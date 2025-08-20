<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../navbar.jsp" %>
<html>
<head>
    <title>My Orders</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <h3>My Purchase History</h3>
<%
    // Get logged-in username from session
    String loggedUser = (String) session.getAttribute("username");
    if(loggedUser == null){
        out.println("<p>Please login to view your orders.</p>");
    } else {
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_billing1","root","");

            // Verify role
            PreparedStatement psUser = conn.prepareStatement(
                "SELECT role FROM users WHERE username=?");
            psUser.setString(1, loggedUser);
            ResultSet rsUser = psUser.executeQuery();
            if(rsUser.next() && "customer".equals(rsUser.getString("role"))){

                // Fetch invoices for this customer
                PreparedStatement psInvoices = conn.prepareStatement(
                    "SELECT * FROM invoices WHERE customer_name=? ORDER BY invoice_id DESC");
                psInvoices.setString(1, loggedUser);
                ResultSet rsInvoices = psInvoices.executeQuery();

                while(rsInvoices.next()){
                    int invoiceId = rsInvoices.getInt("invoice_id");
                    double total = rsInvoices.getDouble("total");
                    double payment = rsInvoices.getDouble("payment");
                    double balance = rsInvoices.getDouble("balance");
%>
<div class="card mb-3">
    <div class="card-header d-flex justify-content-between align-items-center">
        <span>Invoice ID: <%=invoiceId%> | Total: LKR <%=total%></span>
        <form action="DownloadInvoiceServlet" method="post" target="_blank">
            <input type="hidden" name="invoiceId" value="<%=invoiceId%>">
            <button class="btn btn-sm btn-primary">Download PDF</button>
        </form>
    </div>
    <div class="card-body">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Book</th>
                    <th>Qty</th>
                    <th>Price</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody>
            <%
                PreparedStatement psItems = conn.prepareStatement(
                    "SELECT * FROM invoice_items WHERE invoice_id=?");
                psItems.setInt(1, invoiceId);
                ResultSet rsItems = psItems.executeQuery();
                while(rsItems.next()){
            %>
                <tr>
                    <td><%=rsItems.getString("title")%></td>
                    <td><%=rsItems.getInt("quantity")%></td>
                    <td>LKR <%=rsItems.getDouble("price")%></td>
                    <td>LKR <%=rsItems.getDouble("subtotal")%></td>
                </tr>
            <%
                }
                rsItems.close();
            %>
            </tbody>
        </table>
    </div>
</div>
<%
                }
                rsInvoices.close();
                psInvoices.close();
            } else {
                out.println("<p>You do not have permission to view orders.</p>");
            }
            rsUser.close();
            psUser.close();
            conn.close();
        }catch(Exception e){
            out.println("<p style='color:red;'>Error: "+e.getMessage()+"</p>");
        }
    }
%>
</div>
</body>
</html>
