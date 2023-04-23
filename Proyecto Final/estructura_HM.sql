--GRUPO 4 - HOTEL MASCOTAS
--ANGEL MORENO 1104666
--ALLEN SILVERIO 1104220
--ROLBIK URBAEZ 1105721
--GLEIDY ESPINAL 1104225
GO
USE NORTHWND
GO
DROP DATABASE Hotel_Mascotas_DB
GO
CREATE DATABASE Hotel_Mascotas_DB
COLLATE SQL_Latin1_General_CP1_CI_AS
GO
USE Hotel_Mascotas_DB;

ALTER DATABASE Hotel_Mascotas_DB SET AUTO_CREATE_STATISTICS ON;

GO
CREATE SCHEMA adm;
GO
CREATE SCHEMA facturacion;
GO
CREATE SCHEMA registro;
GO

CREATE TABLE adm.[ESTATUS] (
  [Estatus_ID] int IDENTITY(1,1) NOT NULL,
  [Nombre] nvarchar(100) NOT NULL
);

CREATE TABLE adm.[SECTOR] (
  [Sector_ID] int IDENTITY(1,1) NOT NULL,
  [Nombre] nvarchar(100) NOT NULL
);

CREATE TABLE registro.[DUEÑOS] (
  [Dueño_ID] int IDENTITY(1,1) NOT NULL,
  [Nombres] nvarchar(100) NOT NULL,
  [Apellidos] nvarchar(100) NOT NULL,
  [Telefono] nvarchar(100) NOT NULL,
  [Correo_Electronico] nvarchar(100) NOT NULL,
  [Sector_ID] int NOT NULL,
  [Calle] nvarchar(100) NOT NULL,
  [Numero_Casa] int NOT NULL,
  [Fecha_Registro] datetime NOT NULL DEFAULT(GETDATE()),
  [Descripcion] nvarchar(100) NOT NULL,
  [Fecha_Nacimiento] datetime NOT NULL
);

CREATE TABLE registro.[RESERVACIONES] (
  [Reservacion_ID] int IDENTITY(1,1) NOT NULL,
  [Dueño_ID] int NOT NULL,
  [Fecha_Registro] datetime NOT NULL DEFAULT(GETDATE()),
  [Estatus_ID] int NOT NULL DEFAULT 1,
  [Fecha_Inicio] datetime NOT NULL,
  [Fecha_Fin] datetime NOT NULL,
  [Monto_Reservacion] decimal(10,2) NOT NULL DEFAULT 0, 
  [Descuento] decimal(3,2) NOT NULL DEFAULT 0
);

CREATE TABLE adm.[EMPLEADOS] (
  [Empleado_ID] int IDENTITY(1,1) NOT NULL,
  [Nombres] nvarchar(100) NOT NULL,
  [Apellidos] nvarchar(100) NOT NULL,
  [Telefono] nvarchar(100) NOT NULL,
  [Correo_Electronico] nvarchar(100) NOT NULL,
  [Sector_ID] int NOT NULL,
  [Calle] nvarchar(100) NOT NULL,
  [Numero_Casa] int NOT NULL,
  [Fecha_Registro] datetime DEFAULT(GETDATE()),
  [Fecha_Nacimiento] datetime NOT NULL
);

CREATE TABLE facturacion.[FACTURAS] (
  [Factura_ID] int IDENTITY(1,1) NOT NULL,
  [Empleado_ID] int NOT NULL,
  [Reservacion_ID] int NOT NULL,
  [Total] decimal(10,2) NOT NULL DEFAULT 0,
  [Descuentos] decimal(3,2) NOT NULL DEFAULT 0,
  [Total_Final] decimal(10,2) NOT NULL DEFAULT 0,
  [Fecha_Emision] datetime NOT NULL DEFAULT(GETDATE())
  [Total_Productos] decimal(10,2) NOT NULL DEFAULT 0
  [Total_Servicios] decimal(10,2) NOT NULL DEFAULT 0
  [Total_Reservacion] decimal(10,2) NOT NULL DEFAULT 0
);

CREATE TABLE adm.[ESPECIES] (
  [Especie_ID] int IDENTITY(1,1) NOT NULL,
  [Nombre] nvarchar(100) NOT NULL
);

