<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../navbar.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cashier Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f8f9fa;
            font-family: Arial, sans-serif;
        }
        .dashboard-title {
            font-weight: 600;
            color: #2c3e50;
            text-align: center;
        }
        .quick-action-btn {
            font-size: 18px;
            font-weight: 500;
            border-radius: 12px;
            transition: transform 0.2s;
            padding: 30px;
        }
        .quick-action-btn:hover {
            transform: scale(1.05);
        }
        .card-header {
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="container mt-4">
    <h2 class="dashboard-title mb-4">Cashier Dashboard</h2>

    <!-- Quick Actions -->
    <div class="row mb-4 g-3 text-center">
        <div class="col-md-3">
            <a href="billing.jsp" class="btn btn-primary quick-action-btn w-100">🧾 Generate Bill</a>
        </div>
        <div class="col-md-3">
            <a href="books.jsp" class="btn btn-success quick-action-btn w-100">📚 Book Management</a>
        </div>
        <div class="col-md-3">
            <a href="reports.jsp" class="btn btn-warning quick-action-btn w-100">👤 Customer Reports</a>
        </div>
        <div class="col-md-3">
            <a href="stock.jsp" class="btn btn-info quick-action-btn w-100">📦 Stock Details</a>
        </div>
    </div>

    <!-- Today’s Overview -->
    <div class="row g-4">
        <!-- Latest Bills -->
        <div class="col-md-6">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-dark text-white">Latest Bills</div>
                <div class="card-body p-0">
                    <table class="table table-striped mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Bill ID</th>
                                <th>Customer</th>
                                <th>Total</th>
                                <th>Time</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="bill" items="${latestBills}">
                                <tr>
                                    <td>${bill.id}</td>
                                    <td>${bill.customer}</td>
                                    <td>${bill.total}</td>
                                    <td>${bill.time}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty latestBills}">
                                <tr>
                                    <td colspan="4" class="text-center text-muted">No bills found</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Top Selling Books -->
        <div class="col-md-6">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-dark text-white">Top Selling Books Today</div>
                <div class="card-body p-0">
                    <table class="table table-striped mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Book</th>
                                <th>Sold</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="book" items="${topBooks}">
                                <tr>
                                    <td>${book.name}</td>
                                    <td>${book.sold}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty topBooks}">
                                <tr>
                                    <td colspan="2" class="text-center text-muted">No sales yet</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
