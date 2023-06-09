--INSERT
GO
CREATE PROCEDURE adm.spInsertRol
@Nombre nvarchar(100)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT INTO adm.[ROLES] ([Nombre])
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
CREATE PROCEDURE adm.spUpdateRol
@Rol_ID int,
@Nombre nvarchar(100)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
BEGIN TRANSACTION;
UPDATE adm.[ROLES]
SET [Nombre] = @Nombre
WHERE [Rol_ID] = @Rol_ID;
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
CREATE PROCEDURE adm.spDeleteRol
@Rol_ID int
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
BEGIN TRANSACTION;
DELETE FROM adm.[ROLES]
WHERE [Rol_ID] = @Rol_ID;
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

--GET
GO
CREATE PROCEDURE adm.spGetRol
AS
BEGIN
SET NOCOUNT ON;
SELECT [Rol_ID], [Nombre]
FROM adm.[ROLES];
END

--GET BY ID
GO
CREATE PROCEDURE adm.spGetRolById
@Rol_ID int
AS
BEGIN
SET NOCOUNT ON;
SELECT [Rol_ID], [Nombre]
FROM adm.[ROLES]
WHERE [Rol_ID] = @Rol_ID;
IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No se encontró ningún registro con el ID especificado', 16, 1);
    END
END