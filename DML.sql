
USE [Reservas Canchas];
GO

/*1. Insertar y/o actualizar, eliminar (Explique en que momento se puede realizar inserciones y borrados
teniendo en cuenta la integridad referencial, es decir, las relaciones, las claves primarias y foráneas)*/

--Procedimiento para Insertar, Actualizar y Eliminar
CREATE PROCEDURE SP_ManejarCancha
    @Accion VARCHAR(10), --'GUARDAR', 'MODIFICAR' o 'BORRAR'
    @idCancha INT,
    @nombre VARCHAR(50),
    @tipo VARCHAR(20),
    @ubicacion VARCHAR(80),
    @estado VARCHAR(15)
AS
BEGIN
    -- 1. Si la acción es GUARDAR, insertamos los datos
    IF @Accion = 'GUARDAR'
    BEGIN
        INSERT INTO Cancha (nombre, tipo, ubicacion, estado)
        VALUES (@nombre, @tipo, @ubicacion, @estado);
        PRINT 'Se guardó la cancha nueva.';
    END

    -- 2. Si la acción es MODIFICAR, actualizamos los datos
    IF @Accion = 'MODIFICAR'
    BEGIN
        UPDATE Cancha
        SET nombre = @nombre, tipo = @tipo, ubicacion = @ubicacion, estado = @estado
        WHERE idCancha = @idCancha;
        PRINT 'Se actualizaron los datos.';
    END

    -- 3. Si la acción es BORRAR, eliminamos la cancha
    IF @Accion = 'BORRAR'
    BEGIN
        DELETE FROM Cancha WHERE idCancha = @idCancha;
        PRINT 'Se borró la cancha.';
    END
END;
GO

--Ejecutar el Procedimiento para Insertar una Cancha
--Guardamos una cancha nueva
EXEC SP_ManejarCancha 
    @Accion = 'GUARDAR', 
    @idCancha = 0, 
    @nombre = 'Cancha de Fútbol Central', 
    @tipo = 'Futbol', 
    @ubicacion = 'Bloque Norte', 
    @estado = 'Disponible';

SELECT * FROM Cancha;

--Modificar los datos de una cancha existente.
EXEC SP_ManejarCancha 
    @Accion = 'MODIFICAR', 
    @idCancha = 11, 
    @nombre = 'Cancha Fútbol Pro', 
    @tipo = 'Futbol', 
    @ubicacion = 'Bloque Norte - Editado', 
    @estado = 'Mantenimiento';    -- Nuevo estado

SELECT * FROM Cancha;

--Eliminar una cancha existente.
EXEC SP_ManejarCancha 
    @Accion = 'BORRAR', 
    @idCancha = 11, 
    @nombre = '', 
    @tipo = '', 
    @ubicacion = '', 
    @estado = '';

SELECT * FROM Cancha;
--Procedimiento para Insertar, Actualizar y Eliminar Usuario
CREATE PROCEDURE SP_ManejarUsuario
    @Accion VARCHAR(10), --'GUARDAR', 'MODIFICAR' o 'BORRAR'
    @idUsuario INT,
    @nombres VARCHAR(60),
    @apellidos VARCHAR(60),
    @documento VARCHAR(20),
    @telefono VARCHAR(20),
    @correo VARCHAR(100),
    @estado VARCHAR(15)
AS
BEGIN
    -- 1. Si la acción es GUARDAR
    IF @Accion = 'GUARDAR'
    BEGIN
        INSERT INTO [Usuario Deportivo] (nombres, apellidos, documento, telefono, correo, estado)
        VALUES (@nombres, @apellidos, @documento, @telefono, @correo, @estado);
        PRINT 'Se guardó el usuario nuevo.';
    END

    -- 2. Si la acción es MODIFICAR
    IF @Accion = 'MODIFICAR'
    BEGIN
        UPDATE [Usuario Deportivo]
        SET nombres = @nombres, apellidos = @apellidos, documento = @documento, telefono = @telefono, correo = @correo, estado = @estado
        WHERE idUsuario = @idUsuario;
        PRINT 'Se actualizaron los datos del usuario.';
    END

    -- 3. Si la acción es BORRAR
    IF @Accion = 'BORRAR'
    BEGIN
        DELETE FROM [Usuario Deportivo] WHERE idUsuario = @idUsuario;
        PRINT 'Se borró el usuario.';
    END
