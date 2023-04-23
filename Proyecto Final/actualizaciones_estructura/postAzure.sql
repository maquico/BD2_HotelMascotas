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


--
UPDATE registro.MASCOTAS
SET Fecha_Ultimo_Celo = '2023-04-10'
WHERE Sexo_ID > 3 

UPDATE registro.MASCOTAS
SET Fecha_Ultimo_Celo = null
WHERE Sexo_ID < 4 

CREATE OR ALTER FUNCTION adm.fnVerificarCelo()
RETURNS TABLE
AS
RETURN
(
    SELECT Nombre, Fecha_Ultimo_Celo
    FROM registro.MASCOTAS
    WHERE Sexo_ID IN (5, 6) AND Fecha_Ultimo_Celo <= DATEADD(day, -30, GETDATE())
);

USE msdb
GO

EXEC sp_add_job
  @job_name = 'Verificar último celo femenino',
  @enabled = 1,
  @description = 'Comprueba si hay mascotas femeninas en fecha de peligro para su último celo',
  @start_step_id = 1,
  @notify_level_eventlog = 0,
  @notify_level_email = 2,
  @notify_email_operator_name = 'Angel',
  @delete_level = 0

EXEC sp_add_jobstep
  @job_name = 'Verificar último celo femenino',
  @step_name = 'Comprobar último celo',
  @subsystem = 'TSQL',
  @command = 'EXEC registro.VerificarUltimoCeloFemenino',
  @retry_attempts = 0,
  @retry_interval = 0,
  @output_file_name = 'C:\Logs\VerificarUltimoCeloFemenino.txt'

EXEC sp_add_schedule
  @schedule_name = 'Ejecutar cada día a las 9 de la mañana',
  @freq_type = 4,
  @freq_interval = 1,
  @active_start_time = 90000

EXEC sp_attach_schedule
  @job_name = 'Verificar último celo femenino',
  @schedule_name = 'Ejecutar cada día a las 9 de la mañana'
  
EXEC sp_add_jobserver
  @job_name = 'Verificar último celo femenino',
  @server_name = 'DESKTOP-B9S7PAR'

UPDATE registro.SERVICIOS_SOLICITADOS
SET Cantidad_Aplicada = Cantidad_Unidad


--EJECUTAR PLAN DE EJECUCION 2 (Maria y Luna)

UPDATE registro.SERVICIOS_SOLICITADOS
SET Total = Cantidad_Aplicada * Precio_Unidad_Cobrado


EXEC facturacion.spActualizarTotalFactura @Factura_ID = 103
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 104
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 105
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 107
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 110
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 111
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 112
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 113
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 114
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 115
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 116
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 117
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 117
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 118
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 123
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 124
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 126
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 129
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 130
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 132
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 134
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 136
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 138
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 139
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 141
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 142
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 143
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 146
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 151
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 151
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 152
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 157
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 158
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 160
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 164
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 168
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 169
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 170
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 172
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 175
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 176
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 177
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 179
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 180
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 185
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 186
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 189
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 191
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 192
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 193
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 194

insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (5, 5);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (10, 10);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (15, 15);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (20, 20);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (25, 25);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (30, 30);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (35, 35);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (40, 40);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (45, 45);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (50, 50);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (55, 9);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (60, 14);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (65, 19);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (70, 24);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (75, 29);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (80, 34);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (85, 39);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (90, 44);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (95, 49);
insert into registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID) values (100, 8);


insert into registro.MASCOTA_RESERVACION (Reservacion_ID, Mascota_ID, Habitacion_ID, Descuento, Monto_Estadia, Pertenencias) values (5, 5, 4, 0.8, 1000, 'dolor sit amet consectetuer adipiscing');
insert into registro.MASCOTA_RESERVACION (Reservacion_ID, Mascota_ID, Habitacion_ID, Descuento, Monto_Estadia, Pertenencias) values (10, 10, 14, 0.16, 1000, 'nulla suspendisse potenti cras in purus eu');
insert into registro.MASCOTA_RESERVACION (Reservacion_ID, Mascota_ID, Habitacion_ID, Descuento, Monto_Estadia, Pertenencias) values (15, 15, 25, 0.17, 1000, 'velit eu est congue elementum in hac habitasse');
insert into registro.MASCOTA_RESERVACION (Reservacion_ID, Mascota_ID, Habitacion_ID, Descuento, Monto_Estadia, Pertenencias) values (20, 20, 21, 0.99, 1000, 'dictumst maecenas ut massa quis augue');
insert into registro.MASCOTA_RESERVACION (Reservacion_ID, Mascota_ID, Habitacion_ID, Descuento, Monto_Estadia, Pertenencias) values (25, 25, 19, 0.36, 1000, 'justo in hac habitasse platea');
insert into registro.MASCOTA_RESERVACION (Reservacion_ID, Mascota_ID, Habitacion_ID, Descuento, Monto_Estadia, Pertenencias) values (30, 30, 7, 0.96, 1000, 'primis in faucibus orci luctus et ultrices posuere');
insert into registro.MASCOTA_RESERVACION (Reservacion_ID, Mascota_ID, Habitacion_ID, Descuento, Monto_Estadia, Pertenencias) values (35, 35, 21, 0.38, 1000, 'ultrices enim lorem ipsum dolor');
insert into registro.MASCOTA_RESERVACION (Reservacion_ID, Mascota_ID, Habitacion_ID, Descuento, Monto_Estadia, Pertenencias) values (40, 40, 24, 0.17, 1000, 'cras mi pede malesuada in');
insert into registro.MASCOTA_RESERVACION (Reservacion_ID, Mascota_ID, Habitacion_ID, Descuento, Monto_Estadia, Pertenencias) values (45, 45, 12, 0.29, 1000, 'turpis a pede posuere nonummy integer non velit');
insert into registro.MASCOTA_RESERVACION (Reservacion_ID, Mascota_ID, Habitacion_ID, Descuento, Monto_Estadia, Pertenencias) values (50, 50, 28, 0.18, 1000, 'sit amet eleifend pede libero');

UPDATE registro.RESERVACIONES 
SET Monto_Reservacion = Monto_Reservacion + 1000
WHERE Reservacion_ID >= 5 AND Reservacion_ID <= 50 AND Reservacion_ID % 5 =0

UPDATE facturacion.FACTURAS
SET Total_Reservacion = Total_Reservacion + 1000
WHERE Reservacion_ID >= 5 AND Reservacion_ID <= 50 AND Reservacion_ID % 5 =0 AND Total_Reservacion !=0