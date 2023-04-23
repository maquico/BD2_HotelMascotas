CREATE PROCEDURE registro.spInsertMascotaCondicion
    @Condicion_ID int,
    @Mascota_ID int,
    @Descripcion nvarchar(250)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO registro.MASCOTA_CONDICION (Condicion_ID, Mascota_ID, Descripcion)
            VALUES (@Condicion_ID, @Mascota_ID, @Descripcion)
			COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END

--DELETE
Go
CREATE PROCEDURE registro.spDeleteMascotaCondicion
    @Condicion_ID int,
    @Mascota_ID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            DELETE FROM registro.MASCOTA_CONDICION
            WHERE Condicion_ID = @Condicion_ID
              AND Mascota_ID = @Mascota_ID
        
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
CREATE PROCEDURE registro.spUpdateMascotaCondicion
    @Condicion_ID int,
    @Mascota_ID int,
    @Descripcion nvarchar(250)

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            UPDATE registro.MASCOTA_CONDICION
            SET Descripcion = COALESCE(@Descripcion, Descripcion)
            WHERE Condicion_ID = @Condicion_ID
            AND Mascota_ID = @Mascota_ID
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
CREATE PROCEDURE registro.spGetMascotaCondicionById
    @Condicion_ID int,
    @Mascota_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM registro.MASCOTA_CONDICION
    WHERE Condicion_ID = @Condicion_ID
    AND Mascota_ID = @Mascota_ID

	IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
END


--GetAll
Go
CREATE PROCEDURE registro.spGetMascotaCondicion
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM registro.MASCOTA_CONDICION
END

