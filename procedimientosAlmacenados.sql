use IsraelGym



-- Crear Rol
CREATE PROCEDURE sp_CrearRol
    @nombreRol VARCHAR(50)
AS
BEGIN
    INSERT INTO Rol(nombreRol)
    VALUES(@nombreRol)
    
    RETURN SCOPE_IDENTITY()
END
GO

-- Leer todos los Roles
CREATE PROCEDURE sp_LeerRoles
AS
BEGIN
    SELECT idRol, nombreRol FROM Rol
END
GO

-- Leer Rol por ID
CREATE PROCEDURE sp_LeerRolPorID
    @idRol INT
AS
BEGIN
    SELECT idRol, nombreRol FROM Rol
    WHERE idRol = @idRol
END
GO

-- Actualizar Rol
CREATE PROCEDURE sp_ActualizarRol
    @idRol INT,
    @nombreRol VARCHAR(50)
AS
BEGIN
    UPDATE Rol SET
        nombreRol = @nombreRol
    WHERE idRol = @idRol
    
    RETURN @@ROWCOUNT
END
GO

-- Eliminar Rol
CREATE PROCEDURE sp_EliminarRol
    @idRol INT
AS
BEGIN
    DELETE FROM Rol
    WHERE idRol = @idRol
    
    RETURN @@ROWCOUNT
END
GO





-- Crear Usuario
CREATE PROCEDURE sp_CrearUsuario
    @Usuario VARCHAR(50),
    @Password VARCHAR(100),
    @EstadoUsuario VARCHAR(25),
    @email VARCHAR(100),
    @idRol INT
AS
BEGIN
    INSERT INTO Usuario(Usuario, Password, EstadoUsuario, email, idRol)
    VALUES(@Usuario, @Password, @EstadoUsuario, @email, @idRol)
    
    RETURN SCOPE_IDENTITY()
END
GO

-- Leer todos los Usuarios
CREATE PROCEDURE sp_LeerUsuarios
AS
BEGIN
    SELECT u.idUsuario, u.Usuario, u.EstadoUsuario, u.email, u.fechaRegistro, 
           r.idRol, r.nombreRol
    FROM Usuario u
    INNER JOIN Rol r ON u.idRol = r.idRol
END
GO

-- Leer Usuario por ID
CREATE PROCEDURE sp_LeerUsuarioPorID
    @idUsuario INT
AS
BEGIN
    SELECT u.idUsuario, u.Usuario, u.EstadoUsuario, u.email, u.fechaRegistro, 
           r.idRol, r.nombreRol
    FROM Usuario u
    INNER JOIN Rol r ON u.idRol = r.idRol
    WHERE u.idUsuario = @idUsuario
END
GO

-- Leer Usuario por nombre de usuario
CREATE PROCEDURE sp_LeerUsuarioPorNombre
    @Usuario VARCHAR(50)
AS
BEGIN
    SELECT u.idUsuario, u.Usuario, u.Password, u.EstadoUsuario, u.email, u.fechaRegistro, 
           r.idRol, r.nombreRol
    FROM Usuario u
    INNER JOIN Rol r ON u.idRol = r.idRol
    WHERE u.Usuario = @Usuario
END
GO

-- Actualizar Usuario
CREATE PROCEDURE sp_ActualizarUsuario
    @idUsuario INT,
    @Usuario VARCHAR(50),
    @Password VARCHAR(100),
    @EstadoUsuario VARCHAR(25),
    @email VARCHAR(100),
    @idRol INT
AS
BEGIN
    UPDATE Usuario SET
        Usuario = @Usuario,
        Password = @Password,
        EstadoUsuario = @EstadoUsuario,
        email = @email,
        idRol = @idRol
    WHERE idUsuario = @idUsuario
    
    RETURN @@ROWCOUNT
END
GO

-- Cambiar estado de Usuario
CREATE PROCEDURE sp_CambiarEstadoUsuario
    @idUsuario INT,
    @EstadoUsuario VARCHAR(25)
AS
BEGIN
    UPDATE Usuario SET
        EstadoUsuario = @EstadoUsuario
    WHERE idUsuario = @idUsuario
    
    RETURN @@ROWCOUNT
END
GO

-- Eliminar Usuario
CREATE PROCEDURE sp_EliminarUsuario
    @idUsuario INT
AS
BEGIN
    DELETE FROM Usuario
    WHERE idUsuario = @idUsuario
    
    RETURN @@ROWCOUNT
END
GO





-- Crear Colaborador
CREATE PROCEDURE sp_CrearColaborador
    @idUsuario INT,
    @primerNombreColab VARCHAR(50),
    @segundoNombreColab VARCHAR(50) = NULL,
    @primerApellidoColab VARCHAR(50),
    @segundoApellidoColab VARCHAR(50) = NULL,
    @telefColab VARCHAR(20) = NULL,
    @emailColab VARCHAR(100) = NULL,
    @direccionColab VARCHAR(100) = NULL,
    @fechaIngreso DATE,
    @cargoColab VARCHAR(50)
AS
BEGIN
    INSERT INTO Colaborador(idUsuario, primerNombreColab, segundoNombreColab, 
                          primerApellidoColab, segundoApellidoColab, telefColab, 
                          emailColab, direccionColab, fechaIngreso, cargoColab)
    VALUES(@idUsuario, @primerNombreColab, @segundoNombreColab, 
           @primerApellidoColab, @segundoApellidoColab, @telefColab, 
           @emailColab, @direccionColab, @fechaIngreso, @cargoColab)
    
    RETURN SCOPE_IDENTITY()
END
GO

