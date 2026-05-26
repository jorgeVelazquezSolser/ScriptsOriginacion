USE Cobranza
GO

IF NOT EXISTS (
    SELECT 1 FROM dbo.[Cat_TipoReporte] WHERE Pk_ID_Tip_Reportes = 19
)
BEGIN
    INSERT INTO dbo.[Cat_TipoReporte] (Pk_ID_Tip_Reportes, Descripcion)
    VALUES (19, 'Cartera Asignada Extendida Moratorios');
END
GO

IF NOT EXISTS (
    SELECT 1 FROM dbo.[Cat_TipoReporte] WHERE Pk_ID_Tip_Reportes = 20
)
BEGIN
    INSERT INTO dbo.[Cat_TipoReporte] (Pk_ID_Tip_Reportes, Descripcion)
    VALUES (20, 'Cartera Asignada Moratorios');
END
GO
