USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[Cob_Etiquetas_Cobranza_Add_Update]    Script Date: 03/11/2025 11:38:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Proc_EndosoValidacionUpdate] (
	 @Id_Validador INT
	,@Ids_Endoso VARCHAR(100)
	,@Ecv_Endoso CHAR(2)
)
AS
BEGIN
	DECLARE
		 @estatus INT = 0
		,@ID_Lote_Endoso INT
		,@Id_Endoso INT = 0
		,@Pagare FLOAT = 0
		,@Cod_ECV_Endoso CHAR(2) = ''

	BEGIN TRANSACTION
	BEGIN TRY

		IF @Ecv_Endoso = '02'
		BEGIN 
			UPDATE dbo.Endoso 
			SET Fecha_Validacion=GETDATE(),Id_Gestor_Validador=@Id_Validador,Cod_ECV_Endoso=@Ecv_Endoso 
			WHERE Id_Endoso IN (SELECT value FROM [dbo].[STRING_SPLIT](@Ids_Endoso,','))

			SET @estatus = 1
		END
		IF @Ecv_Endoso = '04'
		BEGIN 
			-- Buscará endosos por id_endoso para buscar el pagaré que se encuentre en estatus 04, si lo encuentra lo anulará con el estatus 05
			DECLARE db_cursor CURSOR FOR 
				SELECT e1.*--,e2.Id_Endoso,e2.Cod_ECV_Endoso
				FROM (
					SELECT Id_Endoso,Pagare,Cod_ECV_Endoso 
					FROM Endoso
					WHERE Cod_ECV_Endoso='04'
						) AS e1
				INNER JOIN Endoso AS e2 ON e1.Pagare=e2.Pagare
				WHERE e2.Cod_ECV_Endoso='02'
					AND e2.Id_Endoso IN (SELECT value FROM [dbo].[STRING_SPLIT](@Ids_Endoso,','))
			OPEN db_cursor  
			FETCH NEXT FROM db_cursor INTO @Id_Endoso,@Pagare,@Cod_ECV_Endoso 
			WHILE @@FETCH_STATUS = 0  
			BEGIN
				EXEC [dbo].[Proc_EndosoAnula_Update] 
						 @Id_Endoso = @Id_Endoso
						 ,@Id_Usuario = @Id_Validador
					
				FETCH NEXT FROM db_cursor INTO @Id_Endoso,@Pagare,@Cod_ECV_Endoso 
			END
			CLOSE db_cursor  
			DEALLOCATE db_cursor

			-- actualizará a 04 a aquellos endosos que permanezcan en esatus 02
			UPDATE dbo.Endoso 
			SET Fecha_Aceptacion=GETDATE(),Id_Gestor_Autoriza=@Id_Validador,Cod_ECV_Endoso=@Ecv_Endoso 
			WHERE Cod_ECV_Endoso='02' AND Id_Endoso IN (SELECT value FROM [dbo].[STRING_SPLIT](@Ids_Endoso,','))

			SET @estatus = 1
		END

		SELECT TOP 1 @ID_Lote_Endoso = Id_Lote_Endoso
		FROM Endoso
		WHERE Id_Endoso IN (SELECT value FROM [dbo].[STRING_SPLIT](@Ids_Endoso,','))

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
	SELECT @estatus AS Estatus,@ID_Lote_Endoso AS IdLoteEndoso, @Id_Validador AS IdGestor 
END


