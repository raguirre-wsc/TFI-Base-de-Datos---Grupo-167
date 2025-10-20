EXPLAIN ANALYZE
SELECT 
    estado,
    COUNT(*) AS cantidad,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM Pedido), 2) AS porcentaje,
    SUM(total) AS total_pedidos
FROM Pedido 
FORCE INDEX (
    PRIMARY, 
    numero, 
	idx_pedido_estado_total
)
GROUP BY estado
ORDER BY porcentaje DESC;