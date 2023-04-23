
--INSERT (EN AZURE)
CREATE PROCEDURE [facturacion].[spInsertFacturasProductos]
	@Factura_ID int,
	@Producto_ID int,
	@Cantidad int,
	@Descuento decimal(10,2)
	AS
	BEGIN 
		SET NOCOUNT ON;
		BEGIN TRANSACTION
		BEGIN TRY
		
		DECLARE @Precio_Unidad Decimal(10,2)
		SELECT @Precio_Unidad = Precio_Unidad
		FROM adm.PRODUCTOS
		WHERE Producto_ID = @Producto_ID

		INSERT INTO facturacion.FACTURA_PRODUCTOS(Factura_ID, Producto_ID, Cantidad, Precio_Unidad, Total, Descuento)
		VALUES(@Factura_ID, @Producto_ID, @Cantidad, @Precio_Unidad, [facturacion].[fnCalcularTotalDeProducto](@Cantidad, @Precio_Unidad, @Descuento), @Descuento)
		COMMIT
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
CREATE PROCEDURE facturacion.spUpdateFacturaProducto
(
@Factura_ID int,
@Producto_ID int,
@Cantidad int = null,
@Descuento decimal(3,2)=null
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
    BEGIN TRANSACTION;
	DECLARE @Total decimal(10,2)
	DECLARE @Precio_Unidad decimal(10,2)
	SELECT @Precio_Unidad = Precio_Unidad
	FROM adm.PRODUCTOS
	WHERE Producto_ID = @Producto_ID

    UPDATE facturacion.FACTURA_PRODUCTOS
    SET Cantidad = COALESCE(@Cantidad,Cantidad),
	Descuento = COALESCE(@Descuento, Descuento)
    WHERE Factura_ID = @Factura_ID AND Producto_ID = @Producto_ID;

	UPDATE facturacion.FACTURA_PRODUCTOS
	SET Total = [facturacion].[fnCalcularTotalDeProducto](Cantidad, Precio_Unidad, Descuento)
	WHERE Factura_ID = @Factura_ID AND Producto_ID = @Producto_ID;

    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No se encontró ningún registro con los IDs especificados', 16, 1);
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

--DELETE 
CREATE PROCEDURE facturacion.spDeleteFacturaProducto
(
@Factura_ID int,
@Producto_ID int
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
    BEGIN TRANSACTION;

    DELETE FROM facturacion.FACTURA_PRODUCTOS
    WHERE Factura_ID = @Factura_ID AND Producto_ID = @Producto_ID;

    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No se encontró ningún registro con los IDs especificados', 16, 1);
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

--GET BY ID 
CREATE PROCEDURE facturacion.spGetFacturaProductoById
(
@Factura_ID int,
@Producto_ID int
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Factura_ID, Producto_ID, Cantidad, Precio_Unidad, Descuento, Total
	FROM facturacion.FACTURA_PRODUCTOS
	WHERE Factura_ID = @Factura_ID AND Producto_ID = @Producto_ID;

	IF @@ROWCOUNT = 0
	BEGIN
		RAISERROR('No se encontró ningún registro con los IDs especificados', 16, 1);
	END
END;

--GET
CREATE PROCEDURE facturacion.spGetFacturaProductos
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Factura_ID, Producto_ID, Cantidad, Precio_Unidad, Descuento, Total
	FROM facturacion.FACTURA_PRODUCTOS;
END;
