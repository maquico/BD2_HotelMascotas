

-- Crear el stored procedure
CREATE PROCEDURE [registro].[spGetHistoricoEstatusByReservacionID]
	@Reservacion_ID [int] -- Parámetro para el ID de la reservación
AS
BEGIN
	-- Inicio de la transacción
	BEGIN TRY
		BEGIN TRANSACTION
		
		-- Consultar el historial de estatus por el ID de la reservación
		SELECT [Estatus_ID], [Reservacion_ID], [Fecha_Registro]
		FROM [registro].[HISTORICO_ESTATUS]
		WHERE [Reservacion_ID] = @Reservacion_ID
		
		-- Confirmar la transacción
		COMMIT TRANSACTION
		
	END TRY
	BEGIN CATCH
		-- Si ocurre un error, deshacer la transacción
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION
		
		-- Mostrar el mensaje de error utilizando PRINT
		PRINT 'Error al obtener el historial de estatus. Detalles: ' + ERROR_MESSAGE()
	END CATCH
END
GO

-- Obtener todos los historicos estatus

-- Crear el stored procedure
CREATE PROCEDURE [registro].[spGetAllHistoricoEstatus]
AS
BEGIN
	-- Inicio de la transacción
	BEGIN TRY
		BEGIN TRANSACTION
		
		-- Consultar todos los registros de historial de estatus
		SELECT *
		FROM [registro].[HISTORICO_ESTATUS]
		ORDER BY Estatus_ID
		
		-- Confirmar la transacción
		COMMIT TRANSACTION
		
	END TRY
	BEGIN CATCH
		-- Si ocurre un error, deshacer la transacción
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION
		
		-- Mostrar el mensaje de error utilizando PRINT
		PRINT 'Error al obtener todos los registros de historial de estatus. Detalles: ' + ERROR_MESSAGE()
	END CATCH
END
GO





