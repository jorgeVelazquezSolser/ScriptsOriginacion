USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[ReporteGestPromesas]    Script Date: 02/09/2025 13:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_EndosoLoteConsulta_ID]
--DECLARE
		@Ids_Endoso VARCHAR(100)

AS

	SELECT 
		   endoso.Id_Endoso AS IdEndoso
		  ,endoso.Id_Lote_Endoso AS IdLoteEndoso
		  ,endoso.Pagare AS Pagare
		  ,RC.Nombre AS  NombreTitular
		  ,endoso.Nombre_Abogado AS NombreAbogado
		  ,endoso.Nombre_Coordinador AS NombreCoordinador
		  ,endoso.Nombre_Validador AS NombreValidador
		  ,endoso.Nombre_Autoriza AS NombreAutoriza
		  ,endoso.Estatus_Autorizacion AS EstatusAutorizacion
		  ,endoso.Cod_ECV_Endoso AS EstatusEndoso
	FROM (
			SELECT 
				 endo.Id_Endoso,endo.Id_Lote_Endoso,endo.Credito,endo.Pagare,tpEn.Nombre AS Tipo_Endoso,endo.Fecha_Registro,endo.Fecha_Aceptacion,endo.Fecha_Termino
				,ecvEn.Descripcion AS Estatus_Autorizacion,abogado.Nombre AS Nombre_Abogado,endo.Id_Abogado,endo.Id_Gestor_Autoriza,endo.Cod_ECV_Endoso
				,usuario.Nombre AS Nombre_Coordinador
				,vali.Nombre AS Nombre_Validador
				,aut.Nombre AS Nombre_Autoriza
			FROM dbo.Endoso AS endo
			INNER JOIN dbo.Lote_Endoso AS lote ON endo.Id_Lote_Endoso=lote.Id_Lote_Endoso
			INNER JOIN dbo.Cat_Abogado AS abogado ON endo.Id_Abogado=abogado.Id_Abogado
			INNER JOIN dbo.Usr_Usuarios AS usuario ON lote.Id_Gestor=usuario.ID_Usuario
			INNER JOIN dbo.TR_Tipo_Endoso AS tpEn ON endo.Cod_Tipo_Endoso=tpEn.Cod_Tipo_Endoso
			INNER JOIN dbo.TR_ECV_Endoso AS ecvEn ON endo.Cod_ECV_Endoso=ecvEn.Cod_ECV_Endoso 
			LEFT JOIN dbo.Usr_Usuarios AS vali ON endo.Id_Gestor_Validador=vali.ID_Usuario
			LEFT JOIN dbo.Usr_Usuarios AS aut ON endo.Id_Gestor_Autoriza=aut.ID_Usuario
		) AS endoso 

	INNER JOIN
		(SELECT
				[Prestamo]
				,[Nombre]
			FROM [Reporte_cartera] 
			GROUP BY prestamo,nombre
		)RC ON RC.Prestamo = endoso.credito 

	WHERE 
		endoso.Id_Endoso IN (SELECT value FROM [dbo].[STRING_SPLIT](@Ids_Endoso,','))
	ORDER BY endoso.Id_Endoso


