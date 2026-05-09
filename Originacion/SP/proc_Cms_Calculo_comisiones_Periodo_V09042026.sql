CREATE OR ALTER PROCEDURE [dbo].[proc_Cms_Calculo_comisiones_Periodo_V09042026](
--DECLARE
		 @Num_Periodo_Anual Int --= 5  -- Numero de semana del año
		, @Cod_tipo_comision CHAR(2) --= '01'   -- Originación consumo
		, @Anio int --= 2026
		, @Cod_Accion_Realizar CHAR(1) = 'N'   --N: Nuevo, R: Reprocesar
		, @Id_Usuario int --= 0
		, @Id_Proceso_Comisiones Int = 0
)
AS 
BEGIN
/*
	DECLARE @Num_Periodo_Anual Int --= 33  -- Numero de semana del año
		, @Cod_tipo_comision CHAR(2) --= '01'   -- Originación consumo
		, @Anio int
		, @Cod_Accion_Realizar CHAR(1) = 'N'   --N: Nuevo, R: Reprocesar
		, @Id_Usuario int
		, @Id_Proceso_Comisiones Int = 0

	SELECT 
		@Num_Periodo_Anual = 34  -- Numero de semana del año
		, @Cod_tipo_comision = '01'   -- Originación consumo
		, @Anio = 2024
		, @Cod_Accion_Realizar = 'R' --'N'   --N: Nuevo, R: Reprocesar
		, @Id_Usuario = 0
		, @Id_Proceso_Comisiones = 1000029
*/

	DECLARE	 @Fecha_ini_Calculo DATE
			, @Fecha_fin_Calculo DATE
			, @Cod_Calendario CHAR(2)
			, @Cod_ECV_Proceso CHAR(2)
			, @Id_Periodo Int
			, @Estatus Int
			, @Accion CHAR(1)
			, @ECV_Abierto CHAR(2) = '01'
			, @ECV_Cancelado CHAR(2) = '03'
			, @Fecha_Proceso DATETIME
			, @Limite_Inferior DECIMAL(18,2)
			, @Porcentaje_Incentivo_Nuevo DECIMAL(18,12)
			, @Porcentaje_Incentivo_Renovado DECIMAL(18,12)

	DECLARE @ID_Secuencia Int = 38 -- 'Proceso de Cálculo de Comisiones'  

	-- Valida si se proporciono el id del proceso de comisiones, de ser asi, extrae los datos del preceso ignorando los volares proporcionado,
	-- es decir, se da prioridad al proceso proporcionado..

	-- En caso que se encuentre el proceso, depenera del estatus para reporcsarlo o no. Proceso cerrado no se puede reprcesar
	-- En caso que no se encuentre el proceso, se verificará que no exista uno ya procesado con las mismas caracteristicas, de ya ser asi se ignorará

	--Estatus
	-- -1) No existe el proporcionado
	-- -2) Ya existe uno igual
	-- -3) Existe pero ya esta cerrado
	--  1) Ya Existe el proporcionado
	--  2) Creado nuevo
	--  3) Reprocesado
	--  0) No existe uno activo o cerrado con las mismas caracteristicas

	SELECT @Limite_Inferior = ValorEntero FROM Tr_Parametros_Generales prm1 WHERE prm1.IdParametro=19
	SELECT @Porcentaje_Incentivo_Nuevo = ValorEntero/100.0 FROM Tr_Parametros_Generales WHERE IdParametro=20
	SELECT @Porcentaje_Incentivo_Renovado = ValorEntero/100.0 FROM Tr_Parametros_Generales WHERE IdParametro=21



	IF @Id_Proceso_Comisiones != 0
	BEGIN
		SELECT @Anio= NULL
				, @Num_Periodo_Anual = NULL
				, @Cod_Tipo_Comision = NULL
				, @Cod_ECV_Proceso = NULL
				, @Estatus = -1   --No existe el periodo

		--Extare los valores del proceso y el estatus
		SELECT @Id_Periodo = Id_Periodo
			, @Anio = Anio
			, @Num_Periodo_Anual = Num_Periodo_Anual
			, @Cod_Tipo_Comision= Cod_Tipo_Comision
			, @Cod_ECV_Proceso = Cod_ECV_Proceso_Comisiones
			, @Estatus = 1  -- Existe el proporcionado
		 FROM cms_Comisiones_Procesadas
		 WHERE Id_Proceso_Comisiones = @Id_Proceso_Comisiones
	END
	ELSE -- no se proporciono el ID_proeso. Se verificará que no exista alguno con las mismas caracteristicas
	BEGIN
		SELECT @Estatus = 0   --No existe uno abierto o cerrado con las mismas caracteristias

		SELECT @Id_Periodo = Id_Periodo
			, @Anio = Anio
			, @Num_Periodo_Anual = Num_Periodo_Anual
			, @Cod_Tipo_Comision = Cod_Tipo_Comision
			, @Cod_ECV_Proceso = Cod_ECV_Proceso_Comisiones
			, @Estatus = -2  -- Ya Existe uno igual
		 FROM cms_Comisiones_Procesadas
		 WHERE Cod_Tipo_Comision = @Cod_tipo_comision
		   AND Anio = @Anio
		   AND Num_Periodo_Anual = @Num_Periodo_Anual
		   AND Cod_ECV_Proceso_Comisiones != @ECV_Cancelado
	END --- Si no se proporcino Id_Proceso

	
	SELECT @Accion = CASE @Cod_Accion_Realizar 
							WHEN 'N' THEN CASE WHEN @Id_Proceso_Comisiones = 0 THEN
													CASE WHEN @Estatus = 0  --No existe uno igual
														 THEN 'N' --Nuevo, No existe con las mismas condiciones abierto o cerrado
														 ELSE 'S' -- Salir
													END
							                   WHEN @Id_Proceso_Comisiones > 0 THEN 'S' -- Salir  , No se puede crear un proceso dando un numero de proceso 
											   ELSE 'S'   --Salir
											END
							WHEN 'R' THEN
											CASE WHEN @Id_Proceso_Comisiones = 0 THEN 'S'   -- No se puede reprocesar sin indicar que proceso
												 WHEN @Id_Proceso_Comisiones > 0 THEN
													CASE WHEN @Estatus = 1 AND  @Cod_ECV_Proceso = @ECV_Abierto
														 THEN 'R' --Reprocesar si existe uno abierto
														 ELSE 'S' -- Salir
													END
											 END
							 ELSE 'S'   --Salir
					END
	IF @Accion = 'N' OR  @Accion = 'R'
	BEGIN
		IF @Accion = 'N'
			EXEC proc_Orgn_Numero_Secuencia_Extrae @ID_Secuencia,'S',1,@Num_Secuencia = @Id_Proceso_Comisiones Output
		

		SELECT @Cod_Calendario =  Cod_Calendario FROM cms_TR_Tipos_Comisiones WHERE Cod_tipo_Comision = @Cod_tipo_comision 

		SELECT	@Id_Periodo = ID_Periodo
				, @Fecha_ini_Calculo = Fecha_inicial
				, @Fecha_fin_Calculo = Fecha_Final
		FROM cms_TR_Periodos_Calendario
		WHERE Cod_Frecuencia = @Cod_Calendario AND Num_Periodo_Anual = @Num_Periodo_Anual

		IF @Accion = 'R'
		BEGIN
			DELETE cms_Creditos_Periodo WHERE Id_Proceso_Comisiones = @Id_Proceso_Comisiones
			DELETE Cms_Resumen_Comisiones WHERE Id_Proceso_Comisiones = @Id_Proceso_Comisiones
	
			SELECT @Fecha_Proceso = GETDATE()

			UPDATE cms_Comisiones_Procesadas SET 	
				Id_Periodo  		 =	@Id_Periodo  
				,Anio  				 =	@Anio  
				,Num_Periodo_Anual   =	@Num_Periodo_Anual  
				,Cod_Tipo_Comision 	 =	@Cod_Tipo_Comision
				,Fecha_Inicial 		 =	@Fecha_ini_Calculo 
				,Fecha_Final 		 =	@Fecha_fin_Calculo
				,Fecha_Proceso 		 =	@Fecha_Proceso 
				,Cod_ECV_Proceso_Comisiones = @ECV_Abierto
				,Id_Usuario 		 =	@Id_Usuario 
			WHERE Id_Proceso_Comisiones = @Id_Proceso_Comisiones 

			SELECT @Estatus =3

	--  2) Creado nuevo
	--  3) Reprocesado
	--  0) No existe uno activo o cerrado con las mismas caracteristicas

		END
		ELSE
		BEGIN
			SELECT @Fecha_Proceso = GETDATE()

			INSERT cms_Comisiones_Procesadas (
				Id_Proceso_Comisiones 
				,Id_Periodo  
				,Anio  
				,Num_Periodo_Anual  
				,Cod_Tipo_Comision 
				,Fecha_Inicial 
				,Fecha_Final 
				,Fecha_Proceso 
				,Cod_ECV_Proceso_Comisiones 
				,Id_Usuario 
			) VALUES (
				@Id_Proceso_Comisiones 
				,@Id_Periodo  
				,@Anio  
				,@Num_Periodo_Anual  
				,@Cod_Tipo_Comision
				,@Fecha_Ini_Calculo
				,@Fecha_fin_Calculo 
				,@Fecha_Proceso 
				,@ECV_Abierto 
				,@Id_Usuario )

			SELECT @Estatus = 2
				, @Cod_ECV_Proceso = '01'
		END

		-- Busca las personas del crédito
		SELECT cr.ID_Credito
			,pp.Id_Persona
			,(SELECT COUNT(1)
				FROM CR_Credito
				INNER JOIN Pers_Persona ON CR_Credito.ID_Persona = Pers_Persona.Id_Persona
				WHERE
					pp.Primer_Nombre	= Pers_Persona.Primer_Nombre
					AND pp.Segundo_Nombre	= Pers_Persona.Segundo_Nombre
					AND pp.Primer_Apellido	= Pers_Persona.Primer_Apellido
					AND pp.Segundo_Apellido	= Pers_Persona.Segundo_Apellido
					AND pp.Fecha_Nacimiento = Pers_Persona.Fecha_Nacimiento
					AND CR_Credito.Cod_Etapa = '08'
					AND CR_Credito.ID_Credito <> cr.ID_Credito
					
			) creditos_anteriores
		INTO #temp_personas 
		FROM Pagos_Solicitudes_Pagos spg 
		INNER JOIN CR_Credito cr ON spg.id_credito  = cr.id_credito
				AND  spg.fecha_solicitud_pago >= @Fecha_ini_Calculo AND CONVERT(DATE,fecha_solicitud_pago) <=  CONVERT(DATE,@Fecha_fin_Calculo)
				AND cr.ID_Credito >= 1000000
				AND ( codigo_ecv_pagos  = '01'  -- solicitado
					OR Codigo_Ecv_Pagos =  '03'  -- Operado no dispersado
					OR Codigo_Ecv_Pagos =  '04'  -- Operado dispersado
					OR Codigo_Ecv_Pagos =  '07')  -- Conciliado
		INNER JOIN Pers_Persona pp ON cr.ID_Persona = pp.Id_Persona 
		-- Fin busca

		INSERT INTO cms_Creditos_Periodo
		SELECT @Id_Proceso_Comisiones AS Id_Proceso_Comisiones
			, cr.Id_credito
			, spg.Id_Compra_Deuda
			, cr.ID_Ejecutivo_Ventas
			, cms.Identifier
			, @Anio AS Anio
			, @Num_Periodo_Anual AS Num_Periodo_Anual
			, spg.Fecha_Solicitud_Pago Feha_Dispersion
			, @Cod_tipo_comision AS Cod_tipo_comision
			, @Fecha_Ini_Calculo AS Fecha_Ini_Periodo
			, @Fecha_Fin_Calculo AS Fecha_Fin_Periodo
			, cr.Fecha_Operacion
			, cr.Importe AS Importe_Otorgado
			, cr.Plazo AS Plazo
			, cr.Importe_Renovacion AS Importe_Renovacion
			, cr.Importe_Dispersion AS Importe_Dispersado
			, cr.Importe_Compra_Deuda  AS Importe_compra_Deuda
			, cr.Importe_Movto_Interno AS Importe_Movto_Interno
			, spg.Importe_Solicitado
			, spg.Importe_Solicitado AS Importe_Base_Comision
			, CONVERT(DECIMAL(18,10), 0) AS Factor_Ponderacion
			, CONVERT(DECIMAL(18,2), 0) AS Monto_Comision
			, CONVERT(DECIMAL(18,2), 0) AS Monto_Comision_Ajuste
			, CONVERT(DECIMAL(18,2), 0) AS Imp_Amortizacion
			, CONVERT(DECIMAL(18,2), 0) AS Imp_Ult_Amortizacion
			, usr.id_usuario
			, usr.Nombre AS Nombre_Usuario
			, '01' AS Cod_Estatus
			, '01' AS Cod_Estatus_Previo
			, NULL AS Id_Proceso_Comisiones_Previo
			, acms.Cod_Rango_Comision
			, acms.Cod_Puesto
			, acms.Cod_Alcance_Comision
			, RANK () OVER
			(PARTITION BY cr.ID_ejecutivo_Ventas ORDER BY ISNULL(cr.Importe_Dispersion, 0) + ISNULL(cr.Importe_Compra_Deuda, 0) DESC,cr.id_credito) AS Rank 
			, '' AS Clase
		FROM Pagos_Solicitudes_Pagos spg 
		INNER JOIN CR_Credito cr ON spg.id_credito  = cr.id_credito
			 AND  spg.fecha_solicitud_pago >= @Fecha_ini_Calculo AND CONVERT(DATE,fecha_solicitud_pago) <=  CONVERT(DATE,@Fecha_fin_Calculo)
			 AND cr.ID_Credito >= 1000000
			 AND ( codigo_ecv_pagos  = '01'  -- solicitado
					OR Codigo_Ecv_Pagos =  '03'  -- Operado no dispersado
					OR Codigo_Ecv_Pagos =  '04'  -- Operado dispersado
					OR Codigo_Ecv_Pagos =  '07')  -- Conciliado

		LEFT JOIN Usr_Usuarios usr ON cr.id_usuario = usr.id_usuario
		LEFT JOIN cms_TR_Comisionistas cms ON cr.ID_ejecutivo_Ventas = cms.ID_ejecutivo_Ventas
		LEFT JOIN cms_TR_Puestos pt ON cms.position_name = pt.Nom_Puesto
		LEFT JOIN cms_TR_Alcance_Comisiones acms ON pt.cod_Puesto = acms.Cod_Puesto AND acms.Cod_tipo_Comision = @Cod_tipo_comision 
		WHERE (( cr.id_usuario IS NULL		--25Mar2025 Se agrego para que incluyera todos los creditos aun cuando los comisionistas tengan omisiones
	          OR usr.id_usuario IS NULL 
			  OR cr.ID_ejecutivo_Ventas IS NULL 
			  OR cms.ID_ejecutivo_Ventas IS NULL 
			  OR acms.Cod_tipo_Comision IS NULL
			)
			OR (acms.Cod_Alcance_Comision = '01'  AND ISNULL(acms.Ind_Activo, 0) = 1))

		UNION ALL
		SELECT @Id_Proceso_Comisiones
			, cr.Id_credito
			, spg.Id_Compra_Deuda
			, cr.ID_Ejecutivo_Ventas
			, cms.Identifier
			, @Anio AS Anio
			, @Num_Periodo_Anual AS Num_Periodo_Anual
			, spg.Fecha_Solicitud_Pago Feha_Dispersion
			, @Cod_tipo_comision AS Cod_tipo_comision
			, @Fecha_Ini_Calculo AS Fecha_Ini_Periodo
			, @Fecha_Fin_Calculo AS Fecha_Fin_Periodo
			, cr.Fecha_Operacion
			, cr.Importe AS Importe_Otorgado
			, cr.Plazo AS Plazo
			, cr.Importe_Renovacion AS Importe_Renovacion
			, cr.Importe_Dispersion AS Importe_Dispersado
			, cr.Importe_Compra_Deuda  AS Importe_compra_Deuda
			, cr.Importe_Movto_Interno AS Importe_Movto_Interno
			, spg.Importe_Solicitado
			, spg.Importe_Solicitado AS Importe_Base_Comision
			, CONVERT(DECIMAL(18,10), 0) AS Factor_Ponderacion
			, CONVERT(DECIMAL(18,2), 0) AS Monto_Comision
			, CONVERT(DECIMAL(18,2), 0) AS Monto_Comision_Ajuste
			, CONVERT(DECIMAL(18,2), 0) AS Imp_Amortizacion
			, CONVERT(DECIMAL(18,2), 0) AS Imp_Ult_Amortizacion
			, usr.id_usuario
			, usr.Nombre AS Nombre_Usuario
			, '01' AS Cod_Estatus
			, '01' AS Cod_Estatus_Previo
			, NULL AS Id_Proceso_Comisiones_Previo
			, acms.Cod_Rango_Comision
			, acms.Cod_Puesto
			, acms.Cod_Alcance_Comision
			, RANK () over
			(PARTITION BY cr.ID_ejecutivo_Ventas ORDER BY ISNULL(cr.Importe_Dispersion, 0) + ISNULL(cr.Importe_Compra_Deuda, 0) DESC,cr.id_credito) AS Rank 
			, '' AS Clase
		FROM Pagos_Solicitudes_Pagos spg 
		INNER JOIN CR_Credito cr ON spg.id_credito  = cr.id_credito
			 AND  spg.fecha_solicitud_pago >= @Fecha_ini_Calculo AND CONVERT(DATE,fecha_solicitud_pago) <=  CONVERT(DATE,@Fecha_fin_Calculo)
			 AND cr.ID_Credito >= 1000000
			 AND ( codigo_ecv_pagos  = '01'  -- solicitado
					OR Codigo_Ecv_Pagos =  '03'  -- Operado no dispersado
					OR Codigo_Ecv_Pagos =  '04'  -- Operado dispersado
					OR Codigo_Ecv_Pagos =  '07')  -- Conciliado

		LEFT JOIN Usr_Usuarios usr ON cr.id_usuario = usr.id_usuario
		LEFT JOIN cms_TR_Comisionistas cms ON cr.ID_ejecutivo_Ventas = cms.ID_ejecutivo_Ventas
		LEFT JOIN cms_TR_Puestos pt ON cms.position_name = pt.Nom_Puesto
		LEFT JOIN cms_TR_Alcance_Comisiones acms ON pt.cod_Puesto = acms.Cod_Puesto AND acms.Cod_tipo_Comision = @Cod_tipo_comision
		LEFT JOIN cms_TR_Alcance_Cnvs_Excluidos cnvex ON acms.Cod_Puesto = cnvex.cod_puesto 
		              AND cr.ID_Convenio = cnvex.id_Convenio 
					  AND cnvex.fecha_Aplicacion <= CONVERT(DATE, spg.Fecha_Solicitud_Pago)
					  AND ISNULL(cnvex.Ind_Activo, 0) = 1
		WHERE (( cr.id_usuario IS NULL 
				  OR usr.id_usuario IS NULL 
				  OR cr.ID_ejecutivo_Ventas IS NULL 
				  OR cms.ID_ejecutivo_Ventas IS NULL 
				  OR acms.Cod_tipo_Comision IS NULL
			   )
			 OR (acms.Cod_Alcance_Comision = '02'  AND ISNULL(acms.Ind_Activo, 0) = 1) AND cnvex.id_convenio IS NULL)

		UNION ALL
		SELECT @Id_Proceso_Comisiones
			, cr.Id_credito 
			, spg.Id_Compra_Deuda
			, cr.ID_Ejecutivo_Ventas
			, cms.Identifier
			, @Anio AS Anio
			, @Num_Periodo_Anual AS Num_Periodo_Anual
			, spg.Fecha_Solicitud_Pago Feha_Dispersion
			, @Cod_tipo_comision AS Cod_tipo_comision
			, @Fecha_Ini_Calculo AS Fecha_Ini_Periodo
			, @Fecha_Fin_Calculo AS Fecha_Fin_Periodo
			, cr.Fecha_Operacion
			, cr.Importe AS Importe_Otorgado
			, cr.Plazo AS Plazo
			, cr.Importe_Renovacion AS Importe_Renovacion
			, cr.Importe_Dispersion AS Importe_Dispersado
			, cr.Importe_Compra_Deuda  AS Importe_compra_Deuda
			, cr.Importe_Movto_Interno AS Importe_Movto_Interno
			, spg.Importe_Solicitado
			, spg.Importe_Solicitado AS Importe_Base_Comision
			, CONVERT(DECIMAL(18,10), 0) AS Factor_Ponderacion
			, CONVERT(DECIMAL(18,2), 0) AS Monto_Comision
			, CONVERT(DECIMAL(18,2), 0) AS Monto_Comision_Ajuste
			, CONVERT(DECIMAL(18,2), 0) AS Imp_Amortizacion
			, CONVERT(DECIMAL(18,2), 0) AS Imp_Ult_Amortizacion
			, usr.id_usuario
			, usr.Nombre AS Nombre_Usuario
			, '01' AS Cod_Estatus
			, '01' AS Cod_Estatus_Previo
			, NULL AS Id_Proceso_Comisiones_Previo
			, acms.Cod_Rango_Comision
			, acms.Cod_Puesto
			, acms.Cod_Alcance_Comision
			, RANK () over
			(PARTITION BY cr.ID_ejecutivo_Ventas ORDER BY ISNULL(cr.Importe_Dispersion, 0) + ISNULL(cr.Importe_Compra_Deuda, 0) DESC,cr.id_credito) AS Rank 
			, '' AS Clase
		FROM Pagos_Solicitudes_Pagos spg 
		INNER JOIN CR_Credito cr ON spg.id_credito  = cr.id_credito
			 AND  spg.fecha_solicitud_pago >= @Fecha_ini_Calculo AND CONVERT(DATE,fecha_solicitud_pago) <=  CONVERT(DATE,@Fecha_fin_Calculo)
			 AND cr.ID_Credito >= 1000000
			 AND ( codigo_ecv_pagos  = '01'  -- solicitado
					OR Codigo_Ecv_Pagos =  '03'  -- Operado no dispersado
					OR Codigo_Ecv_Pagos =  '04'  -- Operado dispersado
					OR Codigo_Ecv_Pagos =  '07')  -- Conciliado

		LEFT JOIN Usr_Usuarios usr ON cr.id_usuario = usr.id_usuario
		LEFT JOIN cms_TR_Comisionistas cms ON cr.ID_ejecutivo_Ventas = cms.ID_ejecutivo_Ventas
		LEFT JOIN cms_TR_Puestos pt ON cms.position_name = pt.Nom_Puesto
		LEFT JOIN cms_TR_Alcance_Comisiones acms ON pt.cod_Puesto = acms.Cod_Puesto AND acms.Cod_tipo_Comision = @Cod_tipo_comision
		LEFT JOIN cms_TR_Alcance_Cnvs_Incluidos cnvin ON acms.Cod_Puesto = cnvin.cod_puesto 
		              AND cr.ID_Convenio = cnvin.id_Convenio 
					  AND cnvin.fecha_Aplicacion <= CONVERT(DATE, spg.Fecha_Solicitud_Pago)
					  AND ISNULL(cnvin.ind_activo, 0) = 1
		WHERE (( cr.id_usuario IS NULL 
				  OR usr.id_usuario IS NULL 
				  OR cr.ID_ejecutivo_Ventas IS NULL 
				  OR cms.ID_ejecutivo_Ventas IS NULL 
				  OR acms.Cod_tipo_Comision IS NULL
			   )
			 OR (acms.Cod_Alcance_Comision = '03'  AND ISNULL(acms.Ind_Activo, 0) = 1) AND cnvin.id_convenio IS NOT NULL)

		UNION ALL
		SELECT -- Créditos nuevos
			@Id_Proceso_Comisiones AS Id_Proceso_Comisiones
			, cr.Id_credito
			, spg.Id_Compra_Deuda
			, cr.ID_Ejecutivo_Ventas
			, cms.Identifier
			, @Anio AS Anio
			, @Num_Periodo_Anual AS Num_Periodo_Anual
			, spg.Fecha_Solicitud_Pago Feha_Dispersion
			, @Cod_tipo_comision AS Cod_tipo_comision
			, @Fecha_Ini_Calculo AS Fecha_Ini_Periodo
			, @Fecha_Fin_Calculo AS Fecha_Fin_Periodo
			, cr.Fecha_Operacion
			, cr.Importe AS Importe_Otorgado
			, cr.Plazo AS Plazo
			, cr.Importe_Renovacion AS Importe_Renovacion
			, cr.Importe_Dispersion AS Importe_Dispersado
			, cr.Importe_Compra_Deuda  AS Importe_compra_Deuda
			, cr.Importe_Movto_Interno AS Importe_Movto_Interno
			, spg.Importe_Solicitado
			, spg.Importe_Solicitado AS Importe_Base_Comision
			, CONVERT(DECIMAL(18,10), 0) AS Factor_Ponderacion
			, CONVERT(DECIMAL(18,2), 0) AS Monto_Comision
			, CONVERT(DECIMAL(18,2), 0) AS Monto_Comision_Ajuste
			, CONVERT(DECIMAL(18,2), 0) AS Imp_Amortizacion
			, CONVERT(DECIMAL(18,2), 0) AS Imp_Ult_Amortizacion
			, usr.id_usuario
			, usr.Nombre AS Nombre_Usuario
			, '01' AS Cod_Estatus
			, '01' AS Cod_Estatus_Previo
			, NULL AS Id_Proceso_Comisiones_Previo
			, acms.Cod_Rango_Comision
			, acms.Cod_Puesto
			, acms.Cod_Alcance_Comision
			, RANK () OVER
			(PARTITION BY cr.ID_ejecutivo_Ventas ORDER BY ISNULL(cr.Importe_Dispersion, 0) + ISNULL(cr.Importe_Compra_Deuda, 0) DESC,cr.id_credito) AS Rank 
			, 'NC' AS Clase
		FROM Pagos_Solicitudes_Pagos spg 
			INNER JOIN CR_Credito cr ON spg.id_credito  = cr.id_credito
				AND  spg.fecha_solicitud_pago >= @Fecha_ini_Calculo AND CONVERT(DATE,fecha_solicitud_pago) <=  CONVERT(DATE,@Fecha_fin_Calculo)
				AND cr.ID_Credito >= 1000000
				AND ( codigo_ecv_pagos  = '01'  -- solicitado
					OR Codigo_Ecv_Pagos =  '03'  -- Operado no dispersado
					OR Codigo_Ecv_Pagos =  '04'  -- Operado dispersado
					OR Codigo_Ecv_Pagos =  '07')  -- Conciliado
				AND cr.Importe_Renovacion=0 AND cr.Importe_Movto_Interno=0
		LEFT JOIN Usr_Usuarios usr ON cr.id_usuario = usr.id_usuario
		LEFT JOIN cms_TR_Comisionistas cms ON cr.ID_ejecutivo_Ventas = cms.ID_ejecutivo_Ventas
		LEFT JOIN cms_TR_Puestos pt ON cms.position_name = pt.Nom_Puesto
		INNER JOIN cms_TR_Alcance_Comisiones acms ON pt.cod_Puesto = acms.Cod_Puesto AND acms.Cod_tipo_Comision = '01' AND acms.Cod_Rango_Comision=14 AND acms.Cod_Alcance_Comision = '04'
		LEFT JOIN #temp_personas tp ON tp.ID_Credito = cr.ID_Credito AND tp.creditos_anteriores = 0
		WHERE (( cr.id_usuario IS NULL		--25Mar2025 Se agrego para que incluyera todos los creditos aun cuando los comisionistas tengan omisiones
				OR usr.id_usuario IS NULL 
				OR cr.ID_ejecutivo_Ventas IS NULL 
				OR cms.ID_ejecutivo_Ventas IS NULL 
				OR acms.Cod_tipo_Comision IS NULL
			)
			OR (acms.Cod_Alcance_Comision = '04' AND ISNULL(acms.Ind_Activo, 0) = 1))

		UNION ALL
		SELECT -- créditos renovados
			@Id_Proceso_Comisiones AS Id_Proceso_Comisiones
			, cr.Id_credito
			, spg.Id_Compra_Deuda
			, cr.ID_Ejecutivo_Ventas
			, cms.Identifier
			, @Anio AS Anio
			, @Num_Periodo_Anual AS Num_Periodo_Anual
			, spg.Fecha_Solicitud_Pago Feha_Dispersion
			, @Cod_tipo_comision AS Cod_tipo_comision
			, @Fecha_Ini_Calculo AS Fecha_Ini_Periodo
			, @Fecha_Fin_Calculo AS Fecha_Fin_Periodo
			, cr.Fecha_Operacion
			, cr.Importe AS Importe_Otorgado
			, cr.Plazo AS Plazo
			, cr.Importe_Renovacion AS Importe_Renovacion
			, cr.Importe_Dispersion AS Importe_Dispersado
			, cr.Importe_Compra_Deuda  AS Importe_compra_Deuda
			, cr.Importe_Movto_Interno AS Importe_Movto_Interno
			, spg.Importe_Solicitado
			, spg.Importe_Solicitado AS Importe_Base_Comision
			, CONVERT(DECIMAL(18,10), 0) AS Factor_Ponderacion
			, CONVERT(DECIMAL(18,2), 0) AS Monto_Comision
			, CONVERT(DECIMAL(18,2), 0) AS Monto_Comision_Ajuste
			, CONVERT(DECIMAL(18,2), 0) AS Imp_Amortizacion
			, CONVERT(DECIMAL(18,2), 0) AS Imp_Ult_Amortizacion
			, usr.id_usuario
			, usr.Nombre AS Nombre_Usuario
			, '01' AS Cod_Estatus
			, '01' AS Cod_Estatus_Previo
			, NULL AS Id_Proceso_Comisiones_Previo
			, acms.Cod_Rango_Comision
			, acms.Cod_Puesto
			, acms.Cod_Alcance_Comision
			, RANK () OVER
			(PARTITION BY cr.ID_ejecutivo_Ventas ORDER BY ISNULL(cr.Importe_Dispersion, 0) + ISNULL(cr.Importe_Compra_Deuda, 0) DESC,cr.id_credito) AS Rank 
			, 'RN' AS Clase
		FROM Pagos_Solicitudes_Pagos spg 
		INNER JOIN CR_Credito cr ON spg.id_credito  = cr.id_credito
				AND  spg.fecha_solicitud_pago >= @Fecha_ini_Calculo AND CONVERT(DATE,fecha_solicitud_pago) <=  CONVERT(DATE,@Fecha_fin_Calculo)
				AND cr.ID_Credito >= 1000000
				AND ( codigo_ecv_pagos  = '01'  -- solicitado
					OR Codigo_Ecv_Pagos =  '03'  -- Operado no dispersado
					OR Codigo_Ecv_Pagos =  '04'  -- Operado dispersado
					OR Codigo_Ecv_Pagos =  '07')  -- Conciliado
				AND (cr.Importe_Renovacion>0 OR cr.Importe_Movto_Interno>0)

		LEFT JOIN Usr_Usuarios usr ON cr.id_usuario = usr.id_usuario
		LEFT JOIN cms_TR_Comisionistas cms ON cr.ID_ejecutivo_Ventas = cms.ID_ejecutivo_Ventas
		LEFT JOIN cms_TR_Puestos pt ON cms.position_name = pt.Nom_Puesto
		INNER JOIN cms_TR_Alcance_Comisiones acms ON pt.cod_Puesto = acms.Cod_Puesto AND acms.Cod_tipo_Comision = '01' AND acms.Cod_Rango_Comision=15 AND acms.Cod_Alcance_Comision = '04'
		LEFT JOIN #temp_personas tp ON tp.ID_Credito = cr.ID_Credito AND tp.creditos_anteriores > 0
		WHERE (( cr.id_usuario IS NULL		--25Mar2025 Se agrego para que incluyera todos los creditos aun cuando los comisionistas tengan omisiones
				OR usr.id_usuario IS NULL 
				OR cr.ID_ejecutivo_Ventas IS NULL 
				OR cms.ID_ejecutivo_Ventas IS NULL 
				OR acms.Cod_tipo_Comision IS NULL
			)
			OR (acms.Cod_Alcance_Comision = '04' AND ISNULL(acms.Ind_Activo, 0) = 1))

		UNION ALL
		SELECT -- créditos Celula digital ejecutivo firmador
			@Id_Proceso_Comisiones AS Id_Proceso_Comisiones
			, cr.Id_credito
			, spg.Id_Compra_Deuda
			, eje.Id_Ejecutivo_Ventas
			, cms.Identifier
			, @Anio AS Anio
			, @Num_Periodo_Anual AS Num_Periodo_Anual
			, spg.Fecha_Solicitud_Pago Feha_Dispersion
			, @Cod_tipo_comision AS Cod_tipo_comision
			, @Fecha_Ini_Calculo AS Fecha_Ini_Periodo
			, @Fecha_Fin_Calculo AS Fecha_Fin_Periodo
			, cr.Fecha_Operacion
			, cr.Importe AS Importe_Otorgado
			, cr.Plazo AS Plazo
			, cr.Importe_Renovacion AS Importe_Renovacion
			, cr.Importe_Dispersion AS Importe_Dispersado
			, cr.Importe_Compra_Deuda  AS Importe_compra_Deuda
			, cr.Importe_Movto_Interno AS Importe_Movto_Interno
			, spg.Importe_Solicitado
			, spg.Importe_Solicitado AS Importe_Base_Comision
			, CONVERT(DECIMAL(18,10), 0) AS Factor_Ponderacion
			, CONVERT(DECIMAL(18,2), 0) AS Monto_Comision
			, CONVERT(DECIMAL(18,2), 0) AS Monto_Comision_Ajuste
			, CONVERT(DECIMAL(18,2), 0) AS Imp_Amortizacion
			, CONVERT(DECIMAL(18,2), 0) AS Imp_Ult_Amortizacion
			, usr.id_usuario
			, usr.Nombre AS Nombre_Usuario
			, '01' AS Cod_Estatus
			, '01' AS Cod_Estatus_Previo
			, NULL AS Id_Proceso_Comisiones_Previo
			, acms.Cod_Rango_Comision
			, acms.Cod_Puesto
			, acms.Cod_Alcance_Comision
			, RANK () OVER
			(PARTITION BY cr.ID_ejecutivo_Ventas ORDER BY ISNULL(cr.Importe_Dispersion, 0) + ISNULL(cr.Importe_Compra_Deuda, 0) DESC,cr.id_credito) AS Rank 
			, 'CD' AS Clase
		FROM Pagos_Solicitudes_Pagos spg 
		INNER JOIN CR_Credito cr ON spg.id_credito  = cr.id_credito
				AND  spg.fecha_solicitud_pago >= @Fecha_ini_Calculo AND CONVERT(DATE,fecha_solicitud_pago) <=  CONVERT(DATE,@Fecha_fin_Calculo)
				AND cr.ID_Credito >= 1000000
				AND ( codigo_ecv_pagos  = '01'  -- solicitado
					OR Codigo_Ecv_Pagos =  '03'  -- Operado no dispersado
					OR Codigo_Ecv_Pagos =  '04'  -- Operado dispersado
					OR Codigo_Ecv_Pagos =  '07')  -- Conciliado
        INNER JOIN ctz_ejecutivos  eje on cr.Id_Cotizacion = eje.Id_Cotizacion
		LEFT JOIN Usr_Usuarios usr ON cr.id_usuario = usr.id_usuario
		LEFT JOIN cms_TR_Comisionistas cms ON eje.ID_ejecutivo_Ventas = cms.ID_ejecutivo_Ventas
		LEFT JOIN cms_TR_Puestos pt ON cms.position_name = pt.Nom_Puesto
		INNER JOIN cms_TR_Alcance_Comisiones acms ON pt.cod_Puesto = acms.Cod_Puesto AND acms.Cod_tipo_Comision = '01' AND acms.Cod_Rango_Comision=17 AND acms.Cod_Alcance_Comision = '05' -- modificar codigo de alconca el rango		
		WHERE (( cr.id_usuario IS NULL		--25Mar2025 Se agrego para que incluyera todos los creditos aun cuando los comisionistas tengan omisiones
				OR usr.id_usuario IS NULL 
				OR cr.ID_ejecutivo_Ventas IS NULL 
				OR cms.ID_ejecutivo_Ventas IS NULL 
				OR acms.Cod_tipo_Comision IS NULL
			)
			OR (acms.Cod_Alcance_Comision = '05' AND ISNULL(acms.Ind_Activo, 0) = 1)) -- modificar cuando ya se alaren las dudas
	UNION ALL
		SELECT -- créditos Celula digital ejecutivo comisionista
			@Id_Proceso_Comisiones AS Id_Proceso_Comisiones
			, cr.Id_credito
			, spg.Id_Compra_Deuda
			, cr.ID_Ejecutivo_Ventas
			, cms.Identifier
			, @Anio AS Anio
			, @Num_Periodo_Anual AS Num_Periodo_Anual
			, spg.Fecha_Solicitud_Pago Feha_Dispersion
			, @Cod_tipo_comision AS Cod_tipo_comision
			, @Fecha_Ini_Calculo AS Fecha_Ini_Periodo
			, @Fecha_Fin_Calculo AS Fecha_Fin_Periodo
			, cr.Fecha_Operacion
			, cr.Importe AS Importe_Otorgado
			, cr.Plazo AS Plazo
			, cr.Importe_Renovacion AS Importe_Renovacion
			, cr.Importe_Dispersion AS Importe_Dispersado
			, cr.Importe_Compra_Deuda  AS Importe_compra_Deuda
			, cr.Importe_Movto_Interno AS Importe_Movto_Interno
			, spg.Importe_Solicitado
			, spg.Importe_Solicitado AS Importe_Base_Comision
			, CONVERT(DECIMAL(18,10), 0) AS Factor_Ponderacion
			, CONVERT(DECIMAL(18,2), 0) AS Monto_Comision
			, CONVERT(DECIMAL(18,2), 0) AS Monto_Comision_Ajuste
			, CONVERT(DECIMAL(18,2), 0) AS Imp_Amortizacion
			, CONVERT(DECIMAL(18,2), 0) AS Imp_Ult_Amortizacion
			, usr.id_usuario
			, usr.Nombre AS Nombre_Usuario
			, '01' AS Cod_Estatus
			, '01' AS Cod_Estatus_Previo
			, NULL AS Id_Proceso_Comisiones_Previo
			, acms.Cod_Rango_Comision
			, acms.Cod_Puesto
			, acms.Cod_Alcance_Comision
			, RANK () OVER
			(PARTITION BY cr.ID_ejecutivo_Ventas ORDER BY ISNULL(cr.Importe_Dispersion, 0) + ISNULL(cr.Importe_Compra_Deuda, 0) DESC,cr.id_credito) AS Rank 
			, 'CD' AS Clase
		FROM Pagos_Solicitudes_Pagos spg 
		INNER JOIN CR_Credito cr ON spg.id_credito  = cr.id_credito
				AND  spg.fecha_solicitud_pago >= @Fecha_ini_Calculo AND CONVERT(DATE,fecha_solicitud_pago) <=  CONVERT(DATE,@Fecha_fin_Calculo)
				AND cr.ID_Credito >= 1000000
				AND ( codigo_ecv_pagos  = '01'  -- solicitado
					OR Codigo_Ecv_Pagos =  '03'  -- Operado no dispersado
					OR Codigo_Ecv_Pagos =  '04'  -- Operado dispersado
					OR Codigo_Ecv_Pagos =  '07')  -- Conciliado
		INNER JOIN Ctz_Cotizacion cc on cc.ID_Cotizacion = 	cr.Id_Cotizacion and  cc.Codigo_Origen_Cotizacion = '03'	
		LEFT JOIN Usr_Usuarios usr ON cr.id_usuario = usr.id_usuario
		LEFT JOIN cms_TR_Comisionistas cms ON cr.ID_ejecutivo_Ventas = cms.ID_ejecutivo_Ventas
		LEFT JOIN cms_TR_Puestos pt ON cms.position_name = pt.Nom_Puesto
		INNER JOIN cms_TR_Alcance_Comisiones acms ON pt.cod_Puesto = acms.Cod_Puesto AND acms.Cod_tipo_Comision = '01' AND acms.Cod_Rango_Comision=16 AND acms.Cod_Alcance_Comision = '05'
		WHERE (( cr.id_usuario IS NULL		--25Mar2025 Se agrego para que incluyera todos los creditos aun cuando los comisionistas tengan omisiones
				OR usr.id_usuario IS NULL 
				OR cr.ID_ejecutivo_Ventas IS NULL 
				OR cms.ID_ejecutivo_Ventas IS NULL 
				OR acms.Cod_tipo_Comision IS NULL
			)
			OR (acms.Cod_Alcance_Comision = '05' AND ISNULL(acms.Ind_Activo, 0) = 1))
		UNION ALL
		SELECT -- créditos Celula digital ejecutivo comisionista
			@Id_Proceso_Comisiones AS Id_Proceso_Comisiones
			, cr.Id_credito
			, spg.Id_Compra_Deuda
			, cr.ID_Ejecutivo_Ventas
			, cms.Identifier
			, @Anio AS Anio
			, @Num_Periodo_Anual AS Num_Periodo_Anual
			, spg.Fecha_Solicitud_Pago Feha_Dispersion
			, @Cod_tipo_comision AS Cod_tipo_comision
			, @Fecha_Ini_Calculo AS Fecha_Ini_Periodo
			, @Fecha_Fin_Calculo AS Fecha_Fin_Periodo
			, cr.Fecha_Operacion
			, cr.Importe AS Importe_Otorgado
			, cr.Plazo AS Plazo
			, cr.Importe_Renovacion AS Importe_Renovacion
			, cr.Importe_Dispersion AS Importe_Dispersado
			, cr.Importe_Compra_Deuda  AS Importe_compra_Deuda
			, cr.Importe_Movto_Interno AS Importe_Movto_Interno
			, spg.Importe_Solicitado
			, spg.Importe_Solicitado AS Importe_Base_Comision
			, CONVERT(DECIMAL(18,10), 0) AS Factor_Ponderacion
			, CONVERT(DECIMAL(18,2), 0) AS Monto_Comision
			, CONVERT(DECIMAL(18,2), 0) AS Monto_Comision_Ajuste
			, CONVERT(DECIMAL(18,2), 0) AS Imp_Amortizacion
			, CONVERT(DECIMAL(18,2), 0) AS Imp_Ult_Amortizacion
			, usr.id_usuario
			, usr.Nombre AS Nombre_Usuario
			, '01' AS Cod_Estatus
			, '01' AS Cod_Estatus_Previo
			, NULL AS Id_Proceso_Comisiones_Previo
			, acms.Cod_Rango_Comision
			, acms.Cod_Puesto
			, acms.Cod_Alcance_Comision
			, RANK () OVER
			(PARTITION BY cr.ID_ejecutivo_Ventas ORDER BY ISNULL(cr.Importe_Dispersion, 0) + ISNULL(cr.Importe_Compra_Deuda, 0) DESC,cr.id_credito) AS Rank 
			, 'CD' AS Clase
		FROM Pagos_Solicitudes_Pagos spg 
		INNER JOIN CR_Credito cr ON spg.id_credito  = cr.id_credito
				AND  spg.fecha_solicitud_pago >= @Fecha_ini_Calculo AND CONVERT(DATE,fecha_solicitud_pago) <=  CONVERT(DATE,@Fecha_fin_Calculo)
				AND cr.ID_Credito >= 1000000
				AND ( codigo_ecv_pagos  = '01'  -- solicitado
					OR Codigo_Ecv_Pagos =  '03'  -- Operado no dispersado
					OR Codigo_Ecv_Pagos =  '04'  -- Operado dispersado
					OR Codigo_Ecv_Pagos =  '07')  -- Conciliado
		INNER JOIN Ctz_Cotizacion cc on cc.ID_Cotizacion = 	cr.Id_Cotizacion and  cc.Codigo_Origen_Cotizacion = '03'	
		LEFT JOIN Usr_Usuarios usr ON cr.id_usuario = usr.id_usuario
		LEFT JOIN cms_TR_Comisionistas cms ON cr.ID_ejecutivo_Ventas = cms.ID_ejecutivo_Ventas
		LEFT JOIN cms_TR_Puestos pt ON cms.position_name = pt.Nom_Puesto
		INNER JOIN cms_TR_Alcance_Comisiones acms ON pt.cod_Puesto = acms.Cod_Puesto AND acms.Cod_tipo_Comision = '01' AND acms.Cod_Rango_Comision=18 AND acms.Cod_Alcance_Comision = '05'
		WHERE (( cr.id_usuario IS NULL		
				OR usr.id_usuario IS NULL 
				OR cr.ID_ejecutivo_Ventas IS NULL 
				OR cms.ID_ejecutivo_Ventas IS NULL 
				OR acms.Cod_tipo_Comision IS NULL
			)
			OR (acms.Cod_Alcance_Comision = '05' AND ISNULL(acms.Ind_Activo, 0) = 1)) -- modificar cuando ya se alaren las dudas


		--Elimina aquellos registros que estan duplicacos o triplicados, dejando solo un registro de los que no tienen identificador
		DELETE cms_Creditos_Periodo
		FROM cms_Creditos_Periodo cms
		INNER JOIN (
				SELECT Id_credito
					, Id_Proceso_Comisiones
					, Id_Compra_Deuda
					, Cod_tipo_comision
					, MIN(Id) AS id
				FROM cms_Creditos_Periodo
				WHERE Id_Proceso_Comisiones = @Id_Proceso_Comisiones
						AND Identifier IS NULL
						AND Cod_tipo_comision = @Cod_tipo_comision
				GROUP BY Id_Proceso_Comisiones
					, Id_credito
					, Id_Compra_Deuda
					, Cod_tipo_comision
			) a ON cms.Id_Proceso_Comisiones = a.Id_Proceso_Comisiones
					AND cms.Cod_tipo_comision = a.Cod_tipo_comision
					AND cms.Id_credito = a.Id_credito
					AND cms.id != a.id
		WHERE cms.Id_Proceso_Comisiones = @Id_Proceso_Comisiones
				AND cms.Identifier IS NULL
				AND cms.Cod_tipo_comision = @Cod_tipo_comision
		
		----Elimina los registros duplicados cuando tiene comisionista asignado pero no tiene comisiones
		DELETE cms_Creditos_Periodo
		FROM cms_Creditos_Periodo cms
		INNER JOIN (		 
				SELECT Id_credito
					, 	Id_Proceso_Comisiones
					, Id_Compra_Deuda
					, Cod_tipo_comision
					, Identifier
					, min(Id) AS id
				FROM cms_Creditos_Periodo
				WHERE Id_Proceso_Comisiones = @Id_Proceso_Comisiones
					AND Identifier IS NOT NULL
					AND Cod_tipo_comision = @Cod_tipo_comision
					AND Cod_Alcance_Comision IS NULL
				GROUP BY Id_Proceso_Comisiones
					, Id_credito
					, Id_Compra_Deuda
					, Cod_tipo_comision
					, Identifier
				) a ON cms.Id_Proceso_Comisiones = a.Id_Proceso_Comisiones
				AND cms.Cod_tipo_comision = a.Cod_tipo_comision
				AND cms.Id_credito = a.Id_credito
				AND cms.Identifier = a.Identifier
				AND cms.id != a.id
		WHERE cms.Id_Proceso_Comisiones = @Id_Proceso_Comisiones
			AND cms.Identifier IS NOT NULL
			AND cms.Cod_tipo_comision = @Cod_tipo_comision
			AND Cod_Alcance_Comision IS NULL

	

		--Revisar la existencia de un posible pago duplicado de comisiones 
		--a) Se pago comisones en periodos anteriores y se pretENDe pagar nuevamente
		--		En este caso el segundo pago se debe de evitar, mientras no se cancele el pago previo
		--		El pago previo se cancela reprocesando el calculo del perido anterior

	
		-- En el caso que el credito ya este incluido en un proceso previo de pago de comisiones, el importe base lo deja en cero y marca el registro como
		-- se proceso previamente
		UPDATE  cru
		  SET Importe_Base_Comision = 0
			, cod_estatus_Previo = '02'  -- 01 Normal, 02.Pagado previamiente, 03. Cancelado previamente
			, cod_estatus = '02'  -- 01 incluir 02 Excluir
			, Id_Proceso_Comisiones_Previo = upg.Id_Proceso_Comisiones_Previo
		FROM  cms_Creditos_Periodo cru
		INNER JOIN ( SELECT crd.Id_credito
							, crd.Id_Compra_Deuda
		  					, crd.Id_Proceso_Comisiones AS Id_Proceso_Comisiones_Previo
							, MAX(cr.Id_Proceso_Comisiones) AS Id_Proceso_comisiones
							, MAX(crd.Fecha_Fin_Periodo) AS Previa_Fecha_Pago
					FROM cms_Creditos_Periodo cr 
					INNER JOIN  cms_Creditos_Periodo crd ON cr.Id_credito = crd.Id_credito 
								AND cr.id != crd.Id
								AND crd.Cod_tipo_comision = cr.Cod_tipo_comision 
								AND crd.Anio <= cr.Anio 
								AND ((crd.Anio = cr.Anio  AND crd.Num_Periodo_Anual < cr.Num_Periodo_Anual)
									OR ( crd.Anio < cr.Anio))
								AND crd.cod_estatus = '01'
		   			 WHERE cr.Id_Proceso_Comisiones = @Id_Proceso_Comisiones 
					 GROUP BY crd.id_credito, crd.Id_Compra_Deuda, crd.Id_Proceso_Comisiones
					)	upg ON cru.Id_credito = upg.id_credito AND cru.Id_Compra_Deuda = upg.Id_Compra_Deuda AND cru.Id_Proceso_Comisiones = upg.Id_Proceso_comisiones
		WHERE cru.Id_Proceso_Comisiones = @Id_Proceso_Comisiones

		INSERT INTO Cms_Resumen_Comisiones
		SELECT cr.Id_Proceso_Comisiones
			, cr.ID_Ejecutivo_Ventas
			, cr.Cod_Alcance_Comision
			, MAX(cr.cod_rango_Comision) AS Cod_Rango_Comision
			, ISNULL(MAX(cr.cod_puesto),'00') AS Cod_Puesto
			, MAX(ev.Nombre) AS Nombre_Ejecutivo
			, MAX(cr.Identifier) AS Identifier
			, MAX(cms.Nombre_dep) AS Nombre_Rh
			, MAX(cms.Position_Name) AS Position_Name
			, MAX(cr.Anio) AS Anio
			, MAX(cr.Num_Periodo_Anual) AS Num_Periodo_Anual
			, MAX(cr.Cod_tipo_comision) AS Cod_tipo_comision
			, COUNT (distinct Id_credito) Creditos
			, @Fecha_ini_Calculo AS Fecha_Ini_Periodo
			, @Fecha_fin_Calculo AS Fecha_fin_Periodo
			, SUM(importe_Otorgado) AS Importe_Otorgado
			, SUM(importe_renovacion) AS Importe_renovacion
			, SUM(Importe_Dispersado) AS Importe_Dispersado
			, SUM(Importe_compra_Deuda) AS Importe_compra_Deuda
			, SUM(Importe_Movto_Interno) AS importe_Movto_Interno
			, SUM(Importe_Solicitado) AS Importe_Solicitado
			, SUM(Importe_base_Comision) AS Importe_base_Comision
			, CONVERT(DECIMAL(18,2), 0) AS Rango_Inicial
			, CONVERT(DECIMAL(18,2), 0) AS Rango_final 
			, CONVERT(DECIMAL(18,12),0) AS  Factor
			, CONVERT(DECIMAL(18,2), 0) AS Importe_Comision
			, CONVERT(DECIMAL(18,6), 0) AS Factor_distribucion
			, CONVERT(DECIMAL(18,2), 0) AS Importe_Distribuido
			, MAX(cms.Nombre_dep) AS Nombre_dep
		FROM cms_Creditos_Periodo cr 
		LEFT JOIN Vtas_Ejecutivos ev ON cr.ID_Ejecutivo_Ventas = ev.ID_Ejecutivo_Ventas
		LEFT JOIN cms_TR_Comisionistas cms ON  CR.ID_Ejecutivo_Ventas = cms.ID_Ejecutivo_Ventas AND CONVERT(DATE,cr.Feha_Dispersion) >= CONVERT(DATE, cms.joiningdate) 
	    WHERE cr.Id_Proceso_Comisiones = @Id_Proceso_Comisiones
				AND cr.Cod_Alcance_Comision not in('04','05')
	    GROUP BY cr.Id_Proceso_Comisiones
			, cr.ID_Ejecutivo_Ventas
			, cr.Cod_Alcance_Comision
	    ORDER BY 1,2,3	

		-- Se actualiza el rango, el factor y el importe de comisión

		INSERT INTO Cms_Resumen_Comisiones -- para alcance 4 solamente
		SELECT cr.Id_Proceso_Comisiones
			, cr.ID_Ejecutivo_Ventas
			, cr.Cod_Alcance_Comision
			, cr.cod_rango_Comision
			, ISNULL(max(cr.cod_puesto),'00') AS Cod_Puesto
			, MAX(ev.Nombre) AS Nombre_Ejecutivo
			, MAX(cr.Identifier) AS Identifier
			, MAX(cms.Nombre_dep) AS Nombre_Rh
			, MAX(cms.Position_Name) AS Position_Name
			, MAX(cr.Anio) AS Anio
			, MAX(cr.Num_Periodo_Anual) AS Num_Periodo_Anual
			, MAX(cr.Cod_tipo_comision) AS Cod_tipo_comision
			, COUNT(DISTINCT Id_credito) AS Creditos
			, @Fecha_ini_Calculo AS Fecha_Ini_Periodo
			, @Fecha_fin_Calculo AS Fecha_fin_Periodo
			, SUM(importe_Otorgado) AS Importe_Otorgado
			, SUM(importe_renovacion) AS Importe_renovacion
			, SUM(Importe_Dispersado) AS Importe_Dispersado
			, SUM(Importe_compra_Deuda) AS Importe_compra_Deuda
			, SUM(Importe_Movto_Interno) AS importe_Movto_Interno
			, SUM(Importe_Solicitado) AS Importe_Solicitado
			, SUM(Importe_base_Comision) AS Importe_base_Comision
			, CONVERT(DECIMAL(18,2), 0) AS Rango_Inicial
			, CONVERT(DECIMAL(18,2), 0) AS Rango_final 
			, CONVERT( DECIMAL(18,12),0) AS  Factor 
			, CONVERT(DECIMAL(18,2), 0) AS Importe_Comision
			, CONVERT(DECIMAL(18,6), 0) AS Factor_distribucion
			, CONVERT(DECIMAL(18,2), 0) AS Importe_Distribuido
			, MAX(cms.Nombre_dep) AS Nombre_dep
		FROM cms_Creditos_Periodo cr 
		LEFT JOIN Vtas_Ejecutivos ev ON cr.ID_Ejecutivo_Ventas = ev.ID_Ejecutivo_Ventas
		LEFT JOIN cms_TR_Comisionistas cms ON  CR.ID_Ejecutivo_Ventas = cms.ID_Ejecutivo_Ventas AND CONVERT(DATE,cr.Feha_Dispersion) >= CONVERT(DATE, cms.joiningdate) 
	    WHERE cr.Id_Proceso_Comisiones = @Id_Proceso_Comisiones
	   			AND cr.Cod_Alcance_Comision = '04' 
		GROUP BY cr.Id_Proceso_Comisiones
			, cr.ID_Ejecutivo_Ventas
			, cr.Cod_Alcance_Comision
			, cr.cod_rango_Comision
		ORDER BY 1,2,3	

		INSERT INTO Cms_Resumen_Comisiones -- para alcance 5 solamente y firmante -- Celula digital
		SELECT cr.Id_Proceso_Comisiones
			, eje.Id_Ejecutivo_Ventas
			, cr.Cod_Alcance_Comision
			, cr.cod_rango_Comision
			, ISNULL(max(cr.cod_puesto),'00') AS Cod_Puesto
			, MAX(ev.Nombre) AS Nombre_Ejecutivo
			, MAX(cr.Identifier) AS Identifier
			, MAX(cms.Nombre_dep) AS Nombre_Rh
			, MAX(cms.Position_Name) AS Position_Name
			, MAX(cr.Anio) AS Anio
			, MAX(cr.Num_Periodo_Anual) AS Num_Periodo_Anual
			, MAX(cr.Cod_tipo_comision) AS Cod_tipo_comision
			, COUNT(DISTINCT cr.Id_credito) AS Creditos
			, @Fecha_ini_Calculo AS Fecha_Ini_Periodo
			, @Fecha_fin_Calculo AS Fecha_fin_Periodo
			, SUM(importe_Otorgado) AS Importe_Otorgado
			, SUM(cr.importe_renovacion) AS Importe_renovacion
			, SUM(Importe_Dispersado) AS Importe_Dispersado
			, SUM(cr.Importe_compra_Deuda) AS Importe_compra_Deuda
			, SUM(cr.Importe_Movto_Interno) AS importe_Movto_Interno
			, SUM(Importe_Solicitado) AS Importe_Solicitado
			, SUM(Importe_base_Comision) AS Importe_base_Comision
			, CONVERT(DECIMAL(18,2), 0) AS Rango_Inicial
			, CONVERT(DECIMAL(18,2), 0) AS Rango_final 
			, CONVERT( DECIMAL(18,12),0) AS  Factor 
			, CONVERT(DECIMAL(18,2), 0) AS Importe_Comision
			, CONVERT(DECIMAL(18,6), 0) AS Factor_distribucion
			, CONVERT(DECIMAL(18,2), 0) AS Importe_Distribuido
			, MAX(cms.Nombre_dep) AS Nombre_dep
		FROM cms_Creditos_Periodo cr 
		JOIN CR_Credito crc on crc.ID_Credito = cr.Id_credito
		JOIN Ctz_Ejecutivos eje on crc.Id_Cotizacion = eje.Id_Cotizacion
		LEFT JOIN Vtas_Ejecutivos ev ON eje.ID_Ejecutivo_Ventas = ev.ID_Ejecutivo_Ventas
		LEFT JOIN cms_TR_Comisionistas cms ON  CR.ID_Ejecutivo_Ventas = cms.ID_Ejecutivo_Ventas AND CONVERT(DATE,cr.Feha_Dispersion) >= CONVERT(DATE, cms.joiningdate) 
	    WHERE cr.Id_Proceso_Comisiones = @Id_Proceso_Comisiones
	   			AND cr.Cod_Alcance_Comision = '05'
				AND  cr.cod_rango_Comision = 17
		GROUP BY cr.Id_Proceso_Comisiones
			, eje.ID_Ejecutivo_Ventas
			, cr.Cod_Alcance_Comision
			, cr.cod_rango_Comision
		ORDER BY 1,2,3	

		INSERT INTO Cms_Resumen_Comisiones -- para alcance 5 solamente y comisionistas -- Celula digital
		SELECT Distinct cr.Id_Proceso_Comisiones
			, crc.ID_Ejecutivo_Ventas
			, cr.Cod_Alcance_Comision
			, cr.cod_rango_Comision
			, ISNULL(max(cr.cod_puesto),'00') AS Cod_Puesto
			, MAX(ev.Nombre) AS Nombre_Ejecutivo
			, MAX(cr.Identifier) AS Identifier
			, MAX(cms.Nombre_dep) AS Nombre_Rh
			, MAX(cms.Position_Name) AS Position_Name
			, MAX(cr.Anio) AS Anio
			, MAX(cr.Num_Periodo_Anual) AS Num_Periodo_Anual
			, MAX(cr.Cod_tipo_comision) AS Cod_tipo_comision
			, COUNT(DISTINCT cr.Id_credito) AS Creditos
			, @Fecha_ini_Calculo AS Fecha_Ini_Periodo
			, @Fecha_fin_Calculo AS Fecha_fin_Periodo
			, SUM(importe_Otorgado) AS Importe_Otorgado
			, SUM(cr.importe_renovacion) AS Importe_renovacion
			, SUM(Importe_Dispersado) AS Importe_Dispersado
			, SUM(cr.Importe_compra_Deuda) AS Importe_compra_Deuda
			, SUM(cr.Importe_Movto_Interno) AS importe_Movto_Interno
			, SUM(Importe_Solicitado) AS Importe_Solicitado
			, SUM(Importe_base_Comision) AS Importe_base_Comision
			, CONVERT(DECIMAL(18,2), 0) AS Rango_Inicial
			, CONVERT(DECIMAL(18,2), 0) AS Rango_final 
			, CONVERT( DECIMAL(18,12),0) AS  Factor 
			, CONVERT(DECIMAL(18,2), 0) AS Importe_Comision
			, CONVERT(DECIMAL(18,6), 0) AS Factor_distribucion
			, CONVERT(DECIMAL(18,2), 0) AS Importe_Distribuido
			, MAX(cms.Nombre_dep) AS Nombre_dep
		FROM cms_Creditos_Periodo cr 
		JOIN CR_Credito crc on crc.ID_Credito = cr.Id_credito
		JOIN Ctz_Cotizacion cc on cc.Id_Cotizacion = crc.Id_Cotizacion and cc.Codigo_Origen_Cotizacion = '03'
		LEFT JOIN Vtas_Ejecutivos ev ON crc.ID_Ejecutivo_Ventas = ev.ID_Ejecutivo_Ventas
		LEFT JOIN cms_TR_Comisionistas cms ON  CR.ID_Ejecutivo_Ventas = cms.ID_Ejecutivo_Ventas AND CONVERT(DATE,cr.Feha_Dispersion) >= CONVERT(DATE, cms.joiningdate) 
	    WHERE cr.Id_Proceso_Comisiones = @Id_Proceso_Comisiones
	   			AND cr.Cod_Alcance_Comision = '05'
				AND cr.Cod_Rango_Comision in(16,18)
		GROUP BY cr.Id_Proceso_Comisiones
			, crc.ID_Ejecutivo_Ventas
			, cr.Cod_Alcance_Comision
			, cr.cod_rango_Comision
		ORDER BY 1,2,3	

		UPDATE RC
		  SET Rango_Inicial = rngc.Rango_inicial
			, Rango_final  = rngc.Rango_final
			, factor = rngc.Factor 
			, Importe_Comision = ROUND(Importe_Base_Comision * rngc.Factor,2)
		FROM Cms_Resumen_Comisiones rc
		LEFT JOIN cms_TR_Rango_Comisiones_V02 rngc ON rc.cod_rango_comision  = rngc.Cod_Rango_Comision
			      AND rc.Importe_Base_Comision >= rngc.Rango_Inicial 
				  AND rc.Importe_Base_comision <= rngc.Rango_final
		WHERE rc.Id_Proceso_Comisiones = @Id_Proceso_Comisiones
				  AND rc.Importe_Base_Comision > 0  -- 21 May 2025 para evitar div=0 cuado no se tenga base para el pago de las comisiones
				  AND rc.Cod_Alcance_Comision not in('04','05') 

		-- Actualiza el Factor de distribución en el resumen
		-- renovaciones
		UPDATE RC 
		  SET Rango_Inicial = rngc.Rango_inicial
			, Rango_final  = rngc.Rango_final
			, factor = rngc.Factor + ISNULL(pol.Incentivo,0.0)
			, Importe_Comision = ROUND(Importe_Base_Comision * (rngc.Factor + ISNULL(pol.Incentivo,0.0)),2)
		FROM Cms_Resumen_Comisiones rc --Cms_Resumen_Comisiones rc --
		LEFT JOIN cms_TR_Rango_Comisiones_V02 rngc on rc.cod_rango_comision  = rngc.Cod_Rango_Comision
			      AND rc.Importe_Base_Comision >= rngc.Rango_Inicial 
				  AND rc.Importe_Base_comision <= rngc.Rango_final
		LEFT JOIN (
				SELECT 
					cr.Id_Proceso_Comisiones
					, cr.ID_Ejecutivo_Ventas
					, cr.Cod_Alcance_Comision
					, SUM(Importe_Dispersado) AS Importe_Dispersado
					, CAST(CASE WHEN SUM(Importe_Dispersado) > @Limite_Inferior THEN @Porcentaje_Incentivo_Renovado ELSE 0/100.0 END AS DECIMAL(18,12)) AS Incentivo
				FROM cms_Creditos_Periodo cr 
				LEFT JOIN Vtas_Ejecutivos ev ON cr.ID_Ejecutivo_Ventas = ev.ID_Ejecutivo_Ventas
				LEFT JOIN cms_TR_Comisionistas cms ON  CR.ID_Ejecutivo_Ventas = cms.ID_Ejecutivo_Ventas
					AND CONVERT(DATE,cr.Feha_Dispersion) >= CONVERT(DATE, cms.joiningdate) 
				WHERE cr.Cod_Alcance_Comision='04'
					AND cr.Clase = 'NC'
					AND Id_Proceso_Comisiones = @Id_Proceso_Comisiones
				GROUP BY cr.Id_Proceso_Comisiones
					, cr.ID_Ejecutivo_Ventas
					, cr.Cod_Alcance_Comision
			) AS pol ON rc.Id_Proceso_Comisiones=pol.Id_Proceso_Comisiones AND rc.ID_Ejecutivo_Ventas=pol.ID_Ejecutivo_Ventas
		WHERE rc.Id_Proceso_Comisiones = @Id_Proceso_Comisiones
		  AND rc.Importe_Base_Comision > 0  -- 21 May 2025 para evitar div=0 cuado no se tenga base para el pago de las comisiones
		  AND rc.Cod_Alcance_Comision = '04' 
		  AND rc.Cod_Rango_Comision = 15


		-- créditos nuevos
		UPDATE RC 
		  SET Rango_Inicial = rngc.Rango_inicial
			, Rango_final  = rngc.Rango_final
			, factor = rngc.Factor + ISNULL(pol.Incentivo,0.0)
			, Importe_Comision = ROUND(Importe_Base_Comision * (rngc.Factor + ISNULL(pol.Incentivo,0.0)),2)
		FROM Cms_Resumen_Comisiones rc 
		LEFT JOIN cms_TR_Rango_Comisiones_V02 rngc ON rc.cod_rango_comision  = rngc.Cod_Rango_Comision
			 AND rc.Importe_Base_Comision >= rngc.Rango_Inicial 
			 AND rc.Importe_Base_comision <= rngc.Rango_final
		LEFT JOIN (
				SELECT 
					cr.Id_Proceso_Comisiones
					, cr.ID_Ejecutivo_Ventas
					, cr.Cod_Alcance_Comision
					, SUM(Importe_Dispersado) AS Importe_Dispersado
					, CAST(CASE WHEN SUM(Importe_Dispersado) > @Limite_Inferior THEN @Porcentaje_Incentivo_Nuevo ELSE 0/100.0 END AS DECIMAL(18,12)) AS Incentivo
				FROM cms_Creditos_Periodo cr 
				LEFT JOIN Vtas_Ejecutivos ev ON cr.ID_Ejecutivo_Ventas = ev.ID_Ejecutivo_Ventas
				LEFT JOIN cms_TR_Comisionistas cms ON  CR.ID_Ejecutivo_Ventas = cms.ID_Ejecutivo_Ventas
					AND CONVERT(DATE,cr.Feha_Dispersion) >= CONVERT(DATE, cms.joiningdate) 
				WHERE cr.Cod_Alcance_Comision='04'
					AND cr.Clase = 'NC'
					AND Id_Proceso_Comisiones = @Id_Proceso_Comisiones
				GROUP BY cr.Id_Proceso_Comisiones
					, cr.ID_Ejecutivo_Ventas
					, cr.Cod_Alcance_Comision
			) AS pol ON rc.Id_Proceso_Comisiones=pol.Id_Proceso_Comisiones AND rc.ID_Ejecutivo_Ventas=pol.ID_Ejecutivo_Ventas
		WHERE rc.Id_Proceso_Comisiones = @Id_Proceso_Comisiones
		  AND rc.Importe_Base_Comision > 0  -- 21 May 2025 para evitar div=0 cuado no se tenga base para el pago de las comisiones
		  AND rc.Cod_Alcance_Comision = '04' 
		  AND rc.Cod_Rango_Comision = 14

		  -- Celula Digital ejecutivo firmador		  
		UPDATE RC
		  SET Rango_Inicial = rngc.Rango_inicial
			, Rango_final  = rngc.Rango_final
			, factor = rngc.Factor
			, Importe_Comision = rngc.Valor
		FROM Cms_Resumen_Comisiones rc		 
		LEFT JOIN cms_TR_Rango_Comisiones_V02 rngc ON rc.cod_rango_comision  = rngc.Cod_Rango_Comision			 
		LEFT JOIN (
				SELECT  DISTINCT
					cr.Id_Proceso_Comisiones
					, cr.ID_Ejecutivo_Ventas
					, cr.Cod_Alcance_Comision
					, SUM(Importe_Dispersado) AS Importe_Dispersado
					, CAST(CASE WHEN SUM(Importe_Dispersado) > @Limite_Inferior THEN @Porcentaje_Incentivo_Nuevo ELSE 0/100.0 END AS DECIMAL(18,12)) AS Incentivo
				FROM cms_Creditos_Periodo cr 				
				LEFT JOIN Vtas_Ejecutivos ev ON cr.ID_Ejecutivo_Ventas = ev.ID_Ejecutivo_Ventas
				LEFT JOIN cms_TR_Comisionistas cms ON  CR.ID_Ejecutivo_Ventas = cms.ID_Ejecutivo_Ventas
					AND CONVERT(DATE,cr.Feha_Dispersion) >= CONVERT(DATE, cms.joiningdate) 
				WHERE cr.Cod_Alcance_Comision='05'
					AND cr.Clase = 'CD'
					AND Id_Proceso_Comisiones = @Id_Proceso_Comisiones
					AND cr.Cod_Rango_Comision = 17
				GROUP BY cr.Id_Proceso_Comisiones
					, cr.ID_Ejecutivo_Ventas
					, cr.Cod_Alcance_Comision
			) AS pol ON rc.Id_Proceso_Comisiones=pol.Id_Proceso_Comisiones AND rc.ID_Ejecutivo_Ventas=pol.ID_Ejecutivo_Ventas
		WHERE rc.Id_Proceso_Comisiones = @Id_Proceso_Comisiones
		  AND rc.Importe_Base_Comision > 0  
		  AND rc.Cod_Alcance_Comision = '05' 
		  AND rc.Cod_Rango_Comision = 17-- celula digital firmador

		  -- Celula Digital ejecutivo comercial 		  
		UPDATE RC 
		  SET Rango_Inicial = rngc.Rango_inicial
			, Rango_final  = rngc.Rango_final
			, factor = rngc.Factor
			, Importe_Comision = ROUND(Importe_Base_Comision * rngc.Factor,2)
		FROM Cms_Resumen_Comisiones rc 
		LEFT JOIN cms_TR_Rango_Comisiones_V02 rngc ON rc.cod_rango_comision  = rngc.Cod_Rango_Comision
			 AND rc.Importe_Base_Comision >= rngc.Rango_Inicial 
			 AND rc.Importe_Base_comision <= rngc.Rango_final
		LEFT JOIN (
				SELECT 
					cr.Id_Proceso_Comisiones
					, cr.ID_Ejecutivo_Ventas
					, cr.Cod_Alcance_Comision
					, SUM(Importe_Dispersado) AS Importe_Dispersado
					, CAST(CASE WHEN SUM(Importe_Dispersado) > @Limite_Inferior THEN @Porcentaje_Incentivo_Nuevo ELSE 0/100.0 END AS DECIMAL(18,12)) AS Incentivo
				FROM cms_Creditos_Periodo cr 
				LEFT JOIN Vtas_Ejecutivos ev ON cr.ID_Ejecutivo_Ventas = ev.ID_Ejecutivo_Ventas
				LEFT JOIN cms_TR_Comisionistas cms ON  CR.ID_Ejecutivo_Ventas = cms.ID_Ejecutivo_Ventas
					AND CONVERT(DATE,cr.Feha_Dispersion) >= CONVERT(DATE, cms.joiningdate) 
				WHERE cr.Cod_Alcance_Comision='05'
					AND cr.Clase = 'CD'
					AND Id_Proceso_Comisiones = @Id_Proceso_Comisiones
					AND cr.Cod_Rango_Comision in(16,18)
				GROUP BY cr.Id_Proceso_Comisiones
					, cr.ID_Ejecutivo_Ventas
					, cr.Cod_Alcance_Comision
			) AS pol ON rc.Id_Proceso_Comisiones=pol.Id_Proceso_Comisiones AND rc.ID_Ejecutivo_Ventas=pol.ID_Ejecutivo_Ventas
		WHERE rc.Id_Proceso_Comisiones = @Id_Proceso_Comisiones
		  AND rc.Importe_Base_Comision > 0  -- 21 May 2025 para evitar div=0 cuado no se tenga base para el pago de las comisiones
		  AND rc.Cod_Alcance_Comision = '05' 
		  AND pol.Cod_Alcance_Comision = '05'
		  AND rc.Cod_Rango_Comision in(16,18)-- celula digital firmador

		UPDATE Cms_Resumen_Comisiones   
		  SET Factor_Distribucion = ROUND(importe_comision / Importe_Base_Comision,6)
	    WHERE Id_Proceso_Comisiones = @Id_Proceso_Comisiones
				AND Importe_Base_Comision > 0  -- 21 May 2025 para evitar div=0 cuado no se tenga base para el pago de las comisiones

		-- Actualiza el monto de comisión en los créditos del periodo
		UPDATE cr
		  SET Monto_Comision = ROUND(cr.importe_Base_Comision * rc.Factor_Distribucion,2)
		FROM cms_Creditos_Periodo cr  
		INNER JOIN Cms_Resumen_Comisiones rc ON  cr.ID_Ejecutivo_Ventas = rc.ID_Ejecutivo_Ventas 
				AND cr.Id_Proceso_Comisiones = rc.Id_Proceso_Comisiones
				AND cr.cod_Alcance_Comision = rc.cod_Alcance_Comision  -- se agrego   26 sept 2024
				AND cr.Cod_Rango_Comision = rc.Cod_Rango_Comision -- se agrego   26 sept 2024
	    WHERE cr.Id_Proceso_Comisiones = @Id_Proceso_Comisiones


		-- Actualiza en el resumen lo distribuido en el detalle
		UPDATE rc
		  SET rc.Importe_Distribuido = dst.Monto_Comision
		FROM Cms_Resumen_Comisiones rc
		INNER JOIN (
						SELECT id_ejecutivo_ventas
							, Id_Proceso_Comisiones
							, cod_Alcance_Comision
							, SUM(Monto_comision) AS Monto_Comision
						FROM cms_Creditos_Periodo 
						WHERE Id_Proceso_Comisiones = @Id_Proceso_Comisiones					
						  GROUP BY Id_Ejecutivo_Ventas
								, Id_Proceso_Comisiones
								, cod_Alcance_Comision
					   ) dst ON rc.id_ejecutivo_ventas = dst.id_ejecutivo_ventas
					           AND rc.Id_Proceso_Comisiones = dst.Id_Proceso_Comisiones
							   AND rc.cod_Alcance_Comision = dst.cod_Alcance_Comision
		WHERE rc.Id_Proceso_Comisiones = @Id_Proceso_Comisiones
			AND rc.Cod_Alcance_Comision <> '04' 

		-- Actualiza en el resumen lo distribuido en el detalle
		UPDATE rc
		  SET rc.Importe_Distribuido = dst.Monto_Comision
		FROM Cms_Resumen_Comisiones rc
			INNER JOIN (
						SELECT id_ejecutivo_ventas
							, Id_Proceso_Comisiones
							, cod_Alcance_Comision
							, Cod_Rango_Comision
							, SUM(Monto_comision) AS Monto_Comision
						FROM cms_Creditos_Periodo 
						WHERE Id_Proceso_Comisiones = @Id_Proceso_Comisiones					
						GROUP BY Id_Ejecutivo_Ventas
								, Id_Proceso_Comisiones
								, cod_Alcance_Comision
								, Cod_Rango_Comision
					   ) dst ON rc.id_ejecutivo_ventas = dst.id_ejecutivo_ventas
					           AND rc.Id_Proceso_Comisiones = dst.Id_Proceso_Comisiones
						   AND rc.cod_Alcance_Comision = dst.cod_Alcance_Comision
						   AND rc.Cod_Rango_Comision = dst.Cod_Rango_Comision

	        WHERE rc.Id_Proceso_Comisiones = @Id_Proceso_Comisiones
			AND rc.Cod_Alcance_Comision = '04'

		--- En el credito de mayor disersión hace el ajuste de la distribucion de las comisiones
		UPDATE cr
		  SET 
			 Monto_Comision = Monto_Comision + (rc.Importe_Comision - rc.Importe_Distribuido)
		    ,Monto_Comision_Ajuste =Monto_Comision_Ajuste + (rc.Importe_Comision - rc.Importe_Distribuido)
		FROM cms_Creditos_Periodo cr 
		INNER JOIN Cms_Resumen_Comisiones rc ON  cr.ID_Ejecutivo_Ventas = rc.ID_Ejecutivo_Ventas 
					AND cr.Id_Proceso_Comisiones = rc.Id_Proceso_Comisiones 
					AND cr.cod_Alcance_Comision = rc.cod_Alcance_Comision 
		WHERE cr.Rank = 1
		AND rc.Importe_Comision != rc.Importe_Distribuido
		AND cr.Id_Proceso_Comisiones = @Id_Proceso_Comisiones
		AND cr.cod_Alcance_Comision = rc.cod_Alcance_Comision 
		AND cr.Cod_Alcance_Comision <> '04' 
		
		-- Aplica los cálculos de comisión para el alcance 4 créditos nuevos
		--- En el credito de mayor disersión hace el ajuste de la distribucion de las comisiones

		-- Hace las distribución de cada amortizaicón segun el plazo de crédito, y determina el monto periodo ajustado
		UPDATE cms_Creditos_Periodo
		  SET 
			 Imp_Amortizacion = ROUND(Monto_Comision / Plazo, 2)
			,Imp_Ult_Amortizacion = Monto_Comision - ROUND(Monto_Comision / Plazo, 2) * (Plazo - 1)
		WHERE Id_Proceso_Comisiones = @Id_Proceso_Comisiones

	END   -- Si es nuevo o recalculado

	SELECT @Id_Proceso_Comisiones AS Id_Proceso_Comisiones,  @Estatus AS Cod_Resultado, @Cod_ECV_Proceso AS Cod_ECV_Proceso
END