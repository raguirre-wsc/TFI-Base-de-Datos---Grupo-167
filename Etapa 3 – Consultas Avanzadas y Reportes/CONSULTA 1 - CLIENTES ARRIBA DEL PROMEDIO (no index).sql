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