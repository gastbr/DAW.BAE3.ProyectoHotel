drop role if exists rol_direccion;
create role rol_direccion;
grant all privileges on hotel.* to rol_direccion with grant option;

drop role if exists rol_gestion_compras;
create role rol_gestion_compras;
grant select, insert, update, delete on hotel.corresponde to rol_gestion_compras;
grant select, insert, update, delete on hotel.albaran to rol_gestion_compras;
grant select, insert, update, delete on hotel.pedido to rol_gestion_compras;
grant select, insert, update, delete on hotel.linea_pedido to rol_gestion_compras;
grant select, insert, update, delete on hotel.linea_albaran to rol_gestion_compras;
grant select, insert, update, delete on hotel.realiza_pedido to rol_gestion_compras;
grant select on hotel.localidad to rol_gestion_compras;

drop role if exists rol_gestion_empleados;
create role rol_gestion_empleados;
grant select(puesto), update(puesto) on hotel.empleado to rol_gestion_empleados;
grant select, update on hotel.empleado_telefono to rol_gestion_empleados;
grant select, update on hotel.empleado_email to rol_gestion_empleados;
grant select(id, nombre, apellido1, apellido2, nif_nie, superior, departamento) on hotel.empleado to rol_gestion_empleados;
grant select on hotel.Departamento to rol_gestion_empleados;
grant select on hotel.Departamento_telefono to rol_gestion_empleados;

drop role if exists rol_administracion;
create role rol_administracion;
grant rol_gestion_compras to rol_administracion;
grant select, insert, update, delete on hotel.factura_pago to rol_administracion;
grant select, insert, update, delete on hotel.proveedor_email to rol_administracion;
grant select, insert, update, delete on hotel.proveedor_telefono to rol_administracion;
grant select, insert, update, delete on hotel.articulo to rol_administracion;
grant select, insert, update, delete on hotel.factura_cobro to rol_administracion;
grant select, update on hotel.proveedor to rol_administracion;
grant select(id, tipo, vista_mar), update(id, tipo, vista_mar) on hotel.habitacion to rol_administracion;
grant select(id, nombre, jefe1, jefe2) on hotel.departamento to rol_administracion;
grant select on hotel.Departamento_telefono to rol_administracion;
grant select(id, nombre, apellido1, apellido2, puesto, superior, departamento) on hotel.empleado to rol_administracion;
grant select on hotel.reserva to rol_administracion;
grant select(precio_base) on hotel.habitacion to rol_administracion;
grant select on hotel.Realiza_reserva to rol_administracion;
grant select(id) on hotel.cliente to rol_administracion;

drop role if exists rol_jefatura;
create role rol_jefatura;
grant rol_gestion_compras to rol_jefatura;
grant rol_gestion_empleados to rol_jefatura;

drop role if exists rol_recepcion;
create role rol_recepcion;
grant select, insert, update, delete on hotel.Reserva to rol_recepcion;
grant select, insert, update, delete on hotel.Cliente to rol_recepcion;
grant select, insert, update, delete on hotel.cliente_telefono to rol_recepcion;
grant select, insert, update, delete on hotel.cliente_email to rol_recepcion;
grant select, insert, update, delete on hotel.Realiza_reserva to rol_recepcion;
grant select, insert, update, delete on hotel.factura_cobro to rol_recepcion;
grant select(estado, ocupada), update(estado, ocupada) on hotel.Habitacion to rol_recepcion;
grant select(id, tipo, vista_mar, precio_base) on hotel.Habitacion to rol_recepcion;
grant select(id, nombre, jefe1, jefe2) on hotel.Departamento to rol_recepcion;
grant select on hotel.Departamento_telefono to rol_recepcion;
grant select(id, nombre, apellido1, apellido2) on hotel.empleado to rol_recepcion;

drop role if exists rol_contabilidad;
create role rol_contabilidad;
grant select, insert, update, delete on hotel.factura_cobro to rol_contabilidad;
grant select, insert, update, delete on hotel.factura_pago to rol_contabilidad;
grant select, update on hotel.Departamento to rol_contabilidad;
grant select(ID) on hotel.albaran to rol_contabilidad;
grant select on hotel.Departamento_telefono to rol_contabilidad;

drop role if exists rol_gobernanza;
create role rol_gobernanza;
grant select(estado), update(estado) on hotel.Gobernanza to rol_gobernanza;
grant select(id, tipo, vista_mar) on hotel.Habitacion to rol_gobernanza;
grant select(ID, fecha) on hotel.reserva to rol_gobernanza;
grant select(reserva, habitacion) on hotel.realiza_reserva to rol_gobernanza;

drop role if exists rol_mantenimiento;
create role rol_mantenimiento;

drop role if exists rol_restaurante;
create role rol_restaurante;

drop role if exists rol_cocina;
create role rol_cocina;

flush privileges;