use hotel;
        
INSERT INTO localidad (Localidad, Codigo_postal, Provincia, Pais) 
VALUES ('Madrid', '28001', 'Madrid', 'España'),
       ('Barcelona', '08001', 'Barcelona', 'España'),
       ('Sevilla', '41001', 'Sevilla', 'España'),
       ('París', '64850', 'París', 'Francia'),
       ('Puerto del Rosario', '64850', 'Las Palmas de Gran Canaria', 'España'),
       ('Agaete', '64850', 'Las Palmas de Gran Canaria', 'España'),
       ('Ceuta', '64850', 'Ceuta', 'España'),
       ('Berlín', '64850', 'Berlín', 'Alemania'),
       ('Valladolid', '64850', 'Valladolid', 'España'),
       ('Alicante', '64850', 'Alicante', 'España'),
       ('La Coruña', '64850', 'La Coruña', 'España'),
       ('Murcia', '64850', 'Murcia', 'España'),
       ('Londres', '64850', 'Londres', 'Reino Unido'),
       ('Pamplona', '64850', 'Navarra', 'España');
        
INSERT INTO empleado 
    (Nombre, Apellido1, Apellido2, NIF_NIE, NIE_Antiguo, Seg_Social, Domicilio, Localidad, Puesto, Superior, Departamento) 
VALUES 
	('Carmen', 'Flores', 'Gonzalez', '88990011L', 'O8899001L', 'SS8899001122', 'Calle Mar 404', 'Murcia', 'Directora', NULL, NULL),
    ('Miguel', 'Santos', 'Lopez', '90112233M', 'N9011223M', 'SS9011223344', 'Avenida Rio 505', 'Pamplona', 'Secretario', NULL, NULL),
    ('Juan', 'Perez', 'Gomez', '12345678A', 'X1234567A', 'SS1234567890', 'Calle Falsa 123', 'Madrid', 'Recepcionista', NULL, NULL),
    ('Maria', 'Lopez', 'Martinez', '87654321B', 'Y8765432B', 'SS0987654321', 'Avenida Siempre Viva 456', 'Barcelona', 'Camarera', NULL, NULL),
    ('Carlos', 'Garcia', 'Rodriguez', '11223344C', 'Z1122334C', 'SS1122334455', 'Plaza Mayor 789', 'Sevilla', 'Administrador', NULL, NULL),
    ('Ana', 'Hernandez', 'Ruiz', '33445566D', 'W3344556D', 'SS3344556677', 'Calle Luna 12', 'París', 'Contable', NULL, NULL),
    ('Jose', 'Martinez', 'Lopez', '55667788E', 'V5566778E', 'SS5566778899', 'Avenida Sol 34', 'Puerto del Rosario', 'Ingeniero', NULL, NULL),
    ('Laura', 'Gomez', 'Diaz', '77889900F', 'U7788990F', 'SS7788990011', 'Plaza Estrella 56', 'Agaete', 'Diseñadora', NULL, NULL),
    ('Luis', 'Gonzalez', 'Fernandez', '99001122G', 'T9900112G', 'SS9900112233', 'Calle Rio 78', 'Ceuta', 'Programador', NULL, NULL),
    ('Elena', 'Ramirez', 'Sanchez', '00112233H', 'S0011223H', 'SS0011223344', 'Avenida Mar 90', 'Berlín', 'Arquitecta', NULL, NULL),
    ('David', 'Torres', 'Martinez', '22334455I', 'R2233445I', 'SS2233445566', 'Calle Viento 101', 'Valladolid', 'Analista', NULL, NULL),
    ('Sara', 'Alvarez', 'Garcia', '44556677J', 'Q4455667J', 'SS4455667788', 'Plaza Luna 202', 'Alicante', 'Consultora', NULL, NULL),
    ('Jorge', 'Navarro', 'Perez', '66778899K', 'P6677889K', 'SS6677889900', 'Avenida Estrella 303', 'La Coruña', 'Gerente', NULL, NULL);

        
