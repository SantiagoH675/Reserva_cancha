
CREATE DATABASE [Reservas Canchas];
GO

USE [Reservas Canchas];
GO

CREATE TABLE [Usuario Deportivo](
    idUsuario INT IDENTITY(1,1) PRIMARY KEY,
    nombres VARCHAR(60) NOT NULL,
    apellidos VARCHAR(60) NOT NULL,
    documento VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    estado VARCHAR(15) NOT NULL,
    CONSTRAINT CK_UsuarioDeportivo_Estado CHECK (estado IN ('Activo', 'Inactivo'))
);
GO

CREATE TABLE Cancha(
    idCancha INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    tipo VARCHAR(20) NOT NULL,
    ubicacion VARCHAR(80) NOT NULL,
    estado VARCHAR(15) NOT NULL,
    CONSTRAINT CK_Cancha_Tipo CHECK (tipo IN ('Futbol', 'Tenis', 'Squash', 'Voleibol')),
    CONSTRAINT CK_Cancha_Estado CHECK (estado IN ('Disponible', 'Mantenimiento', 'Inactiva'))
);
GO

CREATE TABLE Horario(
    idHorario INT IDENTITY(1,1) PRIMARY KEY,
    idCancha INT NOT NULL,
    fecha DATE NOT NULL,
    horaInicio TIME NOT NULL,
    horaFin TIME NOT NULL,
    disponible BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Horario_Cancha FOREIGN KEY (idCancha) REFERENCES Cancha (idCancha),
    CONSTRAINT CK_Horario_Horas CHECK (horaInicio < horaFin),
    CONSTRAINT UQ_Horario_Cancha_Fecha_Hora UNIQUE (idCancha, fecha, horaInicio, horaFin)
);
GO

CREATE TABLE Reserva(
    idReserva INT IDENTITY(1,1) PRIMARY KEY,
    idUsuario INT NOT NULL,
    idHorario INT NOT NULL UNIQUE, -- Se unifica el Unique constraint de horario
    fechaReserva DATETIME NOT NULL DEFAULT GETDATE(),
    estado VARCHAR(15) NOT NULL,
    CONSTRAINT CK_Reserva_Estado CHECK (estado IN ('Activa', 'Cancelada', 'Finalizada')),
    CONSTRAINT FK_Reserva_Usuario FOREIGN KEY (idUsuario) REFERENCES [Usuario Deportivo] (idUsuario),
    CONSTRAINT FK_Reserva_Horario FOREIGN KEY (idHorario) REFERENCES Horario (idHorario)
);
GO

CREATE TABLE Pago(
    idPago INT IDENTITY(1,1) PRIMARY KEY,
    idReserva INT NOT NULL UNIQUE, -- Unique porque es un pago por reserva
    fechaPago DATETIME NOT NULL DEFAULT GETDATE(),
    valor DECIMAL(10,2) NOT NULL,
    metodoPago VARCHAR(20) NOT NULL,
    estadoPago VARCHAR(15) NOT NULL,
    CONSTRAINT CK_Pago_Valor CHECK (valor > 0),
    CONSTRAINT CK_Pago_Metodo CHECK (metodoPago IN ('Efectivo', 'Tarjeta', 'Transferencia', 'Nequi', 'Daviplata')),
    CONSTRAINT CK_Pago_Estado CHECK (estadoPago IN ('Pagado', 'Pendiente', 'Rechazado')),
    CONSTRAINT FK_Pago_Reserva FOREIGN KEY (idReserva) REFERENCES Reserva (idReserva)
);
GO