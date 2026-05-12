USE Originacion

/* =========================================================
   2. TABLA RECHAZO COTIZACION
   ========================================================= */

IF OBJECT_ID('[dbo].[TR_Rechazo_Cotizacion]', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[TR_Rechazo_Cotizacion] (
        [Id_Rechazo] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Id_Tipo_Rechazo] INT NOT NULL,
        [Id_Cotizacion] INT NOT NULL,
        [Fecha_Registro] DATETIME NOT NULL,
        [Fecha_Modificacion] DATETIME NULL,
        [Cod_ECV_Rechazo] CHAR(2) NOT NULL,
        [Usuario] VARCHAR(100) NULL,
		[Comentarios] VARCHAR(500) NULL,

        CONSTRAINT [FK_TR_Rechazo_Cotizacion_TR_Tipo_Rechazo]
        FOREIGN KEY ([Id_Tipo_Rechazo])
        REFERENCES [dbo].[TR_Tipo_Rechazo] ([Id_Tipo_Rechazo])
    );
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UX_TR_Rechazo_Cotizacion_Id_Cotizacion'
      AND object_id = OBJECT_ID('[dbo].[TR_Rechazo_Cotizacion]')
)
BEGIN
    CREATE UNIQUE INDEX [UX_TR_Rechazo_Cotizacion_Id_Cotizacion]
    ON [dbo].[TR_Rechazo_Cotizacion] ([Id_Cotizacion]);
END
GO

/* =========================================================
   5. RENOMBRAR TABLA Y AJUSTAR STORED PROCEDURES
   ========================================================= */

-- 5.1 RENOMBRAR TABLA
IF OBJECT_ID('[dbo].[TR_Rechazo_Cotizacion]', 'U') IS NOT NULL
BEGIN
    EXEC sp_rename 'dbo.TR_Rechazo_Cotizacion', 'Ctz_Rechazo_Cotizacion';
END
GO
