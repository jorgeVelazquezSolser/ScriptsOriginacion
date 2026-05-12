-- ============================================================
-- SCRIPT: 01_SP_NEW_proc_Orgn_CheckList_Busca_Cerrado_x_Persona
-- Versión: v1_CallCenter_Recotizacion
-- Fecha: 2026-05-11
-- Autor: JorgeVelazquez
-- Descripción: SP NUEVO. Busca si una persona tiene alguna solicitud
--              anterior con validación de Call Center cerrada positivamente
--              (Resultado = 'S'). Se usa al migrar una recotización para
--              saber si se deben replicar los registros de CC.
-- Tablas afectadas: CR_Credito (lectura), CR_Credito_CheckList_Resumen (lectura)
-- ============================================================

IF OBJECT_ID('proc_Orgn_CheckList_Busca_Cerrado_x_Persona', 'P') IS NOT NULL
    DROP PROCEDURE proc_Orgn_CheckList_Busca_Cerrado_x_Persona;
GO

CREATE PROCEDURE proc_Orgn_CheckList_Busca_Cerrado_x_Persona
    @ID_Persona INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP 1
        c.ID_Credito,
        r.Resultado,
        r.Fecha_Fin,
        r.Notas
    FROM CR_Credito c
    INNER JOIN CR_Credito_CheckList_Resumen r
        ON r.Id_Credito = c.ID_Credito
    WHERE c.ID_PERSONA = @ID_Persona
      AND r.Resultado  = 'S'
    ORDER BY r.Fecha_Fin DESC;

END
GO

