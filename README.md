# Proyecto de Base de Datos Aplicada - Universidad Nacional de La Matanza (UNLaM)

## Descripción

Este proyecto tiene como objetivo el desarrollo de un sistema de base de datos para un supermercado minorista, diseñado como parte de un trabajo de la asignatura de **Base de Datos Aplicada** de la **Universidad Nacional de La Matanza (UNLaM)**. El sistema incluye el diseño y la implementación de diversas tablas y procedimientos almacenados para gestionar productos, ventas, empleados y sucursales.

## Integrantes

- Iván Roig
- Felipe Devalle
- Matías Munar

## Objetivo del Proyecto

El sistema de base de datos tiene como propósito administrar la información de un supermercado minorista, incluyendo las siguientes funcionalidades:
- Gestión de **productos**, **empleados** y **sucursales**.
- Registro de **ventas** y **detalles de ventas**.
- Catálogo de productos con tipos de **productos** organizados en diferentes categorías.
- Generación de reportes en formato **XML** sobre ventas mensuales, trimestrales y por rangos de fechas.

## Estructura de la Base de Datos

El modelo de la base de datos incluye las siguientes tablas:

1. **sucursal**: Almacena las sucursales del supermercado.
2. **empleado**: Contiene información de los empleados, vinculados a una sucursal.
3. **producto**: Registra los productos disponibles en el supermercado.
4. **catalogo_producto**: Relaciona los productos con los tipos de catálogos.
5. **venta**: Registra las ventas realizadas en las sucursales.
6. **detalle_venta**: Almacena los detalles de cada venta, como los productos vendidos.

## Tecnologías Utilizadas

- **SQL Server**: Para la gestión y administración de la base de datos.
- **Draw.io**: Para el modelado de datos.
