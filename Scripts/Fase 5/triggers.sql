-- Trigger: cada vez que se inserta o sea actualiza un línea de albarán en la tabla linea_albaran, se calcula el importe de la línea y se actualiza el importe total del albarán.

DELIMITER $$
DROP TRIGGER if exists hotel.albaran_calcular_importe$$
CREATE TRIGGER hotel.albaran_calcular_importe
before insert on linea_albaran
for each row
begin
set new.importe = (new.precio_compra - ((new.descuento/100) * new.precio_compra) + ((new.impuesto/100) * new.precio_compra));
UPDATE albaran 
SET 
    base_imponible = base_imponible + new.precio_compra,
    total_impuestos = total_impuestos + ((new.impuesto / 100) * new.precio_compra),
    total_descuentos = total_descuentos + ((new.descuento / 100) * new.precio_compra),
    importe_total = importe_total + new.importe
WHERE
    id = new.albaran;
end$$

DROP TRIGGER if exists hotel.albaran_actualizar_importe$$
CREATE TRIGGER hotel.albaran_actualizar_importes
before update on linea_albaran
for each row
begin
set new.importe = (new.precio_compra - ((new.descuento/100) * new.precio_compra) + ((new.impuesto/100) * new.precio_compra));
UPDATE albaran 
SET 
    base_imponible = base_imponible + new.precio_compra - old.precio_compra,
    total_impuestos = total_impuestos + ((new.impuesto / 100) * new.precio_compra) - ((old.impuesto / 100) * old.precio_compra),
    total_descuentos = total_descuentos + ((new.descuento / 100) * new.precio_compra) - ((old.descuento / 100) * old.precio_compra),
    importe_total = importe_total + new.importe - old.importe
WHERE
    id = new.albaran;
end$$

-- Al menos un procedimiento almacenado que haga uso de cursores y del manejo de errores mediante handler

delimiter ;
select * from cliente_email;
select * from cliente;

DELIMITER $$
drop procedure if exists hotel.emails_clientes$$
create procedure hotel.emails_clientes(out cadena longtext)
begin
	declare flag boolean default false;
    declare email varchar(50);
    declare descripcion varchar(50);
    declare cliente int;
	declare cursor1 cursor for select cliente, email, descripcion from cliente_email;
    declare continue handler for not found set flag = true;
    set cadena = "";
    open cursor1;
    
    bucle: loop
		fetch cursor1 into cliente, email, descripcion;
        if flag then
			leave bucle;
		end if;
        set cadena = concat(cadena,"Nombre: ",(select concat_ws(" ", nombre, apellido1, apellido2) from hotel.cliente where id = cliente), "/ Descripcion: ", descripcion , "/ Email: ",email);
	end loop bucle;
    close cursor1;    
end$$

DROP PROCEDURE IF EXISTS hotel.emails_clientes$$

CREATE PROCEDURE hotel.emails_clientes(OUT cadena LONGTEXT)
BEGIN
    DECLARE flag BOOLEAN DEFAULT FALSE;
    DECLARE email VARCHAR(50);
    DECLARE descripcion VARCHAR(50);
    DECLARE cliente INT;

    DECLARE cursor1 CURSOR FOR SELECT cliente, email, descripcion FROM cliente_email;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET flag = TRUE;

    SET cadena = "";
    OPEN cursor1;

    bucle: LOOP
        FETCH cursor1 INTO cliente, email, descripcion;
        IF flag THEN
            LEAVE bucle;
        END IF;

        SET cadena = CONCAT(
            cadena, 
            "Nombre: ", 
            (SELECT CONCAT_WS(" ", nombre, apellido1, apellido2) FROM hotel.cliente WHERE id = cliente), 
            "/ Descripcion: ", descripcion, 
            "/ Email: ", email, 
            "; "
        );
    END LOOP bucle;

    CLOSE cursor1;
END$$

call hotel.emails_clientes(@var);
select @var;

-- Al menos una función almacenada que a partir de algunos parámetros de entrada retorne un valor.

-- Al menos un evento que se realice únicamente en un intervalo de tiempo determinado o bien de forma periódica