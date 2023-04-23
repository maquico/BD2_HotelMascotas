
CREATE NONCLUSTERED INDEX IX_DUEÑOS_Nombres_Apellidos_Sector_ID ON registro.[DUEÑOS]([Nombres], [Apellidos], [Sector_ID]); 

CREATE NONCLUSTERED INDEX IX_RESERVACIONES_Dueño_ID_Fecha_Registro ON registro.[RESERVACIONES]([Dueño_ID], [Fecha_Registro]); 

CREATE NONCLUSTERED INDEX IX_FACTURAS_Empleado_ID_Reservacion_ID_Fecha_Emision ON facturacion.[FACTURAS]([Empleado_ID], [Reservacion_ID], [Fecha_Emision]); 

CREATE NONCLUSTERED INDEX IX_Dueño_ID ON registro.MASCOTAS (Dueño_ID); 

CREATE NONCLUSTERED INDEX IX_Factura_ID ON facturacion.FACTURA_PRODUCTOS (Factura_ID); 

CREATE NONCLUSTERED INDEX IX_Reservacion_ID ON registro. SERVICIOS_SOLICITADOS (Reservacion_ID); 

CREATE NONCLUSTERED INDEX IX_Reservacion_ID_Mascota_ID ON registro. SERVICIOS_SOLICITADOS (Reservacion_ID, Mascota_ID); 

CREATE NONCLUSTERED INDEX IX_Reservacion_ID ON registro. MASCOTA_RESERVACION (Reservacion_ID); 

 