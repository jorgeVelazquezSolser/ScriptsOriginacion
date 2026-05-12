USE Originacion

INSERT INTO [Originacion].[dbo].[Tr_Parametros_Generales] 
VALUES((SELECT MAX([IdParametro]) + 1 FROM [Originacion].[dbo].[Tr_Parametros_Generales]),'RequiereAutorizacionCB','','Bandera que indica si se debe realizar autorización de CB o no, se toma como boolean',1)

INSERT INTO [Originacion].[dbo].[Tr_Parametros_Generales]
 VALUES ((SELECT MAX([IdParametro]) + 1 FROM [Originacion].[dbo].[Tr_Parametros_Generales]),'HabilitarCelulaDigital','','Bandera que indica si se debe habilita celula digital o no',1);

