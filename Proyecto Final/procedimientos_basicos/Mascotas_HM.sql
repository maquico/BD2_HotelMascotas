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

    BEGIN TRY
	    BEGIN TRANSACTION; -- Inicio de la transacción
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
		IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
			PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;


-- UPDATE MASCOTA
GO
CREATE PROCEDURE registro.spUpdateMascota
(
    @Mascota_ID int,
    @Nombre nvarchar(100),
    @Sexo_ID int,
    @Fecha_Nacimiento datetime,
    @Peso decimal(10,2),
    @Fecha_Ultimo_Celo datetime,
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
    SET NOCOUNT ON;
    BEGIN TRY

		DECLARE @Tamaño nvarchar(100)
			SELECT  @Tamaño = (
			CASE 
				WHEN @Peso < 14 THEN 'Pequeño'
				WHEN @Peso >=14 AND @Peso <25 THEN 'Mediano'
				ELSE 'Grande'
			END
			)

        BEGIN TRANSACTION;
        UPDATE registro.MASCOTAS
        SET
            Nombre = COALESCE(@Nombre, Nombre),
            Sexo_ID = COALESCE(@Sexo_ID, Sexo_ID),
            Fecha_Nacimiento = COALESCE(@Fecha_Nacimiento, Fecha_Nacimiento),
            Peso = COALESCE(@Peso, Peso),
            Fecha_Ultimo_Celo = COALESCE(@Fecha_Ultimo_Celo, Fecha_Ultimo_Celo),
            Tamaño = COALESCE(@Tamaño, Tamaño),
            Especie_ID = COALESCE(@Especie_ID, Especie_ID),
            Raza_Primaria_ID = COALESCE(@Raza_Primaria_ID, Raza_Primaria_ID),
            Dueño_ID = COALESCE(@Dueño_ID, Dueño_ID),
            Microchip = COALESCE(@Microchip, Microchip),
            Nota = COALESCE(@Nota, Nota),
            Color_ID = COALESCE(@Color_ID, Color_ID),
            Tarjeta_File_Name = COALESCE(@Tarjeta_File_Name, Tarjeta_File_Name),
            Tarjeta_File_Path = COALESCE(@Tarjeta_File_Path, Tarjeta_File_Path),
            Foto_File_Name = COALESCE(@Foto_File_Name, Foto_File_Name),
            Foto_File_Path = COALESCE(@Foto_File_Path, Foto_File_Path)
        WHERE Mascota_ID = @Mascota_ID;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
		COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
			PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END


-- DELETE MASCOTA
GO
CREATE PROCEDURE registro.spDeleteMascota
(
    @Mascota_ID int
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM registro.MASCOTAS
        WHERE Mascota_ID = @Mascota_ID;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
		COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
			PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END


-- GetByID MASCOTA
GO
CREATE PROCEDURE registro.spGetMascotaById
(
    @Mascota_ID int
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM registro.MASCOTAS
    WHERE Mascota_ID = @Mascota_ID;

	IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
        END
END


-- GetAll MASCOTA
GO
CREATE PROCEDURE registro.spGetMascotas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM registro.MASCOTAS;
END
