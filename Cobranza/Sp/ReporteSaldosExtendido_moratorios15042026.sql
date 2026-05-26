USE Cobranza
GO

CREATE OR ALTER PROCEDURE dbo.ReporteSaldosExtendido_moratorios15042026
    @idGestor     int,
    @filtro       varchar(25),
    @idU          int,
    @clasificacion varchar(30)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @rol int;
    SET @rol = (SELECT [pkCatRol] FROM [dbo].[Usr_Usuarios] WHERE [ID_Usuario] = @idU);

    -- ROL 1 sin gestor: supervisor ve toda la cartera
    IF (@rol = 1 AND @idGestor = '')
    BEGIN
        SELECT
             r.[Prestamo]
            ,r.[GestorAsignado]                                  AS gestorasignado
            ,r.[Sucursal]                                        AS sucursal
            ,[Nombre]                                            AS nombre
            ,[FechaNacimiento]                                   AS fechanacimiento
            ,CONVERT(varchar,[FechaIngreso])                     AS fechaingreso2
            ,[Genero]                                            AS genero
            ,[RFC]                                               AS rfc
            ,[CURP]                                              AS curp
            ,[FolioIFE]                                          AS folioife
            ,[DomicilioCalleNumero]                              AS domiciliocallenumero
            ,[Colonia]                                           AS colonia
            ,[CodigoPostal]                                      AS codigopostal
            ,[CiudadEstado]                                      AS ciudadestado
            ,[ClaveLada]                                         AS clavelada
            ,[Telefono1]                                         AS telefono1
            ,[Telefono2]                                         AS telefono2
            ,[Telefono3]                                         AS telefono3
            ,[Tel1ConsCC]                                        AS tel1conscc
            ,[Tel2ConsCC]                                        AS tel2conscc
            ,[Tel3ConsCC]                                        AS tel3conscc
            ,[EstadoCivil]                                       AS estadocivil
            ,[NombreConyuge]                                     AS nombreconyuge
            ,[TipoEmpleado]                                      AS tipoempleado
            ,[Municipio]                                         AS municipio
            ,[Area]                                              AS area
            ,[Convenio]                                          AS convenio
            ,[Dependencia]                                       AS dependencia
            ,r.[CredOtorgNoLiq]                                  AS credotorgnoliq
            ,[TipoProducto]                                      AS tipoproducto
            ,[MontoOtorgado]                                     AS montootorgado
            ,[FechaOperacion]                                    AS fechaoperacion
            ,[FechaVence]                                        AS fechavence
            ,[NumAmortizaciones]                                 AS numamortizaciones
            ,[Periodicidad]                                      AS periodicidad
            ,[PlazoMeses]                                        AS plazomeses
            ,[CapitalVencido]                                    AS capitalvencido
            ,[Capital]                                           AS capital
            ,[InteresSinVencer]                                  AS interessinvencer
            ,[InteresVencido]                                    AS interesvencido
            ,[InteresOrdinario]                                  AS interesordinario
            ,CAST(proy.Proy2_IntMoratorio  AS float)              AS intmoratorio
            ,[IVAIntAccesorios]                                  AS ivaintaccesorios
            ,CAST(proy.Proy2_IVAMoratorios AS float)             AS ivamoratorios
            ,[IVA]                                               AS iva
            ,CAST(proy.Proy2_Seguro        AS float)             AS seguro
            ,[Total]                                             AS total
            ,[TotalExigible]                                     AS totalexigible
            ,r.[EstadoCartera]                                   AS estadocartera
            ,r.[MontoAmortizacion]                               AS montoamortizacion
            ,[AmortizacionesVencidas]                            AS amortizacionesvencidas
            ,[FchUltimoPago]                                     AS fchultimopago
            ,[MontoUltimoPago]                                   AS Montoultimopgo
            ,r.[DiasDevengadosDesdeOtorgamiento]                 AS diasdevengadosdesdeotorgamiento
            ,[DiasAtraso]                                        AS diasatraso
            ,[SaldoVencido]                                      AS saldovencido
            ,[NomConvenio]                                       AS nomconvenio
            ,r.[EstatusGral]                                     AS estatusgral
            ,r.[EstatusInt]                                      AS estatusint
            ,r.[DiasAtrso]                                       AS diasatrso
            ,r.[BandaDiasAtraso]                                 AS bandadiasatraso
            ,[Exigible1]                                         AS exigible1
            ,[Liquidar1]                                         AS liquidar1
            ,[Exigible2]                                         AS exigible2
            ,[Liquidar2]                                         AS liquidar2
            ,[Telefono1Acred]                                    AS telefono1acred
            ,[Telefono2Acred]                                    AS telefono2acred
            ,[OtroAcred]                                         AS otroacred
            ,[NombreR1]                                          AS nombrer1
            ,[TelefonoR1]                                        AS telefonor1
            ,[CalleRef1]                                         AS calleref1
            ,[NumExtR1]                                          AS numextr1
            ,[NumIntR1]                                          AS numintr1
            ,[ColoniaR1]                                         AS coloniar1
            ,[CPR1]                                              AS cpr1
            ,[MunicipioR1]                                       AS municipior1
            ,[EstadoR1]                                          AS estador1
            ,[NombreR2]                                          AS nombrer2
            ,[TelefonoR2]                                        AS telefonor2
            ,[CalleRef2]                                         AS calleref2
            ,[NumExtR2]                                          AS numextr2
            ,[NumIntR2]                                          AS numintr2
            ,[ColoniaR2]                                         AS coloniar2
            ,[CPR2]                                              AS cpr2
            ,[MunicipioR2]                                       AS municipior2
            ,[EstadoR2]                                          AS estador2
            ,[NombreR3]                                          AS nombrer3
            ,[TelefonoR3]                                        AS telefonor3
            ,[CalleRef3]                                         AS calleref3
            ,[NumExtR3]                                          AS numextr3
            ,[NumIntR3]                                          AS numintr3
            ,[ColoniaR3]                                         AS coloniar3
            ,[CPR3]                                              AS cpr3
            ,[MunicipioR3]                                       AS municipior3
            ,[EstadoR3]                                          AS estador3
            ,r.[VentaCartera]                                    AS ventacartera
            ,r.[Producto]                                        AS producto
            ,CONVERT(varchar, LAC.FechaAsignacion, 103)         AS FechaAsignaRespSeg
            ,DATEADD(YEAR, 10, r.FchUltimoPago)                 AS fechaVencimientoGestionOrdinaria
            ,DATEADD(YEAR,  3, r.FchUltimoPago)                 AS fechaVencimientoGestionMercantil
            ,de.Txt_Direccion                                    AS correoElectronico
        FROM [dbo].[AsignacionCobranza] ac
        INNER JOIN [dbo].[RptActSdosDiaria] r
            ON ac.Prestamo = r.Prestamo
        INNER JOIN [dbo].[TR_Cob_Saldos_Proy_Moras] Proy
            ON r.Prestamo = proy.Prestamo
        INNER JOIN dbo.ListaPrestamos lp
            ON ac.Prestamo = CONVERT(numeric(18,0), lp.sNoProspecto)
        LEFT JOIN (
            SELECT s.ID_Persona, s.Txt_Direccion
            FROM (
                SELECT d.ID_Persona, d.Txt_Direccion,
                       RANK() OVER (
                           PARTITION BY d.ID_Persona
                           ORDER BY d.Fecha_Ult_Accion DESC, d.Fecha_Inicio DESC, d.Id_Direccion DESC
                       ) AS rk
                FROM Originacion_v00.dbo.DR_Dir_Electronicas d
                WHERE d.Cod_Cat_Dir_Electronica = 1
            ) s WHERE s.rk = 1
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
            WHEN @filtro = 'Nombre Cliente' THEN [Nombre]
            WHEN @filtro = 'CP'             THEN [CodigoPostal]
        END ASC;
    END

    -- ROL 2 sin gestor: coordinador ve su cartera via CatGestorCoordinador
    IF (@rol = 2 AND @idGestor = '')
    BEGIN
        SELECT
             r.[Prestamo]
            ,r.[GestorAsignado]                                  AS gestorasignado
            ,r.[Sucursal]                                        AS sucursal
            ,[Nombre]                                            AS nombre
            ,[FechaNacimiento]                                   AS fechanacimiento
            ,CONVERT(varchar,[FechaIngreso])                     AS fechaingreso2
            ,[Genero]                                            AS genero
            ,[RFC]                                               AS rfc
            ,[CURP]                                              AS curp
            ,[FolioIFE]                                          AS folioife
            ,[DomicilioCalleNumero]                              AS domiciliocallenumero
            ,[Colonia]                                           AS colonia
            ,[CodigoPostal]                                      AS codigopostal
            ,[CiudadEstado]                                      AS ciudadestado
            ,[ClaveLada]                                         AS clavelada
            ,[Telefono1]                                         AS telefono1
            ,[Telefono2]                                         AS telefono2
            ,[Telefono3]                                         AS telefono3
            ,[Tel1ConsCC]                                        AS tel1conscc
            ,[Tel2ConsCC]                                        AS tel2conscc
            ,[Tel3ConsCC]                                        AS tel3conscc
            ,[EstadoCivil]                                       AS estadocivil
            ,[NombreConyuge]                                     AS nombreconyuge
            ,[TipoEmpleado]                                      AS tipoempleado
            ,[Municipio]                                         AS municipio
            ,[Area]                                              AS area
            ,[Convenio]                                          AS convenio
            ,[Dependencia]                                       AS dependencia
            ,r.[CredOtorgNoLiq]                                  AS credotorgnoliq
            ,[TipoProducto]                                      AS tipoproducto
            ,[MontoOtorgado]                                     AS montootorgado
            ,[FechaOperacion]                                    AS fechaoperacion
            ,[FechaVence]                                        AS fechavence
            ,[NumAmortizaciones]                                 AS numamortizaciones
            ,[Periodicidad]                                      AS periodicidad
            ,[PlazoMeses]                                        AS plazomeses
            ,[CapitalVencido]                                    AS capitalvencido
            ,[Capital]                                           AS capital
            ,[InteresSinVencer]                                  AS interessinvencer
            ,[InteresVencido]                                    AS interesvencido
            ,[InteresOrdinario]                                  AS interesordinario
            ,CAST(proy.Proy2_IntMoratorio  AS float)              AS intmoratorio
            ,[IVAIntAccesorios]                                  AS ivaintaccesorios
            ,CAST(proy.Proy2_IVAMoratorios AS float)             AS ivamoratorios
            ,[IVA]                                               AS iva
            ,CAST(proy.Proy2_Seguro        AS float)             AS seguro
            ,[Total]                                             AS total
            ,[TotalExigible]                                     AS totalexigible
            ,r.[EstadoCartera]                                   AS estadocartera
            ,r.[MontoAmortizacion]                               AS montoamortizacion
            ,[AmortizacionesVencidas]                            AS amortizacionesvencidas
            ,[FchUltimoPago]                                     AS fchultimopago
            ,[MontoUltimoPago]                                   AS Montoultimopgo
            ,r.[DiasDevengadosDesdeOtorgamiento]                 AS diasdevengadosdesdeotorgamiento
            ,[DiasAtraso]                                        AS diasatraso
            ,[SaldoVencido]                                      AS saldovencido
            ,[NomConvenio]                                       AS nomconvenio
            ,r.[EstatusGral]                                     AS estatusgral
            ,r.[EstatusInt]                                      AS estatusint
            ,r.[DiasAtrso]                                       AS diasatrso
            ,r.[BandaDiasAtraso]                                 AS bandadiasatraso
            ,[Exigible1]                                         AS exigible1
            ,[Liquidar1]                                         AS liquidar1
            ,[Exigible2]                                         AS exigible2
            ,[Liquidar2]                                         AS liquidar2
            ,[Telefono1Acred]                                    AS telefono1acred
            ,[Telefono2Acred]                                    AS telefono2acred
            ,[OtroAcred]                                         AS otroacred
            ,[NombreR1]                                          AS nombrer1
            ,[TelefonoR1]                                        AS telefonor1
            ,[CalleRef1]                                         AS calleref1
            ,[NumExtR1]                                          AS numextr1
            ,[NumIntR1]                                          AS numintr1
            ,[ColoniaR1]                                         AS coloniar1
            ,[CPR1]                                              AS cpr1
            ,[MunicipioR1]                                       AS municipior1
            ,[EstadoR1]                                          AS estador1
            ,[NombreR2]                                          AS nombrer2
            ,[TelefonoR2]                                        AS telefonor2
            ,[CalleRef2]                                         AS calleref2
            ,[NumExtR2]                                          AS numextr2
            ,[NumIntR2]                                          AS numintr2
            ,[ColoniaR2]                                         AS coloniar2
            ,[CPR2]                                              AS cpr2
            ,[MunicipioR2]                                       AS municipior2
            ,[EstadoR2]                                          AS estador2
            ,[NombreR3]                                          AS nombrer3
            ,[TelefonoR3]                                        AS telefonor3
            ,[CalleRef3]                                         AS calleref3
            ,[NumExtR3]                                          AS numextr3
            ,[NumIntR3]                                          AS numintr3
            ,[ColoniaR3]                                         AS coloniar3
            ,[CPR3]                                              AS cpr3
            ,[MunicipioR3]                                       AS municipior3
            ,[EstadoR3]                                          AS estador3
            ,r.[VentaCartera]                                    AS ventacartera
            ,r.[Producto]                                        AS producto
            ,CONVERT(varchar, LAC.FechaAsignacion, 103)         AS FechaAsignaRespSeg
            ,DATEADD(YEAR, 10, r.FchUltimoPago)                 AS fechaVencimientoGestionOrdinaria
            ,DATEADD(YEAR,  3, r.FchUltimoPago)                 AS fechaVencimientoGestionMercantil
            ,de.Txt_Direccion                                    AS correoElectronico
        FROM [Cobranza].[dbo].[AsignacionCobranza] ac
        INNER JOIN CatGestorCoordinador
            ON ac.nidGestor = CatGestorCoordinador.pk_idGestor
        LEFT JOIN [Cobranza].[dbo].[RptActSdosDiaria] r
            ON ac.Prestamo = r.Prestamo
        INNER JOIN [dbo].[TR_Cob_Saldos_Proy_Moras] Proy
            ON r.Prestamo = proy.Prestamo
        INNER JOIN dbo.ListaPrestamos lp
            ON ac.Prestamo = CONVERT(numeric(18,0), lp.sNoProspecto)
        LEFT JOIN (
            SELECT s.ID_Persona, s.Txt_Direccion
            FROM (
                SELECT d.ID_Persona, d.Txt_Direccion,
                       RANK() OVER (
                           PARTITION BY d.ID_Persona
                           ORDER BY d.Fecha_Ult_Accion DESC, d.Fecha_Inicio DESC, d.Id_Direccion DESC
                       ) AS rk
                FROM Originacion_v00.dbo.DR_Dir_Electronicas d
                WHERE d.Cod_Cat_Dir_Electronica = 1
            ) s WHERE s.rk = 1
        ) de ON de.ID_Persona = lp.nIdPersona
        LEFT JOIN (
            SELECT Prestamo, FechaAsignacion,
                   RANK() OVER (PARTITION BY Prestamo ORDER BY FechaAsignacion DESC) AS orden
            FROM LogAsignacionCobranza
        ) LAC ON ac.Prestamo = LAC.Prestamo AND LAC.orden = 1
        WHERE pk_idCoordinador = @idu
          AND Clasificacion = @clasificacion
          AND r.Sucursal NOT IN ('RECONSTRUCCION SHF')
          AND r.Liquidar1 > 0
        ORDER BY CASE
            WHEN @filtro = 'Credito'        THEN ac.[Prestamo]
            WHEN @filtro = 'Nombre Cliente' THEN [Nombre]
            WHEN @filtro = 'CP'             THEN [CodigoPostal]
        END ASC;
    END

    -- Gestor específico, Ordinaria, no rol 3
    IF (@idGestor != '' AND @clasificacion = 'Ordinaria' AND @rol != '3')
    BEGIN
        SELECT
             r.[Prestamo]
            ,r.[GestorAsignado]                                  AS gestorasignado
            ,r.[Sucursal]                                        AS sucursal
            ,[Nombre]                                            AS nombre
            ,[FechaNacimiento]                                   AS fechanacimiento
            ,CONVERT(varchar,[FechaIngreso])                     AS fechaingreso2
            ,[Genero]                                            AS genero
            ,[RFC]                                               AS rfc
            ,[CURP]                                              AS curp
            ,[FolioIFE]                                          AS folioife
            ,[DomicilioCalleNumero]                              AS domiciliocallenumero
            ,[Colonia]                                           AS colonia
            ,[CodigoPostal]                                      AS codigopostal
            ,[CiudadEstado]                                      AS ciudadestado
            ,[ClaveLada]                                         AS clavelada
            ,[Telefono1]                                         AS telefono1
            ,[Telefono2]                                         AS telefono2
            ,[Telefono3]                                         AS telefono3
            ,[Tel1ConsCC]                                        AS tel1conscc
            ,[Tel2ConsCC]                                        AS tel2conscc
            ,[Tel3ConsCC]                                        AS tel3conscc
            ,[EstadoCivil]                                       AS estadocivil
            ,[NombreConyuge]                                     AS nombreconyuge
            ,[TipoEmpleado]                                      AS tipoempleado
            ,[Municipio]                                         AS municipio
            ,[Area]                                              AS area
            ,[Convenio]                                          AS convenio
            ,[Dependencia]                                       AS dependencia
            ,r.[CredOtorgNoLiq]                                  AS credotorgnoliq
            ,[TipoProducto]                                      AS tipoproducto
            ,[MontoOtorgado]                                     AS montootorgado
            ,[FechaOperacion]                                    AS fechaoperacion
            ,[FechaVence]                                        AS fechavence
            ,[NumAmortizaciones]                                 AS numamortizaciones
            ,[Periodicidad]                                      AS periodicidad
            ,[PlazoMeses]                                        AS plazomeses
            ,[CapitalVencido]                                    AS capitalvencido
            ,[Capital]                                           AS capital
            ,[InteresSinVencer]                                  AS interessinvencer
            ,[InteresVencido]                                    AS interesvencido
            ,[InteresOrdinario]                                  AS interesordinario
            ,CAST(proy.Proy2_IntMoratorio  AS float)              AS intmoratorio
            ,[IVAIntAccesorios]                                  AS ivaintaccesorios
            ,CAST(proy.Proy2_IVAMoratorios AS float)             AS ivamoratorios
            ,[IVA]                                               AS iva
            ,CAST(proy.Proy2_Seguro        AS float)             AS seguro
            ,[Total]                                             AS total
            ,[TotalExigible]                                     AS totalexigible
            ,r.[EstadoCartera]                                   AS estadocartera
            ,r.[MontoAmortizacion]                               AS montoamortizacion
            ,[AmortizacionesVencidas]                            AS amortizacionesvencidas
            ,[FchUltimoPago]                                     AS fchultimopago
            ,[MontoUltimoPago]                                   AS Montoultimopgo
            ,r.[DiasDevengadosDesdeOtorgamiento]                 AS diasdevengadosdesdeotorgamiento
            ,[DiasAtraso]                                        AS diasatraso
            ,[SaldoVencido]                                      AS saldovencido
            ,[NomConvenio]                                       AS nomconvenio
            ,r.[EstatusGral]                                     AS estatusgral
            ,r.[EstatusInt]                                      AS estatusint
            ,r.[DiasAtrso]                                       AS diasatrso
            ,r.[BandaDiasAtraso]                                 AS bandadiasatraso
            ,[Exigible1]                                         AS exigible1
            ,[Liquidar1]                                         AS liquidar1
            ,[Exigible2]                                         AS exigible2
            ,[Liquidar2]                                         AS liquidar2
            ,[Telefono1Acred]                                    AS telefono1acred
            ,[Telefono2Acred]                                    AS telefono2acred
            ,[OtroAcred]                                         AS otroacred
            ,[NombreR1]                                          AS nombrer1
            ,[TelefonoR1]                                        AS telefonor1
            ,[CalleRef1]                                         AS calleref1
            ,[NumExtR1]                                          AS numextr1
            ,[NumIntR1]                                          AS numintr1
            ,[ColoniaR1]                                         AS coloniar1
            ,[CPR1]                                              AS cpr1
            ,[MunicipioR1]                                       AS municipior1
            ,[EstadoR1]                                          AS estador1
            ,[NombreR2]                                          AS nombrer2
            ,[TelefonoR2]                                        AS telefonor2
            ,[CalleRef2]                                         AS calleref2
            ,[NumExtR2]                                          AS numextr2
            ,[NumIntR2]                                          AS numintr2
            ,[ColoniaR2]                                         AS coloniar2
            ,[CPR2]                                              AS cpr2
            ,[MunicipioR2]                                       AS municipior2
            ,[EstadoR2]                                          AS estador2
            ,[NombreR3]                                          AS nombrer3
            ,[TelefonoR3]                                        AS telefonor3
            ,[CalleRef3]                                         AS calleref3
            ,[NumExtR3]                                          AS numextr3
            ,[NumIntR3]                                          AS numintr3
            ,[ColoniaR3]                                         AS coloniar3
            ,[CPR3]                                              AS cpr3
            ,[MunicipioR3]                                       AS municipior3
            ,[EstadoR3]                                          AS estador3
            ,r.[VentaCartera]                                    AS ventacartera
            ,r.[Producto]                                        AS producto
            ,CONVERT(varchar, LAC.FechaAsignacion, 103)         AS FechaAsignaRespSeg
            ,DATEADD(YEAR, 10, r.FchUltimoPago)                 AS fechaVencimientoGestionOrdinaria
            ,DATEADD(YEAR,  3, r.FchUltimoPago)                 AS fechaVencimientoGestionMercantil
            ,de.Txt_Direccion                                    AS correoElectronico
        FROM [Cobranza].[dbo].[AsignacionCobranza] ac
        INNER JOIN [Cobranza].[dbo].[RptActSdosDiaria] r
            ON ac.Prestamo = r.Prestamo
        INNER JOIN [dbo].[TR_Cob_Saldos_Proy_Moras] Proy
            ON r.Prestamo = proy.Prestamo
        INNER JOIN dbo.ListaPrestamos lp
            ON ac.Prestamo = CONVERT(numeric(18,0), lp.sNoProspecto)
        LEFT JOIN (
            SELECT s.ID_Persona, s.Txt_Direccion
            FROM (
                SELECT d.ID_Persona, d.Txt_Direccion,
                       RANK() OVER (
                           PARTITION BY d.ID_Persona
                           ORDER BY d.Fecha_Ult_Accion DESC, d.Fecha_Inicio DESC, d.Id_Direccion DESC
                       ) AS rk
                FROM Originacion_v00.dbo.DR_Dir_Electronicas d
                WHERE d.Cod_Cat_Dir_Electronica = 1
            ) s WHERE s.rk = 1
        ) de ON de.ID_Persona = lp.nIdPersona
        LEFT JOIN (
            SELECT Prestamo, FechaAsignacion,
                   RANK() OVER (PARTITION BY Prestamo ORDER BY FechaAsignacion DESC) AS orden
            FROM LogAsignacionCobranza
        ) LAC ON ac.Prestamo = LAC.Prestamo AND LAC.orden = 1
        WHERE ac.nIdGestor = @idGestor
          AND Clasificacion = 'Ordinaria'
          AND r.Sucursal NOT IN ('RECONSTRUCCION SHF')
          AND r.Liquidar1 > 0
        ORDER BY CASE
            WHEN @filtro = 'Credito'        THEN CONVERT(varchar, ac.[Prestamo])
            WHEN @filtro = 'Nombre Cliente' THEN [Nombre]
            WHEN @filtro = 'CP'             THEN [CodigoPostal]
        END ASC;
    END

    -- Gestor específico, Extraordinaria/Olivo, no rol 3
    IF (@idGestor != '' AND @clasificacion = 'Extraordinaria' AND @rol != '3')
    BEGIN
        SELECT
             r.[Prestamo]
            ,r.[GestorAsignado]                                  AS gestorasignado
            ,r.[Sucursal]                                        AS sucursal
            ,[Nombre]                                            AS nombre
            ,[FechaNacimiento]                                   AS fechanacimiento
            ,CONVERT(varchar,[FechaIngreso])                     AS fechaingreso2
            ,[Genero]                                            AS genero
            ,[RFC]                                               AS rfc
            ,[CURP]                                              AS curp
            ,[FolioIFE]                                          AS folioife
            ,[DomicilioCalleNumero]                              AS domiciliocallenumero
            ,[Colonia]                                           AS colonia
            ,[CodigoPostal]                                      AS codigopostal
            ,[CiudadEstado]                                      AS ciudadestado
            ,[ClaveLada]                                         AS clavelada
            ,[Telefono1]                                         AS telefono1
            ,[Telefono2]                                         AS telefono2
            ,[Telefono3]                                         AS telefono3
            ,[Tel1ConsCC]                                        AS tel1conscc
            ,[Tel2ConsCC]                                        AS tel2conscc
            ,[Tel3ConsCC]                                        AS tel3conscc
            ,[EstadoCivil]                                       AS estadocivil
            ,[NombreConyuge]                                     AS nombreconyuge
            ,[TipoEmpleado]                                      AS tipoempleado
            ,[Municipio]                                         AS municipio
            ,[Area]                                              AS area
            ,[Convenio]                                          AS convenio
            ,[Dependencia]                                       AS dependencia
            ,r.[CredOtorgNoLiq]                                  AS credotorgnoliq
            ,[TipoProducto]                                      AS tipoproducto
            ,[MontoOtorgado]                                     AS montootorgado
            ,[FechaOperacion]                                    AS fechaoperacion
            ,[FechaVence]                                        AS fechavence
            ,[NumAmortizaciones]                                 AS numamortizaciones
            ,[Periodicidad]                                      AS periodicidad
            ,[PlazoMeses]                                        AS plazomeses
            ,[CapitalVencido]                                    AS capitalvencido
            ,[Capital]                                           AS capital
            ,[InteresSinVencer]                                  AS interessinvencer
            ,[InteresVencido]                                    AS interesvencido
            ,[InteresOrdinario]                                  AS interesordinario
            ,CAST(proy.Proy2_IntMoratorio  AS float)              AS intmoratorio
            ,[IVAIntAccesorios]                                  AS ivaintaccesorios
            ,CAST(proy.Proy2_IVAMoratorios AS float)             AS ivamoratorios
            ,[IVA]                                               AS iva
            ,CAST(proy.Proy2_Seguro        AS float)             AS seguro
            ,[Total]                                             AS total
            ,[TotalExigible]                                     AS totalexigible
            ,r.[EstadoCartera]                                   AS estadocartera
            ,r.[MontoAmortizacion]                               AS montoamortizacion
            ,[AmortizacionesVencidas]                            AS amortizacionesvencidas
            ,[FchUltimoPago]                                     AS fchultimopago
            ,[MontoUltimoPago]                                   AS Montoultimopgo
            ,r.[DiasDevengadosDesdeOtorgamiento]                 AS diasdevengadosdesdeotorgamiento
            ,[DiasAtraso]                                        AS diasatraso
            ,[SaldoVencido]                                      AS saldovencido
            ,[NomConvenio]                                       AS nomconvenio
            ,r.[EstatusGral]                                     AS estatusgral
            ,r.[EstatusInt]                                      AS estatusint
            ,r.[DiasAtrso]                                       AS diasatrso
            ,r.[BandaDiasAtraso]                                 AS bandadiasatraso
            ,[Exigible1]                                         AS exigible1
            ,[Liquidar1]                                         AS liquidar1
            ,[Exigible2]                                         AS exigible2
            ,[Liquidar2]                                         AS liquidar2
            ,[Telefono1Acred]                                    AS telefono1acred
            ,[Telefono2Acred]                                    AS telefono2acred
            ,[OtroAcred]                                         AS otroacred
            ,[NombreR1]                                          AS nombrer1
            ,[TelefonoR1]                                        AS telefonor1
            ,[CalleRef1]                                         AS calleref1
            ,[NumExtR1]                                          AS numextr1
            ,[NumIntR1]                                          AS numintr1
            ,[ColoniaR1]                                         AS coloniar1
            ,[CPR1]                                              AS cpr1
            ,[MunicipioR1]                                       AS municipior1
            ,[EstadoR1]                                          AS estador1
            ,[NombreR2]                                          AS nombrer2
            ,[TelefonoR2]                                        AS telefonor2
            ,[CalleRef2]                                         AS calleref2
            ,[NumExtR2]                                          AS numextr2
            ,[NumIntR2]                                          AS numintr2
            ,[ColoniaR2]                                         AS coloniar2
            ,[CPR2]                                              AS cpr2
            ,[MunicipioR2]                                       AS municipior2
            ,[EstadoR2]                                          AS estador2
            ,[NombreR3]                                          AS nombrer3
            ,[TelefonoR3]                                        AS telefonor3
            ,[CalleRef3]                                         AS calleref3
            ,[NumExtR3]                                          AS numextr3
            ,[NumIntR3]                                          AS numintr3
            ,[ColoniaR3]                                         AS coloniar3
            ,[CPR3]                                              AS cpr3
            ,[MunicipioR3]                                       AS municipior3
            ,[EstadoR3]                                          AS estador3
            ,r.[VentaCartera]                                    AS ventacartera
            ,r.[Producto]                                        AS producto
            ,CONVERT(varchar, LAC.FechaAsignacion, 103)         AS FechaAsignaRespSeg
            ,DATEADD(YEAR, 10, r.FchUltimoPago)                 AS fechaVencimientoGestionOrdinaria
            ,DATEADD(YEAR,  3, r.FchUltimoPago)                 AS fechaVencimientoGestionMercantil
            ,de.Txt_Direccion                                    AS correoElectronico
        FROM [Cobranza].[dbo].[AsignacionCobranza] ac
        INNER JOIN [Cobranza].[dbo].[RptActSdosDiaria] r
            ON ac.Prestamo = r.Prestamo
        INNER JOIN [dbo].[TR_Cob_Saldos_Proy_Moras] Proy
            ON r.Prestamo = proy.Prestamo
        INNER JOIN dbo.ListaPrestamos lp
            ON ac.Prestamo = CONVERT(numeric(18,0), lp.sNoProspecto)
        LEFT JOIN (
            SELECT s.ID_Persona, s.Txt_Direccion
            FROM (
                SELECT d.ID_Persona, d.Txt_Direccion,
                       RANK() OVER (
                           PARTITION BY d.ID_Persona
                           ORDER BY d.Fecha_Ult_Accion DESC, d.Fecha_Inicio DESC, d.Id_Direccion DESC
                       ) AS rk
                FROM Originacion_v00.dbo.DR_Dir_Electronicas d
                WHERE d.Cod_Cat_Dir_Electronica = 1
            ) s WHERE s.rk = 1
        ) de ON de.ID_Persona = lp.nIdPersona
        LEFT JOIN (
            SELECT Prestamo, FechaAsignacion,
                   RANK() OVER (PARTITION BY Prestamo ORDER BY FechaAsignacion DESC) AS orden
            FROM LogAsignacionCobranza
        ) LAC ON ac.Prestamo = LAC.Prestamo AND LAC.orden = 1
        WHERE ac.nIdGestor = @idGestor
          AND (Clasificacion = 'Extraordinaria' OR Clasificacion = 'Olivo')
          AND r.Sucursal NOT IN ('RECONSTRUCCION SHF')
          AND r.Liquidar1 > 0
        ORDER BY CASE
            WHEN @filtro = 'Credito'        THEN CONVERT(varchar, ac.[Prestamo])
            WHEN @filtro = 'Nombre Cliente' THEN [Nombre]
            WHEN @filtro = 'CP'             THEN [CodigoPostal]
        END ASC;
    END

    -- ROL 3 "Por Asignar", Ordinaria
    IF (@idGestor != '' AND @clasificacion = 'Ordinaria' AND @rol = '3')
    BEGIN
        SELECT
             r.[Prestamo]
            ,r.[GestorAsignado]                                  AS gestorasignado
            ,r.[Sucursal]                                        AS sucursal
            ,[Nombre]                                            AS nombre
            ,[FechaNacimiento]                                   AS fechanacimiento
            ,CONVERT(varchar,[FechaIngreso])                     AS fechaingreso2
            ,[Genero]                                            AS genero
            ,[RFC]                                               AS rfc
            ,[CURP]                                              AS curp
            ,[FolioIFE]                                          AS folioife
            ,[DomicilioCalleNumero]                              AS domiciliocallenumero
            ,[Colonia]                                           AS colonia
            ,[CodigoPostal]                                      AS codigopostal
            ,[CiudadEstado]                                      AS ciudadestado
            ,[ClaveLada]                                         AS clavelada
            ,[Telefono1]                                         AS telefono1
            ,[Telefono2]                                         AS telefono2
            ,[Telefono3]                                         AS telefono3
            ,[Tel1ConsCC]                                        AS tel1conscc
            ,[Tel2ConsCC]                                        AS tel2conscc
            ,[Tel3ConsCC]                                        AS tel3conscc
            ,[EstadoCivil]                                       AS estadocivil
            ,[NombreConyuge]                                     AS nombreconyuge
            ,[TipoEmpleado]                                      AS tipoempleado
            ,[Municipio]                                         AS municipio
            ,[Area]                                              AS area
            ,[Convenio]                                          AS convenio
            ,[Dependencia]                                       AS dependencia
            ,r.[CredOtorgNoLiq]                                  AS credotorgnoliq
            ,[TipoProducto]                                      AS tipoproducto
            ,[MontoOtorgado]                                     AS montootorgado
            ,[FechaOperacion]                                    AS fechaoperacion
            ,[FechaVence]                                        AS fechavence
            ,[NumAmortizaciones]                                 AS numamortizaciones
            ,[Periodicidad]                                      AS periodicidad
            ,[PlazoMeses]                                        AS plazomeses
            ,[CapitalVencido]                                    AS capitalvencido
            ,[Capital]                                           AS capital
            ,[InteresSinVencer]                                  AS interessinvencer
            ,[InteresVencido]                                    AS interesvencido
            ,[InteresOrdinario]                                  AS interesordinario
            ,CAST(proy.Proy2_IntMoratorio  AS float)              AS intmoratorio
            ,[IVAIntAccesorios]                                  AS ivaintaccesorios
            ,CAST(proy.Proy2_IVAMoratorios AS float)             AS ivamoratorios
            ,[IVA]                                               AS iva
            ,CAST(proy.Proy2_Seguro        AS float)             AS seguro
            ,[Total]                                             AS total
            ,[TotalExigible]                                     AS totalexigible
            ,r.[EstadoCartera]                                   AS estadocartera
            ,r.[MontoAmortizacion]                               AS montoamortizacion
            ,[AmortizacionesVencidas]                            AS amortizacionesvencidas
            ,[FchUltimoPago]                                     AS fchultimopago
            ,[MontoUltimoPago]                                   AS Montoultimopgo
            ,r.[DiasDevengadosDesdeOtorgamiento]                 AS diasdevengadosdesdeotorgamiento
            ,[DiasAtraso]                                        AS diasatraso
            ,[SaldoVencido]                                      AS saldovencido
            ,[NomConvenio]                                       AS nomconvenio
            ,r.[EstatusGral]                                     AS estatusgral
            ,r.[EstatusInt]                                      AS estatusint
            ,r.[DiasAtrso]                                       AS diasatrso
            ,r.[BandaDiasAtraso]                                 AS bandadiasatraso
            ,[Exigible1]                                         AS exigible1
            ,[Liquidar1]                                         AS liquidar1
            ,[Exigible2]                                         AS exigible2
            ,[Liquidar2]                                         AS liquidar2
            ,[Telefono1Acred]                                    AS telefono1acred
            ,[Telefono2Acred]                                    AS telefono2acred
            ,[OtroAcred]                                         AS otroacred
            ,[NombreR1]                                          AS nombrer1
            ,[TelefonoR1]                                        AS telefonor1
            ,[CalleRef1]                                         AS calleref1
            ,[NumExtR1]                                          AS numextr1
            ,[NumIntR1]                                          AS numintr1
            ,[ColoniaR1]                                         AS coloniar1
            ,[CPR1]                                              AS cpr1
            ,[MunicipioR1]                                       AS municipior1
            ,[EstadoR1]                                          AS estador1
            ,[NombreR2]                                          AS nombrer2
            ,[TelefonoR2]                                        AS telefonor2
            ,[CalleRef2]                                         AS calleref2
            ,[NumExtR2]                                          AS numextr2
            ,[NumIntR2]                                          AS numintr2
            ,[ColoniaR2]                                         AS coloniar2
            ,[CPR2]                                              AS cpr2
            ,[MunicipioR2]                                       AS municipior2
            ,[EstadoR2]                                          AS estador2
            ,[NombreR3]                                          AS nombrer3
            ,[TelefonoR3]                                        AS telefonor3
            ,[CalleRef3]                                         AS calleref3
            ,[NumExtR3]                                          AS numextr3
            ,[NumIntR3]                                          AS numintr3
            ,[ColoniaR3]                                         AS coloniar3
            ,[CPR3]                                              AS cpr3
            ,[MunicipioR3]                                       AS municipior3
            ,[EstadoR3]                                          AS estador3
            ,r.[VentaCartera]                                    AS ventacartera
            ,r.[Producto]                                        AS producto
            ,CONVERT(varchar, LAC.FechaAsignacion, 103)         AS FechaAsignaRespSeg
            ,DATEADD(YEAR, 10, r.FchUltimoPago)                 AS fechaVencimientoGestionOrdinaria
            ,DATEADD(YEAR,  3, r.FchUltimoPago)                 AS fechaVencimientoGestionMercantil
            ,de.Txt_Direccion                                    AS correoElectronico
        FROM [Cobranza].[dbo].[RptActSdosDiaria] r
        INNER JOIN [dbo].[TR_Cob_Saldos_Proy_Moras] Proy
            ON r.Prestamo = proy.Prestamo
        INNER JOIN dbo.ListaPrestamos lp
            ON r.Prestamo = CONVERT(numeric(18,0), lp.sNoProspecto)
        LEFT JOIN (
            SELECT s.ID_Persona, s.Txt_Direccion
            FROM (
                SELECT d.ID_Persona, d.Txt_Direccion,
                       RANK() OVER (
                           PARTITION BY d.ID_Persona
                           ORDER BY d.Fecha_Ult_Accion DESC, d.Fecha_Inicio DESC, d.Id_Direccion DESC
                       ) AS rk
                FROM Originacion_v00.dbo.DR_Dir_Electronicas d
                WHERE d.Cod_Cat_Dir_Electronica = 1
            ) s WHERE s.rk = 1
        ) de ON de.ID_Persona = lp.nIdPersona
        LEFT JOIN (
            SELECT Prestamo, FechaAsignacion,
                   RANK() OVER (PARTITION BY Prestamo ORDER BY FechaAsignacion DESC) AS orden
            FROM LogAsignacionCobranza
        ) LAC ON r.Prestamo = LAC.Prestamo AND LAC.orden = 1
        WHERE Clasificacion = 'Ordinaria'
          AND r.GestorAsignado = 'Por Asignar'
          AND r.Sucursal NOT IN ('RECONSTRUCCION SHF')
          AND r.Liquidar1 > 0
        ORDER BY CASE
            WHEN @filtro = 'Credito'        THEN CONVERT(varchar, r.Prestamo)
            WHEN @filtro = 'Nombre Cliente' THEN [Nombre]
            WHEN @filtro = 'CP'             THEN [CodigoPostal]
        END ASC;
    END

    -- ROL 3 "Por Asignar", Extraordinaria/Olivo
    IF (@idGestor != '' AND @clasificacion = 'Extraordinaria' AND @rol = '3')
    BEGIN
        SELECT
             r.[Prestamo]
            ,r.[GestorAsignado]                                  AS gestorasignado
            ,r.[Sucursal]                                        AS sucursal
            ,[Nombre]                                            AS nombre
            ,[FechaNacimiento]                                   AS fechanacimiento
            ,CONVERT(varchar,[FechaIngreso])                     AS fechaingreso2
            ,[Genero]                                            AS genero
            ,[RFC]                                               AS rfc
            ,[CURP]                                              AS curp
            ,[FolioIFE]                                          AS folioife
            ,[DomicilioCalleNumero]                              AS domiciliocallenumero
            ,[Colonia]                                           AS colonia
            ,[CodigoPostal]                                      AS codigopostal
            ,[CiudadEstado]                                      AS ciudadestado
            ,[ClaveLada]                                         AS clavelada
            ,[Telefono1]                                         AS telefono1
            ,[Telefono2]                                         AS telefono2
            ,[Telefono3]                                         AS telefono3
            ,[Tel1ConsCC]                                        AS tel1conscc
            ,[Tel2ConsCC]                                        AS tel2conscc
            ,[Tel3ConsCC]                                        AS tel3conscc
            ,[EstadoCivil]                                       AS estadocivil
            ,[NombreConyuge]                                     AS nombreconyuge
            ,[TipoEmpleado]                                      AS tipoempleado
            ,[Municipio]                                         AS municipio
            ,[Area]                                              AS area
            ,[Convenio]                                          AS convenio
            ,[Dependencia]                                       AS dependencia
            ,r.[CredOtorgNoLiq]                                  AS credotorgnoliq
            ,[TipoProducto]                                      AS tipoproducto
            ,[MontoOtorgado]                                     AS montootorgado
            ,[FechaOperacion]                                    AS fechaoperacion
            ,[FechaVence]                                        AS fechavence
            ,[NumAmortizaciones]                                 AS numamortizaciones
            ,[Periodicidad]                                      AS periodicidad
            ,[PlazoMeses]                                        AS plazomeses
            ,[CapitalVencido]                                    AS capitalvencido
            ,[Capital]                                           AS capital
            ,[InteresSinVencer]                                  AS interessinvencer
            ,[InteresVencido]                                    AS interesvencido
            ,[InteresOrdinario]                                  AS interesordinario
            ,CAST(proy.Proy2_IntMoratorio  AS float)              AS intmoratorio
            ,[IVAIntAccesorios]                                  AS ivaintaccesorios
            ,CAST(proy.Proy2_IVAMoratorios AS float)             AS ivamoratorios
            ,[IVA]                                               AS iva
            ,CAST(proy.Proy2_Seguro        AS float)             AS seguro
            ,[Total]                                             AS total
            ,[TotalExigible]                                     AS totalexigible
            ,r.[EstadoCartera]                                   AS estadocartera
            ,r.[MontoAmortizacion]                               AS montoamortizacion
            ,[AmortizacionesVencidas]                            AS amortizacionesvencidas
            ,[FchUltimoPago]                                     AS fchultimopago
            ,[MontoUltimoPago]                                   AS Montoultimopgo
            ,r.[DiasDevengadosDesdeOtorgamiento]                 AS diasdevengadosdesdeotorgamiento
            ,[DiasAtraso]                                        AS diasatraso
            ,[SaldoVencido]                                      AS saldovencido
            ,[NomConvenio]                                       AS nomconvenio
            ,r.[EstatusGral]                                     AS estatusgral
            ,r.[EstatusInt]                                      AS estatusint
            ,r.[DiasAtrso]                                       AS diasatrso
            ,r.[BandaDiasAtraso]                                 AS bandadiasatraso
            ,[Exigible1]                                         AS exigible1
            ,[Liquidar1]                                         AS liquidar1
            ,[Exigible2]                                         AS exigible2
            ,[Liquidar2]                                         AS liquidar2
            ,[Telefono1Acred]                                    AS telefono1acred
            ,[Telefono2Acred]                                    AS telefono2acred
            ,[OtroAcred]                                         AS otroacred
            ,[NombreR1]                                          AS nombrer1
            ,[TelefonoR1]                                        AS telefonor1
            ,[CalleRef1]                                         AS calleref1
            ,[NumExtR1]                                          AS numextr1
            ,[NumIntR1]                                          AS numintr1
            ,[ColoniaR1]                                         AS coloniar1
            ,[CPR1]                                              AS cpr1
            ,[MunicipioR1]                                       AS municipior1
            ,[EstadoR1]                                          AS estador1
            ,[NombreR2]                                          AS nombrer2
            ,[TelefonoR2]                                        AS telefonor2
            ,[CalleRef2]                                         AS calleref2
            ,[NumExtR2]                                          AS numextr2
            ,[NumIntR2]                                          AS numintr2
            ,[ColoniaR2]                                         AS coloniar2
            ,[CPR2]                                              AS cpr2
            ,[MunicipioR2]                                       AS municipior2
            ,[EstadoR2]                                          AS estador2
            ,[NombreR3]                                          AS nombrer3
            ,[TelefonoR3]                                        AS telefonor3
            ,[CalleRef3]                                         AS calleref3
            ,[NumExtR3]                                          AS numextr3
            ,[NumIntR3]                                          AS numintr3
            ,[ColoniaR3]                                         AS coloniar3
            ,[CPR3]                                              AS cpr3
            ,[MunicipioR3]                                       AS municipior3
            ,[EstadoR3]                                          AS estador3
            ,r.[VentaCartera]                                    AS ventacartera
            ,r.[Producto]                                        AS producto
            ,CONVERT(varchar, LAC.FechaAsignacion, 103)         AS FechaAsignaRespSeg
            ,DATEADD(YEAR, 10, r.FchUltimoPago)                 AS fechaVencimientoGestionOrdinaria
            ,DATEADD(YEAR,  3, r.FchUltimoPago)                 AS fechaVencimientoGestionMercantil
            ,de.Txt_Direccion                                    AS correoElectronico
        FROM [Cobranza].[dbo].[RptActSdosDiaria] r
        INNER JOIN [dbo].[TR_Cob_Saldos_Proy_Moras] Proy
            ON r.Prestamo = proy.Prestamo
        INNER JOIN dbo.ListaPrestamos lp
            ON r.Prestamo = CONVERT(numeric(18,0), lp.sNoProspecto)
        LEFT JOIN (
            SELECT s.ID_Persona, s.Txt_Direccion
            FROM (
                SELECT d.ID_Persona, d.Txt_Direccion,
                       RANK() OVER (
                           PARTITION BY d.ID_Persona
                           ORDER BY d.Fecha_Ult_Accion DESC, d.Fecha_Inicio DESC, d.Id_Direccion DESC
                       ) AS rk
                FROM Originacion_v00.dbo.DR_Dir_Electronicas d
                WHERE d.Cod_Cat_Dir_Electronica = 1
            ) s WHERE s.rk = 1
        ) de ON de.ID_Persona = lp.nIdPersona
        LEFT JOIN (
            SELECT Prestamo, FechaAsignacion,
                   RANK() OVER (PARTITION BY Prestamo ORDER BY FechaAsignacion DESC) AS orden
            FROM LogAsignacionCobranza
        ) LAC ON r.Prestamo = LAC.Prestamo AND LAC.orden = 1
        WHERE (Clasificacion = 'Extraordinaria' OR Clasificacion = 'Olivo')
          AND r.GestorAsignado = 'Por Asignar'
          AND r.Sucursal NOT IN ('RECONSTRUCCION SHF')
          AND r.Liquidar1 > 0
        ORDER BY CASE
            WHEN @filtro = 'Credito'        THEN CONVERT(varchar, r.[Prestamo])
            WHEN @filtro = 'Nombre Cliente' THEN [Nombre]
            WHEN @filtro = 'CP'             THEN [CodigoPostal]
        END ASC;
    END
END
GO
