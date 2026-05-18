USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[Proc_DespachosConsulta]    Script Date: 16/01/2026 07:30:09 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_DespachosCrear]
    @Id_Zona             INT,
    @Nombre              VARCHAR(100),
    @Tipo_Persona        CHAR(1),
    @Id_Usuario_Registra INT,
    @Id_Despacho         INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Num_Secuencia INT;

    EXEC [dbo].[proc_Orgn_Numero_Secuencia_Extrae]
          @ID_Secuencia   = 2,
          @Ind_Update     = 'S',
          @Factor_update  = 1,
          @Num_Secuencia  = @Num_Secuencia OUTPUT;

    IF (@Num_Secuencia < 0)
    BEGIN
        RAISERROR('No se pudo obtener la secuencia para Id_Despacho.', 16, 1);
        RETURN;
    END;

    SET @Id_Despacho = @Num_Secuencia;

    INSERT INTO [dbo].[Cat_Despacho] (
          Id_Despacho
        , Id_Zona
        , Nombre
        , Tipo_Persona
        , Fecha_Registro
        , Id_Usuario_Registra
        , Cod_ECV_Despacho
        , Fecha_Modificacion
        , Id_Usuario_Modificacion
    )
    VALUES (
          @Id_Despacho 
        , @Id_Zona
        , @Nombre
        , @Tipo_Persona
        , GETDATE()
        , @Id_Usuario_Registra
        , '01'
        , NULL
        , NULL
    );
END;
GO