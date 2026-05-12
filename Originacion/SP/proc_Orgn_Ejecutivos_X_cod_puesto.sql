USE Originacion

create or alter procedure proc_Orgn_Ejecutivos_X_cod_puesto
@Codigo_Puesto nvarchar(510)
as
begin
	Select 
		ID_Ejecutivo_Ventas,
		Nombre,
		Estatus,
		Fecha_Alta,
		Email,
		[User_Name],
		Id_Ejecutivo_Padre,
		ID_Empleado,
		ID_Comisionista
	from Vtas_Ejecutivos
	where Codigo_Puesto = @Codigo_Puesto
end;

GO
