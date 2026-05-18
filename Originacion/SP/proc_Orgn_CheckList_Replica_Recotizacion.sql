-- ============================================================
-- SCRIPT: proc_Orgn_CheckList_Replica_Recotizacion
-- Versión: v4_CallCenter_Recotizacion
-- Fecha: 2026-05-15
-- Autor: JorgeVelazquez
-- Descripción: SP NUEVO. Cuando se recotiza y se genera una nueva solicitud,
--              replica los registros de validación de Call Center de la
--              solicitud anterior (con Resultado='S') hacia la nueva solicitud.
--              Hace dos operaciones:
--              1. Actualiza CR_Credito_Checklist del nuevo crédito con los
--                 resultados de verificación del crédito anterior.
--              2. Inserta/actualiza CR_Credito_CheckList_Resumen del nuevo
--                 crédito copiando Fecha_Fin y Resultado del anterior.
--                 Guarda ID_Credito_Origen = @ID_Credito_Anterior para
--                 identificar que el cierre fue replicado (no propio).
-- Tablas afectadas:
--   CR_Credito_Checklist         (UPDATE)
--   CR_Credito_CheckList_Resumen (INSERT / UPDATE)
-- ============================================================

CREATE OR  ALTER PROCEDURE proc_Orgn_CheckList_Replica_Recotizacion
    @ID_Credito_Nuevo    INT,
    @ID_Credito_Anterior INT,
    @_id  SMALLINT       OUTPUT,
    @_msg VARCHAR(2048)  OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SET @_id  = 0;
    SET @_msg = '';

    IF NOT EXISTS (
        SELECT 1
        FROM CR_Credito_CheckList_Resumen
        WHERE Id_Credito = @ID_Credito_Anterior
          AND Resultado  = 'S'
    )
    BEGIN
        SET @_id  = 0;
        SET @_msg = 'El crédito anterior no tiene cierre de Call Center positivo (Resultado=S). No se replica.';
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;
        
        UPDATE cc_nuevo
        SET
            cc_nuevo.Cod_Resultado_Verificacion  = cc_ant.Cod_Resultado_Verificacion,
            cc_nuevo.Cod_ECV_Credito_Checklist   = cc_ant.Cod_ECV_Credito_Checklist,
            cc_nuevo.Notas                       = cc_ant.Notas,
            cc_nuevo.ID_Usuario_Reviso           = cc_ant.ID_Usuario_Reviso,
            cc_nuevo.Cod_Etapa                   = cc_ant.Cod_Etapa,
            cc_nuevo.Cod_Estatus                 = cc_ant.Cod_Estatus,
            cc_nuevo.Fecha_Actualizacion         = GETDATE()
        FROM CR_Credito_Checklist cc_nuevo
        INNER JOIN CR_Credito_Checklist cc_ant
            ON  cc_ant.ID_Checklist = cc_nuevo.ID_Checklist
            AND cc_ant.ID_Credito   = @ID_Credito_Anterior
        WHERE cc_nuevo.ID_Credito   = @ID_Credito_Nuevo;

        -- --------------------------------------------------------
        -- 2. Replicar el resumen de Call Center
        --    Si ya existe registro para el nuevo crédito → UPDATE
        --    Si no existe → INSERT
        --    En ambos casos se guarda ID_Credito_Origen para que
        --    el SP de lista muestre el resultado anterior mientras
        --    CC no confirme el nuevo crédito (Resultado IS NULL).
        -- --------------------------------------------------------
        IF EXISTS (
            SELECT 1
            FROM CR_Credito_CheckList_Resumen
            WHERE Id_Credito = @ID_Credito_Nuevo
        )
        BEGIN
            UPDATE dest
            SET
                dest.Id_Usuario_Asignado = src.Id_Usuario_Asignado,
                dest.Fecha_Inicio        = src.Fecha_Inicio,
                dest.Fecha_Fin           = src.Fecha_Fin,
                dest.Resultado           = src.Resultado,
                dest.Fecha_Asignacion    = src.Fecha_Asignacion,
                dest.Notas               = src.Notas,
                dest.ID_Credito_Origen   = @ID_Credito_Anterior
            FROM CR_Credito_CheckList_Resumen dest
            INNER JOIN CR_Credito_CheckList_Resumen src
                ON src.Id_Credito = @ID_Credito_Anterior
            WHERE dest.Id_Credito = @ID_Credito_Nuevo
              AND src.Resultado   = 'S';
        END
        ELSE
        BEGIN
            INSERT INTO CR_Credito_CheckList_Resumen
                (Id_Credito, Id_Usuario_Asignado, Fecha_Inicio, Fecha_Fin,
                 Resultado, Fecha_Asignacion, Notas, ID_Credito_Origen)
            SELECT
                @ID_Credito_Nuevo,
                Id_Usuario_Asignado,
                Fecha_Inicio,
                Fecha_Fin,
                Resultado,
                Fecha_Asignacion,
                Notas,
                @ID_Credito_Anterior
            FROM CR_Credito_CheckList_Resumen
            WHERE Id_Credito = @ID_Credito_Anterior
              AND Resultado  = 'S';
        END

        COMMIT TRANSACTION;

        SET @_id  = 1;
        SET @_msg = 'OK';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @_id  = -1;
        SET @_msg = ERROR_MESSAGE();
    END CATCH

END
GO

