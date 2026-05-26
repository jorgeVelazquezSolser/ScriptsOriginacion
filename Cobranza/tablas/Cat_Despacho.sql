USE Cobranza

CREATE TABLE dbo.Cat_Despacho (
	Id_Despacho INT PRIMARY KEY,
	Id_Zona INT NOT NULL,
	Nombre VARCHAR(100) NOT NULL,
	Tipo_Persona CHAR(1) NOT NULL,
	Fecha_Registro DATETIME DEFAULT GETDATE(),
	Id_Usuario_Registra INT NOT NULL,
	Cod_ECV_Despacho CHAR(2) DEFAULT '01',
	CONSTRAINT CK_Tipo_Persona_FM CHECK (Tipo_Persona IN ('F', 'M'))
) ON [PRIMARY]

ALTER TABLE dbo.Cat_Despacho
ADD Fecha_Modificacion DATETIME DEFAULT GETDATE(),
	Id_Usuario_Modificacion INT NULL

INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(1 ,2 ,'AGUILAR GUILLEN RICARDO','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(2 ,2 ,'ANA KARINA SANCHEZ ARMENTA','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(3 ,2 ,'CAFLO CONSULTORES JURIDICOS S.C.','M',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(4 ,1 ,'CADMUS LEGAL SERVICES S DE RL DE CV','M',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(5 ,2 ,'COMPRO TU CARTERA VENCIDA S.C.','M',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(6 ,2 ,'FRIAS MILAN JUAN GABRIEL','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(7 ,2 ,'DAMIAN ALEJANDRO ALDAZ VAZQUEZ','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(8 ,3 ,'GONZALEZ GUZMAN ANAYELI','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(9 ,2 ,'DAVILA TOSCANO SANDRA','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(10,2 ,'DELGADO MENDOZA RICARDO','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(11,1 ,'INFANTE CERVANTES DAVID','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(12,2 ,'JESUS VALLES VERDIN','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(13,2 ,'JIMENEZ ALVARADO SALVADOR','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(14,2 ,'DIAZ DEVORA MARIO AARON','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(15,2 ,'GOMEZ VILLEGAS JOSE LUIS','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(16,2 ,'SANDOVAL SILVA MAGALY LOURDES','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(17,1 ,'SERVICIOS INTEGRALES DE GESTIÓN ACTUALIZADA S.C.','M',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(18,3 ,'GONZALEZ GONZALEZ JULIO','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(19,3 ,'TRUJILLO REYES LAURA FABIOLA','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(20,3 ,'YESENIA MARTINEZ CASTILLO','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(21,2 ,'GONZALEZ HERNANDEZ EDGAR SALVADOR','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(22,2 ,'HERNANDEZ TINAJERO MAGDIEL','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(23,2 ,'HUMBERTO REYES HERNANDEZ','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(24,3 ,'HURTADO Y ASESORES ESTRATEGICOS SOCIEDAD CIVIL','M',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(25,2 ,'ICCE  CORPORATIVO INNOVACION Y CALIDAD EN COBRANZA ESTRATEGICA','M',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(26,2 ,'LEGIS ACCION JURIDICA Y ADMINISTRATIVA GUEVARA Y ASOCIADOS','M',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(27,1 ,'MILLAN PACHECO URIEL','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(28,2 ,'NELLY OYUKY SALAZAR OROZCO','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(29,2 ,'RIBEMI ASOCIADOS, S.A. DE C.V.','M',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(30,2 ,'SOTO CARDONA ISRAEL','F',126)
INSERT INTO dbo.Cat_Despacho (Id_Despacho,Id_Zona,Nombre,Tipo_Persona,Id_Usuario_Registra) VALUES(31,1,'IRVING GUERRERO','F',126)
