-- 3 consultas de cada tipo (describirlas):
-- inner join
-- left/right join
-- group by
-- subconsultas en insert/update/delete

-- arreglar vista de histórico de precios de artículo

-- Mostrar tabla con todos los departamentos y los nombres de sus jefes primeros
SELECT 
    d.nombre 'Nombre del departamento',
    CONCAT_WS(' ', e.nombre, e.apellido1, e.apellido2) 'Nombre del primer jefe'
FROM
    departamento d
        INNER JOIN
    empleado e ON d.jefe1 = e.id;

