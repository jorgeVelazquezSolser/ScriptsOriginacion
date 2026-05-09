USE PortalCliente

CREATE TABLE TR_MedioSMS
(
	ID_MedioSMS INT PRIMARY KEY,
	Servicio_SMS VARCHAR(100) NOT NULL,
	URL_Endpoint VARCHAR(500) NOT NULL,
	Usuario VARCHAR(50) NOT NULL,
	Contrasena VARCHAR(50) NOT NULL,
	Servicio VARCHAR(50) NULL,
	Orden_Preferencia INT NOT NULL
)

INSERT INTO TR_MedioSMS VALUES(1,'Gepard','https://gepardapi.com/webresources/Engine/SendMsg','i_Fomapade_CIO','F0m3CIO_@74','638418117128495',2)
INSERT INTO TR_MedioSMS VALUES(2,'nubarium','https://api.nubarium.com/otp/v1/enviar','user1','pass123','',1)
