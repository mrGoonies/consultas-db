SET SERVEROUTPUT ON;


CREATE OR REPLACE FUNCTION monto_total_prestamos(rut_cliente IN NUMBER) RETURN NUMBER IS
  v_monto_total NUMBER := 0;
  v_cliente_nombre VARCHAR2(40);

BEGIN
    -- Obtener el nombre del cliente
    SELECT cli_nombre INTO v_cliente_nombre
    FROM cliente
    WHERE cli_rut = rut_cliente;

    -- Obtener el monto total de los préstamos
    SELECT 
        NVL(SUM(pres.pre_monto), 0) INTO v_monto_total
    FROM cliente cl
    INNER JOIN prestamo_cliente pres ON cl.cli_rut = pres.cli_rut
    WHERE pres.cli_rut = rut_cliente
    GROUP BY pres.cli_rut;


    -- Mostrar el resultado
    DBMS_OUTPUT.PUT_LINE('El cliente: ' || v_cliente_nombre || ' debe en total $' || v_monto_total || ' en préstamos.');
    

    
    RETURN v_monto_total;
END monto_total_prestamos;
/

ACCEPT rut_cliente NUMBER PROMPT 'Ingrese el RUT del cliente: ';

DECLARE
  v_rut_cliente NUMBER := &rut_cliente; 
  v_monto_total NUMBER;
BEGIN
  v_monto_total := monto_total_prestamos(v_rut_cliente);
END;



