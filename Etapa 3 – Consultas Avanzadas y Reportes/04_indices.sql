
/*
-- PEDIDO
DROP INDEX idx_pedido_cliente_total ON Pedido;
DROP INDEX idx_pedido_estado_total ON Pedido;
DROP INDEX idx_pedido_estado_total_envio ON Pedido;
-- DROP INDEX idx_pedido_envio_estado ON Pedido; AL CREAR ESTE INDICE SE VINCULA A LA FK Y NO PUEDE SER BORRADO

-- ENVIO
DROP INDEX idx_envio_fechaDespacho ON Envio;
DROP INDEX idx_envio_fecha_empresa_tipo ON Envio;
*/

-- Creamos índices
-- PEDIDO
CREATE INDEX idx_pedido_cliente_total ON Pedido(clienteNombre, total);
CREATE INDEX idx_pedido_estado_total ON Pedido(estado, total);
CREATE INDEX idx_pedido_estado_total_envio ON Pedido(estado, total, envio);
CREATE INDEX idx_pedido_envio_estado ON Pedido(envio, estado);

-- ENVIO
CREATE INDEX idx_envio_fechaDespacho ON Envio(fechaDespacho);
CREATE INDEX idx_envio_fecha_empresa_tipo ON Envio(fechaDespacho, empresa, tipo, costo, fechaEstimada);