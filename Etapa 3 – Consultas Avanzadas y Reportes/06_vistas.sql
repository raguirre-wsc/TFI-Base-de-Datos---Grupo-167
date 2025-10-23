CREATE VIEW IF NOT EXISTS vista_situacion_pedidos AS
SELECT 
    p.numero AS numero_pedido,
    p.fecha AS fecha_pedido,
    p.estado AS estado_pedido,
    e.empresa,
    e.tipo,
    e.estado AS estado_envio,
    e.fechaDespacho,
    e.fechaEstimada,
    DATEDIFF(e.fechaEstimada, e.fechaDespacho) AS dias_espera
FROM Pedido p
JOIN Envio e ON p.envio = e.id;

SELECT * FROM vista_situacion_pedidos;