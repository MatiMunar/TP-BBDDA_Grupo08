USE master;
GO

-- Cambiar la base de datos a modo de emergencia
ALTER DATABASE Com2900G08 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Eliminar la base de datos
DROP DATABASE Com2900G08;
GO
