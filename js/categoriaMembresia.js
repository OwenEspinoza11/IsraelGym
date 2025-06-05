document.addEventListener('DOMContentLoaded', function() {
    cargarCategoriasMembresia();
    
    document.getElementById('formCategoriaMembresia').addEventListener('submit', function(e) {
        e.preventDefault();
        const idEdit = document.getElementById('idCatMembresiaEdit').value;
        const nombre = document.getElementById('nombreCatMemb').value.trim();
        
        if (!nombre) {
            alert('Por favor ingrese un nombre válido para la categoría');
            return;
        }

        if (idEdit) {
            actualizarCategoriaMembresia(idEdit, nombre);
        } else {
            agregarCategoriaMembresia(nombre);
        }
    });

    document.getElementById('btnCancelarEdit').addEventListener('click', resetForm);
});

function cargarCategoriasMembresia() {
    fetch('http://127.0.0.1:5000/categorias-membresia')
        .then(response => response.json())
        .then(data => {
            const tbody = document.querySelector('#tablaCategoriaMembresia tbody');
            tbody.innerHTML = '';
            
            data.forEach(categoria => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${categoria.id}</td>
                    <td>${categoria.nombre}</td>
                    <td>
                        <button class="btn-edit" onclick="editarCategoriaMembresia(${categoria.id}, '${categoria.nombre.replace(/'/g, "\\'")}')">Editar</button>
                        <button class="btn-danger" onclick="eliminarCategoriaMembresia(${categoria.id})">Eliminar</button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        })
        .catch(error => console.error('Error:', error));
}

function agregarCategoriaMembresia(nombre) {
    fetch('http://127.0.0.1:5000/categorias-membresia', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ nombre: nombre })
    })
    .then(response => response.json())
    .then(data => {
        alert(data.mensaje);
        resetForm();
        cargarCategoriasMembresia();
    })
    .catch(error => console.error('Error:', error));
}

function actualizarCategoriaMembresia(id, nombre) {
    fetch(`http://127.0.0.1:5000/categorias-membresia/${id}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ nombre: nombre })
    })
    .then(response => response.json())
    .then(data => {
        alert(data.mensaje);
        resetForm();
        cargarCategoriasMembresia();
    })
    .catch(error => console.error('Error:', error));
}

function eliminarCategoriaMembresia(id) {
    if (!confirm('¿Está seguro de eliminar esta categoría?')) return;
    
    fetch(`http://127.0.0.1:5000/categorias-membresia/${id}`, {
        method: 'DELETE'
    })
    .then(response => response.json())
    .then(data => {
        alert(data.mensaje);
        cargarCategoriasMembresia();
    })
    .catch(error => console.error('Error:', error));
}

function editarCategoriaMembresia(id, nombre) {
    document.getElementById('idCatMembresiaEdit').value = id;
    document.getElementById('nombreCatMemb').value = nombre;
    document.getElementById('btnCancelarEdit').style.display = 'inline-block';
    document.getElementById('nombreCatMemb').focus();
}

function resetForm() {
    document.getElementById('formCategoriaMembresia').reset();
    document.getElementById('idCatMembresiaEdit').value = '';
    document.getElementById('btnCancelarEdit').style.display = 'none';
}