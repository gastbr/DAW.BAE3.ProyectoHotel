-- 3 consultas de cada tipo (describirlas):
-- inner join
-- left/right join
-- group by
-- subconsultas en insert/update/delete

-- arreglar vista de histórico de precios de artículo

use hotel;

/*
Incluye una vista HISTÓRICO DE PRECIOS del artículo, con datos provenientes de los albaranes con los que se ha asociado el artículo:
fecha de compra
precio
impuesto
proveedor
albarán en el que se registró el precio

*/

-- Mostrar tabla con todos los departamentos y los nombres de sus jefes primeros
SELECT d.nombre 'Nombre del departamento', CONCAT_WS(' ', e.nombre, e.apellido1, e.apellido2) 'Nombre del primer jefe' FROM departamento d INNER JOIN empleado e ON d.jefe1 = e.id;

-- Tabla con todas las reservas, el número de habitación reservada y el nombre completo del cliente
select r.reserva "Número de reserva", r.habitacion "Habitación reservada", concat_ws(" ", c.nombre, c.apellido1, c.apellido2) "Nombre completo del cliente" from realiza_reserva r inner join cliente c on r.cliente = c.id;

select * from articulo;





