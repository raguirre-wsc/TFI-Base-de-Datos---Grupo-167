USE Pedido_envio;

-- Registro de prueba en Pedido (si no existe)
INSERT INTO Pedido (id, numero, fecha, clienteNombre, total, estado, envio)
VALUES (1000, 'PED-TEST-001', CURDATE(), 'Cliente Test', 1234.56, 'NUEVO', NULL);

-- Procedimiento almacenado seguro (sin SQL dinámico)
DROP PROCEDURE IF EXISTS sp_get_pedido_por_numero;
DELIMITER $$
CREATE PROCEDURE sp_get_pedido_por_numero(IN p_numero VARCHAR(50))
BEGIN
  SELECT id, numero, fecha, clienteNombre, total, estado
  FROM Pedido
  WHERE numero = p_numero AND eliminado = FALSE;
END$$
DELIMITER ;