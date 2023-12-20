SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION productos_bancarios_usuario(rut_cliente IN NUMBER) RETURN NUMBER IS
  v_cantidad_productos NUMBER := 0;

BEGIN
    BEGIN
      -- Obtener la cantidad de cuentas corrientes del cliente
      SELECT COUNT(*) INTO v_cantidad_productos
      FROM cta_corriente
      WHERE cli_rut = rut_cliente;

      -- Sumar la cantidad de préstamos del cliente
      SELECT 
        v_cantidad_productos + COUNT(*) INTO v_cantidad_productos
      FROM prestamo_cliente
      WHERE cli_rut = rut_cliente;

    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('El rut ingresado no existe. Intenta probar con otro rut');
            v_cantidad_productos := 0;
    END;

    RETURN v_cantidad_productos;
END productos_bancarios_usuario;
/

ACCEPT rut_cliente NUMBER PROMPT 'Ingrese el RUT del cliente: ';

DECLARE
  v_rut_cliente NUMBER := &rut_cliente;
  v_cantidad_productos NUMBER;
  
BEGIN
  v_cantidad_productos := productos_bancarios_usuario(v_rut_cliente);
  
  DBMS_OUTPUT.PUT_LINE('La cantidad de productos del cliente con rut ' || v_rut_cliente || ' es de :');
  DBMS_OUTPUT.PUT_LINE(v_cantidad_productos);
END;
/


