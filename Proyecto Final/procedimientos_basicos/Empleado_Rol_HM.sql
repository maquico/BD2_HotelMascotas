--INSERT (EN AZURE)
CREATE PROCEDURE adm.spInsertEmpleadoRol
(
    @Empleado_ID int,
    @Rol_ID int
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		BEGIN TRANSACTION;
        INSERT INTO adm.EMPLEADO_ROL (Empleado_ID, Rol_ID)
        VALUES (@Empleado_ID, @Rol_ID);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            PRINT 'Error: ' + ERROR_MESSAGE();
            ROLLBACK TRANSACTION;
        END
    END CATCH
END

--UPDATE (No es posible, todos sus campos son o primary key o por defecto)

--DELETE(EN AZURE)
CREATE PROCEDURE adm.spDeleteEmpleadoRol
(
    @Empleado_ID int,
    @Rol_ID int
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM adm.EMPLEADO_ROL
        WHERE Empleado_ID = @Empleado_ID AND Rol_ID = @Rol_ID;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con los IDs especificados', 16, 1);
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
END

--GET BY ID (EN AZURE)
CREATE PROCEDURE adm.spGetEmpleadoRolById
(
    @Empleado_ID int,
    @Rol_ID int
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Empleado_ID, Rol_ID, Fecha_Registro
    FROM adm.EMPLEADO_ROL
    WHERE Empleado_ID = @Empleado_ID AND Rol_ID = @Rol_ID
	IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END

END;

--GET (EN AZURE)
CREATE PROCEDURE adm.spGetEmpleadoRol
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Empleado_ID, Rol_ID, Fecha_Registro
    FROM adm.EMPLEADO_ROL;
	
END
