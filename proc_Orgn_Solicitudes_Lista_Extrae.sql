-- Versión: v1_CallCenter_Recotizacion  |  Fecha: 2026-05-11  |  Autor: JorgeVelazquez
-- Agrega LEFT JOIN con CR_Credito_CheckList_Resumen (alias chkres) y usr_usuarios (alias usuarioCC)
-- y las columnas check* + CheckListCerrado en los 5 branches del SP.

USE [Originacion]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[proc_Orgn_Solicitudes_Lista_Extrae] (
	@Id_Usuario int
)
AS
Begin
	--declare @Id_Usuario int = 301

	declare @idPerfil int
	declare @idperfilcoordinadoroperaciones int
	declare @idperfilcoordinadorcallcenter int
	declare @idperfilanalistadocumental int

	select @idPerfil = idperfil
	from websec.dbo.[SegUsuariosPerfiles]
	where idusuario = @Id_Usuario
	  and Estatus = 'A'

	print '@idPerfil'
	print @idPerfil

	select @idperfilcoordinadoroperaciones = [ValorEntero]
	from [dbo].[Tr_Parametros_Generales]
	where [Nombre] = 'PerfilCoordOperaciones'

	print '@idperfilcoordinadoroperaciones'
	print @idperfilcoordinadoroperaciones

	select @idperfilcoordinadorcallcenter = [ValorEntero]
	from [dbo].[Tr_Parametros_Generales]
	where [Nombre] = 'PerfilCoordCallCenter'

	print '@idperfilcoordinadorcallcenter'
	print @idperfilcoordinadorcallcenter

	select @idperfilanalistadocumental = [ValorEntero]
	from [dbo].[Tr_Parametros_Generales]
	where [Nombre] = 'AnalistsaDocumental'

	print '@idperfilanalistadocumental'
	print @idperfilanalistadocumental

	declare @tienesolicitudes int = 0

	select @tienesolicitudes = count(id_usuario)
	from [CR_Credito_Usuarios]
	where Id_Usuario = @Id_Usuario
	  and Cod_ECV_Credito_Usuario = '01'


	if @idPerfil = @idperfilanalistadocumental
	begin
		print 'entro documental 19'

		SELECT distinct credito.ID_Credito,
		ltrim(rtrim(Persona.Primer_Nombre)) + ' ' +
		ltrim(rtrim(Persona.Segundo_Nombre)) + ' ' +
		ltrim(rtrim(Persona.Primer_Apellido)) + ' ' +
		ltrim(rtrim(Persona.Segundo_Apellido)) as Nombre,
		Importe,
		Cod_Frecuencia_Pago,
		(SELECT  vd.Descripcion
			FROM PR_Dominio_Tarifa dtr INNER JOIN TR_Dominios td ON  dtr.Cod_Dominio = td.Cod_Dominio
			INNER JOIN TR_Valores_Dominio vd on dtr.Cod_Dominio = vd.Cod_Dominio and
			dtr.Cod_Valor_Dominio = vd.Cod_Valor_Dominio
			where Cod_Tarifa = Credito.Cod_Tarifa
			and Cod_Param_Producto = 'A002'
			and dtr.Cod_Valor_Dominio = Credito.Cod_Frecuencia_Pago) as Frec_PAgo,
		Credito.Fecha_Inicio,
		Fecha_Prim_Liq,
		Etapas.Nombre_Estapa + '-' + Estatus.Nombre_Estatus as Etapa,
		Estatus.Nombre_Estatus as Estatus,
		CASE
			WHEN (Select count(*)  from Exp_Tikets_Expediente where Fecha_Cierre is null
			and [ID_Referencia] = Credito.ID_Credito and [Cod_Tipo_Tramite] = '01'
			and Cod_ECV_Ticket = 'AB') > 0
			THEN 2
			WHEN (Select count(*)  from Exp_Tikets_Expediente where Fecha_Cierre is null
			and [ID_Referencia] = Credito.ID_Credito
			and [Cod_Tipo_Tramite] = '01'
			and Cod_ECV_Ticket = 'AT'  ) > 0
			THEN 1

		ELSE -1
		END as incidencias
		,usrs.ID_Usuario
		,isnull(usrs.ID_Usuario_Padre,0) as ID_Usuario_Padre
		,usrs.Nombre as Nombre_Usuario
		,usrs.Id_Tipo_Usuario
		,usrs.Email as Email_Usuario
		,'U' as Clase_Registro_Usuario
		,credito.Cod_Etapa
		,credito.Cod_Estatus
		,usrAnalista.Nombre Nombre_Analista
		,usrAnalista.Id_Usuario Id_Usuario_Analista
		,CASE isnull(asignable.Cod_Etapa, '')
			WHEN '' THEN 0
			ELSE 1
		End as ASignable
		,asignable.Cod_Etapa
		,chkres.Id_Usuario_Asignado  AS checkIdUsuario
		,chkres.Fecha_Inicio         AS checkfechaInicio
		,chkres.Fecha_Fin            AS checkfechafin
		,chkres.Resultado            AS checkResultado
		,chkres.Fecha_Asignacion     AS checkFechaAsigna
		,chkres.Notas                AS checkNotas
		,ISNULL(usuarioCC.Nombre,'') AS checkUsuario
		,CAST(CASE WHEN chkres.Id_Credito IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS CheckListCerrado
		FROM CR_Credito as Credito
			left join [dbo].[TR_Cr_Etapas] as Etapas on Credito.Cod_Etapa = Etapas.Cod_Etapa
			inner join Pers_Persona Persona on Persona.Id_Persona = Credito.ID_Persona
			left join usr_usuarios usrs on Credito.ID_Usuario = usrs.ID_Usuario
			inner join TR_Cr_Estatus as estatus on estatus.Cod_Estatus = Credito.Cod_Estatus
			left join CR_Credito_Usuarios usuariocredito
				on Credito.ID_Credito = usuariocredito.Id_Credito
				and usuariocredito.Cod_ECV_Credito_Usuario = '01'
				and usuariocredito.Id_Usuario = @Id_Usuario
			left join [CR_Credito_Usuarios] credusrAnalista
				on Credito.ID_Credito = credusrAnalista.Id_Credito
				and credusrAnalista.Cod_ECV_Credito_Usuario = '01'
				and credusrAnalista.IdPerfil in (10,11, 19,20)
			left join Usr_Usuarios usrAnalista on credusrAnalista.ID_Usuario = usrAnalista.ID_Usuario
			inner join websec.[dbo].[SegUsuariosVistasEtapasEstatus] usrVistaEtapas
				on  usrVistaEtapas.IdPerfil = @idPerfil and
				usrVistaEtapas.Cod_Etapa = Credito.Cod_Etapa and
				usrVistaEtapas.Cod_Estatus = Credito.Cod_Estatus
			left join websec.dbo.[SegEtapasEsatusAsignables] asignable on
			Credito.Cod_Etapa = asignable.Cod_Etapa and
			Credito.Cod_Estatus = asignable.Cod_Estatus
			left join [dbo].[CR_Credito_CheckList_Resumen] chkres ON chkres.id_credito = Credito.ID_Credito
			left join usr_usuarios usuarioCC ON usuarioCC.ID_Usuario = chkres.Id_Usuario_Asignado
		 where credito.Id_Credito >= (select [ValorEntero]
									from  [dbo].[Tr_Parametros_Generales]
									where [Nombre] = 'IdCreditoInicial')
		   and (
				usuariocredito.Id_Usuario = @Id_Usuario
				or not exists (
					select 1
					from CR_Credito_Usuarios cuDoc
					where cuDoc.Id_Credito = credito.Id_Credito
					  and cuDoc.Cod_ECV_Credito_Usuario = '01'
				)
		   )
		order by Id_Credito
	end
	else if @tienesolicitudes > 0 and @idPerfil <> @idperfilcoordinadoroperaciones
		and @idPerfil <> @idperfilcoordinadorcallcenter
		and (select count(*) from websec.dbo.SegUsuariosPerfiles
		where IdPerfil = 20) = 0
	begin
		print 'entro 1'

		SELECT distinct credito.ID_Credito,
		ltrim(rtrim(Persona.Primer_Nombre)) + ' ' +
		ltrim(rtrim(Persona.Segundo_Nombre)) + ' ' +
		ltrim(rtrim(Persona.Primer_Apellido)) + ' ' +
		ltrim(rtrim(Persona.Segundo_Apellido)) as Nombre,
		Importe,
		Cod_Frecuencia_Pago,
		(SELECT  vd.Descripcion
			FROM PR_Dominio_Tarifa dtr INNER JOIN TR_Dominios td ON  dtr.Cod_Dominio = td.Cod_Dominio
			INNER JOIN TR_Valores_Dominio vd on dtr.Cod_Dominio = vd.Cod_Dominio and
			dtr.Cod_Valor_Dominio = vd.Cod_Valor_Dominio
			where Cod_Tarifa = Credito.Cod_Tarifa
			and Cod_Param_Producto = 'A002'
			and dtr.Cod_Valor_Dominio = Credito.Cod_Frecuencia_Pago) as Frec_PAgo,
		Credito.Fecha_Inicio,
		Fecha_Prim_Liq,
		Etapas.Nombre_Estapa + '-' + Estatus.Nombre_Estatus as Etapa,
		Estatus.Nombre_Estatus as Estatus,
		CASE
			WHEN (Select count(*)  from Exp_Tikets_Expediente where Fecha_Cierre is null
			and [ID_Referencia] = Credito.ID_Credito and [Cod_Tipo_Tramite] = '01'
			and Cod_ECV_Ticket = 'AB') > 0
			THEN 2
			WHEN (Select count(*)  from Exp_Tikets_Expediente where Fecha_Cierre is null
			and [ID_Referencia] = Credito.ID_Credito
			and [Cod_Tipo_Tramite] = '01'
			and Cod_ECV_Ticket = 'AT'  ) > 0
			THEN 1

		ELSE -1
		END as incidencias
		,usrs.ID_Usuario
		,isnull(usrs.ID_Usuario_Padre,0) as ID_Usuario_Padre
		,usrs.Nombre as Nombre_Usuario
		,usrs.Id_Tipo_Usuario
		,usrs.Email as Email_Usuario
		,'U' as Clase_Registro_Usuario
		,credito.Cod_Etapa
		,credito.Cod_Estatus
		,usrAnalista.Nombre Nombre_Analista
		,usrAnalista.Id_Usuario Id_Usuario_Analista
		,CASE isnull(asignable.Cod_Etapa, '')
			WHEN '' THEN 0
			ELSE 1
		End as ASignable
		,asignable.Cod_Etapa
		,chkres.Id_Usuario_Asignado  AS checkIdUsuario
		,chkres.Fecha_Inicio         AS checkfechaInicio
		,chkres.Fecha_Fin            AS checkfechafin
		,chkres.Resultado            AS checkResultado
		,chkres.Fecha_Asignacion     AS checkFechaAsigna
		,chkres.Notas                AS checkNotas
		,ISNULL(usuarioCC.Nombre,'') AS checkUsuario
		,CAST(CASE WHEN chkres.Id_Credito IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS CheckListCerrado
		FROM CR_Credito as Credito
			left join [dbo].[TR_Cr_Etapas] as Etapas on Credito.Cod_Etapa = Etapas.Cod_Etapa
			inner join Pers_Persona Persona on Persona.Id_Persona = Credito.ID_Persona
			left join usr_usuarios usrs on Credito.ID_Usuario = usrs.ID_Usuario
			inner join TR_Cr_Estatus as estatus on estatus.Cod_Estatus = Credito.Cod_Estatus
			left join CR_Credito_Usuarios usuariocredito on Credito.ID_Credito = usuariocredito.Id_Credito
			left join [CR_Credito_Usuarios] credusrAnalista on Credito.ID_Credito = credusrAnalista.Id_Credito and credusrAnalista.Cod_ECV_Credito_Usuario = '01' and credusrAnalista.IdPerfil in (10,11, 19,20)
			left join Usr_Usuarios usrAnalista on credusrAnalista.ID_Usuario = usrAnalista.ID_Usuario
			inner join websec.[dbo].[SegUsuariosVistasEtapasEstatus] usrVistaEtapas
				on  usrVistaEtapas.IdPerfil = @idPerfil and
				usrVistaEtapas.Cod_Etapa = Credito.Cod_Etapa and
				usrVistaEtapas.Cod_Estatus = Credito.Cod_Estatus
			left join websec.dbo.[SegEtapasEsatusAsignables] asignable on
			Credito.Cod_Etapa = asignable.Cod_Etapa and
			Credito.Cod_Estatus = asignable.Cod_Estatus
			left join [dbo].[CR_Credito_CheckList_Resumen] chkres ON chkres.id_credito = Credito.ID_Credito
			left join usr_usuarios usuarioCC ON usuarioCC.ID_Usuario = chkres.Id_Usuario_Asignado
		 where credito.Id_Credito >= (select [ValorEntero]
									from  [dbo].[Tr_Parametros_Generales]
									where [Nombre] = 'IdCreditoInicial')
			and usuariocredito.Id_Usuario = @Id_Usuario
		order by Id_Credito
	end
	else if @idPerfil = @idperfilcoordinadorcallcenter
	begin
		print 'entro 2'

		SELECT credito.ID_Credito,
		ltrim(rtrim(Persona.Primer_Nombre)) + ' ' +
		ltrim(rtrim(Persona.Segundo_Nombre)) + ' ' +
		ltrim(rtrim(Persona.Primer_Apellido)) + ' ' +
		ltrim(rtrim(Persona.Segundo_Apellido)) as Nombre,
		Importe,
		Cod_Frecuencia_Pago,
		(SELECT  vd.Descripcion
			FROM PR_Dominio_Tarifa dtr INNER JOIN TR_Dominios td ON  dtr.Cod_Dominio = td.Cod_Dominio
			INNER JOIN TR_Valores_Dominio vd on dtr.Cod_Dominio = vd.Cod_Dominio and
			dtr.Cod_Valor_Dominio = vd.Cod_Valor_Dominio
			where Cod_Tarifa = Credito.Cod_Tarifa
			and Cod_Param_Producto = 'A002'
			and dtr.Cod_Valor_Dominio = Credito.Cod_Frecuencia_Pago) as Frec_PAgo,
		Credito.Fecha_Inicio,
		Fecha_Prim_Liq,
		Etapas.Nombre_Estapa + '-' + Estatus.Nombre_Estatus as Etapa,
		Estatus.Nombre_Estatus as Estatus,
		CASE
			WHEN (Select count(*)  from Exp_Tikets_Expediente where Fecha_Cierre is null
			and [ID_Referencia] = Credito.ID_Credito and [Cod_Tipo_Tramite] = '01'
			and Cod_ECV_Ticket = 'AB') > 0
			THEN 2
			WHEN (Select count(*)  from Exp_Tikets_Expediente where Fecha_Cierre is null
			and [ID_Referencia] = Credito.ID_Credito
			and [Cod_Tipo_Tramite] = '01'
			and Cod_ECV_Ticket = 'AT' ) > 0
			THEN 1

		ELSE -1
		END as incidencias
		,usrs.ID_Usuario
		,isnull(usrs.ID_Usuario_Padre,0) as ID_Usuario_Padre
		,usrs.Nombre as Nombre_Usuario
		,usrs.Id_Tipo_Usuario
		,usrs.Email as Email_Usuario
		,'U' as Clase_Registro_Usuario
		,credito.Cod_Etapa
		,credito.Cod_Estatus
		,usrAnalista.Nombre Nombre_Analista
		,usrAnalista.Id_Usuario Id_Usuario_Analista
		,CASE isnull(asignable.Cod_Etapa, '')
			WHEN '' THEN 0
			ELSE 1
		End as ASignable
		,asignable.Cod_Etapa
		,chkres.Id_Usuario_Asignado  AS checkIdUsuario
		,chkres.Fecha_Inicio         AS checkfechaInicio
		,chkres.Fecha_Fin            AS checkfechafin
		,chkres.Resultado            AS checkResultado
		,chkres.Fecha_Asignacion     AS checkFechaAsigna
		,chkres.Notas                AS checkNotas
		,ISNULL(usuarioCC.Nombre,'') AS checkUsuario
		,CAST(CASE WHEN chkres.Id_Credito IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS CheckListCerrado
		FROM CR_Credito as Credito
			left join [dbo].[TR_Cr_Etapas] as Etapas on Credito.Cod_Etapa = Etapas.Cod_Etapa
			inner join Pers_Persona Persona on Persona.Id_Persona = Credito.ID_Persona
			left join usr_usuarios usrs on Credito.ID_Usuario = usrs.ID_Usuario
			inner join TR_Cr_Estatus as estatus on estatus.Cod_Estatus = Credito.Cod_Estatus
			left join [CR_Credito_Usuarios] credusrAnalista on Credito.ID_Credito = credusrAnalista.Id_Credito and credusrAnalista.Cod_ECV_Credito_Usuario = '01' and (credusrAnalista.IdPerfil = 17 or credusrAnalista.IdPerfil = 18)
			left join usr_usuarios usrAnalista on credusrAnalista.ID_Usuario = usrAnalista.ID_Usuario
			inner join websec.[dbo].[SegUsuariosVistasEtapasEstatus] usrVistaEtapas
				on  usrVistaEtapas.IdPerfil = @idPerfil and
				usrVistaEtapas.Cod_Etapa = Credito.Cod_Etapa and
				usrVistaEtapas.Cod_Estatus = Credito.Cod_Estatus
			left join websec.dbo.[SegEtapasEsatusAsignables] asignable on
			Credito.Cod_Etapa = asignable.Cod_Etapa and
			Credito.Cod_Estatus = asignable.Cod_Estatus
			left join [dbo].[CR_Credito_CheckList_Resumen] chkres ON chkres.id_credito = Credito.ID_Credito
			left join usr_usuarios usuarioCC ON usuarioCC.ID_Usuario = chkres.Id_Usuario_Asignado
		 where credito.Id_Credito >= (select [ValorEntero]
									from  [dbo].[Tr_Parametros_Generales]
									where [Nombre] = 'IdCreditoInicial')
		order by Id_Credito
	end
	else if @idPerfil = @idperfilcoordinadoroperaciones
	or (select count(*) from websec.dbo.SegUsuariosPerfiles
		where IdPerfil = 20) > 0
	begin
		print 'entro 3'

		SELECT credito.ID_Credito,
		ltrim(rtrim(Persona.Primer_Nombre)) + ' ' +
		ltrim(rtrim(Persona.Segundo_Nombre)) + ' ' +
		ltrim(rtrim(Persona.Primer_Apellido)) + ' ' +
		ltrim(rtrim(Persona.Segundo_Apellido)) as Nombre,
		Importe,
		Cod_Frecuencia_Pago,
		(SELECT  vd.Descripcion
			FROM PR_Dominio_Tarifa dtr INNER JOIN TR_Dominios td ON  dtr.Cod_Dominio = td.Cod_Dominio
			INNER JOIN TR_Valores_Dominio vd on dtr.Cod_Dominio = vd.Cod_Dominio and
			dtr.Cod_Valor_Dominio = vd.Cod_Valor_Dominio
			where Cod_Tarifa = Credito.Cod_Tarifa
			and Cod_Param_Producto = 'A002'
			and dtr.Cod_Valor_Dominio = Credito.Cod_Frecuencia_Pago) as Frec_PAgo,
		Credito.Fecha_Inicio,
		Fecha_Prim_Liq,
		Etapas.Nombre_Estapa + '-' + Estatus.Nombre_Estatus as Etapa,
		Estatus.Nombre_Estatus as Estatus,
		CASE
			WHEN (Select count(*)  from Exp_Tikets_Expediente where Fecha_Cierre is null
			and [ID_Referencia] = Credito.ID_Credito and [Cod_Tipo_Tramite] = '01'
			and Cod_ECV_Ticket = 'AB') > 0
			THEN 2
			WHEN (Select count(*)  from Exp_Tikets_Expediente where Fecha_Cierre is null
			and [ID_Referencia] = Credito.ID_Credito
			and [Cod_Tipo_Tramite] = '01'
			and Cod_ECV_Ticket = 'AT' ) > 0
			THEN 1

		ELSE -1
		END as incidencias
		,usrs.ID_Usuario
		,isnull(usrs.ID_Usuario_Padre,0) as ID_Usuario_Padre
		,usrs.Nombre as Nombre_Usuario
		,usrs.Id_Tipo_Usuario
		,usrs.Email as Email_Usuario
		,'U' as Clase_Registro_Usuario
		,credito.Cod_Etapa
		,credito.Cod_Estatus
		,usrAnalista.Nombre Nombre_Analista
		,usrAnalista.Id_Usuario Id_Usuario_Analista
		,CASE isnull(asignable.Cod_Etapa, '')
			WHEN '' THEN 0
			ELSE 1
		End as ASignable
		,asignable.Cod_Etapa
		,chkres.Id_Usuario_Asignado  AS checkIdUsuario
		,chkres.Fecha_Inicio         AS checkfechaInicio
		,chkres.Fecha_Fin            AS checkfechafin
		,chkres.Resultado            AS checkResultado
		,chkres.Fecha_Asignacion     AS checkFechaAsigna
		,chkres.Notas                AS checkNotas
		,ISNULL(usuarioCC.Nombre,'') AS checkUsuario
		,CAST(CASE WHEN chkres.Id_Credito IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS CheckListCerrado
		FROM CR_Credito as Credito
			left join [dbo].[TR_Cr_Etapas] as Etapas on Credito.Cod_Etapa = Etapas.Cod_Etapa
			inner join Pers_Persona Persona on Persona.Id_Persona = Credito.ID_Persona
			left join usr_usuarios usrs on Credito.ID_Usuario = usrs.ID_Usuario
			inner join TR_Cr_Estatus as estatus on estatus.Cod_Estatus = Credito.Cod_Estatus
			left join [CR_Credito_Usuarios] credusrAnalista on Credito.ID_Credito = credusrAnalista.Id_Credito and credusrAnalista.Cod_ECV_Credito_Usuario = '01' and credusrAnalista.IdPerfil in ( 9,10,11, 19,20)
			left join usr_usuarios usrAnalista on credusrAnalista.ID_Usuario = usrAnalista.ID_Usuario
			inner join websec.[dbo].[SegUsuariosVistasEtapasEstatus] usrVistaEtapas
				on  usrVistaEtapas.IdPerfil = @idPerfil and
				usrVistaEtapas.Cod_Etapa = Credito.Cod_Etapa and
				usrVistaEtapas.Cod_Estatus = Credito.Cod_Estatus
			left join websec.dbo.[SegEtapasEsatusAsignables] asignable on
			Credito.Cod_Etapa = asignable.Cod_Etapa and
			Credito.Cod_Estatus = asignable.Cod_Estatus
			left join [dbo].[CR_Credito_CheckList_Resumen] chkres ON chkres.id_credito = Credito.ID_Credito
			left join usr_usuarios usuarioCC ON usuarioCC.ID_Usuario = chkres.Id_Usuario_Asignado
		 where credito.Id_Credito >= (select [ValorEntero]
									from  [dbo].[Tr_Parametros_Generales]
									where [Nombre] = 'IdCreditoInicial')
		order by Id_Credito
	end
	else
	begin
		print 'entro al else'

		SELECT credito.ID_Credito,
		ltrim(rtrim(Persona.Primer_Nombre)) + ' ' +
		ltrim(rtrim(Persona.Segundo_Nombre)) + ' ' +
		ltrim(rtrim(Persona.Primer_Apellido)) + ' ' +
		ltrim(rtrim(Persona.Segundo_Apellido)) as Nombre,
		Importe,
		Cod_Frecuencia_Pago,
		(SELECT  vd.Descripcion
			FROM PR_Dominio_Tarifa dtr INNER JOIN TR_Dominios td ON  dtr.Cod_Dominio = td.Cod_Dominio
			INNER JOIN TR_Valores_Dominio vd on dtr.Cod_Dominio = vd.Cod_Dominio and
			dtr.Cod_Valor_Dominio = vd.Cod_Valor_Dominio
			where Cod_Tarifa = Credito.Cod_Tarifa
			and Cod_Param_Producto = 'A002'
			and dtr.Cod_Valor_Dominio = Credito.Cod_Frecuencia_Pago) as Frec_PAgo,
		Credito.Fecha_Inicio,
		Fecha_Prim_Liq,
		Etapas.Nombre_Estapa + '-' + Estatus.Nombre_Estatus as Etapa,
		Estatus.Nombre_Estatus as Estatus,
		CASE
			WHEN (Select count(*)  from Exp_Tikets_Expediente where Fecha_Cierre is null
			and [ID_Referencia] = Credito.ID_Credito and [Cod_Tipo_Tramite] = '01'
			and Cod_ECV_Ticket = 'AB') > 0
			THEN 2
			WHEN (Select count(*)  from Exp_Tikets_Expediente where Fecha_Cierre is null
			and [ID_Referencia] = Credito.ID_Credito
			and [Cod_Tipo_Tramite] = '01'
			and Cod_ECV_Ticket = 'AT' ) > 0
			THEN 1

		ELSE -1
		END as incidencias
		,usrs.ID_Usuario
		,isnull(usrs.ID_Usuario_Padre,0) as ID_Usuario_Padre
		,usrs.Nombre as Nombre_Usuario
		,usrs.Id_Tipo_Usuario
		,usrs.Email as Email_Usuario
		,usrs.Clase as Clase_Registro_Usuario
		,credito.Cod_Etapa
		,credito.Cod_Estatus
		,usrAnalista.Nombre Nombre_Analista
		,usrAnalista.Id_Usuario Id_Usuario_Analista
		,CASE isnull(asignable.Cod_Etapa, '')
			WHEN '' THEN 0
			ELSE 1
		End as ASignable
		,asignable.Cod_Etapa
		,chkres.Id_Usuario_Asignado  AS checkIdUsuario
		,chkres.Fecha_Inicio         AS checkfechaInicio
		,chkres.Fecha_Fin            AS checkfechafin
		,chkres.Resultado            AS checkResultado
		,chkres.Fecha_Asignacion     AS checkFechaAsigna
		,chkres.Notas                AS checkNotas
		,ISNULL(usuarioCC.Nombre,'') AS checkUsuario
		,CAST(CASE WHEN chkres.Id_Credito IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS CheckListCerrado
		FROM CR_Credito as Credito
			left join [dbo].[TR_Cr_Etapas] as Etapas on Credito.Cod_Etapa = Etapas.Cod_Etapa
			inner join Pers_Persona Persona on Persona.Id_Persona = Credito.ID_Persona
			inner join fn_Orgn_Usuarios_Jerarquia(@Id_Usuario) usrs on Credito.ID_Usuario = usrs.ID_Usuario
			inner join TR_Cr_Estatus as estatus on estatus.Cod_Estatus = Credito.Cod_Estatus
			left join [CR_Credito_Usuarios] credusrAnalista on Credito.ID_Credito = credusrAnalista.Id_Credito and credusrAnalista.Cod_ECV_Credito_Usuario = '01' and credusrAnalista.IdPerfil in (10,11, 19,20)
			left join usr_usuarios usrAnalista on credusrAnalista.ID_Usuario = usrAnalista.ID_Usuario
			inner join websec.[dbo].[SegUsuariosVistasEtapasEstatus] usrVistaEtapas
				on  usrVistaEtapas.Cod_Etapa = Credito.Cod_Etapa and
				usrVistaEtapas.Cod_Estatus = Credito.Cod_Estatus
			left join websec.dbo.[SegEtapasEsatusAsignables] asignable on
			Credito.Cod_Etapa = asignable.Cod_Etapa and
			Credito.Cod_Estatus = asignable.Cod_Estatus
			left join [dbo].[CR_Credito_CheckList_Resumen] chkres ON chkres.id_credito = Credito.ID_Credito
			left join usr_usuarios usuarioCC ON usuarioCC.ID_Usuario = chkres.Id_Usuario_Asignado
		where (usrs.id_usuario = @Id_Usuario or usrs.ID_Usuario_Padre = @Id_Usuario)
		order by Id_Credito
	end

End
