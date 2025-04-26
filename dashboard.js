let datos = [];
let chart = null;
let modoOscuro = false;

// Función para cargar data.json
async function cargarDatos() {
    const response = await fetch('data.json');
    datos = await response.json();

    if (datos.length > 0) {
        mostrarUltimoResultado();
        construirGrafico(datos);
    } else {
        document.getElementById('ultimoDetalle').textContent = "Sin datos disponibles.";
    }
}

// Mostrar el último resultado
function mostrarUltimoResultado() {
    const ultimo = datos[datos.length - 1];
    document.getElementById('ultimoDetalle').innerHTML = `
        📅 ${ultimo.FechaHora}<br>
        📥 Descarga: ${ultimo.Download} Mbps<br>
        📤 Subida: ${ultimo.Upload} Mbps<br>
        🕒 Latencia: ${ultimo.Latency} ms
    `;
}

// Construir el gráfico
function construirGrafico(filtrado) {
    const fechas = filtrado.map(x => x.FechaHora);
    const descarga = filtrado.map(x => x.Download);
    const subida = filtrado.map(x => x.Upload);
    const latencia = filtrado.map(x => x.Latency);

    const ctx = document.getElementById('speedChart').getContext('2d');

    if (chart) {
        chart.destroy();
    }

    chart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: fechas,
            datasets: [
                {
                    label: 'Descarga (Mbps)',
                    data: descarga,
                    borderColor: 'blue',
                    fill: false,
                    tension: 0.3
                },
                {
                    label: 'Subida (Mbps)',
                    data: subida,
                    borderColor: 'green',
                    fill: false,
                    tension: 0.3
                },
                {
                    label: 'Latencia (ms)',
                    data: latencia,
                    borderColor: 'red',
                    fill: false,
                    tension: 0.3
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Fecha y Hora'
                    }
                },
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Mbps / ms'
                    }
                }
            },
            plugins: {
                legend: {
                    position: 'top'
                }
            }
        }
    });
}

// Filtrar por fechas seleccionadas
function filtrarDatos() {
    const start = document.getElementById('startDate').value;
    const end = document.getElementById('endDate').value;

    if (!start || !end) {
        alert('Por favor selecciona ambas fechas.');
        return;
    }

    const filtrado = datos.filter(item => {
        const fecha = item.FechaHora.split(' ')[0];
        return fecha >= start && fecha <= end;
    });

    construirGrafico(filtrado);

    if (filtrado.length > 0) {
        const ultimoFiltrado = filtrado[filtrado.length - 1];
        document.getElementById('ultimoDetalle').innerHTML = `
            📅 ${ultimoFiltrado.FechaHora}<br>
            📥 Descarga: ${ultimoFiltrado.Download} Mbps<br>
            📤 Subida: ${ultimoFiltrado.Upload} Mbps<br>
            🕒 Latencia: ${ultimoFiltrado.Latency} ms
        `;
    } else {
        document.getElementById('ultimoDetalle').textContent = "Sin datos en este rango.";
    }
}

// Resetear filtro
function resetearFiltro() {
    construirGrafico(datos);
    mostrarUltimoResultado();
    document.getElementById('startDate').value = '';
    document.getElementById('endDate').value = '';
}

// Modo Oscuro
function toggleModoOscuro() {
    modoOscuro = !modoOscuro;
    document.body.classList.toggle('dark-mode', modoOscuro);
}

// Cargar al inicio
cargarDatos();
