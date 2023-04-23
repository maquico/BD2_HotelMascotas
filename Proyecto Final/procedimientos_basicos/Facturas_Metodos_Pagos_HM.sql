--INSERT(EN AZURE)
CREATE PROCEDURE facturacion.spInsertFacturasMetodoPagos
@Factura_ID int,
@MetodoPago_ID int,
@Monto_Con_Metodo decimal(10,2)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
		INSERT INTO facturacion.FACTURAS_METODOS_PAGOS (Factura_ID, MetodoPago_ID, Monto_Con_Metodo)
		VALUES (@Factura_ID, @MetodoPago_ID, @Monto_Con_Metodo);
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

--UPDATE 
CREATE PROCEDURE facturacion.spUpdateFacturasMetodosPagos
(
@Factura_ID int,
@MetodoPago_ID int,
@Monto_Con_Metodo decimal(10,2)
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
    
		UPDATE facturacion.FACTURAS_METODOS_PAGOS
		SET Monto_Con_Metodo = @Monto_Con_Metodo
		WHERE Factura_ID = @Factura_ID AND MetodoPago_ID = @MetodoPago_ID;
    
		IF @@ROWCOUNT = 0
		BEGIN
			RAISERROR('No se encontró ningún registro con los ID especificados', 16, 1);
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
CREATE PROCEDURE facturacion.spDeleteFacturasMetodoPagos
@Factura_ID int,
@MetodoPago_ID int
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
    
		DELETE FROM facturacion.FACTURAS_METODOS_PAGOS
		WHERE Factura_ID = @Factura_ID AND MetodoPago_ID = @MetodoPago_ID;
    
		IF @@ROWCOUNT = 0
		BEGIN
			RAISERROR('No se encontró ningún registro con los ID especificados', 16, 1);
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

--GET BY ID (EN AZURE)
CREATE PROCEDURE facturacion.spGetFacturasMetodosPagosById
@Factura_ID int,
@MetodoPago_ID int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Factura_ID, MetodoPago_ID, Monto_Con_Metodo
	FROM facturacion.FACTURAS_METODOS_PAGOS
	WHERE Factura_ID = @Factura_ID AND MetodoPago_ID = @MetodoPago_ID;

	IF @@ROWCOUNT = 0
		BEGIN
			RAISERROR('No se encontró ningún registro con los ID especificado', 16, 1);
		END
END;

--GET (EN AZURE)
CREATE PROCEDURE facturacion.spGetFacturasMetodosPagos
AS
BEGIN
SET NOCOUNT ON;
SELECT Factura_ID, MetodoPago_ID, Monto_Con_Metodo
FROM facturacion.FACTURAS_METODOS_PAGOS;
END;