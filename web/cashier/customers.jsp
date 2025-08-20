<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../navbar.jsp" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Customer Management | Admin</title>
        <!-- Bootstrap & FontAwesome CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            body { 
                font-family: 'Segoe UI', sans-serif; 
                background: #f5f7fa; 
                margin: 0; 
            }
            .container-main { 
                max-width: 1400px; 
                margin: 2rem auto; 
                padding: 1rem; 
            }
            h2 { 
                color: #0d6efd; 
                font-weight: 700; 
            }
            .btn-add { 
                background: linear-gradient(90deg, #0d6efd, #6610f2); 
                color: #fff; 
                font-weight: 600; 
                border-radius: 8px; 
                box-shadow: 0 4px 12px rgba(0,0,0,0.15); 
                transition: 0.3s; 
            }
            .btn-add:hover { 
                background: linear-gradient(90deg, #6610f2, #0d6efd); 
                color: #fff;
            }
            .table-wrapper {
                background: #fff; 
                padding: 1.5rem; 
                border-radius: 12px; 
                box-shadow: 0 6px 20px rgba(0,0,0,0.08); 
                overflow-x: auto; 
            }
            table { 
                width: 100%; 
                border-collapse: separate; 
                border-spacing: 0 0.5rem; 
            }
            table th {
                background: #6610f2; 
                color: #fff; 
                font-weight: 600; 
                border: none; 
                padding: 0.8rem; 
                text-align: center; 
            }
            table td { 
                background: #f8f9fa; 
                border: none; 
                padding: 0.7rem; 
                text-align: center; 
                vertical-align: middle; 
            }
            table tr:hover td { 
                background: #e2e6ff; 
            }
            .btn-icon { 
                font-size: 1.1rem; 
                margin: 0 0.2rem; 
                transition: 0.2s; 
            }
            .btn-edit {
                color: #198754; 
            } 
            .btn-edit:hover 
            {
                color: #157347;
            }
            .btn-delete { 
                color: #dc3545; 
            } 
            .btn-delete:hover { 
                color: #b02a37; 
            }
            .modal-header { 
                background: #6610f2; 
                color: #fff; 
                font-weight: 600; 
            }
            .modal-body .form-label { 
                font-weight: 500; 
            }
            .modal-footer .btn-primary {
                background: #0d6efd; 
                border: none; 
            }
            .modal-footer .btn-primary:hover { 
                background: #6610f2; 
            }
        </style>
    </head>
    <body>
        
        <div class="container-main">
            
            <!-- Success / Error Messages -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert" id="alert-success">
                    ${param.success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert" id="alert-error">
                    ${param.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Header + Add Button -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Customers</h2>
                <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                    <i class="fas fa-plus"></i> Add Customer
                </button>
            </div>

            <!-- Customers Table -->
            <div class="table-wrapper">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_billing", "root", "");
                                PreparedStatement ps = con.prepareStatement("SELECT * FROM customers");
                                ResultSet rs = ps.executeQuery();
                                while (rs.next()) {
                        %>
                        <tr>
                            <td><%= rs.getInt("id")%></td>
                            <td><%= rs.getString("name")%></td>
                            <td><%= rs.getString("email")%></td>
                            <td><%= rs.getString("phone")%></td>
                            <td>
                                <a href="javascript:void(0);" class="btn-icon btn-edit" 
                                   onclick="openEditCustomerModal(
                                                   '<%=rs.getInt("id")%>',
                                                   '<%=rs.getString("name")%>',
                                                   '<%=rs.getString("email")%>',
                                                   '<%=rs.getString("phone")%>',
                                                   '<%=rs.getString("address")%>'
                                                   )">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <button class="btn-icon btn-delete" onclick="confirmDelete(<%= rs.getInt("id")%>)">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </td>
                        </tr>
                        <%
                                }
                                rs.close();
                                ps.close();
                                con.close();
                            } catch (Exception e) {
                                out.println("<tr><td colspan='5' class='text-danger'>Error fetching customers!</td></tr>");
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <!-- Add Customer Modal -->
            <div class="modal fade" id="addCustomerModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <form action="<%=request.getContextPath()%>/cashier/AddCustomerServlet" method="post">
                            <div class="modal-header">
                                <h5 class="modal-title">Add New Customer</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="row g-3">
                                    <div class="col-md-6"><label class="form-label">Name</label><input type="text" name="name" class="form-control" required></div>
                                    <div class="col-md-6"><label class="form-label">Email</label><input type="email" name="email" class="form-control" required></div>
                                    <div class="col-md-6"><label class="form-label">Phone</label><input type="text" name="phone" class="form-control"></div>
                                    <div class="col-md-6"><label class="form-label">Address</label><input type="text" name="address" class="form-control"></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary">Add Customer</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Edit Customer Modal -->
            <div class="modal fade" id="editCustomerModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <form id="editCustomerForm" action="<%=request.getContextPath()%>/cashier/UpdateCustomerServlet" method="post">
                            <input type="hidden" name="id" id="editCustomerId">
                            <div class="modal-header">
                                <h5 class="modal-title">Edit Customer</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="row g-3">
                                    <div class="col-md-6"><label class="form-label">Name</label><input type="text" name="name" id="editCustomerName" class="form-control" required></div>
                                    <div class="col-md-6"><label class="form-label">Email</label><input type="email" name="email" id="editCustomerEmail" class="form-control" required></div>
                                    <div class="col-md-6"><label class="form-label">Phone</label><input type="text" name="phone" id="editCustomerPhone" class="form-control"></div>
                                    <div class="col-md-6"><label class="form-label">Address</label><input type="text" name="address" id="editCustomerAddress" class="form-control"></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary">Update Customer</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

        </div>

        <script>
            function confirmDelete(customerId) {
                if (confirm("Are you sure you want to delete this customer?")) {
                    window.location.href = "<%=request.getContextPath()%>/cashier/DeleteCustomerServlet?id=" + customerId;
                }
            }

            function openEditCustomerModal(id, name, email, phone, address) {
                document.getElementById('editCustomerId').value = id;
                document.getElementById('editCustomerName').value = name;
                document.getElementById('editCustomerEmail').value = email;
                document.getElementById('editCustomerPhone').value = phone;
                document.getElementById('editCustomerAddress').value = address;

                var editModal = new bootstrap.Modal(document.getElementById('editCustomerModal'));
                editModal.show();
            }

            // Auto-dismiss alerts after 3 seconds
            setTimeout(function () {
                var successAlert = document.getElementById('alert-success');
                if (successAlert)
                    successAlert.style.display = 'none';
                var errorAlert = document.getElementById('alert-error');
                if (errorAlert)
                    errorAlert.style.display = 'none';
            }, 3000);
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>

</html>
