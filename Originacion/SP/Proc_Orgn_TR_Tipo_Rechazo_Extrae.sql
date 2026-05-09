USE [Originacion]
GO



/* =========================================================
   SP EXTRAER CATALOGO TIPO RECHAZO ACTIVO
   ========================================================= */

CREATE OR ALTER PROCEDURE [dbo].[Proc_Orgn_TR_Tipo_Rechazo_Extrae]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [Id_Tipo_Rechazo],
        [Descripcion]
    FROM [dbo].[TR_Tipo_Rechazo]
    WHERE [Cod_ECV_Tipo_Rechazo] = '01'
    ORDER BY [Descripcion];
END
GO