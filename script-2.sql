SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE mostrar_clientes_sucursal(p_suc_codigo IN NUMBER) IS
BEGIN
  FOR cliente_info IN (
    SELECT 
      c.cli_rut,
      c.cli_nombre
    FROM cliente c
    WHERE EXISTS (
      SELECT 1
      FROM cta_corriente cc
      WHERE cc.cli_rut = c.cli_rut AND cc.suc_codigo = p_suc_codigo
    )
    UNION
    SELECT 
      c.cli_rut,
      c.cli_nombre
    FROM cliente c
    WHERE EXISTS (
      SELECT 1
      FROM prestamo_cliente pc
      WHERE pc.cli_rut = c.cli_rut AND pc.suc_codigo = p_suc_codigo
    )
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Cliente: ' || cliente_info.cli_nombre);
  END LOOP;
END mostrar_clientes_sucursal;
/


ACCEPT input_usuario NUMBER PROMPT 'Ingrese el código de la sucursal: ';

DECLARE
    v_suc_codigo sucursal.suc_codigo%TYPE;
    
BEGIN
    v_suc_codigo := &input_usuario;
    --info_sucursal(v_suc_codigo);
    mostrar_clientes_sucursal(v_suc_codigo); 
END;
/

