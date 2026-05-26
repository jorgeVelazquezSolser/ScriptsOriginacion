USE Cobranza

CREATE TABLE dbo.Expediente_Endoso (
	Id_Expediente_Endoso INT PRIMARY KEY,
	Id_Endoso INT NOT NULL,
	Nombre_Documento VARCHAR(100) NOT NULL,
	Ubicacion VARCHAR(MAX) NOT NULL,
	--CONSTRAINT FK_Expediente_Endoso_Endoso FOREIGN KEY (Id_Endoso)
 --   REFERENCES Endoso (Id_Endoso),
) ON [PRIMARY]