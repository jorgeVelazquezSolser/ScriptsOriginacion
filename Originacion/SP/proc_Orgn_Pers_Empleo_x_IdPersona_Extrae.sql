USE Originacion

ALTER PROCEDURE [dbo].[proc_Orgn_Pers_Empleo_x_IdPersona_Extrae](
	@ID_Persona INT,
	@Id_Credito INT = 0
)
AS
BEGIN
	PRINT('Check Crédito Cerrado');

	IF EXISTS (
		SELECT cc.Id_Entidad
		FROM CR_Credito_Cerrado AS cc
		INNER JOIN Pers_Empleo_Bitacora AS empBit
            ON cc.ID_Persona = empBit.Id_Persona 
		   AND cc.ID_Credito = empBit.Id_Referencia 
		   AND empBit.Cod_Ind_Congelado = 'S'
		WHERE cc.Id_Tipo_Entidad = 4
          AND cc.ID_Credito = @Id_Credito
          AND cc.ID_Persona = @Id_Persona
	)
	BEGIN
		PRINT('<Datos Empleo Congelado>');

		SELECT   [ID_Empleo],
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
                 [Id_Tipo_Empleado_Cotizacion],
				 [Id_Referencia],
				 [Cod_Ind_Congelado]
		FROM [dbo].[Pers_Empleo_Bitacora]
		WHERE [Id_Referencia] = @Id_Credito
          AND [ID_Persona] = @ID_Persona
		  AND [Ind_Activo] = 1;
	END
	ELSE
	BEGIN
		PRINT('<Datos Empleo VIVO>');

		SELECT   [ID_Empleo],
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
                 [Id_Tipo_Empleado_Cotizacion],
				 NULL AS [Id_Referencia],
				 NULL AS [Cod_Ind_Congelado]
		FROM [dbo].[Pers_Empleo]
		WHERE [ID_Persona] = @ID_Persona
		  AND [Ind_Activo] = 1;
	END
END
GO