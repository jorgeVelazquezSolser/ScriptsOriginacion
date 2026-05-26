USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[ReporteGestPromesas]    Script Date: 02/09/2025 13:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_LoteExistente]
	@Id_Gestor INT

AS
	SELECT 
		 Id_Lote_Endoso AS IdLoteEndoso
		,COUNT(1) AS TotalLote
	FROM dbo.Temp_Endoso
	WHERE Id_Gestor=@Id_Gestor
	GROUP BY ID_Lote_Endoso

