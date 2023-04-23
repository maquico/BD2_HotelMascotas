
-- Procedimiento para insertar Servicios_Solicitados
-- AGREGADO

CREATE OR ALTER PROCEDURE [registro].[spInsertServiciosSolicitados] 
(
    @Servicio_ID INT,
    @Reservacion_ID INT,
    @Mascota_ID INT,
    @Cantidad_Unidad INT,
	@Descuento DECIMAL(3,2) = 0
	)
AS
BEGIN
SET NOCOUNT ON
    BEGIN TRY
        BEGIN TRANSACTION

		DECLARE @EstadoReservacion INT, @Precio_Unidad DECIMAL(10,2), @Multiplicador decimal(10,2)
		SELECT @EstadoReservacion = r.Estatus_ID
		FROM registro.RESERVACIONES r
		WHERE Reservacion_ID = @Reservacion_ID
        
        SELECT @Precio_Unidad = Precio_Unidad
		FROM adm.SERVICIOS
		WHERE Servicio_ID = @Servicio_ID

        SET @Multiplicador = registro.fnObtenerMultiplicadorMascota(@Mascota)
        SET @Precio_Unidad_Cobrado = @Precio_Unidad * @Multiplicador

		IF (@EstadoReservacion = 4) OR (@EstadoReservacion = 3)
		BEGIN
		 RAISERROR('Esta reservación fue cancelada o ya finalizó', 16, 1);
		END

		ELSE

		BEGIN
			DECLARE @Precio_Unidad_Cobrado DECIMAL(10, 2)
		SET @Precio_Unidad_Cobrado = registro.fnCalcularPrecioUnidadCobrado(@Servicio_ID, @Mascota_ID)

        INSERT INTO [registro].[SERVICIOS_SOLICITADOS] (
            [Servicio_ID],
            [Reservacion_ID],
            [Mascota_ID],
            [Cantidad_Unidad],
            [Precio_Base]
            [Precio_Unidad_Cobrado],
            [Descuento]
        ) VALUES (
            @Servicio_ID,
            @Reservacion_ID,
            @Mascota_ID,
            @Cantidad_Unidad,
            @Precio_Unidad
            @Precio_Unidad_Cobrado,
            @Descuento
        )
		END

        COMMIT
    END TRY

    BEGIN CATCH
        ROLLBACK;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

-- Procedimiento para actualizar Servicios_Solicitados
-- AGREGADO
GO
CREATE PROCEDURE [registro].[spUpdateServiciosSolicitados]
    (@Servicio_ID INT,
    @Reservacion_ID INT,
    @Mascota_ID INT,
    @Cantidad_Unidad INT,
    @Precio_Unidad_Cobrado DECIMAL(10, 2),
    @Cantidad_Aplicada INT,
    @Descuento DECIMAL(3, 2) = 0)
AS
BEGIN
SET NOCOUNT ON
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [registro].[SERVICIOS_SOLICITADOS]
        SET [Cantidad_Unidad] = COALESCE(@Cantidad_Unidad, [Cantidad_Unidad]),
            [Precio_Unidad_Cobrado] = COALESCE(@Precio_Unidad_Cobrado, [Precio_Unidad_Cobrado]),
            [Cantidad_Aplicada] = COALESCE(@Cantidad_Aplicada, [Cantidad_Aplicada]),
            [Descuento] = COALESCE(@Descuento, [Descuento])
        WHERE [Servicio_ID] = @Servicio_ID
            AND [Reservacion_ID] = @Reservacion_ID
            AND [Mascota_ID] = @Mascota_ID

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
         RAISERROR('No se encontr� ning�n registro con el ID especificado', 16, 1);
    END CATCH;
END;

GO


-- Obtener todos los servicios solicitados
-- AGREGADOS

CREATE PROCEDURE [registro].[spGetServiciosSolicitados]
AS
BEGIN
SET NOCOUNT ON
    SELECT *
    FROM [registro].[SERVICIOS_SOLICITADOS];
END;

-- Obtener servicios solicitados por Id
-- AGREGADO
GO
CREATE PROCEDURE [registro].[spGetServiciosSolicitadosById]
    (@Servicio_ID INT,
    @Reservacion_ID INT,
    @Mascota_ID INT)
AS
BEGIN
SET NOCOUNT ON
    SELECT *
    FROM [registro].[SERVICIOS_SOLICITADOS]
    WHERE [Servicio_ID] = @Servicio_ID AND Reservacion_ID = @Reservacion_ID AND Mascota_ID = @Mascota_ID AND Servicio_ID = @Servicio_ID
END;

-- Eliminar servicio solicitado
-- Agregado
GO
CREATE PROCEDURE [registro].[spDeleteServiciosSolicitados]
    @Servicio_ID INT,
    @Reservacion_ID INT,
    @Mascota_ID INT
AS
BEGIN
SET NOCOUNT ON
    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM [registro].[SERVICIOS_SOLICITADOS]
        WHERE [Servicio_ID] = @Servicio_ID
            AND [Reservacion_ID] = @Reservacion_ID
            AND [Mascota_ID] = @Mascota_ID;

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
         RAISERROR('No se encontr� ning�n registro con el ID especificado', 16, 1);
    END CATCH;
END;
