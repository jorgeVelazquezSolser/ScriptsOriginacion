-- ============================================================
-- SCRIPT: proc_Orgn_Dir_Electronica_ObservacionCC_Update
-- Fecha: 2026-05-15
-- Autor: JorgeVelazquez
-- Descripción: SP NUEVO. Actualiza únicamente el campo Observacion_CallCenter
--              de un registro existente en DR_Dir_Electronicas.
--              Uso exclusivo de perfiles Call Center (17 y 18).
--              No modifica ningún otro campo del registro.
-- Tablas afectadas: DR_Dir_Electronicas (UPDATE)
-- ============================================================

IF OBJECT_ID('proc_Orgn_Dir_Electronica_ObservacionCC_Update', 'P') IS NOT NULL
    DROP PROCEDURE proc_Orgn_Dir_Electronica_ObservacionCC_Update;
GO

CREATE PROCEDURE proc_Orgn_Dir_Electronica_ObservacionCC_Update
    @Id_Direccion_Electronica INT,
    @Observacion_CallCenter   NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE DR_Dir_Electronicas
    SET Observacion_CallCenter = @Observacion_CallCenter
    WHERE Id_Direccion_Electronica = @Id_Direccion_Electronica;

    SELECT @Id_Direccion_Electronica AS Id_Direccion_Electronica;
END
GO


