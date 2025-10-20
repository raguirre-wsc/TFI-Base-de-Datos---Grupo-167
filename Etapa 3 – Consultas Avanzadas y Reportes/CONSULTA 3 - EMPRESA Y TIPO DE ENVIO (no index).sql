
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