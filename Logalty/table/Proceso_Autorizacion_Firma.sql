USE LogaltyFirmaDigital_Copia

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
