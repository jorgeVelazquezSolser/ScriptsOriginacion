USE Originacion

CREATE OR ALTER PROCEDURE dbo.proc_Ctz_EjecutivoCelulaDigital_Get
    @Id_Cotizacion INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1
        Id_Cotizacion_Ejecutivo,
        Id_Cotizacion,
        Id_Ejecutivo_Ventas,
        Fecha_Registro,
        Cod_Rol_Ejecutivo
    FROM dbo.Ctz_Ejecutivos
    WHERE Id_Cotizacion = @Id_Cotizacion
    ORDER BY Id_Cotizacion_Ejecutivo DESC;
END
GO