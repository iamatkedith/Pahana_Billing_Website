<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../navbar.jsp" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Books Management | Admin</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
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
            } .
            btn-edit:hover 
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

            <!-- Header + Add Book Button -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Books Inventory</h2>
                <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addBookModal">
                    <i class="fas fa-plus"></i> Add Book
                </button>
            </div>

            <!-- Books Table -->
            <div class="table-wrapper">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th>ID</th><th>ISBN</th><th>Title</th><th>Author</th><th>Publisher</th>
                            <th>Year</th><th>Edition</th><th>Price</th><th>Discount</th><th>Stock</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_billing", "root", "");
                                PreparedStatement ps = con.prepareStatement("SELECT * FROM books");
                                ResultSet rs = ps.executeQuery();
                                while (rs.next()) {
                        %>
                        <tr>
                            <td><%= rs.getInt("id")%></td>
                            <td><%= rs.getString("isbn")%></td>
                            <td><%= rs.getString("title")%></td>
                            <td><%= rs.getString("author")%></td>
                            <td><%= rs.getString("publisher")%></td>
                            <td><%= rs.getInt("year")%></td>
                            <td><%= rs.getString("edition")%></td>
                            <td>$<%= rs.getDouble("price")%></td>
                            <td><%= rs.getDouble("discount")%>%</td>
                            <td><%= rs.getInt("stock")%></td>
                            <td>
                                <button class="btn-icon btn-edit"
                                        onclick="openEditModal('<%=rs.getInt("id")%>', '<%=rs.getString("isbn")%>', '<%=rs.getString("title")%>', '<%=rs.getString("author")%>', '<%=rs.getString("publisher")%>', '<%=rs.getInt("year")%>', '<%=rs.getString("edition")%>', '<%=rs.getInt("stock")%>', '<%=rs.getDouble("price")%>', '<%=rs.getDouble("discount")%>')">
                                    <i class="fas fa-edit"></i>
                                </button>
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
                                out.println("<tr><td colspan='11' class='text-danger'>Error fetching books!</td></tr>");
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <!-- Add Book Modal -->
            <div class="modal fade" id="addBookModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <form action="<%=request.getContextPath()%>/AddBookServlet" method="post">
                            <div class="modal-header">
                                <h5 class="modal-title">Add New Book</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="row g-3">
                                    <div class="col-md-6"><label class="form-label">ISBN</label><input type="text" name="isbn" class="form-control" required></div>
                                    <div class="col-md-6"><label class="form-label">Title</label><input type="text" name="title" class="form-control" required></div>
                                    <div class="col-md-6"><label class="form-label">Author</label><input type="text" name="author" class="form-control" required></div>
                                    <div class="col-md-6"><label class="form-label">Publisher</label><input type="text" name="publisher" class="form-control"></div>
                                    <div class="col-md-4"><label class="form-label">Year</label><input type="number" name="year" class="form-control" min="1900" max="2100"></div>
                                    <div class="col-md-4"><label class="form-label">Edition</label><input type="text" name="edition" class="form-control"></div>
                                    <div class="col-md-4"><label class="form-label">Stock</label><input type="number" name="stock" class="form-control" min="0" required></div>
                                    <div class="col-md-6"><label class="form-label">Price</label><input type="number" step="0.01" name="price" class="form-control" required></div>
                                    <div class="col-md-6"><label class="form-label">Discount (%)</label><input type="number" step="0.01" name="discount" class="form-control" value="0"></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary">Add Book</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Edit Book Modal -->
            <div class="modal fade" id="editBookModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <form action="<%=request.getContextPath()%>/admin/UpdateBookServlet" method="post">
                            <div class="modal-header">
                                <h5 class="modal-title">Edit Book</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" name="id" id="editBookId">
                                <div class="row g-3">
                                    <div class="col-md-6"><label class="form-label">ISBN</label><input type="text" name="isbn" id="editIsbn" class="form-control" required></div>
                                    <div class="col-md-6"><label class="form-label">Title</label><input type="text" name="title" id="editTitle" class="form-control" required></div>
                                    <div class="col-md-6"><label class="form-label">Author</label><input type="text" name="author" id="editAuthor" class="form-control" required></div>
                                    <div class="col-md-6"><label class="form-label">Publisher</label><input type="text" name="publisher" id="editPublisher" class="form-control"></div>
                                    <div class="col-md-4"><label class="form-label">Year</label><input type="number" name="year" id="editYear" class="form-control" min="1900" max="2100"></div>
                                    <div class="col-md-4"><label class="form-label">Edition</label><input type="text" name="edition" id="editEdition" class="form-control"></div>
                                    <div class="col-md-4"><label class="form-label">Stock</label><input type="number" name="stock" id="editStock" class="form-control" min="0" required></div>
                                    <div class="col-md-6"><label class="form-label">Price</label><input type="number" step="0.01" name="price" id="editPrice" class="form-control" required></div>
                                    <div class="col-md-6"><label class="form-label">Discount (%)</label><input type="number" step="0.01" name="discount" id="editDiscount" class="form-control"></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary">Update Book</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

        </div>

        <script>
            function confirmDelete(bookId) {
                if (confirm("Are you sure you want to delete this book?")) {
                    window.location.href = "<%=request.getContextPath()%>/admin/DeleteBookServlet?id=" + bookId;
                }
            }

            function openEditModal(id, isbn, title, author, publisher, year, edition, stock, price, discount) {
                document.getElementById('editBookId').value = id;
                document.getElementById('editIsbn').value = isbn;
                document.getElementById('editTitle').value = title;
                document.getElementById('editAuthor').value = author;
                document.getElementById('editPublisher').value = publisher;
                document.getElementById('editYear').value = year;
                document.getElementById('editEdition').value = edition;
                document.getElementById('editStock').value = stock;
                document.getElementById('editPrice').value = price;
                document.getElementById('editDiscount').value = discount;

                var editModal = new bootstrap.Modal(document.getElementById('editBookModal'));
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

        <!-- Bootstrap JS Bundle -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
