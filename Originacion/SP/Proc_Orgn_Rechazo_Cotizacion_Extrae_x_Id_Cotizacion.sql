USE [Originacion]
GO

/* =========================================================
   5.3 SP EXTRAER RECHAZO (YA CON NUEVO NOMBRE)
   ========================================================= */

CREATE OR ALTER PROCEDURE [dbo].[Proc_Orgn_Rechazo_Cotizacion_Extrae_x_Id_Cotizacion]
    @Id_Cotizacion INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        RC.[Id_Rechazo],
        RC.[Id_Cotizacion],
        RC.[Id_Tipo_Rechazo],
        TR.[Descripcion],
        RC.[Fecha_Registro],
        RC.[Fecha_Modificacion],
        RC.[Cod_ECV_Rechazo],
        RC.[Usuario],
        RC.[Comentarios]
    FROM [dbo].[Ctz_Rechazo_Cotizacion] RC
    INNER JOIN [dbo].[TR_Tipo_Rechazo] TR
        ON RC.[Id_Tipo_Rechazo] = TR.[Id_Tipo_Rechazo]
    WHERE RC.[Id_Cotizacion] = @Id_Cotizacion
      AND RC.[Cod_ECV_Rechazo] = '01';
END
GO