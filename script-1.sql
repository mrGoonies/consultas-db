SET SERVEROUTPUT ON;
      

CREATE OR REPLACE PROCEDURE info_sucursal(p_suc_codigo sucursal.suc_codigo%TYPE) IS
    v_suc_nombre sucursal.suc_nombre%TYPE;
    v_total_clientes NUMBER;
    v_total_prestamos NUMBER;
    v_total_cuentas_corrientes NUMBER;
    
    BEGIN
        -- Nombre sucursal
        SELECT 
            suc_nombre INTO v_suc_nombre
        FROM sucursal
        WHERE suc_codigo = p_suc_codigo;
        
        -- Obtener total clientes
        SELECT 
            COUNT(*) INTO v_total_clientes
        FROM prestamo_cliente pc
        INNER JOIN cliente c ON pc.cli_rut = c.cli_rut
        WHERE pc.suc_codigo = p_suc_codigo
        GROUP BY pc.suc_codigo;
        
        -- Obtener total préstamos
        SELECT
            COUNT(*) INTO v_total_prestamos
        FROM prestamo_cliente pc
        INNER JOIN cliente c ON pc.cli_rut = c.cli_rut
        WHERE pc.suc_codigo = p_suc_codigo
        GROUP BY pc.cli_rut, pc.suc_codigo;
        
        -- Obtener total de ctas corrientes
        SELECT
            COUNT(*) INTO v_total_cuentas_corrientes
        FROM cta_corriente cc
        INNER JOIN cliente c ON cc.cli_rut = c.cli_rut
        WHERE cc.suc_codigo = p_suc_codigo
        GROUP BY cc.suc_codigo;
        
        

        -- Mostrar resultados
        DBMS_OUTPUT.PUT_LINE('Sucursal: ' || v_suc_nombre);
        DBMS_OUTPUT.PUT_LINE('Total Clientes: ' || v_total_clientes);
        DBMS_OUTPUT.PUT_LINE('Total Prestamos: ' || v_total_prestamos);
        DBMS_OUTPUT.PUT_LINE('Total CTAs Corrientes: ' || v_total_cuentas_corrientes);
        

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('La sucursal con código ' || p_suc_codigo || ' no existe.');
    END info_sucursal;
/


ACCEPT input_usuario NUMBER PROMPT 'Ingrese el código de la sucursal: ';

DECLARE
    v_suc_codigo sucursal.suc_codigo%TYPE;
    
BEGIN
    v_suc_codigo := &input_usuario;
    info_sucursal(v_suc_codigo);
    
END;
/
    



