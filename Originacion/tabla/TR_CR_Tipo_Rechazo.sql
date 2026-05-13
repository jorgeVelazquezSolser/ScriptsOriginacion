USE [Originacion]
GO

/****** Object:  Table [dbo].[TR_Tipo_Rechazo]    Script Date: 11/05/2026 12:10:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TR_CR_Tipo_Rechazo](
	[Id_Tipo_Rechazo] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](250) NOT NULL,
	[Cod_ECV_Tipo_Rechazo] [char](2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Tipo_Rechazo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [dbo].[TR_CR_Tipo_Rechazo] VALUES('Recotización','01')
INSERT INTO [dbo].[TR_CR_Tipo_Rechazo] VALUES('Cancelación por el cliente','01')
INSERT INTO [dbo].[TR_CR_Tipo_Rechazo] VALUES('Rechazada','01')
