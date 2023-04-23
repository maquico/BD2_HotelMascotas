
---INSERT (EN AZURE)
	CREATE PROCEDURE adm.spInsertEmpleados
	@Nombres nvarchar(100),
	@Apellidos nvarchar(100),
	@Telefono nvarchar(100),
	@Correo_Electronico nvarchar(100),
	@Sector_ID int,
	@Calle nvarchar(100),
	@Numero_Casa int,
	@Fecha_Nacimiento datetime
	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRANSACTION 
		BEGIN TRY
			INSERT INTO adm.EMPLEADOS(Nombres, Apellidos, Telefono,Correo_Electronico, Sector_ID, Calle, Numero_Casa, Fecha_Nacimiento)
			VALUES(@Nombres, @Apellidos, @Telefono, @Correo_Electronico, @Sector_ID, @Calle, @Numero_Casa, @Fecha_Nacimiento)
			COMMIT
		END TRY
		
		BEGIN CATCH 
			IF @@TRANCOUNT > 0
			BEGIN
				PRINT 'Error: ' + ERROR_MESSAGE();
				ROLLBACK TRANSACTION;
			END
		END CATCH
	END;

-----UPDATE (EN AZURE)
CREATE PROCEDURE adm.spUpdateEmpleados
(
@Empleado_ID int,
@Nombres nvarchar(100) = NULL,
@Apellidos nvarchar(100) = NULL,
@Telefono nvarchar(100) = NULL,
@Correo_Electronico nvarchar(100) = NULL,
@Sector_ID int = NULL,
@Calle nvarchar(100) = NULL,
@Numero_Casa int = NULL,
@Fecha_Nacimiento datetime = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
    BEGIN TRANSACTION;
	BEGIN TRY

    UPDATE adm.EMPLEADOS
    SET Nombres = COALESCE(@Nombres, Nombres),
        Apellidos = COALESCE(@Apellidos, Apellidos),
        Telefono = COALESCE(@Telefono, Telefono),
        Correo_Electronico = COALESCE(@Correo_Electronico, Correo_Electronico),
        Sector_ID = COALESCE(@Sector_ID, Sector_ID),
        Calle = COALESCE(@Calle, Calle),
        Numero_Casa = COALESCE(@Numero_Casa, Numero_Casa),
        Fecha_Nacimiento = COALESCE(@Fecha_Nacimiento, Fecha_Nacimiento)
    WHERE Empleado_ID = @Empleado_ID;
    
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
END;

--DELETE (EN AZURE)
CREATE PROCEDURE adm.spDeleteEmpleados
@Empleado_ID int
AS
BEGIN
	SET NOCOUNT ON;
    BEGIN TRANSACTION;
	BEGIN TRY
    
		DELETE FROM adm.EMPLEADOS
		WHERE Empleado_ID = @Empleado_ID;
    
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
END;

--GET BY ID (EN AZURE)
CREATE PROCEDURE adm.spGetEmpleadosById
@Empleado_ID INT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Empleado_ID, Nombres, Apellidos, Telefono, Correo_Electronico, Sector_ID, Calle, Numero_Casa, Fecha_Registro, Fecha_Nacimiento
	FROM adm.EMPLEADOS
	WHERE Empleado_ID = @Empleado_ID
	IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
    END
END;

----GET (EN AZURE)
CREATE PROCEDURE adm.spGetEmpleados
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Empleado_ID, Nombres, Apellidos, Telefono, Correo_Electronico, Sector_ID, Calle, Numero_Casa, Fecha_Registro, Fecha_Nacimiento
	FROM adm.EMPLEADOS;
END;