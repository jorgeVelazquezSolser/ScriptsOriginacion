USE [Originacion]
GO

/* =========================================================
   5.2 SP INSERT / UPDATE RECHAZO (YA CON NUEVO NOMBRE)
   ========================================================= */

CREATE OR ALTER PROCEDURE [dbo].[Proc_Orgn_Rechazo_Cotizacion_Add_Update]
    @Id_Cotizacion INT,
    @Id_Tipo_Rechazo INT,
    @Usuario VARCHAR(100) = NULL,
    @Comentarios VARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM [dbo].[Ctz_Rechazo_Cotizacion]
        WHERE [Id_Cotizacion] = @Id_Cotizacion
    )
    BEGIN
        UPDATE [dbo].[Ctz_Rechazo_Cotizacion]
        SET
            [Id_Tipo_Rechazo] = @Id_Tipo_Rechazo,
            [Fecha_Modificacion] = GETDATE(),
            [Cod_ECV_Rechazo] = '01',
            [Usuario] = @Usuario,
            [Comentarios] = @Comentarios
        WHERE [Id_Cotizacion] = @Id_Cotizacion
          AND (
                [Id_Tipo_Rechazo] <> @Id_Tipo_Rechazo
                OR [Cod_ECV_Rechazo] <> '01'
                OR ISNULL([Usuario], '') <> ISNULL(@Usuario, '')
                OR ISNULL([Comentarios], '') <> ISNULL(@Comentarios, '')
              );
    END
    ELSE
    BEGIN
        INSERT INTO [dbo].[Ctz_Rechazo_Cotizacion]
        (
            [Id_Tipo_Rechazo],
            [Id_Cotizacion],
            [Fecha_Registro],
            [Fecha_Modificacion],
            [Cod_ECV_Rechazo],
            [Usuario],
            [Comentarios]
        )
        VALUES
        (
            @Id_Tipo_Rechazo,
            @Id_Cotizacion,
            GETDATE(),
            NULL,
            '01',
            @Usuario,
            @Comentarios
        );
    END

    SELECT *
    FROM [dbo].[Ctz_Rechazo_Cotizacion]
    WHERE [Id_Cotizacion] = @Id_Cotizacion;
END
GO
