USE Originacion

CREATE TABLE cms_TR_Alcance_Origen_Credito
(
	Cod_Alcance_Comision CHAR(2),
	Codigo_Origen_Cotizacion CHAR(2)
)

GO
-- Índice para Cod_Alcance_Comision
CREATE INDEX IX_TR_Alcance_Origen_Credito_Cod_Alcance_Comision
ON cms_TR_Alcance_Origen_Credito (Cod_Alcance_Comision);

GO	

-- Índice para Codigo_Origen_Cotizacion
CREATE INDEX IX_TR_Alcance_Origen_Credito_Codigo_Origen_Cotizacion
ON cms_TR_Alcance_Origen_Credito (Codigo_Origen_Cotizacion);
GO



INSERT INTO cms_TR_Alcance_Origen_Credito (Cod_Alcance_Comision,Codigo_Origen_Cotizacion)
SELECT distinct Cod_Alcance_Comision,01
FROM  cms_TR_Alcance_Comisiones ORDER BY Cod_Alcance_Comision
GO

INSERT INTO cms_TR_Alcance_Origen_Credito (Cod_Alcance_Comision,Codigo_Origen_Cotizacion)
SELECT distinct Cod_Alcance_Comision,02
FROM  cms_TR_Alcance_Comisiones ORDER BY Cod_Alcance_Comision
GO

INSERT INTO  cms_TR_Alcance_Origen_Credito(Cod_Alcance_Comision, Codigo_Origen_Cotizacion)
Values('05',3);

GO 
