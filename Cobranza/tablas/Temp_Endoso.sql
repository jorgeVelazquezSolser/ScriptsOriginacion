USE Cobranza

CREATE TABLE dbo.Temp_Endoso (
	Id_Lote_Endoso INT NOT NULL,
	Id_Gestor INT NOT NULL,
	Pagare INT NOT NULL,
	Credito INT NOT NULL,
	Cod_Tipo_Endoso CHAR(2) NOT NULL,
	Id_Abogado INT NOT NULL,
	Id_Gestor_Validador INT NULL,
	Id_Gestor_Autoriza INT NULL,
	Fecha_Registro DATETIME DEFAULT GETDATE(),
	Fecha_Validacion DATETIME NULL,
	Fecha_Aceptacion DATETIME NULL,
	Fecha_Notificacion DATETIME NULL,
	Fecha_Firma DATETIME NULL,
	Fecha_Termino DATETIME NULL,
	UUID UNIQUEIDENTIFIER NULL,
	Cod_ECV_Endoso CHAR(2) DEFAULT '00',
) ON [PRIMARY]

ALTER TABLE Temp_Endoso
ALTER COLUMN Pagare FLOAT

ALTER TABLE Temp_Endoso
ALTER COLUMN Credito FLOAT

