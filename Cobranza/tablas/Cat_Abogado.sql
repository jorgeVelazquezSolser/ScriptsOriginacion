USE Cobranza

CREATE TABLE dbo.Cat_Abogado (
	Id_Abogado INT PRIMARY KEY,
	Id_Despacho INT NOT NULL,
	Rfc VARCHAR(13) NOT NULL,
	Nombre VARCHAR(100) NOT NULL,
	Correo VARCHAR(100) NOT NULL,
	Telefono VARCHAR(15) NOT NULL,
	Fecha_Registro DATETIME DEFAULT GETDATE(),
	Id_Usuario_Registra INT NOT NULL,
	Cod_ECV_Abogado CHAR(2) DEFAULT '01',
	CONSTRAINT FK_Cat_Abogado_Cat_Despacho FOREIGN KEY (Id_Despacho)
    REFERENCES Cat_Despacho (Id_Despacho)
) ON [PRIMARY]

ALTER TABLE dbo.Cat_Abogado
ADD Fecha_Modificacion DATETIME DEFAULT GETDATE(),
	Id_Usuario_Modificacion INT NULL

INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(1 ,1 ,'UGR760611318','AGUILAR GUILLEN RICARDO ','ricardoag611@hotmail.com ','6621677290',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(2 ,2 ,'SAAA880927JH8','ANA KARINA SANCHEZ ARMENTA','servicios.juridicos24@hotmail.com','6441264774',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(3 ,3 ,'CCJ170725K86','EFREN CAZAREZ OLVERA',' pamelatwoo@hotmail.com','8712431453',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(4 ,4 ,'CLS221219UU2','JORGE DOMINGUEZ VARGAS','jdominguez@cadmuslegal.com','7771914558',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(5 ,5 ,'CTC1701236K6','ERICK SOLANO IBARRA','eransoib@hotmail.com','6142881597',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(6 ,6 ,'FIMJ7402278C9','FRIAS MILAN JUAN GABRIEL ','jgfm_dgo@hotmail.com ','6181115100',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(7 ,7 ,'AAVD860311L12','DAMIAN ALEJANDRO ALDAZ VAZQUEZ','gerenciaoperativa@oropezayasociados.com','8711362157',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(8 ,8 ,'GOGA881108GE4','GONZALEZ GUZMAN ANAYELI','mopi776@hotmail.com','9585857647',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(9 ,9 ,'DATS7009064X3','DAVILA TOSCANO SANDRA','sdavila@miksabc.com','6461514228',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(10,10,'DEMR970401LB2','RICARDO DELGADO MENDOZA','lic.ricardo970401@outlook.com','4623093691',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(11,11,'IACD820218KNA','DAVID INFANTE CERVANTES','david.infante@apreciaconnect.com.mx','7292678929',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(12,12,'VAVJ700930RS1','JESUS VALLES VERDIN','claudiagarciaromo@yahoo.com.mx','6181320651',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(13,13,'JIAS800614QEA','SALVADOR  JIMENEZ ALVARADO','juridico_yasociados@hotmail.com','3112640856',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(14,14,'DIDM960104UB9','DIAZ DEVORA MARIO AARON ','galzacatecas@gmail.com','6711074313',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(15,15,'GOVL920221TJA','GOMEZ VILLEGAS JOSE LUIS','lic.gomezvillegas@gmail.com','4431825264',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(16,16,'SASL7604139C3','SANDOVAL SILVA MAGALY LOURDES','lomasasi@gmail.com','4421783260',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(17,17,'SIG090205CK8','JOSE MANUEL SIERRA MARMOLEJO','sbecerra@sigamx.com','771 1000730',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(18,18,'GOGJ691106RR0','GONZALEZ GONZALEZ JULIO','consultores_asociados@live.com','2293061639',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(19,19,'TURL800123M9A','LAURA FABIOLA TRUJILLO REYES','laura.trujillo@apreciaconnect.com.mx','9531547134',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(20,20,'MACY810303EN3','YESENIA MARTINEZ CASTILLO','yesdieguito@gmail.com','2741419602',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(21,21,'GOHE731027QVA','GONZALEZ HERNANDEZ EDGAR SALVADOR ','cjesgh@gmail.com','3112640856',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(22,22,'HETM760918CN9 ','MAGDIEL HERNANDEZ TINAJERO','alternativaslegales4c@gmail.com','4421069577',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(23,23,'REHH8311081S9','HUMBERTO REYES HERNANDEZ','hrh_8308@hotmail.com',' 618 231 95 72',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(24,24,'HAE150521F13','HURTADO SOSA CARLOS HUMBERTO','ilcaconsultor@gmail.com','9811381863',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(25,25,'CIC180814IF8','SERGIO ANDRADE VILLA',' avazquez@corporativoicce.com.mx','3323398152',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(26,26,'LAJ1604228Y6','DAVID GUEVARA CARDOSO',' dguevara@legissa.com.mx','8183620691',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(27,27,'MIPU771128TU6','MILLAN PACHECO URIEL','direccionsle1@gmail.com','7775183764',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(28,28,'SAON7901279P5','NELLY OYUKY SALAZAR OROZCO','nelly2701@yahoo.com','4931140420',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(29,29,'RAS170328DM5','JESUS ARMANDO RIOS TANGUMA,','cobranza@ribemi.com','8126568578',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(30,30,'SOCI8010191T5','SOTO CARDONA ISRAEL','ardjlega@hotmail.com','4495831028',126)
INSERT INTO dbo.Cat_Abogado (Id_Abogado,Id_Despacho,Rfc,Nombre,Correo,Telefono,Id_Usuario_Registra) VALUES(31,31,'GUGH820604QT3','IRVING GUERRERO','hernando.guerrero@solsersistem.net','4421496701',126)
