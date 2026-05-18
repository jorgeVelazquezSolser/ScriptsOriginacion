-- ============================================================
-- SCRIPT: CR_Credito_CheckList_Resumen — Agrega columna ID_Credito_Origen
-- Versión: v2_CallCenter_Recotizacion
-- Fecha: 2026-05-14
-- Autor: JorgeVelazquez
-- Descripción: Agrega la columna ID_Credito_Origen (INT NULL) a la tabla
--              CR_Credito_CheckList_Resumen. 
-- ============================================================

USE [Originacion];
GO

IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME   = 'CR_Credito_CheckList_Resumen'
      AND COLUMN_NAME  = 'ID_Credito_Origen'
)
BEGIN
    ALTER TABLE [dbo].[CR_Credito_CheckList_Resumen]
        ADD [ID_Credito_Origen] INT NULL;

    PRINT 'OK - Columna ID_Credito_Origen agregada a CR_Credito_CheckList_Resumen';
END
ELSE
BEGIN
    PRINT 'INFO - Columna ID_Credito_Origen ya existe en CR_Credito_CheckList_Resumen. Sin cambios.';
END
GO
