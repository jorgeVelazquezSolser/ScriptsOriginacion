USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[ReporteGestPromesas]    Script Date: 02/09/2025 13:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_Endoso_Registro_Elimina]
	 @Id_Gestor INT
	,@Prestamo INT

AS

DECLARE
	 @existe INT = 0
	,@estatus INT = 0

BEGIN
	BEGIN TRANSACTION
	BEGIN TRY

		DELETE
		FROM dbo.Temp_Endoso
		WHERE Id_Gestor=@Id_Gestor
			AND Pagare=@Prestamo


		SELECT @existe = COUNT(1)
		FROM dbo.Temp_Endoso
		WHERE Id_Gestor=@Id_Gestor
			AND Pagare=@Prestamo

		IF @existe = 0
		BEGIN
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
	SELECT @estatus AS Estatus,@Id_Gestor AS IdGestor 
END
