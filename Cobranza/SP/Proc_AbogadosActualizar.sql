USE Cobranza


CREATE PROC [dbo].[Proc_AbogadosActualizar]
    @Id_Abogado              INT,
    @Id_Despacho             INT,
    @Rfc                     VARCHAR(13),
    @Nombre                  VARCHAR(100),
    @Correo                  VARCHAR(100),
    @Telefono                VARCHAR(15),
    @Id_Usuario_Modificacion INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE a
    SET
          a.Id_Despacho             = @Id_Despacho
        , a.Rfc                     = @Rfc
        , a.Nombre                  = @Nombre
        , a.Correo                  = @Correo
        , a.Telefono                = @Telefono
        , a.Id_Usuario_Modificacion = @Id_Usuario_Modificacion
        , a.Fecha_Modificacion      = GETDATE()
    FROM [dbo].[Cat_Abogado] a
    WHERE a.Id_Abogado = @Id_Abogado
      AND a.Cod_ECV_Abogado = '01';
END;
GO
