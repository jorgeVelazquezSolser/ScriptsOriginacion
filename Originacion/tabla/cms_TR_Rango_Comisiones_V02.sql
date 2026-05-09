USE Originacion

ALTER TABLE cms_TR_Rango_Comisiones_V02
ADD Valor DECIMAL(18,2);

INSERT INTO [cms_TR_Rango_Comisiones_V02]
(Cod_Rango_Comision, Rango_Inicial, Rango_final, Factor, Valor)
VALUES
('16', 0, 499999.99, 0, NULL),
('16', 500000, 1499999.99, 0.03, NULL),
('16', 1500000, 2499999.99, 0.035, NULL),
('16', 2500000, 9999999999, 0.5, NULL),
('17', 0, 0, 0, 300),
('18', 0, 9999999999, 0.02, NULL);

GO