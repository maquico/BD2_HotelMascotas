CREATE PROCEDURE registro.spInsertMascotaVacuna
    @Mascota_ID int,
    @Vacuna_ID int,
    @Fecha_Vencimiento datetime
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO registro.MASCOTA_VACUNA (Mascota_ID, Vacuna_ID, Fecha_Vencimiento)
            VALUES (@Mascota_ID, @Vacuna_ID, @Fecha_Vencimiento)
			COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END

--DELETE
Go
CREATE PROCEDURE registro.spDeleteMascotaVacuna
    @Mascota_ID int,
    @Vacuna_ID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            DELETE FROM registro.MASCOTA_VACUNA
            WHERE Mascota_ID = @Mascota_ID
              AND Vacuna_ID = @Vacuna_ID
        
		IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
		COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END

--UPDATE
Go
CREATE PROCEDURE registro.spUpdateMascotaVacuna
    @Mascota_ID int,
    @Vacuna_ID int,
    @Fecha_Vencimiento datetime
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            UPDATE registro.MASCOTA_VACUNA
            SET Fecha_Vencimiento = COALESCE(@Fecha_Vencimiento, Fecha_Vencimiento)  
            WHERE Mascota_ID = @Mascota_ID
              AND Vacuna_ID = @Vacuna_ID
        
		IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
		COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END


--GetByID
Go
CREATE PROCEDURE registro.spGetMascotaVacunaById
    @Mascota_ID int,
    @Vacuna_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM registro.MASCOTA_VACUNA
    WHERE Mascota_ID = @Mascota_ID
      AND Vacuna_ID = @Vacuna_ID

	IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
END


--GetAll
Go
CREATE PROCEDURE registro.spGetMascotaVacuna
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM registro.MASCOTA_VACUNA
END