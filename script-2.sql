drop table prestamo_cliente purge;
drop table cta_corriente purge;
drop table sucursal purge;
drop table cliente purge;

create table sucursal (
suc_codigo    number(8) primary key,
suc_nombre    varchar2(20),
suc_ciudad    varchar2(20));

create table cliente (
cli_rut        number primary key,
cli_nombre     varchar2(40),
cli_direccion  varchar2(40),
cli_telefono   number);

create table prestamo_cliente (
pre_numero      number primary key,
pre_monto       number,
pre_tasa        number,
cli_rut         number,
pre_fecha_alta  date,
suc_codigo      number(8));

create table cta_corriente (
cta_numero          number primary key,
cta_saldo           number,
cli_rut             number,
suc_codigo          number(8),
cta_fecha_apertura  date,
cta_fecha_cierre    date);

alter table prestamo_cliente
add(constraint fk_cli_pre foreign key (cli_rut)
    references cliente (cli_rut));

alter table prestamo_cliente
add(constraint fk_suc_pre foreign key (suc_codigo)
    references sucursal (suc_codigo));

alter table cta_corriente
add(constraint fk_cli_cta foreign key (cli_rut)
    references cliente (cli_rut));

alter table cta_corriente
add(constraint fk_suc_cta foreign key (suc_codigo)
    references sucursal (suc_codigo));

insert into sucursal values(1,'INDEPENDENCIA','RANCAGUA');
insert into sucursal values(2,'21 DE MAYO','ARICA');
insert into sucursal values(3,'OHIGGINS','CONCEPCION');
insert into sucursal values(4,'AHUMADA','SANTIAGO');
insert into sucursal values(5,'APOQUINDO','LAS CONDES');

insert into cliente values(1112,'JUAN DEDOS','LAS MANZANAS 333',712574838);
insert into cliente values(1442,'LUIS TORNILLOS','LAS UVAS 3454',901082006);
insert into cliente values(1232,'ISMAEL TORQUE','LAS SANDIAS 3980',901022007);
insert into cliente values(1044,'ROBERTO RUEDAS','LAS NARANJAS 3849',901042007);
insert into cliente values(1155,'MARCOS MARTILLO','PASAJE NUBES 2345',801092008);
insert into cliente values(1055,'MAURICIO FRENO','PASAJE TIERRA 2148',701092018);
insert into cliente values(1033,'FERNANDO BUJIA','LOS PLATANOS 345',701094028);
insert into cliente values(1333,'JOANNA RADAR','LOS MANZANOS 1745',711994078);

insert into cta_corriente values(1,5000,1112,1,to_date('10/11/2017','dd/mm/yyyy'),null);
insert into cta_corriente values(2,15000,1442,2,to_date('22/12/2017','dd/mm/yyyy'),null);
insert into cta_corriente values(3,25000,1232,3,to_date('10/01/2018','dd/mm/yyyy'),null);
insert into cta_corriente values(4,50000,1044,2,to_date('22/01/2018','dd/mm/yyyy'),null);
insert into cta_corriente values(5,60000,1055,4,to_date('22/02/2018','dd/mm/yyyy'),null);
insert into cta_corriente values(6,160000,1033,5,to_date('22/03/2018','dd/mm/yyyy'),null);

insert into prestamo_cliente values(1,1000000,15,1112,to_date('10/11/2017','dd/mm/yyyy'),1);
insert into prestamo_cliente values(2,1000000,15,1232,to_date('10/01/2018','dd/mm/yyyy'),3);
insert into prestamo_cliente values(3,1000000,15,1044,to_date('22/01/2018','dd/mm/yyyy'),2);
insert into prestamo_cliente values(4,1000000,15,1112,to_date('02/02/2018','dd/mm/yyyy'),1);
insert into prestamo_cliente values(5,1000000,15,1044,to_date('22/01/2018','dd/mm/yyyy'),2);
insert into prestamo_cliente values(6,1000000,15,1044,to_date('22/01/2018','dd/mm/yyyy'),2);
insert into prestamo_cliente values(7,1000000,15,1112,to_date('10/04/2018','dd/mm/yyyy'),1);
insert into prestamo_cliente values(8,1000000,15,1232,to_date('10/03/2018','dd/mm/yyyy'),3);
insert into prestamo_cliente values(9,1000000,15,1155,to_date('10/03/2018','dd/mm/yyyy'),5);
insert into prestamo_cliente values(10,2000000,15,1055,to_date('10/03/2018','dd/mm/yyyy'),4);
insert into prestamo_cliente values(11,1000000,15,1055,to_date('10/04/2018','dd/mm/yyyy'),4);
insert into prestamo_cliente values(12,1000000,15,1333,to_date('10/01/2018','dd/mm/yyyy'),5);
insert into prestamo_cliente values(13,1000000,15,1333,to_date('10/03/2018','dd/mm/yyyy'),5);
insert into prestamo_cliente values(14,1000000,10,1333,to_date('10/05/2018','dd/mm/yyyy'),5);

commit;


SET SERVEROUTPUT ON;


CREATE OR REPLACE PROCEDURE mostrar_clientes_sucursal(p_suc_codigo IN NUMBER) IS
BEGIN
  FOR cte IN (SELECT DISTINCT c.cli_nombre
              FROM cliente c
              WHERE EXISTS (SELECT 1 FROM cta_corriente cc WHERE cc.cli_rut = c.cli_rut AND cc.suc_codigo = p_suc_codigo)
                 OR EXISTS (SELECT 1 FROM prestamo_cliente pc WHERE pc.cli_rut = c.cli_rut AND pc.suc_codigo = p_suc_codigo))
  LOOP
    DBMS_OUTPUT.PUT_LINE('Cliente: ' || cte.cli_nombre);
  END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
            -- Mensaje de excepción
            DBMS_OUTPUT.PUT_LINE('La sucursal con código ' || p_suc_codigo || ' no existe.');

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



