USE tp_pedidoenvio;

-- ==========================================================
-- PROCEDIMIENTO: sp_actualizar_pedido_envio
-- Etapa 5 - Transacciones y manejo de deadlock
-- ==========================================================
USE tp_pedidoenvio;

-- ==========================================================
-- PROCEDIMIENTO: sp_actualizar_pedido_envio
-- Etapa 5 - Transacciones y manejo de deadlock y lock wait timeout
-- ==========================================================
DROP PROCEDURE IF EXISTS sp_actualizar_pedido_envio;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_pedido_envio(
    IN p_idPedido BIGINT,
    IN p_estadoPedido ENUM('NUEVO','FACTURADO','ENVIADO'),
    IN p_estadoEnvio ENUM('EN_PREPARACION','EN_TRANSITO','ENTREGADO')
)
BEGIN
    DECLARE retry_count INT DEFAULT 0;
    DECLARE deadlock_occurred BOOLEAN DEFAULT TRUE;

    -- Bucle para reintentos
    WHILE deadlock_occurred AND retry_count < 2 DO
        BEGIN
            DECLARE EXIT HANDLER FOR 1213, 1205 -- deadlock o lock wait timeout
            BEGIN
                SET deadlock_occurred = TRUE;
                SET retry_count = retry_count + 1;
                SELECT CONCAT('Deadlock/Lock timeout detectado. Reintento ', retry_count) AS mensaje;
                ROLLBACK;
                DO SLEEP(1); -- backoff breve
            END;

            -- Antes de iniciar la transacción
            SELECT 'Intentando ejecutar transacción...' AS mensaje;

            -- Si no hay deadlock, procedemos
            SET deadlock_occurred = FALSE;

            START TRANSACTION;

            -- Actualizamos Pedido
            UPDATE Pedido 
            SET estado = p_estadoPedido
            WHERE id = p_idPedido;

            -- Actualizamos Envio relacionado
            UPDATE Envio 
            SET estado = p_estadoEnvio
            WHERE id = (SELECT envio FROM Pedido WHERE id = p_idPedido);

            COMMIT;

            -- Mensaje al finalizar exitosamente
            SELECT 'Transacción completada exitosamente' AS mensaje;

        END;
    END WHILE;

    -- Si después de 2 reintentos sigue fallando
    IF deadlock_occurred THEN
        SELECT 'No se pudo completar la transacción después de 2 reintentos' AS mensaje;
    END IF;

END$$

DELIMITER ;






