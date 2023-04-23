CREATE PROCEDURE registro.spInsertColor
(
    @Nombre nvarchar(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO registro.COLOR (Nombre)
        VALUES (@Nombre);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END


--UPDATE
Go
CREATE PROCEDURE registro.spUpdateColor
(
    @Color_ID int,
    @Nombre nvarchar(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE registro.COLOR
        SET Nombre = @Nombre
        WHERE Color_ID = @Color_ID;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
		COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END


--Delete
Go
CREATE PROCEDURE registro.spDeleteColor
(
    @Color_ID int
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM registro.COLOR
        WHERE Color_ID = @Color_ID;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
		COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END




--GetAll
Go
CREATE PROCEDURE registro.spGetColor
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM registro.COLOR;
END


--GetByID
Go
CREATE PROCEDURE registro.spGetColorById
(
    @Color_ID int
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM registro.COLOR
    WHERE Color_ID = @Color_ID;

	IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
END
