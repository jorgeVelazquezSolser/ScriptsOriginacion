-- Grupo: Reporte Saldos Extendido Moratorios (con columnas extendidas)
IF NOT EXISTS (
	SELECT 1 FROM Grupos_usuarios
	WHERE Id_Usuario = 126
	AND Nombre_Grupo = 'ReporteSaldosExtendido_moratorios'
)
BEGIN
	INSERT INTO Grupos_usuarios (
		 Id_Usuario
		,Nombre_Grupo
		,Descripcion
		,Fecha_Creacion
	) VALUES (
		 126
		,'ReporteSaldosExtendido_moratorios'
		,'Reporte de saldos extendido con moratorios'
		,GETDATE()
	)
END
GO
