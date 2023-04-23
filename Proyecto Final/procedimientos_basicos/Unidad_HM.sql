--INSERT
GO
CREATE PROCEDURE adm.spInsertUnidad
    @Nombre nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO adm.[UNIDAD] ([Nombre])
        VALUES (@Nombre);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END

--UPDATE
GO
CREATE PROCEDURE adm.spUpdateUnidad
    @Unidad_ID int,
    @Nombre nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        UPDATE adm.[UNIDAD]
        SET [Nombre] = @Nombre
        WHERE [Unidad_ID] = @Unidad_ID;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END

--DELETE
GO
CREATE PROCEDURE adm.spDeleteUnidad
    @Unidad_ID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DELETE FROM adm.[UNIDAD]
        WHERE [Unidad_ID] = @Unidad_ID;
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
        COMMIT TRANSACTION; 
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END

--GET
GO
CREATE PROCEDURE adm.spGetUnidad
AS
BEGIN
    SET NOCOUNT ON;
    SELECT [Unidad_ID], [Nombre]
    FROM adm.[UNIDAD];
END

--GET BY ID
GO
CREATE PROCEDURE adm.spGetUnidadById
    @Unidad_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT [Unidad_ID], [Nombre]
    FROM adm.[UNIDAD]
    WHERE [Unidad_ID] = @Unidad_ID;

    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
    END
END