CREATE TABLE adm.[TIPO_HABITACION] (
  [Tipo_Habitacion_ID] int IDENTITY(1,1) NOT NULL,
  [Nombre] nvarchar(100) NOT NULL,
  [Precio_Dia] decimal(10,2) NOT NULL
);

CREATE TABLE adm.[UNIDAD] (
  [Unidad_ID] int IDENTITY(1,1) NOT NULL,
  [Nombre] nvarchar(100) NOT NULL
);

CREATE TABLE adm.[SERVICIOS] (
  [Servicio_ID] int IDENTITY(1,1) NOT NULL,
  [Nombre] nvarchar(100) NOT NULL,
  [Unidad_ID] int NOT NULL,
  [Precio_Unidad] decimal(10,2) NOT NULL,
  [Multiplicador_Pequeño] decimal(10, 2) NOT NULL,
  [Multiplicador_Mediano] decimal(10, 2) NOT NULL,
  [Multiplicador_Grande] decimal(10, 2) NOT NULL
);

CREATE TABLE adm.[METODOS_PAGOS] (
  [Metodo_Pago_ID] int IDENTITY(1,1) NOT NULL,
  [Nombre] nvarchar(100) NOT NULL
);

CREATE TABLE facturacion.[FACTURAS_METODOS_PAGOS] (
  [Factura_ID] int NOT NULL,
  [MetodoPago_ID] int NOT NULL,
  [Monto_Con_Metodo]  decimal(10,2) NOT NULL
);

CREATE TABLE registro.[COLOR] (
  [Color_ID] int IDENTITY(1,1) NOT NULL,
  [Nombre] nvarchar(100) NOT NULL
);

CREATE TABLE registro.[RAZAS] (
  [Raza_ID] int IDENTITY(1,1) NOT NULL,
  [Nombre] nvarchar(100) NOT NULL,
  [Especie_ID] int NOT NULL
);

CREATE TABLE adm.[SEXO] (
  [Sexo_ID] int IDENTITY(1,1) NOT NULL,
  [Nombre] nvarchar(100) NOT NULL
);

CREATE TABLE registro.[MASCOTAS] (
  [Mascota_ID] int IDENTITY(1,1) NOT NULL,
  [Nombre] nvarchar(100) NOT NULL,
  [Sexo_ID] int NOT NULL,
  [Fecha_Registro] datetime NOT NULL DEFAULT(GETDATE()),
  [Fecha_Nacimiento] datetime NOT NULL,
  [Peso] decimal (10, 2) NOT NULL,
  [Fecha_Ultimo_Celo] datetime NOT NULL,
  [Tamaño] nvarchar(100) NOT NULL,
  [Especie_ID] int NOT NULL,
  [Raza_Primaria_ID] int NOT NULL,
  [Dueño_ID] int  NOT NULL,
  [Microchip] nvarchar(100) NOT NULL,
  [Nota] nvarchar(200) NOT NULL,
  [Color_ID] int NOT NULL,
  [Tarjeta_File_Name] nvarchar(255) NOT NULL,
  [Tarjeta_File_Path] nvarchar(255) NOT NULL,
  [Foto_File_Name] nvarchar(255) NOT NULL,
  [Foto_File_Path] nvarchar(255) NOT NULL
);

CREATE TABLE adm.[SUPLIDORES] (
  [Suplidor_ID] int IDENTITY(1,1) NOT NULL,
  [Nombre_Empresa] nvarchar(100) NOT NULL,
  [Nombre_Contacto] nvarchar(100) NOT NULL,
  [Telefono_Contacto] nvarchar(100) NOT NULL
);

CREATE TABLE registro.[CONTACTO_EMERGENCIA] (
  [Contacto_Emergencia_ID] int IDENTITY(1,1) NOT NULL,
  [Relacion] nvarchar(100) NOT NULL,
  [Nombres] nvarchar(100) NOT NULL,
  [Apellidos] nvarchar(100) NOT NULL,
  [Telefono] nvarchar(100) NOT NULL,
  [Sector_ID] int NOT NULL,
  [Calle] nvarchar(100) NOT NULL,
  [Numero_Casa] int NOT NULL,
  [Correo_Electronico] nvarchar(100) NOT NULL,
  [Fecha_Registro] datetime NOT NULL DEFAULT(GETDATE()),
  [Fecha_Nacimiento] datetime NOT NULL
);

