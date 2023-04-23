--INSERTAR MASCOTA
EXEC registro.spInsertMascota 
	@Nombre = 'Garfield', 
	@Sexo_ID = 1,
	@Fecha_Nacimiento = '2018-05-01',
	@Peso = 25.4,
	@Especie_ID = 2,
	@Raza_Primaria_ID = 11,
	@Dueño_ID = 1,
	@Microchip = '123456789',
	@Nota = 'Mascota muy amigable',
	@Color_ID = 1,
	@Tarjeta_File_Name = 'fido-tarjeta.jpg',
	@Tarjeta_File_Path = 'C:\\Mascotas\\Tarjetas\\Fido\\',
	@Foto_File_Name = 'fido-foto.jpg',
	@Foto_File_Path = 'C:\\Mascotas\\Fotos\\Fido\\'

--REVISAR QUE SE LE HAYAN ASIGNADO SUS VACUNAS
SELECT * FROM registro.MASCOTA_VACUNA

DELETE FROM registro.HISTORICO_ESTATUS
DELETE FROM registro.RESERVACIONES
DBCC CHECKIDENT('registro.RESERVACIONES', RESEED, 0);
--CAMBIAR POR PROCEDURE
INSERT INTO registro.[RESERVACIONES] (Dueño_ID, Fecha_Inicio, Fecha_Fin)
VALUES (1, '2023-04-10', '2023-04-15');

--CAMBIAR POR PROCEDURE
DELETE FROM registro.MASCOTA_RESERVACION
INSERT INTO registro.[MASCOTA_RESERVACION] ([Reservacion_ID], [Mascota_ID], [Habitacion_ID], [Monto_Estadia], [Pertenencias], [Descuento])
VALUES (1, 101, 10, registro.fnCalcularMontoEstadia(10, 1, 0.10), 'Comida, Juguete', 0.10);



--Estados de la reservacion
EXEC registro.spActualizarEstatusReservaciones
SELECT * FROM registro.RESERVACIONES
SELECT * FROM registro.HISTORICO_ESTATUS




DELETE FROM facturacion.FACTURAS
DELETE FROM facturacion.FACTURA_PRODUCTOS
--FACTURA MONTO RESERVACION
EXEC facturacion.spInsertFacturas @Empleado_ID = 1, @Reservacion_ID = 18, @Descuentos=0.10
SELECT * FROM facturacion.FACTURAS

SELECT * FROM registro.RESERVACIONES
where Reservacion_ID = 18

SELECT * FROM registro.SERVICIOS_SOLICITADOS
where Reservacion_ID = 18

EXEC facturacion.spActualizarTotalFactura @Factura_ID =6
DELETE FROM registro.HISTORICO_ESTATUS
SELECT * FROM registro.HISTORICO_ESTATUS
SELECT * FROM facturacion.FACTURAS

--FACTURA SERVICIOS Y PRODUCTOS
EXEC facturacion.spInsertFacturas @Empleado_ID = 1, @Reservacion_ID = 18, @Descuentos=0.30

EXEC facturacion.spActualizarTotalFactura @Factura_ID =8

SELECT * FROM facturacion.FACTURAS
SELECT * FROM facturacion.FACTURA_PRODUCTOS


EXEC facturacion.spInsertFacturasProductos @Factura_ID =7, @Producto_ID = 1, @Cantidad = 2, @Descuento = 0.50
EXEC facturacion.spInsertFacturasProductos @Factura_ID =8, @Producto_ID = 10, @Cantidad = 1, @Descuento = 0.10


--VERIFICAR MASCOTA
SELECT * FROM registro.MASCOTAS
SELECT * FROM registro.MASCOTA_VACUNA WHERE Mascota_ID = 105
EXEC registro.spVerificarMascota @Mascota_ID = 105, @Vacuna_ID = 6


