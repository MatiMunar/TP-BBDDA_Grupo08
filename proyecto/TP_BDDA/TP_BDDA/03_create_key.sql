USE Com2900G08;
GO

-- Creamos una clave maestra si no existe
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'claveMaestra123';
END;
GO

-- Creamos la clave simétrica para encriptar datos personales de los empleados
IF NOT EXISTS (SELECT * FROM sys.certificates WHERE name = 'CertificadoEmpleado')
BEGIN
    CREATE CERTIFICATE CertificadoEmpleado
    WITH SUBJECT = 'Certificado de Encriptación para Empleados';
END;
GO

IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'ClaveEmpleado')
BEGIN
    CREATE SYMMETRIC KEY ClaveEmpleado
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE CertificadoEmpleado;
END;
GO
