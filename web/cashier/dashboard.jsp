<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cashier Dashboard | Pahana Edu</title>
    <style>
        * { box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { background:#f5f6fa; margin:0; padding:0; }
        .dashboard-wrapper { max-width:1200px; margin:auto; padding:40px; }
        h2 { text-align:center; margin-bottom:40px; }

        /* Info boxes */
        .info-container { display:flex; flex-wrap:wrap; gap:20px; justify-content:space-around; margin-bottom:40px; }
        .info-box {
            flex:1 1 200px;
            padding:30px 20px;
            background:linear-gradient(135deg,#4682B4,#0F52BA);
            color:#fff;
            border-radius:12px;
            box-shadow:0 10px 20px rgba(0,0,0,0.1);
            position:relative;
            overflow:hidden;
            cursor:pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .info-box:hover { transform: translateY(-5px); box-shadow:0 15px 25px rgba(0,0,0,0.2); }
        .info-box h3 { font-size:32px; margin:0; }
        .info-box p { font-size:16px; margin:5px 0 0; }
        .info-icon {
            position:absolute;
            top:10px; right:15px;
            font-size:50px;
            opacity:0.2;
        }

        /* Chart */
        #salesChartWrapper {
            background:#fff;
            padding:20px;
            border-radius:12px;
            box-shadow:0 10px 20px rgba(0,0,0,0.1);
        }
        canvas { max-width:100%; }

    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div class="dashboard-wrapper">
    <h2>Cashier Dashboard</h2>

    <div class="info-container">
        <div class="info-box">
            <h3 id="totalSales">0</h3>
            <p>Total Sales ($)</p>
            <div class="info-icon">💰</div>
        </div>
        <div class="info-box">
            <h3 id="totalInvoices">0</h3>
            <p>Total Invoices</p>
            <div class="info-icon">🧾</div>
        </div>
        <div class="info-box">
            <h3 id="booksSold">0</h3>
            <p>Books Sold</p>
            <div class="info-icon">📚</div>
        </div>
        <div class="info-box">
            <h3 id="lowStockItems">0</h3>
            <p>Low Stock Items</p>
            <div class="info-icon">⚠️</div>
        </div>
    </div>

    <div id="salesChartWrapper">
        <h3 style="text-align:center; margin-bottom:20px;">Sales Last 7 Days</h3>
        <canvas id="salesChart"></canvas>
    </div>
</div>

<script>
var contextPath = "<%= request.getContextPath() %>";

// Animate counters
function animateCounter(id, value) {
    let element = document.getElementById(id);
    let current = 0;
    let increment = value / 100; // 100 frames
    let interval = setInterval(() => {
        current += increment;
        if(current >= value){
            current = value;
            clearInterval(interval);
        }
        element.innerText = Math.floor(current);
    }, 10); // 10ms per frame
}

// Load dashboard data
function loadDashboard() {
    fetch(contextPath + "/cashier/DashboardServlet")
    .then(res => res.json())
    .then(data => {
        animateCounter("totalSales", data.totalSales);
        animateCounter("totalInvoices", data.totalInvoices);
        animateCounter("booksSold", data.booksSold);
        animateCounter("lowStockItems", data.lowStockItems);

        // Chart
        const labels = data.dailySales.map(d => d.date);
        const salesData = data.dailySales.map(d => d.sales);

        const ctx = document.getElementById('salesChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Daily Sales ($)',
                    data: salesData,
                    backgroundColor: 'rgba(70,130,180,0.7)',
                    borderColor: 'rgba(70,130,180,1)',
                    borderWidth: 1,
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero:true },
                    x: { grid: { display: false } }
                }
            }
        });
    });
}

// Initial load
loadDashboard();
</script>
</body>
</html>
