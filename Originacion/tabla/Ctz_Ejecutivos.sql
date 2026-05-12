USE Originacion

-- Crear tabla si no existe
IF OBJECT_ID('dbo.Ctz_Ejecutivos', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Ctz_Ejecutivos(
        Id_Cotizacion_Ejecutivo INT IDENTITY(1,1) PRIMARY KEY,
        Id_Cotizacion INT,
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
    WHERE name = 'UX_Ctz_Ejecutivos_Cotizacion_Ejecutivo'
      AND object_id = OBJECT_ID('dbo.Ctz_Ejecutivos')
)
BEGIN
    CREATE UNIQUE INDEX UX_Ctz_Ejecutivos_Cotizacion_Ejecutivo
    ON dbo.Ctz_Ejecutivos(Id_Cotizacion, Id_Ejecutivo_Ventas);
END
GO
