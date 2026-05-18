USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[ReporteGestPromesas]    Script Date: 02/09/2025 13:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_EndososListaLoteConsulta]
	@Id_Gestor INT

AS
	SELECT 
		 endoso.Id_Lote_Endoso AS IdLoteEndoso
		,endoso.Pagare
		,RC.Nombre AS  NombreTitular
		,coordina.Nombre_Coordinador AS NombreCoordinador
		,abogado.Nombre_Abogado AS NombreAbogado
		,endoso.Id_Abogado AS IdAbogado
		,endoso.Id_Gestor AS IdGestor
	FROM dbo.Temp_Endoso AS endoso
	INNER JOIN
		(SELECT
				[Prestamo]
				,[Nombre]
			FROM [Reporte_cartera] 
			GROUP BY prestamo,nombre
		)RC ON RC.Prestamo = endoso.credito 
	LEFT JOIN (
			SELECT
				[id_usuario]
				,[Tip_user]
				,user_name AS Nombre_Coordinador
			FROM [usr_usuarios] 
		) AS coordina ON coordina.id_usuario = endoso.Id_Gestor
	LEFT JOIN (
			SELECT
				Id_Abogado
				,Nombre AS Nombre_Abogado
				,Rfc
			FROM Cat_Abogado 
		) AS abogado ON abogado.Id_Abogado = endoso.Id_Abogado
	WHERE endoso.Id_Gestor=@Id_Gestor