-- Leer todos los Colaboradores
CREATE PROCEDURE sp_LeerColaboradores
AS
BEGIN
    SELECT c.idColaborador, c.idUsuario, c.primerNombreColab, c.segundoNombreColab,
           c.primerApellidoColab, c.segundoApellidoColab, c.telefColab, c.emailColab,
           c.direccionColab, c.fechaIngreso, c.cargoColab,
           u.Usuario, u.EstadoUsuario, r.nombreRol
    FROM Colaborador c
    INNER JOIN Usuario u ON c.idUsuario = u.idUsuario
    INNER JOIN Rol r ON u.idRol = r.idRol
END
GO

-- Leer Colaborador por ID
CREATE PROCEDURE sp_LeerColaboradorPorID
    @idColaborador INT
AS
BEGIN
    SELECT c.idColaborador, c.idUsuario, c.primerNombreColab, c.segundoNombreColab,
           c.primerApellidoColab, c.segundoApellidoColab, c.telefColab, c.emailColab,
           c.direccionColab, c.fechaIngreso, c.cargoColab,
           u.Usuario, u.EstadoUsuario, r.nombreRol
    FROM Colaborador c
    INNER JOIN Usuario u ON c.idUsuario = u.idUsuario
    INNER JOIN Rol r ON u.idRol = r.idRol
    WHERE c.idColaborador = @idColaborador
END
GO

-- Leer Colaborador por ID de Usuario
CREATE PROCEDURE sp_LeerColaboradorPorUsuario
    @idUsuario INT
AS
BEGIN
    SELECT c.idColaborador, c.idUsuario, c.primerNombreColab, c.segundoNombreColab,
           c.primerApellidoColab, c.segundoApellidoColab, c.telefColab, c.emailColab,
           c.direccionColab, c.fechaIngreso, c.cargoColab,
           u.Usuario, u.EstadoUsuario, r.nombreRol
    FROM Colaborador c
    INNER JOIN Usuario u ON c.idUsuario = u.idUsuario
    INNER JOIN Rol r ON u.idRol = r.idRol
    WHERE c.idUsuario = @idUsuario
END
GO

-- Actualizar Colaborador
CREATE PROCEDURE sp_ActualizarColaborador
    @idColaborador INT,
    @primerNombreColab VARCHAR(50),
    @segundoNombreColab VARCHAR(50) = NULL,
    @primerApellidoColab VARCHAR(50),
    @segundoApellidoColab VARCHAR(50) = NULL,
    @telefColab VARCHAR(20) = NULL,
    @emailColab VARCHAR(100) = NULL,
    @direccionColab VARCHAR(100) = NULL,
    @fechaIngreso DATE,
    @cargoColab VARCHAR(50)
AS
BEGIN
    UPDATE Colaborador SET
        primerNombreColab = @primerNombreColab,
        segundoNombreColab = @segundoNombreColab,
        primerApellidoColab = @primerApellidoColab,
        segundoApellidoColab = @segundoApellidoColab,
        telefColab = @telefColab,
        emailColab = @emailColab,
        direccionColab = @direccionColab,
        fechaIngreso = @fechaIngreso,
        cargoColab = @cargoColab
    WHERE idColaborador = @idColaborador
    
    RETURN @@ROWCOUNT
END
GO

-- Eliminar Colaborador
CREATE PROCEDURE sp_EliminarColaborador
    @idColaborador INT
AS
BEGIN
    DELETE FROM Colaborador
    WHERE idColaborador = @idColaborador
    
    RETURN @@ROWCOUNT
END
GO





-- Crear Cliente
CREATE PROCEDURE sp_CrearCliente
    @primerNomCliente VARCHAR(50),
    @segundoNomCliente VARCHAR(50) = NULL,
    @primerApeCliente VARCHAR(50),
    @segApeCliente VARCHAR(50) = NULL,
    @telefCliente VARCHAR(20) = NULL,
    @emailCliente VARCHAR(100) = NULL,
    @direccionCliente VARCHAR(100) = NULL,
    @Estado CHAR(1) = 'A'
AS
BEGIN
    INSERT INTO Cliente(primerNomCliente, segundoNomCliente, primerApeCliente, 
                      segApeCliente, telefCliente, emailCliente, direccionCliente, Estado)
    VALUES(@primerNomCliente, @segundoNomCliente, @primerApeCliente, 
           @segApeCliente, @telefCliente, @emailCliente, @direccionCliente, @Estado)
    
    RETURN SCOPE_IDENTITY()
END
GO

-- Leer todos los Clientes
CREATE PROCEDURE sp_LeerClientes
AS
BEGIN
    SELECT idCliente, primerNomCliente, segundoNomCliente, primerApeCliente,
           segApeCliente, telefCliente, emailCliente, direccionCliente, Estado, fechaRegistro
    FROM Cliente
END
GO

-- Leer Clientes activos
CREATE PROCEDURE sp_LeerClientesActivos
AS
BEGIN
    SELECT idCliente, primerNomCliente, segundoNomCliente, primerApeCliente,
           segApeCliente, telefCliente, emailCliente, direccionCliente, Estado, fechaRegistro
    FROM Cliente
    WHERE Estado = 'A'
END
GO

-- Leer Cliente por ID
CREATE PROCEDURE sp_LeerClientePorID
    @idCliente INT
AS
BEGIN
    SELECT idCliente, primerNomCliente, segundoNomCliente, primerApeCliente,
           segApeCliente, telefCliente, emailCliente, direccionCliente, Estado, fechaRegistro
    FROM Cliente
    WHERE idCliente = @idCliente
END
GO

-- Buscar Clientes por nombre o apellido
CREATE PROCEDURE sp_BuscarClientes
    @busqueda VARCHAR(100)
