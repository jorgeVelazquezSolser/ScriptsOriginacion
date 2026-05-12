USE Originacion

CREATE OR ALTER PROCEDURE dbo.proc_Ctz_EjecutivoCelulaDigital_AddUpdate
    @Id_Cotizacion INT,
    @Id_Ejecutivo_Ventas INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Codigo_Origen_Cotizacion VARCHAR(10);

    SELECT TOP 1
        @Codigo_Origen_Cotizacion = Codigo_Origen_Cotizacion
    FROM dbo.Ctz_Cotizacion
    WHERE ID_Cotizacion = @Id_Cotizacion;

    IF ISNULL(@Codigo_Origen_Cotizacion, '') <> '03'
    BEGIN
        RETURN;
    END

    IF EXISTS (
        SELECT 1
        FROM dbo.Ctz_Ejecutivos
        WHERE Id_Cotizacion = @Id_Cotizacion
    )
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM dbo.Ctz_Ejecutivos
            WHERE Id_Cotizacion = @Id_Cotizacion
              AND ISNULL(Id_Ejecutivo_Ventas, 0) <> ISNULL(@Id_Ejecutivo_Ventas, 0)
        )
        BEGIN
            UPDATE dbo.Ctz_Ejecutivos
            SET Id_Ejecutivo_Ventas = @Id_Ejecutivo_Ventas,
                Fecha_Registro = GETDATE()
            WHERE Id_Cotizacion = @Id_Cotizacion;
        END
    END
    ELSE
    BEGIN
        INSERT INTO dbo.Ctz_Ejecutivos
        (
            Id_Cotizacion,
            Id_Ejecutivo_Ventas,
            Fecha_Registro,
            Cod_Rol_Ejecutivo
        )
        VALUES
        (
            @Id_Cotizacion,
            @Id_Ejecutivo_Ventas,
            GETDATE(),
            '02'
        );
    END
END
GO
