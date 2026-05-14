USE [Originacion]
GO
/****** Object:  StoredProcedure [dbo].[proc_Orgn_Flujo_Regresa_Call_Center]    Script Date: 08/05/2026 16:01:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROC [dbo].[proc_Orgn_Flujo_Regresa_Analisis_Analisis]																																																																																				
	@Id_Referencia INT 
	,@Id_Usuario INT 
	,@Estatus_Validacion CHAR(2) OUTPUT
	,@Mensaje_Error VARCHAR(200)  OUTPUT
	,@Etapa CHAR(2) OUTPUT 
	,@Estatus CHAR(2) OUTPUT
AS
BEGIN

	DECLARE @Etapa_Actual CHAR(2)
	DECLARE @Estatus_Actual CHAR(2)

	SELECT	@Etapa_Actual	= Cod_Etapa,
			@Estatus_Actual = Cod_Estatus
	FROM cr_credito 
	WHERE [Id_Credito] = @Id_Referencia

	DECLARE @Mensaje_Errortotal VARCHAR(200)  

	IF ( (@Etapa_Actual != '04' AND 
			@Estatus_Actual != '10') 
		)
	BEGIN
		SET @Mensaje_Errortotal = '[{"errormensaje":"La etapa actual no se encuentra en las etapas permitidas para regresar a Analisis-En Analisis "}]'
		SELECT @Estatus_Validacion = '00'
			,@Mensaje_Error=  @Mensaje_Errortotal
			,@Etapa = '0'
			,@Estatus = '0'	
			RETURN

	END

	
	SELECT @Estatus_Validacion = '01'
	,@Mensaje_Error = ''
	,@Etapa = '04'
	,@Estatus = '08'		

END


