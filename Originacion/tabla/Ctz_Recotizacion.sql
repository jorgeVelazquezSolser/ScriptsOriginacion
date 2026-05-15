IF NOT EXISTS (
    SELECT 1
    FROM sys.columns
    WHERE Name = N'Id_Credito_Original'
      AND Object_ID = Object_ID(N'Ctz_Recotizacion')
)
BEGIN
    ALTER TABLE Ctz_Recotizacion
    ADD Id_Credito_Original INT NULL;
END
GO