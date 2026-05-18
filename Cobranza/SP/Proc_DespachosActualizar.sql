USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[Proc_DespachosConsulta]    Script Date: 16/01/2026 07:30:09 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_DespachosActualizar]
    @Id_Despacho              INT,
    @Id_Zona                  INT,
    @Nombre                   VARCHAR(100),
    @Tipo_Persona             CHAR(1),
    @Id_Usuario_Modificacion  INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE d
    SET
          d.Id_Zona                 = @Id_Zona
        , d.Nombre                  = @Nombre
        , d.Tipo_Persona            = @Tipo_Persona
        , d.Id_Usuario_Modificacion = @Id_Usuario_Modificacion
        , d.Fecha_Modificacion      = GETDATE()
    FROM [dbo].[Cat_Despacho] d
    WHERE d.Id_Despacho = @Id_Despacho
      AND d.Cod_ECV_Despacho = '01';  -- opcional: solo si está activo
END;
GO