CREATE TABLE registro.[SERVICIOS_SOLICITADOS] (
  [Servicio_ID] int NOT NULL,
  [Reservacion_ID] int NOT NULL,
  [Mascota_ID] int NOT NULL,
  [Cantidad_Unidad] int NOT NULL,
  [Precio_Unidad_Cobrado] decimal(10,2) NOT NULL,
  [Total] decimal(10,2) NOT NULL DEFAULT 0,
  [Cantidad_Aplicada] int NOT NULL DEFAULT 0,
  [Descuento] decimal (3,2) NOT NULL DEFAULT 0,
  [Cancelado] bit NOT NULL DEFAULT 0
  [Precio_Base] Decimal(10,2) NOT NULL DEFAULT 0
);

CREATE TABLE registro.[MASCOTA_CONTACTO] (
  [Contacto_Emergencia_ID] int NOT NULL,
  [Mascota_ID] int NOT NULL,
  [Fecha_Registro] datetime NOT NULL DEFAULT GETDATE()
);

CREATE TABLE adm.[CATEGORIAS] (
  [Categoria_ID] int IDENTITY(1,1) NOT NULL,
  [Nombre] nvarchar(100) NOT NULL,
  [Descripcion] nvarchar(100) NOT NULL
);

CREATE TABLE adm.[CONDICIONES_MEDICAS] (
  [Condicion_ID] int IDENTITY(1,1) NOT NULL,
  [Nombre] nvarchar(100) NOT NULL
);

CREATE TABLE adm.[HABITACIONES] (
  [Habitacion_ID] int IDENTITY(1,1) NOT NULL,
  [Numero] int NOT NULL,
  [Capacidad] int NOT NULL,
  [Fecha_Registro] datetime NOT NULL DEFAULT(GETDATE()),
  [Ocupada] bit NOT NULL DEFAULT 0,
  [Tipo_Habitacion_ID] int NOT NULL 
);

CREATE TABLE registro.[MASCOTA_RESERVACION] (
  [Reservacion_ID] int NOT NULL,
  [Mascota_ID] int NOT NULL,
  [Habitacion_ID] int NOT NULL,
  [Monto_Estadia] decimal(10,2)NOT NULL DEFAULT 0,
  [Pertenencias] nvarchar(200) NOT NULL,
  [Descuento] decimal(3,2) NOT NULL DEFAULT 0
);

CREATE TABLE adm.[PRODUCTOS] (
  [Producto_ID] int IDENTITY(1,1) NOT NULL,
  [Nombre] nvarchar(100) NOT NULL,
  [Descripcion] nvarchar(100) NOT NULL,
  [Precio_Unidad] decimal(10,2) NOT NULL,
  [Cantidad_Disp] int NOT NULL,
  [Categoria_ID] int NOT NULL,
  [Fecha_Registro] datetime NOT NULL DEFAULT(GETDATE()),
  [Suplidor_ID] int NOT NULL
);

CREATE TABLE registro.[DUEÑOS_MASCOTA] (
  [Dueño_ID] int NOT NULL,
  [Mascota_ID] int NOT NULL,
  [Fecha_Registro] datetime NOT NULL DEFAULT(GETDATE())
);

CREATE TABLE adm.[VACUNAS] (
  [Vacuna_ID] int IDENTITY(1,1) NOT NULL,
  [Nombre] nvarchar(100) NOT NULL
);

CREATE TABLE registro.[MASCOTA_VACUNA] (
  [Mascota_ID] int NOT NULL,
  [Vacuna_ID] int NOT NULL,
  [Fecha_Vencimiento] datetime NOT NULL,
  [Verificado] bit NOT NULL
);

CREATE TABLE registro.[MASCOTA_CONDICION] (
  [Condicion_ID] int NOT NULL,
  [Mascota_ID] int NOT NULL,
  [Fecha_Registro] datetime NOT NULL DEFAULT(GETDATE()),
  [Descripcion] nvarchar(250) NOT NULL
);


