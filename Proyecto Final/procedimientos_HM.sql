

--MASCOTAS
    --INSERT AGREGADO Y PROBADO
CREATE PROCEDURE registro.spInsertMascota
(
    @Nombre nvarchar(100),
    @Sexo_ID int,
    @Fecha_Nacimiento datetime,
    @Peso decimal(10, 2),
    @Fecha_Ultimo_Celo datetime = NULL,
    @Especie_ID int,
    @Raza_Primaria_ID int,
    @Dueño_ID int,
    @Microchip nvarchar(100),
    @Nota nvarchar(200),
    @Color_ID int,
    @Tarjeta_File_Name nvarchar(255),
    @Tarjeta_File_Path nvarchar(255),
    @Foto_File_Name nvarchar(255),
    @Foto_File_Path nvarchar(255)
)
AS
BEGIN
	SET NOCOUNT ON
    BEGIN TRANSACTION; -- Inicio de la transacción

    BEGIN TRY

		DECLARE @Tamaño nvarchar(100)
		SELECT  @Tamaño = (
		CASE 
			WHEN @Peso < 14 THEN 'Pequeño'
			WHEN @Peso >=14 AND @Peso <25 THEN 'Mediano'
			ELSE 'Grande'
		END
		)
		
        -- Insertar la nueva mascota en la tabla MASCOTAS
        INSERT INTO [registro].[MASCOTAS] (
            [Nombre],
            [Sexo_ID],
            [Fecha_Nacimiento],
            [Peso],
            [Fecha_Ultimo_Celo],
            [Tamaño],
            [Especie_ID],
            [Raza_Primaria_ID],
            [Dueño_ID],
            [Microchip],
            [Nota],
            [Color_ID],
            [Tarjeta_File_Name],
            [Tarjeta_File_Path],
            [Foto_File_Name],
            [Foto_File_Path]
        )
        VALUES (
            @Nombre,
            @Sexo_ID,
            @Fecha_Nacimiento,
            @Peso,
            @Fecha_Ultimo_Celo,
            @Tamaño,
            @Especie_ID,
            @Raza_Primaria_ID,
            @Dueño_ID,
            @Microchip,
            @Nota,
            @Color_ID,
            @Tarjeta_File_Name,
            @Tarjeta_File_Path,
            @Foto_File_Name,
            @Foto_File_Path
        );

        COMMIT; -- Confirmar la transacción si no hay errores
    END TRY
    BEGIN CATCH
		PRINT 'Se hizo Rollback'
		PRINT 'Error: ' + ERROR_MESSAGE();
        ROLLBACK; -- Deshacer la transacción si ocurre un error
       
    END CATCH
END;

--RESERVACION
    --CANCELAR AGREGADO y PROBADO
IF OBJECT_ID('spCancelarReservacion', 'SP') IS NOT NULL
    DROP PROCEDURE spCancelarReservacion;
