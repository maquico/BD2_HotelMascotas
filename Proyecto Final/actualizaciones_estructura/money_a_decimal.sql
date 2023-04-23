ALTER TABLE [registro].[RESERVACIONES] DROP CONSTRAINT [DF__RESERVACI__Monto__619B8048]
GO

ALTER TABLE registro.RESERVACIONES
DROP COLUMN Monto_Reservacion

ALTER TABLE registro.RESERVACIONES
ADD Monto_Reservacion decimal(10,2) NOT NULL DEFAULT 0


 
 ALTER TABLE [facturacion].[FACTURAS] DROP CONSTRAINT [DF__FACTURAS__Total___68487DD7]
GO

ALTER TABLE [facturacion].[FACTURAS] DROP CONSTRAINT [DF__FACTURAS__Total__66603565]
GO

ALTER TABLE facturacion.FACTURAS 
DROP COLUMN Total

ALTER TABLE facturacion.FACTURAS 
ADD Total Decimal(10,2) NOT NULL DEFAULT 0

ALTER TABLE facturacion.FACTURAS 
DROP COLUMN Total_Final

ALTER TABLE facturacion.FACTURAS 
ADD Total_Final Decimal(10,2) NOT NULL DEFAULT 0

ALTER TABLE adm.TIPO_HABITACION
ALTER COLUMN Precio_Dia Decimal(10,2) NOT NULL

ALTER TABLE adm.SERVICIOS
ALTER COLUMN Precio_Unidad Decimal(10,2) NOT NULL

ALTER TABLE facturacion.FACTURAS_METODOS_PAGOS
ALTER COLUMN Monto_Con_Metodo Decimal(10,2) NOT NULL

ALTER TABLE [registro].[MASCOTA_RESERVACION] DROP CONSTRAINT [DF__MASCOTA_R__Monto__03F0984C]
GO

ALTER TABLE registro.MASCOTA_RESERVACION
DROP COLUMN Monto_Estadia

ALTER TABLE registro.MASCOTA_RESERVACION
ADD Monto_Estadia Decimal(10,2) NOT NULL DEFAULT 0

ALTER TABLE adm.PRODUCTOS
ALTER COLUMN Precio_Unidad Decimal(10,2) NOT NULL

ALTER TABLE facturacion.FACTURA_PRODUCTOS
ALTER COLUMN Precio_Unidad Decimal(10,2) NOT NULL