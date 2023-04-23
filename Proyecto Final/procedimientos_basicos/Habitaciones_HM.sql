
-- Procedimiento para insertar habitaciones
--AGREGADO
GO
CREATE PROCEDURE [adm].[spInsertHabitaciones]
    @Numero INT,
    @Capacidad INT,
    @Tipo_Habitacion_ID INT
AS
BEGIN
SET NOCOUNT ON
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [adm].[HABITACIONES] ([Numero], [Capacidad], [Tipo_Habitacion_ID])
        VALUES (@Numero, @Capacidad, @Tipo_Habitacion_ID);

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;


--Procedimiento para actualizar habitaciones
-- AGREGADO
go
CREATE PROCEDURE [adm].[spUpdateHabitaciones]
(
    @Habitacion_ID INT,
    @Numero INT,
    @Capacidad INT,
    @Ocupada BIT,
    @Tipo_Habitacion_ID INT
)
AS
BEGIN
SET NOCOUNT ON
    BEGIN TRY
        -- Iniciar la transacci�n
        BEGIN TRANSACTION;

        -- Actualizar los campos de la tabla usando la funci�n COALESCE para manejar los valores NULL
        UPDATE [adm].[HABITACIONES]
        SET
            [Numero] = COALESCE(@Numero, [Numero]),
            [Capacidad] = COALESCE(@Capacidad, [Capacidad]),
            [Ocupada] = COALESCE(@Ocupada, [Ocupada]),
            [Tipo_Habitacion_ID] = COALESCE(@Tipo_Habitacion_ID, [Tipo_Habitacion_ID])
        WHERE
            [Habitacion_ID] = @Habitacion_ID;

        -- Comprobar si se ha actualizado alg�n registro
        IF @@ROWCOUNT = 0
        BEGIN
            -- Si no se ha actualizado ning�n registro, lanzar un mensaje de error
            RAISERROR('No se encontr� ning�n registro con el ID especificado', 16, 1);
        END

        -- Confirmar la transacci�n
        COMMIT;
    END TRY
    BEGIN CATCH
        -- En caso de error, hacer rollback de la transacci�n y mostrar el mensaje de error
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK;
        END
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END

-- Procedimiento para eliminar habitaciones
--AGREGADO
GO
CREATE PROCEDURE [adm].[spDeleteHabitaciones]
    @Habitacion_ID INT
AS
BEGIN
SET NOCOUNT ON
    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM [adm].[HABITACIONES]
        WHERE [Habitacion_ID] = @Habitacion_ID;

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        RAISERROR('No se encontr� ning�n registro con el ID especificado', 16, 1);
    END CATCH;
END;

-- Procedimiento para obtener habitaciones por ID
-- AGREGADO
GO
CREATE OR ALTER PROCEDURE [registro].[spGetHabitacionesById]
    @Habitacion_ID INT
AS
BEGIN
SET NOCOUNT ON
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No se encontró ninguna habitación con el ID especificado', 16, 1);
                RETURN;
    END;

    SELECT 1
    FROM [adm].[HABITACIONES]
    WHERE [Habitacion_ID] = @Habitacion_ID;
END;


--Procedimiento para obtener todas habitaciones
-- AGREGADO
GO
CREATE OR ALTER PROCEDURE [registro].[spGetHabitaciones]
AS
BEGIN
SET NOCOUNT ON
    SELECT *
    FROM [adm].[HABITACIONES];
END;