USE pedido_envio;

-- EMPRESA
CREATE TEMPORARY TABLE seed_empresas (empresa ENUM('ANDREANI','OCA','CORREO_ARG'));
INSERT INTO seed_empresas VALUES ('ANDREANI'), ('OCA'), ('CORREO_ARG');

-- TIPO ENVIO
CREATE TEMPORARY TABLE seed_tipos (tipo ENUM('ESTANDAR','EXPRES'));
INSERT INTO seed_tipos VALUES ('ESTANDAR'), ('EXPRES');

-- ESTADO ENVIO
CREATE TEMPORARY TABLE seed_estados_envio (estado ENUM('EN_PREPARACION','EN_TRANSITO','ENTREGADO'));
INSERT INTO seed_estados_envio VALUES ('EN_PREPARACION'), ('EN_TRANSITO'), ('ENTREGADO');

-- ESTADO PEDIDO
CREATE TEMPORARY TABLE seed_estados_pedido (estado ENUM('NUEVO','FACTURADO','ENVIADO'));
INSERT INTO seed_estados_pedido VALUES ('NUEVO'), ('FACTURADO'), ('ENVIADO');

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
LIMIT 300000;

-- TABLA ENVIO
-- PRIMER REGISTRO
  INSERT INTO Envio (tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
  SELECT
      NULL,
      (SELECT empresa FROM seed_empresas ORDER BY RAND() LIMIT 1),
      (SELECT tipo FROM seed_tipos ORDER BY RAND() LIMIT 1),
      ROUND(100 + RAND() * 900, 2) AS costo,
      fechaDespacho,
      DATE_ADD(fechaDespacho, INTERVAL FLOOR(1 + RAND() * 10) DAY) AS fechaEstimada,
      (SELECT estado FROM seed_estados_envio ORDER BY RAND() LIMIT 1)
  FROM (
      SELECT n,
             DATE_ADD('2025-01-01', INTERVAL FLOOR(RAND() * 270) DAY) AS fechaDespacho
      FROM seed_numeros
      WHERE n BETWEEN 1 AND 50000
  ) AS base;
  
UPDATE Envio
SET tracking = CONCAT('TRK', LPAD(id, 6, '0'))
WHERE tracking IS NULL;

-- SEGUNDO REGISTRO
  INSERT INTO Envio (tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
  SELECT
      NULL,
      (SELECT empresa FROM seed_empresas ORDER BY RAND() LIMIT 1),
      (SELECT tipo FROM seed_tipos ORDER BY RAND() LIMIT 1),
      ROUND(100 + RAND() * 900, 2) AS costo,
      fechaDespacho,
      DATE_ADD(fechaDespacho, INTERVAL FLOOR(1 + RAND() * 10) DAY) AS fechaEstimada,
      (SELECT estado FROM seed_estados_envio ORDER BY RAND() LIMIT 1)
  FROM (
      SELECT n,
             DATE_ADD('2025-01-01', INTERVAL FLOOR(RAND() * 270) DAY) AS fechaDespacho
      FROM seed_numeros
      WHERE n BETWEEN 50001 AND 100000
  ) AS base;
  
UPDATE Envio
SET tracking = CONCAT('TRK', LPAD(id, 6, '0'))
WHERE tracking IS NULL;

-- TERCER REGISTRO
  INSERT INTO Envio (tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
  SELECT
      NULL,
      (SELECT empresa FROM seed_empresas ORDER BY RAND() LIMIT 1),
      (SELECT tipo FROM seed_tipos ORDER BY RAND() LIMIT 1),
      ROUND(100 + RAND() * 900, 2) AS costo,
      fechaDespacho,
      DATE_ADD(fechaDespacho, INTERVAL FLOOR(1 + RAND() * 10) DAY) AS fechaEstimada,
      (SELECT estado FROM seed_estados_envio ORDER BY RAND() LIMIT 1)
  FROM (
      SELECT n,
             DATE_ADD('2025-01-01', INTERVAL FLOOR(RAND() * 270) DAY) AS fechaDespacho
      FROM seed_numeros
      WHERE n BETWEEN 100001 AND 150000
  ) AS base;
  
UPDATE Envio
SET tracking = CONCAT('TRK', LPAD(id, 6, '0'))
WHERE tracking IS NULL;

-- CUARTO REGISTRO
  INSERT INTO Envio (tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
  SELECT
      NULL,
      (SELECT empresa FROM seed_empresas ORDER BY RAND() LIMIT 1),
      (SELECT tipo FROM seed_tipos ORDER BY RAND() LIMIT 1),
      ROUND(100 + RAND() * 900, 2) AS costo,
      fechaDespacho,
      DATE_ADD(fechaDespacho, INTERVAL FLOOR(1 + RAND() * 10) DAY) AS fechaEstimada,
      (SELECT estado FROM seed_estados_envio ORDER BY RAND() LIMIT 1)
  FROM (
      SELECT n,
             DATE_ADD('2025-01-01', INTERVAL FLOOR(RAND() * 270) DAY) AS fechaDespacho
      FROM seed_numeros
	  WHERE n BETWEEN 150001 AND 200000
  ) AS base;
  
UPDATE Envio
SET tracking = CONCAT('TRK', LPAD(id, 6, '0'))
WHERE tracking IS NULL;

-- QUINTO REGISTRO
  INSERT INTO Envio (tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
  SELECT
      NULL,
      (SELECT empresa FROM seed_empresas ORDER BY RAND() LIMIT 1),
      (SELECT tipo FROM seed_tipos ORDER BY RAND() LIMIT 1),
      ROUND(100 + RAND() * 900, 2) AS costo,
      fechaDespacho,
      DATE_ADD(fechaDespacho, INTERVAL FLOOR(1 + RAND() * 10) DAY) AS fechaEstimada,
      (SELECT estado FROM seed_estados_envio ORDER BY RAND() LIMIT 1)
  FROM (
      SELECT n,
             DATE_ADD('2025-01-01', INTERVAL FLOOR(RAND() * 270) DAY) AS fechaDespacho
      FROM seed_numeros
      WHERE n BETWEEN 200001 AND 250000
  ) AS base;

UPDATE Envio
SET tracking = CONCAT('TRK', LPAD(id, 6, '0'))
WHERE tracking IS NULL;

-- SEXTO REGISTRO
  INSERT INTO Envio (tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
  SELECT
      NULL,
      (SELECT empresa FROM seed_empresas ORDER BY RAND() LIMIT 1),
      (SELECT tipo FROM seed_tipos ORDER BY RAND() LIMIT 1),
      ROUND(100 + RAND() * 900, 2) AS costo,
      fechaDespacho,
      DATE_ADD(fechaDespacho, INTERVAL FLOOR(1 + RAND() * 10) DAY) AS fechaEstimada,
      (SELECT estado FROM seed_estados_envio ORDER BY RAND() LIMIT 1)
  FROM (
      SELECT n,
             DATE_ADD('2025-01-01', INTERVAL FLOOR(RAND() * 270) DAY) AS fechaDespacho
      FROM seed_numeros
      WHERE n BETWEEN 250001 AND 300000
  ) AS base;

-- TABLA PEDIDO
-- Permitimos que 'numero' acepte NULL temporalmente
ALTER TABLE Pedido MODIFY numero VARCHAR(20) NULL;

-- Insertamos todos los pedidos en una sola vez
INSERT INTO Pedido (numero, fecha, clienteNombre, total, estado, envio)
SELECT
    NULL,
    DATE_ADD('2025-01-01', INTERVAL FLOOR(RAND() * 270) DAY) AS fecha,
    CONCAT('Cliente ', e.id) AS clienteNombre,
    ROUND(500 + RAND() * 5000, 2) AS total,
    (SELECT estado FROM seed_estados_pedido ORDER BY RAND() LIMIT 1),
    e.id
FROM Envio e;

-- Asignamos los números de pedido únicos
UPDATE Pedido
SET numero = CONCAT('PED', LPAD(id, 6, '0'))
WHERE numero IS NULL;

-- Volvemos a dejar la columna como obligatoria
ALTER TABLE Pedido MODIFY numero VARCHAR(20) NOT NULL UNIQUE;

-- Verificación final
SELECT COUNT(*) AS total_envios FROM Envio;
SELECT COUNT(*) AS total_pedidos FROM Pedido;
SELECT COUNT(*) AS inconsistencias FROM Pedido WHERE envio NOT IN (SELECT id FROM Envio);
SELECT COUNT(*) AS fk_huerfanas FROM Pedido WHERE envio NOT IN (SELECT id FROM Envio);
