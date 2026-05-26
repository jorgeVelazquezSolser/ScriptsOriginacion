USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[ReporteGestPromesas]    Script Date: 02/09/2025 13:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_Endoso_ReporteConsulta]
--DECLARE
		  @pagare FLOAT --= NULL--4082181--720161
		 ,@fechaInicial DATETIME --= '2026-01-06'
		 ,@fechaFinal DATETIME --= '2026-01-08'

AS

	SELECT 
		 endo.Pagare
		,RC.Nombre AS Nombre
		,RC.Capital AS MontoPagare --?????
		,RC.[CIUDAD, ESTADO] AS MpioEdo --?????
		,RC.Convenio AS Convenio
		,gestor.Nombre_Gestor AS GestorAsignado
		,CONVERT(VARCHAR,endo.Fecha_Registro,103) AS FechaTramite
		,CONVERT(VARCHAR,endo.Fecha_Aceptacion,103) AS FechaAceptacion
		,ecv.Descripcion AS Estatus
		,CONVERT(VARCHAR,endo.Fecha_Termino,103) AS FechaCancelacion
		,val.Nombre_Validador AS Validador
		,endosatario.Nombre_Endosante AS Endosante
		,abogado.Nombre AS Endosatario
	FROM dbo.Endoso AS endo
	INNER JOIN dbo.Lote_Endoso AS lot ON endo.Id_Lote_Endoso=lot.Id_Lote_Endoso
	INNER JOIN (
			SELECT Prestamo,Convenio,Nombre,Capital,[CIUDAD, ESTADO]
			FROM dbo.Reporte_cartera
			GROUP BY Prestamo,Convenio,Nombre,Capital,[CIUDAD, ESTADO]
		) AS RC ON RC.Prestamo = endo.Credito 
	INNER JOIN (
		SELECT gst.* 
		FROM dbo.Gestiones AS gst
		INNER JOIN (
				SELECT Ges_Prestamo,MAX(pk_Cob_Gestiones) AS pk_Cob_Gestiones
				FROM dbo.Gestiones AS gest
				GROUP BY Ges_Prestamo
			) AS ultGest ON gst.pk_Cob_Gestiones=ultGest.pk_Cob_Gestiones
		) AS gest ON endo.Credito=gest.Ges_Prestamo
	INNER JOIN (
			SELECT
					id_usuario
				,Tip_user
				,user_name AS Nombre_Gestor
			FROM dbo.usr_usuarios
		) AS gestor ON gest.ges_usuarioagencia=Gestor.id_usuario
	INNER JOIN (
			SELECT
					id_usuario
				,Tip_user
				,user_name AS Nombre_Validador
			FROM dbo.usr_usuarios
		) AS val ON endo.Id_Gestor_Validador=val.ID_Usuario
	INNER JOIN (
			SELECT
					id_usuario
				,Tip_user
				,user_name AS Nombre_Endosante
			FROM dbo.usr_usuarios
		) AS endosatario ON lot.Id_Gestor=endosatario.ID_Usuario
	INNER JOIN dbo.Cat_Abogado AS abogado ON endo.Id_Abogado=abogado.Id_Abogado
	INNER JOIN dbo.TR_ECV_Endoso AS ecv ON endo.Cod_ECV_Endoso=ecv.Cod_ECV_Endoso

	WHERE 
		(@pagare IS NULL OR endo.Pagare=@pagare)
		AND (@fechaInicial IS NULL OR CAST(endo.Fecha_Aceptacion AS DATE)>=@fechaInicial)
		AND (@fechaFinal IS NULL OR CAST(endo.Fecha_Aceptacion AS DATE)<=@fechaFinal)
	ORDER BY endo.Id_Endoso DESC

