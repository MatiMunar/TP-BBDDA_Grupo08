IF DB_ID('Com2900G08') IS NULL
BEGIN
    CREATE DATABASE Com2900G08;
END
ELSE
	PRINT('Ya existe la Base de Datos "Com2900G08"')
GO