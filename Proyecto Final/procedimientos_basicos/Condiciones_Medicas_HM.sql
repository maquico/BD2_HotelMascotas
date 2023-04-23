--INSERT
GO
CREATE PROCEDURE adm.spInsertCondicionMedica
@Nombre nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO adm.[CONDICIONES_MEDICAS] ([Nombre])
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
CREATE PROCEDURE adm.spUpdateCondicionMedica
@Condicion_ID int,
@Nombre nvarchar(100)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
BEGIN TRANSACTION;
UPDATE adm.[CONDICIONES_MEDICAS]
SET [Nombre] = @Nombre
WHERE [Condicion_ID] = @Condicion_ID;
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
CREATE PROCEDURE adm.spDeleteCondicionMedica
@Condicion_ID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DELETE FROM adm.[CONDICIONES_MEDICAS]
        WHERE [Condicion_ID] = @Condicion_ID;
        IF @@ROWCOUNT = 0
        BEGIN
        RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END

        BEGIN
        COMMIT TRANSACTION;
        END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END

--GET
GO
CREATE PROCEDURE adm.spGetCondicionMedica
AS
BEGIN
SET NOCOUNT ON;
SELECT [Condicion_ID], [Nombre]
FROM adm.[CONDICIONES_MEDICAS];
END

--GET BY ID
GO
CREATE PROCEDURE adm.spGetCondicionMedicaById
@Condicion_ID int
AS
BEGIN
SET NOCOUNT ON;
SELECT [Condicion_ID], [Nombre]
FROM adm.[CONDICIONES_MEDICAS]
WHERE [Condicion_ID] = @Condicion_ID;
IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
    END
END