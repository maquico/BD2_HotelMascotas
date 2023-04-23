
---INSERT (EN AZURE)
	CREATE PROCEDURE adm.spInsertSector
	@Nombre nvarchar(100)
	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRANSACTION 

		BEGIN TRY 
			INSERT INTO adm.SECTOR
			VALUES(@Nombre)
			COMMIT;
		END TRY
		
		BEGIN CATCH 
			IF @@TRANCOUNT > 0
			BEGIN
				PRINT 'Error: ' + ERROR_MESSAGE();
				ROLLBACK TRANSACTION;
			END
		END CATCH
	END;

--UPDATE (EN AZURE)
CREATE PROCEDURE adm.spUpdateSector
(
@Sector_ID int,
@Nombre nvarchar(100) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION;
	BEGIN TRY
		UPDATE adm.SECTOR
		SET Nombre = COALESCE(@Nombre, Nombre)
		WHERE Sector_ID = @Sector_ID;
    
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

----DELETE (EN AZURE)
CREATE PROCEDURE adm.spDeleteSector
@Sector_ID int
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION;
	BEGIN TRY
		DELETE FROM adm.SECTOR
		WHERE Sector_ID = @Sector_ID;
    
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

----GET BY ID
CREATE PROCEDURE adm.spGetSectorById
@Sector_ID INT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Sector_ID, Nombre
	FROM adm.SECTOR
	WHERE Sector_ID = @Sector_ID
	IF @@ROWCOUNT = 0
		BEGIN
			RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
		END
END;

----GET (EN AZURE)
CREATE PROCEDURE adm.spGetSector
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Sector_ID, Nombre
	FROM adm.SECTOR;
END;