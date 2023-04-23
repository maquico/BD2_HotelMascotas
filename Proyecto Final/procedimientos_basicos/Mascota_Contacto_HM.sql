CREATE PROCEDURE registro.spInsertMascotaContacto
(
    @Contacto_Emergencia_ID INT,
    @Mascota_ID INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            INSERT INTO registro.MASCOTA_CONTACTO (Contacto_Emergencia_ID, Mascota_ID)
            VALUES (@Contacto_Emergencia_ID, @Mascota_ID);
			COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
			PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END

--Delete
Go
CREATE PROCEDURE registro.spDeleteMascotaContacto
(
    @Contacto_Emergencia_ID INT,
    @Mascota_ID INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM registro.MASCOTA_CONTACTO
            WHERE Contacto_Emergencia_ID = @Contacto_Emergencia_ID
            AND Mascota_ID = @Mascota_ID;
		
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

--GetByID
Go
CREATE PROCEDURE registro.spGetMascotaContactoById
    @Contacto_Emergencia_ID int,
    @Mascota_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM registro.MASCOTA_CONTACTO
    WHERE Contacto_Emergencia_ID = @Contacto_Emergencia_ID
      AND Mascota_ID = @Mascota_ID
	
	IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
END


--GetAll
Go
CREATE PROCEDURE registro.spGetAllMascotaContacto
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM registro.MASCOTA_CONTACTO
END
