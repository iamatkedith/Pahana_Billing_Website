<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../navbar.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Pahana Bookshop</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f4f6f9;
            margin: 0;
        }
        .dashboard-container {
            padding: 2rem;
        }
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
        }
        .card {
            background: white;
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transition: 0.3s;
            text-align: center;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }
        .card i {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            color: #0d6efd;
        }
        .card h3 {
            margin: 0.5rem 0;
            font-size: 1.2rem;
        }
        .card a {
            text-decoration: none;
            color: #0d6efd;
            font-weight: 500;
            display: block;
            margin-top: 0.5rem;
        }
        .card a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <h1>Welcome!</h1>
        <div class="cards">
            <div class="card">
                <i class="fa-solid fa-book"></i>
                <h3>Books</h3>
                <a href="books.jsp">Manage Books</a>
            </div>
            <div class="card">
                <i class="fa-solid fa-users"></i>
                <h3>Customers</h3>
                <a href="customers.jsp">Manage Customers</a>
            </div>
            <div class="card">
                <i class="fa-solid fa-user-tie"></i>
                <h3>Cashiers</h3>
                <a href="cashiers.jsp">Manage Cashiers</a>
            </div>
            <div class="card">
                <i class="fa-solid fa-chart-line"></i>
                <h3>Reports</h3>
                <a href="reports.jsp">View Reports</a>
            </div>
            <div class="card">
                <i class="fa-solid fa-gear"></i>
                <h3>Settings</h3>
                <a href="settings.jsp">System Settings</a>
            </div>
        </div>
    </div>
</body>
</html>
