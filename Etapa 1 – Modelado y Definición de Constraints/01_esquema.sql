
CREATE DATABASE IF NOT EXISTS `Pedido_Envio`;

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

CREATE TABLE IF NOT EXISTS Pedido (
id BIGINT NOT NULL AUTO_INCREMENT,
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






