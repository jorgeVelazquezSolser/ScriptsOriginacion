USE Originacion

ALTER TABLE dbo.CR_Cancelacion_Rechazo
ADD Id_Tipo_Rechazo INT NULL
GO

UPDATE rec
	SET rec.Id_Tipo_Rechazo = 3
FROM dbo.CR_Cancelacion_Rechazo AS rec
WHERE rec.Cod_Motivo_Cancelacion_Rechazo NOT IN ('01','02','03')
