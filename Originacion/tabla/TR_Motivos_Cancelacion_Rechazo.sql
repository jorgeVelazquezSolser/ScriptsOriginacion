USE Originacion

ALTER TABLE dbo.TR_Motivos_Cancelacion_Rechazo
ADD Id_Tipo_Operacion INT NULL
GO

UPDATE canc
	SET canc.Id_Tipo_Operacion=1
FROM dbo.TR_Motivos_Cancelacion_Rechazo AS canc
WHERE canc.Motivo_Cancelacion_Rechazo LIKE 'Cancelar%'

UPDATE rech
	SET rech.Id_Tipo_Operacion=2
FROM dbo.TR_Motivos_Cancelacion_Rechazo AS rech
WHERE rech.Motivo_Cancelacion_Rechazo LIKE 'Rechazar%'

INSERT INTO dbo.TR_Motivos_Cancelacion_Rechazo
	VALUES('10','Rechazar - Captura',2)
INSERT INTO dbo.TR_Motivos_Cancelacion_Rechazo
	VALUES('11','Rechazar - Falta Información',2)
INSERT INTO dbo.TR_Motivos_Cancelacion_Rechazo
	VALUES('12','Rechazar - Errores en el cálculo',2)
	