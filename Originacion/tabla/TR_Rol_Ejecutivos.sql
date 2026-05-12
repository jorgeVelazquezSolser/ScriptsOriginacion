USE Originacion

IF OBJECT_ID('dbo.TR_Rol_Ejecutivos', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.TR_Rol_Ejecutivos(
        Cod_Rol_Ejecutivo NVARCHAR(50) PRIMARY KEY,
        Descripcion NVARCHAR(255),
        Fecha_Registro DATETIME DEFAULT(GETDATE()),
        Cod_Estatus NVARCHAR(2)
    );
END
GO

-- Registro 01
IF NOT EXISTS (
    SELECT 1 
    FROM dbo.TR_Rol_Ejecutivos 
    WHERE Cod_Rol_Ejecutivo = '01'
)
BEGIN
    INSERT INTO dbo.TR_Rol_Ejecutivos (Cod_Rol_Ejecutivo, Descripcion, Cod_Estatus)
    VALUES ('01', 'Ejecutivo Comercial', '01');
END

-- Registro 02
IF NOT EXISTS (
    SELECT 1 
    FROM dbo.TR_Rol_Ejecutivos 
    WHERE Cod_Rol_Ejecutivo = '02'
)
BEGIN
    INSERT INTO dbo.TR_Rol_Ejecutivos (Cod_Rol_Ejecutivo, Descripcion, Cod_Estatus)
    VALUES ('02', 'Ejecutivo Firmante', '01');
END

GO

IF NOT EXISTS (
    SELECT 1 
    FROM dbo.TR_Rol_Ejecutivos 
    WHERE Cod_Rol_Ejecutivo = '03'
)
BEGIN
    INSERT INTO dbo.TR_Rol_Ejecutivos (Cod_Rol_Ejecutivo, Descripcion, Cod_Estatus)
    VALUES ('03', 'Asesor de Ventas o Comisionista', '01');
END

GO
