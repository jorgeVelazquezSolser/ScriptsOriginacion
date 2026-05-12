USE Originacion

IF NOT EXISTS (
    SELECT 1
    FROM sys.columns
    WHERE Name = 'Id_Tipo_Empleado_Cotizacion'
      AND Object_ID = Object_ID('[dbo].[Pers_Empleo_Bitacora]')
)
BEGIN
    ALTER TABLE [dbo].[Pers_Empleo_Bitacora]
    ADD [Id_Tipo_Empleado_Cotizacion] CHAR(2) NULL;
END
GO
