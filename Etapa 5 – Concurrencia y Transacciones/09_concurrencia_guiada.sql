USE tp_pedidoenvio;

/*
Simulación de deadlock entre Pedido y Envio
*/

-- SESIÓN 1
USE tp_pedidoenvio;
START TRANSACTION;

-- Bloquea el Pedido 1
UPDATE Pedido 
SET estado = 'FACTURADO'
WHERE id = 1;

-- (Se mantiene la transacción abierta sin COMMIT)

-- SESIÓN 2
USE tp_pedidoenvio;
START TRANSACTION;

-- Bloquea el Envio 2 (relacionado al Pedido 1)
UPDATE Envio 
SET estado = 'EN_TRANSITO'
WHERE id = 2;

-- (Mantener transacción abierta sin COMMIT)

/*
-- Ahora generamos el deadlock
*/
-- SESIÓN 1 intenta actualizar el Envio bloqueado por la Sesión 2
UPDATE Envio 
SET estado = 'ENTREGADO'
WHERE id = 2;

-- SESIÓN 2 intenta actualizar el Pedido bloqueado por la Sesión 1
UPDATE Pedido 
SET estado = 'ENVIADO'
WHERE id = 1;

-- Resultado esperado en una de las sesiones:
-- ERROR 1213 (40001): Deadlock found when trying to get lock; try restarting transaction.

-- Limpieza
ROLLBACK;  -- en ambas sesiones para liberar bloqueos

/*
-- PRUEBA 2: Comparación de niveles de aislamiento
*/
/*
Objetivo:
Observar diferencias entre READ COMMITTED y REPEATABLE READ
mediante una lectura no repetible sobre la tabla Pedido.
*/

-- SESIÓN 1
USE tp_pedidoenvio;

-- Configuramos nivel de aislamiento: READ COMMITTED
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;

-- Leemos el estado actual del Pedido 1
SELECT id, estado FROM Pedido WHERE id = 1;

-- (No hacemos COMMIT todavía; dejamos la transacción abierta)

-- SESIÓN 2
USE tp_pedidoenvio;
START TRANSACTION;

-- Actualizamos el estado del mismo Pedido
UPDATE Pedido SET estado = 'ENVIADO' WHERE id = 1;
COMMIT;

-- SESIÓN 1 (vuelve a leer sin cerrar transacción)
SELECT id, estado FROM Pedido WHERE id = 1;

/*
RESULTADO ESPERADO:
Bajo READ COMMITTED, la segunda lectura muestra el nuevo valor 'ENVIADO',
porque el nivel permite ver los cambios ya confirmados por otra transacción.
*/

ROLLBACK; -- cerrar sesión 1

/*
-- Ahora repetimos el mismo experimento con REPEATABLE READ
*/
-- SESIÓN 1
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

-- Leemos el estado actual del Pedido 1
SELECT id, estado FROM Pedido WHERE id = 1;

-- SESIÓN 2 (en otra conexión)
START TRANSACTION;
UPDATE Pedido SET estado = 'FACTURADO' WHERE id = 1;
COMMIT;

-- SESIÓN 1 vuelve a leer el mismo registro
SELECT id, estado FROM Pedido WHERE id = 1;

/*
RESULTADO ESPERADO: 
Bajo REPEATABLE READ, la segunda lectura muestra el mismo valor original,
aunque otra transacción lo haya cambiado. 
MySQL mantiene una "vista consistente" dentro de la misma transacción. 
*/

ROLLBACK; -- cerrar sesión 1


