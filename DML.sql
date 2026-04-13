
--Procedimiento para Insertar, Actualizar y Eliminar
CREATE PROCEDURE SP_ManejarCancha
    @Accion VARCHAR(10), -- Puede ser 'GUARDAR', 'MODIFICAR' o 'BORRAR'
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

--El Trigger
CREATE TRIGGER TR_OcuparHorario
ON Reserva
AFTER INSERT -- Se activa justo DESPUÉS de hacer una reserva
AS
BEGIN
    -- Cambiamos la disponibilidad a 0 (Falso/Ocupado)
    UPDATE Horario
    SET disponible = 0
    -- Le decimos que lo haga solo en el horario que acabamos de reservar
    -- 'inserted' es la memoria temporal de lo que acabamos de guardar
    WHERE idHorario IN (SELECT idHorario FROM inserted);
    
    PRINT '¡OK! El horario se marcó como ocupado automáticamente.';
END;
GO
