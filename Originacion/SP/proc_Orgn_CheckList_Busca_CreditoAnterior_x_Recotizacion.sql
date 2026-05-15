-- ============================================================
-- SCRIPT: proc_Orgn_CheckList_Busca_CreditoAnterior_x_Recotizacion
-- Versión: v1_CallCenter_Recotizacion
-- Fecha: 2026-05-14
-- Autor: JorgeVelazquez
-- Descripción: SP NUEVO. Dado el ID de la cotización NUEVA (recotización),
--              busca en Ctz_Recotizacion el crédito original asociado
--              (Id_Credito_Original) que tenga validación de Call Center
--              cerrada positivamente (Resultado = 'S').
--              La búsqueda usa Id_Cotizacion_Nueva para garantizar que se
--              enlaza con el crédito EXACTO de esta cadena de recotización,
--              no con cualquier crédito anterior de la persona.
-- Tablas afectadas: Ctz_Recotizacion (lectura), CR_Credito_CheckList_Resumen (lectura)
-- ============================================================

IF OBJECT_ID('proc_Orgn_CheckList_Busca_CreditoAnterior_x_Recotizacion', 'P') IS NOT NULL
    DROP PROCEDURE proc_Orgn_CheckList_Busca_CreditoAnterior_x_Recotizacion;
GO

CREATE PROCEDURE proc_Orgn_CheckList_Busca_CreditoAnterior_x_Recotizacion
    @Id_Cotizacion_Nueva INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Busca via Ctz_Recotizacion.Id_Cotizacion_Nueva (la cotización NUEVA/copia)
    -- para encontrar el crédito original exacto de esta recotización.
    -- Solo retorna fila si ese crédito original tiene CC Resultado = 'S'.
    SELECT TOP 1
        r.Id_Credito_Original AS ID_Credito
    FROM Ctz_Recotizacion r
    INNER JOIN CR_Credito_CheckList_Resumen chk
        ON  chk.Id_Credito = r.Id_Credito_Original
    WHERE r.Id_Cotizacion_Nueva  = @Id_Cotizacion_Nueva
      AND r.Id_Credito_Original  IS NOT NULL
      AND chk.Resultado          = 'S';

END
GO

-- ============================================================
-- VERIFICACIÓN POST-DEPLOY
-- ============================================================
-- SELECT * FROM Ctz_Recotizacion WHERE Id_Cotizacion_Nueva = <id_nueva>
-- EXEC proc_Orgn_CheckList_Busca_CreditoAnterior_x_Recotizacion @Id_Cotizacion_Nueva = <id_nueva>
