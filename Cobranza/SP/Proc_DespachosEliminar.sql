USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[Proc_DespachosConsulta]    Script Date: 16/01/2026 07:30:09 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_DespachosEliminar]
    @Id_Despacho INT,
	@Id_Usuario_Modificacion INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE d
    SET
          d.Cod_ECV_Despacho   = '02'
        , d.Fecha_Modificacion = GETDATE()
		, d.Id_Usuario_Modificacion = @Id_Usuario_Modificacion
    FROM [dbo].[Cat_Despacho] d
    WHERE d.Id_Despacho = @Id_Despacho
      AND d.Cod_ECV_Despacho = '01';
END;
GO