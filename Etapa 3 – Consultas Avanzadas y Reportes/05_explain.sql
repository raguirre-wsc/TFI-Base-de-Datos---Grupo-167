-- EXPLAIN ANALYZE DE CONSULTAS UTILIZANDO IGNORE INDEX

/*
CONSULTA 1 - CLIENTES ARRIBA DEL PROMEDIO (with index)
*/
EXPLAIN ANALYZE
SELECT 
    clienteNombre,
    COUNT(*) AS cantidad_pedidos,
    ROUND(AVG(total), 2) AS total_promedio,
    ROUND(SUM(total), 2) AS total_compras
FROM Pedido 
IGNORE INDEX (
    PRIMARY, 
    numero,
	idx_pedido_cliente_total
	)
GROUP BY clienteNombre
HAVING AVG(total) > (SELECT AVG(total) FROM Pedido)
ORDER BY total_promedio DESC
LIMIT 10;

/*
CONSULTA 2 - ESTADO DE PEDIDOS (with index)
Resume los pedidos por estado, mostrando cantidad, porcentaje sobre el total de
pedidos e importe total de cada estado.
*/
EXPLAIN ANALYZE
SELECT 
    estado,
    COUNT(*) AS cantidad,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM Pedido), 2) AS porcentaje,
    SUM(total) AS total_pedidos
FROM Pedido 
IGNORE INDEX (
    PRIMARY, 
    numero, 
	idx_pedido_estado_total
)
GROUP BY estado
ORDER BY porcentaje DESC;

/*
CONSULTA 3 - EMPRESA Y TIPO DE ENVIO (with index)
Agrupa los envíos por empresa y tipo, indicando cantidad, costo promedio y
tiempo promedio de entrega.
*/
EXPLAIN ANALYZE
SELECT 
    e.empresa AS empresa,
    e.tipo AS tipo_envio,
    COUNT(*) AS cantidad_envios,
    ROUND(AVG(e.costo), 2) AS costo_promedio,
    ROUND(AVG(DATEDIFF(e.fechaEstimada, e.fechaDespacho)), 1) AS tiempo_promedio_dias
FROM Envio e 
IGNORE INDEX (
    PRIMARY, 
    tracking, 
	idx_envio_fecha_empresa_tipo 
)
JOIN Pedido p 
IGNORE INDEX (
    PRIMARY, 
    numero, 
	idx_pedido_envio_estado 
)
ON p.envio = e.id
WHERE e.fechaDespacho BETWEEN '2025-01-01' AND '2025-12-31'
  AND p.estado = 'ENVIADO'
GROUP BY e.empresa, e.tipo
ORDER BY e.empresa

/*
CONSULTA 4 - ENVIOS POR MES (with index)
Analiza pedidos mensuales altos mayores a un desvio estandar de la media,
mostrando cantidad, costo y tiempo promedio.
*/
EXPLAIN ANALYZE
WITH estadisticos AS (
    SELECT 
        AVG(total) AS pedido_promedio,
        STD(total) AS pedido_desvio_estandar
    FROM Pedido
)
SELECT 
    DATE_FORMAT(e.fechaDespacho, '%Y-%m') AS mes,
    COUNT(*) AS cantidad_envios,
    ROUND(AVG(e.costo), 2) AS costo_promedio,
    ROUND(AVG(DATEDIFF(e.fechaEstimada, e.fechaDespacho)), 1) AS tiempo_promedio_dias
FROM Envio e 
IGNORE INDEX (
    PRIMARY, 
    tracking, 
	idx_envio_fechaDespacho 
)
JOIN Pedido p 
IGNORE INDEX (
    PRIMARY, 
    numero, 
	idx_pedido_estado_total_envio 
)
ON p.envio = e.id
JOIN estadisticos s
WHERE e.fechaDespacho BETWEEN '2025-01-01' AND '2025-12-31'
  AND p.estado = 'ENVIADO'
  AND p.total > (pedido_promedio + pedido_desvio_estandar)
