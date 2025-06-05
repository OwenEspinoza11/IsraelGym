document.addEventListener('DOMContentLoaded', function() {
    cargarClientes();
    
    document.getElementById('formCliente').addEventListener('submit', function(e) {
        e.preventDefault();
        const idEdit = document.getElementById('idClienteEdit').value;
        const cliente = {
            primerNombre: document.getElementById('primerNombre').value.trim(),
            segundoNombre: document.getElementById('segundoNombre').value.trim(),
            primerApellido: document.getElementById('primerApellido').value.trim(),
            segundoApellido: document.getElementById('segundoApellido').value.trim(),
            telefono: document.getElementById('telefono').value.trim(),
            email: document.getElementById('email').value.trim(),
            direccion: document.getElementById('direccion').value.trim(),
            estado: document.getElementById('estado').value
        };

        if (!cliente.primerNombre || !cliente.primerApellido || !cliente.telefono) {
            alert('Por favor complete los campos obligatorios (Primer Nombre, Primer Apellido y Teléfono)');
            return;
        }

        if (idEdit) {
            actualizarCliente(idEdit, cliente);
        } else {
            agregarCliente(cliente);
        }
    });

    document.getElementById('btnCancelarEdit').addEventListener('click', resetForm);
});

function cargarClientes() {
    fetch('http://127.0.0.1:5000/clientes')
        .then(response => response.json())
        .then(data => {
            const tbody = document.querySelector('#tablaClientes tbody');
            tbody.innerHTML = '';
            
            data.forEach(cliente => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${cliente.id}</td>
                    <td>${cliente.primerNombre} ${cliente.segundoNombre || ''} ${cliente.primerApellido} ${cliente.segundoApellido || ''}</td>
                    <td>${cliente.telefono}</td>
                    <td>${cliente.email || '-'}</td>
                    <td>${cliente.estado === 'A' ? 'Activo' : 'Inactivo'}</td>
                    <td>
                        <button class="btn-edit" onclick="editarCliente(${cliente.id}, '${escape(JSON.stringify(cliente))}')">Editar</button>
                        <button class="btn-danger" onclick="eliminarCliente(${cliente.id})">Eliminar</button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        })
        .catch(error => console.error('Error:', error));
}

function agregarCliente(cliente) {
    fetch('http://127.0.0.1:5000/clientes', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(cliente)
    })
    .then(response => response.json())
    .then(data => {
        alert(data.mensaje);
        resetForm();
        cargarClientes();
    })
    .catch(error => console.error('Error:', error));
}

function actualizarCliente(id, cliente) {
    fetch(`http://127.0.0.1:5000/clientes/${id}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(cliente)
    })
    .then(response => response.json())
    .then(data => {
        alert(data.mensaje);
        resetForm();
        cargarClientes();
    })
    .catch(error => console.error('Error:', error));
}

function eliminarCliente(id) {
    if (!confirm('¿Está seguro de eliminar este cliente?')) return;
    
    fetch(`http://127.0.0.1:5000/clientes/${id}`, {
        method: 'DELETE'
    })
    .then(response => response.json())
    .then(data => {
        alert(data.mensaje);
        cargarClientes();
    })
    .catch(error => console.error('Error:', error));
}

function editarCliente(id, clienteStr) {
    const cliente = JSON.parse(unescape(clienteStr));
    document.getElementById('idClienteEdit').value = id;
    document.getElementById('primerNombre').value = cliente.primerNombre;
    document.getElementById('segundoNombre').value = cliente.segundoNombre || '';
    document.getElementById('primerApellido').value = cliente.primerApellido;
    document.getElementById('segundoApellido').value = cliente.segundoApellido || '';
    document.getElementById('telefono').value = cliente.telefono;
    document.getElementById('email').value = cliente.email || '';
    document.getElementById('direccion').value = cliente.direccion || '';
    document.getElementById('estado').value = cliente.estado;
    document.getElementById('btnCancelarEdit').style.display = 'inline-block';
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function resetForm() {
    document.getElementById('formCliente').reset();
    document.getElementById('idClienteEdit').value = '';
    document.getElementById('estado').value = 'A';
    document.getElementById('btnCancelarEdit').style.display = 'none';
}

function escape(str) {
    return str.replace(/'/g, "\\'");
}