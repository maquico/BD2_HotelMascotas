CREATE PROCEDURE registro.spInsertDue�osMascota
    @Due�o_ID int,
    @Mascota_ID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO registro.DUE�OS_MASCOTA (Due�o_ID, Mascota_ID)
            VALUES (@Due�o_ID, @Mascota_ID)
			COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END

--DELETE
Go
CREATE PROCEDURE registro.spDeleteDue�osMascota
    @Due�o_ID int,
    @Mascota_ID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            DELETE FROM registro.DUE�OS_MASCOTA
            WHERE Due�o_ID = @Due�o_ID
              AND Mascota_ID = @Mascota_ID
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontr� ning�n registro con el ID especificado', 16, 1);
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
CREATE PROCEDURE registro.spGetDue�osMascotaById
    @Due�o_ID int,
    @Mascota_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM registro.DUE�OS_MASCOTA
    WHERE Due�o_ID = @Due�o_ID
      AND Mascota_ID = @Mascota_ID

	IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontr� ning�n registro con el ID especificado', 16, 1);
        END
END

--GetAll
Go
CREATE PROCEDURE registro.spGetDue�osMascota
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM registro.DUE�OS_MASCOTA
END
