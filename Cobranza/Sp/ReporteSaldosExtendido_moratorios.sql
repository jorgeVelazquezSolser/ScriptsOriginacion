USE Cobranza
GO

CREATE OR ALTER PROCEDURE dbo.ReporteSaldosExtendido_moratorios
    @idGestor     int,
    @filtro       varchar(25),
    @idU          int,
    @clasificacion varchar(30)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @rol int;
    SET @rol = (SELECT [pkCatRol] FROM [dbo].[Usr_Usuarios] WHERE [ID_Usuario] = @idU);

    -- =====================================================================
    -- ROL 1 (Administrador/Supervisor general) sin gestor especifico
    -- =====================================================================
    IF (@rol = 1 AND @idGestor = '')
    BEGIN
        SELECT
             r.[Prestamo]
            ,r.[GestorAsignado]                                  AS gestorasignado
            ,r.[Sucursal]                                        AS sucursal
            ,r.[Nombre]                                          AS nombre
            ,r.[FechaNacimiento]                                 AS fechanacimiento
            ,CONVERT(varchar, r.[FechaIngreso])                  AS fechaingreso2
            ,r.[Genero]                                          AS genero
            ,r.[RFC]                                             AS rfc
            ,r.[CURP]                                            AS curp
            ,r.[FolioIFE]                                        AS folioife
            ,r.[DomicilioCalleNumero]                            AS domiciliocallenumero
            ,r.[Colonia]                                         AS colonia
            ,r.[CodigoPostal]                                    AS codigopostal
            ,r.[CiudadEstado]                                    AS ciudadestado
            ,r.[ClaveLada]                                       AS clavelada
            ,r.[Telefono1]                                       AS telefono1
            ,r.[Telefono2]                                       AS telefono2
            ,r.[Telefono3]                                       AS telefono3
            ,r.[Tel1ConsCC]                                      AS tel1conscc
            ,r.[Tel2ConsCC]                                      AS tel2conscc
            ,r.[Tel3ConsCC]                                      AS tel3conscc
            ,r.[EstadoCivil]                                     AS estadocivil
            ,r.[NombreConyuge]                                   AS nombreconyuge
            ,r.[TipoEmpleado]                                    AS tipoempleado
            ,r.[Municipio]                                       AS municipio
            ,r.[Area]                                            AS area
            ,r.[Convenio]                                        AS convenio
            ,r.[Dependencia]                                     AS dependencia
            ,r.[CredOtorgNoLiq]                                  AS credotorgnoliq
            ,r.[TipoProducto]                                    AS tipoproducto
            ,r.[MontoOtorgado]                                   AS montootorgado
            ,r.[FechaOperacion]                                  AS fechaoperacion
            ,r.[FechaVence]                                      AS fechavence
            ,r.[NumAmortizaciones]                               AS numamortizaciones
            ,r.[Periodicidad]                                    AS periodicidad
            ,r.[PlazoMeses]                                      AS plazomeses
            ,r.[CapitalVencido]                                  AS capitalvencido
            ,r.[Capital]                                         AS capital
            ,r.[InteresSinVencer]                                AS interessinvencer
            ,r.[InteresVencido]                                  AS interesvencido
            ,r.[InteresOrdinario]                                AS interesordinario
            ,CAST(proy.Proy2_IntMoratorio   AS decimal(10,4))   AS intmoratorio
            ,r.[IVAIntAccesorios]                                AS ivaintaccesorios
            ,CAST(proy.Proy2_IVAMoratorios  AS decimal(10,4))   AS ivamoratorios
            ,r.[IVA]                                             AS iva
            ,CAST(proy.Proy2_Seguro         AS decimal(10,4))   AS seguro
            ,r.[Total]                                           AS total
            ,r.[TotalExigible]                                   AS totalexigible
            ,r.[EstadoCartera]                                   AS estadocartera
            ,r.[MontoAmortizacion]                               AS montoamortizacion
            ,r.[AmortizacionesVencidas]                          AS amortizacionesvencidas
            ,r.[FchUltimoPago]                                   AS fchultimopago
            ,r.[MontoUltimoPago]                                 AS Montoultimopgo
            ,r.[DiasDevengadosDesdeOtorgamiento]                 AS diasdevengadosdesdeotorgamiento
            ,r.[DiasAtraso]                                      AS diasatraso
            ,r.[SaldoVencido]                                    AS saldovencido
            ,r.[NomConvenio]                                     AS nomconvenio
            ,r.[EstatusGral]                                     AS estatusgral
            ,r.[EstatusInt]                                      AS estatusint
            ,r.[DiasAtrso]                                       AS diasatrso
            ,r.[BandaDiasAtraso]                                 AS bandadiasatraso
            ,r.[Exigible1]                                       AS exigible1
            ,r.[Liquidar1]                                       AS liquidar1
            ,r.[Exigible2]                                       AS exigible2
            ,r.[Liquidar2]                                       AS liquidar2
            ,r.[Telefono1Acred]                                  AS telefono1acred
            ,r.[Telefono2Acred]                                  AS telefono2acred
            ,r.[OtroAcred]                                       AS otroacred
            ,r.[NombreR1]                                        AS nombrer1
            ,r.[TelefonoR1]                                      AS telefonor1
            ,r.[CalleRef1]                                       AS calleref1
            ,r.[NumExtR1]                                        AS numextr1
            ,r.[NumIntR1]                                        AS numintr1
            ,r.[ColoniaR1]                                       AS coloniar1
            ,r.[CPR1]                                            AS cpr1
            ,r.[MunicipioR1]                                     AS municipior1
            ,r.[EstadoR1]                                        AS estador1
            ,r.[NombreR2]                                        AS nombrer2
            ,r.[TelefonoR2]                                      AS telefonor2
            ,r.[CalleRef2]                                       AS calleref2
            ,r.[NumExtR2]                                        AS numextr2
            ,r.[NumIntR2]                                        AS numintr2
            ,r.[ColoniaR2]                                       AS coloniar2
            ,r.[CPR2]                                            AS cpr2
            ,r.[MunicipioR2]                                     AS municipior2
            ,r.[EstadoR2]                                        AS estador2
            ,r.[NombreR3]                                        AS nombrer3
            ,r.[TelefonoR3]                                      AS telefonor3
            ,r.[CalleRef3]                                       AS calleref3
            ,r.[NumExtR3]                                        AS numextr3
            ,r.[NumIntR3]                                        AS numintr3
            ,r.[ColoniaR3]                                       AS coloniar3
            ,r.[CPR3]                                            AS cpr3
            ,r.[MunicipioR3]                                     AS municipior3
            ,r.[EstadoR3]                                        AS estador3
            ,r.[VentaCartera]                                    AS ventacartera
            ,r.[Producto]                                        AS producto
            ,CONVERT(varchar, LAC.FechaAsignacion, 103)         AS FechaAsignaRespSeg
            ,DATEADD(YEAR, 10, r.FchUltimoPago)                 AS fechaVencimientoGestionOrdinaria
            ,DATEADD(YEAR,  3, r.FchUltimoPago)                 AS fechaVencimientoGestionMercantil
            ,de.Txt_Direccion                                    AS correoElectronico
        FROM [dbo].[AsignacionCobranza] ac
        INNER JOIN [dbo].[RptActSdosDiaria]        r   ON ac.Prestamo = r.Prestamo
        INNER JOIN [dbo].[TR_Cob_Saldos_Proy_Moras] proy ON r.Prestamo = proy.Prestamo
        INNER JOIN dbo.ListaPrestamos              lp  ON ac.Prestamo = CONVERT(numeric(18,0), lp.sNoProspecto)
        LEFT JOIN (
            SELECT s.ID_Persona, s.Txt_Direccion
            FROM (
                SELECT d.ID_Persona, d.Txt_Direccion,
                       RANK() OVER (PARTITION BY d.ID_Persona
                                    ORDER BY d.Fecha_Ult_Accion DESC,
                                             d.Fecha_Inicio    DESC,
                                             d.Id_Direccion    DESC) AS rk
                FROM Originacion_v00.dbo.DR_Dir_Electronicas d
                WHERE d.Cod_Cat_Dir_Electronica = 1
            ) s
            WHERE s.rk = 1
        ) de ON de.ID_Persona = lp.nIdPersona
        LEFT JOIN (
            SELECT Prestamo, FechaAsignacion,
                   RANK() OVER (PARTITION BY Prestamo ORDER BY FechaAsignacion DESC) AS orden
            FROM LogAsignacionCobranza
        ) LAC ON ac.Prestamo = LAC.Prestamo AND LAC.orden = 1
        WHERE Clasificacion IN (@clasificacion, 'OLIVO')
          AND r.Sucursal NOT IN ('RECONSTRUCCION SHF')
          AND r.Liquidar1 > 0
        ORDER BY CASE
                     WHEN @filtro = 'Credito'        THEN ac.[Prestamo]
                     WHEN @filtro = 'Nombre Cliente' THEN r.[Nombre]
                     WHEN @filtro = 'CP'             THEN r.[CodigoPostal]
                 END ASC;
    END

    -- =====================================================================
    -- ROL 2 (Coordinador) sin gestor especifico
    -- =====================================================================
    IF (@rol = 2 AND @idGestor = '')
    BEGIN
        SELECT
             r.[Prestamo]
            ,r.[GestorAsignado]                                  AS gestorasignado
            ,r.[Sucursal]                                        AS sucursal
            ,r.[Nombre]                                          AS nombre
            ,CONVERT(varchar, r.[FechaIngreso])                  AS fechaingreso2
            ,r.[FechaNacimiento]                                 AS fechanacimiento
            ,r.[Genero]                                          AS genero
            ,r.[RFC]                                             AS rfc
            ,r.[CURP]                                            AS curp
            ,r.[FolioIFE]                                        AS folioife
            ,r.[DomicilioCalleNumero]                            AS domiciliocallenumero
            ,r.[Colonia]                                         AS colonia
            ,r.[CodigoPostal]                                    AS codigopostal
            ,r.[CiudadEstado]                                    AS ciudadestado
            ,r.[ClaveLada]                                       AS clavelada
            ,r.[Telefono1]                                       AS telefono1
            ,r.[Telefono2]                                       AS telefono2
            ,r.[Telefono3]                                       AS telefono3
            ,r.[Tel1ConsCC]                                      AS tel1conscc
            ,r.[Tel2ConsCC]                                      AS tel2conscc
            ,r.[Tel3ConsCC]                                      AS tel3conscc
            ,r.[EstadoCivil]                                     AS estadocivil
            ,r.[NombreConyuge]                                   AS nombreconyuge
            ,r.[TipoEmpleado]                                    AS tipoempleado
            ,r.[Municipio]                                       AS municipio
            ,r.[Area]                                            AS area
            ,r.[Convenio]                                        AS convenio
            ,r.[Dependencia]                                     AS dependencia
            ,r.[CredOtorgNoLiq]                                  AS credotorgnoliq
            ,r.[TipoProducto]                                    AS tipoproducto
            ,r.[MontoOtorgado]                                   AS montootorgado
            ,r.[FechaOperacion]                                  AS fechaoperacion
            ,r.[FechaVence]                                      AS fechavence
            ,r.[NumAmortizaciones]                               AS numamortizaciones
            ,r.[Periodicidad]                                    AS periodicidad
            ,r.[PlazoMeses]                                      AS plazomeses
            ,r.[CapitalVencido]                                  AS capitalvencido
            ,r.[Capital]                                         AS capital
            ,r.[InteresSinVencer]                                AS interessinvencer
            ,r.[InteresVencido]                                  AS interesvencido
            ,r.[InteresOrdinario]                                AS interesordinario
            ,CAST(proy.Proy2_IntMoratorio   AS decimal(10,4))   AS intmoratorio
            ,r.[IVAIntAccesorios]                                AS ivaintaccesorios
            ,CAST(proy.Proy2_IVAMoratorios  AS decimal(10,4))   AS ivamoratorios
            ,r.[IVA]                                             AS iva
            ,CAST(proy.Proy2_Seguro         AS decimal(10,4))   AS seguro
            ,r.[Total]                                           AS total
            ,r.[TotalExigible]                                   AS totalexigible
            ,r.[EstadoCartera]                                   AS estadocartera
            ,r.[MontoAmortizacion]                               AS montoamortizacion
            ,r.[AmortizacionesVencidas]                          AS amortizacionesvencidas
            ,r.[FchUltimoPago]                                   AS fchultimopago
            ,r.[MontoUltimoPago]                                 AS Montoultimopgo
            ,r.[DiasDevengadosDesdeOtorgamiento]                 AS diasdevengadosdesdeotorgamiento
            ,r.[DiasAtraso]                                      AS diasatraso
            ,r.[SaldoVencido]                                    AS saldovencido
            ,r.[NomConvenio]                                     AS nomconvenio
            ,r.[EstatusGral]                                     AS estatusgral
            ,r.[EstatusInt]                                      AS estatusint
            ,r.[DiasAtrso]                                       AS diasatrso
            ,r.[BandaDiasAtraso]                                 AS bandadiasatraso
            ,r.[Exigible1]                                       AS exigible1
            ,r.[Liquidar1]                                       AS liquidar1
            ,r.[Exigible2]                                       AS exigible2
            ,r.[Liquidar2]                                       AS liquidar2
            ,r.[Telefono1Acred]                                  AS telefono1acred
            ,r.[Telefono2Acred]                                  AS telefono2acred
            ,r.[OtroAcred]                                       AS otroacred
            ,r.[NombreR1]                                        AS nombrer1
            ,r.[TelefonoR1]                                      AS telefonor1
            ,r.[CalleRef1]                                       AS calleref1
            ,r.[NumExtR1]                                        AS numextr1
            ,r.[NumIntR1]                                        AS numintr1
            ,r.[ColoniaR1]                                       AS coloniar1
            ,r.[CPR1]                                            AS cpr1
            ,r.[MunicipioR1]                                     AS municipior1
            ,r.[EstadoR1]                                        AS estador1
            ,r.[NombreR2]                                        AS nombrer2
            ,r.[TelefonoR2]                                      AS telefonor2
            ,r.[CalleRef2]                                       AS calleref2
            ,r.[NumExtR2]                                        AS numextr2
            ,r.[NumIntR2]                                        AS numintr2
            ,r.[ColoniaR2]                                       AS coloniar2
            ,r.[CPR2]                                            AS cpr2
            ,r.[MunicipioR2]                                     AS municipior2
            ,r.[EstadoR2]                                        AS estador2
            ,r.[NombreR3]                                        AS nombrer3
            ,r.[TelefonoR3]                                      AS telefonor3
            ,r.[CalleRef3]                                       AS calleref3
            ,r.[NumExtR3]                                        AS numextr3
            ,r.[NumIntR3]                                        AS numintr3
            ,r.[ColoniaR3]                                       AS coloniar3
            ,r.[CPR3]                                            AS cpr3
            ,r.[MunicipioR3]                                     AS municipior3
            ,r.[EstadoR3]                                        AS estador3
            ,r.[VentaCartera]                                    AS ventacartera
            ,r.[Producto]                                        AS producto
            ,CONVERT(varchar, LAC.FechaAsignacion, 103)         AS FechaAsignaRespSeg
            ,DATEADD(YEAR, 10, r.FchUltimoPago)                 AS fechaVencimientoGestionOrdinaria
            ,DATEADD(YEAR,  3, r.FchUltimoPago)                 AS fechaVencimientoGestionMercantil
            ,de.Txt_Direccion                                    AS correoElectronico
        FROM [Cobranza].[dbo].[AsignacionCobranza] ac
        INNER JOIN CatGestorCoordinador               cgc ON ac.nidGestor = cgc.pk_idGestor
        INNER JOIN dbo.ListaPrestamos                 lp  ON ac.Prestamo  = CONVERT(numeric(18,0), lp.sNoProspecto)
        LEFT  JOIN [Cobranza].[dbo].[RptActSdosDiaria] r  ON ac.Prestamo = r.Prestamo
        INNER JOIN [dbo].[TR_Cob_Saldos_Proy_Moras] proy  ON r.Prestamo  = proy.Prestamo
        LEFT JOIN (
            SELECT s.ID_Persona, s.Txt_Direccion
            FROM (
                SELECT d.ID_Persona, d.Txt_Direccion,
                       RANK() OVER (PARTITION BY d.ID_Persona
                                    ORDER BY d.Fecha_Ult_Accion DESC,
                                             d.Fecha_Inicio    DESC,
                                             d.Id_Direccion    DESC) AS rk
                FROM Originacion_v00.dbo.DR_Dir_Electronicas d
                WHERE d.Cod_Cat_Dir_Electronica = 1
            ) s
            WHERE s.rk = 1
        ) de ON de.ID_Persona = lp.nIdPersona
        LEFT JOIN (
            SELECT Prestamo, FechaAsignacion,
                   RANK() OVER (PARTITION BY Prestamo ORDER BY FechaAsignacion DESC) AS orden
            FROM LogAsignacionCobranza
        ) LAC ON ac.Prestamo = LAC.Prestamo AND LAC.orden = 1
        WHERE cgc.pk_idCoordinador = @idU
          AND r.Clasificacion     = @clasificacion
          AND r.Sucursal NOT IN ('RECONSTRUCCION SHF')
          AND r.Liquidar1 > 0
        ORDER BY CASE
                     WHEN @filtro = 'Credito'        THEN ac.[Prestamo]
                     WHEN @filtro = 'Nombre Cliente' THEN r.[Nombre]
                     WHEN @filtro = 'CP'             THEN r.[CodigoPostal]
                 END ASC;
    END

    -- =====================================================================
    -- GESTOR ESPECIFICO - Cartera Ordinaria (roles != 3)
    -- =====================================================================
    IF (@idGestor != '' AND @clasificacion = 'Ordinaria' AND @rol != '3')
    BEGIN
        SELECT
             r.[Prestamo]
            ,r.[GestorAsignado]                                  AS gestorasignado
            ,r.[Sucursal]                                        AS sucursal
            ,r.[Nombre]                                          AS nombre
            ,r.[FechaNacimiento]                                 AS fechanacimiento
            ,CONVERT(varchar, r.[FechaIngreso])                  AS fechaingreso2
            ,r.[Genero]                                          AS genero
            ,r.[RFC]                                             AS rfc
            ,r.[CURP]                                            AS curp
            ,r.[FolioIFE]                                        AS folioife
            ,r.[DomicilioCalleNumero]                            AS domiciliocallenumero
            ,r.[Colonia]                                         AS colonia
            ,r.[CodigoPostal]                                    AS codigopostal
            ,r.[CiudadEstado]                                    AS ciudadestado
            ,r.[ClaveLada]                                       AS clavelada
            ,r.[Telefono1]                                       AS telefono1
            ,r.[Telefono2]                                       AS telefono2
            ,r.[Telefono3]                                       AS telefono3
            ,r.[Tel1ConsCC]                                      AS tel1conscc
            ,r.[Tel2ConsCC]                                      AS tel2conscc
            ,r.[Tel3ConsCC]                                      AS tel3conscc
            ,r.[EstadoCivil]                                     AS estadocivil
            ,r.[NombreConyuge]                                   AS nombreconyuge
            ,r.[TipoEmpleado]                                    AS tipoempleado
            ,r.[Municipio]                                       AS municipio
            ,r.[Area]                                            AS area
            ,r.[Convenio]                                        AS convenio
            ,r.[Dependencia]                                     AS dependencia
            ,r.[CredOtorgNoLiq]                                  AS credotorgnoliq
            ,r.[TipoProducto]                                    AS tipoproducto
            ,r.[MontoOtorgado]                                   AS montootorgado
            ,r.[FechaOperacion]                                  AS fechaoperacion
            ,r.[FechaVence]                                      AS fechavence
            ,r.[NumAmortizaciones]                               AS numamortizaciones
            ,r.[Periodicidad]                                    AS periodicidad
            ,r.[PlazoMeses]                                      AS plazomeses
            ,r.[CapitalVencido]                                  AS capitalvencido
            ,r.[Capital]                                         AS capital
            ,r.[InteresSinVencer]                                AS interessinvencer
            ,r.[InteresVencido]                                  AS interesvencido
            ,r.[InteresOrdinario]                                AS interesordinario
            ,CAST(proy.Proy2_IntMoratorio   AS decimal(10,4))   AS intmoratorio
            ,r.[IVAIntAccesorios]                                AS ivaintaccesorios
            ,CAST(proy.Proy2_IVAMoratorios  AS decimal(10,4))   AS ivamoratorios
            ,r.[IVA]                                             AS iva
            ,CAST(proy.Proy2_Seguro         AS decimal(10,4))   AS seguro
            ,r.[Total]                                           AS total
            ,r.[TotalExigible]                                   AS totalexigible
            ,r.[EstadoCartera]                                   AS estadocartera
            ,r.[MontoAmortizacion]                               AS montoamortizacion
            ,r.[AmortizacionesVencidas]                          AS amortizacionesvencidas
            ,r.[FchUltimoPago]                                   AS fchultimopago
            ,r.[MontoUltimoPago]                                 AS Montoultimopgo
            ,r.[DiasDevengadosDesdeOtorgamiento]                 AS diasdevengadosdesdeotorgamiento
            ,r.[DiasAtraso]                                      AS diasatraso
            ,r.[SaldoVencido]                                    AS saldovencido
            ,r.[NomConvenio]                                     AS nomconvenio
            ,r.[EstatusGral]                                     AS estatusgral
            ,r.[EstatusInt]                                      AS estatusint
            ,r.[DiasAtrso]                                       AS diasatrso
            ,r.[BandaDiasAtraso]                                 AS bandadiasatraso
            ,r.[Exigible1]                                       AS exigible1
            ,r.[Liquidar1]                                       AS liquidar1
            ,r.[Exigible2]                                       AS exigible2
            ,r.[Liquidar2]                                       AS liquidar2
            ,r.[Telefono1Acred]                                  AS telefono1acred
            ,r.[Telefono2Acred]                                  AS telefono2acred
            ,r.[OtroAcred]                                       AS otroacred
            ,r.[NombreR1]                                        AS nombrer1
            ,r.[TelefonoR1]                                      AS telefonor1
            ,r.[CalleRef1]                                       AS calleref1
            ,r.[NumExtR1]                                        AS numextr1
            ,r.[NumIntR1]                                        AS numintr1
            ,r.[ColoniaR1]                                       AS coloniar1
            ,r.[CPR1]                                            AS cpr1
            ,r.[MunicipioR1]                                     AS municipior1
            ,r.[EstadoR1]                                        AS estador1
            ,r.[NombreR2]                                        AS nombrer2
            ,r.[TelefonoR2]                                      AS telefonor2
            ,r.[CalleRef2]                                       AS calleref2
            ,r.[NumExtR2]                                        AS numextr2
            ,r.[NumIntR2]                                        AS numintr2
            ,r.[ColoniaR2]                                       AS coloniar2
            ,r.[CPR2]                                            AS cpr2
            ,r.[MunicipioR2]                                     AS municipior2
            ,r.[EstadoR2]                                        AS estador2
            ,r.[NombreR3]                                        AS nombrer3
            ,r.[TelefonoR3]                                      AS telefonor3
            ,r.[CalleRef3]                                       AS calleref3
            ,r.[NumExtR3]                                        AS numextr3
            ,r.[NumIntR3]                                        AS numintr3
            ,r.[ColoniaR3]                                       AS coloniar3
            ,r.[CPR3]                                            AS cpr3
            ,r.[MunicipioR3]                                     AS municipior3
            ,r.[EstadoR3]                                        AS estador3
            ,r.[VentaCartera]                                    AS ventacartera
            ,r.[Producto]                                        AS producto
            ,CONVERT(varchar, LAC.FechaAsignacion, 103)         AS FechaAsignaRespSeg
            ,DATEADD(YEAR, 10, r.FchUltimoPago)                 AS fechaVencimientoGestionOrdinaria
            ,DATEADD(YEAR,  3, r.FchUltimoPago)                 AS fechaVencimientoGestionMercantil
            ,de.Txt_Direccion                                    AS correoElectronico
        FROM [Cobranza].[dbo].[AsignacionCobranza] ac
        INNER JOIN dbo.ListaPrestamos              lp   ON ac.Prestamo = CONVERT(numeric(18,0), lp.sNoProspecto)
        INNER JOIN [Cobranza].[dbo].[RptActSdosDiaria] r ON ac.Prestamo = r.Prestamo
        INNER JOIN [dbo].[TR_Cob_Saldos_Proy_Moras] proy ON r.Prestamo = proy.Prestamo
        LEFT JOIN (
            SELECT s.ID_Persona, s.Txt_Direccion
            FROM (
                SELECT d.ID_Persona, d.Txt_Direccion,
                       RANK() OVER (PARTITION BY d.ID_Persona
                                    ORDER BY d.Fecha_Ult_Accion DESC,
                                             d.Fecha_Inicio    DESC,
                                             d.Id_Direccion    DESC) AS rk
                FROM Originacion_v00.dbo.DR_Dir_Electronicas d
                WHERE d.Cod_Cat_Dir_Electronica = 1
            ) s
            WHERE s.rk = 1
        ) de ON de.ID_Persona = lp.nIdPersona
        LEFT JOIN (
            SELECT Prestamo, FechaAsignacion,
                   RANK() OVER (PARTITION BY Prestamo ORDER BY FechaAsignacion DESC) AS orden
            FROM LogAsignacionCobranza
        ) LAC ON ac.Prestamo = LAC.Prestamo AND LAC.orden = 1
        WHERE ac.nIdGestor = @idGestor
          AND r.Clasificacion = 'Ordinaria'
          AND r.Sucursal NOT IN ('RECONSTRUCCION SHF')
          AND r.Liquidar1 > 0
        ORDER BY CASE
                     WHEN @filtro = 'Credito'        THEN CONVERT(varchar, ac.[Prestamo])
                     WHEN @filtro = 'Nombre Cliente' THEN r.[Nombre]
                     WHEN @filtro = 'CP'             THEN r.[CodigoPostal]
                 END ASC;
    END

    -- =====================================================================
    -- GESTOR ESPECIFICO - Cartera Extraordinaria/Olivo (roles != 3)
    -- =====================================================================
    IF (@idGestor != '' AND @clasificacion = 'Extraordinaria' AND @rol != '3')
    BEGIN
        SELECT
             r.[Prestamo]
            ,r.[GestorAsignado]                                  AS gestorasignado
            ,r.[Sucursal]                                        AS sucursal
            ,r.[Nombre]                                          AS nombre
            ,r.[FechaNacimiento]                                 AS fechanacimiento
            ,CONVERT(varchar, r.[FechaIngreso])                  AS fechaingreso2
            ,r.[Genero]                                          AS genero
            ,r.[RFC]                                             AS rfc
            ,r.[CURP]                                            AS curp
            ,r.[FolioIFE]                                        AS folioife
            ,r.[DomicilioCalleNumero]                            AS domiciliocallenumero
            ,r.[Colonia]                                         AS colonia
            ,r.[CodigoPostal]                                    AS codigopostal
            ,r.[CiudadEstado]                                    AS ciudadestado
            ,r.[ClaveLada]                                       AS clavelada
            ,r.[Telefono1]                                       AS telefono1
            ,r.[Telefono2]                                       AS telefono2
            ,r.[Telefono3]                                       AS telefono3
            ,r.[Tel1ConsCC]                                      AS tel1conscc
            ,r.[Tel2ConsCC]                                      AS tel2conscc
            ,r.[Tel3ConsCC]                                      AS tel3conscc
            ,r.[EstadoCivil]                                     AS estadocivil
            ,r.[NombreConyuge]                                   AS nombreconyuge
            ,r.[TipoEmpleado]                                    AS tipoempleado
            ,r.[Municipio]                                       AS municipio
            ,r.[Area]                                            AS area
            ,r.[Convenio]                                        AS convenio
            ,r.[Dependencia]                                     AS dependencia
            ,r.[CredOtorgNoLiq]                                  AS credotorgnoliq
            ,r.[TipoProducto]                                    AS tipoproducto
            ,r.[MontoOtorgado]                                   AS montootorgado
            ,r.[FechaOperacion]                                  AS fechaoperacion
            ,r.[FechaVence]                                      AS fechavence
            ,r.[NumAmortizaciones]                               AS numamortizaciones
            ,r.[Periodicidad]                                    AS periodicidad
            ,r.[PlazoMeses]                                      AS plazomeses
            ,r.[CapitalVencido]                                  AS capitalvencido
            ,r.[Capital]                                         AS capital
            ,r.[InteresSinVencer]                                AS interessinvencer
            ,r.[InteresVencido]                                  AS interesvencido
            ,r.[InteresOrdinario]                                AS interesordinario
            ,CAST(proy.Proy2_IntMoratorio   AS decimal(10,4))   AS intmoratorio
            ,r.[IVAIntAccesorios]                                AS ivaintaccesorios
            ,CAST(proy.Proy2_IVAMoratorios  AS decimal(10,4))   AS ivamoratorios
            ,r.[IVA]                                             AS iva
            ,CAST(proy.Proy2_Seguro         AS decimal(10,4))   AS seguro
            ,r.[Total]                                           AS total
            ,r.[TotalExigible]                                   AS totalexigible
            ,r.[EstadoCartera]                                   AS estadocartera
            ,r.[MontoAmortizacion]                               AS montoamortizacion
            ,r.[AmortizacionesVencidas]                          AS amortizacionesvencidas
            ,r.[FchUltimoPago]                                   AS fchultimopago
            ,r.[MontoUltimoPago]                                 AS Montoultimopgo
            ,r.[DiasDevengadosDesdeOtorgamiento]                 AS diasdevengadosdesdeotorgamiento
            ,r.[DiasAtraso]                                      AS diasatraso
            ,r.[SaldoVencido]                                    AS saldovencido
            ,r.[NomConvenio]                                     AS nomconvenio
            ,r.[EstatusGral]                                     AS estatusgral
            ,r.[EstatusInt]                                      AS estatusint
            ,r.[DiasAtrso]                                       AS diasatrso
            ,r.[BandaDiasAtraso]                                 AS bandadiasatraso
            ,r.[Exigible1]                                       AS exigible1
            ,r.[Liquidar1]                                       AS liquidar1
            ,r.[Exigible2]                                       AS exigible2
            ,r.[Liquidar2]                                       AS liquidar2
            ,r.[Telefono1Acred]                                  AS telefono1acred
            ,r.[Telefono2Acred]                                  AS telefono2acred
            ,r.[OtroAcred]                                       AS otroacred
            ,r.[NombreR1]                                        AS nombrer1
            ,r.[TelefonoR1]                                      AS telefonor1
            ,r.[CalleRef1]                                       AS calleref1
            ,r.[NumExtR1]                                        AS numextr1
            ,r.[NumIntR1]                                        AS numintr1
            ,r.[ColoniaR1]                                       AS coloniar1
            ,r.[CPR1]                                            AS cpr1
            ,r.[MunicipioR1]                                     AS municipior1
            ,r.[EstadoR1]                                        AS estador1
            ,r.[NombreR2]                                        AS nombrer2
            ,r.[TelefonoR2]                                      AS telefonor2
            ,r.[CalleRef2]                                       AS calleref2
            ,r.[NumExtR2]                                        AS numextr2
            ,r.[NumIntR2]                                        AS numintr2
            ,r.[ColoniaR2]                                       AS coloniar2
            ,r.[CPR2]                                            AS cpr2
            ,r.[MunicipioR2]                                     AS municipior2
            ,r.[EstadoR2]                                        AS estador2
            ,r.[NombreR3]                                        AS nombrer3
            ,r.[TelefonoR3]                                      AS telefonor3
            ,r.[CalleRef3]                                       AS calleref3
            ,r.[NumExtR3]                                        AS numextr3
            ,r.[NumIntR3]                                        AS numintr3
            ,r.[ColoniaR3]                                       AS coloniar3
            ,r.[CPR3]                                            AS cpr3
            ,r.[MunicipioR3]                                     AS municipior3
            ,r.[EstadoR3]                                        AS estador3
            ,r.[VentaCartera]                                    AS ventacartera
            ,r.[Producto]                                        AS producto
            ,CONVERT(varchar, LAC.FechaAsignacion, 103)         AS FechaAsignaRespSeg
            ,DATEADD(YEAR, 10, r.FchUltimoPago)                 AS fechaVencimientoGestionOrdinaria
            ,DATEADD(YEAR,  3, r.FchUltimoPago)                 AS fechaVencimientoGestionMercantil
            ,de.Txt_Direccion                                    AS correoElectronico
        FROM [Cobranza].[dbo].[AsignacionCobranza] ac
        INNER JOIN dbo.ListaPrestamos              lp   ON ac.Prestamo = CONVERT(numeric(18,0), lp.sNoProspecto)
        INNER JOIN [Cobranza].[dbo].[RptActSdosDiaria] r ON ac.Prestamo = r.Prestamo
        INNER JOIN [dbo].[TR_Cob_Saldos_Proy_Moras] proy ON r.Prestamo = proy.Prestamo
        LEFT JOIN (
            SELECT s.ID_Persona, s.Txt_Direccion
            FROM (
                SELECT d.ID_Persona, d.Txt_Direccion,
                       RANK() OVER (PARTITION BY d.ID_Persona
                                    ORDER BY d.Fecha_Ult_Accion DESC,
                                             d.Fecha_Inicio    DESC,
                                             d.Id_Direccion    DESC) AS rk
                FROM Originacion_v00.dbo.DR_Dir_Electronicas d
                WHERE d.Cod_Cat_Dir_Electronica = 1
            ) s
            WHERE s.rk = 1
        ) de ON de.ID_Persona = lp.nIdPersona
        LEFT JOIN (
            SELECT Prestamo, FechaAsignacion,
                   RANK() OVER (PARTITION BY Prestamo ORDER BY FechaAsignacion DESC) AS orden
            FROM LogAsignacionCobranza
        ) LAC ON ac.Prestamo = LAC.Prestamo AND LAC.orden = 1
        WHERE ac.nIdGestor = @idGestor
          AND (r.Clasificacion = 'Extraordinaria' OR r.Clasificacion = 'Olivo')
          AND r.Sucursal NOT IN ('RECONSTRUCCION SHF')
          AND r.Liquidar1 > 0
        ORDER BY CASE
                     WHEN @filtro = 'Credito'        THEN CONVERT(varchar, ac.[Prestamo])
                     WHEN @filtro = 'Nombre Cliente' THEN r.[Nombre]
                     WHEN @filtro = 'CP'             THEN r.[CodigoPostal]
                 END ASC;
    END

    -- =====================================================================
    -- ROL 3 (Gestor "Por Asignar") - Cartera Ordinaria
    -- =====================================================================
    IF (@idGestor != '' AND @clasificacion = 'Ordinaria' AND @rol = '3')
    BEGIN
        SELECT
             r.[Prestamo]
            ,r.[GestorAsignado]                                  AS gestorasignado
            ,r.[Sucursal]                                        AS sucursal
            ,r.[Nombre]                                          AS nombre
            ,r.[FechaNacimiento]                                 AS fechanacimiento
            ,CONVERT(varchar, r.[FechaIngreso])                  AS fechaingreso2
            ,r.[Genero]                                          AS genero
            ,r.[RFC]                                             AS rfc
            ,r.[CURP]                                            AS curp
            ,r.[FolioIFE]                                        AS folioife
            ,r.[DomicilioCalleNumero]                            AS domiciliocallenumero
            ,r.[Colonia]                                         AS colonia
            ,r.[CodigoPostal]                                    AS codigopostal
            ,r.[CiudadEstado]                                    AS ciudadestado
            ,r.[ClaveLada]                                       AS clavelada
            ,r.[Telefono1]                                       AS telefono1
            ,r.[Telefono2]                                       AS telefono2
            ,r.[Telefono3]                                       AS telefono3
            ,r.[Tel1ConsCC]                                      AS tel1conscc
            ,r.[Tel2ConsCC]                                      AS tel2conscc
            ,r.[Tel3ConsCC]                                      AS tel3conscc
            ,r.[EstadoCivil]                                     AS estadocivil
            ,r.[NombreConyuge]                                   AS nombreconyuge
            ,r.[TipoEmpleado]                                    AS tipoempleado
            ,r.[Municipio]                                       AS municipio
            ,r.[Area]                                            AS area
            ,r.[Convenio]                                        AS convenio
            ,r.[Dependencia]                                     AS dependencia
            ,r.[CredOtorgNoLiq]                                  AS credotorgnoliq
            ,r.[TipoProducto]                                    AS tipoproducto
            ,r.[MontoOtorgado]                                   AS montootorgado
            ,r.[FechaOperacion]                                  AS fechaoperacion
            ,r.[FechaVence]                                      AS fechavence
            ,r.[NumAmortizaciones]                               AS numamortizaciones
            ,r.[Periodicidad]                                    AS periodicidad
            ,r.[PlazoMeses]                                      AS plazomeses
            ,r.[CapitalVencido]                                  AS capitalvencido
            ,r.[Capital]                                         AS capital
            ,r.[InteresSinVencer]                                AS interessinvencer
            ,r.[InteresVencido]                                  AS interesvencido
            ,r.[InteresOrdinario]                                AS interesordinario
            ,CAST(proy.Proy2_IntMoratorio   AS decimal(10,4))   AS intmoratorio
            ,r.[IVAIntAccesorios]                                AS ivaintaccesorios
            ,CAST(proy.Proy2_IVAMoratorios  AS decimal(10,4))   AS ivamoratorios
            ,r.[IVA]                                             AS iva
            ,CAST(proy.Proy2_Seguro         AS decimal(10,4))   AS seguro
            ,r.[Total]                                           AS total
            ,r.[TotalExigible]                                   AS totalexigible
            ,r.[EstadoCartera]                                   AS estadocartera
            ,r.[MontoAmortizacion]                               AS montoamortizacion
            ,r.[AmortizacionesVencidas]                          AS amortizacionesvencidas
            ,r.[FchUltimoPago]                                   AS fchultimopago
            ,r.[MontoUltimoPago]                                 AS Montoultimopgo
            ,r.[DiasDevengadosDesdeOtorgamiento]                 AS diasdevengadosdesdeotorgamiento
            ,r.[DiasAtraso]                                      AS diasatraso
            ,r.[SaldoVencido]                                    AS saldovencido
            ,r.[NomConvenio]                                     AS nomconvenio
            ,r.[EstatusGral]                                     AS estatusgral
            ,r.[EstatusInt]                                      AS estatusint
            ,r.[DiasAtrso]                                       AS diasatrso
            ,r.[BandaDiasAtraso]                                 AS bandadiasatraso
            ,r.[Exigible1]                                       AS exigible1
            ,r.[Liquidar1]                                       AS liquidar1
            ,r.[Exigible2]                                       AS exigible2
            ,r.[Liquidar2]                                       AS liquidar2
            ,r.[Telefono1Acred]                                  AS telefono1acred
            ,r.[Telefono2Acred]                                  AS telefono2acred
            ,r.[OtroAcred]                                       AS otroacred
            ,r.[NombreR1]                                        AS nombrer1
            ,r.[TelefonoR1]                                      AS telefonor1
            ,r.[CalleRef1]                                       AS calleref1
            ,r.[NumExtR1]                                        AS numextr1
            ,r.[NumIntR1]                                        AS numintr1
            ,r.[ColoniaR1]                                       AS coloniar1
            ,r.[CPR1]                                            AS cpr1
            ,r.[MunicipioR1]                                     AS municipior1
            ,r.[EstadoR1]                                        AS estador1
            ,r.[NombreR2]                                        AS nombrer2
            ,r.[TelefonoR2]                                      AS telefonor2
            ,r.[CalleRef2]                                       AS calleref2
            ,r.[NumExtR2]                                        AS numextr2
            ,r.[NumIntR2]                                        AS numintr2
            ,r.[ColoniaR2]                                       AS coloniar2
            ,r.[CPR2]                                            AS cpr2
            ,r.[MunicipioR2]                                     AS municipior2
            ,r.[EstadoR2]                                        AS estador2
            ,r.[NombreR3]                                        AS nombrer3
            ,r.[TelefonoR3]                                      AS telefonor3
            ,r.[CalleRef3]                                       AS calleref3
            ,r.[NumExtR3]                                        AS numextr3
            ,r.[NumIntR3]                                        AS numintr3
            ,r.[ColoniaR3]                                       AS coloniar3
            ,r.[CPR3]                                            AS cpr3
            ,r.[MunicipioR3]                                     AS municipior3
            ,r.[EstadoR3]                                        AS estador3
            ,r.[VentaCartera]                                    AS ventacartera
            ,r.[Producto]                                        AS producto
            ,CONVERT(varchar, LAC.FechaAsignacion, 103)         AS FechaAsignaRespSeg
            ,DATEADD(YEAR, 10, r.FchUltimoPago)                 AS fechaVencimientoGestionOrdinaria
            ,DATEADD(YEAR,  3, r.FchUltimoPago)                 AS fechaVencimientoGestionMercantil
            ,de.Txt_Direccion                                    AS correoElectronico
        FROM [Cobranza].[dbo].[RptActSdosDiaria] r
        INNER JOIN [dbo].[TR_Cob_Saldos_Proy_Moras] proy ON r.Prestamo = proy.Prestamo
        INNER JOIN dbo.ListaPrestamos              lp   ON r.Prestamo = CONVERT(numeric(18,0), lp.sNoProspecto)
        LEFT JOIN (
            SELECT s.ID_Persona, s.Txt_Direccion
            FROM (
                SELECT d.ID_Persona, d.Txt_Direccion,
                       RANK() OVER (PARTITION BY d.ID_Persona
                                    ORDER BY d.Fecha_Ult_Accion DESC,
                                             d.Fecha_Inicio    DESC,
                                             d.Id_Direccion    DESC) AS rk
                FROM Originacion_v00.dbo.DR_Dir_Electronicas d
                WHERE d.Cod_Cat_Dir_Electronica = 1
            ) s
            WHERE s.rk = 1
        ) de ON de.ID_Persona = lp.nIdPersona
        LEFT JOIN (
            SELECT Prestamo, FechaAsignacion,
                   RANK() OVER (PARTITION BY Prestamo ORDER BY FechaAsignacion DESC) AS orden
            FROM LogAsignacionCobranza
        ) LAC ON r.Prestamo = LAC.Prestamo AND LAC.orden = 1
        WHERE r.Clasificacion = 'Ordinaria'
          AND r.GestorAsignado = 'Por Asignar'
          AND r.Sucursal NOT IN ('RECONSTRUCCION SHF')
          AND r.Liquidar1 > 0
        ORDER BY CASE
                     WHEN @filtro = 'Credito'        THEN CONVERT(varchar, r.Prestamo)
                     WHEN @filtro = 'Nombre Cliente' THEN r.[Nombre]
                     WHEN @filtro = 'CP'             THEN r.[CodigoPostal]
                 END ASC;
    END

    -- =====================================================================
    -- ROL 3 (Gestor "Por Asignar") - Cartera Extraordinaria/Olivo
    -- =====================================================================
    IF (@idGestor != '' AND @clasificacion = 'Extraordinaria' AND @rol = '3')
    BEGIN
        SELECT
             r.[Prestamo]
            ,r.[GestorAsignado]                                  AS gestorasignado
            ,r.[Sucursal]                                        AS sucursal
            ,r.[Nombre]                                          AS nombre
            ,r.[FechaNacimiento]                                 AS fechanacimiento
            ,CONVERT(varchar, r.[FechaIngreso])                  AS fechaingreso2
            ,r.[Genero]                                          AS genero
            ,r.[RFC]                                             AS rfc
            ,r.[CURP]                                            AS curp
            ,r.[FolioIFE]                                        AS folioife
            ,r.[DomicilioCalleNumero]                            AS domiciliocallenumero
            ,r.[Colonia]                                         AS colonia
            ,r.[CodigoPostal]                                    AS codigopostal
            ,r.[CiudadEstado]                                    AS ciudadestado
            ,r.[ClaveLada]                                       AS clavelada
            ,r.[Telefono1]                                       AS telefono1
            ,r.[Telefono2]                                       AS telefono2
            ,r.[Telefono3]                                       AS telefono3
            ,r.[Tel1ConsCC]                                      AS tel1conscc
            ,r.[Tel2ConsCC]                                      AS tel2conscc
            ,r.[Tel3ConsCC]                                      AS tel3conscc
            ,r.[EstadoCivil]                                     AS estadocivil
            ,r.[NombreConyuge]                                   AS nombreconyuge
            ,r.[TipoEmpleado]                                    AS tipoempleado
            ,r.[Municipio]                                       AS municipio
            ,r.[Area]                                            AS area
            ,r.[Convenio]                                        AS convenio
            ,r.[Dependencia]                                     AS dependencia
            ,r.[CredOtorgNoLiq]                                  AS credotorgnoliq
            ,r.[TipoProducto]                                    AS tipoproducto
            ,r.[MontoOtorgado]                                   AS montootorgado
            ,r.[FechaOperacion]                                  AS fechaoperacion
            ,r.[FechaVence]                                      AS fechavence
            ,r.[NumAmortizaciones]                               AS numamortizaciones
            ,r.[Periodicidad]                                    AS periodicidad
            ,r.[PlazoMeses]                                      AS plazomeses
            ,r.[CapitalVencido]                                  AS capitalvencido
            ,r.[Capital]                                         AS capital
            ,r.[InteresSinVencer]                                AS interessinvencer
            ,r.[InteresVencido]                                  AS interesvencido
            ,r.[InteresOrdinario]                                AS interesordinario
            ,CAST(proy.Proy2_IntMoratorio   AS decimal(10,4))   AS intmoratorio
            ,r.[IVAIntAccesorios]                                AS ivaintaccesorios
            ,CAST(proy.Proy2_IVAMoratorios  AS decimal(10,4))   AS ivamoratorios
            ,r.[IVA]                                             AS iva
            ,CAST(proy.Proy2_Seguro         AS decimal(10,4))   AS seguro
            ,r.[Total]                                           AS total
            ,r.[TotalExigible]                                   AS totalexigible
            ,r.[EstadoCartera]                                   AS estadocartera
            ,r.[MontoAmortizacion]                               AS montoamortizacion
            ,r.[AmortizacionesVencidas]                          AS amortizacionesvencidas
            ,r.[FchUltimoPago]                                   AS fchultimopago
            ,r.[MontoUltimoPago]                                 AS Montoultimopgo
            ,r.[DiasDevengadosDesdeOtorgamiento]                 AS diasdevengadosdesdeotorgamiento
            ,r.[DiasAtraso]                                      AS diasatraso
            ,r.[SaldoVencido]                                    AS saldovencido
            ,r.[NomConvenio]                                     AS nomconvenio
            ,r.[EstatusGral]                                     AS estatusgral
            ,r.[EstatusInt]                                      AS estatusint
            ,r.[DiasAtrso]                                       AS diasatrso
            ,r.[BandaDiasAtraso]                                 AS bandadiasatraso
            ,r.[Exigible1]                                       AS exigible1
            ,r.[Liquidar1]                                       AS liquidar1
            ,r.[Exigible2]                                       AS exigible2
            ,r.[Liquidar2]                                       AS liquidar2
            ,r.[Telefono1Acred]                                  AS telefono1acred
            ,r.[Telefono2Acred]                                  AS telefono2acred
            ,r.[OtroAcred]                                       AS otroacred
            ,r.[NombreR1]                                        AS nombrer1
            ,r.[TelefonoR1]                                      AS telefonor1
            ,r.[CalleRef1]                                       AS calleref1
            ,r.[NumExtR1]                                        AS numextr1
            ,r.[NumIntR1]                                        AS numintr1
            ,r.[ColoniaR1]                                       AS coloniar1
            ,r.[CPR1]                                            AS cpr1
            ,r.[MunicipioR1]                                     AS municipior1
            ,r.[EstadoR1]                                        AS estador1
            ,r.[NombreR2]                                        AS nombrer2
            ,r.[TelefonoR2]                                      AS telefonor2
            ,r.[CalleRef2]                                       AS calleref2
            ,r.[NumExtR2]                                        AS numextr2
            ,r.[NumIntR2]                                        AS numintr2
            ,r.[ColoniaR2]                                       AS coloniar2
            ,r.[CPR2]                                            AS cpr2
            ,r.[MunicipioR2]                                     AS municipior2
            ,r.[EstadoR2]                                        AS estador2
            ,r.[NombreR3]                                        AS nombrer3
            ,r.[TelefonoR3]                                      AS telefonor3
            ,r.[CalleRef3]                                       AS calleref3
            ,r.[NumExtR3]                                        AS numextr3
            ,r.[NumIntR3]                                        AS numintr3
            ,r.[ColoniaR3]                                       AS coloniar3
            ,r.[CPR3]                                            AS cpr3
            ,r.[MunicipioR3]                                     AS municipior3
            ,r.[EstadoR3]                                        AS estador3
            ,r.[VentaCartera]                                    AS ventacartera
            ,r.[Producto]                                        AS producto
            ,CONVERT(varchar, LAC.FechaAsignacion, 103)         AS FechaAsignaRespSeg
            ,DATEADD(YEAR, 10, r.FchUltimoPago)                 AS fechaVencimientoGestionOrdinaria
            ,DATEADD(YEAR,  3, r.FchUltimoPago)                 AS fechaVencimientoGestionMercantil
            ,de.Txt_Direccion                                    AS correoElectronico
        FROM [Cobranza].[dbo].[RptActSdosDiaria] r
        INNER JOIN [dbo].[TR_Cob_Saldos_Proy_Moras] proy ON r.Prestamo = proy.Prestamo
        INNER JOIN dbo.ListaPrestamos              lp   ON r.Prestamo = CONVERT(numeric(18,0), lp.sNoProspecto)
        LEFT JOIN (
            SELECT s.ID_Persona, s.Txt_Direccion
            FROM (
                SELECT d.ID_Persona, d.Txt_Direccion,
                       RANK() OVER (PARTITION BY d.ID_Persona
                                    ORDER BY d.Fecha_Ult_Accion DESC,
                                             d.Fecha_Inicio    DESC,
                                             d.Id_Direccion    DESC) AS rk
                FROM Originacion_v00.dbo.DR_Dir_Electronicas d
                WHERE d.Cod_Cat_Dir_Electronica = 1
            ) s
            WHERE s.rk = 1
        ) de ON de.ID_Persona = lp.nIdPersona
        LEFT JOIN (
            SELECT Prestamo, FechaAsignacion,
                   RANK() OVER (PARTITION BY Prestamo ORDER BY FechaAsignacion DESC) AS orden
            FROM LogAsignacionCobranza
        ) LAC ON r.Prestamo = LAC.Prestamo AND LAC.orden = 1
        WHERE (r.Clasificacion = 'Extraordinaria' OR r.Clasificacion = 'Olivo')
          AND r.GestorAsignado = 'Por Asignar'
          AND r.Sucursal NOT IN ('RECONSTRUCCION SHF')
          AND r.Liquidar1 > 0
        ORDER BY CASE
                     WHEN @filtro = 'Credito'        THEN CONVERT(varchar, r.[Prestamo])
                     WHEN @filtro = 'Nombre Cliente' THEN r.[Nombre]
                     WHEN @filtro = 'CP'             THEN r.[CodigoPostal]
                 END ASC;
    END

END
GO
