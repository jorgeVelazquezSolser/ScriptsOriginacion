-- ============================================================
-- SCRIPT: proc_Orgn_Direccion_Electronica_Extrae
-- Fecha: 2026-05-15
-- Autor: JorgeVelazquez
-- Descripción: Extrae direcciones electrónicas de una persona.
--              Verifica si el crédito está cerrado (congelado) y trae
--              de la bitácora, de lo contrario trae de la tabla activa.
--              Modificación 2026-05-15: se agrega Observacion_CallCenter
--              en todos los SELECT (ISNULL para evitar nulls).
-- Tablas afectadas: DR_Dir_Electronicas (lectura), DR_Dir_Electronicas_Bitacora (lectura)
-- ============================================================

ALTER PROCEDURE [dbo].[proc_Orgn_Direccion_Electronica_Extrae]
	@Id_Persona INT = 0
	,@Id_Credito INT = 0
AS
BEGIN
	PRINT('Check Credito Cerrado')
	IF EXISTS(
				SELECT cc.Id_Entidad
				FROM CR_Credito_Cerrado AS cc
				INNER JOIN DR_Dir_Electronicas_Bitacora AS elecBit ON cc.ID_PERSONA=elecBit.Id_Persona
						AND cc.ID_CREDITO=elecBit.Id_Referencia
						AND elecBit.Cod_Ind_Congelado='S'
				WHERE cc.Id_Tipo_Entidad=3 AND cc.ID_CREDITO=@Id_Credito AND cc.ID_PERSONA=@Id_Persona)
	BEGIN
		IF @Id_Persona <> 0
			SELECT [Id_Direccion_Electronica],[Cod_Dir_Electronica],[ID_Persona],[Prefijo_Nacional],[Codigo_Area],[Txt_Direccion],[Extension],[Observacion],[Fecha_Inicio],[Fecha_Final],[Cod_Ecv_Direccion],[Fecha_Ult_Accion],[Cod_Ult_Accion],[Fecha_Registro],[Valido_Desde],[Valido_Hasta],[Fecha_Ult_Cambio],[Version],[Prioridad],tipo.Nombre AS Tipo_Dir_electronica,[Id_Referencia],[Cod_Ind_Congelado],ISNULL(direlect.Observacion_CallCenter,'') AS Observacion_CallCenter
			FROM [dbo].[DR_Dir_Electronicas_Bitacora] AS direlect
			INNER JOIN [TR_Dir_Electronica] AS tipo ON direlect.Cod_Dir_Electronica = tipo.Cod_Dir_Eletronica
			WHERE Id_Persona = @Id_Persona AND Id_Referencia=@Id_Credito AND direlect.Prioridad = 1
		ELSE
			SELECT [Id_Direccion_Electronica],[Cod_Dir_Electronica],[ID_Persona],[Prefijo_Nacional],[Codigo_Area],[Txt_Direccion],[Extension],[Observacion],[Fecha_Inicio],[Fecha_Final],[Cod_Ecv_Direccion],[Fecha_Ult_Accion],[Cod_Ult_Accion],[Fecha_Registro],[Valido_Desde],[Valido_Hasta],[Fecha_Ult_Cambio],[Version],[Prioridad],tipo.Nombre AS Tipo_Dir_electronica,[Id_Referencia],[Cod_Ind_Congelado],ISNULL(direlect.Observacion_CallCenter,'') AS Observacion_CallCenter
			FROM [dbo].[DR_Dir_Electronicas_Bitacora] AS direlect
			INNER JOIN [TR_Dir_Electronica] AS tipo ON direlect.Cod_Dir_Electronica = tipo.Cod_Dir_Eletronica
			WHERE Id_Referencia=@Id_Credito AND direlect.Prioridad = 1
	END
	ELSE
	BEGIN
		IF @Id_Persona <> 0
			SELECT [Id_Direccion_Electronica],[Cod_Dir_Electronica],[ID_Persona],[Prefijo_Nacional],[Codigo_Area],[Txt_Direccion],[Extension],[Observacion],[Fecha_Inicio],[Fecha_Final],[Cod_Ecv_Direccion],[Fecha_Ult_Accion],[Cod_Ult_Accion],[Fecha_Registro],[Valido_Desde],[Valido_Hasta],[Fecha_Ult_Cambio],[Version],[Prioridad],tipo.Nombre AS Tipo_Dir_electronica,NULL AS [Id_Referencia],NULL AS [Cod_Ind_Congelado],ISNULL(direlect.Observacion_CallCenter,'') AS Observacion_CallCenter
			FROM [dbo].[DR_Dir_Electronicas] AS direlect
			INNER JOIN [TR_Dir_Electronica] AS tipo ON direlect.Cod_Dir_Electronica = tipo.Cod_Dir_Eletronica
			WHERE Id_Persona = @Id_Persona AND direlect.Prioridad = 1
		ELSE
			SELECT [Id_Direccion_Electronica],[Cod_Dir_Electronica],[ID_Persona],[Prefijo_Nacional],[Codigo_Area],[Txt_Direccion],[Extension],[Observacion],[Fecha_Inicio],[Fecha_Final],[Cod_Ecv_Direccion],[Fecha_Ult_Accion],[Cod_Ult_Accion],[Fecha_Registro],[Valido_Desde],[Valido_Hasta],[Fecha_Ult_Cambio],[Version],[Prioridad],tipo.Nombre AS Tipo_Dir_electronica,NULL AS [Id_Referencia],NULL AS [Cod_Ind_Congelado],ISNULL(direlect.Observacion_CallCenter,'') AS Observacion_CallCenter
			FROM [dbo].[DR_Dir_Electronicas] AS direlect
			INNER JOIN [TR_Dir_Electronica] AS tipo ON direlect.Cod_Dir_Electronica = tipo.Cod_Dir_Eletronica
			WHERE direlect.Prioridad = 1
	END
END
GO
