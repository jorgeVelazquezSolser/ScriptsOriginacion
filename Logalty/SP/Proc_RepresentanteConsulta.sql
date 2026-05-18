USE [LogaltyFirmaDigital_Copia]
GO
/****** Object:  StoredProcedure [dbo].[ReporteGestPromesas]    Script Date: 02/09/2025 13:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_RepresentanteConsulta]

AS
	SELECT 
		 Primer_Nombre AS PrimerNombre
		,Segundo_Nombre AS SegundoNombre
		,Primer_Apellido AS PrimerApellido
		,Segundo_Apellido AS SegundoApellido
		,Curp
		,Uuid
	FROM dbo.Cat_Representante
	WHERE Cod_ECV_Representante='01'
	ORDER BY Orden

--UPDATE dbo.Cat_Representante SET Cod_ECV_Representante='02' WHERE Uuid='E2559A1C-1946-4318-AB57-607A20486B47'
