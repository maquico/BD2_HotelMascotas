--Procedimiento para ESTATUS


-- Insertar Estatus
CREATE PROCEDURE [adm].[spInsertEstatus]
	@Nombre [nvarchar](100) -- Par�metro para el nombre del estatus a insertar
AS
BEGIN
	-- Inicio de la transacci�n
	BEGIN TRY
		BEGIN TRANSACTION
		
		-- Insertar el nuevo estatus en la tabla [adm].[ESTATUS]
		INSERT INTO [adm].[ESTATUS] ([Nombre])
		VALUES (@Nombre)
		
		-- Confirmar la transacci�n
		COMMIT TRANSACTION
		
	END TRY
	BEGIN CATCH
		-- Si ocurre un error, deshacer la transacci�n
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION
		
		-- Mostrar el mensaje de error utilizando PRINT
		PRINT 'Error al insertar el estatus. Detalles: ' + ERROR_MESSAGE()
	END CATCH
END
GO

-- Buscar por ID

GO
-- Crear el stored procedure
CREATE PROCEDURE [adm].[spBuscarEstatusPorID]
	@Estatus_ID [int] -- Par�metro para el ID del estatus a buscar
AS
BEGIN
	-- Inicio de la transacci�n
	BEGIN TRY
		BEGIN TRANSACTION
		
		-- Declarar variables
		DECLARE @Nombre [nvarchar](100)
		
		-- Buscar el estatus por su ID
		SELECT @Nombre = [Nombre]
		FROM [adm].[ESTATUS]
		WHERE [Estatus_ID] = @Estatus_ID
		
		-- Si se encuentra el estatus, mostrar el resultado
		IF @Nombre IS NOT NULL
			PRINT 'Estatus encontrado: ' + @Nombre
		ELSE
			PRINT 'No se encontr� ning�n estatus con el ID especificado.'
		
		-- Confirmar la transacci�n
		COMMIT TRANSACTION
		
	END TRY
	BEGIN CATCH
		-- Si ocurre un error, deshacer la transacci�n
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION
		
		-- Mostrar el mensaje de error utilizando PRINT
		PRINT 'Error al buscar el estatus por ID. Detalles: ' + ERROR_MESSAGE()
	END CATCH
END
GO

-- Obtener todos los estados
GO

-- Crear el stored procedure
CREATE PROCEDURE [adm].[spGetAllEstatus]
AS
BEGIN
	-- Inicio de la transacci�n
	BEGIN TRY
		BEGIN TRANSACTION
		
		-- Obtener todos los estados
		SELECT *
		FROM [adm].[ESTATUS]
		
		-- Confirmar la transacci�n
		COMMIT TRANSACTION
		
	END TRY
	BEGIN CATCH
		-- Si ocurre un error, deshacer la transacci�n
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION
		
		-- Mostrar el mensaje de error utilizando PRINT
		PRINT 'Error al obtener todos los estados. Detalles: ' + ERROR_MESSAGE()
	END CATCH
END
GO

-- Actualizar Estados

-- Crear el stored procedure
CREATE PROCEDURE [adm].[spUpdateEstatus]
	@Estatus_ID [int], -- Par�metro para el ID del estatus a actualizar
	@Nombre [nvarchar](100) -- Par�metro para el nuevo nombre del estatus
AS
BEGIN
	-- Inicio de la transacci�n
	BEGIN TRY
		BEGIN TRANSACTION
		
		-- Actualizar el estatus en la tabla
		UPDATE [adm].[ESTATUS]
		SET [Nombre] = COALESCE(@Nombre, [Nombre]) -- Utilizar COALESCE para manejar valores nulos
		WHERE [Estatus_ID] = @Estatus_ID
		
		-- Confirmar la transacci�n
		COMMIT TRANSACTION
		
		-- Mostrar mensaje de �xito
		PRINT 'El estatus se ha actualizado exitosamente.'
		
	END TRY
	BEGIN CATCH
		-- Si ocurre un error, deshacer la transacci�n
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION
		
		-- Mostrar el mensaje de error utilizando PRINT
		PRINT 'Error al actualizar el estatus. Detalles: ' + ERROR_MESSAGE()
	END CATCH
END
GO


