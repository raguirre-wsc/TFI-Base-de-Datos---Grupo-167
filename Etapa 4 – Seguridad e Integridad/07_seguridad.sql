-- ============================================================
--  ETAPA 4 - SEGURIDAD E INTEGRIDAD
--  Proyecto: Sistema Pedido–Envío
--  Descripción:
--   1. Creación de usuario con privilegios mínimos
--   2. Creación de vistas públicas
--   3. Pruebas de integridad (PK, FK, UNIQUE, CHECK)
--   4. Pruebas de acceso restringido
--   5. Procedimiento seguro antiinyección SQL
-- ============================================================

-- ============================================================
--  0. CONFIGURACIÓN INICIAL
-- ============================================================
DROP DATABASE IF EXISTS Pedido_Envio;
CREATE DATABASE Pedido_Envio;
USE Pedido_Envio;

-- ============================================================
--  1. CREACIÓN DE TABLAS BASE
-- ============================================================
DROP TABLE IF EXISTS Pedido;
DROP TABLE IF EXISTS Envio;

CREATE TABLE IF NOT EXISTS Envio (
id BIGINT NOT NULL,
eliminado BOOLEAN DEFAULT FALSE,
tracking VARCHAR(40) UNIQUE,
empresa ENUM('ANDREANI','OCA','CORREO_ARG'),
tipo ENUM('ESTANDAR','EXPRES'),
costo DECIMAL(10,2) CHECK (costo >= 0),
fechaDespacho DATE,
fechaEstimada DATE,
estado ENUM('EN_PREPARACION','EN_TRANSITO','ENTREGADO'),
PRIMARY KEY (id),
CHECK (fechaEstimada IS NOT NULL AND fechaDespacho IS NOT NULL AND fechaEstimada >= fechaDespacho)
);

CREATE TABLE Pedido (
    id BIGINT NOT NULL AUTO_INCREMENT,
    eliminado BOOLEAN DEFAULT FALSE,
    numero VARCHAR(20) NOT NULL UNIQUE,
    fecha DATE DEFAULT (CURRENT_DATE) NOT NULL,
    clienteNombre VARCHAR(120) NOT NULL,
    total DECIMAL(12,2) NOT NULL CHECK (total >= 0),
    estado ENUM('NUEVO','FACTURADO','ENVIADO') NOT NULL,
    envio BIGINT,
    PRIMARY KEY (id),
    FOREIGN KEY (envio) REFERENCES Envio(id)
);

-- ============================================================
--  2. CREACIÓN DE USUARIO CON PRIVILEGIOS MÍNIMOS
-- ============================================================
DROP USER IF EXISTS 'usuario_prueba'@'localhost';
CREATE USER 'usuario_prueba'@'localhost' IDENTIFIED BY 'ClaveSegura123';

GRANT SELECT, INSERT, UPDATE ON Pedido_Envio.* TO 'usuario_prueba'@'localhost';
REVOKE DELETE, DROP, ALTER ON Pedido_Envio.* FROM 'usuario_prueba'@'localhost';

SHOW GRANTS FOR 'usuario_prueba'@'localhost';

-- ============================================================
--  3. CREACIÓN DE VISTAS QUE OCULTAN INFORMACIÓN SENSIBLE
-- ============================================================
DROP VIEW IF EXISTS vista_pedidos_publica;
CREATE VIEW vista_pedidos_publica AS
SELECT 
    id AS id_pedido,
    numero,
    fecha,
    clienteNombre,
    estado,
    envio
FROM Pedido
WHERE eliminado = FALSE;

DROP VIEW IF EXISTS vista_envios_publica;
CREATE VIEW vista_envios_publica AS
SELECT 
    id AS id_envio,
    tracking,
    empresa,
    tipo,
    estado,
    fechaDespacho,
    fechaEstimada
FROM Envio
WHERE eliminado = FALSE;

