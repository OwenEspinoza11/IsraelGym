// Configuración inicial de fechas
    document.addEventListener('DOMContentLoaded', function () {
      const hoy = new Date();
      const primerDiaMes = new Date(hoy.getFullYear(), hoy.getMonth(), 1);

      document.getElementById('fechaInicio').value = primerDiaMes.toISOString().split('T')[0];
      document.getElementById('fechaFin').value = hoy.toISOString().split('T')[0];

      cargarReportes();
    });

    // Cargar todos los reportes
    function cargarReportes() {
      const fechaInicio = document.getElementById('fechaInicio').value;
      const fechaFin = document.getElementById('fechaFin').value;

      cargarVentasPorPeriodo(fechaInicio, fechaFin);
      cargarProductosMasVendidos();
      cargarMembresiasActivas();
      cargarInventarioBajo();
      cargarResumenes();
    }

    // Cargar ventas por período
    function cargarVentasPorPeriodo(fechaInicio, fechaFin) {
      fetch(`http://127.0.0.1:5000/reportes/ventas-por-periodo?fecha_inicio=${fechaInicio}&fecha_fin=${fechaFin}`)
        .then(res => res.json())
        .then(data => {
          // Actualizar gráfico de ventas
          const fechas = data.map(item => item.fecha);
          const montos = data.map(item => item.monto_total);

          if (window.ventasChart) {
            window.ventasChart.destroy();
          }

          const ctx = document.getElementById('grafico-ventas').getContext('2d');
          window.ventasChart = new Chart(ctx, {
            type: 'line',
            data: {
              labels: fechas,
              datasets: [{
                label: 'Ventas por día',
                data: montos,
                backgroundColor: 'rgba(54, 162, 235, 0.2)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
              }]
            },
            options: {
              responsive: true,
              scales: {
                y: {
                  beginAtZero: true
                }
              }
            }
          });

          // Actualizar tabla de últimas ventas
          const tbody = document.querySelector('#tabla-ultimas-ventas tbody');
          tbody.innerHTML = '';

          // Simulamos datos de últimas ventas (deberías crear un endpoint específico para esto)
          data.slice(0, 5).forEach(venta => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
          <td>${Math.floor(Math.random() * 1000)}</td>
          <td>${venta.fecha}</td>
          <td>$${venta.monto_total.toFixed(2)}</td>
          <td>${Math.floor(Math.random() * 5) + 1} productos</td>
        `;
            tbody.appendChild(tr);
          });
        });
    }

    // Cargar productos más vendidos
    function cargarProductosMasVendidos() {
      fetch('http://127.0.0.1:5000/reportes/productos-mas-vendidos?limit=5')
        .then(res => res.json())
        .then(data => {
          const productos = data.map(item => item.producto);
          const cantidades = data.map(item => item.total_vendido);

          if (window.productosChart) {
            window.productosChart.destroy();
          }

          const ctx = document.getElementById('grafico-productos').getContext('2d');
          window.productosChart = new Chart(ctx, {
            type: 'bar',
            data: {
              labels: productos,
              datasets: [{
                label: 'Unidades vendidas',
                data: cantidades,
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
              }]
            },
            options: {
              responsive: true,
              scales: {
                y: {
                  beginAtZero: true
                }
              }
            }
          });
        });
    }

    // Cargar membresías activas
    function cargarMembresiasActivas() {
      fetch('http://127.0.0.1:5000/reportes/membresias-activas')
        .then(res => res.json())
        .then(data => {
          document.getElementById('membresias-activas').textContent =
            data.reduce((sum, item) => sum + item.cantidad, 0);
        });
    }

    // Cargar inventario bajo
    function cargarInventarioBajo() {
      fetch('http://127.0.0.1:5000/reportes/inventario-bajo?umbral=10')
        .then(res => res.json())
        .then(data => {
          document.getElementById('productos-bajo-stock').textContent = data.length;

          const tbody = document.querySelector('#tabla-inventario-bajo tbody');
          tbody.innerHTML = '';

          data.slice(0, 5).forEach(item => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
          <td>${item.producto}</td>
          <td class="${item.stock < 5 ? 'stock-critico' : 'stock-bajo'}">${item.stock}</td>
          <td>${item.categoria}</td>
        `;
            tbody.appendChild(tr);
          });
        });
    }

    // Cargar resúmenes
    function cargarResumenes() {
      // Ventas hoy (simulado)
      fetch('http://127.0.0.1:5000/reportes/ventas-por-periodo?fecha_inicio=' +
        new Date().toISOString().split('T')[0] +
        '&fecha_fin=' + new Date().toISOString().split('T')[0])
        .then(res => res.json())
        .then(data => {
          const totalHoy = data.reduce((sum, item) => sum + item.monto_total, 0);
          document.getElementById('ventas-hoy').textContent = `$${totalHoy.toFixed(2)}`;
        });

      // Ingresos mes (simulado)
      const primerDiaMes = new Date(new Date().getFullYear(), new Date().getMonth(), 1)
        .toISOString().split('T')[0];
      const hoy = new Date().toISOString().split('T')[0];

      fetch(`http://127.0.0.1:5000/reportes/ventas-por-periodo?fecha_inicio=${primerDiaMes}&fecha_fin=${hoy}`)
        .then(res => res.json())
        .then(data => {
          const totalMes = data.reduce((sum, item) => sum + item.monto_total, 0);
          document.getElementById('ingresos-mes').textContent = `$${totalMes.toFixed(2)}`;
        });
    }