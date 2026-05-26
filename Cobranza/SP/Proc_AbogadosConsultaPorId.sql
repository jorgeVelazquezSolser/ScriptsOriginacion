USE Cobranza


CREATE PROC [dbo].[Proc_AbogadosConsultaPorId]
    @Id_Abogado INT
AS
BEGIN
    SET NOCOUNT ON;
	SELECT 
		Nombre,Rfc,Correo,Telefono,Id_Abogado AS IdAbogado
	FROM Cat_Abogado
	WHERE Cod_ECV_Abogado = '01'
		AND Id_Abogado=@Id_Abogado    
END;
GO