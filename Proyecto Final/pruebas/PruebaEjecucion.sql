USE Hotel_Mascotas_DB

--Aquí tienes el plan de ejecución en T-SQL con datos diferentes:

--REGISTRAR UN DUEÑO
EXEC registro.spInsertDueño
@Nombres = 'Maria',
@Apellidos = 'González',
@Telefono = '829-123-4567',
@Correo_Electronico = 'mariagonzalez@gmail.com',
@Sector_ID = 17,
@Calle = 'Calle Duarte',
@Numero_Casa = 24,
@Descripcion = 'adulto',
@Fecha_Nacimiento = '1985-02-10'

EXEC registro.spGetDueñoById @Dueño_ID = 102

--REGISTRAR A LA MASCOTA
EXEC registro.spInsertMascota @Nombre = 'Luna', @Sexo_ID = 4, @Fecha_Nacimiento = '2020-04-01', @Peso = 7, @Fecha_Ultimo_Celo = '2022-02-15', @Especie_ID = 2,
@Raza_Primaria_ID = 8, @Dueño_ID = 102, @Microchip = '548912-5', @Nota = 'Gata muy activa y cariñosa',
@Color_ID = 7, @Tarjeta_File_Name = 'Tarjeta.pdf',@Tarjeta_File_Path = 'C:/Hotel_Mascotas/Tarjetas/', @Foto_File_Name='FotoLuna.jpg', @Foto_File_Path = 'C:/Hotel_Mascotas/Fotos/'

EXEC registro.spGetMascotaById @Mascota_ID = 52

--Opcional -> Se registran CONDICIONES MEDICAS y/o CONTACTOS DE EMERGENCIA para la mascota

--SE COLOCAN LAS FECHAS DE VENCIMIENTO DE LAS VACUNAS
EXEC registro.spUpdateMascotaVacuna @Mascota_ID = 52, @Vacuna_ID = 4, @Fecha_Vencimiento = '2024-10-15'
EXEC registro.spUpdateMascotaVacuna @Mascota_ID = 52, @Vacuna_ID = 5, @Fecha_Vencimiento = '2024-10-15'

--SE VALIDAN LAS VACUNAS DE LA MASCOTA
EXEC registro.spVerificarMascota @Mascota_ID = 52, @Vacuna_ID = 4
EXEC registro.spVerificarMascota @Mascota_ID = 52, @Vacuna_ID = 5

EXEC registro.spGetMascotaVacunaById @Mascota_ID = 52, @Vacuna_ID = 2

--REGISTRAR UNA RESERVACION
EXEC registro.spInsertReservaciones
@Dueño_ID = 102,
@Fecha_Inicio = '2023/05/01',
@Fecha_Fin = '2023/05/05'
EXEC registro.spGetReservacionesById @Reservacion_ID = 102

--AGREGAMOS MASCOTAS A LA RESERVACION
EXEC registro.spInsertMascotaReservacion
@Reservacion_ID = 102,
@Mascota_ID = 52,
@Habitacion_ID = 5,
@Pertenencias = 'Juguetes favoritos, cama y comida',
@Descuento = null

--Se valida la vacuna que faltaba
EXEC registro.spVerificarMascota @Mascota_ID = 52, @Vacuna_ID =2

--Ahora si, se inserta la mascota
EXEC registro.spInsertMascotaReservacion
@Reservacion_ID = 102,
@Mascota_ID = 52,
@Habitacion_ID = 5,
@Pertenencias = 'Juguetes favoritos, cama y comida',
@Descuento = null
--Consultamos que se registro la mascota en nuestra reservacion
EXEC registro.spGetMascotaReservacionById @Reservacion_ID = 102, @Mascota_ID = 52
--Consultamos la habitacion y su tipo para comprobar que se nos cobro el monto de estadia correcto
EXEC registro.spGetHabitacionesById @Habitacion_ID = 5
EXEC registro.spGetTipoHabitacionById @Tipo_Habitacion_ID = 2
--Consultamos que en la reservacion, se añadio el monto de estadia de la mascota agregada
EXEC registro.spGetReservacionesById @Reservacion_ID = 102

