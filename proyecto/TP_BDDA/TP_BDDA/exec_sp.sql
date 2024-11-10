USE Com2900G08

EXEC insertar.informacion_complementaria @rutaArchivo = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Informacion_complementaria.xlsx';

EXEC insertar.datos_catalogo @rutaArchivo = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Productos\catalogo.csv', @rutaArchComplement = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Informacion_complementaria.xlsx';

EXEC insertar.datos_electronic_accessories @rutaArchivo = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Productos\Electronic accessories.xlsx', @rutaArchComplement = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Informacion_complementaria.xlsx';

EXEC insertar.datos_productos_importados @rutaArchivo = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Productos\Productos_importados.xlsx';

EXEC insertar.ventas_registradas @rutaArchivo = 'C:\Users\ivanr\Desktop\TP_integrador_Archivos\Ventas_registradas.csv';