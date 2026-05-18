USE Cobranza

CREATE PROC [dbo].[Proc_AbogadosCrear]
    @Id_Despacho          INT,
    @Rfc                  VARCHAR(13),
    @Nombre               VARCHAR(100),
    @Correo               VARCHAR(100),
    @Telefono             VARCHAR(15),
    @Id_Usuario_Registra  INT,
    @Id_Abogado           INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Num_Secuencia INT;

    -- Secuencia para Id_Abogado (ID_Secuencia = 3)
    EXEC [dbo].[proc_Orgn_Numero_Secuencia_Extrae]
          @ID_Secuencia   = 3,
          @Ind_Update     = 'S',
          @Factor_update  = 1,
          @Num_Secuencia  = @Num_Secuencia OUTPUT;

    IF (@Num_Secuencia < 0)
    BEGIN
        RAISERROR('No se pudo obtener la secuencia para Id_Abogado.', 16, 1);
        RETURN;
    END;

    SET @Id_Abogado = @Num_Secuencia;

    INSERT INTO [dbo].[Cat_Abogado] (
          Id_Abogado
        , Id_Despacho
        , Rfc
        , Nombre
        , Correo
        , Telefono
        , Fecha_Registro
        , Id_Usuario_Registra
        , Cod_ECV_Abogado
        , Fecha_Modificacion
        , Id_Usuario_Modificacion
    )
    VALUES (
          @Id_Abogado
        , @Id_Despacho
        , @Rfc
        , @Nombre
        , @Correo
        , @Telefono
        , GETDATE()
        , @Id_Usuario_Registra
        , '01'
        , NULL
        , NULL
    );
END;
GO