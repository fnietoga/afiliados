-- V1__Create_Afiliados_Table.sql
-- Script para crear la tabla de Afiliados

CREATE TABLE Afiliados (
    AfiliadoId INT IDENTITY(1,1) PRIMARY KEY,
    DNI NVARCHAR(20) NOT NULL UNIQUE,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    Telefonos NVARCHAR(MAX) NULL, -- Puede almacenar una lista o JSON de teléfonos
    Email NVARCHAR(255) NOT NULL UNIQUE,
    NumeroAfiliado NVARCHAR(50) NOT NULL UNIQUE,
    NNGG BIT NOT NULL DEFAULT 0, -- Nuevas Generaciones (0 = No, 1 = Sí)
    FechaAfiliacion DATE NOT NULL,
    AltaWeb BIT NOT NULL DEFAULT 0, -- Alta a través de la web (0 = No, 1 = Sí)
    Sexo NVARCHAR(20) NULL,
    Nacionalidad NVARCHAR(100) NULL,
    PaisOrigen NVARCHAR(100) NULL,
    FechaCreacion DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    FechaModificacion DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

-- Opcional: Crear un trigger para actualizar FechaModificacion automáticamente en cada UPDATE
-- (La implementación exacta puede variar ligeramente según la versión de SQL Server/Azure SQL DB
-- y si se prefiere manejar esto a nivel de aplicación o base de datos)

-- Ejemplo de Trigger (revisar y adaptar si es necesario):
/*
IF OBJECT_ID('TRG_Afiliados_UpdateFechaModificacion', 'TR') IS NOT NULL
    DROP TRIGGER TRG_Afiliados_UpdateFechaModificacion;
GO

CREATE TRIGGER TRG_Afiliados_UpdateFechaModificacion
ON Afiliados
AFTER UPDATE
AS
BEGIN
    IF NOT UPDATE(FechaModificacion) -- Evitar recursividad si FechaModificacion se actualiza explícitamente
    BEGIN
        UPDATE A
        SET FechaModificacion = GETUTCDATE()
        FROM Afiliados AS A
        INNER JOIN inserted AS I ON A.AfiliadoId = I.AfiliadoId;
    END
END;
GO
*/
