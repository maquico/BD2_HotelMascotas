--INSERT RAZA
CREATE PROCEDURE registro.spInsertRaza
(
    @Nombre nvarchar(100),
    @Especie_ID int
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO registro.RAZAS (Nombre, Especie_ID)
        VALUES (@Nombre, @Especie_ID);
		COMMIT TRANSACTION;
	END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
			PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END


--UPDATE RAZA
GO
CREATE PROCEDURE registro.spUpdateRaza
(
    @Raza_ID int,
    @Nombre nvarchar(100),
    @Especie_ID int
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE registro.RAZAS
        SET Nombre = COALESCE(@Nombre, Nombre),
            Especie_ID = COALESCE(@Especie_ID, Especie_ID)
        WHERE Raza_ID = @Raza_ID;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
		COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
			PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END


--DELETE RAZA
GO
CREATE PROCEDURE registro.spDeleteRaza
(
    @Raza_ID int
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM registro.RAZAS
        WHERE Raza_ID = @Raza_ID;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
		COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
			PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END


--GetByID RAZA
GO
CREATE PROCEDURE registro.spGetRazaById
(
    @Raza_ID int
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM registro.RAZAS
    WHERE Raza_ID = @Raza_ID;

	IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
END


--GetAll RAZA
Go
CREATE PROCEDURE registro.spGetRazas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM registro.RAZAS;
END

