--PROCEDIMIENTOS:  INSERTAR, GETBYID, GETALL, UPDATE, DELETE
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--PRODUCTO (AGREGADOS, NO PROBADOS)
--Insertar Productos
CREATE PROCEDURE [adm].[spInsertProductos]
    @Nombre nvarchar(100),
    @Descripcion nvarchar(100),
    @Precio_Unidad decimal(10, 2),
    @Cantidad_Disp int,
    @Categoria_ID int,
    @Fecha_Registro datetime,
    @Suplidor_ID int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION; -- Iniciar la transacción

    BEGIN TRY
        INSERT INTO [adm].[PRODUCTOS] (Nombre, Descripcion, Precio_Unidad, Cantidad_Disp, Categoria_ID, Fecha_Registro, Suplidor_ID)
        VALUES (@Nombre, @Descripcion, @Precio_Unidad, @Cantidad_Disp, @Categoria_ID, @Fecha_Registro, @Suplidor_ID);

        COMMIT; -- Commit de la transacción si no hay errores
    END TRY
    BEGIN CATCH
        ROLLBACK; -- Deshacer la transacción en caso de error

        -- Manejar el error aquí
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

GO
--Get productos by ID
CREATE PROCEDURE [adm].[spGetProductosByID]
    @Producto_ID int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT Producto_ID, Nombre, Descripcion, Precio_Unidad, Cantidad_Disp, Categoria_ID, Fecha_Registro, Suplidor_ID
        FROM [adm].[PRODUCTOS]
        WHERE Producto_ID = @Producto_ID;

        COMMIT;
    END TRY
    BEGIN CATCH
        -- Manejar el error aquí
        IF @@TRANCOUNT > 0
            ROLLBACK;

        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO
--Get All productos
CREATE PROCEDURE [adm].[spGetAllProductos]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT Producto_ID, Nombre, Precio_Unidad, Cantidad_Disp, Categoria_ID, Suplidor_ID
        FROM [adm].[PRODUCTOS];

        COMMIT;
    END TRY
    BEGIN CATCH
        -- Manejar el error aquí
        IF @@TRANCOUNT > 0
            ROLLBACK;

        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

--Update Productos
CREATE PROCEDURE [adm].[spUpdateProductos]
    @Producto_ID INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(100),
    @Precio_Unidad DECIMAL(10, 2),
    @Cantidad_Disp INT,
    @Categoria_ID INT,
    @Fecha_Registro DATETIME,
    @Suplidor_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [adm].[PRODUCTOS]
        SET Nombre = COALESCE(@Nombre, Nombre),
            Descripcion = COALESCE(@Descripcion, Descripcion),
            Precio_Unidad = COALESCE(@Precio_Unidad, Precio_Unidad),
            Cantidad_Disp = COALESCE(@Cantidad_Disp, Cantidad_Disp),
            Categoria_ID = COALESCE(@Categoria_ID, Categoria_ID),
            Fecha_Registro = COALESCE(@Fecha_Registro, Fecha_Registro),
            Suplidor_ID = COALESCE(@Suplidor_ID, Suplidor_ID)
        WHERE Producto_ID = @Producto_ID;

        COMMIT;
    END TRY
    BEGIN CATCH
        -- Manejar el error aquí
        IF @@TRANCOUNT > 0
            ROLLBACK;

        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

--Delete Productos
CREATE PROCEDURE [adm].[spDeleteProducto]
    @Producto_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM [adm].[PRODUCTOS]
        WHERE Producto_ID = @Producto_ID;

        COMMIT;
    END TRY
    BEGIN CATCH
        -- Manejar el error aquí
        IF @@TRANCOUNT > 0
            ROLLBACK;

        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
