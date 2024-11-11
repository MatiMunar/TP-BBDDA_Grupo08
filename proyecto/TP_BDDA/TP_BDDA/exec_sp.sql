USE Com2900G08

EXEC insertar.informacion_complementaria @rutaArchivo = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Informacion_complementaria.xlsx';

EXEC insertar.datos_catalogo @rutaArchivo = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Productos\catalogo.csv', @rutaArchComplement = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Informacion_complementaria.xlsx';

EXEC insertar.datos_electronic_accessories @rutaArchivo = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Productos\Electronic accessories.xlsx';

EXEC insertar.datos_productos_importados @rutaArchivo = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Productos\Productos_importados.xlsx';

EXEC insertar.ventas_registradas @rutaArchivo = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Ventas_registradas.csv';

EXEC insertar.actualizar_categoria

select * from [creacion].[venta]v
left join [creacion].[detalle_venta] d on d.id_venta = v.id_venta
where d.id_detalle_venta is null
select * from [creacion].[detalle_venta]

SELECT * 
FROM [creacion].[producto] p
WHERE p.nombre_producto LIKE '%perro adulto Delikut con cordero y verduras%';