CREATE TABLE facturacion.[FACTURA_PRODUCTOS] (
  [Factura_ID] int NOT NULL,
  [Producto_ID] int NOT NULL,
  [Cantidad] int NOT NULL,
  [Precio_Unidad] decimal(10,2) NOT NULL,
  [Descuento] decimal(3,2) NOT NULL DEFAULT 0,
  [Total] decimal(10, 2) NOT NULL DEFAULT 0,
);

CREATE TABLE adm.[ROLES] (
[Rol_ID] int IDENTITY(1,1) NOT NULL,
[Nombre] nvarchar(100) NOT NULL
);

CREATE TABLE adm.[EMPLEADO_ROL] (
[Empleado_ID] int NOT NULL,
[Rol_ID] int NOT NULL,
[Fecha_Registro] datetime NOT NULL DEFAULT(GETDATE())
);

CREATE TABLE registro.[HISTORICO_ESTATUS] (
  [Estatus_ID] int NOT NULL ,
  [Reservacion_ID] int NOT NULL,
  [Fecha_Registro] datetime NOT NULL DEFAULT GETDATE()
);

CREATE TABLE registro.[HISTORICO_SERVICIOS] (
  [Historico_Servicios_ID] int NOT NULL IDENTITY(1,1),
  [Mascota_ID] int NOT NULL,
  [Servicio_ID] int NOT NULL,
  [Reservacion_ID] int NOT NULL,
  [Fecha_Registro] datetime NOT NULL DEFAULT GETDATE()
);


/* Agregando los constraints*/

--Llaves de Estatus
ALTER TABLE adm.ESTATUS 
ADD CONSTRAINT PK_ESTATUS PRIMARY KEY(ESTATUS_ID);

--Llaves de Sector
ALTER  TABLE adm.SECTOR 
ADD CONSTRAINT PK_SECTOR PRIMARY KEY(Sector_ID);

--Llaves de dueños
ALTER  TABLE registro.DUEÑOS ADD CONSTRAINT PK_DUEÑOS PRIMARY KEY (Dueño_ID),
CONSTRAINT FK_DUEÑOS_Sector_ID FOREIGN KEY (Sector_ID) REFERENCES adm.SECTOR(Sector_ID);

--LLaves Reservaciones
ALTER  TABLE registro.RESERVACIONES
ADD CONSTRAINT PK_RESERVACIONES PRIMARY KEY (Reservacion_ID),
CONSTRAINT FK_RESERVACIONES_Estatus_ID FOREIGN KEY (Estatus_ID) REFERENCES adm.ESTATUS(Estatus_ID),
CONSTRAINT FK_RESERVACIONES_Dueño_ID FOREIGN KEY (Dueño_ID) REFERENCES registro.DUEÑOS(Dueño_ID);

--Llaves Empleados
ALTER  TABLE adm.EMPLEADOS
ADD CONSTRAINT PK_EMPLEADOS PRIMARY KEY (Empleado_ID),
CONSTRAINT FK_EMPLEADOS_Sector_ID FOREIGN KEY (Sector_ID) REFERENCES adm.SECTOR(Sector_ID);

--Llaves Facturas
ALTER  TABLE facturacion.FACTURAS
ADD CONSTRAINT PK_FACTURAS PRIMARY KEY (Factura_ID),
CONSTRAINT FK_FACTURAS_Reservacion_ID FOREIGN KEY (Reservacion_ID) REFERENCES registro.RESERVACIONES(Reservacion_ID),
CONSTRAINT FK_FACTURAS_Empleado_ID FOREIGN KEY (Empleado_ID) REFERENCES adm.EMPLEADOS(Empleado_ID);

--Llaves Especies
ALTER  TABLE adm.ESPECIES
ADD CONSTRAINT PK_ESPECIES PRIMARY KEY (Especie_ID);

--Llaves Undidad
ALTER  TABLE adm.UNIDAD
ADD CONSTRAINT PK_UNIDAD PRIMARY KEY (Unidad_ID);

