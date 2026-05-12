IF NOT EXISTS (
    SELECT 1
    FROM sys.columns
    WHERE Name = N'Observaciones'
      AND Object_ID = Object_ID(N'DR_Domicilios_Bitacora')
)
BEGIN
    ALTER TABLE DR_Domicilios_Bitacora
    ADD Observaciones NVARCHAR(500) NULL;
END

