--SE REGISTRA EL DUEÑO
EXEC registro.spInsertDueño 
	@Nombres = 'Angel Gabriel',
    @Apellidos = 'Moreno Reyes',
    @Telefono = '829-764-0186',
    @Correo_Electronico = 'angelgmorenor@gmail.com',
    @Sector_ID = 62,
    @Calle = 'San Juan Bautista de La Salle',
    @Numero_Casa = 92,
    @Descripcion = 'joven',
    @Fecha_Nacimiento = '2003-05-27'

	EXEC registro.spGetDueñoById @Dueño_ID = 101

--REGISTRAR A LA MASCOTA
GO
DELETE FROM registro.MASCOTA_VACUNA --
DELETE FROM registro.DUEÑOS_MASCOTA --
DELETE FROM registro.MASCOTAS
DBCC CHECKIDENT('registro.MASCOTAS', RESEED, 0);

EXEC registro.spInsertMascota @Nombre = 'Maiki', @Sexo_ID = 1, @Fecha_Nacimiento = '2022-07-08', @Peso = 14, @Fecha_Ultimo_Celo = null, @Especie_ID = 1,
							@Raza_Primaria_ID = 5, @Dueño_ID = 101, @Microchip = '442112-0', @Nota = 'Perrito amigable con humanos territorial con machos', 
							@Color_ID = 10, @Tarjeta_File_Name = 'File.pdf',@Tarjeta_File_Path = 'C:/Hotel_Mascotas/Mascotas/file/', @Foto_File_Name='FotoFile.jpg', @Foto_File_Path = 'C:/Hotel_Mascotas/Mascotas/fotos/'

EXEC registro.spGetMascotaById @Mascota_ID = 51 

--Opcional -> Se registran CONDICIONES MEDICAS y/o CONTACTOS DE EMERGENCIA para la mascota

--SE COLOCAN LAS FECHAS DE VENCIMIENTO DE LAS VACUNAS
EXEC registro.spUpdateMascotaVacuna @Mascota_ID = 51, @Vacuna_ID = 1, @Fecha_Vencimiento = '2024-04-15'
EXEC registro.spUpdateMascotaVacuna @Mascota_ID = 51, @Vacuna_ID = 2, @Fecha_Vencimiento = '2024-04-15'
EXEC registro.spUpdateMascotaVacuna @Mascota_ID = 51, @Vacuna_ID = 3, @Fecha_Vencimiento = '2024-04-15'

--SE VALIDAN LAS VACUNAS DE LA MASCOTA
EXEC registro.spVerificarMascota @Mascota_ID = 51, @Vacuna_ID = 1
EXEC registro.spVerificarMascota @Mascota_ID = 51, @Vacuna_ID = 2

--REGISTRAR UNA RESERVACION
DBCC CHECKIDENT('registro.RESERVACIONES', RESEED, 0);
DELETE FROM registro.RESERVACIONES
DELETE FROM registro.HISTORICO_ESTATUS
EXEC registro.spInsertReservaciones
@Dueño_ID = 101, 
@Fecha_Inicio = '2023/04/15',
@Fecha_Fin = '2023/04/17'
EXEC registro.spGetReservacionesById @Reservacion_ID = 1


--AGREGAMOS MASCOTAS A LA RESERVACION
EXEC registro.spInsertMascotaReservacion
	@Reservacion_ID = 1,
    @Mascota_ID = 51,
    @Habitacion_ID = 10,
    @Pertenencias = 'Correa roja, y collar azul',
	@Descuento = null
	--Se valida la vacuna que faltaba
EXEC registro.spVerificarMascota @Mascota_ID = 51, @Vacuna_ID = 3
	--Ahora si, se inserta la mascota
EXEC registro.spInsertMascotaReservacion
	@Reservacion_ID = 1,
    @Mascota_ID = 50,
    @Habitacion_ID = 25,
    @Pertenencias = 'Correa roja, y collar azul',
	@Descuento = null
	--Consultamos que se registro la mascota en nuestra reservacion
EXEC registro.spGetMascotaReservacionById @Reservacion_ID = 1, @Mascota_ID = 51
	--Consultamos la habitacion y su tipo para comprobar que se nos cobro el monto de estadia correcto
EXEC registro.spGetHabitacionesById @Habitacion_ID = 10
EXEC registro.spGetTipoHabitacionById @Tipo_Habitacion_ID = 3
	--Consultamos que en la reservacion, se añadio el monto de estadia de la mascota agregada
