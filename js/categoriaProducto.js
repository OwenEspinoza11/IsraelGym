document.addEventListener('DOMContentLoaded', function () {
      // Cargar categorías al iniciar
      cargarCategorias();

      // Evento para agregar categoría
      document.getElementById('btnAgregarCategoria').addEventListener('click', agregarCategoria);
    });

    function cargarCategorias() {
      fetch('http://127.0.0.1:5000/categorias')
        .then(response => {
          if (!response.ok) {
            throw new Error('Error al cargar categorías');
          }
          return response.json();
        })
        .then(data => {
          const tbody = document.getElementById('cuerpoTablaCategorias');
          tbody.innerHTML = '';

          data.forEach(categoria => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
          <td>${categoria.id}</td>
          <td>${categoria.nombre}</td>
          <td>
            <button class="btn-danger" onclick="eliminarCategoria(${categoria.id})">Eliminar</button>
          </td>
        `;
            tbody.appendChild(tr);
          });
        })
        .catch(error => {
          console.error('Error:', error);
          alert(error.message);
        });
    }

    function agregarCategoria() {
      const nombre = document.getElementById('nombreCategoria').value.trim();

      if (!nombre) {
        alert('Por favor ingrese un nombre para la categoría');
        return;
      }

      fetch('http://127.0.0.1:5000/categorias', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ nombre: nombre }),
      })
        .then(response => {
          if (!response.ok) {
            return response.json().then(err => { throw new Error(err.error || 'Error al agregar categoría'); });
          }
          return response.json();
        })
        .then(data => {
          alert(data.mensaje);
          document.getElementById('nombreCategoria').value = '';
          cargarCategorias(); // Recargar la lista
        })
        .catch(error => {
          console.error('Error:', error);
          alert(error.message);
        });
    }

    function eliminarCategoria(id) {
      if (!confirm('¿Está seguro que desea eliminar esta categoría?')) {
        return;
      }

      fetch(`http://127.0.0.1:5000/categorias/${id}`, {
        method: 'DELETE',
      })
        .then(response => {
          if (!response.ok) {
            return response.json().then(err => { throw new Error(err.error || 'Error al eliminar categoría'); });
          }
          return response.json();
        })
        .then(data => {
          alert(data.mensaje);
          cargarCategorias(); // Recargar la lista
        })
        .catch(error => {
          console.error('Error:', error);
          alert(error.message);
        });
    }