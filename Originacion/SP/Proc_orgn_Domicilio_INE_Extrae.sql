USE [Originacion]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE Proc_orgn_Domicilio_INE_Extrae
	@_calle VARCHAR(500) 
	,@_colonia VARCHAR(500) 
	,@_ciudad VARCHAR(500) 

AS
DECLARE
	@Calle VARCHAR(50)
	,@Numero_Exterior VARCHAR(50)
	,@Colonia VARCHAR(50)
	,@CP VARCHAR(50)
	,@Municipio VARCHAR(50)
	,@Cve_Estado VARCHAR(50)
	,@Estado VARCHAR(50)
	,@Id_Colonia INT
	,@Id_Municipio INT
	,@Cod_Estado SMALLINT
DECLARE
	@ini INT, @end INT
	,@SPACE CHAR(1) = ' '
	,@COMMA CHAR(1) = ','
	,@PERIOD CHAR(1) = '.'

BEGIN
	-- Calle
	SET @ini = CHARINDEX(@SPACE, @_calle) + 1
	SET @end = LEN(@_calle) - CHARINDEX(@SPACE, REVERSE(@_calle)) - CHARINDEX(@SPACE, @_calle)
	SET @Calle = SUBSTRING(@_calle,@ini, @end)

	-- Numero Exterior
	SET @ini = LEN(@_calle) - CHARINDEX(@SPACE, REVERSE(@_calle)) + 2
	SET @end = LEN(@_calle) - @ini + 1
	SET @Numero_Exterior = SUBSTRING(@_calle,@ini, @end)

	-- Colonia
	SET @ini = CHARINDEX(@SPACE, @_colonia) + 1
	SET @end = LEN(@_colonia) - CHARINDEX(@SPACE, REVERSE(@_colonia)) - CHARINDEX(@SPACE, @_colonia)
	SET @Colonia = SUBSTRING(@_colonia,@ini, @end)

	-- CP
	SET @ini = LEN(@_colonia)- CHARINDEX(@SPACE, REVERSE(@_colonia)) + 2
	SET @end = LEN(@_colonia) - @ini + 1
	SET @CP = SUBSTRING(@_colonia,@ini, @end)

	-- Municipio
	SET @ini = 0
	SET @end = CHARINDEX(@COMMA, @_ciudad)
	SET @Municipio = SUBSTRING(@_ciudad,@ini, @end)

	-- Estado
	SET @ini = CHARINDEX(@COMMA, @_ciudad) + 2
	SET @end = CHARINDEX(@PERIOD, @_ciudad) - @ini
	SET @Cve_Estado = SUBSTRING(@_ciudad,@ini, @end)

	SELECT @Cod_Estado = Cod_Edo_Region, @Estado = Nombre
	FROM TR_Edo_Region
	WHERE Cve_CNBV=@Cve_Estado

	SELECT @Id_Municipio = ID_Municipio
	FROM TR_Municipio
	WHERE Cod_Edo_Region = @Cod_Estado
		AND Nombre=@Municipio

	SELECT @Id_Colonia = ID_Colonia
	FROM TR_Colonia
	WHERE ID_Municipio=@Id_Municipio
		AND CP=@CP
		AND TRANSLATE(Nombre, N'יאמפü', N'eaiou')=@Colonia

	SELECT 
		0 AS Id_Direccion, CAST(1 AS BIT) AS Ind_Catalogado,@Id_Colonia AS Id_Colonia,0 AS Id_Delegacion,@Id_Municipio AS Id_Municipio,@Cod_Estado AS Id_Edo_Region,CAST(82 AS SMALLINT) AS Cod_Pais_ISO,1 AS Cod_Tipo_Domicilio,'01' AS Cod_Situacion_Domicilio
		,@Calle AS Calle,@Numero_Exterior AS Numero_Ext,'' AS Numero_Int
		,'' AS Unidad_Habitacional,'' AS Edificio,'' AS Piso, '' AS Departamento, '' AS Casa,'' AS Lote,'' AS Manzana
		,@CP AS Codigo_Postal,@Colonia AS Colonia,'' AS Localidad,'' AS Delegacion,@Municipio AS Municipio,@Estado AS Edo_Region,'MEX' AS Pais
		,'' AS EntreCalles,1 AS Cod_Ecv_Direccion
		,NULL AS Fecha_Ult_Accion,'' AS Cod_Ult_Accion,'' AS Tipo_Domicilio,'' AS Situacion_Domicilio,0 AS Id_Persona
		,NULL AS Fecha_Inicio_Residencia,NULL AS Fecha_Fin_Residencia,NULL AS Fecha_Registro,NULL AS Fecha_Valido_Desde,NULL AS Fecha_Valido_Hasta,NULL AS Fecha_Ult_Cambio
		,CAST(1 AS SMALLINT) AS Version, 1 AS Prioridad,'' AS Latitud,'' AS Longitud
		

END