AS
BEGIN
    SELECT idCliente, primerNomCliente, segundoNomCliente, primerApeCliente,
           segApeCliente, telefCliente, emailCliente, direccionCliente, Estado, fechaRegistro
    FROM Cliente
    WHERE primerNomCliente LIKE '%' + @busqueda + '%' OR
          segundoNomCliente LIKE '%' + @busqueda + '%' OR
          primerApeCliente LIKE '%' + @busqueda + '%' OR
          segApeCliente LIKE '%' + @busqueda + '%'
END
GO

-- Actualizar Cliente
CREATE PROCEDURE sp_ActualizarCliente
    @idCliente INT,
    @primerNomCliente VARCHAR(50),
    @segundoNomCliente VARCHAR(50) = NULL,
    @primerApeCliente VARCHAR(50),
    @segApeCliente VARCHAR(50) = NULL,
    @telefCliente VARCHAR(20) = NULL,
    @emailCliente VARCHAR(100) = NULL,
    @direccionCliente VARCHAR(100) = NULL,
    @Estado CHAR(1)
AS
BEGIN
    UPDATE Cliente SET
        primerNomCliente = @primerNomCliente,
        segundoNomCliente = @segundoNomCliente,
        primerApeCliente = @primerApeCliente,
        segApeCliente = @segApeCliente,
        telefCliente = @telefCliente,
        emailCliente = @emailCliente,
        direccionCliente = @direccionCliente,
        Estado = @Estado
    WHERE idCliente = @idCliente
    
    RETURN @@ROWCOUNT
END
GO

-- Cambiar estado de Cliente
CREATE PROCEDURE sp_CambiarEstadoCliente
    @idCliente INT,
    @Estado CHAR(1)
AS
BEGIN
    UPDATE Cliente SET
        Estado = @Estado
    WHERE idCliente = @idCliente
    
    RETURN @@ROWCOUNT
END
GO






-- Crear Proveedor
CREATE PROCEDURE sp_CrearProveedor
    @nombreProveedor VARCHAR(50),
    @telefProveedor VARCHAR(8),
    @direccProveedor VARCHAR(100)
AS
BEGIN
    INSERT INTO Proveedor(nombreProveedor, telefProveedor, direccProveedor)
    VALUES(@nombreProveedor, @telefProveedor, @direccProveedor)
    
    RETURN SCOPE_IDENTITY()
END
GO

-- Leer todos los Proveedores
CREATE PROCEDURE sp_LeerProveedores
AS
BEGIN
    SELECT idProveedor, nombreProveedor, telefProveedor, direccProveedor
    FROM Proveedor
END
GO

-- Leer Proveedor por ID
CREATE PROCEDURE sp_LeerProveedorPorID
    @idProveedor INT
AS
BEGIN
    SELECT idProveedor, nombreProveedor, telefProveedor, direccProveedor
    FROM Proveedor
    WHERE idProveedor = @idProveedor
END
GO

-- Buscar Proveedores por nombre
CREATE PROCEDURE sp_BuscarProveedores
    @busqueda VARCHAR(50)
AS
BEGIN
    SELECT idProveedor, nombreProveedor, telefProveedor, direccProveedor
    FROM Proveedor
    WHERE nombreProveedor LIKE '%' + @busqueda + '%'
END
GO

-- Actualizar Proveedor
CREATE PROCEDURE sp_ActualizarProveedor
    @idProveedor INT,
    @nombreProveedor VARCHAR(50),
    @telefProveedor VARCHAR(8),
    @direccProveedor VARCHAR(100)
AS
BEGIN
    UPDATE Proveedor SET
        nombreProveedor = @nombreProveedor,
        telefProveedor = @telefProveedor,
        direccProveedor = @direccProveedor
    WHERE idProveedor = @idProveedor
    
    RETURN @@ROWCOUNT
END
GO

-- Eliminar Proveedor
CREATE PROCEDURE sp_EliminarProveedor
    @idProveedor INT
AS
BEGIN
    DELETE FROM Proveedor
    WHERE idProveedor = @idProveedor
    
    RETURN @@ROWCOUNT
END
GO






-- Crear Categoría de Producto
CREATE PROCEDURE sp_CrearCategoriaProducto
    @nombreCategoria VARCHAR(50)
AS
BEGIN
    INSERT INTO CategoriaProducto(nombreCategoria)
    VALUES(@nombreCategoria)
    
    RETURN SCOPE_IDENTITY()
END
GO

-- Leer todas las Categorías
CREATE PROCEDURE sp_LeerCategoriasProducto
AS
BEGIN
    SELECT idCategoria, nombreCategoria
    FROM CategoriaProducto
END
GO

-- Leer Categoría por ID
CREATE PROCEDURE sp_LeerCategoriaProductoPorID
    @idCategoria INT
AS
BEGIN
    SELECT idCategoria, nombreCategoria
    FROM CategoriaProducto
    WHERE idCategoria = @idCategoria
END
GO

-- Actualizar Categoría
CREATE PROCEDURE sp_ActualizarCategoriaProducto
    @idCategoria INT,
    @nombreCategoria VARCHAR(50)
AS
BEGIN
    UPDATE CategoriaProducto SET
        nombreCategoria = @nombreCategoria
    WHERE idCategoria = @idCategoria
    
    RETURN @@ROWCOUNT
END
GO

-- Eliminar Categoría
CREATE PROCEDURE sp_EliminarCategoriaProducto
    @idCategoria INT
AS
BEGIN
    DELETE FROM CategoriaProducto
    WHERE idCategoria = @idCategoria
    
    RETURN @@ROWCOUNT
END
GO







