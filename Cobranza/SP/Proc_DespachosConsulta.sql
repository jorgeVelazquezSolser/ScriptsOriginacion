USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[ReporteGestPromesas]    Script Date: 02/09/2025 13:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_DespachosConsulta]
	@id_Zona INT

AS
	SELECT 
		Nombre,Id_Zona AS IdZona,Id_Despacho AS IdDespacho,Tipo_Persona AS TipoPersona
	FROM Cat_Despacho
	WHERE Cod_ECV_Despacho = '01'
		AND Id_Zona=@id_Zona


