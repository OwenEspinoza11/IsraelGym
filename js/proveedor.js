document.addEventListener('DOMContentLoaded', function() {
    cargarProveedores();
    
    document.getElementById('formProveedor').addEventListener('submit', function(e) {
        e.preventDefault();
        const idEdit = document.getElementById('idProveedorEdit').value;
        const proveedor = {
            nombreProveedor: document.getElementById('nombreProveedor').value.trim(),
            telefProveedor: document.getElementById('telefProveedor').value.trim(),
            direccProveedor: document.getElementById('direccProveedor').value.trim()
        };

        if (!proveedor.nombreProveedor || !proveedor.telefProveedor) {
            alert('Por favor complete los campos obligatorios (Nombre y Teléfono)');
            return;
        }

        if (idEdit) {
            actualizarProveedor(idEdit, proveedor);
        } else {
            agregarProveedor(proveedor);
        }
    });

    document.getElementById('btnCancelarEdit').addEventListener('click', resetForm);
});

function cargarProveedores() {
    fetch('http://127.0.0.1:5000/proveedores')
        .then(response => response.json())
        .then(data => {
            const tbody = document.querySelector('#tablaProveedores tbody');
            tbody.innerHTML = '';
            
            data.forEach(proveedor => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${proveedor.idProveedor}</td>
                    <td>${proveedor.nombreProveedor}</td>
                    <td>${proveedor.telefProveedor}</td>
                    <td>${proveedor.direccProveedor || '-'}</td>
                    <td>
                        <button class="btn-edit" onclick="editarProveedor(${proveedor.idProveedor}, '${escape(JSON.stringify(proveedor))}')">Editar</button>
                        <button class="btn-danger" onclick="eliminarProveedor(${proveedor.idProveedor})">Eliminar</button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        })
        .catch(error => console.error('Error:', error));
}

function agregarProveedor(proveedor) {
    fetch('http://127.0.0.1:5000/proveedores', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(proveedor)
    })
    .then(response => response.json())
    .then(data => {
        alert(data.mensaje);
        resetForm();
        cargarProveedores();
    })
    .catch(error => console.error('Error:', error));
}

function actualizarProveedor(id, proveedor) {
    fetch(`http://127.0.0.1:5000/proveedores/${id}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(proveedor)
    })
    .then(response => response.json())
    .then(data => {
        alert(data.mensaje);
        resetForm();
        cargarProveedores();
    })
    .catch(error => console.error('Error:', error));
}

function eliminarProveedor(id) {
    if (!confirm('¿Está seguro de eliminar este proveedor?')) return;
    
    fetch(`http://127.0.0.1:5000/proveedores/${id}`, {
        method: 'DELETE'
    })
    .then(response => response.json())
    .then(data => {
        alert(data.mensaje);
        cargarProveedores();
    })
    .catch(error => console.error('Error:', error));
}

function editarProveedor(id, proveedorStr) {
    const proveedor = JSON.parse(unescape(proveedorStr));
    document.getElementById('idProveedorEdit').value = id;
    document.getElementById('nombreProveedor').value = proveedor.nombreProveedor;
    document.getElementById('telefProveedor').value = proveedor.telefProveedor;
    document.getElementById('direccProveedor').value = proveedor.direccProveedor || '';
    document.getElementById('btnCancelarEdit').style.display = 'inline-block';
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function resetForm() {
    document.getElementById('formProveedor').reset();
    document.getElementById('idProveedorEdit').value = '';
    document.getElementById('btnCancelarEdit').style.display = 'none';
}

function escape(str) {
    return str.replace(/'/g, "\\'");
}