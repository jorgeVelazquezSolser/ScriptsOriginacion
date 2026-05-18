USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[ReporteGestPromesas]    Script Date: 02/09/2025 13:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_EndososPagareConsulta]
--DECLARE
		 @idU INT --= 86
		,@Pagare FLOAT --= 4082181--411091110

AS

	SELECT 
		   gest.[Ges_Prestamo] AS Pagare
		  ,RC.[Nombre] AS  Nombre
		  ,ISNULL(endoso.Tipo_Endoso,tmpEndoso.Tipo_Endoso) AS TipoEndoso
		  ,CONVERT(VARCHAR,ISNULL(endoso.Fecha_Registro,tmpEndoso.Fecha_Registro),103) AS FechaRegistro
		  ,CONVERT(VARCHAR,endoso.Fecha_Aceptacion,103) AS FechaAceptacion
		  ,CONVERT(VARCHAR,endoso.Fecha_Termino,103) AS FechaTermino
		  ,Autoriza.Gestor_Autoriza AS GestorAutoriza
		  ,ISNULL(endoso.Estatus_Autorizacion,tmpEndoso.Estatus_Autorizacion) AS EstatusAutorizacion
		  ,ISNULL(endoso.Nombre_Abogado,tmpEndoso.Nombre_Abogado) AS NombreAbogado
		  ,endoso.Id_Endoso AS IdEndoso
		  ,gest.pk_Cob_Gestiones AS IdGestion
		  ,catg.pk_idcoordinador AS IdCoordinador
		  ,ISNULL(endoso.Cod_ECV_Endoso,tmpEndoso.Cod_ECV_Endoso) AS EstatusEndoso
		  ,sldo.MontoOtorgado
	FROM [CatGestorCoordinador] AS catg

	INNER JOIN (
		SELECT  [pk_idGestor]
				,[pk_idCoordinador]
			FROM [dbo].[CatGestorCoordinador] 
		) AS catg2 ON[catg2].[pk_idCoordinador]=catg.[pk_idgestor]

	INNER JOIN (
		SELECT gst.* 
		FROM Gestiones AS gst
	    INNER JOIN (
			SELECT Ges_Prestamo,MAX(pk_Cob_Gestiones) AS pk_Cob_Gestiones
			FROM [dbo].[Gestiones] gest
			GROUP BY Ges_Prestamo
			) AS ultGest ON gst.pk_Cob_Gestiones=ultGest.pk_Cob_Gestiones
		) AS gest ON gest.ges_usuarioagencia=catg2.[pk_idGestor]

	INNER JOIN
		(SELECT
				[Prestamo]
				,[Nombre]
			FROM [Reporte_cartera] 
			GROUP BY prestamo,nombre
		) AS RC ON RC.Prestamo = gest.[Ges_Prestamo] 

	INNER JOIN dbo.RptActSdosDiaria AS sldo ON gest.[Ges_Prestamo]=sldo.Prestamo AND sldo.Clasificacion NOT IN ('ORDINARIA')

	LEFT JOIN dbo.Cob_Prestamos_Proceso_Judicial AS proj ON gest.[Ges_Prestamo]=proj.Prestamo 

	LEFT JOIN (
			SELECT 
				 endo.Id_Endoso,endo.Credito,endo.Pagare,tpEn.Nombre AS Tipo_Endoso,endo.Fecha_Registro,endo.Fecha_Aceptacion,endo.Fecha_Termino
				,ecvEn.Descripcion AS Estatus_Autorizacion,abogado.Nombre AS Nombre_Abogado,endo.Id_Abogado,endo.Id_Gestor_Autoriza,endo.Cod_ECV_Endoso
			FROM dbo.Endoso AS endo
			INNER JOIN dbo.Cat_Abogado AS abogado ON endo.Id_Abogado=abogado.Id_Abogado
			INNER JOIN dbo.TR_Tipo_Endoso AS tpEn ON endo.Cod_Tipo_Endoso=tpEn.Cod_Tipo_Endoso
			INNER JOIN dbo.TR_ECV_Endoso AS ecvEn ON endo.Cod_ECV_Endoso=ecvEn.Cod_ECV_Endoso 
			WHERE endo.Cod_ECV_Endoso NOT IN ('00','01','02','04')
		) AS endoso ON gest.[Ges_Prestamo]=endoso.Credito

	LEFT JOIN (
			SELECT 
				 0 AS Id_Endoso,endo.Credito,endo.Pagare,tpEn.Nombre AS Tipo_Endoso,endo.Fecha_Registro,endo.Fecha_Aceptacion,endo.Fecha_Termino
				,ecvEn.Descripcion AS Estatus_Autorizacion,abogado.Nombre AS Nombre_Abogado,endo.Id_Abogado,endo.Id_Gestor_Autoriza,endo.Cod_ECV_Endoso
				,endo.Id_Gestor
			FROM dbo.Temp_Endoso AS endo
			INNER JOIN dbo.Cat_Abogado AS abogado ON endo.Id_Abogado=abogado.Id_Abogado
			INNER JOIN dbo.TR_Tipo_Endoso AS tpEn ON endo.Cod_Tipo_Endoso=tpEn.Cod_Tipo_Endoso
			INNER JOIN dbo.TR_ECV_Endoso AS ecvEn ON endo.Cod_ECV_Endoso=ecvEn.Cod_ECV_Endoso 
		) AS tmpEndoso ON catg.pk_idcoordinador=tmpEndoso.Id_Gestor AND gest.[Ges_Prestamo]=tmpEndoso.Credito 

	LEFT JOIN (
			SELECT
				[id_usuario]
				,[Tip_user]
				,user_name AS Gestor_Autoriza
			FROM [usr_usuarios] 
		) AS Autoriza ON Autoriza.id_usuario = endoso.Id_Gestor_Autoriza

	WHERE 
		catg.pk_idcoordinador=@idU
		AND gest.[Ges_Prestamo]=@Pagare 
		AND proj.Prestamo IS NULL
		AND tmpEndoso.Credito IS NULL
	ORDER BY gest.[Ges_Prestamo]