--Llaves Servicios
ALTER  TABLE adm.SERVICIOS
ADD CONSTRAINT PK_SERVICIOS PRIMARY KEY (Servicio_ID),
CONSTRAINT FK_SERVICIOS_Unidad_ID FOREIGN KEY (Unidad_ID) REFERENCES adm.UNIDAD(Unidad_ID);

--Llaves Metodos Pagos
ALTER TABLE adm.METODOS_PAGOS
ADD CONSTRAINT PK_METODOS_PAGOS PRIMARY KEY (Metodo_Pago_ID);

--Llaves Facturas Metodos Pagos
ALTER TABLE facturacion.FACTURAS_METODOS_PAGOS 
ADD CONSTRAINT PK_FACTURAS_METODOS_PAGOS PRIMARY KEY (Factura_ID, MetodoPago_ID),
CONSTRAINT FK_FACTURAS_METODOS_PAGOS_MetodoPago_ID FOREIGN KEY (MetodoPago_ID) REFERENCES adm.METODOS_PAGOS(Metodo_Pago_ID),
CONSTRAINT FK_FACTURAS_METODOS_PAGOS_Factura_ID FOREIGN KEY (Factura_ID) REFERENCES facturacion.FACTURAS(Factura_ID);

--Llaves tipo habitacion
ALTER TABLE adm.TIPO_HABITACION
ADD CONSTRAINT PK_TIPO_HABITACION PRIMARY KEY (Tipo_Habitacion_ID);

--Llaves color
ALTER TABLE registro.COLOR 
ADD CONSTRAINT PK_COLOR PRIMARY KEY (Color_ID);

--Llaves Razas
ALTER TABLE registro.RAZAS
ADD CONSTRAINT PK_RAZAS PRIMARY KEY (Raza_ID),
CONSTRAINT FK_RAZAS_Especie_ID FOREIGN KEY (Especie_ID) REFERENCES adm.ESPECIES(Especie_ID);

--Llaves Seso
ALTER TABLE adm.SEXO
ADD CONSTRAINT PK_SEXO PRIMARY KEY (Sexo_ID);

--Llaves Mascotas
ALTER TABLE registro.MASCOTAS
ADD CONSTRAINT PK_MASCOTAS PRIMARY KEY (Mascota_ID),
CONSTRAINT FK_MASCOTAS_Dueño_ID FOREIGN KEY (Dueño_ID) REFERENCES registro.DUEÑOS(Dueño_ID),
CONSTRAINT FK_MASCOTAS_Raza_Primaria_ID FOREIGN KEY (Raza_Primaria_ID) REFERENCES registro.RAZAS(Raza_ID),
CONSTRAINT FK_MASCOTAS_Especie_ID FOREIGN KEY (Especie_ID) REFERENCES adm.ESPECIES(Especie_ID),
CONSTRAINT FK_MASCOTAS_Sexo_ID FOREIGN KEY (Sexo_ID) REFERENCES adm.SEXO(Sexo_ID),
CONSTRAINT FK_MASCOTAS_Color_ID FOREIGN KEY (Color_ID) REFERENCES registro.COLOR(Color_ID);

--Llaves suplidores
ALTER TABLE adm.SUPLIDORES
ADD CONSTRAINT PK_SUPLIDORES PRIMARY KEY (Suplidor_ID);

--Llaves Contacto Emergencia
ALTER TABLE registro.CONTACTO_EMERGENCIA
ADD CONSTRAINT PK_CONTACTO_EMERGENCIA PRIMARY KEY (Contacto_Emergencia_ID),
CONSTRAINT FK_CONTACTO_EMERGENCIA_Sector_ID FOREIGN KEY (Sector_ID) REFERENCES adm.SECTOR(Sector_ID);

--Llaves Mascota Contacto
ALTER TABLE registro.MASCOTA_CONTACTO
ADD CONSTRAINT PK_MASCOTA_CONTACTO PRIMARY KEY (Mascota_ID, Contacto_Emergencia_ID),
CONSTRAINT FK_MASCOTA_CONTACTO_Contacto_Emergencia_ID FOREIGN KEY (Contacto_Emergencia_ID) REFERENCES registro.CONTACTO_EMERGENCIA(Contacto_Emergencia_ID),
CONSTRAINT FK_MASCOTA_CONTACTO_Mascota_ID FOREIGN KEY (Mascota_ID) REFERENCES registro.MASCOTAS(Mascota_ID);

