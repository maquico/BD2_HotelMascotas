
-- Procedimientos para Insertar Mascota_Reservacion
-- AGREGADO
GO
CREATE OR ALTER PROCEDURE registro.spInsertMascotaReservacion
    @Reservacion_ID INT,
    @Mascota_ID INT,
    @Habitacion_ID INT,
    @Pertenencias NVARCHAR(200),
    @Descuento DECIMAL(3, 2)
AS
BEGIN
SET NOCOUNT ON

    BEGIN TRY
		BEGIN TRANSACTION;
            SET @Descuento = ISNULL(@Descuento, 0) 
			DECLARE @Monto_Estadia DECIMAL(10, 2)
			SET @Monto_Estadia = registro.fnCalcularMontoEstadia(@Habitacion_ID, @Reservacion_ID, @Descuento)
			DECLARE @Estado_Reservacion INT, @Ocupada BIT
			SELECT @Estado_Reservacion = r.Estatus_ID
			FROM registro.RESERVACIONES r
			WHERE Reservacion_ID = @Reservacion_ID

            SELECT @Ocupada = Ocupada
            FROM adm.HABITACIONES
            WHERE Habitacion_ID = @Habitacion_ID

			IF (@Estado_Reservacion != 1)
			BEGIN
                RAISERROR('No se puede agregar mascota a su reservacion porque ya ha iniciado, finalizó o fue cancelada', 16, 1);
			END
            ELSE IF registro.fnMascotaVacunasVerificadas(@Mascota_ID) = 0
            BEGIN 
                RAISERROR('La mascota seleccionada no cumple con las vacunas necesarias para visitar nuestro hotel', 16, 1);
            END
            ELSE IF @Ocupada = 1
                RAISERROR('La habitacion que seleccionaste esta ocupada', 16, 1);
            ELSE 
            BEGIN 
                INSERT INTO [registro].[MASCOTA_RESERVACION] (Reservacion_ID, Mascota_ID, Habitacion_ID, Pertenencias, Descuento, Monto_Estadia)
				VALUES (@Reservacion_ID, @Mascota_ID, @Habitacion_ID, @Pertenencias, @Descuento, @Monto_Estadia);
				PRINT 'Mascota Reservación insertada exitosamente.';
            END
		COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END

--Procedimiento para actualizar Mascota_Reservacion
-- AGREGADO
GO
CREATE OR ALTER PROCEDURE registro.spUpdateMascotaReservacion
    @Reservacion_ID INT,
    @Mascota_ID INT,
    @Habitacion_ID INT,
    @Pertenencias NVARCHAR(200),
    @Descuento DECIMAL(3, 2),
    @Monto_Estadia DECIMAL(10, 2)
AS
BEGIN
SET NOCOUNT ON
    BEGIN TRY
        BEGIN TRANSACTION;
        UPDATE [registro].[MASCOTA_RESERVACION]
        SET Habitacion_ID = COALESCE(@Habitacion_ID, Habitacion_ID),
            Pertenencias = COALESCE(@Pertenencias, Pertenencias),
            Descuento = COALESCE(@Descuento, Descuento),
            Monto_Estadia = COALESCE(@Monto_Estadia, Monto_Estadia)
        WHERE Reservacion_ID = @Reservacion_ID AND Mascota_ID = @Mascota_ID;

        COMMIT;
        PRINT 'Mascota Reservación actualizada exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END

-- Procedimiento para obtener todas las Mascota Reservacion
-- AGREGADO
GO
CREATE OR ALTER PROCEDURE registro.spGetMascotaReservacion
AS
BEGIN
SET NOCOUNT ON
    SELECT *
    FROM [registro].[MASCOTA_RESERVACION];
END


-- Procedimiento para obtener Reservacion Mascota por ID
GO
CREATE OR ALTER PROCEDURE registro.spGetMascotaReservacionById(
    @Reservacion_ID INT,
    @Mascota_ID INT)
AS
BEGIN
SET NOCOUNT ON
    SELECT *
    FROM [registro].[MASCOTA_RESERVACION]
    WHERE Reservacion_ID = @Reservacion_ID AND Mascota_ID = @Mascota_ID;
	IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No se encontró ningun registro con el ID especificado', 16, 1);
        RETURN;
	END
END

-- Procedimiento para Eliminar Mascota Reservacion
--AGREGADO
GO

CREATE OR ALTER PROCEDURE registro.spDeleteMascotaReservacion(
    @Reservacion_ID INT,
    @Mascota_ID INT)
AS
BEGIN
SET NOCOUNT ON
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Eliminar el registro de la tabla MASCOTA_RESERVACION
        DELETE FROM registro.MASCOTA_RESERVACION
        WHERE Reservacion_ID = @Reservacion_ID
        AND Mascota_ID = @Mascota_ID;

        -- Verificar si se eliminó algón registro
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningón registro con el ID especificado', 16, 1);
        END

        COMMIT;
    END TRY
    BEGIN CATCH
        -- En caso de error, realizar rollback y mostrar mensaje de error
        ROLLBACK;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

































    
    
