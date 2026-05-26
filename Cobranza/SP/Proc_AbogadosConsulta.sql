USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[ReporteGestPromesas]    Script Date: 02/09/2025 13:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_AbogadosConsulta]
	@id_despacho INT

AS
	SELECT 
		Nombre,Rfc,Correo,Telefono,Id_Abogado AS IdAbogado
	FROM Cat_Abogado
	WHERE Cod_ECV_Abogado = '01'
		AND Id_Despacho=@id_despacho


