USE [PortalCliente]
GO
/****** Object:  StoredProcedure [dbo].[sp_consulta_api_key]    Script Date: 02/04/2026 10:42:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
 Author:	Guerrero Gomez, Hernando Irving
 Create date:   02/04/2026
 Description:	Consulta el último intento de envío de SMS si existe
*****************************************************************************************************/
CREATE PROCEDURE [dbo].[sp_MedioSMS_Intentos_Consulta] 
		@id_Solicitud_Autorizacion_BC_Intentos BIGINT
AS
BEGIN
DECLARE

	@p_id SMALLINT = 0,
	@p_msg VARCHAR(100) = '',
	@p_vigente INT

BEGIN TRY

	SET @p_id = 1;
	SET @p_msg = 'OK';

	SELECT TOP 1
		 @p_id AS p_id
		,@p_msg AS p_msg
		,intento.Id_Solicitud_Autorizacion_BC
		,intento.ID_MedioSMS
		,solicitud.Id_Cliente AS Id_Cotizacion
		,intento.Id_Solicitud_Autorizacion_BC_Intentos
	FROM Solicitud_Autorizacion_BC_Intentos AS intento
	INNER JOIN Solicitud_Autorizacion_BC AS solicitud ON intento.Id_Solicitud_Autorizacion_BC=solicitud.Id_Solicitud_Autorizacion_BC
	LEFT JOIN Peticion_Token_Autorizacion AS peticion ON intento.Id_Solicitud_Autorizacion_BC=peticion.Id_Solicitud_Autorizacion_BC
	LEFT JOIN Notificacion_Token_Autorizacion AS notificacion ON peticion.Id_Peticion_Token_Autorizacion=notificacion.Id_Peticion_Token_Autorizacion
	WHERE @id_Solicitud_Autorizacion_BC_Intentos IN (intento.Id_Solicitud_Autorizacion_BC,notificacion.Id_Notificacion_Token_Autorizacion)
	ORDER BY Id_Solicitud_Autorizacion_BC_Intentos DESC

	PRINT 'Termina consulta';

 END TRY
  BEGIN CATCH
        INSERT INTO ErrorLog (
            suser_sname, error_number, error_state, error_severity,
            error_line, error_procedure, error_message, usuario_id
        )
        VALUES (
            current_user, ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), 'sp_MedioSMS_Intentos_Consulta', ERROR_MESSAGE(), @p_id -- Suponiendo que p_id se utiliza como usuario_id
        );

     -- Establecer salidas de error
        SET @p_id = 0
        SET @p_msg = 'Se ha presentado un error: ' + ERROR_STATE() + ' - ' + ERROR_MESSAGE()

		SELECT 
            @p_id AS p_id
			,@p_msg AS p_msg

        -- Levantar la excepción nuevamente
        RAISERROR (@p_msg, -1, -1, 'sp_MedioSMS_Intentos_Consulta')
  END CATCH

END       