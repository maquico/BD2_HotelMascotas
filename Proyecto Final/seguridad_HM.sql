--GERENTE
USE [master]
GO
CREATE LOGIN UserGerente WITH PASSWORD = '54321gerente12345', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON;
USE [Hotel_Mascotas_DB]
	GO
    CREATE USER UserGerente FOR LOGIN UserGerente
    GO
    DENY SELECT, INSERT, UPDATE, DELETE ON DATABASE:: Hotel_Mascotas_DB TO UserGerente;
    GRANT EXECUTE TO UserGerente;
    

--EMPLEADO
USE [master]
GO
CREATE LOGIN [UserEmpleado] WITH PASSWORD=N'X3LyKR/AspYPtThV2HWlE+emR0Zp2sl3AfSnTRCh3Xas', DEFAULT_DATABASE=[Hotel_Mascotas_DB], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [Hotel_Mascotas_DB]
	GO
CREATE USER [UserEmpleado] FOR LOGIN [UserEmpleado]
GO
DENY SELECT, INSERT, UPDATE, DELETE ON DATABASE::Hotel_Mascotas_DB To [UserEmpleado]
GO
DENY EXECUTE ON SCHEMA:: [Registro] TO [UserEmpleado]
GO
DENY EXECUTE ON SCHEMA:: [adm] TO [UserEmpleado]
GO
DENY EXECUTE ON SCHEMA:: [Facturacion] TO [UserEmpleado]
GO
GRANT EXECUTE ON registro.spAgregarServicioAplicado TO [UserEmpleado]

--CLIENTE

USE [master]
GO
CREATE LOGIN [UserCliente] WITH PASSWORD=N'X3LyKR/AspYPtThV2HWlE+emR0Zp2sl3AfSnTRCh3Xg', DEFAULT_DATABASE=[Hotel_Mascotas_DB], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [Hotel_Mascotas_DB]
	GO
CREATE USER [UserCliente] FOR LOGIN [UserCliente]
GO
GRANT EXECUTE ON SCHEMA:: [Registro] TO [UserCliente]
GO
DENY SELECT, INSERT, UPDATE, DELETE ON DATABASE::Hotel_Mascotas_DB To [UserCliente]
GO
DENY EXECUTE ON SCHEMA:: [adm] TO [UserCliente]
GO
DENY EXECUTE ON SCHEMA:: [Facturacion] TO [UserCliente]
GO
DENY  SELECT, INSERT, UPDATE, DELETE ON registro.razas TO [UserCliente]


--Cajero
USE [master]
	GO
	CREATE LOGIN [UserCajero] WITH PASSWORD='jvuycfgkIUgiofufygUTFFR!@#5768$#@#$%'

USE [Hotel_Mascotas_DB]
	GO
	CREATE USER [UserCajero] FOR LOGIN [UserCajero]
	GO
	GO
	GRANT EXECUTE ON SCHEMA::[facturacion] TO [UserCajero];
	DENY SELECT, INSERT, UPDATE, DELETE ON DATABASE::Hotel_Mascotas_DB TO UserCajero;
	GO
	DENY EXECUTE ON SCHEMA::[adm] to [UserCajero]
	GO
	GO
	DENY EXECUTE ON SCHEMA::[registro] to [UserCajero]
	GO

--Recepcionista
USE [master]
CREATE LOGIN [UserRecepcionista] WITH PASSWORD=N'Us3r__R3c3pc1@n127@'
GO
CREATE USER [UserRecepcionista] FOR LOGIN [UserRecepcionista]
GO

GRANT EXECUTE ON SCHEMA::[registro] TO [UserRecepcionista];
Go

DENY SELECT, INSERT, UPDATE, DELETE ON DATABASE::Hotel_Mascotas_DB TO [UserRecepcionista];
Go

DENY EXECUTE ON SCHEMA::[adm] TO [UserRecepcionista]
GO

DENY EXECUTE ON SCHEMA::[facturacion] TO [UserRecepcionista]