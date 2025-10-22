
CREATE DATABASE IF NOT EXISTS `Pedido_Envio`;

CREATE TABLE Pedido (
id BIGINT NOT NULL,
eliminado BOOLEAN DEFAULT FALSE,
numero VARCHAR(20) NOT NULL UNIQUE,
fecha DATE DEFAULT (CURRENT_DATE) NOT NULL, -- en caso de no especificar fecha, se ingresa la fecha actual por defecto y no queda nulo
clienteNombre VARCHAR(120) NOT NULL,
total DECIMAL(12,2) NOT NULL CHECK (total >= 0),
estado ENUM('NUEVO','FACTURADO','ENVIADO') NOT NULL,
envio BIGINT,
PRIMARY KEY (id),
FOREIGN KEY (envio) REFERENCES Envio(id)
);

CREATE TABLE Envio (
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
CHECK (fechaEstimada IS NOT NULL AND fechaDespacho IS NOT AND fechaEstimada >= fechaDespacho)
);

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




