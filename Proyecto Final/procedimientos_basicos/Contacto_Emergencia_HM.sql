CREATE PROCEDURE registro.spInsertContactoEmergencia
(
    @Relacion nvarchar(100),
    @Nombres nvarchar(100),
    @Apellidos nvarchar(100),
    @Telefono nvarchar(100),
    @Sector_ID int,
    @Calle nvarchar(100),
    @Numero_Casa int,
    @Correo_Electronico nvarchar(100),
    @Fecha_Nacimiento datetime
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO registro.CONTACTO_EMERGENCIA (Relacion, Nombres, Apellidos, Telefono, Sector_ID, Calle, Numero_Casa, Correo_Electronico, Fecha_Nacimiento)
        VALUES (@Relacion, @Nombres, @Apellidos, @Telefono, @Sector_ID, @Calle, @Numero_Casa, @Correo_Electronico, @Fecha_Nacimiento);
		COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
			PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END


--UPDATE ConEmergencia
Go
CREATE PROCEDURE registro.spUpdateContactoEmergencia
(
    @Contacto_Emergencia_ID int,
    @Relacion nvarchar(100),
    @Nombres nvarchar(100),
    @Apellidos nvarchar(100),
    @Telefono nvarchar(100),
    @Sector_ID int,
    @Calle nvarchar(100),
    @Numero_Casa int,
    @Correo_Electronico nvarchar(100),
    @Fecha_Nacimiento datetime
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE registro.CONTACTO_EMERGENCIA
        SET 
            Relacion = COALESCE(@Relacion, Relacion),
            Nombres = COALESCE(@Nombres, Nombres),
            Apellidos = COALESCE(@Apellidos, Apellidos),
            Telefono = COALESCE(@Telefono, Telefono),
            Sector_ID = COALESCE(@Sector_ID, Sector_ID),
            Calle = COALESCE(@Calle, Calle),
            Numero_Casa = COALESCE(@Numero_Casa, Numero_Casa),
            Correo_Electronico = COALESCE(@Correo_Electronico, Correo_Electronico),
            Fecha_Nacimiento = COALESCE(@Fecha_Nacimiento, Fecha_Nacimiento)
        WHERE Contacto_Emergencia_ID = @Contacto_Emergencia_ID;

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


--DELETE
GO
CREATE PROCEDURE registro.spDeleteContactoEmergencia
    @contacto_emergencia_id int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DELETE FROM registro.CONTACTO_EMERGENCIA
        WHERE Contacto_Emergencia_ID = @contacto_emergencia_id;
        
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


--GetAll
GO
CREATE PROCEDURE registro.spGetContactosEmergencia
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT *
    FROM registro.CONTACTO_EMERGENCIA;
END


--GetByID
GO
CREATE PROCEDURE registro.spGetContactoEmergenciaById
    @contacto_emergencia_id int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT *
    FROM registro.CONTACTO_EMERGENCIA
    WHERE Contacto_Emergencia_ID = @contacto_emergencia_id;

	IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
END
