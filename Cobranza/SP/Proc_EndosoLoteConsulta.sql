USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[ReporteGestPromesas]    Script Date: 02/09/2025 13:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_EndosoLoteConsulta]
--DECLARE
		 @id_LoteEndoso INT --= 72
		,@Ecv_Endoso CHAR(2) --= NULL

AS

	SELECT 
		   endoso.Id_Endoso AS IdEndoso
		  ,endoso.Id_Lote_Endoso AS IdLoteEndoso
		  ,endoso.Pagare AS Pagare
		  ,RC.Nombre AS  NombreTitular
		  ,endoso.Nombre_Coordinador AS NombreCoordinador
		  ,endoso.Estatus_Autorizacion AS EstatusAutorizacion
		  ,endoso.Cod_ECV_Endoso AS EstatusEndoso
	FROM (
			SELECT 
				 endo.Id_Endoso,endo.Id_Lote_Endoso,endo.Credito,endo.Pagare,tpEn.Nombre AS Tipo_Endoso,endo.Fecha_Registro,endo.Fecha_Aceptacion,endo.Fecha_Termino
				,ecvEn.Descripcion AS Estatus_Autorizacion,abogado.Nombre AS Nombre_Abogado,endo.Id_Abogado,endo.Id_Gestor_Autoriza,endo.Cod_ECV_Endoso
				,usuario.Nombre AS Nombre_Coordinador
			FROM dbo.Endoso AS endo
			INNER JOIN dbo.Lote_Endoso AS lote ON endo.Id_Lote_Endoso=lote.Id_Lote_Endoso
			INNER JOIN dbo.Cat_Abogado AS abogado ON endo.Id_Abogado=abogado.Id_Abogado
			INNER JOIN dbo.Usr_Usuarios AS usuario ON lote.Id_Gestor=usuario.ID_Usuario
			INNER JOIN dbo.TR_Tipo_Endoso AS tpEn ON endo.Cod_Tipo_Endoso=tpEn.Cod_Tipo_Endoso
			INNER JOIN dbo.TR_ECV_Endoso AS ecvEn ON endo.Cod_ECV_Endoso=ecvEn.Cod_ECV_Endoso 
		) AS endoso 

	INNER JOIN
		(SELECT
				[Prestamo]
				,[Nombre]
			FROM [Reporte_cartera] 
			GROUP BY prestamo,nombre
		)RC ON RC.Prestamo = endoso.credito 

	WHERE 
		endoso.Id_Lote_Endoso=@id_LoteEndoso
		AND (@Ecv_Endoso IS NULL OR endoso.Cod_ECV_Endoso=@Ecv_Endoso)
	ORDER BY endoso.Id_Endoso


