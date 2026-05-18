USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[ReporteGestPromesas]    Script Date: 02/09/2025 13:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[Proc_EndosoConsultaPagareFirma]
--DECLARE
		 @pagare FLOAT --= 4082181--720161

AS

	SELECT 
		   endoso.Id_Endoso AS IdEndoso
		  ,endoso.Id_Lote_Endoso AS IdLoteEndoso
		  ,endoso.Pagare AS Pagare
		  ,0 AS IdCredi
		  ,endoso.Nombre_Abogado AS  NombreAbogado
		  ,endoso.Rfc AS Curp
		  ,'' AS TelCasa
		  ,endoso.Telefono AS TelCelular
		  ,endoso.Correo AS Correo
		  ,RC.MontoOtorgado AS Monto
		  ,RC.TipoProducto AS Tipo
		  ,endoso.Ubicacion AS RutaArchivo
		  ,endoso.Nombre_Coordinador AS NombreCoordinador
		  ,endoso.Estatus_Autorizacion AS EstatusAutorizacion
		  ,endoso.Cod_ECV_Endoso AS EstatusEndoso
		  ,endoso.Guid
	FROM (
			SELECT 
				 endo.Id_Endoso,endo.Id_Lote_Endoso,endo.Credito,endo.Pagare,tpEn.Nombre AS Tipo_Endoso,endo.Fecha_Registro,endo.Fecha_Aceptacion,endo.Fecha_Termino
				,ecvEn.Descripcion AS Estatus_Autorizacion,abogado.Nombre AS Nombre_Abogado,endo.Id_Abogado,endo.Id_Gestor_Autoriza,endo.Cod_ECV_Endoso
				,usuario.Nombre AS Nombre_Coordinador,endo.Guid
				,abogado.Correo,abogado.Telefono,abogado.Rfc,expe.Ubicacion
			FROM dbo.Endoso AS endo
			INNER JOIN dbo.Lote_Endoso AS lote ON endo.Id_Lote_Endoso=lote.Id_Lote_Endoso
			INNER JOIN dbo.Cat_Abogado AS abogado ON endo.Id_Abogado=abogado.Id_Abogado
			INNER JOIN dbo.Usr_Usuarios AS usuario ON lote.Id_Gestor=usuario.ID_Usuario
			INNER JOIN dbo.TR_Tipo_Endoso AS tpEn ON endo.Cod_Tipo_Endoso=tpEn.Cod_Tipo_Endoso
			INNER JOIN dbo.TR_ECV_Endoso AS ecvEn ON endo.Cod_ECV_Endoso=ecvEn.Cod_ECV_Endoso 
			LEFT JOIN dbo.Expediente_Endoso AS expe ON endo.Id_Endoso=expe.Id_Endoso
			WHERE endo.Cod_ECV_Endoso NOT IN ('03','05')
		) AS endoso 

	INNER JOIN
		(SELECT
				 Prestamo
				,Nombre
				,FechaNacimiento
				,RFC
				,CURP
				,Telefono1
				,TipoProducto
				,MontoOtorgado 
			FROM RptActSdosDiaria 
		)RC ON RC.Prestamo = endoso.credito 

	WHERE 
		endoso.Pagare=@pagare
	ORDER BY endoso.Id_Endoso

--SELECT Prestamo,Nombre,FechaNacimiento,RFC,CURP,Telefono1,TipoProducto,MontoOtorgado 
--FROM RptActSdosDiaria

--SELECT Prestamo,Nombre,MontoOtorgado
--FROM Reporte_cartera

--SELECT ID_Credito,Pagare
--FROM Originacion.dbo.Cr_Credito AS crd

