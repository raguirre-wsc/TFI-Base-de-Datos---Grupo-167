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