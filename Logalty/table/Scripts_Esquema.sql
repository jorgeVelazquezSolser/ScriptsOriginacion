USE LogaltyFirmaDigital_Copia

ALTER TABLE [dbo].[ProcesoEnvioFirma]
ADD Tipo_Transaccion VARCHAR(50)

-- EN-00000000-0000-0000-0000-000000000000
-- CR-00000000-0000-0000-0000-000000000000
-- CN-00000000-0000-0000-0000-000000000000

CREATE TABLE dbo.Cat_Representante (
	Id_Representante INT PRIMARY KEY,
	Primer_Nombre VARCHAR(100) NOT NULL,
	Segundo_Nombre VARCHAR(100) NOT NULL,
	Primer_Apellido VARCHAR(100) NOT NULL,
	Segundo_Apellido VARCHAR(100) NOT NULL,
	Curp VARCHAR(20) NOT NULL,
	Uuid UNIQUEIDENTIFIER NOT NULL,
	Orden INT NOT NULL DEFAULT 0,
	Fecha_Registro DATETIME DEFAULT GETDATE(),
	Id_Usuario_Registra INT NOT NULL,
	Fecha_Modificacion DATETIME NULL,
	Id_Usuario_Modifica INT NULL,
	Cod_ECV_Representante CHAR(2) DEFAULT '01'
) ON [PRIMARY]

CREATE TABLE dbo.Proceso_Autorizacion_Firma (
	Id_Proceso_Autorizacion_Firma INT PRIMARY KEY IDENTITY(1,1),
	Guid VARCHAR(50) NOT NULL,
	ExternalId VARCHAR(20) NOT NULL,
	LegalId VARCHAR(100) NOT NULL DEFAULT 0,
	RuleId INT NOT NULL DEFAULT 0,
	Fecha_Registro DATETIME DEFAULT GETDATE(),
	Operacion VARCHAR(50) NULL,
	SignResult VARCHAR(20) NULL,
	DateSigned VARCHAR(50) NULL,
	ResultCode INT NULL,
	Xml_Request VARCHAR(MAX) NULL,
	Xml_Response VARCHAR(MAX) NULL
) ON [PRIMARY]


INSERT INTO dbo.Cat_Representante 
	(Id_Representante,Primer_Nombre,Segundo_Nombre,Primer_Apellido,Segundo_Apellido,Curp,Uuid,Orden,Id_Usuario_Registra,Cod_ECV_Representante)
	VALUES(1,'SUSANA','','FUERTE','DELGADO','FUDS820604AB3',NEWID(),1,28,'01')
INSERT INTO dbo.Cat_Representante 
	(Id_Representante,Primer_Nombre,Segundo_Nombre,Primer_Apellido,Segundo_Apellido,Curp,Uuid,Orden,Id_Usuario_Registra,Cod_ECV_Representante)
	VALUES(2,'HERNANDO','IRVING','GUERRERO','GOMEZ','GUGH820604HQTRMR07',NEWID(),2,28,'01')
