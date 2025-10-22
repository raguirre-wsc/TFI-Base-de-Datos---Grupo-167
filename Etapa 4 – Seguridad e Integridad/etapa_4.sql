                         USE Pedido_Envio;
DROP USER IF EXISTS 'usuario_prueba'@'localhost';
-- Creacion de usuario con permisos mínimos
CREATE USER 'usuario_prueba'@'localhost' IDENTIFIED BY 'ClaveSegura123';

-- Asignar de permisos minimos sobre la base de datos
GRANT SELECT, INSERT, UPDATE ON Pedido_Envio.* TO 'usuario_prueba'@'localhost';

-- Revocar permisos peligrosos (DROP, DELETE, ALTER)
REVOKE DELETE, DROP, ALTER ON Pedido_Envio.* FROM 'usuario_prueba'@'localhost';

-- Verificar privilegios asignados
SHOW GRANTS FOR 'usuario_prueba'@'localhost';

-- Creacion de vistas que oculten informacion sensible
-- Vista 1: pedidos sin mostrar total ni eliminados
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

-- Vista 2: envíos sin costos ni datos internos
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

-- Prueba de vistas
SELECT * FROM vista_pedidos_publica;
SELECT * FROM vista_envios_publica;
