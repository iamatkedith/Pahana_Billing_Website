<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reports | Pahana Edu</title>
    <style>
        * { box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { background: #f2f7fa; margin:0; padding:0; }
        .report-wrapper { padding:40px; max-width:1200px; margin:auto; }
        h2 { text-align:center; margin-bottom:30px; }
        .tabs { display:flex; gap:20px; margin-bottom:20px; cursor:pointer; }
        .tab { padding:10px 20px; border-radius:8px; background:#fff; box-shadow:0 0 10px rgba(0,0,0,0.1); transition:0.3s; }
        .tab.active { background:#4682B4; color:#fff; }
        .filter-panel { display:flex; flex-wrap:wrap; gap:15px; margin-bottom:20px; }
        .filter-panel select, .filter-panel input, .filter-panel button {
            padding:10px; border-radius:8px; border:none; box-shadow:0 0 5px rgba(0,0,0,0.1);
        }
        .filter-panel button { background:#4682B4; color:#fff; font-weight:bold; cursor:pointer; transition:0.3s; }
        .filter-panel button:hover { background:#0F52BA; }
        table { width:100%; border-collapse:collapse; background:#fff; border-radius:12px; overflow:hidden; box-shadow:0 0 15px rgba(0,0,0,0.1); }
        th, td { padding:12px; border-bottom:1px solid #eee; text-align:left; }
        th { background:#f0f0f0; }
        tbody tr.low-stock { background:#f8d7da; }
        .actions { display:flex; gap:10px; margin-bottom:10px; }
        .actions button { padding:8px 12px; background:#4682B4; color:#fff; border:none; border-radius:6px; cursor:pointer; }
        .actions button:hover { background:#0F52BA; }
        .report-panel { display:none; }
        .report-panel.active { display:block; }
    </style>
</head>
<body>

<div class="report-wrapper">
    <h2>POS Reports Dashboard</h2>

    <div class="tabs">
        <div class="tab active" onclick="showPanel('customerPanel', this)">Customer Purchase History</div>
        <div class="tab" onclick="showPanel('stockPanel', this)">Stock Details</div>
        <div class="tab" onclick="showPanel('salesPanel', this)">Sales Reports</div>
    </div>

    <!-- Customer Panel -->
    <div id="customerPanel" class="report-panel active">
        <div class="filter-panel">
            <select id="customerSearch">
                <option value="">All Customers</option>
            </select>
            <button onclick="loadCustomerHistory()">Filter</button>
        </div>
        <div class="actions">
            <button onclick="downloadCSV('customerTable','customer_report.csv')">Download CSV</button>
        </div>
        <table id="customerTable">
            <thead>
                <tr>
                    <th>Invoice ID</th>
                    <th>Customer Name</th>
                    <th>Contact</th>
                    <th>Total</th>
                    <th>Paid</th>
                    <th>Balance</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>

    <!-- Stock Panel -->
    <div id="stockPanel" class="report-panel">
        <div class="actions">
            <button onclick="downloadCSV('stockTable','stock_report.csv')">Download CSV</button>
        </div>
        <table id="stockTable">
            <thead>
                <tr>
                    <th>ISBN</th>
                    <th>Title</th>
                    <th>Price</th>
                    <th>Available Stock</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>

    <!-- Sales Panel -->
    <div id="salesPanel" class="report-panel">
        <div class="filter-panel">
            <select id="paymentType">
                <option value="">All Payment Types</option>
                <option value="Cash">Cash</option>
                <option value="Card">Card</option>
            </select>
            <input type="month" id="salesMonth">
            <button onclick="loadSalesReport()">Filter</button>
        </div>
        <div class="actions">
            <button onclick="downloadCSV('salesTable','sales_report.csv')">Download CSV</button>
        </div>
        <table id="salesTable">
            <thead>
                <tr>
                    <th>Invoice ID</th>
                    <th>Customer</th>
                    <th>Total</th>
                    <th>Paid</th>
                    <th>Balance</th>
                    <th>Payment Type</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</div>

<script>
var contextPath = "<%= request.getContextPath() %>";

function showPanel(panelId, tabElement){
    document.querySelectorAll('.report-panel').forEach(p=>p.classList.remove('active'));
    document.getElementById(panelId).classList.add('active');
    document.querySelectorAll('.tab').forEach(t=>t.classList.remove('active'));
    tabElement.classList.add('active');

    if(panelId === "stockPanel") loadStockDetails();
}

// Load unique customer names from invoices
fetch(contextPath + "/cashier/ReportsServlet?type=getCustomers")
.then(res => res.json())
.then(data=>{
    let select = document.getElementById("customerSearch");
    data.forEach(name=>{
        let opt = document.createElement("option");
        opt.value = name;
        opt.text = name;
        select.add(opt);
    });
});

function loadCustomerHistory(){
    let customerName = document.getElementById("customerSearch").value;
    fetch(contextPath + "/cashier/ReportsServlet?type=customerHistory&customerName=" + encodeURIComponent(customerName))
    .then(res=>res.json())
    .then(data=>{
        let tbody = document.querySelector("#customerTable tbody");
        tbody.innerHTML = ""; // clear existing rows

        data.forEach(row=>{
            let tr = document.createElement("tr"); // create row element

            // Create and append each cell
            ["invoice_id","customer_name","customer_phone","total","payment","balance"].forEach(key=>{
                let td = document.createElement("td");
                td.textContent = row[key] != null ? row[key] : "";
                tr.appendChild(td);
            });

            tbody.appendChild(tr); // append row to tbody
        });
    });
}


function loadStockDetails(){
    fetch(contextPath + "/cashier/ReportsServlet?type=stockDetails")
    .then(res=>res.json())
    .then(data=>{
        let tbody = document.querySelector("#stockTable tbody");
        tbody.innerHTML = "";

        data.forEach(row=>{
            let tr = document.createElement("tr");
            ["isbn","title","price","stock_available"].forEach(key=>{
                let td = document.createElement("td");
                td.textContent = row[key] != null ? row[key] : "";
                tr.appendChild(td);
            });
            tbody.appendChild(tr);
        });
    });
}

function loadSalesReport(){
    let paymentType = document.getElementById("paymentType").value;
    let month = document.getElementById("salesMonth").value;

    fetch(contextPath + "/cashier/ReportsServlet?type=salesReport&paymentType=" + encodeURIComponent(paymentType) + "&month=" + encodeURIComponent(month))
    .then(res=>res.json())
    .then(data=>{
        let tbody = document.querySelector("#salesTable tbody");
        tbody.innerHTML = "";

        data.forEach(row=>{
            let tr = document.createElement("tr");
            ["invoice_id","customer_name","total","payment","balance","payment_type"].forEach(key=>{
                let td = document.createElement("td");
                td.textContent = row[key] != null ? row[key] : "";
                tr.appendChild(td);
            });
            tbody.appendChild(tr);
        });
    });
}

function downloadCSV(tableId, filename){
    // Ensure table exists
    let table = document.getElementById(tableId);
    if(!table){
        console.error("Table not found:", tableId);
        return;
    }

    let rows = table.querySelectorAll("tr"); // select all rows inside this table
    let csv = [];

    rows.forEach(row=>{
        let cols = row.querySelectorAll("td, th");
        let rowData = [];
        cols.forEach(col=>{
            rowData.push('"' + col.textContent.replace(/"/g,'""') + '"');
        });
        csv.push(rowData.join(","));
    });

    let blob = new Blob([csv.join("\n")], {type:"text/csv"});
    let a = document.createElement("a");
    a.href = URL.createObjectURL(blob);
    a.download = filename;
    a.click();
}

// Initial load
loadCustomerHistory();
loadStockDetails();
loadSalesReport();
</script>

</body>
</html>