-- Crear Producto
CREATE PROCEDURE sp_CrearProducto
    @idCategoria INT,
    @idProveedor INT,
    @NombreProducto VARCHAR(50),
    @descripcionProducto VARCHAR(100),
    @precioProducto FLOAT,
    @Costoproducto FLOAT,
    @estadoProducto VARCHAR(25),
    @cantidadProducto INT
AS
BEGIN
    INSERT INTO Producto(idCategoria, idProveedor, NombreProducto, descripcionProducto, 
                        precioProducto, Costoproducto, estadoProducto, cantidadProducto)
    VALUES(@idCategoria, @idProveedor, @NombreProducto, @descripcionProducto, 
           @precioProducto, @Costoproducto, @estadoProducto, @cantidadProducto)
    
    RETURN SCOPE_IDENTITY()
END
GO

-- Leer todos los Productos
CREATE PROCEDURE sp_LeerProductos
AS
BEGIN
    SELECT p.idProducto, p.NombreProducto, p.descripcionProducto, 
           p.precioProducto, p.Costoproducto, p.estadoProducto, p.cantidadProducto, 
           p.fechaIngresoProducto,
           c.idCategoria, c.nombreCategoria,
           pr.idProveedor, pr.nombreProveedor
    FROM Producto p
    INNER JOIN CategoriaProducto c ON p.idCategoria = c.idCategoria
    INNER JOIN Proveedor pr ON p.idProveedor = pr.idProveedor
END
GO

-- Leer Productos activos
CREATE PROCEDURE sp_LeerProductosActivos
AS
BEGIN
    SELECT p.idProducto, p.NombreProducto, p.descripcionProducto, 
           p.precioProducto, p.Costoproducto, p.estadoProducto, p.cantidadProducto, 
           p.fechaIngresoProducto,
           c.idCategoria, c.nombreCategoria,
           pr.idProveedor, pr.nombreProveedor
    FROM Producto p
    INNER JOIN CategoriaProducto c ON p.idCategoria = c.idCategoria
    INNER JOIN Proveedor pr ON p.idProveedor = pr.idProveedor
    WHERE p.estadoProducto = 'ACTIVO'
END
GO

-- Leer Producto por ID
CREATE PROCEDURE sp_LeerProductoPorID
    @idProducto INT
AS
BEGIN
    SELECT p.idProducto, p.NombreProducto, p.descripcionProducto, 
           p.precioProducto, p.Costoproducto, p.estadoProducto, p.cantidadProducto, 
           p.fechaIngresoProducto,
           c.idCategoria, c.nombreCategoria,
           pr.idProveedor, pr.nombreProveedor
    FROM Producto p
    INNER JOIN CategoriaProducto c ON p.idCategoria = c.idCategoria
    INNER JOIN Proveedor pr ON p.idProveedor = pr.idProveedor
    WHERE p.idProducto = @idProducto
END
GO

-- Buscar Productos por nombre
CREATE PROCEDURE sp_BuscarProductos
    @busqueda VARCHAR(50)
AS
BEGIN
    SELECT p.idProducto, p.NombreProducto, p.descripcionProducto, 
           p.precioProducto, p.Costoproducto, p.estadoProducto, p.cantidadProducto, 
           p.fechaIngresoProducto,
           c.idCategoria, c.nombreCategoria,
           pr.idProveedor, pr.nombreProveedor
    FROM Producto p
    INNER JOIN CategoriaProducto c ON p.idCategoria = c.idCategoria
    INNER JOIN Proveedor pr ON p.idProveedor = pr.idProveedor
    WHERE p.NombreProducto LIKE '%' + @busqueda + '%' OR
          p.descripcionProducto LIKE '%' + @busqueda + '%'
END
GO

-- Actualizar Producto
CREATE PROCEDURE sp_ActualizarProducto
    @idProducto INT,
    @idCategoria INT,
    @idProveedor INT,
    @NombreProducto VARCHAR(50),
    @descripcionProducto VARCHAR(100),
    @precioProducto FLOAT,
    @Costoproducto FLOAT,
    @estadoProducto VARCHAR(25),
    @cantidadProducto INT
AS
BEGIN
    UPDATE Producto SET
        idCategoria = @idCategoria,
        idProveedor = @idProveedor,
        NombreProducto = @NombreProducto,
        descripcionProducto = @descripcionProducto,
        precioProducto = @precioProducto,
        Costoproducto = @Costoproducto,
        estadoProducto = @estadoProducto,
        cantidadProducto = @cantidadProducto
    WHERE idProducto = @idProducto
    
    RETURN @@ROWCOUNT
END
GO

-- Actualizar stock de Producto
CREATE PROCEDURE sp_ActualizarStockProducto
    @idProducto INT,
    @cantidad INT
AS
BEGIN
    UPDATE Producto SET
        cantidadProducto = cantidadProducto + @cantidad
    WHERE idProducto = @idProducto
    
    RETURN @@ROWCOUNT
END
GO

-- Cambiar estado de Producto
CREATE PROCEDURE sp_CambiarEstadoProducto
    @idProducto INT,
    @estadoProducto VARCHAR(25)
AS
BEGIN
    UPDATE Producto SET
        estadoProducto = @estadoProducto
    WHERE idProducto = @idProducto
    
    RETURN @@ROWCOUNT
END
GO




-- Crear Compra
CREATE PROCEDURE sp_CrearCompra
    @idColaborador INT,
    @fechaCompra DATE,
    @totalCompra FLOAT
AS
BEGIN
    INSERT INTO Compra(idColaborador, fechaCompra, totalCompra)
    VALUES(@idColaborador, @fechaCompra, @totalCompra)
    
    RETURN SCOPE_IDENTITY()
END
GO

