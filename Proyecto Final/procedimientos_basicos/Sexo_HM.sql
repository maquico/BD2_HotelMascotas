--INSERT
CREATE PROCEDURE adm.spInsertSexo
    @Nombre nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO adm.[SEXO] ([Nombre])
        VALUES (@Nombre);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END
--UPDATE
CREATE PROCEDURE adm.spUpdateSexo
    @Sexo_ID int,
    @Nombre nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        UPDATE adm.[SEXO]
        SET [Nombre] = @Nombre
        WHERE [Sexo_ID] = @Sexo_ID;

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
CREATE PROCEDURE adm.spDeleteSexo
    @Sexo_ID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DELETE FROM adm.[SEXO]
        WHERE [Sexo_ID] = @Sexo_ID;
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
        ELSE
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
CREATE PROCEDURE adm.spGetSexo
AS
BEGIN
    SET NOCOUNT ON;
    SELECT [Sexo_ID], [Nombre]
    FROM adm.[SEXO];
END

--GET BY ID
CREATE PROCEDURE adm.spGetSexoById
    @Sexo_ID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT [Sexo_ID], [Nombre]
    FROM adm.[SEXO]
    WHERE [Sexo_ID] = @Sexo_ID;

	IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
END