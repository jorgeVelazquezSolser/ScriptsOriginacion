USE Cobranza

CREATE TABLE dbo.Lote_Endoso (
	Id_Lote_Endoso INT PRIMARY KEY,
	Fecha_Registro DATETIME DEFAULT GETDATE(),
	Id_Gestor INT NOT NULL
) ON [PRIMARY]
