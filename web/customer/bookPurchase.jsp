<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../navbar.jsp" %>
<html>
<head>
    <title>Book Store | Purchase</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        body { background: #f4f6f8; }
        .left-panel { max-height: 80vh; overflow-y: auto; padding: 15px; background: #fff; border-radius: 10px; }
        .right-panel { padding: 15px; background: #fff; border-radius: 10px; position: sticky; top: 20px; }
        .book-card { cursor:pointer; transition: 0.3s; margin-bottom:10px; padding:10px; border-radius:8px; border:1px solid #ddd; }
        .book-card:hover { background:#fceba1; }
        .cart-table th, .cart-table td { vertical-align: middle !important; }
    </style>
</head>
<body>
<div class="container-fluid mt-4">
    <div class="row">
        <!-- LEFT PANEL: Book List -->
        <div class="col-md-6">
            <h4>Available Books</h4>
            <div class="left-panel">
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_billing1","root","");
                        PreparedStatement ps = conn.prepareStatement("SELECT id,title,price,stock FROM books");
                        ResultSet rs = ps.executeQuery();
                        while(rs.next()){
                            int id = rs.getInt("id");
                            String title = rs.getString("title");
                            double price = rs.getDouble("price");
                            int stock = rs.getInt("stock");
                %>
                    <div class="book-card" onclick="addToCart(<%=id%>,'<%=title%>',<%=price%>,<%=stock%>)">
                        <strong><%=title%></strong><br>
                        Price: LKR <%=price%> | Stock: <%=stock%>
                    </div>
                <%
                        }
                        rs.close(); ps.close(); conn.close();
                    } catch(Exception e){ out.println("<p style='color:red;'>DB Error: "+e.getMessage()+"</p>"); }
                %>
            </div>
        </div>

        <!-- RIGHT PANEL: Cart & Customer Info -->
        <div class="col-md-6">
            <h4>Cart</h4>
            <div class="right-panel">
                <table class="table table-bordered cart-table">
                    <thead>
                        <tr>
                            <th>Book</th>
                            <th>Qty</th>
                            <th>Price</th>
                            <th>Subtotal</th>
                            <th>Remove</th>
                        </tr>
                    </thead>
                    <tbody id="cartBody">
                        <tr><td colspan="5" class="text-center">Cart is empty</td></tr>
                    </tbody>
                </table>
                <h5>Total: LKR <span id="total">0.00</span></h5>

                <h5 class="mt-4">Customer Info</h5>
                <input type="text" id="customerName" placeholder="Name" class="form-control mb-2">
                <input type="text" id="customerPhone" placeholder="Phone" class="form-control mb-2">
                <button class="btn btn-success w-100 mt-2" onclick="purchaseBooks()">Purchase</button>
            </div>
        </div>
    </div>
</div>

<script>
let cart = [];

function addToCart(id, title, price, stock){
    const existing = cart.find(item=>item.id===id);
    if(existing){
        if(existing.qty+1 > stock){ alert("Not enough stock!"); return; }
        existing.qty += 1;
    } else cart.push({id,title,price,qty:1,stock});
    renderCart();
}

function renderCart() {
    const tbody = document.getElementById("cartBody");
    tbody.innerHTML = ""; // clear existing rows

    if (cart.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5" class="text-center">Cart is empty</td></tr>';
        document.getElementById("total").innerText = "0.00";
        return;
    }

    let total = 0;
    cart.forEach((item, index) => {
        const subtotal = item.price * item.qty;
        total += subtotal;

        const row = document.createElement("tr");

        // Title
        const tdTitle = document.createElement("td");
        tdTitle.textContent = item.title;
        row.appendChild(tdTitle);

        // Quantity input
        const tdQty = document.createElement("td");
        const qtyInput = document.createElement("input");
        qtyInput.type = "number";
        qtyInput.min = "1";
        qtyInput.max = item.stock;
        qtyInput.value = item.qty;
        qtyInput.style.width = "60px";
        qtyInput.onchange = function () {
            const newQty = parseInt(this.value);
            if (newQty > item.stock) {
                alert("Quantity exceeds stock!");
                this.value = item.qty;
                return;
            }
            item.qty = newQty;
            renderCart();
        };
        tdQty.appendChild(qtyInput);
        row.appendChild(tdQty);

        // Price
        const tdPrice = document.createElement("td");
        tdPrice.textContent = "LKR " + item.price;
        row.appendChild(tdPrice);

        // Subtotal
        const tdSubtotal = document.createElement("td");
        tdSubtotal.textContent = "LKR " + subtotal;
        row.appendChild(tdSubtotal);

        // Remove button
        const tdRemove = document.createElement("td");
        const removeBtn = document.createElement("button");
        removeBtn.className = "btn btn-sm btn-danger";
        removeBtn.textContent = "X";
        removeBtn.onclick = function () {
            cart.splice(index, 1);
            renderCart();
        };
        tdRemove.appendChild(removeBtn);
        row.appendChild(tdRemove);

        tbody.appendChild(row);
    });

    document.getElementById("total").innerText = total.toFixed(2);
}

function updateQty(index, value){
    const qty=parseInt(value);
    if(qty>cart[index].stock){ alert("Exceeds stock"); return; }
    cart[index].qty=qty;
    renderCart();
}

function removeItem(index){ cart.splice(index,1); renderCart(); }

function purchaseBooks(){
    if(cart.length===0){ alert("Cart is empty"); return; }
    const name=document.getElementById("customerName").value.trim();
    const phone=document.getElementById("customerPhone").value.trim();
    if(!name || !phone){ alert("Enter customer info"); return; }

    fetch("<%=request.getContextPath()%>/customer/PurchaseServlet",{
        method:"POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            customerName: name,
            customerPhone: phone,
            cart: cart
        })
    })
    .then(res=>res.text())
    .then(data=>{
        if(data.trim()==="success"){ alert("Purchase successful"); cart=[]; renderCart(); }
        else alert(data);
    }).catch(err=>alert("Error: "+err));
}

</script>
</body>
</html>
