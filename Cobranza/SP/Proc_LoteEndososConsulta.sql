USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[ReporteGestPromesas]    Script Date: 02/09/2025 13:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_LoteEndososConsulta]
		@Cod_ECV_Endoso CHAR(2)

AS

	SELECT DISTINCT 
		 lote.Id_Lote_Endoso AS IdLoteEndoso
		,usr.Nombre AS NombreCoordinador
		,CONVERT(VARCHAR,lote.Fecha_Registro,103) AS FechaRegistro
	FROM Lote_Endoso AS lote
	INNER JOIN Endoso AS endo ON lote.Id_Lote_Endoso=endo.Id_Lote_Endoso
	INNER JOIN Usr_Usuarios AS usr ON lote.Id_Gestor=usr.ID_Usuario
	WHERE endo.Cod_ECV_Endoso=@Cod_ECV_Endoso
	ORDER BY lote.Id_Lote_Endoso DESC


