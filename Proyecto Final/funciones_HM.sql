--CALCULAR MONTO DE ESTADIA
--Agregada y probada
CREATE FUNCTION [registro].[fnCalcularMontoEstadia] (@habitacion_id INT, @reservacion_id INT, @descuento DECIMAL(3,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
  DECLARE @precio_dia DECIMAL(10,2);
  DECLARE @monto_estadia DECIMAL(10,2);
  DECLARE @fecha_inicio DATETIME;
  DECLARE @fecha_fin DATETIME;
  
  SELECT @fecha_inicio = [Fecha_Inicio], 
        @fecha_fin = [Fecha_Fin]
  FROM registro.[RESERVACIONES]
  WHERE [Reservacion_ID] = @reservacion_id
  
  SELECT @precio_dia = [Precio_Dia]
  FROM adm.[TIPO_HABITACION]
  WHERE [Tipo_Habitacion_ID] = (
    SELECT [Tipo_Habitacion_ID]
    FROM adm.[HABITACIONES]
    WHERE [Habitacion_ID] = @habitacion_id
  );

  SET @monto_estadia = DATEDIFF(DAY, @fecha_inicio, @fecha_fin) * @precio_dia * (1-@descuento);

  RETURN @monto_estadia;
END

--CALCULAR TOTAL EN FACTURA_PRODUCTOS
--Agregada y Probada
CREATE FUNCTION facturacion.fnCalcularTotal
(
    @Cantidad int,
    @Precio_Unidad decimal(10,2),
    @Descuento decimal(3,2)
)
RETURNS decimal(10,2)
AS
BEGIN
    DECLARE @Total decimal(10,2);
    SET @Total = (@Cantidad * @Precio_Unidad) * (1 - @Descuento);
    RETURN @Total;
END;

-- Funcion para calcular monto servicio
--Agegada y probada
CREATE FUNCTION registro.fnCalcularTotalServicio
(
@Cantidad_Aplicada int,
@Precio_Unidad_Cobrado decimal(10,2),
@Descuento decimal (3,2),
@Cancelado bit
)
RETURNS decimal(10,2)
AS
BEGIN
		DECLARE @Total decimal(10,2)
		SET @Total = ((@Cantidad_Aplicada *@Precio_Unidad_Cobrado) * (1 - @Descuento ))
	RETURN @Total
END


-- Funcion para calcular el Precio_Unidad_Cobrado de Un servicio
--DROPEADA
CREATE FUNCTION [registro].[fnCalcularPrecioUnidadCobrado]
(
@ServicioID INT,
@MascotaID INT
)
RETURNS decimal(10,2)
AS
BEGIN
	DECLARE @Multiplicador decimal(3,2)
	DECLARE @Precio_Unidad_Cobrado decimal(10,2)
	SELECT @Multiplicador = 
	CASE
		WHEN m.Tamaño = 'Pequeño' THEN s.Multiplicador_Pequeño
		WHEN m.Tamaño = 'Mediano' THEN s.Multiplicador_Mediano
		WHEN m.Tamaño = 'Grande' THEN s.Multiplicador_Grande
	END, 
	@Precio_Unidad_Cobrado = s.Precio_Unidad * @Multiplicador
  PRINT @Precio_Unidad_Cobrado
	FROM registro.SERVICIOS_SOLICITADOS ss
	INNER JOIN adm.SERVICIOS s ON s.Servicio_ID = ss.Servicio_ID
	INNER JOIN registro.MASCOTAS m ON ss.Mascota_ID = m.Mascota_ID

	RETURN @Precio_Unidad_Cobrado

END
GO

--Funcion para calcular estatus
--Agregado y probado
CREATE FUNCTION registro.fnCalcularEstatusReservacion (@fecha_inicio datetime, @fecha_fin datetime, @fecha_actual DATETIME)
RETURNS INT
AS
BEGIN
    DECLARE @estatus_ID INT
    
    IF @fecha_actual < @fecha_inicio
        SET @estatus_ID = 1 -- Estado programada
    ELSE IF @fecha_actual >= @fecha_inicio AND @fecha_actual <= @fecha_fin
        SET @estatus_ID = 2 -- Estado en curso
    ELSE IF @fecha_actual > @fecha_fin
        SET @estatus_ID = 3 -- Estado finalizada

    
    RETURN @estatus_ID
END

-- Funcion obtener total servicios de la reservacion
--AGREGADA 
DROP FUNCTION [facturacion].[fnCalcularTotalServicios]
	CREATE FUNCTION [facturacion].[fnCalcularTotalServicios](
	@Factura_ID INT
	)

	RETURNS DECIMAL(10,2)
	AS
	BEGIN
		DECLARE @Reservacion_ID int, @Total_Servicios decimal(10,2)

		SELECT @Reservacion_ID = Reservacion_ID
		FROM facturacion.FACTURAS
		WHERE Factura_ID = @Factura_ID

		SET @Total_Servicios = (
		SELECT SUM(Total)
		FROM registro.SERVICIOS_SOLICITADOS
		WHERE Reservacion_ID = @Reservacion_ID)

		RETURN @Total_Servicios
	END
GO

--Función para saber si hay habitaciones disponibles, retorna true o false
--Agregada y Probada
Go
CREATE FUNCTION registro.fnHabitacionesDisponibles()
RETURNS bit
AS
BEGIN
  DECLARE @result bit;
  SET @result = (SELECT TOP 1 [Ocupada] FROM adm.[HABITACIONES] WHERE [Ocupada] = 0)
  IF @result IS NULL
    SET @result = 0;
  Else
	SET @result = 1;
  RETURN @result;
END

--Función para saber si una mascota cuenta con todas las vacunas verificadas, retorna true o false
--Agregada y Probada
Go
CREATE FUNCTION registro.fnMascotaVacunasVerificadas(@mascota_id int)
RETURNS bit
AS
BEGIN
  DECLARE @total_vacunas int, @vacunas_verificadas int, @result bit, @EspecieID int;
  Select @EspecieID = Especie_ID from registro.Mascotas where Mascota_ID = @mascota_id
  
  IF @EspecieID = 1
  Begin
  SET @total_vacunas = (SELECT COUNT(*) FROM registro.[MASCOTA_VACUNA] WHERE [Mascota_ID] = @mascota_id AND 
							[Vacuna_ID] in (Select Vacuna_ID
							From adm.Vacunas 
							where Vacuna_ID = 1 or Vacuna_ID = 2 or Vacuna_ID = 3));

  SET @vacunas_verificadas = (SELECT COUNT(*) FROM registro.[MASCOTA_VACUNA] WHERE [Mascota_ID] = @mascota_id AND [Verificado] = 1 AND 
							[Vacuna_ID] in (Select Vacuna_ID
							From adm.Vacunas 
							where Vacuna_ID = 1 or Vacuna_ID = 2 or Vacuna_ID = 3));
  END

  ELSE
  Begin
	  SET @total_vacunas = (SELECT COUNT(*) FROM registro.[MASCOTA_VACUNA] WHERE [Mascota_ID] = @mascota_id AND 
								[Vacuna_ID] in (Select Vacuna_ID
								From adm.Vacunas 
								where Vacuna_ID = 6 or Vacuna_ID = 7 or Vacuna_ID = 2));

	  SET @vacunas_verificadas = (SELECT COUNT(*) FROM registro.[MASCOTA_VACUNA] WHERE [Mascota_ID] = @mascota_id AND [Verificado] = 1 AND 
								[Vacuna_ID] in (Select Vacuna_ID 
								From adm.Vacunas 
								where Vacuna_ID = 6 or Vacuna_ID = 7 or Vacuna_ID = 2));
  End

  IF @total_vacunas = @vacunas_verificadas
    SET @result = 1;
  ELSE
    SET @result = 0;
  RETURN @result;
END

--Calcular edad en base a fecha de nacimiento
--Agregada y Probada
Go
CREATE FUNCTION registro.fnCalcularEdad(@fecha_nacimiento date)
RETURNS int
AS
BEGIN
  DECLARE @edad int;
  SET @edad = DATEDIFF(YEAR, @fecha_nacimiento, GETDATE()) - 
  CASE 
  WHEN MONTH(@fecha_nacimiento) > MONTH(GETDATE()) OR (MONTH(@fecha_nacimiento) = MONTH(GETDATE()) AND DAY(@fecha_nacimiento) > DAY(GETDATE())) THEN 1 ELSE 0 END;
  RETURN @edad;
END

CREATE OR ALTER FUNCTION adm.fnVerificarCelo()
RETURNS TABLE
AS
RETURN
(
    SELECT Nombre, Fecha_Ultimo_Celo
    FROM registro.MASCOTAS
    WHERE Sexo_ID IN (5, 6) AND Fecha_Ultimo_Celo <= DATEADD(day, -30, GETDATE())
);