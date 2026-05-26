USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[ReporteGestPromesas]    Script Date: 02/09/2025 13:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_Endoso_HistorialConsulta]
--DECLARE
		  @pagare FLOAT --= NULL--4082181--720161
		 ,@fechaInicial DATETIME --= '2026-01-06'
		 ,@fechaFinal DATETIME --= '2026-01-08'

AS

	SELECT 
		   endoso.Id_Endoso AS IdEndoso
		  ,endoso.Id_Lote_Endoso AS IdLoteEndoso
		  ,endoso.Pagare AS Pagare
		  ,RC.Nombre AS NombreTitular
		  ,endoso.Nombre_Abogado AS  NombreAbogado
		  ,endoso.Rfc AS Curp
		  ,RC.MontoOtorgado AS Monto
		  ,RC.TipoProducto AS Tipo
		  ,endoso.Nombre_Coordinador AS NombreCoordinador
		  ,endoso.Guid
		  ,CONVERT(VARCHAR,endoso.Fecha_Aceptacion,103) AS FechaAceptacion
		  ,CONVERT(VARCHAR,endoso.Fecha_Termino,103) AS FechaTermino
		  ,endoso.Estatus_Autorizacion AS EstatusAutorizacion
		  ,endoso.Cod_ECV_Endoso AS EstatusEndoso
	FROM (
			SELECT 
				 endo.Id_Endoso,endo.Id_Lote_Endoso,endo.Credito,endo.Pagare,tpEn.Nombre AS Tipo_Endoso,endo.Fecha_Registro,endo.Fecha_Aceptacion,endo.Fecha_Termino
				,ecvEn.Descripcion AS Estatus_Autorizacion
				,CASE WHEN despacho.Nombre=abogado.Nombre THEN abogado.Nombre ELSE CONCAT(despacho.Nombre,'|',abogado.Nombre) END AS Nombre_Abogado
				,endo.Id_Abogado,endo.Id_Gestor_Autoriza,endo.Cod_ECV_Endoso
				,usuario.Nombre AS Nombre_Coordinador,endo.Guid
				,abogado.Correo,abogado.Telefono,abogado.Rfc
			FROM dbo.Endoso AS endo
			INNER JOIN dbo.Lote_Endoso AS lote ON endo.Id_Lote_Endoso=lote.Id_Lote_Endoso
			INNER JOIN dbo.Cat_Abogado AS abogado ON endo.Id_Abogado=abogado.Id_Abogado
			INNER JOIN dbo.Cat_Despacho AS despacho ON abogado.Id_Despacho=despacho.Id_Despacho
			INNER JOIN dbo.Usr_Usuarios AS usuario ON lote.Id_Gestor=usuario.ID_Usuario
			INNER JOIN dbo.TR_Tipo_Endoso AS tpEn ON endo.Cod_Tipo_Endoso=tpEn.Cod_Tipo_Endoso
			INNER JOIN dbo.TR_ECV_Endoso AS ecvEn ON endo.Cod_ECV_Endoso=ecvEn.Cod_ECV_Endoso 
			WHERE endo.Cod_ECV_Endoso IN ('04','05')
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
		(@pagare IS NULL OR endoso.Pagare=@pagare)
		AND (@fechaInicial IS NULL OR CAST(endoso.Fecha_Aceptacion AS DATE)>=@fechaInicial)
		AND (@fechaFinal IS NULL OR CAST(endoso.Fecha_Aceptacion AS DATE)<=@fechaFinal)
	ORDER BY endoso.Id_Endoso DESC

