-- Crear base de datos
CREATE DATABASE IsraelGym;
GO

USE IsraelGym;
GO

-- Tabla Rol
CREATE TABLE Rol (
    idRol INT IDENTITY(1,1) PRIMARY KEY,
    nombreRol VARCHAR(50) NOT NULL
);

INSERT INTO Rol ( nombreRol) values ( 'Administrador') , ( 'Colaborador');

SELECT * FROM Rol

-- Tabla Usuario
CREATE TABLE Usuario (
    idUsuario INT IDENTITY(1,1) PRIMARY KEY,
    Usuario VARCHAR(50) NOT NULL,
    Password VARCHAR(100) NOT NULL,
    EstadoUsuario VARCHAR(25) NOT NULL,
    email VARCHAR(100),
    fechaRegistro DATE DEFAULT GETDATE(),
    idRol INT,
    FOREIGN KEY (idRol) REFERENCES Rol(idRol)
);

select * from Usuario

INSERT INTO Usuario(Usuario,Password,EstadoUsuario,email,idRol) VALUES('Owen', '4321', 'ACTIVO', 'owen@gmail.com',1);

DELETE FROM Usuario WHERE idUsuario = '2';

-- Tabla Colaborador
CREATE TABLE Colaborador (
    idColaborador INT IDENTITY(1,1) PRIMARY KEY,
    idUsuario INT NOT NULL UNIQUE,
    primerNombreColab VARCHAR(50),
    segundoNombreColab VARCHAR(50),
    primerApellidoColab VARCHAR(50),
    segundoApellidoColab VARCHAR(50),
    telefColab VARCHAR(20),
    emailColab VARCHAR(100),
    direccionColab VARCHAR(100),
    fechaIngreso DATE,
    cargoColab VARCHAR(50),
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
);

-- Tabla Cliente
CREATE TABLE Cliente (
    idCliente INT IDENTITY(1,1) PRIMARY KEY,
    primerNomCliente VARCHAR(50),
    segundoNomCliente VARCHAR(50),
    primerApeCliente VARCHAR(50),
    segApeCliente VARCHAR(50),
    telefCliente VARCHAR(20),
    emailCliente VARCHAR(100),
    direccionCliente VARCHAR(100),
    Estado CHAR(1),
    fechaRegistro DATE DEFAULT GETDATE()
);



-- Tabla Proveedor
CREATE TABLE Proveedor (
    idProveedor INT IDENTITY(1,1) PRIMARY KEY,
    nombreProveedor VARCHAR(50),
    telefProveedor VARCHAR (8) ,
    direccProveedor VARCHAR(100)
);

INSERT INTO Proveedor(nombreProveedor, telefProveedor,direccProveedor)
VALUES('NicaMuscle', '89818902', 'Managua, Metrocentro');

select * from Proveedor
DELETE FROM Proveedor
-- Tabla Categoria
Create Table CategoriaProducto(
	idCategoria INT IDENTITY(1,1) PRIMARY KEY,
	nombreCategoria VARCHAR(50)
	);

-- Tabla Producto
CREATE TABLE Producto (
    idProducto INT IDENTITY(1,1) PRIMARY KEY,
    idCategoria INT,
    idProveedor INT,
	NombreProducto VARCHAR(50),
    descripcionProducto VARCHAR(100),
	precioProducto FLOAT,
	Costoproducto Float,
    estadoProducto VARCHAR(25),
    cantidadProducto INT,
    fechaIngresoProducto DATE DEFAULT GETDATE(),
    FOREIGN KEY (idCategoria) REFERENCES CategoriaProducto(idCategoria),
    FOREIGN KEY (idProveedor) REFERENCES Proveedor(idProveedor)
);

select * from Producto

ALTER TABLE Producto 
ADD	NombreProducto VARCHAR(50);

select *from CategoriaProducto;

Drop Table Product;

INSERT INTO CategoriaProducto(nombreCategoria) VALUES('Suplemento');

-- Tabla Compra
CREATE TABLE Compra (
    idCompra INT IDENTITY(1,1) PRIMARY KEY,
    idColaborador INT NOT NULL,
    fechaCompra DATE NOT NULL,
    totalCompra FLOAT,
    FOREIGN KEY (idColaborador) REFERENCES Colaborador(idColaborador)
);

-- Tabla detalleCompra
CREATE TABLE detalleCompra (
    idDetalleCompra INT IDENTITY(1,1) PRIMARY KEY,
    idCompra INT NOT NULL,
    idProducto INT NOT NULL,
    cantidadCompra INT NOT NULL,
    subtotalCompra FLOAT,
    FOREIGN KEY (idCompra) REFERENCES Compra(idCompra),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);

-- Tabla categoriaMembresia
CREATE TABLE categoriaMembresia (
    idCatMembresia INT IDENTITY(1,1) PRIMARY KEY,
    nombreCatMemb VARCHAR(50)
);

-- Tabla Membresia
CREATE TABLE Membresia (
    idMembresia INT IDENTITY(1,1) PRIMARY KEY,
    idCatMembresia INT,
    descripcion VARCHAR(100),
    duracionMembresia INT,
    precioMembresia FLOAT,
    FOREIGN KEY (idCatMembresia) REFERENCES categoriaMembresia(idCatMembresia)
);

-- Tabla detalleMembresia
CREATE TABLE detalleMembresia (
    idDetalleMembresia INT IDENTITY(1,1) PRIMARY KEY,
    idCliente INT,
    idMembresia INT,
    subtotalMembresia FLOAT,
    fechaInicio DATE,
    fechaFin DATE,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    FOREIGN KEY (idMembresia) REFERENCES Membresia(idMembresia)
);

-- Tabla Venta
CREATE TABLE Venta (
    idVenta INT IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    idColaborador INT NOT NULL,
    fechaVenta DATE NOT NULL,
    totalVenta FLOAT,
    formaPago DECIMAL(10,2),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    FOREIGN KEY (idColaborador) REFERENCES Colaborador(idColaborador)
);

-- Tabla detalleVenta
CREATE TABLE detalleVenta (
    idDetalleVenta INT IDENTITY(1,1) PRIMARY KEY,
    idVenta INT NOT NULL,
    idProducto INT NOT NULL,
    cantidadVenta INT NOT NULL,
    subtotalVenta FLOAT,
    FOREIGN KEY (idVenta) REFERENCES Venta(idVenta),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);

-- Tabla DevolucionVenta
CREATE TABLE DevolucionVenta (
    idDevolucion INT IDENTITY(1,1) PRIMARY KEY,
    idDetalleVenta INT NOT NULL,
    idCliente INT NOT NULL,
    fechaDevolucion DATE NOT NULL,
    motivo VARCHAR(255),
    cantidadDevuelta INT NOT NULL CHECK (cantidadDevuelta > 0),
    esReembolso BIT DEFAULT 0,
    aprobadaPor INT,
    FOREIGN KEY (idDetalleVenta) REFERENCES detalleVenta(idDetalleVenta),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    FOREIGN KEY (aprobadaPor) REFERENCES Colaborador(idColaborador)
);
