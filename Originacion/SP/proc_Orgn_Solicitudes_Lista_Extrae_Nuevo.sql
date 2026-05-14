--///////////////////////////////////////////////////////////////
-- Versión: v2_CallCenter_Recotizacion  |  Fecha: 2026-05-14  |  Autor: JorgeVelazquez
-- Agrega COALESCE(chkres.Resultado, chkres_org.Resultado) en checkResultado
-- y columna CheckFueReplicado (BIT) en @SQL_Campos_Select.
-- Agrega LEFT JOIN chkres_org a CR_Credito_CheckList_Resumen via ID_Credito_Origen
-- en @SQL_From para mostrar resultado del CC anterior mientras Resultado IS NULL.
--///////////////////////////////////////////////////////////////

USE [Originacion]
GO
/****** Object:  StoredProcedure [dbo].[proc_Orgn_Solicitudes_Lista_Extrae_Nuevo]    Script Date: 12/05/2026 08:19:20 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [dbo].[proc_Orgn_Solicitudes_Lista_Extrae_Nuevo] (
@filtrosJson Nvarchar(max) = ''
)
AS
Begin

Declare @Id_Usuario int
Declare @IdPerfil int

Declare @filtrosXML XML
Set @filtrosXML = dbo.fncJson2xml(@filtrosJson)

SELECT @Id_Usuario = Id_Usuario.value('.','varchar(100)') FROM @filtrosXML.nodes('/Id_Usuario') as filtros(Id_Usuario)

select @IdPerfil = isnull(IdPerfil,0)
from websec.[dbo].SegUsuariosPerfiles
where IdUsuario = @Id_Usuario
and Estatus = 'A'

Declare @SQL_Campos_Select NVarchar(max)
Declare @SQL_From NVarchar(max)
Declare @SQL_Where NVarchar(max)
Declare @SQL_Order NVarchar(max)

set @SQL_Campos_Select = N''
set @SQL_From = N''
set @SQL_Where = N''
set @SQL_Order = N''

declare @permisoasignar int = 0
declare @permisoverSol int = 0

select @permisoasignar = count(*)
from WebSec.dbo.SegUsuarios usr
inner join WebSec.dbo.SegUsuariosPerfiles perfilusuario on
perfilusuario.IdUsuario = usr.IdUsuario and
perfilusuario.Estatus = 'A'
inner join WebSec.dbo.SegPerfilesObjetos objetos on
objetos.IdPerfil = perfilusuario.IdPerfil
Where usr.IdUsuario = @Id_Usuario and
objetos.IdObjeto = 3525

select @permisoverSol = count(*)
from WebSec.dbo.SegUsuarios usr
inner join WebSec.dbo.SegUsuariosPerfiles perfilusuario on
perfilusuario.IdUsuario = usr.IdUsuario and
perfilusuario.Estatus = 'A'
inner join WebSec.dbo.SegPerfilesObjetos objetos on
objetos.IdPerfil = perfilusuario.IdPerfil
Where usr.IdUsuario = @Id_Usuario and
objetos.IdObjeto = 3710

print '@permisoasignar'
print @permisoasignar

print '@permisoverSol'
print @permisoverSol

set @SQL_Campos_Select =
N'Distinct top 1000 credito.ID_Credito,' + char(13) +
N' ltrim(rtrim(Persona.Primer_Nombre)) + '' ''+' + char(13) +
N' ltrim(rtrim(Persona.Segundo_Nombre)) + '' '' +' + char(13) +
N' ltrim(rtrim(Persona.Primer_Apellido)) + '' '' +' + char(13) +
N' ltrim(rtrim(Persona.Segundo_Apellido)) as Nombre,' + char(13) +
N' Importe, ' + char(13) +
N' Cod_Frecuencia_Pago,' + char(13) +
N' UM.Nombre Frec_PAgo,' + char(13) +
N' Credito.Fecha_Inicio, ' + char(13) +
N' Fecha_Prim_Liq, ' + char(13) +
N' Etapas.Nombre_Estapa + ''-'' + Estatus.Nombre_Estatus as Etapa, ' + char(13) +
N' Estatus.Nombre_Estatus as Estatus, ' + char(13) +
N' CASE ' + char(13) +
N' WHEN InciAbiertas.cuentaIncidencias > 0 ' + char(13) +
N' THEN 2 ' + char(13) +
N' WHEN InciAntedidas.cuentaIncidencias > 0 ' + char(13) +
N' THEN 1 ' + char(13) +
N' ELSE -1 ' + char(13) +
N' END as incidencias ' + char(13) +
N' ,usrs.ID_Usuario ' + char(13) +
N' ,isnull(usrs.ID_Usuario_Padre,0) as ID_Usuario_Padre ' + char(13) +
N' ,usrs.Nombre as Nombre_Usuario ' + char(13) +
N' ,usrs.Id_Tipo_Usuario ' + char(13) +
N' ,usrs.Email as Email_Usuario ' + char(13) +
N' ,''U'' as Clase_Registro_Usuario ' + char(13) +
N' ,credito.Cod_Etapa ' + char(13) +
N' ,credito.Cod_Estatus ' + char(13) +
N' ,usrAnalista.Nombre Nombre_Analista ' + char(13) +
N' ,usrAnalista.Id_Usuario Id_Usuario_Analista ' + char(13) +
N' ,CASE isnull(asignable.Cod_Etapa, '''') ' + char(13) +
N' WHEN '''' THEN 0 ' + char(13) +
N' ELSE 1 ' + char(13) +
N' End as ASignable ' + char(13) +
N' ,asignable.Cod_Etapa '  + char(13) +
N' ,Credito.Cod_Producto '  + char(13) +
N' ,permisoasignar.IdObjeto '  + char(13) +
N' ,chkres.[Id_Usuario_Asignado] checkIdUsuario '  + char(13)  +
N' ,chkres.[Fecha_Inicio] checkfechaInicio  '  + char(13) +
N' ,chkres.[Fecha_Fin] checkfechafin '  + char(13) +
N' ,COALESCE(chkres.[Resultado], chkres_org.[Resultado]) checkResultado '  + char(13) +
N' ,chkres.[Fecha_Asignacion] checkFechaAsigna  '  + char(13) +
N' ,chkres.Notas checkNotas '  + char(13) +
N' ,usuarioCC.Nombre checkUsuario '  + char(13) +
N' ,isnull(credito.Id_Campana,0) Id_Campana '  + char(13) +
N' ,isnull(campania.Nombre,'''') Nombre_Campana '  + char(13) +
N' ,CAST(CASE WHEN chkres.Id_Credito IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS CheckListCerrado ' + char(13) +
N' ,CAST(CASE WHEN chkres.ID_Credito_Origen IS NOT NULL AND chkres.Resultado IS NULL THEN 1 ELSE 0 END AS BIT) AS CheckFueReplicado ' + char(13)

print 'Longitud @SQL_Campos_Select'
print len(@SQL_Campos_Select)

set @SQL_From =
N'CR_Credito as Credito
inner join [dbo].[TR_Cr_Etapas] as Etapas on Credito.Cod_Etapa = Etapas.Cod_Etapa
inner join Pers_Persona Persona on Persona.Id_Persona = Credito.ID_Persona '

print 'Longitud @SQL_From'
print len(@SQL_From)

if @permisoasignar = 0 and @permisoverSol = 0
begin
print 'entro en inner join fn_Orgn_Usuarios_Jerarquia'

set @SQL_From = @SQL_From  + N' left join Usr_Usuarios usrs
on Credito.ID_Usuario = usrs.ID_Usuario '
end

if @permisoasignar > 0 or @permisoverSol > 0
begin
print 'entro en left join usr_usuarios usrs'

set @SQL_From = @SQL_From  + N' left join usr_usuarios usrs on Credito.ID_Usuario = usrs.ID_Usuario '
end

print 'Longitud @SQL_From'
print len(@SQL_From)

print '@IdPerfil'
print isnull(@IdPerfil,0)

set @SQL_From = @SQL_From  + N'
inner join TR_Cr_Estatus as estatus on estatus.Cod_Estatus = Credito.Cod_Estatus
left join [CR_Credito_Usuarios] credusrAnalista
on Credito.ID_Credito = credusrAnalista.Id_Credito and
credusrAnalista.Cod_ECV_Credito_Usuario = ''01''
and credusrAnalista.IdPerfil in (2,10,11, 19,20,21)
left join usr_usuarios usrAnalista on
credusrAnalista.ID_Usuario = usrAnalista.ID_Usuario
inner join websec.[dbo].[SegUsuariosVistasEtapasEstatus] usrVistaEtapas
on
usrVistaEtapas.Cod_Etapa = Credito.Cod_Etapa and
usrVistaEtapas.Cod_Estatus = Credito.Cod_Estatus
and usrVistaEtapas.IdPerfil = ' + cast(isnull(@IdPerfil,0) as nvarchar(20)) + N'
left join websec.dbo.[SegEtapasEsatusAsignables] asignable on
Credito.Cod_Etapa = asignable.Cod_Etapa and
Credito.Cod_Estatus = asignable.Cod_Estatus
left join websec.[dbo].SegUsuariosPerfiles usuarioperfile on
usrs.ID_Usuario = usuarioperfile.IdUsuario and
usuarioperfile.Estatus = ''A''
left join websec.[dbo].[SegPerfilesObjetosEtapas] permisoasignar on
Credito.Cod_Etapa = permisoasignar.Cod_Etapa and
Credito.Cod_Estatus = permisoasignar.Cod_Estatus and
permisoasignar.IdPerfil = usuarioperfile.IdPerfil and
permisoasignar.idobjeto = 3025
left join [dbo].[CR_Credito_CheckList_Resumen] chkres on
chkres.id_credito = Credito.ID_Credito
left join [dbo].[CR_Credito_CheckList_Resumen] chkres_org on
chkres_org.Id_Credito = chkres.ID_Credito_Origen
left join websec.[dbo].SegUsuarios usuarioCC on
usuarioCC.IdUsuario = chkres.[Id_Usuario_Asignado]
Left join TR_Unidad_Medida UM on Credito.Cod_Frecuencia_Pago = UM.COD_UDM
LEFT JOIN
(
SELECT
Id_Referencia
, COUNT(*) AS cuentaIncidencias
FROM dbo.Exp_Tikets_Expediente
WHERE Fecha_Cierre IS NULL
AND Cod_Tipo_Tramite = ''01''
AND Cod_ECV_Ticket = ''AB''
GROUP BY ID_Referencia
) AS InciAbiertas ON Credito.ID_Credito = InciAbiertas.ID_Referencia
LEFT JOIN
(
SELECT
Id_Referencia
, COUNT(*) AS cuentaIncidencias
FROM dbo.Exp_Tikets_Expediente
WHERE Fecha_Cierre IS NULL
AND Cod_Tipo_Tramite = ''01''
AND Cod_ECV_Ticket = ''AT''
GROUP BY ID_Referencia
) AS InciAntedidas ON Credito.ID_Credito = InciAntedidas.ID_Referencia
left join TR_Campanas campania on campania.Id_Campana = credito.Id_Campana
'

print 'Longitud @SQL_From 3'
print len(@SQL_From)

print '@Id_Usuario'
print @Id_Usuario

SET @SQL_Where = N' Credito.id_credito > 1000000 '

if @permisoasignar = 0 and @permisoverSol = 0
begin
 print 'entro @permisoasignar = 0 and @permisoverSol = 0'

 if @IdPerfil = 19
 begin
  print 'entro perfil 19 documental: asignadas + no asignadas'

  set @SQL_Where = N'(
   usrs.id_usuario in (
    select id_usuario
    from fn_Orgn_Usuarios_Jerarquia(' + cast(@Id_Usuario as varchar(20)) + N')
   )
   or (credusrAnalista.id_usuario = ' + cast(@Id_Usuario as varchar(20)) + N')
   or not exists (
    select 1
    from CR_Credito_Usuarios cuAsignado
    where cuAsignado.Id_Credito = Credito.Id_Credito
      and cuAsignado.Cod_ECV_Credito_Usuario = ''01''
   )
  )'
 end
 else
 begin
  set @SQL_Where = N'(
   usrs.id_usuario in (
    select id_usuario
    from fn_Orgn_Usuarios_Jerarquia(' + cast(@Id_Usuario as varchar(20)) + N')
   )
   or (credusrAnalista.id_usuario = ' + cast(@Id_Usuario as varchar(20)) + N')
  )'
 end
end
  print ' Filtro por nombre'
declare @filtro Nvarchar(max)

SELECT @filtro = nombre.value('.','varchar(100)')
FROM @filtrosXML.nodes('/nombres') as filtros(nombre)

if ltrim(rtrim(@filtro)) <> ''
BEGIN
print ' Filtro por nombre armado'

select @SQL_Where = @SQL_Where +
N' And Persona.Primer_Nombre + '' ''+ ' +
N' Persona.Segundo_Nombre + '' '' + ' +
N' Persona.Primer_Apellido + '' '' + ' +
N' Persona.Segundo_Apellido like ''%' + @filtro + '%'''

print  'Inicio where nombre'
print  CAST(@SQL_Where AS NTEXT)
print  'fin where nombre'
END

print ' Filtro por productos'

set @filtro = ''

SELECT @filtro = productos.value('.','varchar(100)')
FROM @filtrosXML.nodes('/productos') as filtros(productos)

if ltrim(rtrim(@filtro)) <> ''
set @SQL_Where = @SQL_Where + N' And Credito.Cod_Producto in (' + @filtro + ')'   + char(13)

set @filtro = ''

SELECT @filtro = importemin.value('.','varchar(100)')
FROM @filtrosXML.nodes('/importemin') as filtros(importemin)

if ltrim(rtrim(@filtro)) <> ''
set @SQL_Where = @SQL_Where + N' And Importe >= ' + @filtro + char(13)

set @filtro = ''

SELECT @filtro = importemax.value('.','varchar(100)')
FROM @filtrosXML.nodes('/importemax') as filtros(importemax)

if ltrim(rtrim(@filtro)) <> ''
BEGIN
set @SQL_Where = @SQL_Where + N' And Importe <= ' + @filtro  + char(13)
END

set @filtro = ''

SELECT @filtro = frecuencias.value('.','varchar(100)')
FROM @filtrosXML.nodes('/frecuencias') as filtros(frecuencias)

if ltrim(rtrim(@filtro)) <> ''
BEGIN
set @SQL_Where = @SQL_Where + N' And Cod_Frecuencia_Pago in (' + replace(@filtro,'','''') + ')'   + char(13)
END

set @filtro = ''

SELECT @filtro = fechainiciomin.value('.','varchar(100)')
FROM @filtrosXML.nodes('/fechainiciomin') as filtros(fechainiciomin)

if ltrim(rtrim(@filtro)) <> ''
BEGIN
set @SQL_Where = @SQL_Where + N' And Credito.Fecha_Inicio >= ''' + @filtro + ''''   + char(13)
END

set @filtro = ''

SELECT @filtro = fechainiciomax.value('.','varchar(100)')
FROM @filtrosXML.nodes('/fechainiciomax') as filtros(fechainiciomax)

if ltrim(rtrim(@filtro)) <> ''
BEGIN
set @SQL_Where = @SQL_Where + N' And Credito.Fecha_Inicio <= ''' + @filtro + ''''   + char(13)
END

set @filtro = ''

SELECT @filtro = fechaprimliqmin.value('.','varchar(100)')
FROM @filtrosXML.nodes('/fechaprimliqmin') as filtros(fechaprimliqmin)

if ltrim(rtrim(@filtro)) <> ''
BEGIN
set @SQL_Where = @SQL_Where + N' And Credito.Fecha_Prim_Liq >= ''' + @filtro + ''''   + char(13)
END

set @filtro = ''

SELECT @filtro = fechaprimliqmax.value('.','varchar(100)')
FROM @filtrosXML.nodes('/fechaprimliqmax') as filtros(fechaprimliqmax)

if ltrim(rtrim(@filtro)) <> ''
BEGIN
set @SQL_Where = @SQL_Where + N' And Credito.Fecha_Prim_Liq <= ''' + @filtro + ''''   + char(13)
END

set @filtro = ''

SELECT @filtro = etapas.value('.','varchar(100)')
FROM @filtrosXML.nodes('/etapas') as filtros(etapas)

if ltrim(rtrim(@filtro)) <> ''
BEGIN
set @SQL_Where = @SQL_Where + N' And Credito.Cod_Etapa in (' + replace(@filtro,'','''') + ')'   + char(13)
END

set @filtro = ''

SELECT @filtro = estatus.value('.','varchar(100)')
FROM @filtrosXML.nodes('/estatus') as filtros(estatus)

if ltrim(rtrim(@filtro)) <> ''
BEGIN
set @SQL_Where = @SQL_Where + N' And estatus.Cod_Estatus in (' + replace(@filtro,'','''') + ')'   + char(13)
END

set @filtro = ''

SELECT @filtro = nombreanalista.value('.','varchar(100)')
FROM @filtrosXML.nodes('/nombreanalista') as filtros(nombreanalista)

if ltrim(rtrim(@filtro)) <> ''
BEGIN
set @SQL_Where = @SQL_Where + N' And usrAnalista.Nombre like ''%' + @filtro + '%'''   + char(13)
END

set @filtro = ''

SELECT @filtro = asignable.value('.','varchar(100)')
FROM @filtrosXML.nodes('/asignable') as filtros(asignable)

if ltrim(rtrim(@filtro)) <> ''
begin
 if @filtro = '0'
 begin
  set @SQL_Where = @SQL_Where + N' And isnull(asignable.Cod_Etapa, '''') = '''''   + char(13)
 end

 if @filtro = '1'
 begin
  set @SQL_Where = @SQL_Where + N' And isnull(asignable.Cod_Etapa, '''') <> '''''   + char(13)
 end
end

set @filtro = ''

SELECT @filtro = incidenciasabiertas.value('.','varchar(100)')
FROM @filtrosXML.nodes('/incidenciasabiertas') as filtros(incidenciasabiertas)

print 'longitud @SQL_Where'
print Len(@SQL_Where)

if ltrim(rtrim(@filtro)) <> ''
begin
set @SQL_Where = @SQL_Where + N' And (Select count(*)  from Exp_Tikets_Expediente where Fecha_Cierre is null '   + char(13)
set @SQL_Where = @SQL_Where + N' and [ID_Referencia] = Credito.ID_Credito and [Cod_Tipo_Tramite] = ''01'' '   + char(13)
set @SQL_Where = @SQL_Where + N' and Cod_ECV_Ticket = ''AB'') > 0 '   + char(13)
end

print 'longitud @SQL_Where'
print Len(@SQL_Where)

set @filtro = ''

SELECT @filtro = incidenciasatendidas.value('.','varchar(100)')
FROM @filtrosXML.nodes('/incidenciasatendidas') as filtros(incidenciasatendidas)

if ltrim(rtrim(@filtro)) <> ''
begin
set @SQL_Where = @SQL_Where + N' And (Select count(*)  from Exp_Tikets_Expediente where Fecha_Cierre is null '   + char(13)
set @SQL_Where = @SQL_Where + N' and [ID_Referencia] = Credito.ID_Credito and [Cod_Tipo_Tramite] = ''01'' '   + char(13)
set @SQL_Where = @SQL_Where + N' and Cod_ECV_Ticket = ''AT'') > 0 '   + char(13)
end

set @filtro = ''

SELECT @filtro = asignada.value('.','varchar(100)')
FROM @filtrosXML.nodes('/asignada') as filtros(asignada)

if ltrim(rtrim(@filtro)) <> ''
set @SQL_Where = @SQL_Where + N' And usrAnalista.Nombre is not null'   + char(13)

if @IdPerfil = 17 or @IdPerfil = 18
begin
set @SQL_Where = @SQL_Where + N' And (chkres.Resultado <> ''S'' or chkres.Resultado is null) '   + char(13)
set @SQL_Where = @SQL_Where + N' And (chkres.Resultado <> ''N'' or chkres.Resultado is null) '   + char(13)
end

set @filtro = ''

SELECT @filtro = vercanceladas.value('.','varchar(100)')
FROM @filtrosXML.nodes('/vercanceladas') as filtros(vercanceladas)

if ltrim(rtrim(@filtro)) = ''
begin
set @SQL_Where = @SQL_Where + N' And (Credito.Cod_Estatus <> ''04'' ) '   + char(13)
end

set @filtro = ''

SELECT @filtro = vercreditosactivos.value('.','varchar(100)')
FROM @filtrosXML.nodes('/vercreditosactivos') as filtros(vercreditosactivos)

if ltrim(rtrim(@filtro)) = ''
begin
set @SQL_Where = @SQL_Where + N' And (Credito.Cod_Etapa <> ''08''  '   + char(13)
set @SQL_Where = @SQL_Where + N' And Credito.Cod_Estatus <> ''24'' ) '   + char(13)
end

set @filtro = ''

SELECT @filtro = idsolicitud.value('.','varchar(100)')
FROM @filtrosXML.nodes('/idsolicitud') as filtros(idsolicitud)

if ltrim(rtrim(@filtro)) <> ''
begin
print '@filtro en idsolicitud'
print @filtro + '-'
set @SQL_Where = @SQL_Where + N' And Credito.Id_Credito = ' + @filtro + char(13)
end

print 'longitud @SQL_Where'
print Len(@SQL_Where)
print @sql_Where

declare @sql_completo nvarchar(max)

set @sql_completo = N'Select ' + @SQL_Campos_Select + N' From  ' + @SQL_From + N' Where ' + @SQL_Where + N' ORDER BY credito.ID_Credito DESC'

print '------------------ Query Completo ------------------'
print @sql_completo
print '------------------ Query Completo ------------------'

EXECUTE sp_executesql @sql_completo

end
