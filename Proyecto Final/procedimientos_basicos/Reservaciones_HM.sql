-- Procedimiento para insertar reservaciones
-- AGREGADA

CREATE OR ALTER PROCEDURE registro.spInsertReservaciones
(
    @Dueño_ID INT,
    @Fecha_Inicio DATETIME,
    @Fecha_Fin DATETIME,
	@Descuento DECIMAL(3,2) = 0
)
AS
BEGIN
SET NOCOUNT ON
    BEGIN TRY
        BEGIN TRANSACTION

       IF registro.fnHabitacionesDisponibles() = 0
            BEGIN
                RAISERROR('No hay habitaciones disponibles para hacer la reserva', 16, 1);
            END
        ELSE
            BEGIN 
                INSERT INTO [registro].[RESERVACIONES] (Dueño_ID, Fecha_Inicio, Fecha_Fin, Descuento)
                VALUES (@Dueño_ID, @Fecha_Inicio, @Fecha_Fin, @Descuento);
            END
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

-- Procedimiento para Actualizar reservaciones
-- AGREGADO
go

CREATE OR ALTER PROCEDURE registro.spUpdateReservaciones
    @Reservacion_ID INT,
    @Dueño_ID INT,
    @Fecha_Inicio DATE,
    @Fecha_Fin DATE,
	@Descuento DECIMAL(3,2) = 0,
	@Estatus_ID BIT 
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
    BEGIN TRANSACTION
		UPDATE registro.Reservaciones
		SET Fecha_Inicio = COALESCE(@Fecha_Inicio, Fecha_Inicio),
        Dueño_ID = COALESCE(@Dueño_ID, Dueño_ID),
        Fecha_Fin = COALESCE(@Fecha_Fin, Fecha_Fin),
		Descuento = COALESCE(@Descuento, Descuento),
		Estatus_ID = COALESCE(@Estatus_ID, Estatus_ID)
		WHERE Reservacion_ID = @Reservacion_ID;
	COMMIT
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
            ROLLBACK;
       PRINT ERROR_MESSAGE()
	END CATCH
END

-- Procedimiento para obtener todas las reservaciones
--AGREGADO
GO
CREATE PROCEDURE registro.spGetReservaciones
AS
BEGIN
SET NOCOUNT ON
     SELECT * FROM registro.RESERVACIONES  
END

-- Procedimiento para obtener reservaciones por ID
-- AGREGADA
GO
CREATE OR ALTER PROCEDURE registro.spGetReservacionesById
(
    @Reservacion_ID INT
)
AS
BEGIN 
SET NOCOUNT ON
    SELECT * 
	FROM registro.RESERVACIONES r
	WHERE r.Reservacion_ID = @Reservacion_ID
	IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontrñ ningñn registro con el ID especificado', 16, 1);
        END
END

-- Procedimiento para borrar reservaciones
-- AGREGADO
GO
CREATE PROCEDURE registro.spDeleteReservaciones
    @Reservacion_ID INT
AS
BEGIN
SET NOCOUNT ON
    BEGIN TRY
        -- Iniciar la transacciñn
        BEGIN TRANSACTION;

        -- Verificar si existe el registro con el ID especificado
        IF NOT EXISTS (SELECT 1 FROM [registro].[RESERVACIONES] WHERE Reservacion_ID = @Reservacion_ID)
        BEGIN
            -- Lanzar un error si no se encuentra el registro
            RAISERROR('No se encontrñ ningñn registro con el ID especificado', 16, 1);
            RETURN;
        END

        -- Realizar la operaciñn de DELETE
        DELETE FROM [registro].[RESERVACIONES] WHERE Reservacion_ID = @Reservacion_ID;

        -- Commit de la transacciñn
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback de la transacciñn en caso de error
        ROLLBACK;

        -- Imprimir mensaje de error
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END
GO