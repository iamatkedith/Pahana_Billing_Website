
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>POS Billing | Books</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        * { box-sizing: border-box; } 
        .billing-wrapper { 
            padding: 30px 40px 50px 40px; 
        } 
        .billing-container { 
            display: flex; gap: 20px; 
        } 
        .left-panel, .right-panel { 
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(12px); 
            padding: 20px; 
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(0,0,0,0.2); 
            max-height: calc(100vh - 120px); 
            overflow-y: auto; 
        } 
        .left-panel { 
            flex: 1.5; 
        } 
        .right-panel { 
            flex: 2; 
        } 
        .item-bar { 
            background:#fff; 
            margin-bottom:10px; 
            padding:10px 15px; 
            display:flex; 
            justify-content:space-between; 
            border-radius:10px; 
            cursor:pointer; 
            transition:0.3s; 
        } 
        .item-bar:hover { 
            background:#fceba1; 
        } 
        .cart-item {
            background:#fff; 
            padding:12px 15px; 
            border-radius:8px; 
            margin-bottom:12px; 
            display:flex; 
            align-items:center; 
            justify-content:space-between; 
            gap:15px; 
            box-shadow:0 0 5px rgba(0,0,0,0.1);
        } 
        .cart-item input[type=number] { 
            width:60px; 
        } 
        input, select { 
            padding:10px; width:100%; margin-bottom:10px; border-radius:8px; border:none; 
        } 
        .billing-wrapper button { 
            background:#4682B4; color:#fff; 
            font-weight:bold; cursor:pointer; border:none;
            border-radius:8px; padding:10px; } 
        .billing-wrapper button:hover {
            background:#0F52BA; 
        } 
        .total-section { 
            font-size:18px; 
            font-weight:bold; 
            margin:15px 0; 
            color:#000; 
        }
    </style>
</head>
<body>

<div class="billing-wrapper">

    

    <div class="billing-container">

        <!-- LEFT PANEL -->
        <div class="left-panel">
            <h3>Available Books</h3>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_billing1", "root", "");
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT isbn, title, price FROM books");
                    while(rs.next()) {
                        String title = rs.getString("title");
                        double price = rs.getDouble("price");
            %>
            <div class="item-bar" onclick="addToCart('<%=title%>', <%=price%>)">
                <span><%=title%></span>
                <span>LKR <%=price%></span>
            </div>
            <%
                    }
                    rs.close(); stmt.close(); conn.close();
                } catch(Exception e) { out.println("<p style='color:red;'>DB Error: "+e.getMessage()+"</p>"); }
            %>
        </div>

        <!-- RIGHT PANEL -->
        <div class="right-panel">
            <h3>Cart</h3>
            <div id="cart"></div>
            <div class="total-section">Total: LKR <span id="total">0.00</span></div>

            <h3>Customer Info</h3>
            <input type="text" id="customerName" placeholder="Customer Name">
            <input type="text" id="customerContact" placeholder="Contact Number">

            <h3>Payment</h3>
            <select id="paymentMethod">
                <option>Cash</option>
                <option>Card</option>
            </select>
            <input type="number" id="payingAmount" placeholder="Paying Amount" oninput="updateBalance(this.value)">
            <div class="total-section">Balance: LKR <span id="balance">0.00</span></div>

            <button onclick="generateInvoice()">Generate Invoice</button>
        </div>

    </div>
</div>

<!-- Invoice Modal -->
<div class="modal fade" id="invoiceModal" tabindex="-1" aria-labelledby="invoiceLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="invoiceLabel">Invoice</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body" id="invoiceContent">
        <!-- Invoice details will be injected here -->
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
let cart = [];

function addToCart(name, price) {
    const existing = cart.find(i=>i.name===name);
    if(existing) existing.qty++;
    else cart.push({name, price, qty:1});
    renderCart();
}

function renderCart() {
    const cartDiv = document.getElementById("cart");
    cartDiv.innerHTML = "";
    let total = 0;

    cart.forEach((item, idx)=>{
        const itemTotal = item.qty * item.price;
        total += itemTotal;

        const row = document.createElement("div");
        row.className="cart-item";

        const nameDiv = document.createElement("div");
        nameDiv.style.flex="2";
        nameDiv.textContent = item.name;

        const qtyDiv = document.createElement("div");
        qtyDiv.style.display="flex"; qtyDiv.style.alignItems="center"; qtyDiv.style.gap="5px";

        const minusBtn = document.createElement("button");
        minusBtn.textContent="−"; minusBtn.onclick=()=>{ if(item.qty>1) item.qty--; renderCart(); };

        const qtyInput = document.createElement("input");
        qtyInput.type="number"; qtyInput.min="1"; qtyInput.value=item.qty;
        qtyInput.onchange = ()=>{ item.qty=parseInt(qtyInput.value); renderCart(); };

        const plusBtn = document.createElement("button");
        plusBtn.textContent="+"; plusBtn.onclick=()=>{ item.qty++; renderCart(); };

        qtyDiv.appendChild(minusBtn); qtyDiv.appendChild(qtyInput); qtyDiv.appendChild(plusBtn);

        const priceDiv = document.createElement("div");
        priceDiv.textContent=itemTotal.toFixed(2); priceDiv.style.flex="1"; priceDiv.style.textAlign="right";

        const del = document.createElement("span");
        del.textContent="🗑"; del.style.cursor="pointer"; del.style.color="red";
        del.onclick = ()=>{ cart.splice(idx,1); renderCart(); };

        row.appendChild(nameDiv); row.appendChild(qtyDiv); row.appendChild(priceDiv); row.appendChild(del);
        cartDiv.appendChild(row);
    });

    document.getElementById("total").innerText=total.toFixed(2);
    updateBalance(document.getElementById("payingAmount").value);
}

function updateBalance(paying) {
    const total=parseFloat(document.getElementById("total").innerText||0);
    const balance=parseFloat(paying||0)-total;
    document.getElementById("balance").innerText=balance.toFixed(2);
}

function generateInvoice() {
    const name=document.getElementById("customerName").value.trim();
    const contact=document.getElementById("customerContact").value.trim();
    const method=document.getElementById("paymentMethod").value;
    const paid=parseFloat(document.getElementById("payingAmount").value||0);
    const total=parseFloat(document.getElementById("total").innerText||0);

    if(!name || !contact || cart.length===0){ alert("Add books and fill customer info"); return; }

    const data={customerName:name, customerContact:contact, paymentMethod:method, totalAmount:total, paidAmount:paid, balance:paid-total, cartItems:cart};

    fetch('../servlet/cashier/SaveBillServlet', {
        method:"POST",
        headers:{"Content-Type":"application/json"},
        body:JSON.stringify(data)
    })
    .then(res=>res.json())
    .then(res=>{
        if(res.status==="success") showInvoiceModal(res.redirect);
        else alert("Error saving bill");
    });
}

function showInvoiceModal(url) {
    fetch(url)
    .then(resp=>resp.text())
    .then(html=>{
        document.getElementById("invoiceContent").innerHTML = html;
        let invoiceModal = new bootstrap.Modal(document.getElementById('invoiceModal'));
        invoiceModal.show();
    });
}
</script>

</body>
</html>