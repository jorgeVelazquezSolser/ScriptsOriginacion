USE Cobranza

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE dbo.TR_Tipo_Endoso (
	Cod_Tipo_Endoso CHAR(2) PRIMARY KEY,
	Nombre VARCHAR(20) NOT NULL,
	Descripcion VARCHAR(50) NOT NULL
) ON [PRIMARY]

--CREATE TABLE dbo.TR_Tipo_Documento (
--	Cod_Tipo_Documento INT PRIMARY KEY,
--	Nombre VARCHAR(20) NOT NULL,
--	Descripcion VARCHAR(50) NOT NULL
--) ON [PRIMARY]

CREATE TABLE dbo.TR_ECV_Endoso (
	Cod_ECV_Endoso CHAR(2) PRIMARY KEY,
	Descripcion VARCHAR(50) NOT NULL
) ON [PRIMARY]

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

CREATE TABLE dbo.Lote_Endoso (
	Id_Lote_Endoso INT PRIMARY KEY,
	Fecha_Registro DATETIME DEFAULT GETDATE(),
	Id_Gestor INT NOT NULL
) ON [PRIMARY]

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

CREATE TABLE dbo.Expediente_Endoso (
	Id_Expediente_Endoso INT PRIMARY KEY,
	Id_Endoso INT NOT NULL,
	Nombre_Documento VARCHAR(100) NOT NULL,
	Ubicacion VARCHAR(MAX) NOT NULL,
	--CONSTRAINT FK_Expediente_Endoso_Endoso FOREIGN KEY (Id_Endoso)
 --   REFERENCES Endoso (Id_Endoso),
) ON [PRIMARY]

ALTER TABLE Temp_Endoso
ALTER COLUMN Pagare FLOAT

ALTER TABLE Temp_Endoso
ALTER COLUMN Credito FLOAT

ALTER TABLE Endoso
ALTER COLUMN Pagare FLOAT

ALTER TABLE Endoso
ALTER COLUMN Credito FLOAT

ALTER TABLE Endoso
ADD Guid VARCHAR(100)

ALTER TABLE Endoso
ADD  Id_Usuario_Anula INT NULL

ALTER TABLE dbo.Cat_Despacho
ADD Fecha_Modificacion DATETIME DEFAULT GETDATE(),
	Id_Usuario_Modificacion INT NULL

ALTER TABLE dbo.Cat_Abogado
ADD Fecha_Modificacion DATETIME DEFAULT GETDATE(),
	Id_Usuario_Modificacion INT NULL

INSERT INTO dbo.TR_Secuencias VALUES(2,'Despacho','Id Despacho',30)
INSERT INTO dbo.TR_Secuencias VALUES(3,'Abogado','Id Abogado',30)
INSERT INTO dbo.TR_Secuencias VALUES(4,'Lote','Id Lote Endoso',0)
INSERT INTO dbo.TR_Secuencias VALUES(5,'Endoso','Id Endoso',0)
INSERT INTO dbo.TR_Secuencias VALUES(6,'Tmp_Endoso','Id Lote Endoso',0)
INSERT INTO dbo.TR_Secuencias VALUES(7,'Expediente_Endoso','Id_Expediente_Endoso',0)

INSERT INTO dbo.Tr_Parametros_Generales VALUES(3,'CorreoValidacionEndoso','hernando.guerrero@solsersistem.net','Lista de correos para notificar al validador',0)
INSERT INTO dbo.Tr_Parametros_Generales VALUES(4,'CorreoAutorizacionEndoso','hernando.guerrero@solsersistem.net','Lista de correos para notificar al autorizador',0)
INSERT INTO dbo.Tr_Parametros_Generales VALUES(5,'CorreoConfirmacionEndoso','hernando.guerrero@solsersistem.net','Lista de correos para notificar que fue autorizado el endoso',0)
INSERT INTO dbo.Tr_Parametros_Generales VALUES(6,'DocumentosEndosoMostrar','Pagare,Contrato','Muestra la lista de Documentos permitidos a mostrar',0)

INSERT INTO dbo.TR_Tipo_Endoso VALUES('01','Procuración','En Procuración')
INSERT INTO dbo.TR_Tipo_Endoso VALUES('02','Propiedad','En Propiedad')

INSERT INTO dbo.TR_ECV_Endoso VALUES('00','Presolicitud')
INSERT INTO dbo.TR_ECV_Endoso VALUES('01','Solicitud')
INSERT INTO dbo.TR_ECV_Endoso VALUES('02','Autorización')
INSERT INTO dbo.TR_ECV_Endoso VALUES('03','Rechazo')
INSERT INTO dbo.TR_ECV_Endoso VALUES('04','Activo')
INSERT INTO dbo.TR_ECV_Endoso VALUES('05','Terminado')

--INSERT INTO dbo.TR_Tipo_Documento VALUES(1,'Certificado','Certificado de la operación')
--INSERT INTO dbo.TR_Tipo_Documento VALUES(2,'NOM 151','NOM 151')
--INSERT INTO dbo.TR_Tipo_Documento VALUES(3,'Pagare','Pagare de Crédito para endosar')
--INSERT INTO dbo.TR_Tipo_Documento VALUES(4,'Contrato','Contrato de Crédito para endosar')

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


UPDATE dbo.TR_ECV_Endoso SET Descripcion='Por Autorizar' WHERE Cod_ECV_Endoso='02'
