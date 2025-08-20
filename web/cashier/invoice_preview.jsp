<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    int invoiceId = Integer.parseInt(request.getParameter("invoice_id"));

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String customerName = "", customerPhone = "";
    double total = 0, payment = 0, balance = 0;
    String createdAt = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_billing", "root", "");

        // Get invoice header
        ps = conn.prepareStatement("SELECT * FROM invoices WHERE invoice_id = ?");
        ps.setInt(1, invoiceId);
        rs = ps.executeQuery();
        if (rs.next()) {
            customerName = rs.getString("customer_name");
            customerPhone = rs.getString("customer_phone");
            total = rs.getDouble("total");
            payment = rs.getDouble("payment");
            balance = rs.getDouble("balance");
            createdAt = rs.getString("created_at");
        }
        rs.close();
        ps.close();

%>

<!-- Modal Content -->
<div id="invoiceModal" style="font-family: 'Segoe UI', sans-serif; padding:20px; background:#fff; border-radius:12px; max-width:700px; margin:auto; box-shadow:0 0 15px rgba(0,0,0,0.1);">
    <h2 style="text-align:center;">Invoice #<%= invoiceId %></h2>
    <p><strong>Date:</strong> <%= createdAt %></p>
    <p><strong>Customer:</strong> <%= customerName %></p>
    <p><strong>Contact:</strong> <%= customerPhone %></p>

    <table style="width:100%; border-collapse:collapse; margin-top:20px;">
        <thead>
            <tr>
                <th style="text-align:left; padding:8px; border-bottom:1px solid #ccc;">Item</th>
                <th style="text-align:right; padding:8px; border-bottom:1px solid #ccc;">Qty</th>
                <th style="text-align:right; padding:8px; border-bottom:1px solid #ccc;">Price</th>
                <th style="text-align:right; padding:8px; border-bottom:1px solid #ccc;">Subtotal</th>
            </tr>
        </thead>
        <tbody>
            <%
                // Get invoice items
                ps = conn.prepareStatement("SELECT * FROM invoice_items WHERE invoice_id = ?");
                ps.setInt(1, invoiceId);
                rs = ps.executeQuery();
                while (rs.next()) {
                    String title = rs.getString("title");
                    int qty = rs.getInt("quantity");
                    double price = rs.getDouble("price");
                    double subtotal = rs.getDouble("subtotal");
            %>
            <tr>
                <td style="padding:8px; border-bottom:1px solid #eee;"><%= title %></td>
                <td style="text-align:right; padding:8px; border-bottom:1px solid #eee;"><%= qty %></td>
                <td style="text-align:right; padding:8px; border-bottom:1px solid #eee;">LKR <%= price %></td>
                <td style="text-align:right; padding:8px; border-bottom:1px solid #eee;">LKR <%= subtotal %></td>
            </tr>
            <%
                }
                rs.close();
                ps.close();
                conn.close();
            %>
        </tbody>
    </table>

    <div style="margin-top:20px; text-align:right;">
        <p><strong>Total:</strong> LKR <%= total %></p>
        <p><strong>Paid:</strong> LKR <%= payment %></p>
        <p><strong>Balance:</strong> LKR <%= balance %></p>
    </div>

    <div style="text-align:center; margin-top:20px;">
        <button onclick="document.getElementById('invoiceModal').style.display='none';" 
                style="padding:10px 20px; border:none; border-radius:8px; background:#4682B4; color:#fff; font-weight:bold; cursor:pointer;">
            Close
        </button>
    </div>
</div>

<%
    } catch(Exception e) {
        out.println("<p style='color:red;'>Error loading invoice: " + e.getMessage() + "</p>");
    }
%>