END;
GO

-- 1. Guardar un usuario nuevo
EXEC SP_ManejarUsuario 
    @Accion = 'GUARDAR', @idUsuario = 0, 
    @nombres = 'Carlos', @apellidos = 'Ramirez', @documento = '100200300', 
    @telefono = '3001234567', @correo = 'carlos.r@mail.com', @estado = 'Activo';

-- 2. Modificar un usuario existente 
EXEC SP_ManejarUsuario 
    @Accion = 'MODIFICAR', @idUsuario = 11, 
    @nombres = 'Carlos Andres', @apellidos = 'Ramirez', @documento = '100200300', 
    @telefono = '3119998877', @correo = 'carlos.r@mail.com', @estado = 'Inactivo';

-- 3. Borrar un usuario
EXEC SP_ManejarUsuario 
    @Accion = 'BORRAR', @idUsuario = 1, 
    @nombres = '', @apellidos = '', @documento = '', 
    @telefono = '', @correo = '', @estado = '';

SELECT * FROM [Usuario Deportivo];

--Procedimiento para Insertar, Actualizar y Eliminar Horario
CREATE PROCEDURE SP_ManejarHorario
    @Accion VARCHAR(10),
    @idHorario INT,
    @idCancha INT,
    @fecha DATE,
    @horaInicio TIME,
    @horaFin TIME,
    @disponible BIT
AS
BEGIN
    IF @Accion = 'GUARDAR'
    BEGIN
        INSERT INTO Horario (idCancha, fecha, horaInicio, horaFin, disponible)
        VALUES (@idCancha, @fecha, @horaInicio, @horaFin, @disponible);
        PRINT 'Se guardó el horario nuevo.';
    END

    IF @Accion = 'MODIFICAR'
    BEGIN
        UPDATE Horario
        SET idCancha = @idCancha, fecha = @fecha, horaInicio = @horaInicio, horaFin = @horaFin, disponible = @disponible
        WHERE idHorario = @idHorario;
        PRINT 'Se actualizaron los datos del horario.';
    END

    IF @Accion = 'BORRAR'
    BEGIN
        DELETE FROM Horario WHERE idHorario = @idHorario;
        PRINT 'Se borró el horario.';
    END
END;
GO

-- 1. Guardar un horario nuevo 
EXEC SP_ManejarHorario 
    @Accion = 'GUARDAR', @idHorario = 0, 
    @idCancha = 1, @fecha = '2026-04-15', 
    @horaInicio = '08:00', @horaFin = '09:00', @disponible = 1;

-- 2. Modificar un horario existente 
EXEC SP_ManejarHorario 
    @Accion = 'MODIFICAR', @idHorario = 11, 
    @idCancha = 1, @fecha = '2026-04-15', 
    @horaInicio = '10:00', @horaFin = '11:00', @disponible = 0;

select * from Horario;
-- 3. Borrar un horario
EXEC SP_ManejarHorario 
    @Accion = 'BORRAR', @idHorario = 1, 
    @idCancha = 0, @fecha = '2026-01-01', 
    @horaInicio = '00:00', @horaFin = '00:00', @disponible = 0;

select * from Horario;

--Procedimiento para Insertar, Actualizar y Eliminar Reserva
CREATE PROCEDURE SP_ManejarReserva
    @Accion VARCHAR(10),
    @idReserva INT,
    @idUsuario INT,
    @idHorario INT,
    @fechaReserva DATETIME,
    @estado VARCHAR(15)
