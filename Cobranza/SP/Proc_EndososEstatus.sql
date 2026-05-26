USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[ReporteGestPromesas]    Script Date: 02/09/2025 13:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_EndososEstatus]

AS

	SELECT 
		   Cod_ECV_Endoso CodEstatus, Descripcion AS Nombre
	FROM TR_ECV_Endoso
	ORDER BY Cod_ECV_Endoso


