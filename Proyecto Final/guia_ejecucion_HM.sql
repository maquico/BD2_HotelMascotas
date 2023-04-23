--GRUPO 4 - HOTEL MASCOTAS
--ANGEL MORENO 1104666
--ALLEN SILVERIO 1104220
--ROLBIK URBAEZ 1105721
--GLEIDY ESPINAL 1104225
USE Hotel_Mascotas_DB

--Aquí tienes el plan de ejecución en T-SQL con datos diferentes:

--REGISTRAR UN DUEÑO
EXEC registro.spInsertDueño
@Nombres = 'Mercedes',
@Apellidos = 'González',
@Telefono = '829-123-4567',
@Correo_Electronico = 'mercedesgonzalez@gmail.com',
@Sector_ID = 17,
@Calle = 'Calle Duarte',
@Numero_Casa = 24,
@Descripcion = 'adulto',
@Fecha_Nacimiento = '1985-02-10'

EXEC registro.spGetDueñoById @Dueño_ID = 103

--REGISTRAR A LA MASCOTA
EXEC registro.spInsertMascota @Nombre = 'Lola', @Sexo_ID = 4, @Fecha_Nacimiento = '2020-04-01', @Peso = 7, @Fecha_Ultimo_Celo = '2022-02-15', @Especie_ID = 2,
@Raza_Primaria_ID = 12, @Dueño_ID = 103, @Microchip = '548912-5', @Nota = 'Gata muy activa y cariñosa',
@Color_ID = 7, @Tarjeta_File_Name = 'Tarjeta.pdf',@Tarjeta_File_Path = 'C:/Hotel_Mascotas/Tarjetas/', @Foto_File_Name='FotoLuna.jpg', @Foto_File_Path = 'C:/Hotel_Mascotas/Fotos/'

EXEC registro.spGetMascotaById @Mascota_ID = 53

--Opcional -> Se registran CONDICIONES MEDICAS y/o CONTACTOS DE EMERGENCIA para la mascota

--SE COLOCAN LAS FECHAS DE VENCIMIENTO DE LAS VACUNAS
EXEC registro.spUpdateMascotaVacuna @Mascota_ID = 53, @Vacuna_ID = 6, @Fecha_Vencimiento = '2024-10-15'
EXEC registro.spUpdateMascotaVacuna @Mascota_ID = 53, @Vacuna_ID = 7, @Fecha_Vencimiento = '2024-10-15'

--SE VALIDAN LAS VACUNAS DE LA MASCOTA
EXEC registro.spVerificarMascota @Mascota_ID = 53, @Vacuna_ID = 6
EXEC registro.spVerificarMascota @Mascota_ID = 53, @Vacuna_ID = 7

EXEC registro.spGetMascotaVacunaById @Mascota_ID = 53, @Vacuna_ID = 6
EXEC registro.spGetMascotaVacunaById @Mascota_ID = 53, @Vacuna_ID = 7

--REGISTRAR UNA RESERVACION
EXEC registro.spInsertReservaciones
@Dueño_ID = 103,
@Fecha_Inicio = '2023/04/10',
@Fecha_Fin = '2023/04/20'
EXEC registro.spGetReservacionesById @Reservacion_ID = 103

--AGREGAMOS MASCOTAS A LA RESERVACION
EXEC registro.spInsertMascotaReservacion
@Reservacion_ID = 103,
@Mascota_ID = 53,
@Habitacion_ID = 5,
@Pertenencias = 'Juguetes favoritos, comida',
@Descuento = null

--Se valida la vacuna que faltaba
EXEC registro.spVerificarMascota @Mascota_ID = 53, @Vacuna_ID =2

--Ahora si, se inserta la mascota
EXEC registro.spInsertMascotaReservacion
@Reservacion_ID = 103,
@Mascota_ID = 53,
@Habitacion_ID = 5,
@Pertenencias = 'Juguetes favoritos, cama y comida',
@Descuento = null
--Consultamos que se registro la mascota en nuestra reservacion
EXEC registro.spGetMascotaReservacionById @Reservacion_ID = 103, @Mascota_ID = 53
--Consultamos la habitacion y su tipo para comprobar que se nos cobro el monto de estadia correcto
EXEC registro.spGetHabitacionesById @Habitacion_ID = 5
EXEC registro.spGetTipoHabitacionById @Tipo_Habitacion_ID = 2
--Consultamos que en la reservacion, se añadio el monto de estadia de la mascota agregada
EXEC registro.spGetReservacionesById @Reservacion_ID = 103

