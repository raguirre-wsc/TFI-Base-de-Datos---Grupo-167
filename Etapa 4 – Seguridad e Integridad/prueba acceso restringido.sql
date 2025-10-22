DELETE FROM pedido WHERE id = 1;

DROP TABLE envio;

ALTER TABLE Pedido ADD COLUMN observaciones VARCHAR(255);