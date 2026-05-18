USE Cobranza

CREATE TABLE dbo.Endoso (
	Id_Endoso INT PRIMARY KEY,
	Id_Lote_Endoso INT NOT NULL,
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
	Cod_ECV_Endoso CHAR(2) DEFAULT '01',
	CONSTRAINT FK_Endoso_Lote_Endoso FOREIGN KEY (Id_Lote_Endoso)
    REFERENCES Lote_Endoso (Id_Lote_Endoso),
	CONSTRAINT FK_Endoso_Cat_Abogado FOREIGN KEY (Id_Abogado)
    REFERENCES Cat_Abogado (Id_Abogado),
	CONSTRAINT FK_Endoso_TR_Tipo_Endoso FOREIGN KEY (Cod_Tipo_Endoso)
    REFERENCES TR_Tipo_Endoso (Cod_Tipo_Endoso),
	CONSTRAINT FK_Endoso_TR_ECV_Endoso FOREIGN KEY (Cod_ECV_Endoso)
    REFERENCES TR_ECV_Endoso (Cod_ECV_Endoso)
) ON [PRIMARY]

ALTER TABLE Endoso
ALTER COLUMN Pagare FLOAT

ALTER TABLE Endoso
ALTER COLUMN Credito FLOAT

ALTER TABLE Endoso
ADD Guid VARCHAR(100)

ALTER TABLE Endoso
ADD  Id_Usuario_Anula INT NULL