EXEC registro.spGetReservacionesById @Reservacion_ID = 1

--GENERAMOS LA FACTURA DE RESERVACION
EXEC facturacion.spInsertFacturas @Empleado_ID = 1, @Reservacion_ID = 1, @Descuentos = 0.05
SELECT * FROM facturacion.FACTURAS WHERE Reservacion_ID = 1
GO
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 1
	--Consultamos que la factura tiene en su total el monto de reservacion de la Reservacion asociada
	EXEC facturacion.spGetFacturasByID @Factura_ID = 1

--AGREGAMOS SERVICIOS A LA RESERVACION
EXEC registro.spInsertServiciosSolicitados
@Servicio_ID = 1, --Baño
@Reservacion_ID = 1,
@Mascota_ID = 51,
@Cantidad_Unidad = 1,
@Descuento = 0.10;

EXEC registro.spInsertServiciosSolicitados
@Servicio_ID = 2, --Corte de uña
@Reservacion_ID = 1,
@Mascota_ID = 51,
@Cantidad_Unidad = 1,
@Descuento = 0.20;

EXEC registro.spInsertServiciosSolicitados
@Servicio_ID = 7, --Spa
@Reservacion_ID = 1,
@Mascota_ID = 51,
@Cantidad_Unidad = 2,
@Descuento = 0;

DELETE FROM registro.SERVICIOS_SOLICITADOS
--CAMBIAR POR VISTA
SELECT * FROM registro.SERVICIOS_SOLICITADOS WHERE Reservacion_ID = 1
	
--EMPIEZA LA RESERVACION
	--Actualizamos el estado de la reservacion, este procedimiento se ejecuta por un job
EXEC registro.spActualizarEstatusReservaciones
	--Revisamos que se actualizo el estado de la reservacion
EXEC registro.spGetReservacionesById @Reservacion_ID = 1
	--Se insertan los estados en el historico de estados de la reservacion
EXEC registro.spGetHistoricoEstatusByReservacionID @Reservacion_ID = 1
	
	--Los empleados registran que aplicaron los servicios
EXEC registro.spAgregarServicioAplicado @Reservacion_ID = 1, @Servicio_ID = 1, @Mascota_ID = 51
EXEC registro.spAgregarServicioAplicado @Reservacion_ID = 1, @Servicio_ID = 2, @Mascota_ID = 51
EXEC registro.spAgregarServicioAplicado @Reservacion_ID = 1, @Servicio_ID = 7, @Mascota_ID = 51
EXEC registro.spAgregarServicioAplicado @Reservacion_ID = 1, @Servicio_ID = 7, @Mascota_ID = 51

	--Consultamos que los servicios se aplicaron correctamente
SELECT * FROM registro.SERVICIOS_SOLICITADOS WHERE Reservacion_ID = 1
	--Consultamos que en el historico de servicios se guardo cada vez que un empleado aplico un servicios
SELECT * FROM registro.HISTORICO_SERVICIOS WHERE Reservacion_ID = 1

--GENERAMOS FACTURA FINAL CON SERVICIOS Y PRODUCTOS
EXEC facturacion.spInsertFacturas @Empleado_ID = 1, @Reservacion_ID = 1, @Descuentos = 0.05
SELECT * FROM facturacion.FACTURAS WHERE Reservacion_ID = 1
GO
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 2
--Consultamos que la factura tiene en su total el monto de los servicios
	EXEC facturacion.spGetFacturasByID @Factura_ID = 2

	--Agregamos un producto
EXEC facturacion.spInsertFacturasProductos @Factura_ID = 2, @Producto_ID = 8, @Cantidad = 1, @Descuento = 0.00

	--Revisamos el precio del producto
EXEC adm.spGetProductosByID @Producto_ID = 5

	--Consultamos que la factura tiene en su total el monto de los productos
	EXEC facturacion.spGetFacturasByID @Factura_ID = 2

--Actualizamos la fecha de la reservacion para que acabe en la demostracion
EXEC registro.spUpdateReservaciones @Reservacion_ID = 1, @Dueño_ID=null, @Fecha_Inicio=null, @Fecha_Fin='2023-04-16', @Descuento=null, @Estatus_ID =null
--Ejecutamos el procedure que actualiza los estados de las reservaciones en base a la fecha actual
EXEC registro.spActualizarEstatusReservaciones
--Consultamos que el estado de la reservacion es 3, finalizada
EXEC registro.spGetReservacionesById @Reservacion_ID = 1

--RESERVACION FINALIZADA
--GRACIAS :D