--GENERAMOS LA FACTURA DE RESERVACION
EXEC facturacion.spInsertFacturas @Empleado_ID = 2, @Reservacion_ID = 103, @Descuentos = 0.10
EXEC facturacion.spVistaFacturasReservacion @Reservacion_ID = 103
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 205
--Consultamos que la factura tiene en su total el monto de reservacion de la Reservacion asociada
EXEC facturacion.spGetFacturasByID @Factura_ID = 205

--AGREGAMOS SERVICIOS A LA RESERVACION
EXEC registro.spInsertServiciosSolicitados
@Servicio_ID = 3, --Paseo
@Reservacion_ID = 103,
@Mascota_ID = 53,
@Cantidad_Unidad = 2,
@Descuento = 0.10;

EXEC registro.spInsertServiciosSolicitados
@Servicio_ID = 4, --Corte de pelo
@Reservacion_ID = 103,
@Mascota_ID = 53,
@Cantidad_Unidad = 1,
@Descuento = 0.15;

EXEC registro.spInsertServiciosSolicitados
@Servicio_ID = 6, --Comida Premium
@Reservacion_ID = 103,
@Mascota_ID = 53,
@Cantidad_Unidad = 1,
@Descuento = 0;

--Consultamos que se agregaron los servicios a la reservacion
EXEC facturacion.spVistaServiciosReservacion @Reservacion_ID = 103

--EMPIEZA LA RESERVACION
--Actualizamos el estado de la reservacion, este procedimiento se ejecuta por un job
EXEC registro.spActualizarEstatusReservaciones
--Revisamos que se actualizo la habitacion y ahora esta ocupada
registro.spGetHabitacionByReservacionId @Reservacion_ID = 103  
--Revisamos que se actualizo el estado de la reservacion
EXEC registro.spGetReservacionesById @Reservacion_ID = 103


--Se insertan los estados en el historico de estados de la reservacion
EXEC registro.spGetHistoricoEstatusByReservacionID @Reservacion_ID = 103

EXEC registro.spAgregarServicioAplicado @Reservacion_ID = 103, @Servicio_ID = 3, @Mascota_ID = 53
EXEC registro.spAgregarServicioAplicado @Reservacion_ID = 103, @Servicio_ID = 3, @Mascota_ID = 53
EXEC registro.spAgregarServicioAplicado @Reservacion_ID = 103, @Servicio_ID = 4, @Mascota_ID = 53
EXEC registro.spAgregarServicioAplicado @Reservacion_ID = 103, @Servicio_ID = 6, @Mascota_ID = 53


--Consultamos que se aplicaron los servicios a la reservacion   
EXEC facturacion.spVistaServiciosReservacion @Reservacion_ID = 103
--Consultamos que en el historico de servicios se guardo cada vez que un empleado aplico un servicios
EXEC registro.spGetHistoricoServiciosByReservacionID @Reservacion_ID = 103

--GENERAMOS FACTURA FINAL CON SERVICIOS Y PRODUCTOS
EXEC facturacion.spInsertFacturas @Empleado_ID = 2, @Reservacion_ID = 103, @Descuentos = 0.10
EXEC facturacion.spVistaFacturasReservacion @Reservacion_ID = 103
GO
EXEC facturacion.spActualizarTotalFactura @Factura_ID = 206
--Consultamos que la factura tiene en su total el monto de los servicios
EXEC facturacion.spGetFacturasByID @Factura_ID = 206

EXEC facturacion.spInsertFacturasProductos @Factura_ID = 206, @Producto_ID = 7, @Cantidad = 3, @Descuento = 0.05
EXEC adm.spGetProductosByID @Producto_ID = 7

--Consultamos que la factura tiene en su total el monto de los productos
EXEC facturacion.spGetFacturasByID @Factura_ID = 206

--Actualizamos la fecha de la reservacion para que acabe en la demostracion
EXEC registro.spUpdateReservaciones @Reservacion_ID = 103, @Dueño_ID=null, @Fecha_Inicio=null, @Fecha_Fin='2023-04-16', @Descuento=null, @Estatus_ID =null
--Ejecutamos el procedure que actualiza los estados de las reservaciones en base a la fecha actual
EXEC registro.spActualizarEstatusReservaciones
--Consultamos que el estado de la reservacion es 3, finalizada
EXEC registro.spGetReservacionesById @Reservacion_ID = 103

--RESERVACION FINALIZADA
--GRACIAS :D

