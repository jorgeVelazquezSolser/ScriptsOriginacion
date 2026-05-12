USE PortalCliente

CREATE TABLE Solicitud_Autorizacion_BC_Intentos
(
	Id_Solicitud_Autorizacion_BC_Intentos BIGINT IDENTITY(1,1) PRIMARY KEY,
	Id_Solicitud_Autorizacion_BC BIGINT FOREIGN KEY REFERENCES Solicitud_Autorizacion_BC(Id_Solicitud_Autorizacion_BC),
	Fecha_Registro DATETIME DEFAULT GETDATE(),
	ID_MedioSMS INT FOREIGN KEY REFERENCES TR_MedioSMS(ID_MedioSMS),
	Estatus_Envio VARCHAR(50) NOT NULL
)