--Llaves Servicios SOLICITADOS
ALTER TABLE registro.SERVICIOS_SOLICITADOS
ADD CONSTRAINT PK_SERVICIOS_SOLICITADOS PRIMARY KEY (Servicio_ID, Reservacion_ID, Mascota_ID),
CONSTRAINT FK_SERVICIOS_SOLICITADOS_Servicio_ID FOREIGN KEY (Servicio_ID) REFERENCES adm.SERVICIOS(Servicio_ID),
CONSTRAINT FK_SERVICIOS_SOLICITADOS_Reservacion_ID FOREIGN KEY (Reservacion_ID) REFERENCES registro.RESERVACIONES(Reservacion_ID),
CONSTRAINT FK_SERVICIOS_SOLICITADOS_Mascota_ID FOREIGN KEY (Mascota_ID) REFERENCES registro.MASCOTAS(Mascota_ID);

--Llaves Categorias
ALTER TABLE adm.CATEGORIAS
ADD CONSTRAINT PK_CATEGORIAS PRIMARY KEY (Categoria_ID);

--Llaves Habitaciones
ALTER TABLE adm.HABITACIONES
ADD CONSTRAINT PK_HABITACIONES PRIMARY KEY (Habitacion_ID),
CONSTRAINT FK_HABITACIONES_Tipo_Habitacion_ID FOREIGN KEY (Tipo_Habitacion_ID) REFERENCES adm.TIPO_HABITACION(Tipo_Habitacion_ID);

--Llaves Mascota Reservacion Habitacion
ALTER TABLE registro.MASCOTA_RESERVACION
ADD CONSTRAINT PK_MASCOTA_RESERVACION PRIMARY KEY (Reservacion_ID, Mascota_ID),
CONSTRAINT FK_MASCOTA_RESERVACION_Mascota_ID FOREIGN KEY (Mascota_ID) REFERENCES registro.MASCOTAS(Mascota_ID),
CONSTRAINT FK_MASCOTA_RESERVACION_Habitacion_ID FOREIGN KEY (Habitacion_ID) REFERENCES adm.HABITACIONES(Habitacion_ID),
CONSTRAINT FK_MASCOTA_RESERVACION_Reservacion_ID FOREIGN KEY (Reservacion_ID) REFERENCES registro.RESERVACIONES(Reservacion_ID);

--Llaves condiciones medicas
ALTER TABLE adm.CONDICIONES_MEDICAS
ADD CONSTRAINT PK_CONDICIONES_MEDICAS PRIMARY KEY (Condicion_ID);

--Llaves Productos
ALTER TABLE adm.PRODUCTOS
ADD CONSTRAINT PK_PRODUCTOS PRIMARY KEY (Producto_ID),
CONSTRAINT FK_PRODUCTOS_Categoria_ID FOREIGN KEY (Categoria_ID) REFERENCES adm.CATEGORIAS(Categoria_ID),
CONSTRAINT FK_PRODUCTOS_Suplidor_ID FOREIGN KEY (Suplidor_ID) REFERENCES adm.SUPLIDORES(Suplidor_ID);

--Llaves Dueños Mascota
ALTER TABLE registro.DUEÑOS_MASCOTA
ADD CONSTRAINT PK_DUEÑOS_MASCOTA PRIMARY KEY (Dueño_ID, Mascota_ID),
CONSTRAINT FK_DUEÑOS_MASCOTA_Dueño_ID FOREIGN KEY (Dueño_ID) REFERENCES registro.DUEÑOS(Dueño_ID),
CONSTRAINT FK_DUEÑOS_MASCOTA_Mascota_ID FOREIGN KEY (Mascota_ID) REFERENCES registro.MASCOTAS(Mascota_ID)

--Llaves Vacunas
ALTER TABLE adm.VACUNAS
ADD CONSTRAINT PK_VACUNAS PRIMARY KEY (Vacuna_ID)

