DELETE FROM Envio;

INSERT INTO Envio (id, tracking, empresa, tipo, costo, fechaDespacho, fechaEstimada, estado)
WITH base AS (
    SELECT 
        p.envio AS id,
        CONCAT('TRK-', LPAD(id, 9, '0')) AS tracking,
        DATE_ADD(p.fecha, INTERVAL 1 DAY) AS fechaDespacho,
        ELT(FLOOR(1 + RAND()*3), 'ANDREANI','OCA','CORREO_ARG') AS empresa,
        ELT(FLOOR(1 + RAND()*2), 'ESTANDAR','EXPRES') AS tipo,
        ROUND(p.total * 0.001 + RAND() * 5000, 2) AS costo,
        ELT(FLOOR(1 + RAND()*3), 'EN_PREPARACION','EN_TRANSITO','ENTREGADO') AS estado
    FROM Pedido p
)
SELECT 
    id,
    tracking,
    empresa,
    tipo,
    costo,
    fechaDespacho,
    DATE_ADD(fechaDespacho, INTERVAL 1 + (FLOOR(RAND()*7)) DAY) AS fechaEstimada,
    estado
FROM base;


