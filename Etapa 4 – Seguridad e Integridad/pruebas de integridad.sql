USE Pedido_Envio

-- PRUEBAS DE INTEGRIDAD

-- PRUEBA 1 - Violacion de PK
-- Insercion de pedido nuevo
INSERT INTO Pedido (id, numero, clienteNombre, total, estado)
VALUES (1, 'PED-001', 'Cliente Uno', 2500.00, 'NUEVO');

SELECT * FROM pedido;

-- Intento de duplicar la PK
INSERT INTO Pedido (id, numero, clienteNombre, total, estado)
VALUES (1, 'PED-002', 'Cliente Dos', 3000.00, 'FACTURADO');

-- PRUEBA 2 - Violacion de FK
-- Intento de asociar un pedido con un envio inexistente
INSERT INTO Pedido (id, numero, fecha, clienteNombre, total, estado, envio)
VALUES (2, 'PED-003', CURDATE(), 'Cliente Tres', 1800.00, 'ENVIADO', 9999);

-- PRUEBA 3: Violación de UNIQUE (tracking duplicado)
-- Inserción válida
INSERT INTO Envio (tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
VALUES ('T001', 'OCA', 'EXPRES', 500, '2025-10-20', '2025-10-22', 'EN_TRANSITO');

SELECT * FROM envio;

-- Intento de duplicar tracking
INSERT INTO Envio (tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
VALUES ('T001', 'ANDREANI', 'ESTANDAR', 600, '2025-10-21', '2025-10-25', 'ENTREGADO');

-- PRUEBA 4: ViolaciOn de CHECK (costo negativo)
-- Violación de CHECK en Envio
INSERT INTO Envio (tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
VALUES ('T002', 'ANDREANI', 'ESTANDAR', -200, '2025-10-10', '2025-10-12', 'EN_PREPARACION');

-- Violación de CHECK en Pedido
INSERT INTO Pedido (id, numero, fecha, clienteNombre, total, estado)
VALUES (3, 'PED-004', CURDATE(), 'Cliente Cuatro', -5000.00, 'NUEVO');
