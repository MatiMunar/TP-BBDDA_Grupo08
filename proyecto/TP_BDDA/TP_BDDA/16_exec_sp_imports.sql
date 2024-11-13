USE Com2900G08

EXEC insertar.informacion_complementaria @rutaArchivo = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Informacion_complementaria.xlsx';

EXEC insertar.datos_catalogo @rutaArchivo = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Productos\catalogo.csv', @rutaArchComplement = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Informacion_complementaria.xlsx';

EXEC insertar.datos_electronic_accessories @rutaArchivo = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Productos\Electronic accessories.xlsx';

EXEC insertar.datos_productos_importados @rutaArchivo = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Productos\Productos_importados.xlsx';

EXEC insertar.actualizar_categoria

EXEC insertar.ventas_registradas @rutaArchivo = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Ventas_registradas.csv';


SELECT * FROM [creacion].[venta]
WHERE id_venta = 539

SELECT id_venta
FROM [creacion].[detalle_venta]
GROUP BY id_venta
HAVING COUNT(*) > 1;

SELECT * FROM creacion.detalle_venta
where id_venta = 539

SELECT *
FROM creacion.detalle_venta d
INNER JOIN creacion.producto p ON p.id_producto = d.id_producto
WHERE d.id_venta = 240;

SELECT numero_factura FROM creacion.factura
group by numero_factura
having count(*) >1

SELECT * FROM creacion.pago
where id_factura = 545

SELECT * FROM creacion.factura
where id_factura = 545

SELECT * FROM creacion.medio_de_pago

select nombre_producto from creacion.producto
group by nombre_producto
having count(*) > 1

select * from creacion.producto where nombre_producto = '70% Alcohol limpieza hogar Bosque Verde'      
