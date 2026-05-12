USE Originacion

/* =========================================================
   1. TABLA CATALOGO TIPO RECHAZO
   ========================================================= */

IF OBJECT_ID('[dbo].[TR_Tipo_Rechazo]', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[TR_Tipo_Rechazo] (
        [Id_Tipo_Rechazo] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Descripcion] VARCHAR(250) NOT NULL,
        [Cod_ECV_Tipo_Rechazo] CHAR(2) NOT NULL
    );
END
GO



/* =========================================================
   INSERTS CATALOGO TIPO RECHAZO
   01 = Activo
   02 = Inactivo
   ========================================================= */

IF NOT EXISTS (
    SELECT 1 FROM [dbo].[TR_Tipo_Rechazo]
    WHERE [Descripcion] = 'Rechazado por capacidad de pago'
)
BEGIN
    INSERT INTO [dbo].[TR_Tipo_Rechazo]
    (
        [Descripcion],
        [Cod_ECV_Tipo_Rechazo]
    )
    VALUES
    (
        'Rechazado por capacidad de pago',
        '01'
    );
END
GO

IF NOT EXISTS (
    SELECT 1 FROM [dbo].[TR_Tipo_Rechazo]
    WHERE [Descripcion] = 'Cliente no acepta oferta'
)
BEGIN
    INSERT INTO [dbo].[TR_Tipo_Rechazo]
    (
        [Descripcion],
        [Cod_ECV_Tipo_Rechazo]
    )
    VALUES
    (
        'Cliente no acepta oferta',
        '01'
    );
END
GO

IF NOT EXISTS (
    SELECT 1 FROM [dbo].[TR_Tipo_Rechazo]
    WHERE [Descripcion] = 'Cliente no respondió'
)
BEGIN
    INSERT INTO [dbo].[TR_Tipo_Rechazo]
    (
        [Descripcion],
        [Cod_ECV_Tipo_Rechazo]
    )
    VALUES
    (
        'Cliente no respondió',
        '01'
    );
END
GO
