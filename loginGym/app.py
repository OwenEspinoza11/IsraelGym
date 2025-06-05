from flask import Flask, request, jsonify
from flask_cors import CORS
import pyodbc

app = Flask(__name__)
CORS(app)

# Conexión a SQL Server
server = r'OWEN_LAPTOP'
database = 'IsraelGym'
connection_string = (
    f'DRIVER={{ODBC Driver 17 for SQL Server}};'
    f'SERVER={server};'
    f'DATABASE={database};'
    f'Trusted_Connection=yes;'
)

def get_db_connection():
    return pyodbc.connect(connection_string)

# --- Login ---
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    usuario = data.get('Usuario')
    contrasena = data.get('Password')

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        SELECT U.IdUsuario, U.Usuario, U.EstadoUsuario, R.NombreRol
        FROM Usuario U
        JOIN Rol R ON U.idRol = R.idRol
        WHERE U.Usuario = ? AND U.Password = ?
    """, (usuario, contrasena))

    user = cursor.fetchone()
    conn.close()

    if user:
        if user.EstadoUsuario.strip().upper() == 'ACTIVO':
            return jsonify({
                'mensaje': 'Login exitoso',
                'usuario': user.Usuario,
                'rol': user.NombreRol,
                'estado': user.EstadoUsuario,
                'id': user.IdUsuario
            })
        else:
            return jsonify({'mensaje': 'Usuario inactivo'}), 403
    else:
        return jsonify({'mensaje': 'Credenciales incorrectas'}), 401

# --- Productos ---
@app.route('/productos', methods=['GET'])
def obtener_productos():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT P.idProducto, P.NombreProducto, P.descripcionProducto, P.precioProducto,
               P.Costoproducto, P.cantidadProducto, P.estadoProducto,
               C.nombreCategoria, Pr.nombreProveedor
        FROM Producto P
        JOIN CategoriaProducto C ON P.idCategoria = C.idCategoria
        JOIN Proveedor Pr ON P.idProveedor = Pr.idProveedor
    """)
    productos = []
    for row in cursor.fetchall():
        productos.append({
            'id': row.idProducto,
            'nombre': row.NombreProducto,
            'descripcion': row.descripcionProducto,
            'precio': row.precioProducto,
            'costo': row.Costoproducto,
            'cantidad': row.cantidadProducto,
            'estado': row.estadoProducto,
            'categoria': row.nombreCategoria,
            'proveedor': row.nombreProveedor
        })
    conn.close()
    return jsonify(productos)

