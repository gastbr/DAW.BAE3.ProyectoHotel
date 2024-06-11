drop database if exists hotel;
create database hotel;
use hotel;

CREATE TABLE hotel.empleado (
    ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(25) NOT NULL,
    Apellido1 VARCHAR(25) NOT NULL,
    Apellido2 VARCHAR(25),
    NIF_NIE VARCHAR(10) NOT NULL UNIQUE,
    NIE_Antiguo CHAR(10) UNIQUE,
    Seg_Social CHAR(12) NOT NULL UNIQUE,
    Domicilio VARCHAR(100) NOT NULL,
    Localidad VARCHAR(30) NOT NULL,
    Puesto VARCHAR(15) NOT NULL,
    Superior INT UNSIGNED,
    Departamento INT UNSIGNED,
	-- Clave foránea de departamento declarada en ALTER TABLE (ln 38)
    CONSTRAINT CH_empleado_NIF CHECK (NIF_NIE RLIKE '^[A-Z]{0,1}[0-9]{8}[A-Z]{1}$'),
    CONSTRAINT CH_empleado_NIE CHECK (NIE_Antiguo RLIKE '^[A-Z]{1}[0-9]{7}[A-Z]{1}$'),
    CONSTRAINT CH_empleado_SegSocial CHECK (Seg_Social RLIKE '^[A-Z0-9]{12}$'),
    CONSTRAINT FK_empleado_Superior FOREIGN KEY (Superior)
        REFERENCES empleado (ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE hotel.departamento (
    ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(15) UNIQUE NOT NULL,
    Presupuesto DECIMAL(10 , 2 ),
    Jefe1 INT UNSIGNED NOT NULL,
    Jefe2 INT UNSIGNED,
    CONSTRAINT FK_departamento_Jefe1 FOREIGN KEY (Jefe1)
        REFERENCES empleado (ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT FK_departamento_Jefe2 FOREIGN KEY (Jefe2)
        REFERENCES empleado (ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

ALTER TABLE hotel.empleado
ADD 
	CONSTRAINT FK_empleado_Departamento FOREIGN KEY (Departamento)
		REFERENCES departamento (ID) ON DELETE RESTRICT ON UPDATE CASCADE;
        
 CREATE TABLE hotel.articulo (
    ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Nombre_articulo VARCHAR(50) UNIQUE NOT NULL,
    Departamento INT UNSIGNED NOT NULL,
    CONSTRAINT FK_articulo_Departamento FOREIGN KEY (Departamento)
        REFERENCES departamento (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE hotel.proveedor (
    ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Razon_social VARCHAR(50) NOT NULL,
    NIF CHAR(9) UNIQUE,
    Domicilio_fiscal VARCHAR(100) NOT NULL,
    Localidad VARCHAR(30)
);

CREATE TABLE hotel.pedido (
    ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    FechaHora DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE hotel.linea_pedido (
    ID INT UNSIGNED AUTO_INCREMENT,
    Cantidad SMALLINT NOT NULL,
    Pedido INT UNSIGNED NOT NULL,
    Articulo INT UNSIGNED NOT NULL,
    CONSTRAINT FK_linea_pedido FOREIGN KEY (Pedido)
        REFERENCES Pedido (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_linea_ped_articulo FOREIGN KEY (Articulo)
        REFERENCES Articulo (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_linea_pedido PRIMARY KEY (ID , Pedido)
);

CREATE TABLE hotel.albaran (
    ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Numero_externo VARCHAR(15),
    Fecha_albaran DATE NOT NULL,
    Fecha_recepcion DATE NOT NULL,
    Base_imponible DECIMAL(10 , 2 ) NOT NULL DEFAULT 0,
    Total_impuestos DECIMAL(10 , 2 ) NOT NULL DEFAULT 0,
    Total_descuentos DECIMAL(10 , 2 ) NOT NULL DEFAULT 0,
    Importe_total DECIMAL(10 , 2 ) NOT NULL DEFAULT 0,
    Proveedor INT UNSIGNED NOT NULL,
    Factura INT UNSIGNED
);

CREATE TABLE hotel.linea_albaran (
    ID INT UNSIGNED AUTO_INCREMENT,
    Cantidad SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    Precio_compra DECIMAL(10 , 2 ) NOT NULL,
    Impuesto DECIMAL(5 , 2 ) NOT NULL DEFAULT 0,
    Descuento DECIMAL(5 , 2 ) NOT NULL DEFAULT 0,
    Importe DECIMAL(10 , 2 ),
    Albaran INT UNSIGNED NOT NULL,
    Articulo INT UNSIGNED NOT NULL,
    CONSTRAINT FK_linea_Albaran FOREIGN KEY (Albaran)
        REFERENCES Albaran (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_linea_Alb_articulo FOREIGN KEY (Articulo)
        REFERENCES Articulo (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_linea_albaran PRIMARY KEY (ID , Albaran)
);

/* 

DELIMITER $$
CREATE TRIGGER hotel.albaran_calcular_importe
after insert on linea_albaran
for each row
begin
update linea_albaran set importe = (precio_compra - ((new.descuento/100) * new.precio_compra) + ((new.impuesto/100) * new.precio_compra)) where id = new.id;
UPDATE albaran 
SET 
    base_imponible = base_imponible + new.precio_compra,
    total_impuestos = total_impuestos + ((new.impuesto / 100) * new.precio_compra),
    total_descuentos = total_descuentos + ((new.descuento / 100) * new.precio_compra),
    importe_total = importe_total + new.importe
WHERE
    id = new.albaran;
end$$

/*
CREATE TRIGGER hotel.albaran_actualizar_importes
after update on linea_albaran
for each row
begin
update linea_albaran set importe = (precio_compra - ((new.descuento/100) * new.precio_compra) + ((new.impuesto/100) * new.precio_compra)) where id = new.id;
UPDATE albaran 
SET 
    base_imponible = base_imponible + new.precio_compra - old.precio_compra,
    total_impuestos = total_impuestos + ((new.impuesto / 100) * new.precio_compra) - ((old.impuesto / 100) * old.precio_compra),
    total_descuentos = total_descuentos + ((new.descuento / 100) * new.precio_compra) - ((old.descuento / 100) * old.precio_compra),
    importe_total = importe_total + new.importe - old.importe
WHERE
    id = new.albaran;
end$$
*/

DELIMITER ;

CREATE TABLE hotel.factura_pago (
    ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Fecha_factura DATE DEFAULT (CURRENT_DATE),
    Base_imponible DECIMAL(10 , 2 ) NOT NULL,
    Total_impuestos DECIMAL(10 , 2 ) NOT NULL,
    Numero_externo VARCHAR(15)
);

ALTER TABLE hotel.albaran
	ADD CONSTRAINT FK_albaran_proveedor FOREIGN KEY (Proveedor)
		REFERENCES Proveedor (ID) ON DELETE CASCADE ON UPDATE CASCADE,
	ADD CONSTRAINT FK_albaran_factura FOREIGN KEY (Factura)
		REFERENCES Factura_pago (ID) ON DELETE RESTRICT ON UPDATE CASCADE
;

CREATE TABLE hotel.factura_cobro (
    ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Fecha_factura DATE DEFAULT (CURRENT_DATE),
	Base_imponible DECIMAL(10 , 2 ) NOT NULL,
    Total_impuestos DECIMAL(10 , 2 ) NOT NULL
);

CREATE TABLE hotel.habitacion (
    ID INT UNSIGNED PRIMARY KEY,
    Tipo ENUM('Normal', 'Doble', 'Suite', 'Ático') NOT NULL,
    Vista_mar BOOLEAN NOT NULL,
    Precio_base DECIMAL(6 , 2 ) NOT NULL
);

CREATE TABLE hotel.reserva (
    ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Fecha DATE DEFAULT (CURRENT_DATE),
    Factura INT UNSIGNED,
    CONSTRAINT FK_reserva_factura FOREIGN KEY (Factura)
        REFERENCES factura_cobro (ID) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE hotel.cliente (
    ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    NIF_NIE VARCHAR(10) NOT NULL UNIQUE,
    Nombre VARCHAR(25) NOT NULL,
    Apellido1 VARCHAR(25) NOT NULL,
    Apellido2 VARCHAR(25),
    Domicilio VARCHAR(120) NOT NULL,
    Pais VARCHAR(30) NOT NULL,
    CONSTRAINT CH_cliente_NIF CHECK (NIF_NIE RLIKE '^[A-Z0-9]{1}[0-9]{7}[A-Z]{1}$')
);

-- TABLAS DE RELACIONES

CREATE TABLE hotel.realiza_pedido (
    Pedido INT UNSIGNED PRIMARY KEY,
    Departamento INT UNSIGNED NOT NULL,
    Proveedor INT UNSIGNED NOT NULL,
    CONSTRAINT FK_Realiza_Pedido FOREIGN KEY (Pedido)
        REFERENCES Pedido (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Realiza_Departamento FOREIGN KEY (Departamento)
        REFERENCES Departamento (ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT FK_Realiza_Proveedor FOREIGN KEY (Proveedor)
        REFERENCES Proveedor (ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE hotel.corresponde (
    Pedido INT UNSIGNED,
    Albaran INT UNSIGNED,
    CONSTRAINT FK_corresponde_Pedido FOREIGN KEY (Pedido)
        REFERENCES Pedido (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_corresponde_Albaran FOREIGN KEY (Albaran)
        REFERENCES Albaran (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_corresponde PRIMARY KEY (Pedido , Albaran)
);

CREATE TABLE hotel.realiza_reserva (
    Reserva INT UNSIGNED,
    Habitacion INT UNSIGNED,
    Cliente INT UNSIGNED NOT NULL,
    CONSTRAINT FK_realiza_reserva FOREIGN KEY (Reserva)
        REFERENCES Reserva (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_realiza_Habitacion FOREIGN KEY (Habitacion)
        REFERENCES Habitacion (ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT FK_realiza_Cliente FOREIGN KEY (Cliente)
        REFERENCES Cliente (ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT PK_realiza_reserva PRIMARY KEY (Reserva , Habitacion)
);

-- NORMALIZACIÓN

CREATE TABLE hotel.empleado_telefono (
    Empleado INT UNSIGNED,
    Telefono CHAR(9),
    Prefijo CHAR(3),
    Descripcion VARCHAR(20),
    CONSTRAINT FK_empleado_telefono FOREIGN KEY (Empleado)
        REFERENCES Empleado (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_empleado_telefono PRIMARY KEY (Empleado , Descripcion)
);

CREATE TABLE hotel.empleado_email (
    Empleado INT UNSIGNED,
    Email VARCHAR(50),
    Descripcion VARCHAR(20),
    CONSTRAINT FK_empleado_email FOREIGN KEY (Empleado)
        REFERENCES Empleado (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_empleado_email PRIMARY KEY (Empleado , Descripcion)
);

CREATE TABLE hotel.departamento_telefono (
    Departamento INT UNSIGNED,
    Telefono CHAR(9),
    Extension CHAR(4),
    Descripcion VARCHAR(20),
    CONSTRAINT FK_Departamento_telefono FOREIGN KEY (Departamento)
        REFERENCES Departamento (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_Departamento_telefono PRIMARY KEY (Departamento , Descripcion)
);

CREATE TABLE hotel.proveedor_telefono (
    Proveedor INT UNSIGNED,
    Telefono CHAR(9),
    Prefijo CHAR(3),
    Descripcion VARCHAR(20),
    Extension CHAR(4),
    CONSTRAINT FK_proveedor_telefono FOREIGN KEY (Proveedor)
        REFERENCES Proveedor (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_proveedor_telefono PRIMARY KEY (Proveedor , Descripcion)
);

CREATE TABLE hotel.proveedor_email (
    Proveedor INT UNSIGNED,
    Email VARCHAR(50),
    Descripcion VARCHAR(20),
    CONSTRAINT FK_proveedor_email FOREIGN KEY (Proveedor)
        REFERENCES Proveedor (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_proveedor_email PRIMARY KEY (Proveedor , Descripcion)
);

CREATE TABLE hotel.cliente_telefono (
    Cliente INT UNSIGNED,
    Telefono CHAR(9),
    Prefijo CHAR(3),
    Descripcion VARCHAR(20),
    CONSTRAINT FK_cliente_telefono FOREIGN KEY (Cliente)
        REFERENCES Cliente (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_cliente_telefono PRIMARY KEY (Cliente , Descripcion)
);

CREATE TABLE hotel.cliente_email (
    Cliente INT UNSIGNED,
    Email VARCHAR(50),
    Descripcion VARCHAR(20),
    CONSTRAINT FK_cliente_email FOREIGN KEY (Cliente)
        REFERENCES Cliente (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_cliente_email PRIMARY KEY (Cliente , Descripcion)
);

CREATE TABLE hotel.localidad (
    Localidad VARCHAR(30) PRIMARY KEY,
    Codigo_postal CHAR(10),
    Provincia VARCHAR(30),
    Pais VARCHAR(30) NOT NULL
);

ALTER TABLE hotel.empleado
	ADD CONSTRAINT FK_empleado_localidad FOREIGN KEY (Localidad)
		REFERENCES Localidad(Localidad) ON DELETE RESTRICT ON UPDATE CASCADE;
    
ALTER TABLE hotel.proveedor
	ADD CONSTRAINT FK_proveedor_localidad FOREIGN KEY (Localidad)
		REFERENCES Localidad(Localidad) ON DELETE RESTRICT ON UPDATE CASCADE;