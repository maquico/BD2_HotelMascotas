--INSERT (EN AZURE)
	CREATE PROCEDURE adm.spInsertSuplidores
	@Nombre_Empresa nvarchar(100),
	@Nombre_Contacto nvarchar(100),
	@Telefono_Contacto nvarchar(100)
	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRANSACTION 

		BEGIN TRY
			INSERT INTO adm.SUPLIDORES
			VALUES(@Nombre_Empresa, @Nombre_Contacto, @Telefono_Contacto)
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

---UPDATE (EN AZURE)
CREATE PROCEDURE adm.spUpdateSuplidores
(
	@Suplidor_ID int,
    @Nombre_Empresa nvarchar(100) = NULL,
    @Nombre_Contacto nvarchar(100) = NULL,
    @Telefono_Contacto nvarchar(100) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY 
        
        UPDATE adm.SUPLIDORES
        SET Nombre_Empresa = COALESCE(@Nombre_Empresa, Nombre_Empresa),
            Nombre_Contacto = COALESCE(@Nombre_Contacto, Nombre_Contacto),
            Telefono_Contacto = COALESCE(@Telefono_Contacto, Telefono_Contacto)
        WHERE Suplidor_ID = @Suplidor_ID;
        
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
CREATE PROCEDURE adm.spDeleteSuplidores
    @Suplidor_ID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY

        DELETE FROM adm.SUPLIDORES
        WHERE Suplidor_ID = @Suplidor_ID;
        
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

--GET BY ID (EN AZURE)
CREATE PROCEDURE adm.spGetSuplidoresById
@Suplidor_ID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Suplidor_ID, Nombre_Empresa, Nombre_Contacto, Telefono_Contacto
    FROM adm.SUPLIDORES
    WHERE Suplidor_ID = @Suplidor_ID

	IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
    END

END;

--GET (EN AZURE)
CREATE PROCEDURE adm.spGetSuplidores
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Suplidor_ID, Nombre_Empresa, Nombre_Contacto, Telefono_Contacto
    FROM adm.SUPLIDORES;
END;