-- Leer todas las Compras
CREATE PROCEDURE sp_LeerCompras
AS
BEGIN
    SELECT c.idCompra, c.fechaCompra, c.totalCompra,
           col.idColaborador, col.primerNombreColab, col.primerApellidoColab,
           u.idUsuario, u.Usuario
    FROM Compra c
    INNER JOIN Colaborador col ON c.idColaborador = col.idColaborador
    INNER JOIN Usuario u ON col.idUsuario = u.idUsuario
    ORDER BY c.fechaCompra DESC
END
GO

-- Leer Compras por rango de fechas
CREATE PROCEDURE sp_LeerComprasPorFecha
    @fechaInicio DATE,
    @fechaFin DATE
AS
BEGIN
    SELECT c.idCompra, c.fechaCompra, c.totalCompra,
           col.idColaborador, col.primerNombreColab, col.primerApellidoColab,
           u.idUsuario, u.Usuario
    FROM Compra c
    INNER JOIN Colaborador col ON c.idColaborador = col.idColaborador
    INNER JOIN Usuario u ON col.idUsuario = u.idUsuario
    WHERE c.fechaCompra BETWEEN @fechaInicio AND @fechaFin
    ORDER BY c.fechaCompra DESC
END
GO

-- Leer Compra por ID
CREATE PROCEDURE sp_LeerCompraPorID
    @idCompra INT
AS
BEGIN
    SELECT c.idCompra, c.fechaCompra, c.totalCompra,
           col.idColaborador, col.primerNombreColab, col.primerApellidoColab,
           u.idUsuario, u.Usuario
    FROM Compra c
    INNER JOIN Colaborador col ON c.idColaborador = col.idColaborador
    INNER JOIN Usuario u ON col.idUsuario = u.idUsuario
    WHERE c.idCompra = @idCompra
END
GO





-- Crear detalle de Compra
CREATE PROCEDURE sp_CrearDetalleCompra
    @idCompra INT,
    @idProducto INT,
    @cantidadCompra INT,
    @subtotalCompra FLOAT
AS
BEGIN
    INSERT INTO detalleCompra(idCompra, idProducto, cantidadCompra, subtotalCompra)
    VALUES(@idCompra, @idProducto, @cantidadCompra, @subtotalCompra)
    
    -- Actualizar stock del producto
    EXEC sp_ActualizarStockProducto @idProducto, @cantidadCompra
    
    RETURN SCOPE_IDENTITY()
END
GO

-- Leer detalles de Compra
CREATE PROCEDURE sp_LeerDetallesCompra
    @idCompra INT
AS
BEGIN
    SELECT dc.idDetalleCompra, dc.idCompra, dc.cantidadCompra, dc.subtotalCompra,
           p.idProducto, p.NombreProducto, p.descripcionProducto, p.precioProducto,
           cp.idCategoria, cp.nombreCategoria
    FROM detalleCompra dc
    INNER JOIN Producto p ON dc.idProducto = p.idProducto
    INNER JOIN CategoriaProducto cp ON p.idCategoria = cp.idCategoria
    WHERE dc.idCompra = @idCompra
END
GO





-- Crear categoría de Membresía
CREATE PROCEDURE sp_CrearCategoriaMembresia
    @nombreCatMemb VARCHAR(50)
AS
BEGIN
    INSERT INTO categoriaMembresia(nombreCatMemb)
    VALUES(@nombreCatMemb)
    
    RETURN SCOPE_IDENTITY()
END
GO

-- Leer todas las categorías de Membresía
CREATE PROCEDURE sp_LeerCategoriasMembresia
AS
BEGIN
    SELECT idCatMembresia, nombreCatMemb
    FROM categoriaMembresia
END
GO

-- Leer categoría de Membresía por ID
CREATE PROCEDURE sp_LeerCategoriaMembresiaPorID
    @idCatMembresia INT
AS
BEGIN
    SELECT idCatMembresia, nombreCatMemb
    FROM categoriaMembresia
    WHERE idCatMembresia = @idCatMembresia
END
GO

-- Actualizar categoría de Membresía
CREATE PROCEDURE sp_ActualizarCategoriaMembresia
    @idCatMembresia INT,
    @nombreCatMemb VARCHAR(50)
AS
BEGIN
    UPDATE categoriaMembresia SET
        nombreCatMemb = @nombreCatMemb
    WHERE idCatMembresia = @idCatMembresia
    
    RETURN @@ROWCOUNT
END
GO





-- Crear Membresía
CREATE PROCEDURE sp_CrearMembresia
    @idCatMembresia INT,
    @descripcion VARCHAR(100),
    @duracionMembresia INT,
    @precioMembresia FLOAT
AS
BEGIN
    INSERT INTO Membresia(idCatMembresia, descripcion, duracionMembresia, precioMembresia)
    VALUES(@idCatMembresia, @descripcion, @duracionMembresia, @precioMembresia)
    
    RETURN SCOPE_IDENTITY()
END
GO

-- Leer todas las Membresías
CREATE PROCEDURE sp_LeerMembresias
AS
BEGIN
    SELECT m.idMembresia, m.descripcion, m.duracionMembresia, m.precioMembresia,
           cm.idCatMembresia, cm.nombreCatMemb
    FROM Membresia m
    INNER JOIN categoriaMembresia cm ON m.idCatMembresia = cm.idCatMembresia
END
GO

-- Leer Membresía por ID
CREATE PROCEDURE sp_LeerMembresiaPorID
    @idMembresia INT
AS
BEGIN
    SELECT m.idMembresia, m.descripcion, m.duracionMembresia, m.precioMembresia,
           cm.idCatMembresia, cm.nombreCatMemb
    FROM Membresia m
    INNER JOIN categoriaMembresia cm ON m.idCatMembresia = cm.idCatMembresia
    WHERE m.idMembresia = @idMembresia