GROUP BY mes
ORDER BY mes;


-- EXPLAIN ANALYZE DE CONSULTAS UTILIZANDO IGNORE INDEX
/*
CONSULTA 1 - CLIENTES ARRIBA DEL PROMEDIO (NO index)
*/
EXPLAIN ANALYZE
SELECT 
    clienteNombre,
    COUNT(*) AS cantidad_pedidos,
    ROUND(AVG(total), 2) AS total_promedio,
    ROUND(SUM(total), 2) AS total_compras
FROM Pedido 
IGNORE INDEX (
    PRIMARY, 
    numero,
	idx_pedido_cliente_total
	)
GROUP BY clienteNombre
HAVING AVG(total) > (SELECT AVG(total) FROM Pedido)
ORDER BY total_promedio DESC
LIMIT 10;

/*
CONSULTA 2 - ESTADO DE PEDIDOS (NO index)
Resume los pedidos por estado, mostrando cantidad, porcentaje sobre el total de
pedidos e importe total de cada estado.
*/
EXPLAIN ANALYZE
SELECT 
    estado,
    COUNT(*) AS cantidad,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM Pedido), 2) AS porcentaje,
    SUM(total) AS total_pedidos
FROM Pedido 
IGNORE INDEX (
    PRIMARY, 
    numero, 
	idx_pedido_estado_total
)
GROUP BY estado
ORDER BY porcentaje DESC;

/*
CONSULTA 3 - EMPRESA Y TIPO DE ENVIO (NO index)
Agrupa los envíos por empresa y tipo, indicando cantidad, costo promedio y
tiempo promedio de entrega.
*/
EXPLAIN ANALYZE
SELECT 
    e.empresa AS empresa,
    e.tipo AS tipo_envio,
    COUNT(*) AS cantidad_envios,
    ROUND(AVG(e.costo), 2) AS costo_promedio,
    ROUND(AVG(DATEDIFF(e.fechaEstimada, e.fechaDespacho)), 1) AS tiempo_promedio_dias
FROM Envio e 
IGNORE INDEX (
    PRIMARY, 
    tracking, 
	idx_envio_fecha_empresa_tipo 
)
JOIN Pedido p 
IGNORE INDEX (
    PRIMARY, 
    numero, 
	idx_pedido_envio_estado 
)
ON p.envio = e.id
WHERE e.fechaDespacho BETWEEN '2025-01-01' AND '2025-12-31'
  AND p.estado = 'ENVIADO'
GROUP BY e.empresa, e.tipo
ORDER BY e.empresa

/*
CONSULTA 4 - ENVIOS POR MES (NO index)
Analiza pedidos mensuales altos mayores a un desvio estandar de la media,
mostrando cantidad, costo y tiempo promedio.
*/
EXPLAIN ANALYZE
WITH estadisticos AS (
    SELECT 
        AVG(total) AS pedido_promedio,
        STD(total) AS pedido_desvio_estandar
    FROM Pedido
)
SELECT 
    DATE_FORMAT(e.fechaDespacho, '%Y-%m') AS mes,
    COUNT(*) AS cantidad_envios,
    ROUND(AVG(e.costo), 2) AS costo_promedio,
    ROUND(AVG(DATEDIFF(e.fechaEstimada, e.fechaDespacho)), 1) AS tiempo_promedio_dias
FROM Envio e 
IGNORE INDEX (
    PRIMARY, 
    tracking, 
	idx_envio_fechaDespacho 
)
JOIN Pedido p 
IGNORE INDEX (
    PRIMARY, 
    numero, 
	idx_pedido_estado_total_envio 
)
ON p.envio = e.id
JOIN estadisticos s
WHERE e.fechaDespacho BETWEEN '2025-01-01' AND '2025-12-31'
  AND p.estado = 'ENVIADO'
  AND p.total > (pedido_promedio + pedido_desvio_estandar)
GROUP BY mes
ORDER BY mes;