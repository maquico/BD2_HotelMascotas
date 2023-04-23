--INSERT
CREATE PROCEDURE adm.spInsertVacunas
(
    @Nombre nvarchar(100)
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO adm.VACUNAS ([Nombre]) VALUES (@Nombre);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
            PRINT 'Error: ' + ERROR_MESSAGE();
        END
    END CATCH
END

--UPDATE
CREATE PROCEDURE adm.spUpdateVacunas
(
    @Vacuna_ID int,
    @Nombre nvarchar(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE adm.VACUNAS
        SET [Nombre] = @Nombre
        WHERE [Vacuna_ID] = @Vacuna_ID;

		IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
            PRINT 'Error: ' + ERROR_MESSAGE();
        END
    END CATCH
END

--DELETE
CREATE PROCEDURE adm.spDeleteVacunas
(
    @Vacuna_ID int
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM adm.VACUNAS WHERE [Vacuna_ID] = @Vacuna_ID;
		IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
            PRINT 'Error: ' + ERROR_MESSAGE();
        END
    END CATCH
END

--GET
CREATE PROCEDURE adm.GetVacunas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT [Vacuna_ID], [Nombre] FROM adm.VACUNAS;
END
GO

--GET BY ID
CREATE PROCEDURE adm.GetVacunasById
(
    @Vacuna_ID int
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT [Vacuna_ID], [Nombre]
    FROM adm.VACUNAS
    WHERE [Vacuna_ID] = @Vacuna_ID;

	IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
END
GO
