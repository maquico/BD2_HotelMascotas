--INSERT
CREATE PROCEDURE adm.spInsertTipoHabitacion
(
    @Nombre nvarchar(100),
    @Precio_Dia decimal(10,2)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Tipo_Habitacion_ID int;

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO adm.TIPO_HABITACION (Nombre, Precio_Dia)
        VALUES (@Nombre, @Precio_Dia);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            PRINT 'Error: ' + ERROR_MESSAGE();
            ROLLBACK TRANSACTION;
        END
    END CATCH
END

--UPDATE
CREATE PROCEDURE adm.spUpdateTipoHabitacion
(
	@Tipo_Habitacion_ID int,
    @Nombre nvarchar(100) = NULL,
    @Precio_Dia decimal(10,2) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        UPDATE adm.TIPO_HABITACION
        SET Nombre = COALESCE(@Nombre, Nombre),
            Precio_Dia = COALESCE(@Precio_Dia, Precio_Dia)
        WHERE Tipo_Habitacion_ID = @Tipo_Habitacion_ID;
        
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
			PRINT 'Error: ' + ERROR_MESSAGE();
            ROLLBACK TRANSACTION;
        END
    END CATCH;
END
--DELETE
CREATE PROCEDURE adm.spDeleteTipoHabitacion
    @Tipo_Habitacion_ID int
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DELETE FROM adm.TIPO_HABITACION
        WHERE Tipo_Habitacion_ID = @Tipo_Habitacion_ID;
        
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            PRINT 'Error: ' + ERROR_MESSAGE();
            ROLLBACK TRANSACTION;
        END
    END CATCH
END
--GET
CREATE PROCEDURE registro.spGetTipoHabitacion
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Tipo_Habitacion_ID, Nombre, Precio_Dia
    FROM adm.TIPO_HABITACION;
END

GO
--GET BY ID
CREATE PROCEDURE registro.spGetTipoHabitacionById
@Tipo_Habitacion_ID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Tipo_Habitacion_ID, Nombre, Precio_Dia
    FROM adm.TIPO_HABITACION
	WHERE Tipo_Habitacion_ID = @Tipo_Habitacion_ID

	IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
END