USE Cobranza
GO

-- Grupo: Reporte Saldos Moratorios (sin columnas extendidas)
INSERT INTO Grupos_usuarios (
	 Id_Grupo
	,Id_Usuario
	,Nombre_Grupo
	,Descripcion
	,Fecha_Creacion
) VALUES (
	 126
	,'ReporteSaldosExtendido_moratorios'
	,'Reporte de saldos moratorios'
	,'Reporte de saldos con moratorios'
	,GETDATE()
)

