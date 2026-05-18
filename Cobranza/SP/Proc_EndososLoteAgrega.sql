USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[Cob_Etiquetas_Cobranza_Add_Update]    Script Date: 03/11/2025 11:38:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Proc_EndososLoteAgrega] (
	@Id_Gestor INT
)
AS
BEGIN
	DECLARE 
			 @ID_Secuencia_Endoso INT = 5  --Secuencia para Endoso
			,@ID_Endoso INT = 0
			,@ID_Lote_Endoso INT = 0
			,@Pagare FLOAT
			,@Credito FLOAT
			,@Cod_Tipo_Endoso CHAR(2)
			,@Id_Abogado INT
			,@total_tmp INT = 0
			,@total_pro INT = 0
			,@estatus INT = 0

	SELECT 
		 @ID_Lote_Endoso = Id_Lote_Endoso
		,@total_tmp = COUNT(1)
	FROM dbo.Temp_Endoso
	WHERE Id_Gestor=@Id_Gestor
	GROUP BY ID_Lote_Endoso

	BEGIN TRANSACTION
	BEGIN TRY

		INSERT INTO [dbo].[Lote_Endoso] ([Id_Lote_Endoso],[Id_Gestor]) VALUES (
					 @ID_Lote_Endoso
					,@Id_Gestor
			)

		DECLARE EndosoCursor CURSOR FOR
								SELECT Pagare,Credito,Cod_Tipo_Endoso,Id_Abogado
								FROM dbo.Temp_Endoso
								WHERE Id_Gestor=@Id_Gestor

		OPEN EndosoCursor

		FETCH NEXT FROM EndosoCursor INTO @Pagare, @Credito, @Cod_Tipo_Endoso, @Id_Abogado

		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC proc_Orgn_Numero_Secuencia_Extrae @ID_Secuencia_Endoso,'S',1,@Num_Secuencia = @ID_Endoso OUTPUT
			INSERT INTO [dbo].[Endoso] ([Id_Endoso],[Id_Lote_Endoso],[Pagare],[Credito],[Cod_Tipo_Endoso],[Id_Abogado]) VALUES (
						@ID_Endoso
						,@ID_Lote_Endoso
						,@Pagare
						,@Credito
						,@Cod_Tipo_Endoso
						,@Id_Abogado
				)
			SET @total_pro += 1;

			FETCH NEXT FROM EndosoCursor INTO @Pagare, @Credito, @Cod_Tipo_Endoso, @Id_Abogado
		END;

		CLOSE EndosoCursor;

		DEALLOCATE EndosoCursor;

		IF @total_pro = @total_tmp
		BEGIN
			DELETE FROM dbo.Temp_Endoso
			WHERE Id_Gestor=@Id_Gestor

			set @estatus = 1

			COMMIT TRANSACTION
		END
		ELSE
		BEGIN
			ROLLBACK TRANSACTION
		END
	END TRY
	BEGIN CATCH
		PRINT 'ERROR DEL PROCESO'
		INSERT INTO dbo.ErrorLog (suser_sname, error_number, error_state, error_severity, error_line, error_procedure, error_message, usuario_id)
		VALUES (SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), 0);
		IF (XACT_STATE()) = -1
			ROLLBACK TRANSACTION
		if (XACT_STATE()) = 1
			COMMIT TRANSACTION
		DECLARE @severity INT = ERROR_SEVERITY(), @state INT = ERROR_STATE()
				,@_msg VARCHAR(512) = N'Se a presentado un error: ' + (select convert(nvarchar(1024), error_number()) + ' - ' + error_message())

		SET @estatus = 0 
		PRINT 'ERROR DEL PROCESO: ' + @_msg
		RAISERROR(@_msg, @severity, @state)
	END CATCH
	SELECT @estatus AS Estatus,@ID_Lote_Endoso AS IdLoteEndoso, @Id_Gestor AS IdGestor 
END


