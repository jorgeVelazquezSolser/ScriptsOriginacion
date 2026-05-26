USE Cobranza

CREATE TABLE dbo.TR_ECV_Endoso (
	Cod_ECV_Endoso CHAR(2) PRIMARY KEY,
	Descripcion VARCHAR(50) NOT NULL
) ON [PRIMARY]

INSERT INTO dbo.TR_ECV_Endoso VALUES('00','Presolicitud')
INSERT INTO dbo.TR_ECV_Endoso VALUES('01','Solicitud')
INSERT INTO dbo.TR_ECV_Endoso VALUES('02','Por Autorizar')
INSERT INTO dbo.TR_ECV_Endoso VALUES('03','Rechazo')
INSERT INTO dbo.TR_ECV_Endoso VALUES('04','Activo')
INSERT INTO dbo.TR_ECV_Endoso VALUES('05','Terminado')