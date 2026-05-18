USE [Cobranza]
GO
/****** Object:  StoredProcedure [dbo].[Proc_DespachosConsulta]    Script Date: 16/01/2026 07:30:09 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Proc_DespachosConsultaPorId]
    @Id_Despacho INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
          Id_Despacho
        , Id_Zona      AS IdZona
        , Nombre
        , Tipo_Persona AS TipoPersona
        , Fecha_Registro
        , Id_Usuario_Registra
        , Cod_ECV_Despacho
        , Fecha_Modificacion
        , Id_Usuario_Modificacion
    FROM [dbo].[Cat_Despacho]
    WHERE Id_Despacho = @Id_Despacho
      AND Cod_ECV_Despacho = '01';
END;
GO