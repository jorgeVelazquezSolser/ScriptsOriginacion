USE Originacion

ALTER TABLE cms_TR_Alcance_Comisiones
ADD Cod_Rol_Ejecutivo VARCHAR(100);

GO;

INSERT INTO cms_TR_Alcance_Comisiones
(
    Cod_tipo_Comision,
    Cod_Puesto,
    Cod_Alcance_Comision,
    Cod_Rango_Comision,
    Ind_Activo,
    Cod_Rol_Ejecutivo
)
VALUES
-- Rango 16
('1','9','5','16',1,'1'),
('1','9','5','16',1,'1'),
('1','9','5','16',1,'1'),
('1','9','5','16',1,'1'),

-- Rango 17
('1','1','5','17',1,'2'),
('1','2','5','17',1,'2'),
('1','3','5','17',1,'2'),
('1','4','5','17',1,'2'),

-- Rango 18
('1','1','5','18',1,'3'),
('1','2','5','18',1,'3'),
('1','3','5','18',1,'3'),
('1','4','5','18',1,'3');

GO