END
GO

-- Actualizar Membresía
CREATE PROCEDURE sp_ActualizarMembresia
    @idMembresia INT,
    @idCatMembresia INT,
    @descripcion VARCHAR(100),
    @duracionMembresia INT,
    @precioMembresia FLOAT
AS
BEGIN
    UPDATE Membresia SET
        idCatMembresia = @idCatMembresia,
        descripcion = @descripcion,
        duracionMembresia = @duracionMembresia,
        precioMembresia = @precioMembresia
    WHERE idMembresia = @idMembresia
    
    RETURN @@ROWCOUNT
END
GO





-- Crear detalle de Membresía
CREATE PROCEDURE sp_CrearDetalleMembresia
    @idCliente INT,
    @idMembresia INT,
    @subtotalMembresia FLOAT,
    @fechaInicio DATE,
    @fechaFin DATE
AS
BEGIN
    INSERT INTO detalleMembresia(idCliente, idMembresia, subtotalMembresia, fechaInicio, fechaFin)
    VALUES(@idCliente, @idMembresia, @subtotalMembresia, @fechaInicio, @fechaFin)
    
    RETURN SCOPE_IDENTITY()
END
GO

-- Leer detalles de Membresía por Cliente
CREATE PROCEDURE sp_LeerDetallesMembresiaPorCliente
    @idCliente INT
AS
BEGIN
    SELECT dm.idDetalleMembresia, dm.idCliente, dm.subtotalMembresia, 
           dm.fechaInicio, dm.fechaFin,
           m.idMembresia, m.descripcion, m.duracionMembresia, m.precioMembresia,
           cm.idCatMembresia, cm.nombreCatMemb,
           c.primerNomCliente, c.primerApeCliente
    FROM detalleMembresia dm
    INNER JOIN Membresia m ON dm.idMembresia = m.idMembresia
    INNER JOIN categoriaMembresia cm ON m.idCatMembresia = cm.idCatMembresia
    INNER JOIN Cliente c ON dm.idCliente = c.idCliente
    WHERE dm.idCliente = @idCliente
    ORDER BY dm.fechaInicio DESC
END
GO

-- Leer detalles de Membresía activas
CREATE PROCEDURE sp_LeerMembresiasActivas
AS
BEGIN
    SELECT dm.idDetalleMembresia, dm.idCliente, dm.subtotalMembresia, 
           dm.fechaInicio, dm.fechaFin,
           m.idMembresia, m.descripcion, m.duracionMembresia, m.precioMembresia,
           cm.idCatMembresia, cm.nombreCatMemb,
           c.primerNomCliente, c.primerApeCliente
    FROM detalleMembresia dm
    INNER JOIN Membresia m ON dm.idMembresia = m.idMembresia
    INNER JOIN categoriaMembresia cm ON m.idCatMembresia = cm.idCatMembresia
    INNER JOIN Cliente c ON dm.idCliente = c.idCliente
    WHERE dm.fechaFin >= GETDATE()
    ORDER BY dm.fechaFin ASC
END
GO

-- Leer detalles de Membresía por vencer (en los próximos 7 días)
CREATE PROCEDURE sp_LeerMembresiasPorVencer
AS
BEGIN
    SELECT dm.idDetalleMembresia, dm.idCliente, dm.subtotalMembresia, 
           dm.fechaInicio, dm.fechaFin,
           m.idMembresia, m.descripcion, m.duracionMembresia, m.precioMembresia,
           cm.idCatMembresia, cm.nombreCatMemb,
           c.primerNomCliente, c.primerApeCliente, c.telefCliente, c.emailCliente
    FROM detalleMembresia dm
    INNER JOIN Membresia m ON dm.idMembresia = m.idMembresia
    INNER JOIN categoriaMembresia cm ON m.idCatMembresia = cm.idCatMembresia
    INNER JOIN Cliente c ON dm.idCliente = c.idCliente
    WHERE dm.fechaFin BETWEEN GETDATE() AND DATEADD(day, 7, GETDATE())
    ORDER BY dm.fechaFin ASC
END
GO





-- Crear Venta
CREATE PROCEDURE sp_CrearVenta
    @idCliente INT,
    @idColaborador INT,
    @fechaVenta DATE,
    @totalVenta FLOAT,
    @formaPago DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Venta(idCliente, idColaborador, fechaVenta, totalVenta, formaPago)
    VALUES(@idCliente, @idColaborador, @fechaVenta, @totalVenta, @formaPago)
    
    RETURN SCOPE_IDENTITY()
END
GO

-- Leer todas las Ventas
CREATE PROCEDURE sp_LeerVentas
AS
BEGIN
    SELECT v.idVenta, v.fechaVenta, v.totalVenta, v.formaPago,
           c.idCliente, c.primerNomCliente, c.primerApeCliente,
           col.idColaborador, col.primerNombreColab, col.primerApellidoColab,
           u.Usuario
    FROM Venta v
    INNER JOIN Cliente c ON v.idCliente = c.idCliente
    INNER JOIN Colaborador col ON v.idColaborador = col.idColaborador
    INNER JOIN Usuario u ON col.idUsuario = u.idUsuario
    ORDER BY v.fechaVenta DESC
END
GO

-- Leer Ventas por rango de fechas
CREATE PROCEDURE sp_LeerVentasPorFecha
    @fechaInicio DATE,
    @fechaFin DATE
