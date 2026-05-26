USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[ReporteGestPromesas]    Script Date: 02/09/2025 13:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_ParametrosGenerales]
	@Nombre_Parametro VARCHAR(50)

AS
	SELECT 
		Nombre,ValorTexto,IdParametro
	FROM dbo.Tr_Parametros_Generales
	WHERE Nombre=@Nombre_Parametro

