<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../navbar.jsp" %>
<html>
<head>
    <title>My Orders | Pahana Edu</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        body { 
            background-color: #f8f9fa; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
        }

        /* Container */
        .orders-page-container {
            max-width: 1000px;
            margin: 60px auto;
            padding: 20px;
        }

        /* Page Header */
        .orders-page-header {
            text-align: center;
            margin-bottom: 50px;
        }
        .orders-page-header h3 {
            font-weight: 700;
            color: #343a40;
        }
        .orders-page-header p {
            color: #6c757d;
            font-size: 1.1rem;
        }

        /* Invoice Card */
        .orders-invoice-card {
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            margin-bottom: 40px;
            overflow: hidden;
        }

        .orders-invoice-header {
            background-color: #007bff;
            color: #fff;
            font-weight: 600;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 25px;
            font-size: 1rem;
        }

        .orders-invoice-body {
            padding: 20px 25px;
        }

        .orders-invoice-table th {
            background-color: #343a40;
            color: #fff;
            text-align: center;
        }

        .orders-invoice-table td {
            text-align: center;
        }

        .orders-download-btn {
            background-color: #ffc107;
            border-color: #ffc107;
            color: #343a40;
            font-weight: 600;
        }
        .orders-download-btn:hover {
            background-color: #e0a800;
            border-color: #d39e00;
        }

        /* Responsive spacing */
        @media (max-width: 576px) {
            .orders-invoice-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
<div class="orders-page-container">
    <!-- Header -->
    <div class="orders-page-header">
        <h3>My Purchase History</h3>
        <p>Here are all your past orders. Download invoices in PDF format for your records.</p>
    </div>

<%
    String loggedUser = (String) session.getAttribute("username");
    if(loggedUser == null){
        out.println("<p>Please login to view your orders.</p>");
    } else {
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_billing1","root","");

            PreparedStatement psUser = conn.prepareStatement(
                "SELECT role FROM users WHERE username=?");
            psUser.setString(1, loggedUser);
            ResultSet rsUser = psUser.executeQuery();
            if(rsUser.next() && "customer".equals(rsUser.getString("role"))){

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
    <div class="orders-invoice-card">
        <div class="orders-invoice-header">
            <span>Invoice ID: <%=invoiceId%> | Total: LKR <%=total%></span>
            <form action="DownloadInvoiceServlet" method="post" target="_blank">
                <input type="hidden" name="invoiceId" value="<%=invoiceId%>">
                <button class="btn btn-sm orders-download-btn">Download PDF</button>
            </form>
        </div>
        <div class="orders-invoice-body">
            <table class="table table-bordered orders-invoice-table mb-0">
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