INSERT INTO departamento (Nombre, Presupuesto, Jefe1, Jefe2) 
VALUES ('Recepcion', 10000.00, 1, NULL),
       ('Restaurante', 20000.00, 2, 3),
       ('Administracion', 15000.00, 3, NULL);
       
UPDATE empleado SET departamento = 3 WHERE id = 1;
UPDATE empleado SET departamento = 3 WHERE id = 2;
UPDATE empleado SET departamento = 3, superior = 1 WHERE id = 3;
UPDATE empleado SET departamento = 1, superior = 1 WHERE id = 4;
UPDATE empleado SET departamento = 2, superior = 1 WHERE id = 5;
UPDATE empleado SET departamento = 1, superior = 1 WHERE id = 6;
UPDATE empleado SET departamento = 3, superior = 1 WHERE id = 7;
UPDATE empleado SET departamento = 2, superior = 2 WHERE id = 8;
UPDATE empleado SET departamento = 2, superior = 2 WHERE id = 9;
UPDATE empleado SET departamento = 1, superior = 2 WHERE id = 10;
UPDATE empleado SET departamento = 2, superior = 2 WHERE id = 11;
UPDATE empleado SET departamento = 1, superior = 2 WHERE id = 12;
UPDATE empleado SET departamento = 1, superior = 2 WHERE id = 13;


INSERT INTO articulo (Nombre_articulo, Departamento) 
VALUES ('Toallas', 1),
       ('Cuberteria', 2),
       ('Ordenadores', 3);

INSERT INTO proveedor (Razon_social, NIF, Domicilio_fiscal, Localidad) 
VALUES ('Proveedor 1', 'A12345678', 'Calle Comercio 123', 'Madrid'),
       ('Proveedor 2', 'B87654321', 'Avenida Industria 456', 'Barcelona'),
       ('Proveedor 3', 'C11223344', 'Plaza Mercados 789', 'Sevilla'),
       ('Proveedor 4', '85495874D', 'Leicester Sq 79', 'Londres');

INSERT INTO pedido (FechaHora) 
VALUES ('2023-01-01 10:00:00'),
       ('2023-01-02 11:00:00'),
       ('2023-01-03 12:00:00');

INSERT INTO linea_pedido (Cantidad, Pedido, Articulo) 
VALUES (100, 1, 1),
       (200, 2, 2),
       (300, 3, 3);

INSERT INTO factura_pago (Fecha_factura, Base_imponible, Total_impuestos, Numero_externo) 
VALUES ('2023-01-20', 1000.00, 210.00, 'F123'),
       ('2023-01-25', 2000.00, 420.00, 'F456'),
       ('2023-01-30', 3000.00, 630.00, 'F789');

INSERT INTO albaran (Numero_externo, Fecha_albaran, Fecha_recepcion, Proveedor, Factura) 
VALUES ('A123', '2023-01-05', '2023-01-06', 1, 1),
       ('B456', '2023-01-10', '2023-01-11', 2, 2),
       ('C789', '2023-02-09', '2023-01-16', 3, 3),
       ('D489', '2023-04-11', '2023-01-16', 1, 1),
       ('E945', '2023-02-17', '2023-01-16', 2, 2),
       ('F138', '2023-09-05', '2023-01-16', 3, 3),
       ('G749', '2022-12-18', '2023-01-16', 3, 3);

INSERT INTO linea_albaran (Cantidad, Precio_compra, Impuesto, Descuento, Albaran, Articulo) 
VALUES (50, 10.10, 15.00, 0.00, 1, 1),
       (100, 15.65, 15.00, 5.00, 2, 1),
       (150, 19.99, 3.00, 10.00, 3, 1),
       (26, 4.05, 12.00, 0.00, 4, 2),
       (4, 24.90, 9.00, 0.00, 5, 2),
       (1, 156.84, 3.00, 0.00, 6, 2),
       (3, 207.40, 0.00, 0.00, 7, 3),
       (8, 207.40, 15.00, 20.00, 2, 3),
       (5, 207.40, 3.00, 50.00, 3, 3);
       
