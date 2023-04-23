--Drop procedure adm.spInsertCategorias
--INSERT(EN AZURE)
	CREATE PROCEDURE adm.spInsertCategorias
	@Nombre nvarchar(100),
	@Descripcion nvarchar(100)
	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRANSACTION 

		BEGIN TRY
			INSERT INTO adm.CATEGORIAS
			VALUES(@Nombre, @Descripcion)
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
	
	--drop procedure adm.spUpdateCategorias
---UPDATE (EN AZURE)
CREATE PROCEDURE adm.spUpdateCategorias
	@Categoria_ID int,
	@Nombre nvarchar(100) = null,
	@Descripcion nvarchar(100) = null
	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRANSACTION 
		BEGIN TRY
			UPDATE adm.CATEGORIAS
			SET Nombre = COALESCE(@Nombre, Nombre),
				Descripcion = COALESCE(@Descripcion, Descripcion)
			WHERE Categoria_ID = @Categoria_ID;
    
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

	--drop procedure adm.spDeleteCategorias
---DELETE (EN AZURE)
CREATE PROCEDURE adm.spDeleteCategorias
	@Categoria_ID int
	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRANSACTION 

		BEGIN TRY
			DELETE FROM adm.CATEGORIAS
			WHERE Categoria_ID = @Categoria_ID

			IF @@ROWCOUNT = 0
				BEGIN
				RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
				END
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

----GET BY ID (EN AZURE)
CREATE PROCEDURE adm.spGetCategoriaById
@Categoria_ID INT
AS
BEGIN
SET NOCOUNT ON;
SELECT Categoria_ID, Nombre, Descripcion
FROM adm.CATEGORIAS
WHERE Categoria_ID = @Categoria_ID
IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
    END
END;

-----GET (EN AZURE)
CREATE PROCEDURE adm.spGetCategorias
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Categoria_ID, Nombre, Descripcion
	FROM adm.CATEGORIAS;
END;