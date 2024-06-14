drop role if exists ROL_admin;
create role ROL_admin;
grant all privileges on *.* to ROL_admin with grant option;

drop role if exists ROL_direccion;
create role ROL_direccion;
grant all privileges on hotel.* to ROL_direccion with grant option;

drop role if exists ROL_gestion_compras;
create role ROL_gestion_compras;
grant select, insert, update, delete on hotel.corresponde to ROL_gestion_compras;
grant select, insert, update, delete on hotel.albaran to ROL_gestion_compras;
grant select, insert, update, delete on hotel.pedido to ROL_gestion_compras;
grant select, insert, update, delete on hotel.linea_pedido to ROL_gestion_compras;
grant select, insert, update, delete on hotel.linea_albaran to ROL_gestion_compras;
grant select, insert, update, delete on hotel.realiza_pedido to ROL_gestion_compras;
grant select on hotel.localidad to ROL_gestion_compras;

drop role if exists ROL_gestion_empleados;
create role ROL_gestion_empleados;
grant select(puesto), update(puesto) on hotel.empleado to ROL_gestion_empleados;
grant select, update on hotel.empleado_telefono to ROL_gestion_empleados;
grant select, update on hotel.empleado_email to ROL_gestion_empleados;
grant select(id, nombre, apellido1, apellido2, nif_nie, superior, departamento) on hotel.empleado to ROL_gestion_empleados;
grant select on hotel.Departamento to ROL_gestion_empleados;
grant select on hotel.Departamento_telefono to ROL_gestion_empleados;

drop role if exists ROL_administracion;
create role ROL_administracion;
grant ROL_gestion_compras to ROL_administracion;
grant select, insert, update, delete on hotel.factura_pago to ROL_administracion;
grant select, insert, update, delete on hotel.proveedor_email to ROL_administracion;
grant select, insert, update, delete on hotel.proveedor_telefono to ROL_administracion;
grant select, insert, update, delete on hotel.articulo to ROL_administracion;
grant select, insert, update, delete on hotel.factura_cobro to ROL_administracion;
grant select, update on hotel.proveedor to ROL_administracion;
grant select(id, tipo, vista_mar), update(id, tipo, vista_mar) on hotel.habitacion to ROL_administracion;
grant select(id, nombre, jefe1, jefe2) on hotel.departamento to ROL_administracion;
grant select on hotel.Departamento_telefono to ROL_administracion;
grant select(id, nombre, apellido1, apellido2, puesto, superior, departamento) on hotel.empleado to ROL_administracion;
grant select on hotel.reserva to ROL_administracion;
grant select(precio_base) on hotel.habitacion to ROL_administracion;
grant select on hotel.Realiza_reserva to ROL_administracion;
grant select(id) on hotel.cliente to ROL_administracion;

drop role if exists ROL_jefatura;
create role ROL_jefatura;
grant ROL_gestion_compras to ROL_jefatura;
grant ROL_gestion_empleados to ROL_jefatura;

drop role if exists ROL_recepcion;
create role ROL_recepcion;
grant select, insert, update, delete on hotel.Reserva to ROL_recepcion;
grant select, insert, update, delete on hotel.Cliente to ROL_recepcion;
grant select, insert, update, delete on hotel.cliente_telefono to ROL_recepcion;
grant select, insert, update, delete on hotel.cliente_email to ROL_recepcion;
grant select, insert, update, delete on hotel.Realiza_reserva to ROL_recepcion;
grant select, insert, update, delete on hotel.factura_cobro to ROL_recepcion;
grant select(estado, ocupada), update(estado, ocupada) on hotel.Habitacion to ROL_recepcion;
grant select(id, tipo, vista_mar, precio_base) on hotel.Habitacion to ROL_recepcion;
grant select(id, nombre, jefe1, jefe2) on hotel.Departamento to ROL_recepcion;
grant select on hotel.Departamento_telefono to ROL_recepcion;
grant select(id, nombre, apellido1, apellido2) on hotel.empleado to ROL_recepcion;

drop role if exists ROL_contabilidad;
create role ROL_contabilidad;
grant select, insert, update, delete on hotel.factura_cobro to ROL_contabilidad;
grant select, insert, update, delete on hotel.factura_pago to ROL_contabilidad;
grant select, update on hotel.Departamento to ROL_contabilidad;
grant select(ID) on hotel.albaran to ROL_contabilidad;
grant select on hotel.Departamento_telefono to ROL_contabilidad;

