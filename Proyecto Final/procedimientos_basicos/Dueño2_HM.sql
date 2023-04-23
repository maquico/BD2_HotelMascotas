-- Procedimiento para Insertar un dueño
GO
CREATE OR ALTER PROCEDURE registro.spInsertDueño
    @Nombres nvarchar(100),
    @Apellidos nvarchar(100),
    @Telefono nvarchar(100),
    @Correo_Electronico nvarchar(100),
    @Sector_ID int,
    @Calle nvarchar(100),
    @Numero_Casa int,
    @Descripcion nvarchar(100),
    @Fecha_Nacimiento datetime
AS
BEGIN
SET NOCOUNT ON
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO registro.[DUEÑOS] (Nombres, Apellidos, Telefono, Correo_Electronico, Sector_ID, Calle, Numero_Casa, Descripcion, Fecha_Nacimiento)
        VALUES (@Nombres, @Apellidos, @Telefono, @Correo_Electronico, @Sector_ID, @Calle, @Numero_Casa, @Descripcion, @Fecha_Nacimiento);

        COMMIT;
        PRINT 'Dueño insertado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

-- Procedimiento para actualizar un dueño
GO
CREATE OR ALTER PROCEDURE registro.spUpdateDueño
    @Dueño_ID int,
    @Nombres nvarchar(100),
    @Apellidos nvarchar(100),
    @Telefono nvarchar(100),
    @Correo_Electronico nvarchar(100),
    @Sector_ID int,
    @Calle nvarchar(100),
    @Numero_Casa int,
    @Descripcion nvarchar(100),
    @Fecha_Nacimiento datetime
AS
BEGIN
SET NOCOUNT ON
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE registro.[DUEÑOS]
        SET Nombres = COALESCE(@Nombres, Nombres),
            Apellidos = COALESCE(@Apellidos, Apellidos),
            Telefono = COALESCE(@Telefono, Telefono),
            Correo_Electronico = COALESCE(@Correo_Electronico, Correo_Electronico),
            Sector_ID = COALESCE(@Sector_ID, Sector_ID),
            Calle = COALESCE(@Calle, Calle),
            Numero_Casa = COALESCE(@Numero_Casa, Numero_Casa),
            Descripcion = COALESCE(@Descripcion, Descripcion),
            Fecha_Nacimiento = COALESCE(@Fecha_Nacimiento, Fecha_Nacimiento)
        WHERE Dueño_ID = @Dueño_ID;

        COMMIT;
        PRINT 'Dueño actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

--DELETE
CREATE OR ALTER PROCEDURE adm.spDeleteDueño
    @Dueño_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Eliminar el registro de la tabla DUEÑOS
        DELETE FROM registro.DUEÑOS
        WHERE Dueño_ID = @Dueño_ID;

        -- Verificar si se eliminó algún registro
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END

        COMMIT;
    END TRY
    BEGIN CATCH
        -- En caso de error, realizar rollback y mostrar mensaje de error
        ROLLBACK;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

-- Procedimiento para obtener todos los dueños
GO
CREATE OR ALTER PROCEDURE registro.spGetDueños
AS
BEGIN
    SET NOCOUNT ON;
        SELECT * FROM registro.[DUEÑOS];
END;


--GET BY ID
GO
CREATE OR ALTER PROCEDURE registro.spGetDueñoById
    @Dueño_ID int
AS
BEGIN
    SET NOCOUNT ON;

        SELECT * FROM registro.[DUEÑOS] WHERE Dueño_ID = @Dueño_ID;
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
END;