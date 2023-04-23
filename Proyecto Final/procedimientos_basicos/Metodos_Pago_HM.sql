--INSERT
GO
CREATE PROCEDURE adm.spInsertMetodoPago
    @Nombre nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO adm.[METODOS_PAGOS] ([Nombre])
        VALUES (@Nombre);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END

--UPDATE
GO
CREATE PROCEDURE adm.spUpdateMetodoPago
@Metodo_Pago_ID int,
@Nombre nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY

        BEGIN TRANSACTION;
        UPDATE adm.[METODOS_PAGOS]
        SET [Nombre] = @Nombre
        WHERE [Metodo_Pago_ID] = @Metodo_Pago_ID;

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
GO
CREATE PROCEDURE adm.spDeleteMetodoPago
@Metodo_Pago_ID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DELETE FROM adm.[METODOS_PAGOS]
        WHERE [Metodo_Pago_ID] = @Metodo_Pago_ID;
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
GO
CREATE PROCEDURE adm.spGetMetodosPago
AS
BEGIN
SET NOCOUNT ON;
SELECT [Metodo_Pago_ID], [Nombre]
FROM adm.[METODOS_PAGOS];
END

--GET BY ID
GO
CREATE PROCEDURE adm.spGetMetodoPagoById
@Metodo_Pago_ID int
AS
BEGIN
SET NOCOUNT ON;
SELECT [Metodo_Pago_ID], [Nombre]
FROM adm.[METODOS_PAGOS]
WHERE [Metodo_Pago_ID] = @Metodo_Pago_ID;

IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
    END
END