drop role if exists ROL_gobernanza;
create role ROL_gobernanza;
grant select(id, tipo, vista_mar, estado, ocupada), update(estado) on hotel.Habitacion to ROL_gobernanza;
grant select(ID, fecha) on hotel.reserva to ROL_gobernanza;
grant select(reserva, habitacion) on hotel.realiza_reserva to ROL_gobernanza;

drop role if exists ROL_mantenimiento;
create role ROL_mantenimiento;
grant select(id, tipo, vista_mar, ocupada, estado), update(estado) on hotel.Habitacion to ROL_mantenimiento;

drop role if exists ROL_restaurante;
create role ROL_restaurante;
grant select(id, ocupada) on hotel.Habitacion to ROL_restaurante;
grant select(id) on hotel.reserva to ROL_restaurante;
grant select(id, nombre, apellido1, apellido2) on hotel.cliente to ROL_restaurante;
grant select(reserva, habitacion, cliente) on hotel.realiza_reserva to ROL_restaurante;

drop role if exists ROL_cocina;
create role ROL_cocina;
grant select(id, nombre) on hotel.departamento to ROL_cocina;
grant select on hotel.articulo to ROL_cocina;

drop user if exists admin_sistema@localhost;
create user 'admin_sistema'@'localhost' identified by '1234';
grant ROL_admin to 'admin_sistema'@'localhost';
set default role 'ROL_admin' to 'admin_sistema'@'localhost';

drop user if exists direccion@localhost;
create user 'direccion'@'localhost' identified by '1234';
grant ROL_direccion to 'direccion'@'localhost';
set default role 'ROL_direccion' to 'direccion'@'localhost';

drop user if exists administracion@localhost;
create user 'administracion'@'localhost' identified by '1234';
grant ROL_administracion to 'administracion'@'localhost';
set default role 'ROL_administracion' to 'administracion'@'localhost';

drop user if exists jeferestaurante@localhost;
create user 'jeferestaurante'@'localhost' identified by '1234';
grant ROL_jefatura to 'jeferestaurante'@'localhost';
set default role 'ROL_jefatura' to 'jeferestaurante'@'localhost';

drop user if exists jefegobernanza@localhost;
create user 'jefegobernanza'@'localhost' identified by '1234';
grant ROL_jefatura to 'jefegobernanza'@'localhost';
set default role 'ROL_jefatura' to 'jefegobernanza'@'localhost';

drop user if exists jeferecepcion@localhost;
create user 'jeferecepcion'@'localhost' identified by '1234';
grant ROL_jefatura to 'jeferecepcion'@'localhost';
set default role 'ROL_jefatura' to 'jeferecepcion'@'localhost';

drop user if exists jefecocina@localhost;
create user 'jefecocina'@'localhost' identified by '1234';
grant ROL_jefatura to 'jefecocina'@'localhost';
set default role 'ROL_jefatura' to 'jefecocina'@'localhost';

drop user if exists jefemantenimiento@localhost;
create user 'jefemantenimiento'@'localhost' identified by '1234';
grant ROL_jefatura to 'jefemantenimiento'@'localhost';
set default role 'ROL_jefatura' to 'jefemantenimiento'@'localhost';

drop user if exists recepcion@localhost;
create user 'recepcion'@'localhost' identified by '1234';
grant ROL_recepcion to 'recepcion'@'localhost';
set default role 'ROL_recepcion' to 'recepcion'@'localhost';

drop user if exists contabilidad@localhost;
create user 'contabilidad'@'localhost' identified by '1234';
grant ROL_contabilidad to 'contabilidad'@'localhost';
set default role 'ROL_contabilidad' to 'contabilidad'@'localhost';

drop user if exists gobernanza@localhost;
create user 'gobernanza'@'localhost' identified by '1234';
grant ROL_gobernanza to 'gobernanza'@'localhost';
set default role 'ROL_gobernanza' to 'gobernanza'@'localhost';

drop user if exists mantenimiento@localhost;
create user 'mantenimiento'@'localhost' identified by '1234';
grant ROL_mantenimiento to 'mantenimiento'@'localhost';
set default role 'ROL_mantenimiento' to 'mantenimiento'@'localhost';

drop user if exists restaurante@localhost;
create user 'restaurante'@'localhost' identified by '1234';
grant ROL_restaurante to 'restaurante'@'localhost';
set default role 'ROL_restaurante' to 'restaurante'@'localhost';

drop user if exists cocina@localhost;
create user 'cocina'@'localhost' identified by '1234';
grant ROL_cocina to 'cocina'@'localhost';
set default role 'ROL_cocina' to 'cocina'@'localhost';

flush privileges;