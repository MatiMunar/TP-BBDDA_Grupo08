USE Com2900G08

EXEC creacion.insertar_nota_credito 
    @id_venta = 1,
    @valor = 150.00,
    @tipo = 'Reembolso';
