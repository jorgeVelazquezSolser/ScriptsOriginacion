USE Originacion

/* =========================================================
   AGREGAR Id_Tipo_Empleado_Cotizacion A EMPLEO
   ========================================================= */

ALTER PROCEDURE [dbo].[proc_Orgn_Pers_Empleo_Add_Update](
	@ID_Empleo int
    ,@Id_Convenio int
    ,@Id_Persona int
    ,@ID_Dependencia int
    ,@ID_Area int
    ,@Nombre_Dependencia varchar(50)
    ,@Dependencia_Empresa varchar(50) = ''
    ,@Nombre_Area varchar(50)
    ,@Puesto varchar(100)
    ,@Cod_Tipo_Empleado char(2)
    ,@Cod_Sub_Tipo_Empleado char(2)
    ,@Clave_Empleado varchar(20)
    ,@Jefe_Inmediato varchar(50)
    ,@Sueldo decimal(10,2)
    ,@Telefono nvarchar(30)
    ,@Fecha_Ingreso date
    ,@Fecha_Vigencia date = null
    ,@Ind_Activo int
    ,@Fecha_Registro smalldatetime
    ,@Fecha_Ult_Cambio smalldatetime
	,@RegresaDatos bit = 1
    ,@Id_Tipo_Empleado_Cotizacion char(2) = NULL
)
AS
BEGIN
	DECLARE @ID_Secuencia INT = 11;

	IF @ID_Empleo = 0
	BEGIN
		EXEC proc_Orgn_Numero_Secuencia_Extrae @ID_Secuencia,'S',1,@Num_Secuencia = @ID_Empleo OUTPUT;

		UPDATE [dbo].[Pers_Empleo]
        SET [Ind_Activo] = 0
        WHERE [ID_Persona] = @Id_Persona;

		INSERT INTO [dbo].[Pers_Empleo]
		(
            [ID_Empleo],
            [Id_Convenio],
            [ID_Persona],
            [ID_Dependencia],
            [ID_Area],
            [Nombre_Dependencia],
            [Dependencia_Empresa],
            [Nombre_Area],
            [Puesto],
            [Cod_Tipo_Empleado],
            [Cod_Sub_Tipo_Empleado],
            [Clave_Empleado],
            [Jefe_Inmediato],
            [Sueldo],
            [Telefono],
            [Fecha_Ingreso],
            [Fecha_Vigencia],
            [Ind_Activo],
            [Fecha_Registro],
            [Fecha_Ult_Cambio],
            [Id_Tipo_Empleado_Cotizacion]
        )
		VALUES
		(
            @ID_Empleo,
            @Id_Convenio,
            @Id_Persona,
            @ID_Dependencia,
            @ID_Area,
            @Nombre_Dependencia,
            @Dependencia_Empresa,
            @Nombre_Area,
            @Puesto,
            @Cod_Tipo_Empleado,
            @Cod_Sub_Tipo_Empleado,
            @Clave_Empleado,
            @Jefe_Inmediato,
            @Sueldo,
            @Telefono,
            @Fecha_Ingreso,
            @Fecha_Vigencia,
            @Ind_Activo,
            @Fecha_Registro,
            @Fecha_Ult_Cambio,
            @Id_Tipo_Empleado_Cotizacion
		);
	END
	ELSE
	BEGIN
		DECLARE @ID_Secuencia_Empleo_Bitacora INT = 53,
                @Id_Bitacora INT = 0;

		EXEC proc_Orgn_Numero_Secuencia_Extrae @ID_Secuencia_Empleo_Bitacora,'S',1,@Num_Secuencia = @Id_Bitacora OUTPUT;

		INSERT INTO [dbo].[Pers_Empleo_Bitacora]
		(
		    [Id_Bitacora],
		    [ID_Empleo],
		    [Id_Convenio],
		    [ID_Persona],
		    [ID_Dependencia],
		    [ID_Area],
		    [Nombre_Dependencia],
		    [Dependencia_Empresa],
		    [Nombre_Area],
		    [Puesto],
		    [Cod_Tipo_Empleado],
		    [Cod_Sub_Tipo_Empleado],
		    [Clave_Empleado],
		    [Jefe_Inmediato],
		    [Sueldo],
		    [Telefono],
		    [Fecha_Ingreso],
		    [Fecha_Vigencia],
		    [Ind_Activo],
		    [Fecha_Registro],
		    [Fecha_Ult_Cambio],
		    [Fecha_Registro_Cambio],
		    [Id_Referencia],
		    [Cod_Ind_Congelado],
		    [Id_Tipo_Empleado_Cotizacion]
		)
		SELECT 
		    @Id_Bitacora AS [Id_Bitacora],
		    [ID_Empleo],
		    [Id_Convenio],
		    [ID_Persona],
		    [ID_Dependencia],
		    [ID_Area],
		    [Nombre_Dependencia],
		    [Dependencia_Empresa],
		    [Nombre_Area],
		    [Puesto],
		    [Cod_Tipo_Empleado],
		    [Cod_Sub_Tipo_Empleado],
		    [Clave_Empleado],
		    [Jefe_Inmediato],
		    [Sueldo],
		    [Telefono],
		    [Fecha_Ingreso],
		    [Fecha_Vigencia],
		    [Ind_Activo],
		    [Fecha_Registro],
		    [Fecha_Ult_Cambio],
		    GETDATE() AS [Fecha_Registro_Cambio],
		    NULL AS [Id_Referencia],
		    NULL AS [Cod_Ind_Congelado],
		    [Id_Tipo_Empleado_Cotizacion]
		FROM [dbo].[Pers_Empleo]
		WHERE [ID_Empleo] = @ID_Empleo;

		UPDATE [dbo].[Pers_Empleo]
		SET 
			 [Id_Convenio] = @Id_Convenio
			,[Id_Persona] = @Id_Persona
			,[ID_Dependencia] = @ID_Dependencia
			,[ID_Area] = @ID_Area
			,[Nombre_Dependencia] = @Nombre_Dependencia
			,[Dependencia_Empresa] = @Dependencia_Empresa
			,[Nombre_Area] = @Nombre_Area
			,[Puesto] = @Puesto
			,[Cod_Tipo_Empleado] = @Cod_Tipo_Empleado
			,[Cod_Sub_Tipo_Empleado] = @Cod_Sub_Tipo_Empleado
			,[Clave_Empleado] = @Clave_Empleado
			,[Jefe_Inmediato] = @Jefe_Inmediato
			,[Sueldo] = @Sueldo
			,[Telefono] = @Telefono
			,[Fecha_Ingreso] = @Fecha_Ingreso
			,[Fecha_Vigencia] = @Fecha_Vigencia
			,[Ind_Activo] = @Ind_Activo
			,[Fecha_Ult_Cambio] = @Fecha_Ult_Cambio
            ,[Id_Tipo_Empleado_Cotizacion] = @Id_Tipo_Empleado_Cotizacion
		WHERE [ID_Empleo] = @ID_Empleo;
	END

	IF @RegresaDatos = 1 
	BEGIN
		SELECT @ID_Empleo AS ID_Empleo;
	END
END
GO
