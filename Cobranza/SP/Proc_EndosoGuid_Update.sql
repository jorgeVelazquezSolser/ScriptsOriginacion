USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[Cob_Etiquetas_Cobranza_Add_Update]    Script Date: 03/11/2025 11:38:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Proc_EndosoGuid_Update] (
	 @Id_Endoso INT
	,@Guid VARCHAR(100)
)
AS
BEGIN
	DECLARE
		 @estatus INT = 0
	BEGIN TRANSACTION
	BEGIN TRY
		UPDATE dbo.Endoso SET Guid=@Guid WHERE Id_Endoso=@Id_Endoso

		SET @estatus = 1

		SELECT @Guid=Guid
		FROM dbo.Endoso
		WHERE Id_Endoso=@Id_Endoso 

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
	SELECT @estatus AS Estatus,@Guid AS GuidEndoso
END


