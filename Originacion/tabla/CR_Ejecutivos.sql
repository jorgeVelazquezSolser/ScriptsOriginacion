USE Originacion

IF OBJECT_ID('dbo.CR_Ejecutivos', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CR_Ejecutivos(
        Id_Credito_Ejecutivo INT IDENTITY(1,1) PRIMARY KEY,
        Id_Credito INT,
        Id_Ejecutivo_Ventas INT,
        Fecha_Registro DATETIME DEFAULT(GETDATE()),
        Cod_Rol_Ejecutivo NVARCHAR(510)
    );
END
GO

-- Crear índice único si no existe
IF NOT EXISTS (
    SELECT 1 
    FROM sys.indexes 
    WHERE name = 'UX_CR_Ejecutivos_Credito_Ejecutivo'
      AND object_id = OBJECT_ID('dbo.CR_Ejecutivos')
)
BEGIN
    CREATE UNIQUE INDEX UX_CR_Ejecutivos_Credito_Ejecutivo
    ON dbo.CR_Ejecutivos(Id_Credito, Id_Ejecutivo_Ventas);
END
GO