GO
CREATE PROCEDURE spCancelarReservacion(
    @reservacion_ID
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRANSACTION
        BEGIN TRY
            UPDATE registro.Reservaciones
            SET Estatus_ID =  4
            WHERE Reservacion_ID = @reservacion_ID
        COMMIT TRANSACTION; 
        END TRY
        BEGIN CATCH
        PRINT 'Se hizo Rollback'
		PRINT 'Error: ' + ERROR_MESSAGE();
        ROLLBACK;
        END CATCH
END;

--HISTORICO ESTATUS
    --INSERT agregado y probado
CREATE PROCEDURE registro.spInsertHistoricoEstatus
    @Estatus_ID int,
    @Reservacion_ID int
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		IF @Estatus_ID IS NOT NULL
        BEGIN
		
        INSERT INTO registro.HISTORICO_ESTATUS (Estatus_ID, Reservacion_ID)
        VALUES (@Estatus_ID, @Reservacion_ID);
		
		END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        PRINT 'Error en spInsertHistoricoEstatus: ' + ERROR_MESSAGE();
    END CATCH
END;


-- Procedimiento agregar servicio aplicado 
--AGREGADO y Probado

CREATE PROCEDURE registro.spAgregarServicioAplicado(
@Reservacion_ID int,
@Servicio_ID int,
@Mascota_ID int
)
AS
BEGIN 
SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION
		DECLARE @Cancelado int, @CantidadAplicada int, @CantidadUnidad int
			SELECT @Cancelado = ss.Cancelado,
			@CantidadAplicada = ss.Cantidad_Aplicada,
			@CantidadUnidad = ss.Cantidad_Unidad
			FROM registro.SERVICIOS_SOLICITADOS ss
			WHERE (Reservacion_ID = @Reservacion_ID) AND (Servicio_ID = @Servicio_ID) AND (Mascota_ID = @Mascota_ID);

			IF (@Cancelado = 0 AND @CantidadAplicada < @CantidadUnidad)
			BEGIN	
				UPDATE registro.SERVICIOS_SOLICITADOS SET Cantidad_Aplicada =  Cantidad_Aplicada + 1
				WHERE (Reservacion_ID = @Reservacion_ID) AND (Servicio_ID = @Servicio_ID) AND (Mascota_ID = @Mascota_ID)
				EXEC registro.spInsertHistoricoServicios 
				@Mascota_ID = @Mascota_ID, 
				@Servicio_ID = @Servicio_ID, 
				@Reservacion_ID = @Reservacion_ID,
				@Descripcion = 'Servicio Aplicado'
			END
		COMMIT
	END TRY
	BEGIN CATCH
		PRINT 'Error: ' + ERROR_MESSAGE();
		ROLLBACK TRANSACTION
	END CATCH

END

-- Procedimiento actualizar estatus de reservacion
--Agregado y probado
CREATE PROCEDURE registro.spActualizarEstatusReservaciones
AS
BEGIN
    SET XACT_ABORT OFF
    SET NOCOUNT ON
    BEGIN TRY
        DECLARE @fecha_actual DATETIME
        SELECT @fecha_actual = GETDATE()
        
            UPDATE registro.RESERVACIONES
            SET Estatus_ID = registro.fnCalcularEstatusReservacion(Fecha_Inicio, Fecha_Fin, @fecha_actual)
            WHERE (Estatus_ID = 2 OR Estatus_ID = 1) AND (Estatus_ID != registro.fnCalcularEstatusReservacion(Fecha_inicio, Fecha_fin, @fecha_actual))
    END TRY

    BEGIN CATCH
        PRINT 'Error en spActualizar: ' + ERROR_MESSAGE();
        PRINT ERROR_LINE();
        PRINT ERROR_PROCEDURE();
    END CATCH;
END

	--Procedure para registrar la verificacion de las vacunas de una mascota (En Azure)
	--Agregado y probado
	--drop procedure registro.spVerificarMascota
	CREATE OR ALTER PROCEDURE registro.spVerificarMascota
	@Mascota_ID INT,
	@Vacuna_ID INT
	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY 
			BEGIN TRANSACTION 
			UPDATE registro.MASCOTA_VACUNA
			SET Verificado = 1
			WHERE Mascota_ID = @Mascota_ID AND Vacuna_ID = @Vacuna_ID
			COMMIT
		END TRY
		BEGIN CATCH
		PRINT 'Se hizo RollBack'
		PRINT 'Error: ' + ERROR_MESSAGE();
		ROLLBACK;
		END CATCH
	END;

    --drop procedure registro.spInsertarTotalServicios
---Procedimiento para registrar el total de los servicios en Servicios Solicitados (En Azure)
--Agregado y probado
	CREATE OR ALTER PROCEDURE registro.spInsertarTotalServicios
	@Reservacion_ID int
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION 
	BEGIN TRY 
		DECLARE @Cantidad_Aplicada int,
			@Precio_Unidad_Cobrado decimal(10,2),
			@Descuento decimal (3,2),
			@Cancelado bit,
			@Total decimal(10,2);

		DECLARE servicios_cursor CURSOR FOR 
		SELECT Cantidad_Aplicada, Precio_Unidad_Cobrado, Descuento, Cancelado
		FROM registro.SERVICIOS_SOLICITADOS
		WHERE Reservacion_ID = @Reservacion_ID

		OPEN servicios_cursor;

		FETCH NEXT FROM servicios_cursor INTO @Cantidad_Aplicada, @Precio_Unidad_Cobrado, @Descuento, @Cancelado;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @Total = registro.fnCalcularTotalServicio(@Cantidad_Aplicada, @Precio_Unidad_Cobrado, @Descuento, @Cancelado);

			UPDATE registro.SERVICIOS_SOLICITADOS 
			SET Total = @Total
			WHERE CURRENT OF servicios_cursor;

			FETCH NEXT FROM servicios_cursor INTO @Cantidad_Aplicada, @Precio_Unidad_Cobrado, @Descuento, @Cancelado;
		END

		CLOSE servicios_cursor;
		DEALLOCATE servicios_cursor;

		COMMIT;
	END TRY
	BEGIN CATCH
		PRINT 'Se hizo RollBack'
		PRINT 'Error: ' + ERROR_MESSAGE();
		ROLLBACK;
	END CATCH
END;

	-- spCancelarServicio
	--AGREGADO y Probado
CREATE PROCEDURE registro.spCancelarServicio(
@Reservacion_IDaC int,
@Servicio_IDaC int,
@Mascota_IDaC int)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION
		DECLARE @Cancelado bit
				SELECT @Cancelado = ss.Cancelado
				FROM registro.SERVICIOS_SOLICITADOS ss
				WHERE  (Reservacion_ID = @Reservacion_IDaC) AND (Servicio_ID = @Servicio_IDaC) AND (Mascota_ID = @Mascota_IDaC)

				IF(@Cancelado = 0) 
				BEGIN
				UPDATE registro.SERVICIOS_SOLICITADOS SET Cancelado = 1
						WHERE (Reservacion_ID = @Reservacion_IDaC) AND (Servicio_ID = @Servicio_IDaC) AND (Mascota_ID = @Mascota_IDaC)
						EXEC registro.spInsertHistoricoServicios 
						@Mascota_ID = @Mascota_IDaC, 
						@Servicio_ID = @Servicio_IDaC, 
						@Reservacion_ID = @Reservacion_IDaC,
						@Descripcion = 'Servicio Cancelado'
				END
		COMMIT
	END TRY
	BEGIN CATCH
		PRINT 'Error: ' + ERROR_MESSAGE();
		ROLLBACK TRANSACTION
	END CATCH
END
 --Actualizar total factura
-- NO FUNCIONA, PROBAR
CREATE PROCEDURE [facturacion].[spActualizarTotalFactura]
@Factura_ID int
AS
BEGIN
	
	SET NOCOUNT ON;
	BEGIN TRANSACTION 
	BEGIN TRY
		DECLARE @Reservacion_ID INT, @Total_Productos DECIMAL(10,2), @Total_Reservacion DECIMAL(10,2),
				@Total_Servicios DECIMAL(10,2), @Total DECIMAL(10,2), @Cantidad_Facturas_Reservacion int,
				@Actual_Reservacion DECIMAL(10,2), @Actual_Servicios DECIMAL(10,2)

		IF EXISTS(SELECT  1 FROM facturacion.FACTURAS WHERE Factura_ID = @Factura_ID)
			BEGIN
				SELECT  @Reservacion_ID = Reservacion_ID, @Actual_Reservacion = Total_Reservacion,
				@Actual_Servicios = Total_Servicios
				FROM facturacion.FACTURAS
				WHERE Factura_ID = @Factura_ID
			END
		ELSE
			BEGIN
				RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
			END

		SET @Cantidad_Facturas_Reservacion =(SELECT COUNT(*) 
											FROM facturacion.FACTURAS 
											WHERE Reservacion_ID = @Reservacion_ID)
		
		IF @Cantidad_Facturas_Reservacion > 1
			BEGIN
				EXEC registro.spInsertarTotalServicios @Reservacion_ID = @Reservacion_ID
						PRINT 'Se actualizaron los totales de servicios aplicados'
				SET @Total_Reservacion = 0
			END
		ELSE IF @Cantidad_Facturas_Reservacion = 1
			BEGIN
				SET @Total_Reservacion = (SELECT Monto_Reservacion FROM registro.RESERVACIONES 
									WHERE Reservacion_ID = @Reservacion_ID)
				IF @Total_Reservacion != 0 
					BEGIN
						EXEC registro.spInsertHistoricoEstatus @Estatus_ID = 6, @Reservacion_ID = @Reservacion_ID
					END
			END
		
		SET @Total_Productos = facturacion.fnCalcularTotalProductos (@Factura_ID)
		SET @Total_Servicios = facturacion.fnCalcularTotalServicios (@Factura_ID)
		SET @Total = @Total_Reservacion + @Total_Productos + @Total_Servicios

		IF @Actual_Reservacion = 0 AND @Actual_Servicios = 0
		BEGIN
			UPDATE facturacion.FACTURAS
			SET Total = @Total,
			Total_Final = @Total * (1-Descuentos),
			Total_Productos = @Total_Productos
			WHERE Factura_ID = @Factura_ID

			IF NOT EXISTS (SELECT 1 FROM registro.HISTORICO_ESTATUS WHERE Estatus_ID = 6 AND Reservacion_ID = @Reservacion_ID)
				UPDATE facturacion.FACTURAS
				SET Total_Reservacion = @Total_Reservacion
				WHERE Factura_ID = @Factura_ID
			ELSE IF NOT EXISTS (SELECT 1 FROM registro.HISTORICO_ESTATUS WHERE Estatus_ID = 5 AND Reservacion_ID = @Reservacion_ID)
				UPDATE facturacion.FACTURAS
				SET Total_Servicios = @Total_Servicios
				WHERE Factura_ID = @Factura_ID
		END

		IF @Total_Servicios != 0 
					BEGIN
						EXEC registro.spInsertHistoricoEstatus @Estatus_ID = 5, @Reservacion_ID = @Reservacion_ID
					END
		
		
		COMMIT;
	END TRY
	BEGIN CATCH
			PRINT 'Error: ' + ERROR_MESSAGE();
			ROLLBACK;
		END CATCH
END;

--EL MACO, VERSION ACTUAL
CREATE OR ALTER PROCEDURE [facturacion].[spActualizarTotalFactura]
@Factura_ID int
AS
BEGIN
	
	SET NOCOUNT ON;
	BEGIN TRANSACTION 
	BEGIN TRY
		DECLARE @Reservacion_ID INT, @Total_Productos DECIMAL(10,2), @Total_Reservacion DECIMAL(10,2),
				@Total_Servicios DECIMAL(10,2), @Total DECIMAL(10,2), @Cantidad_Facturas_Reservacion int

		IF EXISTS(SELECT  1 FROM facturacion.FACTURAS WHERE Factura_ID = @Factura_ID)
			BEGIN
				SELECT  @Reservacion_ID = Reservacion_ID
				FROM facturacion.FACTURAS
				WHERE Factura_ID = @Factura_ID
			END
		ELSE
			BEGIN
				RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
			END


		SET @Cantidad_Facturas_Reservacion =(SELECT COUNT(*) 
											FROM facturacion.FACTURAS 
											WHERE Reservacion_ID = @Reservacion_ID)
		
		IF @Cantidad_Facturas_Reservacion > 1
			BEGIN
				EXEC registro.spInsertarTotalServicios @Reservacion_ID = @Reservacion_ID
						PRINT 'Se actualizaron los totales de servicios aplicados'
				SET @Total_Reservacion = 0
			END
		ELSE IF @Cantidad_Facturas_Reservacion = 1
			BEGIN
				SET @Total_Reservacion = (SELECT Monto_Reservacion FROM registro.RESERVACIONES 
									WHERE Reservacion_ID = @Reservacion_ID)
			END
		
		SET @Total_Productos = facturacion.fnCalcularTotalProductos (@Factura_ID)
		SET @Total_Servicios = COALESCE(facturacion.fnCalcularTotalServicios (@Factura_ID), 0)
		SET @Total = @Total_Reservacion + @Total_Productos + @Total_Servicios

		UPDATE facturacion.FACTURAS
		SET Total = @Total,
		Total_Final = @Total * (1-Descuentos),
		Total_Productos = @Total_Productos,
		Total_Reservacion = @Total_Reservacion,
		Total_Servicios = @Total_Servicios
		WHERE Factura_ID = @Factura_ID

		COMMIT;
	END TRY
	BEGIN CATCH
			PRINT 'Error: ' + ERROR_MESSAGE();
			ROLLBACK;
		END CATCH
END;

CREATE OR ALTER PROCEDURE [registro].[spGetHistoricoEstatusByReservacionID]
@Reservacion_ID int
AS
BEGIN
	SELECT * 
	FROM registro.HISTORICO_ESTATUS
	WHERE Reservacion_ID = @Reservacion_ID
END


CREATE OR ALTER PROCEDURE [registro].[spGetHistoricoServiciosByReservacionID]
@Reservacion_ID int
AS
BEGIN
	SELECT * 
	FROM registro.HISTORICO_SERVICIOS
	WHERE Reservacion_ID = @Reservacion_ID
END



CREATE PROCEDURE facturacion.spVistaFacturasReservacion @Reservacion_ID INT
AS
BEGIN
	SELECT * 
	FROM registro.vwFacturasReservacion
	WHERE Reservacion_ID = @Reservacion_ID
END

CREATE PROCEDURE facturacion.spVistaServiciosReservacion @Reservacion_ID INT
AS
BEGIN
	SELECT * 
	FROM registro.vwServiciosReservacion
	WHERE Reservacion_ID = @Reservacion_ID
END

CREATE OR ALTER PROCEDURE registro.spGetHabitacionByReservacionId @Reservacion_ID INT
AS
BEGIN
	SELECT * 
	FROM adm.HABITACIONES
	WHERE Habitacion_ID = 
	(SELECT Habitacion_ID 
	FROM registro.MASCOTA_RESERVACION 
	WHERE Reservacion_ID = @Reservacion_ID)
END
