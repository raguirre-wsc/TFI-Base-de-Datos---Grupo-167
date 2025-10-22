/*CARGA MASIVA - TABLA PEDIDOS*/
-- borramos datos cargados previamente si los hubiese
DELETE FROM Pedido;

-- reseteamos el contador para autoincrementar la clave primaria
ALTER TABLE Pedido AUTO_INCREMENT = 1;

-- desactivamos momentaneamente el check de foreign key para poder cagar datos en el campo envio
SET foreign_key_checks = 0;

-- creamos una tabla temporal con una serie de 1 a 500.000
DROP TEMPORARY TABLE IF EXISTS seed_numeros;
CREATE TEMPORARY TABLE seed_numeros AS
SELECT (@row := @row + 1) AS n
FROM
  (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
   UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t1,
  (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
   UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t2,
  (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
   UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t3,
  (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
   UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t4,
  (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
   UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t5,
  (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
   UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t6,
  (SELECT @row := 0) r
LIMIT 500000;


-- Insertamos todos los pedidos en una sola vez
INSERT INTO Pedido (numero, fecha, clienteNombre, total, estado, envio)
SELECT
    CONCAT('PED-', LPAD(n, 9, '0')) AS numero,
    DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * 2190) DAY) AS fecha,
    CONCAT(
        ELT(FLOOR(1 + RAND()*10), 'Juan','Maria','Pedro','Laura','Andres','Lucia','Sofia','Carlos','Julieta','Diego'),
        ' ',
        ELT(FLOOR(1 + RAND()*10), 'Garcia','Perez','Rodriguez','Lopez','Fernandez','Gomez','Torres','Romero','Diaz','Sanchez')
    ) AS clienteNombre,
    ROUND(1 + RAND() * 10000000, 2) AS total,
    ELT(FLOOR(1 + RAND()*3), 'NUEVO','FACTURADO','ENVIADO') AS estado,
    n AS envio
FROM seed_numeros
WHERE n BETWEEN 1 AND 500000;



-- contamos los registros
SELECT COUNT(*) FROM Pedido;


/*CARGA MASIVA - TABLA ENVIOS*/
-- eliminamos registros de envio si los hubiese
DELETE FROM Envio;

-- insertamos datos a partir de los registros de la tabla Pedido, usando p.envio como id de la tabla
INSERT INTO Envio (id, tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
-- usamos un CTE para calcular primero fechaDespacho, dado que fechaEstimada despende de este campo para poblarse
WITH base AS (
    SELECT 
        p.envio AS id,
        CONCAT('TRK-', LPAD(id, 9, '0')) AS tracking,
        DATE_ADD(p.fecha, INTERVAL 1 DAY) AS fechaDespacho,
        ELT(FLOOR(1 + RAND()*3), 'ANDREANI','OCA','CORREO_ARG') AS empresa,
        ELT(FLOOR(1 + RAND()*2), 'ESTANDAR','EXPRES') AS tipo,
        ROUND(p.total * 0.001 + RAND() * 5000, 2) AS costo,
        ELT(FLOOR(1 + RAND()*3), 'EN_PREPARACION','EN_TRANSITO','ENTREGADO') AS estado
    FROM Pedido p
)
SELECT 
    id,
    tracking,
    empresa,
    tipo,
    costo,
    fechaDespacho,
    DATE_ADD(fechaDespacho, INTERVAL 1 + (FLOOR(RAND()*7)) DAY) AS fechaEstimada,
    estado
FROM base;

-- contamos registros
SELECT COUNT(*) FROM Envio;

-- volvemos a activar el check de foreign key
SET foreign_key_checks = 1;