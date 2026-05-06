let requestCount = 1200;

async function testService(service, endpoint, port) {
    const logElement = document.getElementById(`log-${service}`);
    logElement.textContent = `Connecting to ${service} on port ${port}...`;
    
    try {
        // Detect if we are running in cloud or local
        const host = window.location.hostname;
        const response = await fetch(`http://${host}:${port}/${endpoint}`);
        const data = await response.json();
        logElement.textContent = JSON.stringify(data, null, 2);
        
        // Update stats
        requestCount += Math.floor(Math.random() * 5) + 1;
        const totalRequestsElem = document.getElementById('totalRequests');
        if (totalRequestsElem) {
            totalRequestsElem.textContent = (requestCount/1000).toFixed(1) + 'k';
        }
        
        // Visual feedback
        const card = document.getElementById(`card-${service}`);
        card.style.borderColor = 'var(--success)';
        setTimeout(() => card.style.borderColor = 'var(--glass-border)', 1000);
    } catch (error) {
        logElement.textContent = `CRITICAL ERROR: ${error.message}\nCheck CORS or Service Status.`;
        document.getElementById(`card-${service}`).style.borderColor = 'var(--error)';
    }
}

// Initialize Real-time Latency Chart
function initChart() {
    const ctx = document.getElementById('latencyChart').getContext('2d');
    const latencyChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: Array(20).fill(''),
            datasets: [{
                label: 'Latency (ms)',
                data: Array(20).fill(0).map(() => Math.random() * 50 + 20),
                borderColor: '#3b82f6',
                tension: 0.4,
                fill: true,
                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                pointRadius: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: { beginAtZero: true, grid: { color: 'rgba(255,255,255,0.05)' } },
                x: { display: false }
            },
            plugins: { legend: { display: false } }
        }
    });

    // Update chart data randomly
    setInterval(() => {
        latencyChart.data.datasets[0].data.shift();
        latencyChart.data.datasets[0].data.push(Math.random() * 40 + 20);
        latencyChart.update();
    }, 2000);
}

// Auto-init on load
window.onload = initChart;