AS
BEGIN
    IF @Accion = 'GUARDAR'
    BEGIN
        INSERT INTO Reserva (idUsuario, idHorario, fechaReserva, estado)
        VALUES (@idUsuario, @idHorario, @fechaReserva, @estado);
        PRINT 'Se guardó la reserva.';
    END

    IF @Accion = 'MODIFICAR'
    BEGIN
        UPDATE Reserva
        SET idUsuario = @idUsuario, idHorario = @idHorario, fechaReserva = @fechaReserva, estado = @estado
        WHERE idReserva = @idReserva;
        PRINT 'Se actualizaron los datos de la reserva.';
    END

    IF @Accion = 'BORRAR'
    BEGIN
        DELETE FROM Reserva WHERE idReserva = @idReserva;
        PRINT 'Se borró la reserva.';
    END
END;
GO

-- 1. Guardar una reserva nueva 
EXEC SP_ManejarReserva 
    @Accion = 'GUARDAR', @idReserva = 0, 
    @idUsuario = 11, @idHorario = 11, 
    @fechaReserva = '2026-04-14 08:00:00', @estado = 'Activa';

-- 2. Modificar una reserva existente
EXEC SP_ManejarReserva 
    @Accion = 'MODIFICAR', @idReserva = 1, 
    @idUsuario = 1, @idHorario = 1, 
    @fechaReserva = '2026-04-14 08:00:00', @estado = 'Cancelada';

-- 3. Borrar una reserva
EXEC SP_ManejarReserva 
    @Accion = 'BORRAR', @idReserva = 1, 
    @idUsuario = 0, @idHorario = 0, 
    @fechaReserva = '2026-01-01', @estado = '';

--Procedimiento para Insertar, Actualizar y Eliminar Pago
CREATE PROCEDURE SP_ManejarPago
    @Accion VARCHAR(10),
    @idPago INT,
    @idReserva INT,
    @fechaPago DATETIME,
    @valor DECIMAL(10,2),
    @metodoPago VARCHAR(20),
    @estadoPago VARCHAR(15)
AS
BEGIN
    IF @Accion = 'GUARDAR'
    BEGIN
        INSERT INTO Pago (idReserva, fechaPago, valor, metodoPago, estadoPago)
        VALUES (@idReserva, @fechaPago, @valor, @metodoPago, @estadoPago);
        PRINT 'Se guardó el pago correctamente.';
    END

    IF @Accion = 'MODIFICAR'
    BEGIN
        UPDATE Pago
        SET idReserva = @idReserva, fechaPago = @fechaPago, valor = @valor, metodoPago = @metodoPago, estadoPago = @estadoPago
        WHERE idPago = @idPago;
        PRINT 'Se actualizaron los datos del pago.';
    END

    IF @Accion = 'BORRAR'
    BEGIN
        DELETE FROM Pago WHERE idPago = @idPago;
        PRINT 'Se borró el pago del sistema.';
    END
END;
GO

-- 1. Guardar un pago nuevo 
EXEC SP_ManejarPago 
    @Accion = 'GUARDAR', @idPago = 0, 
    @idReserva = 1, @fechaPago = '2026-04-14 08:30:00', 
    @valor = 45000, @metodoPago = 'Nequi', @estadoPago = 'Pagado';

select * from Pago;

-- 2. Modificar un pago existente 
EXEC SP_ManejarPago 
    @Accion = 'MODIFICAR', @idPago = 1, 
    @idReserva = 1, @fechaPago = '2026-04-14 08:30:00', 
    @valor = 45000, @metodoPago = 'Transferencia', @estadoPago = 'Pendiente';

-- 3. Borrar un pago
EXEC SP_ManejarPago 
    @Accion = 'BORRAR', @idPago = 1, 
    @idReserva = 0, @fechaPago = '2026-01-01', 
    @valor = 0, @metodoPago = '', @estadoPago = '';