@app.route('/productos', methods=['POST'])
def agregar_producto():
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO Producto (
            NombreProducto, descripcionProducto, precioProducto, Costoproducto,
            cantidadProducto, estadoProducto, idCategoria, idProveedor
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """, (
        data['nombre'], data['descripcion'], data['precio'], data['costo'],
        data['cantidad'], data['estado'], data['idCategoria'], data['idProveedor']
    ))
    conn.commit()
    conn.close()
    return jsonify({'mensaje': 'Producto agregado correctamente'})

# --- Categorías ---
@app.route('/categorias', methods=['GET'])
def obtener_categorias():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT idCategoria, nombreCategoria FROM CategoriaProducto")
    categorias = [{'id': row.idCategoria, 'nombre': row.nombreCategoria} for row in cursor.fetchall()]
    conn.close()
    return jsonify(categorias)

@app.route('/categorias', methods=['POST'])
def agregar_categoria():
    data = request.json
    nombre = data.get('nombre')
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Verificar si la categoría ya existe
    cursor.execute("SELECT nombreCategoria FROM CategoriaProducto WHERE nombreCategoria = ?", (nombre,))
    if cursor.fetchone():
        conn.close()
        return jsonify({'error': 'La categoría ya existe'}), 400
    
    cursor.execute("INSERT INTO CategoriaProducto (nombreCategoria) VALUES (?)", (nombre,))
    conn.commit()
    conn.close()
    return jsonify({'mensaje': 'Categoría registrada'})

@app.route('/categorias/<int:id>', methods=['DELETE'])
def eliminar_categoria(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        # Verificar si hay productos asociados
        cursor.execute("SELECT COUNT(*) FROM Producto WHERE idCategoria = ?", (id,))
        count = cursor.fetchone()[0]
        
        if count > 0:
            # Opción 1: No permitir eliminación si hay productos
            # conn.close()
            # return jsonify({'error': 'No se puede eliminar, hay productos asociados'}), 400
            
            # Opción 2: Actualizar productos para que no tengan categoría
            cursor.execute("UPDATE Producto SET idCategoria = NULL WHERE idCategoria = ?", (id,))
        
        # Eliminar la categoría
        cursor.execute("DELETE FROM CategoriaProducto WHERE idCategoria = ?", (id,))
        conn.commit()
        
        if count > 0:
            mensaje = f'Categoría eliminada. {count} productos actualizados (sin categoría).'
        else:
            mensaje = 'Categoría eliminada correctamente'
            
        return jsonify({'mensaje': mensaje})
        
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

# --- Proveedores ---
@app.route('/proveedores', methods=['GET'])
def obtener_proveedores():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT idProveedor, nombreProveedor FROM Proveedor")
    proveedores = [{'id': row.idProveedor, 'nombre': row.nombreProveedor} for row in cursor.fetchall()]
    conn.close()
    return jsonify(proveedores)





# --- Reportes OLAP ---
@app.route('/reportes/ventas-por-periodo', methods=['GET'])
def reporte_ventas_periodo():
    fecha_inicio = request.args.get('fecha_inicio')
    fecha_fin = request.args.get('fecha_fin')
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    query = """
        SELECT 
            CAST(Fecha AS DATE) as Fecha,
            COUNT(DISTINCT idVenta) as TotalVentas,
            SUM(totalVenta) as MontoTotal
        FROM FactVenta
        WHERE Fecha BETWEEN ? AND ?
        GROUP BY CAST(Fecha AS DATE)
        ORDER BY Fecha
    """
    
    cursor.execute(query, (fecha_inicio, fecha_fin))
    resultados = []
    for row in cursor.fetchall():
        resultados.append({
            'fecha': row.Fecha.strftime('%Y-%m-%d'),
            'total_ventas': row.TotalVentas,
            'monto_total': float(row.MontoTotal)
        })
    
    conn.close()
    return jsonify(resultados)

@app.route('/reportes/productos-mas-vendidos', methods=['GET'])
def reporte_productos_mas_vendidos():
    limit = request.args.get('limit', 10)
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    query = """
        SELECT TOP (?) 
            P.NombreProducto,
            SUM(FV.cantidadVenta) as TotalVendido,
            SUM(FV.subtotalVenta) as MontoTotal,
            C.nombreCategoria
        FROM FactVenta FV
        JOIN DimProducto P ON FV.idProducto = P.idProducto
        JOIN CategoriaProducto C ON P.idCategoria = C.idCategoria
        GROUP BY P.NombreProducto, C.nombreCategoria
        ORDER BY TotalVendido DESC
    """
    
    cursor.execute(query, (limit))
    resultados = []
    for row in cursor.fetchall():
        resultados.append({
            'producto': row.NombreProducto,
            'total_vendido': row.TotalVendido,
            'monto_total': float(row.MontoTotal),
            'categoria': row.nombreCategoria
        })
    
    conn.close()
    return jsonify(resultados)

@app.route('/reportes/membresias-activas', methods=['GET'])
def reporte_membresias_activas():
    conn = get_db_connection()
    cursor = conn.cursor()
    
    query = """
        SELECT 
            M.nombreCatMemb as TipoMembresia,
            COUNT(*) as Cantidad,
            SUM(FM.subtotalMembresia) as Ingresos
        FROM FactMembresia FM
        JOIN DimMembresia M ON FM.idMembresia = M.idMembresia
        WHERE FM.FechaFin >= GETDATE()
        GROUP BY M.nombreCatMemb
        ORDER BY Cantidad DESC
    """
    
    cursor.execute(query)
    resultados = []
    for row in cursor.fetchall():
        resultados.append({
            'tipo_membresia': row.TipoMembresia,
            'cantidad': row.Cantidad,
            'ingresos': float(row.Ingresos)
        })
    
    conn.close()
    return jsonify(resultados)

@app.route('/reportes/inventario-bajo', methods=['GET'])
def reporte_inventario_bajo():
    umbral = request.args.get('umbral', 10)
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    query = """
        SELECT 
            NombreProducto,
            cantidadProducto as Stock,
            nombreCategoria,
            nombreProveedor
        FROM DimProducto
        WHERE cantidadProducto <= ?
        AND estadoProducto = 'ACTIVO'
        ORDER BY cantidadProducto ASC
    """
    
    cursor.execute(query, (umbral))
    resultados = []
    for row in cursor.fetchall():
        resultados.append({
            'producto': row.NombreProducto,
            'stock': row.Stock,
            'categoria': row.nombreCategoria,
            'proveedor': row.nombreProveedor
        })
    
    conn.close()
    return jsonify(resultados)




# --- Ejecutar servidor ---
if __name__ == '__main__':
    app.run(port=5000, debug=True)
