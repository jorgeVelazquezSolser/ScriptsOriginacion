-- ============================================================
-- SCRIPT: proc_Orgn_Direccion_Electronica_Add_Update
-- Fecha: 2026-05-18
-- Autor: JorgeVelazquez
-- Descripción: Alta/actualización de dirección electrónica.
--              Modificaciones 2026-05-18:
--              - Se agrega @Observacion_CallCenter (uso exclusivo CC perfiles 17/18)
--               Tablas afectadas: DR_Dir_Electronicas (INSERT/UPDATE), DR_Dir_Electronicas_Bitacora (INSERT)
-- ============================================================

ALTER Proc [dbo].[proc_Orgn_Direccion_Electronica_Add_Update]
	@Id_Direccion_Electronica int
	,@Cod_Dir_Electronica char(2) = null
	,@ID_Persona int = null
	,@Prefijo_Nacional char(3) = ''
	,@Codigo_Area smallint = 0
	,@Txt_Direccion nvarchar(255) = null
	,@Extension nvarchar(10) = ''
	,@Observacion nvarchar(100) = null
	,@Fecha_Inicio date = null
	,@Fecha_Final date = null
	,@Cod_Ecv_Direccion char(1) = null
	,@Fecha_Ult_Accion date = null
	,@Cod_Ult_Accion char(2) = null
	,@Fecha_Registro datetime = null
	,@Valido_Desde date = null
	,@Valido_Hasta date = null
	,@Fecha_Ult_Cambio date = null
	,@Version smallint = null
	,@Prioridad char(1) = '1'
	,@RegresaDatos bit = 1
	,@Observacion_CallCenter nvarchar(500) = null
as
Begin
	if @Id_Direccion_Electronica = 0
	Begin
		Declare @ID_Secuencia Int = 8
		Exec proc_Orgn_Numero_Secuencia_Extrae @ID_Secuencia,'S',1,@Num_Secuencia = @Id_Direccion_Electronica Output

		update [DR_Dir_Electronicas] set [Prioridad] = 2
		where ID_Persona = @ID_Persona AND Cod_Dir_Electronica = @Cod_Dir_Electronica

		INSERT INTO [dbo].[DR_Dir_Electronicas]
			([Id_Direccion_Electronica],[Cod_Dir_Electronica],[ID_Persona],[Prefijo_Nacional],[Codigo_Area],[Txt_Direccion],[Extension],[Observacion],[Fecha_Inicio],[Fecha_Final],[Cod_Ecv_Direccion],[Fecha_Ult_Accion],[Cod_Ult_Accion],[Fecha_Registro],[Valido_Desde],[Valido_Hasta],[Fecha_Ult_Cambio],[Version],[Prioridad],[Observacion_CallCenter])
		VALUES
			(@Id_Direccion_Electronica,@Cod_Dir_Electronica,@ID_Persona,@Prefijo_Nacional,@Codigo_Area,@Txt_Direccion,@Extension,@Observacion,@Fecha_Inicio,@Fecha_Final,@Cod_Ecv_Direccion,@Fecha_Ult_Accion,@Cod_Ult_Accion,ISNULL(@Fecha_Registro, GETDATE()),@Valido_Desde,@Valido_Hasta,@Fecha_Ult_Cambio,@Version,@Prioridad,@Observacion_CallCenter)
	end
	Else
	begin
		DECLARE @ID_Secuencia_Dir_Electronica_Bitacora INT = 52, @Id_Bitacora INT = 0
		EXEC proc_Orgn_Numero_Secuencia_Extrae @ID_Secuencia_Dir_Electronica_Bitacora,'S',1,@Num_Secuencia = @Id_Bitacora OUTPUT

		Insert into [dbo].[DR_Dir_Electronicas_Bitacora]
		Select [Id_Direccion_Electronica],[Cod_Dir_Electronica],[ID_Persona],[Prefijo_Nacional],[Codigo_Area],[Txt_Direccion],[Extension],[Observacion],[Fecha_Inicio],[Fecha_Final],[Cod_Ecv_Direccion],[Fecha_Ult_Accion],[Cod_Ult_Accion],[Fecha_Registro],[Valido_Desde],[Valido_Hasta],[Fecha_Ult_Cambio],[Version],[Prioridad],getdate(),@Id_Bitacora,NULL,NULL,[Observacion_CallCenter]
		From [dbo].[DR_Dir_Electronicas]
		where [Id_Direccion_Electronica] = @Id_Direccion_Electronica

		UPDATE [dbo].[DR_Dir_Electronicas]
		SET
			[Cod_Dir_Electronica]     = ISNULL(@Cod_Dir_Electronica,    [Cod_Dir_Electronica])
			,[ID_Persona]             = ISNULL(@ID_Persona,              [ID_Persona])
			,[Prefijo_Nacional]       = ISNULL(@Prefijo_Nacional,        [Prefijo_Nacional])
			,[Codigo_Area]            = ISNULL(@Codigo_Area,             [Codigo_Area])
			,[Txt_Direccion]          = ISNULL(@Txt_Direccion,           [Txt_Direccion])
			,[Extension]              = ISNULL(@Extension,               [Extension])
			,[Observacion]            = @Observacion
			,[Fecha_Inicio]           = ISNULL(@Fecha_Inicio,            [Fecha_Inicio])
			,[Fecha_Final]            = @Fecha_Final
			,[Cod_Ecv_Direccion]      = ISNULL(@Cod_Ecv_Direccion,       [Cod_Ecv_Direccion])
			,[Fecha_Ult_Accion]       = @Fecha_Ult_Accion
			,[Cod_Ult_Accion]         = ISNULL(@Cod_Ult_Accion,          [Cod_Ult_Accion])
			,[Fecha_Registro]         = ISNULL(@Fecha_Registro,          GETDATE())
			,[Valido_Desde]           = @Valido_Desde
			,[Valido_Hasta]           = @Valido_Hasta
			,[Fecha_Ult_Cambio]       = @Fecha_Ult_Cambio
			,[Version]                = ISNULL(@Version,                 [Version])
			,[Prioridad]              = ISNULL(@Prioridad,               [Prioridad])
			,[Observacion_CallCenter] = ISNULL(@Observacion_CallCenter,  [Observacion_CallCenter])
		WHERE [Id_Direccion_Electronica] = @Id_Direccion_Electronica
	end

	if @RegresaDatos = 1
	begin
		select @Id_Direccion_Electronica Id_Direccion_Electronica
	end
end
GO
