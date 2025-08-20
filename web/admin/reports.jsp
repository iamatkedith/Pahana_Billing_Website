<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../navbar.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin Reports</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 20px;
                background: #f4f6f9;
            }
            h1 {
                text-align: center;
                margin-bottom: 20px;
                color: #2c3e50;
            }
            .panel {
                background: #fff;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 25px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }
            .panel:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 16px rgba(0,0,0,0.12);
            }
            .panel-header {
                font-size: 18px;
                font-weight: bold;
                margin-bottom: 15px;
                color: #34495e;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            th, td {
                padding: 10px;
                border-bottom: 1px solid #ddd;
                text-align: left;
            }
            th {
                background: #2c3e50;
                color: white;
            }
            .chart-container {
                position: relative;
                height: 400px;
                width: 100%;
            }
            .filter-panel {
                margin-bottom: 15px;
            }
            select, button {
                padding: 6px 12px;
                margin-right: 10px;
                border-radius: 6px;
                border: 1px solid #ccc;
                font-size: 14px;
                cursor: pointer;
                transition: background 0.2s ease;
            }
            button:hover {
                background: #2c3e50;
                color: white;
            }
        </style>
    </head>
    <body>

        <h1>Admin Reports</h1>

        <!-- Panel 1: Customer Purchases -->
        <div class="panel">
            <div class="panel-header">Customer Purchases</div>
            <div class="filter-panel">
                <select id="customerFilter" onchange="loadCustomerHistory()"></select>
                <button onclick="downloadCustomerCSV()">Download CSV</button>
            </div>
            <table id="customerTable">
                <thead>
                    <tr>
                        <th>Customer Name</th>
                        <th>Invoice ID</th>
                        <th>Total</th>
                        <th>Payment</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>

        <!-- Panel 2: Monthly Sales Chart -->
        <div class="panel">
            <div class="panel-header">Monthly Sales</div>
            <div class="filter-panel">
                <select id="salesYear" onchange="loadSalesChart()"></select>
                <button onclick="downloadMonthlySales()">Download TXT</button>
            </div>
            <div class="chart-container">
                <canvas id="salesChart"></canvas>
            </div>
        </div>

        <!-- Panel 3: Low Stock Items -->
        <div class="panel">
            <div class="panel-header">Low Stock Items (Below 10)</div>
            <table id="lowStockTable">
                <thead>
                    <tr>
                        <th>ISBN</th>
                        <th>Title</th>
                        <th>Available Stock</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>

        <script>
            const contextPath = "<%= request.getContextPath()%>";


            // ========== Populate Year Dropdown ==========
            let currentYear = new Date().getFullYear();
            let yearSelect = document.getElementById("salesYear");
            for (let i = currentYear; i >= currentYear - 5; i--) {
                let opt = document.createElement("option");
                opt.value = i;
                opt.text = i;
                yearSelect.add(opt);
            }

            // ========== Panel 1: Customer Purchases ==========
            let allCustomerData = [];

            function renderCustomerTable(data) {
                let tbody = document.querySelector("#customerTable tbody");
                tbody.innerHTML = "";

                if (!data || data.length === 0) {
                    let tr = document.createElement("tr");
                    tr.innerHTML = `<td colspan="4" style="text-align:center; color:gray;">No records found</td>`;
                    tbody.appendChild(tr);
                    return;
                }

                data.forEach(row => {
                    let tr = document.createElement("tr");

                    let td1 = document.createElement("td");
                    td1.textContent = row.customer_name;
                    tr.appendChild(td1);

                    let td2 = document.createElement("td");
                    td2.textContent = row.invoice_id;
                    tr.appendChild(td2);

                    let td3 = document.createElement("td");
                    td3.textContent = row.total;
                    tr.appendChild(td3);

                    let td4 = document.createElement("td");
                    td4.textContent = row.payment;
                    tr.appendChild(td4);

                    tbody.appendChild(tr);
                });
            }

            function loadCustomerHistory() {
                let filterCustomer = document.getElementById("customerFilter").value;
                fetch(contextPath + "/cashier/ReportsServlet?type=customerHistory")
                        .then(res => res.json())
                        .then(data => {
                            allCustomerData = data;
                            // Populate customer filter dropdown
                            let customerSelect = document.getElementById("customerFilter");
                            if (customerSelect.options.length === 0) {
                                let uniqueCustomers = [...new Set(data.map(row => row.customer_name))];
                                customerSelect.add(new Option("All Customers", ""));
                                uniqueCustomers.forEach(c => customerSelect.add(new Option(c, c)));
                            }

                            // Filter data
                            let filtered = filterCustomer ? data.filter(row => row.customer_name === filterCustomer) : data;

                            // Fill table (via helper method)
                            renderCustomerTable(filtered);
                        });
            }

            function downloadCustomerCSV() {
                let table = document.getElementById("customerTable");
                let rows = table.querySelectorAll("tbody tr");
                if (rows.length === 0) {
                    alert("No data to download!");
                    return;
                }

                let csv = "Customer Name,Invoice ID,Total,Payment\n";

                rows.forEach(tr => {
                    let cells = tr.querySelectorAll("td");
                    let rowData = [];
                    cells.forEach(td => rowData.push(td.textContent));
                    csv += rowData.join(",") + "\n";
                });

                let blob = new Blob([csv], {type: "text/csv"});
                let a = document.createElement("a");
                a.href = URL.createObjectURL(blob);
                a.download = "customer_purchases.csv";
                a.click();
            }


            // ========== Panel 2: Monthly Sales Chart ==========
            let salesChartInstance;
            function loadSalesChart() {
                let year = document.getElementById("salesYear").value;
                fetch(contextPath + "/cashier/ReportsServlet?type=salesReport")
                        .then(res => res.json())
                        .then(data => {
                            let monthMap = {"01": 0, "02": 0, "03": 0, "04": 0, "05": 0, "06": 0, "07": 0, "08": 0, "09": 0, "10": 0, "11": 0, "12": 0};
                            data.forEach(row => {
                                let date = row.created_at; // yyyy-MM-dd
                                let y = date.substring(0, 4);
                                let m = date.substring(5, 7);
                                if (y == year)
                                    monthMap[m] += parseFloat(row.total);
                            });
                            let monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
                            let labels = Object.keys(monthMap).map(m => monthNames[parseInt(m) - 1]);
                            let totals = Object.values(monthMap);

                            const ctx = document.getElementById('salesChart').getContext('2d');
                            if (salesChartInstance)
                                salesChartInstance.destroy();
                            salesChartInstance = new Chart(ctx, {
                                type: 'line',
                                data: {
                                    labels: labels,
                                    datasets: [{
                                            label: 'Monthly Sales',
                                            data: totals,
                                            fill: false,
                                            borderColor: 'rgba(70,130,180,1)',
                                            backgroundColor: 'rgba(70,130,180,0.7)',
                                            tension: 0.3
                                        }]
                                },
                                options: {
                                    responsive: true,
                                    scales: {y: {beginAtZero: true}}
                                }
                            });
                        });
            }

            function downloadMonthlySales() {
                let year = document.getElementById("salesYear").value;
                let txt = "Month,Total Sales\n";
                let data = salesChartInstance.data;
                for (let i = 0; i < data.labels.length; i++) {
                    txt += data.labels[i] + "," + data.datasets[0].data[i] + "\n";
                }
                let blob = new Blob([txt], {type: "text/plain"});
                let a = document.createElement("a");
                a.href = URL.createObjectURL(blob);
                a.download = "monthly_sales_" + year + ".txt";
                a.click();
            }

            // ========== Panel 3: Low Stock ==========
            function loadLowStock() {
                fetch(contextPath + "/cashier/ReportsServlet?type=stockDetails")
                        .then(res => res.json())
                        .then(data => {
                            let tbody = document.querySelector("#lowStockTable tbody");
                            tbody.innerHTML = "";
                            data.filter(row => row.stock_available < 10).forEach(row => {
                                let tr = document.createElement("tr");
                                ["isbn", "title", "stock_available"].forEach(key => {
                                    let td = document.createElement("td");
                                    td.textContent = row[key];
                                    tr.appendChild(td);
                                });
                                tbody.appendChild(tr);
                            });
                        });
            }

            // Initial Load
            loadCustomerHistory();
            loadSalesChart();
            loadLowStock();
        </script>

    </body>
</html>
