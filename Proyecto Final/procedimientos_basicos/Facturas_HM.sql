--INSERT (EN AZURE)
CREATE PROCEDURE facturacion.spInsertFacturas
	@Empleado_ID int,
	@Reservacion_ID int,
	@Descuentos decimal(3,2)
	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY 
			BEGIN TRANSACTION 
			INSERT INTO facturacion.FACTURAS(Empleado_ID, Reservacion_ID, Descuentos)
			VALUES(@Empleado_ID, @Reservacion_ID, @Descuentos)
			COMMIT
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
				PRINT 'Se hizo RollBack'
				PRINT 'Error: ' + ERROR_MESSAGE();
				ROLLBACK;
		END CATCH
	END;

--UPDATE 
CREATE PROCEDURE facturacion.spUpdateFacturas
@Factura_ID int,
@Empleado_ID int = NULL,
@Reservacion_ID int,
@Descuentos decimal(3,2) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @Total decimal(10,2)
		UPDATE facturacion.FACTURAS
		SET Empleado_ID = COALESCE(@Empleado_ID, Empleado_ID),
			Descuentos = COALESCE(@Descuentos, Descuentos)
		WHERE Factura_ID = @Factura_ID;

		UPDATE facturacion.FACTURAS
		SET Total_Final = Total - Descuentos
		WHERE Factura_ID = @Factura_ID;


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
GO
CREATE PROCEDURE facturacion.spDeleteFacturas
@Factura_ID int
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY
	BEGIN TRANSACTION;
	DELETE FROM facturacion.FACTURAS
	WHERE Factura_ID = @Factura_ID;
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
GO
CREATE PROCEDURE facturacion.spGetFacturasById
@Factura_ID INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT *
	FROM facturacion.FACTURAS
	WHERE Factura_ID = @Factura_ID
	IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
    END
END;

--GET
GO
CREATE PROCEDURE facturacion.spGetFacturas
AS
BEGIN
SET NOCOUNT ON;

SELECT Factura_ID, Empleado_ID, Reservacion_ID, Total, Descuentos, Total_Final, Fecha_Emision
FROM facturacion.FACTURAS;
END