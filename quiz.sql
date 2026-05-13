use cleaner;

show tables;

describe pago;

select * from pago;
select * from cliente;
select  distinct forma_pago   

DELIMITER //
CREATE PROCEDURE SP_AUDITORIA_JUAN( 
	IN p_mensaje VARCHAR (100)
    )
    BEGIN 
    INSERT INTO LOGS (MENSAJE)
    VALUES (p_mensaje);
    END //
    DELIMITER //
CREATE PROCEDURE SP_INSERTAR_PAGO
(
    IN p_id_transaccion VARCHAR(50),
    IN p_codigo_cliente INT,
    IN p_forma_pago VARCHAR(50),
    IN p_fecha_pago DATE,
    IN p_total DECIMAL(10,2)
)
BEGIN

    DECLARE v_existe_id_tran INT;

    SELECT COUNT(*)
    INTO v_existe_id_tran
    FROM PAGO
    WHERE ID_TRANSACCION = p_id_transaccion;

    IF v_existe_id_tran = 0 THEN

        INSERT INTO pago
        (id_transaccion,codigo_cliente,forma_pago,fecha_pago,total)
        VALUES
        (p_id_transaccion,p_codigo_cliente,p_forma_pago,p_fecha_pago,p_total);
        CALL AUDITORIA_JUAN('Ejecutado desde juan');
        
	ELSE 
    CALL AUDITORIA_JUAN('Transaccion duplicada - no insertada')
    

    END IF;

END ;

DELIMITER ;




DROP PROCEDURE SP_INSERTAR_PAGO;

/************************JOB************************/

CREATE TABLE LOGS(
    
    ID INT AUTO_INCREMENT PRIMARY KEY,
    
    MENSAJE VARCHAR(100),
    
    FECHA TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    
);



CREATE EVENT REVISION_JUAN
ON SCHEDULE EVERY 1 MINUTE

DO

CALL AUDITORIA_JUAN('Ejecutado desde evento');
    CREATE EVENT REVISION_JUAN
ON SCHEDULE EVERY 1 MINUTE

    

SHOW VARIABLES LIKE 'EVENT_SCHEDULER';

SHOW EVENTS;

SELECT * FROM LOGS;

SET GLOBAL EVENT_SCHEDULER = ON;


SELECT * FROM LOGS;

ALTER EVENT REVISION_JUAN DISABLE; /* LO DETENGO */

ALTER EVENT REVISION_JUAN ENABLE; /* LO HABILITO */

DROP EVENT REVISION_JUAN; /* LO ELIMINO */


