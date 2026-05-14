USE [Originacion]
GO
/****** Object:  StoredProcedure [dbo].[Proc_Orgn_TR_Motivos_Cancelacion_Rechazo_Extrae]    Script Date: 09/05/2026 16:12:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[Proc_Orgn_CR_Tipo_Rechazo_Extrae]
	@Id_Tipo_Rechazo INT = 0
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		[Id_Tipo_Rechazo] AS IdTipoRechazo,
		[Descripcion] AS NombreRechazo
	FROM [dbo].[TR_CR_Tipo_Rechazo]
	WHERE [Cod_ECV_Tipo_Rechazo]='01'
		AND (@Id_Tipo_Rechazo=0 OR [Id_Tipo_Rechazo] = @Id_Tipo_Rechazo)
	ORDER BY [Descripcion] 
END


