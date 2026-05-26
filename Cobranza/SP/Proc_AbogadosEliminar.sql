USE Cobranza


CREATE OR ALTER PROC [dbo].[Proc_AbogadosEliminar]
    @Id_Abogado INT,
	@Id_Usuario_Modificacion INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE a
    SET
          a.Cod_ECV_Abogado   = '02'
        , a.Fecha_Modificacion = GETDATE()
		, a.Id_Usuario_Modificacion = @Id_Usuario_Modificacion
    FROM [dbo].[Cat_Abogado] a
    WHERE a.Id_Abogado = @Id_Abogado
      AND a.Cod_ECV_Abogado = '01';
END;
GO