--Llaves mascota vacuna
ALTER TABLE registro.MASCOTA_VACUNA
ADD CONSTRAINT PK_MASCOTA_VACUNA PRIMARY KEY (Mascota_ID, Vacuna_ID),
CONSTRAINT FK_MASCOTA_VACUNA_Mascota_ID FOREIGN KEY (Mascota_ID) REFERENCES registro.MASCOTAS(Mascota_ID),
CONSTRAINT FK_MASCOTA_VACUNA_Vacuna_ID FOREIGN KEY (Vacuna_ID) REFERENCES adm.VACUNAS(Vacuna_ID);

--Llaves Mascota Condicion
ALTER TABLE registro.MASCOTA_CONDICION
ADD CONSTRAINT PK_MASCOTA_CONDICION PRIMARY KEY (Condicion_ID, Mascota_ID),
CONSTRAINT FK_MASCOTA_CONDICION_Mascota_ID FOREIGN KEY (Mascota_ID) REFERENCES registro.MASCOTAS(Mascota_ID),
CONSTRAINT FK_MASCOTA_CONDICION_Condicion_ID FOREIGN KEY (Condicion_ID) REFERENCES adm.CONDICIONES_MEDICAS(Condicion_ID);

--Llaves Factura Productos
ALTER TABLE facturacion.FACTURA_PRODUCTOS
ADD CONSTRAINT PK_FACTURA_PRODUCTOS PRIMARY KEY (Factura_ID, Producto_ID),
CONSTRAINT FK_FACTURA_PRODUCTOS_Factura_ID FOREIGN KEY (Factura_ID) REFERENCES facturacion.FACTURAS(Factura_ID),
CONSTRAINT FK_FACTURA_PRODUCTOS_Producto_ID FOREIGN KEY (Producto_ID) REFERENCES adm.PRODUCTOS(Producto_ID);

--Llaves Roles
ALTER TABLE adm.ROLES
ADD CONSTRAINT PK_ROLES PRIMARY KEY (Rol_ID);

--Llaves Empleado Rol
ALTER TABLE adm.EMPLEADO_ROL 
ADD CONSTRAINT PK_EMPLEADO_ROL PRIMARY KEY (Rol_ID, Empleado_ID),
CONSTRAINT FK_EMPLEADO_ROL_Rol_ID FOREIGN KEY (Rol_ID) REFERENCES adm.ROLES(Rol_ID),
CONSTRAINT FK_EMPLEADO_ROL_Empleado_ID FOREIGN KEY (Empleado_ID) REFERENCES adm.Empleados(Empleado_ID);

--Llaves de Historico Estatus
ALTER TABLE registro.HISTORICO_ESTATUS
ADD 
CONSTRAINT PK_HISTORICO_ESTATUS PRIMARY KEY([Estatus_ID], [Reservacion_ID]),
CONSTRAINT [FK_HISTORICO_ESTATUS_Estatus_ID] FOREIGN KEY ([Estatus_ID]) REFERENCES adm.[ESTATUS]([Estatus_ID]),
CONSTRAINT [FK_HISTORICO_ESTATUS_Reservacion_ID] FOREIGN KEY ([Reservacion_ID]) REFERENCES registro.[RESERVACIONES]([Reservacion_ID])

--Llaves de Historico Servicios
ALTER TABLE registro.HISTORICO_SERVICIOS
ADD
CONSTRAINT PK_HISTORICO_SERVICIOS PRIMARY KEY ([Historico_Servicios_ID]),
CONSTRAINT [FK_HISTORICO_SERVICIOS_Mascota_ID] FOREIGN KEY ([Mascota_ID]) REFERENCES registro.[MASCOTAS]([Mascota_ID]),
CONSTRAINT [FK_HISTORICO_SERVICIOS_Servicio_ID] FOREIGN KEY ([Servicio_ID]) REFERENCES adm.[SERVICIOS]([Servicio_ID]),
CONSTRAINT [FK_HISTORICO_SERVICIOS_Reservacion] FOREIGN KEY ([Reservacion_ID]) REFERENCES registro.[RESERVACIONES]([Reservacion_ID])
