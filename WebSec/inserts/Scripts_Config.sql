USE WebSec

-- Agrega Objeto tipo botón
INSERT INTO WebSec.dbo.SegObjetos (IdObjeto,Permiso,IdUsuarioModifico,Creado,Nombre,Descripcion,IdTipoObjeto,IdCategoriaObjeto)
	VALUES(3720, 'Regresar Solicitud ', 1, GETDATE(), 'Regresar Solicitud', 'Se requiere volver para revisar/analisar/Validar',2,1)

-- Agrega Objeto a Perfiles
INSERT INTO WebSec.dbo.SegPerfilesObjetos (IdPerfilPermiso,IdPerfil,IdObjeto,IdUsuarioModifico,Creado)
	VALUES (2052, 5, 3720, 1 , GETDATE())
INSERT INTO WebSec.dbo.SegPerfilesObjetos (IdPerfilPermiso,IdPerfil,IdObjeto,IdUsuarioModifico,Creado)
	VALUES (2053, 20, 3720, 1 , GETDATE())

-- Agrega Objeto en Perfil a las Etapas-Estatus
INSERT INTO WebSec.dbo.SegPerfilesObjetosEtapas VALUES (5, '02', '10', 3720, '01', '01', '001')
INSERT INTO WebSec.dbo.SegPerfilesObjetosEtapas VALUES (5, '04', '10', 3720, '01', '01', '001')
INSERT INTO WebSec.dbo.SegPerfilesObjetosEtapas VALUES (5, '05', '10', 3720, '01', '01', '001')
INSERT INTO WebSec.dbo.SegPerfilesObjetosEtapas VALUES (5, '06', '15', 3720, '01', '01', '001')

INSERT INTO WebSec.dbo.SegPerfilesObjetosEtapas VALUES (20, '02', '10', 3720, '01', '01', '001')
INSERT INTO WebSec.dbo.SegPerfilesObjetosEtapas VALUES (20, '04', '10', 3720, '01', '01', '001')
INSERT INTO WebSec.dbo.SegPerfilesObjetosEtapas VALUES (20, '05', '10', 3720, '01', '01', '001')
INSERT INTO WebSec.dbo.SegPerfilesObjetosEtapas VALUES (20, '06', '15', 3720, '01', '01', '001')

USE Originacion

-- Agrega Acción a seguir
INSERT INTO Originacion.dbo.TR_Cr_Flujos_Acciones
	VALUES(51,'Regresar a AD')
INSERT INTO Originacion.dbo.TR_Cr_Flujos_Acciones
	VALUES(52,'Regresar a AA')
INSERT INTO Originacion.dbo.TR_Cr_Flujos_Acciones
	VALUES(53,'Regresar a IV')
INSERT INTO Originacion.dbo.TR_Cr_Flujos_Acciones
	VALUES(54,'Regresar a IV')

-- Agrega el detalle del flujo
INSERT INTO Originacion.dbo.TR_Cr_Flujo_Detalle 
	VALUES ('001', '02', '10', '51','03','07','proc_Orgn_Flujo_Regresa_Analisis_Doc_Rev', '', 'Regresa Analisis Documental', 136)
INSERT INTO Originacion.dbo.TR_Cr_Flujo_Detalle 
	VALUES ('001', '04', '10', '52','04','08','proc_Orgn_Flujo_Regresa_Analisis_Analisis', '', 'Regresa Analisis', 137)
INSERT INTO Originacion.dbo.TR_Cr_Flujo_Detalle 
	VALUES ('001', '05', '10', '53','06','34','proc_Orgn_Flujo_Regresa_Instrument_Validacion', '', 'Regresa Instrumentación', 138)
INSERT INTO Originacion.dbo.TR_Cr_Flujo_Detalle 
	VALUES ('001', '06', '15', '54','06', '34','proc_Orgn_Flujo_Regresa_Instrument_Validacion', '', 'Regresa Instrumentación', 139)

-- Agrega el control de la acción para el front
INSERT INTO Originacion.dbo.TR_Front_Objeto_Etapas VALUES (120, 3720,3720,'001','03', '10','51','Regresa Analisis Documental-En Revisión')
INSERT INTO Originacion.dbo.TR_Front_Objeto_Etapas VALUES (121, 3720,3720,'001','04', '10','52','Regresa Analisis-En Análisis')
INSERT INTO Originacion.dbo.TR_Front_Objeto_Etapas VALUES (122, 3720,3720,'001','05', '10','53','Regresa Instrumentación-Validación')
INSERT INTO Originacion.dbo.TR_Front_Objeto_Etapas VALUES (123, 3720,3720,'001','06', '15','54','Regresa Instrumentación-Validación')

--SELECT *
--FROM Originacion.dbo.TR_Cr_Flujos_Acciones
--ORDER BY 1 DESC

--SELECT *
--FROM Originacion.dbo.TR_Front_Objeto_Etapas
--ORDER BY 1 DESC


--SELECT *
--FROM Originacion.dbo.TR_Cr_Flujo_Detalle
--ORDER BY Id_Secuencia_Flujo DESC

--SELECT *
--FROM WebSec18.dbo.SegPerfilesObjetos
--ORDER BY 1 DESC

--SELECT *
--FROM WebSec18.dbo.SegObjetos 
--ORDER BY 1 DESC

--SELECT *
--FROM WebSec18.dbo.SegPerfilesObjetosEtapas

