-- Trigger: cada vez que se inserta o sea actualiza un línea de albarán en la tabla linea_albaran, se calcula el importe de la línea y se actualiza el importe total del albarán.

DELIMITER $$
DROP TRIGGER if exists hotel.albaran_calcular_importe$$
CREATE TRIGGER hotel.albaran_calcular_importe
before insert on linea_albaran
for each row
begin
set new.importe = new.cantidad * (new.precio_compra - ((new.descuento/100) * new.precio_compra) + ((new.impuesto/100) * new.precio_compra));
UPDATE albaran 
SET 
    base_imponible = base_imponible + new.cantidad * new.precio_compra,
    total_impuestos = total_impuestos + new.cantidad * ((new.impuesto / 100) * new.precio_compra),
    total_descuentos = total_descuentos + new.cantidad * ((new.descuento / 100) * new.precio_compra),
    importe_total = importe_total + new.importe
WHERE
    id = new.albaran;
end$$

DROP TRIGGER if exists hotel.albaran_actualizar_importe$$
CREATE TRIGGER hotel.albaran_actualizar_importe
before update on linea_albaran
for each row
begin
set new.importe = new.cantidad * (new.precio_compra - ((new.descuento/100) * new.precio_compra) + ((new.impuesto/100) * new.precio_compra));
UPDATE albaran 
SET 
    base_imponible = base_imponible + new.cantidad * new.precio_compra - old.cantidad * old.precio_compra,
    total_impuestos = total_impuestos + new.cantidad * ((new.impuesto / 100) * new.precio_compra) - old.cantidad * ((old.impuesto / 100) * old.precio_compra),
    total_descuentos = total_descuentos + new.cantidad * ((new.descuento / 100) * new.precio_compra) - old.cantidad * ((old.descuento / 100) * old.precio_compra),
    importe_total = importe_total + new.importe - old.importe
WHERE
    id = new.albaran;
end$$

-- Procedimiento: Devuelve los emails de todos los clientes concatenados en una cadena con un texto legible, junto con el nombre completo del cliente y la descripción del email.

DROP PROCEDURE IF EXISTS hotel.emails_clientes$$
CREATE PROCEDURE hotel.emails_clientes(OUT cadena LONGTEXT)
BEGIN
    DECLARE flag BOOLEAN DEFAULT FALSE;
    DECLARE vemail VARCHAR(50);
    DECLARE vdescripcion VARCHAR(50);
    DECLARE vcliente INT;

    DECLARE cursor1 CURSOR FOR SELECT cliente, email, descripcion FROM cliente_email;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET flag = TRUE;

    SET cadena = "";
    OPEN cursor1;

    bucle: LOOP
        FETCH cursor1 INTO vcliente, vemail, vdescripcion;
        IF flag = TRUE THEN
            LEAVE bucle;
        END IF;

        SET cadena = concat(cadena, " /// Email \'",  lower(vdescripcion), "\' del cliente ", (select concat_ws(" ", nombre, apellido1, apellido2) from cliente where id = vcliente), ": ", vemail);
    END LOOP bucle;
    CLOSE cursor1;
    set cadena = substring(cadena, 6, length(cadena));
END$$

-- Función: a partir de un código postal o nombre de localidad, devuelve el país donde se encuentre.
drop function if exists hotel.pais$$
create function hotel.pais(vlocalidad varchar(30)) returns varchar(30) deterministic
begin
	declare vpais varchar(30) default "";
    set vlocalidad = trim(vlocalidad);
    if (left(vlocalidad, 1) rlike '[0-9]') then
		set vpais = ifnull((select pais from localidad where codigo_postal = vlocalidad), "Localidad no registrada (NULL)");
	else        
		set vlocalidad = concat(upper(left(vlocalidad, 1)), lower(substring(vlocalidad, 2, length(vlocalidad))));
        set vpais = ifnull((select pais from localidad where localidad = vlocalidad), "Localidad no registrada (NULL)");
	end if;
    return vpais;
end$$

-- Una vez al mes, revisa todos los registros de pedidos, albaranes y facturas de pago y elimina todas las entradas que tengan una antigüedad mayor a 5 años.
delimiter ;
set global event_scheduler = on;

delimiter $$
drop event if exists hotel.eliminar_pedidos_antiguos $$
create event hotel.eliminar_pedidos_antiguos
on schedule every 5 second starts current_timestamp enable do
begin
	delete from pedido where timestampdiff(year, fechahora, current_timestamp()) > 5;
	delete from albaran where timestampdiff(year, fecha_albaran, current_timestamp()) > 5;
	delete from factura_pago where timestampdiff(year, fecha_factura, current_timestamp()) > 5;
end$$