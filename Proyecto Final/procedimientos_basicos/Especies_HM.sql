--INSERT
CREATE PROCEDURE adm.spInsertEspecie
@Nombre nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO adm.[ESPECIES] ([Nombre])
        VALUES (@Nombre);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END

--UPDATE
CREATE PROCEDURE adm.spUpdateEspecie
@Especie_ID int,
@Nombre nvarchar(100)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE adm.[ESPECIES]
    SET [Nombre] = @Nombre
    WHERE [Especie_ID] = @Especie_ID;

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
CREATE PROCEDURE adm.spDeleteEspecie
@Especie_ID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DELETE FROM adm.[ESPECIES]
        WHERE [Especie_ID] = @Especie_ID;
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
CREATE PROCEDURE adm.spGetEspecie
AS
BEGIN
    SET NOCOUNT ON;
    SELECT [Especie_ID], [Nombre]
    FROM adm.[ESPECIES];
END

--GET BY ID
CREATE PROCEDURE adm.spGetEspecieById
@Especie_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT [Especie_ID], [Nombre]
    FROM adm.[ESPECIES]
    WHERE [Especie_ID] = @Especie_ID;

    IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
END