--GENERAMOS LA FACTURA DE RESERVACION
EXEC facturacion.spInsertFacturas @Empleado_ID = 2, @Reservacion_ID = 102, @Descuentos = 0.10
SELECT * FROM facturacion.FACTURAS WHERE Reservacion_ID = 102
GO
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 203
--Consultamos que la factura tiene en su total el monto de reservacion de la Reservacion asociada
EXEC facturacion.spGetFacturasByID @Factura_ID = 203

--AGREGAMOS SERVICIOS A LA RESERVACION
EXEC registro.spInsertServiciosSolicitados
@Servicio_ID = 3, --Paseo
@Reservacion_ID = 102,
@Mascota_ID = 52,
@Cantidad_Unidad = 2,
@Descuento = 0.10;

EXEC registro.spInsertServiciosSolicitados
@Servicio_ID = 4, --Baño de gatos
@Reservacion_ID = 102,
@Mascota_ID = 52,
@Cantidad_Unidad = 1,
@Descuento = 0.15;

EXEC registro.spInsertServiciosSolicitados
@Servicio_ID = 6, --Corte de pelo
@Reservacion_ID = 102,
@Mascota_ID = 52,
@Cantidad_Unidad = 1,
@Descuento = 0;

--CAMBIAR POR VISTA
SELECT * FROM registro.SERVICIOS_SOLICITADOS WHERE Reservacion_ID = 102

--EMPIEZA LA RESERVACION
--Actualizamos el estado de la reservacion, este procedimiento se ejecuta por un job
EXEC registro.spActualizarEstatusReservaciones
--Revisamos que se actualizo el estado de la reservacion
EXEC registro.spGetReservacionesById @Reservacion_ID = 102

UPDATE registro.RESERVACIONES SET Fecha_Inicio = '2023/04/17', Fecha_Fin = '2023/04/18'
WHERE  Reservacion_ID = 102

--Se insertan los estados en el historico de estados de la reservacion
EXEC registro.spGetHistoricoEstatusByReservacionID @Reservacion_ID = 102

EXEC registro.spAgregarServicioAplicado @Reservacion_ID = 102, @Servicio_ID = 3, @Mascota_ID = 52
EXEC registro.spAgregarServicioAplicado @Reservacion_ID = 102, @Servicio_ID = 4, @Mascota_ID = 52

EXEC registro.spAgregarServicioAplicado @Reservacion_ID = 102, @Servicio_ID = 6, @Mascota_ID = 52

SELECT * FROM registro.SERVICIOS_SOLICITADOS WHERE Reservacion_ID = 1
--Consultamos que en el historico de servicios se guardo cada vez que un empleado aplico un servicios
SELECT * FROM registro.HISTORICO_SERVICIOS WHERE Reservacion_ID = 102

--GENERAMOS FACTURA FINAL CON SERVICIOS Y PRODUCTOS
EXEC facturacion.spInsertFacturas @Empleado_ID = 2, @Reservacion_ID = 102, @Descuentos = 0.10
SELECT * FROM facturacion.FACTURAS WHERE Reservacion_ID = 102
GO
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 203
--Consultamos que la factura tiene en su total el monto de los servicios
EXEC facturacion.spGetFacturasByID @Factura_ID = 203

EXEC facturacion.spInsertFacturasProductos @Factura_ID = 203, @Producto_ID = 7, @Cantidad = 3, @Descuento = 0.05
EXEC adm.spGetProductosByID @Producto_ID = 7

--Consultamos que la factura tiene en su total el monto de los productos
EXEC facturacion.spGetFacturasByID @Factura_ID = 203

--Actualizamos la fecha de la reservacion para que acabe en la demostracion
EXEC registro.spUpdateReservaciones @Reservacion_ID = 102, @Dueño_ID=null, @Fecha_Inicio=null, @Fecha_Fin='2023-04-17', @Descuento=null, @Estatus_ID =null
--Ejecutamos el procedure que actualiza los estados de las reservaciones en base a la fecha actual
EXEC registro.spActualizarEstatusReservaciones
--Consultamos que el estado de la reservacion es 3, finalizada
EXEC registro.spGetReservacionesById @Reservacion_ID = 102

--RESERVACION FINALIZADA
--GRACIAS :D

