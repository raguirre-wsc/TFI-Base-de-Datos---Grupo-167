--REALIZAMOS TEST DE INSERCIÓN PARA CORROBORAR LAS RESTRICCIONES DE LAS TABLAS

-- INSERCION VALIDA X1
INSERT INTO Envio (id, tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
VALUES (1, 'TRK-000000001', 'OCA', 'ESTANDAR', 1200.00, '2025-10-09', '2025-10-14', 'EN_PREPARACION');

INSERT INTO Pedido (numero, clienteNombre, total, estado, envio)
VALUES ('PED-000000001', 'Alejandro Baez', 4500.00, 'NUEVO', 1);


-- INSERCION VALIDA X2
INSERT INTO Envio (id, tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
VALUES (2, 'TRK-000000002', 'ANDREANI', 'EXPRES', 2500.50, '2025-10-10', '2025-10-11', 'EN_TRANSITO');

INSERT INTO Pedido (numero, clienteNombre, total, estado, envio)
VALUES ('PED-000000002', 'Lucía Torres', 8900.00, 'ENVIADO', 2);


-- INSERCION INVALIDA X1 - INCUMPLE UNIQUE
INSERT INTO Envio (id, tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
VALUES (3, 'TRK-000000002', 'CORREO_ARG', 'ESTANDAR', 1500.00, '2025-10-12', '2025-10-17', 'EN_PREPARACION');


-- INSERCION INVALIDA X2 - INCUMPLE LA FOREGIN KEY
INSERT INTO Pedido (numero, clienteNombre, total, estado, envio)
VALUES ('PED-000000003', 'Sofia Diaz', 3200.00, 'FACTURADO', 999);