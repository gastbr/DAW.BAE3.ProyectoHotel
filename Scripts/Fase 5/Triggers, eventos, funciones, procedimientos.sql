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
-- Al menos una función almacenada que a partir de algunos parámetros de entrada retorne un valor.
-- Al menos un evento que se realice únicamente en un intervalo de tiempo determinado o bien de forma periódica