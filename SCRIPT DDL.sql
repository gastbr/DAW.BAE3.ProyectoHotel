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
    Departamento INT UNSIGNED NOT NULL,
	-- Clave foránea de departamento declarada en ALTER TABLE (ln 38)
    CONSTRAINT CH_empleado_NIF CHECK (NIF_NIE RLIKE '^[A-Z]{0,1}[0-9]{8}[A-Z]{1}$'),
    CONSTRAINT CH_empleado_NIE CHECK (NIE_Antiguo RLIKE '^[A-Z]{1}[0-9]{8}[A-Z]{1}$'),
    CONSTRAINT CH_empleado_SegSocial CHECK (Seg_Social RLIKE '^[A-Z0-9]{12}$'),
    CONSTRAINT FK_empleado_Superior FOREIGN KEY (Superior)
        REFERENCES empleado (ID)
);

CREATE TABLE hotel.departamento (
    ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(15) UNIQUE NOT NULL,
    Presupuesto DECIMAL(10 , 2 ),
    Jefe1 INT UNSIGNED NOT NULL,
    Jefe2 INT UNSIGNED,
    CONSTRAINT FK_departamento_Jefe1 FOREIGN KEY (Jefe1)
        REFERENCES empleado (ID),
    CONSTRAINT FK_departamento_Jefe2 FOREIGN KEY (Jefe2)
        REFERENCES empleado (ID)
);

ALTER TABLE hotel.empleado
ADD 
	CONSTRAINT FK_empleado_Departamento FOREIGN KEY (Departamento)
		REFERENCES departamento (ID);
        
 CREATE TABLE hotel.articulo (
    ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Nombre_articulo VARCHAR(50) UNIQUE NOT NULL,
    Departamento INT UNSIGNED NOT NULL,
    CONSTRAINT FK_articulo_Departamento FOREIGN KEY (Departamento)
        REFERENCES departamento (ID)
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
        REFERENCES Pedido (ID),
    CONSTRAINT FK_linea_ped_articulo FOREIGN KEY (Articulo)
        REFERENCES Articulo (ID),
    CONSTRAINT PK_linea_pedido PRIMARY KEY (ID , Pedido)
);

CREATE TABLE hotel.albaran (
    ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Numero_externo VARCHAR(15),
    Fecha_albaran DATE NOT NULL,
    Fecha_recepcion DATE NOT NULL,
    Base_imponible DECIMAL(10 , 2 ) NOT NULL,
    Total_impuestos DECIMAL(10 , 2 ) NOT NULL,
    Importe_total DECIMAL(10 , 2 ) NOT NULL,
    Proveedor INT UNSIGNED NOT NULL,
    Factura INT UNSIGNED
    -- Claves foráneas declaradas en ALTER TABLE (ln 113)
);

CREATE TABLE hotel.linea_albaran (
    ID INT UNSIGNED AUTO_INCREMENT,
    Cantidad SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    Precio_compra DECIMAL(10 , 2 ) NOT NULL,
    Impuesto DECIMAL(5 , 2 ) NOT NULL DEFAULT 0,
    Descuento DECIMAL(5 , 2 ) NOT NULL DEFAULT 0,
    Importe DECIMAL(10 , 2 ) NOT NULL,
    Albaran INT UNSIGNED NOT NULL,
    Articulo INT UNSIGNED NOT NULL,
    CONSTRAINT FK_linea_Albaran FOREIGN KEY (Albaran)
        REFERENCES Albaran (ID),
    CONSTRAINT FK_linea_Alb_articulo FOREIGN KEY (Articulo)
        REFERENCES Articulo (ID),
    CONSTRAINT PK_linea_albaran PRIMARY KEY (ID , Albaran)
);

CREATE TABLE hotel.factura_pago (
    ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Fecha_factura DATE DEFAULT (CURRENT_DATE),
    Base_imponible DECIMAL(10 , 2 ) NOT NULL,
    Total_impuestos DECIMAL(10 , 2 ) NOT NULL,
    Numero_externo VARCHAR(15)
);

ALTER TABLE hotel.albaran
	ADD CONSTRAINT FK_albaran_proveedor FOREIGN KEY (Proveedor)
		REFERENCES Proveedor (ID),
	ADD CONSTRAINT FK_albaran_factura FOREIGN KEY (Factura)
		REFERENCES Factura_pago (ID)
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
        REFERENCES factura_cobro (ID)
);

CREATE TABLE hotel.cliente (
    ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    NIF_NIE VARCHAR(10) NOT NULL UNIQUE,
    Domicilio VARCHAR(120) NOT NULL,
    CONSTRAINT CH_cliente_NIF CHECK (NIF_NIE RLIKE '^[A-Z]{0,1}[0-9]{8}[A-Z]{1}$')
);

-- TABLAS DE RELACIONES

