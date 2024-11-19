USE Com2900G08
GO

EXEC insertar.generar_nota_credito
    @numero_factura = '750-67-8428',
    @valor = 42.35;

-- Error, ya existe una nota de crédito para esta factura
EXEC insertar.generar_nota_credito
    @numero_factura = '750-67-8428',
    @valor = 42.35;

-- Error, el valor pasado por parametro (monto a reintegrar) supera el monto total de la venta
EXEC insertar.generar_nota_credito
    @numero_factura = '101-17-6199',
    @valor = 350;

-- Error, el valor pasado por parametro (monto a reintegrar) es menor o igual a 0
EXEC insertar.generar_nota_credito
    @numero_factura = '135-84-8019',
    @valor = -5;