-- ============================================================
--  3.1. INSERTS DE PRUEBA PARA VISTAS PÚBLICAS
-- ============================================================
-- Inserción de registros de prueba en Envio
INSERT INTO Envio (id, tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
VALUES 
(1, 'TRK-001', 'OCA', 'ESTANDAR', 450.00, '2025-10-15', '2025-10-20', 'EN_TRANSITO'),
(2, 'TRK-002', 'ANDREANI', 'EXPRES', 700.00, '2025-10-18', '2025-10-21', 'ENTREGADO'),
(3, 'TRK-003', 'CORREO_ARG', 'ESTANDAR', 300.00, '2025-10-19', '2025-10-24', 'EN_PREPARACION');

-- Inserción de registros de prueba en Pedido
INSERT INTO Pedido (numero, fecha, clienteNombre, total, estado, envio)
VALUES
('PED-010', CURDATE(), 'Cliente A', 2500.00, 'NUEVO', 1),
('PED-011', CURDATE(), 'Cliente B', 1800.00, 'FACTURADO', 2),
('PED-012', CURDATE(), 'Cliente C', 3200.00, 'ENVIADO', 3);

-- Prueba de vistas
SELECT * FROM vista_pedidos_publica;
SELECT * FROM vista_envios_publica;

-- ============================================================
--  3.2. LIMPIEZA DE DATOS DE PRUEBA (para continuar con integridad)
-- ============================================================
DELETE FROM Pedido;
DELETE FROM Envio;

-- Confirmación de limpieza
SELECT COUNT(*) AS Pedidos_restantes FROM Pedido;
SELECT COUNT(*) AS Envios_restantes FROM Envio;

-- ============================================================
--  4. PRUEBAS DE INTEGRIDAD (PK, FK, UNIQUE, CHECK)
-- ============================================================
-- PRUEBA 1: Violación de PRIMARY KEY
INSERT INTO Pedido (id, numero, clienteNombre, total, estado)
VALUES (1, 'PED-001', 'Cliente Uno', 2500.00, 'NUEVO');
-- Intento de duplicar la PK
INSERT INTO Pedido (id, numero, clienteNombre, total, estado)
VALUES (1, 'PED-002', 'Cliente Dos', 3000.00, 'FACTURADO');

-- PRUEBA 2: Violación de FOREIGN KEY
INSERT INTO Pedido (numero, fecha, clienteNombre, total, estado, envio)
VALUES ('PED-003', CURDATE(), 'Cliente Tres', 1800.00, 'ENVIADO', 9999);

-- PRUEBA 3: Violación de UNIQUE (tracking duplicado)
INSERT INTO Envio (tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
VALUES ('T001', 'OCA', 'EXPRES', 500, '2025-10-20', '2025-10-22', 'EN_TRANSITO');
INSERT INTO Envio (tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
VALUES ('T001', 'ANDREANI', 'ESTANDAR', 600, '2025-10-21', '2025-10-25', 'ENTREGADO');

-- PRUEBA 4: Violación de CHECK
INSERT INTO Envio (tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
VALUES ('T002', 'ANDREANI', 'ESTANDAR', -200, '2025-10-10', '2025-10-12', 'EN_PREPARACION');
INSERT INTO Pedido (numero, fecha, clienteNombre, total, estado)
VALUES ('PED-004', CURDATE(), 'Cliente Cuatro', -5000.00, 'NUEVO');

-- ============================================================
--  5. PRUEBAS DE ACCESO RESTRINGIDO
-- ============================================================
-- Intentos de operaciones no autorizadas (deben fallar)
DELETE FROM Pedido WHERE id = 1;
DROP TABLE Envio;
ALTER TABLE Pedido ADD COLUMN observaciones VARCHAR(255);

-- ============================================================
--  6. PROCEDIMIENTO ALMACENADO ANTIINYECCIÓN SQL
-- ============================================================
DROP PROCEDURE IF EXISTS sp_get_pedido_por_numero;
DELIMITER $$
CREATE PROCEDURE sp_get_pedido_por_numero(IN p_numero VARCHAR(50))
BEGIN
  SELECT id, numero, fecha, clienteNombre, total, estado
  FROM Pedido
  WHERE numero = p_numero AND eliminado = FALSE;
END$$
DELIMITER ;

-- Inserción de registro de prueba
INSERT INTO Pedido (id, numero, fecha, clienteNombre, total, estado, envio)
VALUES (1000, 'PED-TEST-001', CURDATE(), 'Cliente Test', 1234.56, 'NUEVO', NULL);

-- Pruebas del procedimiento
CALL sp_get_pedido_por_numero('PED-TEST-001');
CALL sp_get_pedido_por_numero("' OR '1'='1");
