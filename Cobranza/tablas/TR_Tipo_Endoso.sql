USE Cobranza

CREATE TABLE dbo.TR_Tipo_Endoso (
	Cod_Tipo_Endoso CHAR(2) PRIMARY KEY,
	Nombre VARCHAR(20) NOT NULL,
	Descripcion VARCHAR(50) NOT NULL
) ON [PRIMARY]

INSERT INTO dbo.TR_Tipo_Endoso VALUES('01','Procuración','En Procuración')
INSERT INTO dbo.TR_Tipo_Endoso VALUES('02','Propiedad','En Propiedad')