-- Error Code: 1442. Can't update table 'linea_albaran' in stored function/trigger because it is already used by statement which invoked this stored function/trigger.

INSERT INTO factura_cobro (Fecha_factura, Base_imponible, Total_impuestos) 
VALUES ('2023-02-01', 500.00, 105.00),
       ('2023-02-02', 1500.00, 315.00),
       ('2023-02-03', 2500.00, 525.00);

INSERT INTO habitacion (ID, Tipo, Vista_mar, Precio_base) 
VALUES (101, 'Normal', FALSE, 50.00),
       (102, 'Doble', TRUE, 100.00),
       (103, 'Suite', FALSE, 200.00),
       (104, 'Ático', TRUE, 350.00),
       (201, 'Normal', TRUE, 200.00),
       (202, 'Doble', FALSE, 50.00),
       (203, 'Suite', TRUE, 200.00);

INSERT INTO reserva (Fecha, Factura) 
VALUES ('2023-02-10', 1),
       ('2023-02-11', 2),
       ('2023-02-12', 3);

INSERT INTO cliente (NIF_NIE, Nombre, Apellido1, Apellido2, Domicilio, Pais) 
VALUES ('33456789A', 'Miriam', 'Pérez', 'Hidalgo', 'Calle Alegria 123, Madrid', 'España'),
       ('98765432B', 'Gabriel', 'Gómez', 'Rodríguez', 'Avenida Felicidad 456, Barcelona', 'España'),
       ('12345678C', 'José', 'Álvarez', 'Bermúdez', 'Plaza Contento 789, Sevilla', 'España');

INSERT INTO realiza_pedido (Pedido, Departamento, Proveedor) 
VALUES (1, 1, 1),
       (2, 2, 2),
       (3, 3, 3);

INSERT INTO corresponde (Pedido, Albaran) 
VALUES (1, 1),
       (2, 2),
       (3, 3);

INSERT INTO realiza_reserva (Reserva, Habitacion, Cliente) 
VALUES (1, 101, 1),
       (2, 102, 2),
       (3, 103, 3);

INSERT INTO empleado_telefono (Empleado, Telefono, Prefijo, Descripcion) 
VALUES (1, '600123456', '34', 'Personal'),
       (2, '600654321', '34', 'Trabajo'),
       (3, '600112233', '34', 'Emergencia')
       ;

INSERT INTO empleado_email (Empleado, Email, Descripcion) 
VALUES (1, 'juan.perez@hotel.com', 'Trabajo'),
       (2, 'maria.lopez@hotel.com', 'Personal'),
       (3, 'carlos.garcia@hotel.com', 'Emergencia');

INSERT INTO departamento_telefono (Departamento, Telefono, Extension, Descripcion) 
VALUES (1, '910123456', '1001', 'Recepcion'),
       (2, '910654321', '1002', 'Restaurante'),
       (3, '910112233', '1003', 'Administracion');

INSERT INTO proveedor_telefono (Proveedor, Telefono, Prefijo, Descripcion, Extension) 
VALUES (1, '910223344', '34', 'Oficina', '2001'),
       (2, '910556677', '34', 'Almacen', '2002'),
       (3, '910889900', '34', 'Ventas', '2003'),
       (4, '910889900', '34', 'Facturación', '1564')
       ;

INSERT INTO proveedor_email (Proveedor, Email, Descripcion) 
VALUES (1, 'contacto@proveedor1.com', 'General'),
       (2, 'contacto@proveedor2.com', 'Ventas'),
       (3, 'contacto@proveedor3.com', 'Soporte');

INSERT INTO cliente_telefono (Cliente, Telefono, Prefijo, Descripcion) 
VALUES (1, '650123456', '34', 'Personal'),
       (2, '650654321', '34', 'Trabajo'),
       (3, '650112233', '34', 'Emergencia');

INSERT INTO cliente_email (Cliente, Email, Descripcion) 
VALUES (1, 'cliente1@gmail.com', 'Personal'),
       (2, 'cliente2@gmail.com', 'Trabajo'),
       (3, 'cliente3@gmail.com', 'Secundario');