-------------------------------------------------------
-------------------------------------------------------
--Consultas desde Cero (INNER JOIN, GROUP BY y HAVING)
SELECT 
    u.nombres, 
    COUNT(r.idReserva) AS Cantidad_Reservas
FROM [Usuario Deportivo] u
INNER JOIN Reserva r ON u.idUsuario = r.idUsuario
GROUP BY u.nombres
HAVING COUNT(r.idReserva) > 1;


--Buscar un Elemento (Con Mensaje)
CREATE PROCEDURE SP_BuscarUsuario
    @Documento VARCHAR(20)
AS
BEGIN
    -- Declaramos una variable para contar si el usuario existe
    DECLARE @Existe INT;
    
    -- Contamos cuántos usuarios tienen ese documento (Debería ser 1 o 0)
    SELECT @Existe = COUNT(*) FROM [Usuario Deportivo] WHERE documento = @Documento;

    -- Si es mayor a 0, significa que sí existe
    IF @Existe > 0
    BEGIN
        -- Mostramos los datos uniendo Usuario y Reserva
        SELECT u.nombres, u.documento, r.fechaReserva, r.estado
        FROM [Usuario Deportivo] u
        INNER JOIN Reserva r ON u.idUsuario = r.idUsuario
        WHERE u.documento = @Documento;
    END
    ELSE
    BEGIN
        -- Si es 0, no existe y mandamos este mensaje
        PRINT 'ATENCIÓN: No encontramos ningún usuario con ese documento.';
    END
END;
GO

--Dos Funciones
--Función 1: Sumar el dinero que ha pagado un usuario.
CREATE FUNCTION FN_DineroPagado (@idUsuario INT)
RETURNS DECIMAL(10,2) -- Devuelve dinero (decimal)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2);
    
    -- Unimos las tablas Pago y Reserva para sumar la plata de ese usuario
    SELECT @Total = SUM(p.valor)
    FROM Pago p
    INNER JOIN Reserva r ON p.idReserva = r.idReserva
    WHERE r.idUsuario = @idUsuario;
    
    -- Si no ha pagado nada, le ponemos un cero para que no salga vacío (NULL)
    IF @Total IS NULL 
        SET @Total = 0;
        
    RETURN @Total;
END;
GO

--Función 2: Contar cuántos horarios tiene asignados una cancha.
CREATE FUNCTION FN_ContarHorariosCancha (@idCancha INT)
RETURNS INT -- Devuelve un número entero
AS
BEGIN
    DECLARE @Cantidad INT;
    
    -- Unimos Cancha y Horario para contar
    SELECT @Cantidad = COUNT(h.idHorario)
    FROM Cancha c
    INNER JOIN Horario h ON c.idCancha = h.idCancha
    WHERE c.idCancha = @idCancha;
    
    RETURN @Cantidad;
END;
GO

/* ============================================================================
   PUNTO 6: TRIGGER PARA ACTUALIZAR DISPONIBILIDAD DEL HORARIO
   ============================================================================ */

USE [Reservas Canchas]
GO

-- 1. Verificamos si el trigger ya existe y lo borramos
IF OBJECT_ID('TR_DescontarDisponibilidad') IS NOT NULL 
    DROP TRIGGER TR_DescontarDisponibilidad;
GO

-- 2. Creamos el Trigger
CREATE TRIGGER TR_DescontarDisponibilidad
ON Reserva
AFTER INSERT -- Actúa automáticamente justo DESPUÉS de insertar una reserva
AS
BEGIN   
    -- Actualizamos la tabla Horario
    UPDATE Horario
    SET disponible = 0 -- 0 significa que ya no está disponible
    -- Le decimos que solo afecte al horario específico que se acaba de reservar
    WHERE idHorario IN (SELECT idHorario FROM inserted);

    PRINT 'Trigger ejecutado: El horario ha sido marcado como NO disponible.';
END;
GO

