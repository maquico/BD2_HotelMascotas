--Servicios de una reservacion 
CREATE or Alter VIEW registro.vwServiciosReservacion AS
SELECT 
	r.Reservacion_ID,
	d.Nombres + ' ' + d.Apellidos AS Dueño,
	r.Fecha_Inicio, 
	r.Fecha_Fin, 
	m.Nombre AS Mascota, 
	s.Nombre AS Servicio, 
	ss.Precio_Unidad_Cobrado,
	ss.Cantidad_Aplicada AS Cantidad_Aplicada,
	ss.Descuento AS Descuento,
	ss.Total AS Total_Servicio
FROM registro.RESERVACIONES r
JOIN registro.DUEÑOS d ON r.Dueño_ID = d.Dueño_ID
JOIN registro.MASCOTAS m ON r.Dueño_ID = m.Dueño_ID
JOIN registro.Servicios_Solicitados ss ON m.Mascota_ID = ss.Mascota_ID
JOIN adm.SERVICIOS s ON ss.Servicio_ID = s.Servicio_ID;
Go

Select * 
From registro.vwServiciosReservacion
Go

--Habitaciones disponibles actualmente 
CREATE VIEW registro.vwHabitacionesDisponibles AS 
SELECT 
	h.Habitacion_ID, 
	h.Numero, 
	h.Capacidad,
	th.Nombre AS Tipo
FROM adm.HABITACIONES h
JOIN adm.Tipo_Habitacion th ON h.Tipo_Habitacion_ID = th.Tipo_Habitacion_ID
WHERE Ocupada = 0;
Go

Select * 
From registro.vwHabitacionesDisponibles
Go

--Mascotas de un dueño
CREATE VIEW registro.vwMascotasDueños AS
SELECT
	d.Nombres + ' ' + d.Apellidos AS Dueño,
	m.Nombre AS Mascota,
	m.Fecha_Nacimiento AS Fecha_de_Nacimiento,
	m.Peso AS Peso,
	m.Tamaño AS Tamaño,
	e.Nombre AS Especie,
	r.Nombre AS Raza,
	c.Nombre AS Color
FROM registro.DUEÑOS AS d
JOIN registro.DUEÑOS_MASCOTA dm ON d.Dueño_ID = dm.Dueño_ID
JOIN registro.MASCOTAS m ON m.Mascota_ID = dm.Mascota_ID
JOIN adm.ESPECIES e ON m.ESPECIE_ID = e.ESPECIE_ID
JOIN registro.RAZAS r ON m.Raza_Primaria_ID = r.Raza_ID
JOIN registro.COLOR c ON m.Color_ID = c.Color_ID
Go

Select * 
From registro.vwMascotasDueños
Go

--Dueños de una mascota
CREATE VIEW registro.vwDueñosMascotas AS
SELECT
	m.Nombre AS Mascota,
	d.Nombres + ' ' + d.Apellidos AS Dueño,
	d.Telefono AS Telefono,
	d.Correo_Electronico AS Correo_Electronico
FROM registro.MASCOTAS AS m
JOIN registro.DUEÑOS_MASCOTA dm ON m.Mascota_ID = dm.Mascota_ID
JOIN registro.DUEÑOS d ON dm.Dueño_ID = d.Dueño_ID
Go

Select * 
From registro.vwDueñosMascotas
Go

--Facturas de una reservacion 
CREATE or Alter VIEW registro.vwFacturasReservacion AS
SELECT
    f.Factura_ID,
    f.Reservacion_ID,
    d.Nombres + ' ' + d.Apellidos AS Dueño,
	e.Nombres + ' ' + e.Apellidos AS Empleado,
	f.Total_Servicios,
	f.Total_Productos,
	f.Total_Reservacion,
	f.Total,
    f.Descuentos,
	f.Total_Final,
    f.Fecha_Emision
FROM
    facturacion.FACTURAS f
    INNER JOIN registro.RESERVACIONES r ON f.Reservacion_ID = r.Reservacion_ID
    INNER JOIN registro.DUEÑOS d ON r.Dueño_ID = d.Dueño_ID
	INNER JOIN adm.EMPLEADOS e ON f.Empleado_ID = e.Empleado_ID
Go

Select * 
From registro.vwFacturasReservacion
Go

--Total esperado de un servicio solicitado 
CREATE VIEW vwTotalEsperadoServicioSolicitado AS
SELECT 
	ss.Reservacion_ID, 
	s.Nombre AS Nombre_Servicio, 
	ss.Precio_Unidad_Cobrado AS Precio, 
	u.Nombre AS Unidad_Medida, 
	ss.Cantidad_Unidad AS Cantidad, 
	(ss.Precio_Unidad_Cobrado * ss.Cantidad_Unidad) AS Total_Servicio
FROM registro.SERVICIOS_SOLICITADOS ss
INNER JOIN adm.SERVICIOS s ON ss.Servicio_ID = s.Servicio_ID
INNER JOIN adm.UNIDAD u ON s.Unidad_ID = u.Unidad_ID
Go

Select * 
From vwTotalEsperadoServicioSolicitado
Go

--Productos en una Factura
CREATE or Alter VIEW registro.vwFacturasProductos AS
SELECT
    f.Factura_ID,
    f.Reservacion_ID,
    d.Nombres + ' ' + d.Apellidos AS Dueño,
	e.Nombres + ' ' + e.Apellidos AS Empleado,
	p.Nombre AS Producto,
	fp.Cantidad AS Cantidad,
	fp.Precio_Unidad AS Precio_Unidad,
	fp.Descuento AS Descuento,
    fp.Total AS Total
FROM
    facturacion.FACTURAS f
    INNER JOIN registro.RESERVACIONES r ON f.Reservacion_ID = r.Reservacion_ID
    INNER JOIN registro.DUEÑOS d ON r.Dueño_ID = d.Dueño_ID
	INNER JOIN adm.EMPLEADOS e ON f.Empleado_ID = e.Empleado_ID
	INNER JOIN facturacion.FACTURA_PRODUCTOS fp ON f.Factura_ID = fp.Factura_ID
	INNER JOIN adm.PRODUCTOS p ON fp.Producto_ID = p.Producto_ID
Go

Select * 
From registro.vwFacturasProductos
Go