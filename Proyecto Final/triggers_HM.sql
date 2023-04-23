--SUMAR MONTO DE ESTADIA A MONTO RESERVACION
--Agregado y Probado
IF OBJECT_ID('trActualizarMontoReservacion', 'TR') IS NOT NULL
    DROP TRIGGER trActualizarMontoReservacion;
GO

CREATE TRIGGER trActualizarMontoReservacion
ON registro.MASCOTA_RESERVACION
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        UPDATE registro.RESERVACIONES
        SET Monto_Reservacion = Monto_Reservacion + i.Monto_Estadia
        FROM registro.RESERVACIONES AS r
        INNER JOIN inserted AS i ON r.Reservacion_ID = i.Reservacion_ID;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;



--COLOCAR HABITACION DESOCUPADA CUANDO ACABE UNA RESERVACION
--Agregado y probado
CREATE OR ALTER TRIGGER registro.trActualizarHabitacion
ON registro.RESERVACIONES
AFTER UPDATE
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
    IF UPDATE(Estatus_ID)  --Finalizado
    BEGIN
		IF EXISTS (SELECT 1 FROM inserted WHERE Estatus_ID = 3)
			UPDATE adm.HABITACIONES
        SET Ocupada = 0
        WHERE Habitacion_ID IN 
            (SELECT Habitacion_ID 
            FROM registro.MASCOTA_RESERVACION 
            WHERE Reservacion_ID IN 
                (SELECT Reservacion_ID 
                FROM inserted ));
		ELSE IF EXISTS (SELECT 1 FROM inserted WHERE Estatus_ID = 2)
			UPDATE adm.HABITACIONES
        SET Ocupada = 1
        WHERE Habitacion_ID IN 
            (SELECT Habitacion_ID 
            FROM registro.MASCOTA_RESERVACION 
            WHERE Reservacion_ID IN 
                (SELECT Reservacion_ID 
                FROM inserted ));
    END;
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
	ROLLBACK TRANSACTION
	END CATCH
END;

--INSERTAR EN HISTORICO ESTATUS CADA VEZ QUE SE CAMBIE EL ESTATUS DE LA RESERVACION
--AGREGADO Y PROBADO
IF EXISTS (
    SELECT *
    FROM sys.triggers
    WHERE object_id = OBJECT_ID(N'[registro].[trInsertHistoricoEstatus]')
)
DROP TRIGGER [registro].[trInsertHistoricoEstatus];
GO
CREATE TRIGGER [registro].[trInsertHistoricoEstatus]
ON registro.RESERVACIONES
AFTER UPDATE, INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Estatus_ID)
    BEGIN
        INSERT INTO registro.HISTORICO_ESTATUS (Estatus_ID, Reservacion_ID)
        SELECT i.Estatus_ID, i.Reservacion_ID
        FROM inserted i;
    END
END


-- Trigger Restar cantidad producto facturado 
-- Agregado y probado

CREATE TRIGGER facturacion.trRestarCantidadProdcutoFacturado
ON facturacion.Factura_Productos
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRANSACTION
		BEGIN TRY
			DECLARE @CantidadFacturada int
			UPDATE adm.PRODUCTOS SET Cantidad_Disp = Cantidad_Disp - @CantidadFacturada
			SELECT @CantidadFacturada = cantidad
			FROM inserted i
			INNER JOIN adm.PRODUCTOS p ON i.Producto_ID = p.Producto_ID
			WHERE i.Producto_ID = p.Producto_ID
		COMMIT
		END TRY

	BEGIN CATCH
		PRINT 'Error: ' + ERROR_MESSAGE();
		ROLLBACK
	END CATCH
	
END



--Trigger para registrar las vacunas por defecto en mascota vacuna al insertar las mascotas (En Azure)
--Agregado y probado
--Drop trigger registro.trActualizarVacunasEspecies
CREATE TRIGGER registro.trActualizarVacunasEspecies
ON registro.MASCOTAS
AFTER INSERT
AS
BEGIN
	BEGIN TRANSACTION 
	BEGIN TRY
		DECLARE @Mascota_ID int
		DECLARE @Especie_ID int 
		SELECT @Especie_ID = inserted.Especie_ID FROM INSERTED 
		SELECT @Mascota_ID = inserted.Mascota_ID FROM INSERTED
		INSERT INTO registro.MASCOTA_VACUNA(Mascota_ID, Vacuna_ID, Verificado) VALUES(@Mascota_ID, 2, 0)
		INSERT INTO registro.MASCOTA_VACUNA(Mascota_ID, Vacuna_ID, Verificado) VALUES(@Mascota_ID, 4, 0)
		INSERT INTO registro.MASCOTA_VACUNA(Mascota_ID, Vacuna_ID, Verificado) VALUES(@Mascota_ID, 5, 0)
		IF @Especie_ID = 1
		BEGIN
			INSERT INTO registro.MASCOTA_VACUNA(Mascota_ID, Vacuna_ID, Verificado) VALUES(@Mascota_ID, 1, 0)
			INSERT INTO registro.MASCOTA_VACUNA(Mascota_ID, Vacuna_ID, Verificado) VALUES(@Mascota_ID, 3, 0)
		END
		ELSE
		BEGIN
			INSERT INTO registro.MASCOTA_VACUNA(Mascota_ID, Vacuna_ID, Verificado) VALUES(@Mascota_ID, 6, 0)
			INSERT INTO registro.MASCOTA_VACUNA(Mascota_ID, Vacuna_ID, Verificado) VALUES(@Mascota_ID, 7, 0)
		END
		COMMIT;
	END TRY

	BEGIN CATCH 
		PRINT 'Se hizo RollBack'
		PRINT 'Error: ' + ERROR_MESSAGE();
		ROLLBACK;
	END CATCH
END;


--Trigger para insertar los productos de producto factura en la factura correspondiente(En Azure)
--drop trigger facturacion.trRecalcularTotalFactura
--Agregado
CREATE TRIGGER facturacion.trRecalcularTotalFactura
ON facturacion.FACTURA_PRODUCTOS
AFTER INSERT, UPDATE, DELETE
AS

BEGIN
	BEGIN TRANSACTION 
	BEGIN TRY
		 
		DECLARE @Total_Productos decimal(10,2), @Total_Servicios decimal(10,2),
				@Total_Reservacion decimal(10,2), @Total decimal(10,2),
				@Factura_ID int

		 IF EXISTS (SELECT 1 FROM INSERTED i)
			BEGIN
			SELECT @Factura_ID= i.Factura_ID FROM inserted AS i
			END
		ELSE
			BEGIN
			SELECT @Factura_ID= d.Factura_ID FROM deleted AS d
			END
		
		SELECT @Total_Reservacion = Total_Reservacion, @Total_Servicios = Total_Servicios
		FROM facturacion.FACTURAS
		WHERE Factura_ID = @Factura_ID

		SET @Total_Productos = facturacion.fnCalcularTotalProductos(@Factura_ID)
		SET @Total = @Total_Reservacion + @Total_Servicios + @Total_Productos
		
		UPDATE facturacion.FACTURAS
		SET Total = @Total,
		Total_Productos = @Total_Productos
		Total_Final = @Total * (1 - Descuentos)
		WHERE Factura_ID = @Factura_ID

		COMMIT;
	END TRY

	BEGIN CATCH 
		PRINT 'Error: ' + ERROR_MESSAGE();
		ROLLBACK;
	END CATCH
END;