AS
BEGIN
    SELECT v.idVenta, v.fechaVenta, v.totalVenta, v.formaPago,
           c.idCliente, c.primerNomCliente, c.primerApeCliente,
           col.idColaborador, col.primerNombreColab, col.primerApellidoColab,
           u.Usuario
    FROM Venta v
    INNER JOIN Cliente c ON v.idCliente = c.idCliente
    INNER JOIN Colaborador col ON v.idColaborador = col.idColaborador
    INNER JOIN Usuario u ON col.idUsuario = u.idUsuario
    WHERE v.fechaVenta BETWEEN @fechaInicio AND @fechaFin
    ORDER BY v.fechaVenta DESC
END
GO

-- Leer Venta por ID
CREATE PROCEDURE sp_LeerVentaPorID
    @idVenta INT
AS
BEGIN
    SELECT v.idVenta, v.fechaVenta, v.totalVenta, v.formaPago,
           c.idCliente, c.primerNomCliente, c.primerApeCliente,
           col.idColaborador, col.primerNombreColab, col.primerApellidoColab,
           u.Usuario
    FROM Venta v
    INNER JOIN Cliente c ON v.idCliente = c.idCliente
    INNER JOIN Colaborador col ON v.idColaborador = col.idColaborador
    INNER JOIN Usuario u ON col.idUsuario = u.idUsuario
    WHERE v.idVenta = @idVenta
END
GO



-- Crear detalle de Venta
CREATE PROCEDURE sp_CrearDetalleVenta
    @idVenta INT,
    @idProducto INT,
    @cantidadVenta INT,
    @subtotalVenta FLOAT
AS
BEGIN
    -- Verificar si hay suficiente stock
    DECLARE @stockActual INT
    SELECT @stockActual = cantidadProducto FROM Producto WHERE idProducto = @idProducto
    
    IF @stockActual >= @cantidadVenta
    BEGIN
        INSERT INTO detalleVenta(idVenta, idProducto, cantidadVenta, subtotalVenta)
        VALUES(@idVenta, @idProducto, @cantidadVenta, @subtotalVenta)
        
        -- Actualizar stock del producto
        UPDATE Producto SET
            cantidadProducto = cantidadProducto - @cantidadVenta
        WHERE idProducto = @idProducto
        
        RETURN SCOPE_IDENTITY()
    END
    ELSE
    BEGIN
        RETURN -1 -- Código de error para stock insuficiente
    END
END
GO

-- Leer detalles de Venta
CREATE PROCEDURE sp_LeerDetallesVenta
    @idVenta INT
AS
BEGIN
    SELECT dv.idDetalleVenta, dv.idVenta, dv.cantidadVenta, dv.subtotalVenta,
           p.idProducto, p.NombreProducto, p.descripcionProducto, p.precioProducto,
           cp.idCategoria, cp.nombreCategoria
    FROM detalleVenta dv
    INNER JOIN Producto p ON dv.idProducto = p.idProducto
    INNER JOIN CategoriaProducto cp ON p.idCategoria = cp.idCategoria
    WHERE dv.idVenta = @idVenta
END
GO





-- Crear Devolución
CREATE PROCEDURE sp_CrearDevolucion
    @idDetalleVenta INT,
    @idCliente INT,
    @fechaDevolucion DATE,
    @motivo VARCHAR(255),
    @cantidadDevuelta INT,
    @esReembolso BIT,
    @aprobadaPor INT
AS
BEGIN
    -- Verificar que la cantidad a devolver no sea mayor a la vendida
    DECLARE @cantidadVendida INT
    SELECT @cantidadVendida = cantidadVenta 
    FROM detalleVenta 
    WHERE idDetalleVenta = @idDetalleVenta
    
    IF @cantidadDevuelta <= @cantidadVendida
    BEGIN
        INSERT INTO DevolucionVenta(idDetalleVenta, idCliente, fechaDevolucion, 
                                   motivo, cantidadDevuelta, esReembolso, aprobadaPor)
        VALUES(@idDetalleVenta, @idCliente, @fechaDevolucion, 
               @motivo, @cantidadDevuelta, @esReembolso, @aprobadaPor)
        
        -- Si no es reembolso, devolver el producto al inventario
        IF @esReembolso = 0
        BEGIN
            DECLARE @idProducto INT
            SELECT @idProducto = idProducto FROM detalleVenta WHERE idDetalleVenta = @idDetalleVenta
            
            UPDATE Producto SET
                cantidadProducto = cantidadProducto + @cantidadDevuelta
            WHERE idProducto = @idProducto
        END
        
        RETURN SCOPE_IDENTITY()
    END
    ELSE
    BEGIN
        RETURN -1 -- Código de error para cantidad inválida
    END
END
GO

-- Leer Devoluciones por Venta
CREATE PROCEDURE sp_LeerDevolucionesPorVenta
    @idVenta INT
AS
BEGIN
    SELECT d.idDevolucion, d.fechaDevolucion, d.motivo, d.cantidadDevuelta, d.esReembolso,
           dv.idDetalleVenta, dv.idVenta, dv.cantidadVenta, dv.subtotalVenta,
           p.idProducto, p.NombreProducto,
           c.idCliente, c.primerNomCliente, c.primerApeCliente,
           col.idColaborador, col.primerNombreColab, col.primerApellidoColab
    FROM DevolucionVenta d
    INNER JOIN detalleVenta dv ON d.idDetalleVenta = dv.idDetalleVenta
    INNER JOIN Producto p ON dv.idProducto = p.idProducto
    INNER JOIN Cliente c ON d.idCliente = c.idCliente
    INNER JOIN Colaborador col ON d.aprobadaPor = col.idColaborador
    WHERE dv.idVenta = @idVenta
    ORDER BY d.fechaDevolucion DESC
END
GO