CREATE TABLE hotel.realiza_pedido (
    Pedido INT UNSIGNED PRIMARY KEY,
    Departamento INT UNSIGNED NOT NULL,
    Proveedor INT UNSIGNED NOT NULL,
    CONSTRAINT FK_Realiza_Pedido FOREIGN KEY (Pedido)
        REFERENCES Pedido (ID),
    CONSTRAINT FK_Realiza_Departamento FOREIGN KEY (Departamento)
        REFERENCES Departamento (ID),
    CONSTRAINT FK_Realiza_Proveedor FOREIGN KEY (Proveedor)
        REFERENCES Proveedor (ID)
);

CREATE TABLE hotel.corresponde (
    Pedido INT UNSIGNED,
    Albaran INT UNSIGNED,
    CONSTRAINT FK_corresponde_Pedido FOREIGN KEY (Pedido)
        REFERENCES Pedido (ID),
    CONSTRAINT FK_corresponde_Albaran FOREIGN KEY (Albaran)
        REFERENCES Albaran (ID),
    CONSTRAINT PK_corresponde PRIMARY KEY (Pedido , Albaran)
);

CREATE TABLE hotel.realiza_reserva (
    Reserva INT UNSIGNED,
    Habitacion INT UNSIGNED,
    Cliente INT UNSIGNED NOT NULL,
    CONSTRAINT FK_realiza_reserva FOREIGN KEY (Reserva)
        REFERENCES Reserva (ID),
    CONSTRAINT FK_realiza_Habitacion FOREIGN KEY (Habitacion)
        REFERENCES Habitacion (ID),
    CONSTRAINT FK_realiza_Cliente FOREIGN KEY (Cliente)
        REFERENCES Cliente (ID),
    CONSTRAINT PK_realiza_reserva PRIMARY KEY (Reserva , Habitacion)
);

-- NORMALIZACIÓN

CREATE TABLE hotel.empleado_telefono (
    Empleado INT UNSIGNED,
    Telefono CHAR(9),
    Prefijo CHAR(3),
    Descripcion VARCHAR(10),
    CONSTRAINT FK_empleado_telefono FOREIGN KEY (Empleado)
        REFERENCES Empleado (ID),
    CONSTRAINT PK_empleado_telefono PRIMARY KEY (Empleado , Descripcion)
);

CREATE TABLE hotel.empleado_email (
    Empleado INT UNSIGNED,
    Email VARCHAR(50),
    Descripcion VARCHAR(10),
    CONSTRAINT FK_empleado_email FOREIGN KEY (Empleado)
        REFERENCES Empleado (ID),
    CONSTRAINT PK_empleado_email PRIMARY KEY (Empleado , Descripcion)
);

CREATE TABLE hotel.departamento_telefono (
    Departamento INT UNSIGNED,
    Telefono CHAR(9),
    Extension CHAR(4),
    Descripcion VARCHAR(10),
    CONSTRAINT FK_Departamento_telefono FOREIGN KEY (Departamento)
        REFERENCES Departamento (ID),
    CONSTRAINT PK_Departamento_telefono PRIMARY KEY (Departamento , Descripcion)
);

CREATE TABLE hotel.proveedor_telefono (
    Proveedor INT UNSIGNED,
    Telefono CHAR(9),
    Prefijo CHAR(3),
    Descripcion VARCHAR(10),
    Extension CHAR(4),
    CONSTRAINT FK_proveedor_telefono FOREIGN KEY (Proveedor)
        REFERENCES Proveedor (ID),
    CONSTRAINT PK_proveedor_telefono PRIMARY KEY (Proveedor , Descripcion)
);

CREATE TABLE hotel.proveedor_email (
    Proveedor INT UNSIGNED,
    Email VARCHAR(50),
    Descripcion VARCHAR(10),
    CONSTRAINT FK_proveedor_email FOREIGN KEY (Proveedor)
        REFERENCES Proveedor (ID),
    CONSTRAINT PK_proveedor_email PRIMARY KEY (Proveedor , Descripcion)
);

CREATE TABLE hotel.cliente_telefono (
    Cliente INT UNSIGNED,
    Telefono CHAR(9),
    Prefijo CHAR(3),
    Descripcion VARCHAR(10),
    CONSTRAINT FK_cliente_telefono FOREIGN KEY (Cliente)
        REFERENCES Cliente (ID),
    CONSTRAINT PK_cliente_telefono PRIMARY KEY (Cliente , Descripcion)
);

CREATE TABLE hotel.cliente_email (
    Cliente INT UNSIGNED,
    Email VARCHAR(50),
    Descripcion VARCHAR(10),
    CONSTRAINT FK_cliente_email FOREIGN KEY (Cliente)
        REFERENCES Cliente (ID),
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
		REFERENCES Localidad(Localidad);
    
ALTER TABLE hotel.proveedor
	ADD CONSTRAINT FK_proveedor_localidad FOREIGN KEY (Localidad)
		REFERENCES Localidad(Localidad);