CREATE PROCEDURE registro.spInsertDueñosMascota
    @Dueño_ID int,
    @Mascota_ID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO registro.DUEÑOS_MASCOTA (Dueño_ID, Mascota_ID)
            VALUES (@Dueño_ID, @Mascota_ID)
			COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END

--DELETE
Go
CREATE PROCEDURE registro.spDeleteDueñosMascota
    @Dueño_ID int,
    @Mascota_ID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            DELETE FROM registro.DUEÑOS_MASCOTA
            WHERE Dueño_ID = @Dueño_ID
              AND Mascota_ID = @Mascota_ID
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


--UPDATE
--No tiene campos actualizables


--GetByID
Go
CREATE PROCEDURE registro.spGetDueñosMascotaById
    @Dueño_ID int,
    @Mascota_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM registro.DUEÑOS_MASCOTA
    WHERE Dueño_ID = @Dueño_ID
      AND Mascota_ID = @Mascota_ID

	IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
END

--GetAll
Go
CREATE PROCEDURE registro.spGetDueñosMascota
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM registro.DUEÑOS_MASCOTA
END