-- Leer todas las Devoluciones
CREATE PROCEDURE sp_LeerDevoluciones
AS
BEGIN
    SELECT d.idDevolucion, d.fechaDevolucion, d.motivo, d.cantidadDevuelta, d.esReembolso,
           dv.idDetalleVenta, dv.idVenta, dv.cantidadVenta, dv.subtotalVenta,
           p.idProducto, p.NombreProducto,
           c.idCliente, c.primerNomCliente, c.primerApeCliente,
           col.idColaborador, col.primerNombreColab, col.primerApellidoColab
    FROM DevolucionVenta d
    INNER JOIN detalleVenta dv ON d.idDetalleVenta = dv.idDetalleVenta
    INNER JOIN Producto p ON dv.idProducto = p.idProducto
    INNER JOIN Cliente c ON d.idCliente = c.idCliente
    INNER JOIN Colaborador col ON d.aprobadaPor = col.idColaborador
    ORDER BY d.fechaDevolucion DESC
END
GO





-- Reporte de ventas por período
CREATE PROCEDURE sp_ReporteVentasPorPeriodo
    @fechaInicio DATE,
    @fechaFin DATE
AS
BEGIN
    SELECT 
        v.fechaVenta,
        COUNT(v.idVenta) AS totalVentas,
        SUM(v.totalVenta) AS montoTotal,
        AVG(v.totalVenta) AS promedioVenta,
        MIN(v.totalVenta) AS ventaMinima,
        MAX(v.totalVenta) AS ventaMaxima
    FROM Venta v
    WHERE v.fechaVenta BETWEEN @fechaInicio AND @fechaFin
    GROUP BY v.fechaVenta
    ORDER BY v.fechaVenta
END
GO

-- Reporte de productos más vendidos
CREATE PROCEDURE sp_ReporteProductosMasVendidos
    @fechaInicio DATE = NULL,
    @fechaFin DATE = NULL
AS
BEGIN
    IF @fechaInicio IS NULL SET @fechaInicio = '1900-01-01'
    IF @fechaFin IS NULL SET @fechaFin = '9999-12-31'
    
    SELECT 
        p.idProducto,
        p.NombreProducto,
        cp.nombreCategoria,
        SUM(dv.cantidadVenta) AS totalVendido,
        SUM(dv.subtotalVenta) AS montoTotal
    FROM detalleVenta dv
    INNER JOIN Producto p ON dv.idProducto = p.idProducto
    INNER JOIN CategoriaProducto cp ON p.idCategoria = cp.idCategoria
    INNER JOIN Venta v ON dv.idVenta = v.idVenta
    WHERE v.fechaVenta BETWEEN @fechaInicio AND @fechaFin
    GROUP BY p.idProducto, p.NombreProducto, cp.nombreCategoria
    ORDER BY totalVendido DESC
END
GO

-- Reporte de membresías activas
CREATE PROCEDURE sp_ReporteMembresiasActivas
AS
BEGIN
    SELECT 
        cm.nombreCatMemb,
        COUNT(dm.idDetalleMembresia) AS totalActivas,
        SUM(m.precioMembresia) AS ingresosPotenciales
    FROM detalleMembresia dm
    INNER JOIN Membresia m ON dm.idMembresia = m.idMembresia
    INNER JOIN categoriaMembresia cm ON m.idCatMembresia = cm.idCatMembresia
    WHERE dm.fechaFin >= GETDATE()
    GROUP BY cm.nombreCatMemb
    ORDER BY totalActivas DESC
END
GO

-- Reporte de inventario bajo
CREATE PROCEDURE sp_ReporteInventarioBajo
    @umbral INT = 10
AS
BEGIN
    SELECT 
        p.idProducto,
        p.NombreProducto,
        p.cantidadProducto,
        cp.nombreCategoria,
        pr.nombreProveedor
    FROM Producto p
    INNER JOIN CategoriaProducto cp ON p.idCategoria = cp.idCategoria
    INNER JOIN Proveedor pr ON p.idProveedor = pr.idProveedor
    WHERE p.cantidadProducto <= @umbral
    AND p.estadoProducto = 'ACTIVO'
    ORDER BY p.cantidadProducto ASC
END
GO





-- Verificar credenciales de usuario
CREATE PROCEDURE sp_VerificarCredenciales
    @Usuario VARCHAR(50),
    @Password VARCHAR(100)
AS
BEGIN
    SELECT 
        u.idUsuario, u.Usuario, u.EstadoUsuario, u.email,
        r.idRol, r.nombreRol,
        c.idColaborador, c.primerNombreColab, c.primerApellidoColab, c.cargoColab
    FROM Usuario u
    INNER JOIN Rol r ON u.idRol = r.idRol
    LEFT JOIN Colaborador c ON u.idUsuario = c.idUsuario
    WHERE u.Usuario = @Usuario AND u.Password = @Password
END
GO

-- Cambiar contraseña
CREATE PROCEDURE sp_CambiarPassword
    @idUsuario INT,
    @passwordActual VARCHAR(100),
    @nuevoPassword VARCHAR(100)
AS
BEGIN
    DECLARE @passwordCorrecto BIT = 0
    
    -- Verificar contraseña actual
    SELECT @passwordCorrecto = 1
    FROM Usuario
    WHERE idUsuario = @idUsuario AND Password = @passwordActual
    
    IF @passwordCorrecto = 1
    BEGIN
        UPDATE Usuario SET
            Password = @nuevoPassword
        WHERE idUsuario = @idUsuario
        
        RETURN 1 -- Cambio exitoso
    END
    ELSE
    BEGIN
        RETURN 0 -- Contraseña actual incorrecta
    END
END
GO




