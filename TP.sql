create database Com2900G08

use Com2900G08

create schema transacciones

create schema supermrkt

create table supermrkt.empleado
(
  id_Empleado int identity (257020, 1) primary key,
  dni_Empleado int,
  cuil_Empleado int,
  nombre char(50),
  apellido char(50),
  direccion char(100),
  mail_personal char(70),
  mail_empresa char(70),
  Cargo char(20),
  turno char(20)
)

create table supermrkt.sucursal

venta
detalle de venta
producto
medios de pago
