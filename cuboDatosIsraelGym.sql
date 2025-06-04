-- CREACIÓN DE LAS VISTAS DIMENSIONALES

-- Vista DimProducto
CREATE VIEW DimProducto AS
SELECT 
    p.idProducto,
    p.NombreProducto,
    p.descripcionProducto,
    p.precioProducto,
    p.Costoproducto,
    p.estadoProducto,
    p.cantidadProducto,
    c.nombreCategoria,
    pr.nombreProveedor,
    pr.telefProveedor,
    pr.direccProveedor
FROM Producto p
INNER JOIN CategoriaProducto c ON p.idCategoria = c.idCategoria
INNER JOIN Proveedor pr ON p.idProveedor = pr.idProveedor;
GO

-- Vista DimCliente
CREATE VIEW DimCliente AS
SELECT 
    idCliente,
    primerNomCliente,
    segundoNomCliente,
    primerApeCliente,
    segApeCliente,
    telefCliente,
    emailCliente,
    direccionCliente,
    Estado,
    fechaRegistro
FROM Cliente;
GO

-- Vista DimColaborador
CREATE VIEW DimColaborador AS
SELECT 
    c.idColaborador,
    u.Usuario,
    c.primerNombreColab,
    c.segundoNombreColab,
    c.primerApellidoColab,
    c.segundoApellidoColab,
    c.telefColab,
    c.emailColab,
    c.direccionColab,
    c.fechaIngreso,
    c.cargoColab
FROM Colaborador c
INNER JOIN Usuario u ON c.idUsuario = u.idUsuario;
GO

-- Vista DimMembresia
CREATE VIEW DimMembresia AS
SELECT 
    m.idMembresia,
    cm.nombreCatMemb,
    m.descripcion,
    m.duracionMembresia,
    m.precioMembresia
FROM Membresia m
INNER JOIN categoriaMembresia cm ON m.idCatMembresia = cm.idCatMembresia;
GO

-- Vista DimFecha unificada
CREATE VIEW DimFecha AS
SELECT DISTINCT 
    Fecha,
    YEAR(Fecha) AS Anio,
    MONTH(Fecha) AS MesNumero,
    DATENAME(MONTH, Fecha) AS MesNombre,
    DAY(Fecha) AS Dia,
    DATENAME(WEEKDAY, Fecha) AS DiaSemana,
    DATEPART(WEEK, Fecha) AS SemanaDelAnio
FROM (
    SELECT fechaVenta AS Fecha FROM Venta
    UNION
    SELECT fechaCompra FROM Compra
    UNION
    SELECT fechaInicio FROM detalleMembresia
    UNION
    SELECT fechaFin FROM detalleMembresia
    UNION
    SELECT fechaDevolucion FROM DevolucionVenta
) AS FechasUnificadas;
GO

-- CREACIÓN DE LAS VISTAS HECHOS (FACTS)

-- FactVenta
CREATE VIEW FactVenta AS
SELECT 
    v.idVenta,
    v.idCliente,
    v.idColaborador,
    v.fechaVenta AS Fecha,
    v.totalVenta,
    v.formaPago,
    dv.idProducto,
    dv.cantidadVenta,
    dv.subtotalVenta
FROM Venta v
INNER JOIN detalleVenta dv ON v.idVenta = dv.idVenta;
GO

-- FactCompra
CREATE VIEW FactCompra AS
SELECT 
    c.idCompra,
    c.idColaborador,
    c.fechaCompra AS Fecha,
    c.totalCompra,
    dc.idProducto,
    dc.cantidadCompra,
    dc.subtotalCompra
FROM Compra c
INNER JOIN detalleCompra dc ON c.idCompra = dc.idCompra;
GO

-- FactMembresia
CREATE VIEW FactMembresia AS
SELECT 
    dm.idDetalleMembresia,
    dm.idCliente,
    dm.idMembresia,
    dm.fechaInicio AS FechaInicio,
    dm.fechaFin AS FechaFin,
    dm.subtotalMembresia
FROM detalleMembresia dm;
GO

-- FactDevolucionVenta
CREATE VIEW FactDevolucionVenta AS
SELECT 
    d.idDevolucion,
    d.idDetalleVenta,
    d.idCliente,
    d.fechaDevolucion AS Fecha,
    d.motivo,
    d.cantidadDevuelta,
    d.esReembolso,
    d.aprobadaPor
FROM DevolucionVenta d;
GO
