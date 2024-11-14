USE Com2900G08

EXEC insertar.generar_nota_credito
    @numero_factura = '750-67-8428',
    @valor = 34903.75;

-- Error, ya existe una nota de crédito para esta factura
EXEC insertar.generar_nota_credito
    @id_factura = '750-67-8428',
    @valor = 34903.75;