use hotel;

-- Mostrar tabla con todos los departamentos y los nombres de sus jefes primeros (INNER JOIN)
SELECT 
    d.nombre 'Nombre del departamento',
    CONCAT_WS(' ', e.nombre, e.apellido1, e.apellido2) 'Nombre del primer jefe'
FROM
    departamento d
        INNER JOIN
    empleado e ON d.jefe1 = e.id;

-- Tabla con todas las reservas, el número de habitación reservada y el nombre completo del cliente (INNER JOIN)
SELECT 
    r.reserva 'Número de reserva',
    r.habitacion 'Habitación reservada',
    CONCAT_WS(' ', c.nombre, c.apellido1, c.apellido2) 'Nombre completo del cliente'
FROM
    realiza_reserva r
        INNER JOIN
    cliente c ON r.cliente = c.id;

-- Tabla con la cantidad de proveedores registrados por país (INNER JOIN, GROUP BY)
SELECT 
    COUNT(p.id) 'Número de proveedores', pais
FROM
    proveedor p
        INNER JOIN
    localidad l ON p.localidad = l.localidad
GROUP BY Pais;

-- Tabla con todas las facturas y los albaranes asociados (INNER JOIN, GROUP BY)
SELECT 
    f.Numero_externo 'Nº Factura',
    GROUP_CONCAT(a.numero_externo
        SEPARATOR ', ') 'Albaranes'
FROM
    albaran a
        INNER JOIN
    factura_pago f ON a.factura = f.id
GROUP BY f.numero_externo;

-- Tabla con todos los empleados y el nombre de su superior. Incluye también los empleados sin superior (LEFT JOIN).
SELECT 
    CONCAT_WS(' ', e.nombre, e.apellido1, e.apellido2) 'Nombre completo empleado',
    CONCAT_WS(' ', j.nombre, j.apellido1, j.apellido2) 'Nombre completo superior'
FROM
    empleado e
        LEFT JOIN
    empleado j ON e.superior = j.id;

-- Tabla con todos los proveedores y la suma total de los importes de los albaranes entregados. Incluye los proveedores sin albarán asociado. (RIGHT JOIN, GROUP BY)
SELECT 
    p.razon_social 'Razón social del proveedor',
    SUM(a.importe_total) 'Importe total de albaranes'
FROM
    ALBARAN a
        RIGHT JOIN
    proveedor p ON a.proveedor = p.id
GROUP BY p.razon_social;

-- Tabla con todas las habitaciones y las reservas a las que están asociadas, junto con el tipo de habitación, el número de reserva y el nombre del cliente (LEFT JOIN). Incluye las habitaciones sin reserva.
SELECT 
    h.id 'Nº Habitación',
    h.tipo,
    r.reserva 'Nº Reserva',
    CONCAT_WS(' ', c.nombre, c.apellido1, c.apellido2) 'Nombre completo cliente'
FROM
    habitacion h
        LEFT JOIN
    realiza_reserva r ON r.habitacion = h.id
        LEFT JOIN
    cliente c ON c.id = r.cliente;
    
-- SUBCONSULTAS:

-- Selecciona la fecha y el número de la factura correspondiente de todas las reservas realizadas por clientes cuyo apellido comience por la letra P.
SELECT 
    fecha, factura
FROM
    reserva
WHERE
    id = (SELECT 
            reserva
        FROM
            realiza_reserva
        WHERE
            cliente = (SELECT 
                    id
                FROM
                    cliente
                WHERE
                    apellido1 LIKE 'P%'));
                    
-- Selecciona los nombres completos, los puestos y el número de la seguridad social de todos los empleados cuyo superior tenga tenga la cadena "carmen" en su nombre.
SELECT 
    concat_ws(" ", nombre, apellido1, apellido2) "Nombre completo", puesto, seg_social
FROM
    empleado
WHERE
    superior = (SELECT 
            id
        FROM
            empleado
        WHERE
            nombre LIKE '%carmen%');

-- Selecciona todos los empleados (con id, nombre completo, domicilio y localidad) que vivan en la provincia de Las Palmas de Gran Canaria,
SELECT 
    id 'ID empleado',
    CONCAT_WS(' ', nombre, apellido1, apellido2) 'Nombre completo',
    domicilio,
    localidad
FROM
    empleado
WHERE
    localidad IN (SELECT 
            localidad
        FROM
            localidad
        WHERE
            provincia LIKE '%las palmas%');

-- CONSULTAS EN INSERT, DELETE O UPDATE:
-- Inserta una nueva línea al albarán nº 4, con un producto que contenga en su nombre la cadena "ordenador" y con el precio 779.99€. Los valores de impuestos y descuentos se dejan en su valor por defecto, que es 0. La cantidad es 1 por defecto y el importe final se actualiza solo con un trigger.
insert into linea_albaran (Precio_compra, Albaran, Articulo) 
values 
  (
    '779.99', 
    '4', 
    (
      select 
        id 
      from 
        articulo 
      where 
        nombre_articulo like '%ordenador%'
    )
  );

-- Elimina de la tabla proveedor todos los proveedores que se encuentren en una localidad situada en el país Reino Unido.
DELETE FROM proveedor 
WHERE
    localidad IN (SELECT 
        localidad
    FROM
        localidad
    
    WHERE
        pais = 'Reino Unido');
        

-- Actualiza a 44 el prefijo telefónico de todos los proveedores que se encuentren en una ciudad que se encuentre en el país Reino Unido.
UPDATE proveedor_telefono 
SET 
    prefijo = '44'
WHERE
    proveedor IN (SELECT 
            id
        FROM
            proveedor
        WHERE
            localidad IN (SELECT 
                    localidad
                FROM
                    localidad
                WHERE
                    pais = 'Reino Unido'));

-- Vista histórico de precios de artículos
SELECT 
    *
FROM
    hotel.historico_precios_articulos;