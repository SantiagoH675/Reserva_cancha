CREATE PROCEDURE SP_GestionarCancha
    @Accion VARCHAR(10), -- 'INSERT', 'UPDATE', 'DELETE'
    @idCancha INT = NULL,
    @nombre VARCHAR(50) = NULL,
    @tipo VARCHAR(20) = NULL,
    @ubicacion VARCHAR(80) = NULL,
    @estado VARCHAR(15) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Accion = 'INSERT'
    BEGIN
        INSERT INTO Cancha (nombre, tipo, ubicacion, estado)
        VALUES (@nombre, @tipo, @ubicacion, @estado);
        PRINT 'Cancha insertada correctamente.';
    END

    ELSE IF @Accion = 'UPDATE'
    BEGIN
        UPDATE Cancha
        SET nombre = ISNULL(@nombre, nombre),
            tipo = ISNULL(@tipo, tipo),
            ubicacion = ISNULL(@ubicacion, ubicacion),
            estado = ISNULL(@estado, estado)
        WHERE idCancha = @idCancha;
        PRINT 'Cancha actualizada correctamente.';
    END

    ELSE IF @Accion = 'DELETE'
    BEGIN
        -- Nota: Si la cancha tiene horarios asignados, fallará por integridad referencial.
        DELETE FROM Cancha WHERE idCancha = @idCancha;
        PRINT 'Cancha eliminada correctamente.';
    END
END;
GO


SELECT 
    c.idCancha, 
    c.nombre, 
    AVG(p.valor) AS PromedioReservas
FROM Cancha c
INNER JOIN Horario h ON c.idCancha = h.idCancha
INNER JOIN Reserva r ON h.idHorario = r.idHorario
INNER JOIN Pago p ON r.idReserva = p.idReserva
WHERE r.fechaReserva >= DATEADD(MONTH, -3, GETDATE())
GROUP BY c.idCancha, c.nombre;

CREATE PROCEDURE SP_PromedioReservasCancha
    @idCancha INT
AS
BEGIN
    SELECT 
        c.nombre AS Cancha, 
        AVG(p.valor) AS Promedio_Ultimos_3_Meses
    FROM Cancha c
    INNER JOIN Horario h ON c.idCancha = h.idCancha
    INNER JOIN Reserva r ON h.idHorario = r.idHorario
    INNER JOIN Pago p ON r.idReserva = p.idReserva
    WHERE c.idCancha = @idCancha 
      AND r.fechaReserva >= DATEADD(MONTH, -3, GETDATE())
    GROUP BY c.nombre;
END;
GO

SELECT 
    u.idUsuario,
    u.nombres,
    u.apellidos,
    COUNT(r.idReserva) AS ReservasNoPagadas
FROM [Usuario Deportivo] u
INNER JOIN Reserva r ON u.idUsuario = r.idUsuario
LEFT JOIN Pago p ON r.idReserva = p.idReserva
WHERE p.estadoPago = 'Pendiente' OR p.idPago IS NULL
GROUP BY u.idUsuario, u.nombres, u.apellidos;

CREATE PROCEDURE SP_ReservasNoPagadasUsuario
    @idCancha INT
AS
BEGIN
    SELECT 
        u.nombres,
        u.apellidos,
        COUNT(r.idReserva) AS Cantidad_Reservas_Sin_Pagar
    FROM [Usuario Deportivo] u
    INNER JOIN Reserva r ON u.idUsuario = r.idUsuario
    INNER JOIN Horario h ON r.idHorario = h.idHorario
    LEFT JOIN Pago p ON r.idReserva = p.idReserva
    WHERE h.idCancha = @idCancha 
      AND (p.estadoPago = 'Pendiente' OR p.idPago IS NULL)
    GROUP BY u.nombres, u.apellidos;
END;
GO

CREATE PROCEDURE SP_ReservasNoPagadasUsuario
    @idCancha INT
AS
BEGIN
    SELECT 
        u.nombres,
        u.apellidos,
        COUNT(r.idReserva) AS Cantidad_Reservas_Sin_Pagar
    FROM [Usuario Deportivo] u
    INNER JOIN Reserva r ON u.idUsuario = r.idUsuario
    INNER JOIN Horario h ON r.idHorario = h.idHorario
    LEFT JOIN Pago p ON r.idReserva = p.idReserva
    WHERE h.idCancha = @idCancha 
      AND (p.estadoPago = 'Pendiente' OR p.idPago IS NULL)
    GROUP BY u.nombres, u.apellidos;
END;
GO

CREATE TRIGGER TR_ActualizarDisponibilidadHorario
ON Reserva
AFTER INSERT
AS
BEGIN
    -- Este trigger actualiza la tabla horario y la marca como no disponible (0)
    -- automáticamente cuando se inserta una nueva reserva.
    UPDATE Horario
    SET disponible = 0
    FROM Horario h
    INNER JOIN inserted i ON h.idHorario = i.idHorario;
    
    PRINT 'Disponibilidad del horario actualizada por el Trigger.';
END;
GO

SELECT 
    c.tipo AS TipoDeCancha,
    COUNT(r.idReserva) AS TotalReservas,
    SUM(p.valor) AS IngresosTotales
FROM Cancha c
INNER JOIN Horario h ON c.idCancha = h.idCancha
INNER JOIN Reserva r ON h.idHorario = r.idHorario
INNER JOIN Pago p ON r.idReserva = p.idReserva
WHERE p.estadoPago = 'Pagado'
GROUP BY c.tipo
HAVING SUM(p.valor) > 0
ORDER BY IngresosTotales DESC;