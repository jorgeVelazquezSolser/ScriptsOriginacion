USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[Cob_Etiquetas_Cobranza_Add_Update]    Script Date: 03/11/2025 11:38:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Proc_EndososAgrega] (
	 @Pagare FLOAT
	,@Credito FLOAT
	,@Cod_Tipo_Endoso CHAR(2) = '01'
	,@Id_Abogado INT
	,@Id_Gestor INT
)
AS
BEGIN
	DECLARE @ID_Secuencia_Endoso INT = 4  --Secuencia para Lote_Endoso
	DECLARE @ID_Endoso INT = 0
	DECLARE @ID_Lote_Endoso INT = 0

	SELECT
		@ID_Lote_Endoso = Id_Lote_Endoso
	FROM Temp_Endoso
	WHERE Id_Gestor=@Id_Gestor

	IF ISNULL(@ID_Lote_Endoso,0) = 0 
	BEGIN
		EXEC proc_Orgn_Numero_Secuencia_Extrae @ID_Secuencia_Endoso,'S',1,@Num_Secuencia = @ID_Lote_Endoso OUTPUT
		--INSERT INTO [dbo].[Lote_Endoso] ([Id_Lote_Endoso],[Id_Gestor]) VALUES (
		--			 @ID_Lote_Endoso
		--			,@Id_Gestor
		--	)
	END

	--EXEC proc_Orgn_Numero_Secuencia_Extrae @ID_Secuencia_Endoso,'S',1,@Num_Secuencia = @ID_Endoso OUTPUT
	INSERT INTO [dbo].[Temp_Endoso] ([Id_Lote_Endoso],[Id_Gestor],[Pagare],[Credito],[Cod_Tipo_Endoso],[Id_Abogado]) VALUES (
				@ID_Lote_Endoso
			   ,@Id_Gestor
			   ,@Pagare
			   ,@Credito
			   ,@Cod_Tipo_Endoso
			   ,@Id_Abogado
		)

	SELECT [Pagare] AS Pagare,Id_Lote_Endoso AS IdLoteEndoso
	FROM [dbo].[Temp_Endoso]
	WHERE Id_Lote_Endoso=@ID_Lote_Endoso
END


