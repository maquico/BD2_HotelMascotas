--INSERT
GO
CREATE PROCEDURE adm.spInsertServicio
(
@Nombre nvarchar(100),
@Unidad_ID int,
@Precio_Unidad decimal(10,2),
@Multiplicador_Pequeño decimal(10,2),
@Multiplicador_Mediano decimal(10,2),
@Multiplicador_Grande decimal(10,2)
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT INTO adm.SERVICIOS (Nombre, Unidad_ID, Precio_Unidad, Multiplicador_Pequeño, Multiplicador_Mediano, Multiplicador_Grande)
    VALUES (@Nombre, @Unidad_ID, @Precio_Unidad, @Multiplicador_Pequeño, @Multiplicador_Mediano, @Multiplicador_Grande);
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

--UPDATE
GO
CREATE PROCEDURE adm.spUpdateServicio
(
@Servicio_ID int,
@Nombre nvarchar(100) = NULL,
@Unidad_ID int = NULL,
@Precio_Unidad decimal(10,2) = NULL,
@Multiplicador_Pequeño decimal(10,2) = NULL,
@Multiplicador_Mediano decimal(10,2) = NULL,
@Multiplicador_Grande decimal(10,2) = NULL
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE adm.SERVICIOS
    SET Nombre = COALESCE(@Nombre, Nombre),
        Unidad_ID = COALESCE(@Unidad_ID, Unidad_ID),
        Precio_Unidad = COALESCE(@Precio_Unidad, Precio_Unidad),
        Multiplicador_Pequeño = COALESCE(@Multiplicador_Pequeño, Multiplicador_Pequeño),
        Multiplicador_Mediano = COALESCE(@Multiplicador_Mediano, Multiplicador_Mediano),
        Multiplicador_Grande = COALESCE(@Multiplicador_Grande, Multiplicador_Grande)
    WHERE Servicio_ID = @Servicio_ID;

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
END

--DELETE
GO
CREATE PROCEDURE adm.spDeleteServicio
@Servicio_ID int
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION;
    DELETE FROM adm.SERVICIOS
    WHERE Servicio_ID = @Servicio_ID;
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
END

--GET
GO
CREATE PROCEDURE adm.spGetServicios
AS
BEGIN
SET NOCOUNT ON;

SELECT Servicio_ID, Nombre, Unidad_ID, Precio_Unidad, Multiplicador_Pequeño, Multiplicador_Mediano, Multiplicador_Grande
FROM adm.SERVICIOS;
END

--GET BY ID
GO
CREATE PROCEDURE adm.spGetServicioById
@Servicio_ID INT
AS
BEGIN
SET NOCOUNT ON;

SELECT Servicio_ID, Nombre, Unidad_ID, Precio_Unidad, Multiplicador_Pequeño, Multiplicador_Mediano, Multiplicador_Grande
FROM adm.SERVICIOS
WHERE Servicio_ID = @Servicio_ID

IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
    END
END