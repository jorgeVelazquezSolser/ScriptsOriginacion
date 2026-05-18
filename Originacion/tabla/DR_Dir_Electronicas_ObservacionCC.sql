-- ============================================================
-- SCRIPT: DR_Dir_Electronicas_ObservacionCC
-- Fecha: 2026-05-15
-- Autor: JorgeVelazquez
-- Descripción: Agrega columna Observacion_CallCenter a DR_Dir_Electronicas
--              y DR_Dir_Electronicas_Bitacora.
-- ============================================================

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE Name = N'Observacion_CallCenter'
      AND Object_ID = OBJECT_ID(N'DR_Dir_Electronicas')
)
BEGIN
    ALTER TABLE DR_Dir_Electronicas
    ADD Observacion_CallCenter NVARCHAR(500) NULL;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE Name = N'Observacion_CallCenter'
      AND Object_ID = OBJECT_ID(N'DR_Dir_Electronicas_Bitacora')
)
BEGIN
    ALTER TABLE DR_Dir_Electronicas_Bitacora
    ADD Observacion_CallCenter NVARCHAR(500) NULL;
END
GO
