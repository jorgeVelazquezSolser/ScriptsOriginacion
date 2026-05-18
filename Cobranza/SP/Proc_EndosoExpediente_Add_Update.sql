USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[Cob_Etiquetas_Cobranza_Add_Update]    Script Date: 03/11/2025 11:38:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Proc_EndosoExpediente_Add_Update] (
	 @Id_Endoso INT
	,@Nombre_Documento VARCHAR(100)
	,@Ubicacion VARCHAR(MAX)
)
AS
BEGIN
	DECLARE
		 @estatus INT = 0
		,@Id_Expediente_Endoso INT
		,@ID_Secuencia_Expediente_Endoso INT = 7

	SELECT @Id_Expediente_Endoso=Id_Expediente_Endoso
	FROM dbo.Expediente_Endoso
	WHERE Id_Endoso=@Id_Endoso AND Nombre_Documento=@Nombre_Documento

	BEGIN TRANSACTION
	BEGIN TRY

		IF ISNULL(@Id_Expediente_Endoso,0) = 0
		BEGIN
			EXEC proc_Orgn_Numero_Secuencia_Extrae @ID_Secuencia_Expediente_Endoso,'S',1,@Num_Secuencia = @Id_Expediente_Endoso OUTPUT

			INSERT INTO dbo.Expediente_Endoso (Id_Expediente_Endoso,Id_Endoso,Nombre_Documento,Ubicacion)
			VALUES(
				 @Id_Expediente_Endoso
				,@Id_Endoso
				,@Nombre_Documento
				,@Ubicacion
			)
		END
		IF ISNULL(@Id_Expediente_Endoso,0) > 0
		BEGIN 
			UPDATE dbo.Expediente_Endoso 
			SET Nombre_Documento=@Nombre_Documento,Ubicacion=@Ubicacion
			WHERE Id_Expediente_Endoso=@Id_Expediente_Endoso

		END
		SET @estatus = 1

		SELECT @Id_Expediente_Endoso=Id_Expediente_Endoso
		FROM dbo.Expediente_Endoso
		WHERE Id_Endoso=@Id_Endoso AND Nombre_Documento=@Nombre_Documento

		COMMIT TRANSACTION
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
	SELECT @estatus AS Estatus,@Id_Expediente_Endoso AS IdExpedienteEndoso
END


