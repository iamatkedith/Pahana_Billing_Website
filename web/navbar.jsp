<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pahana Edu | Navbar</title>
    <!-- Font Awesome CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        /* Navbar container */
        .navbar {
            background: #ffffff;
            padding: 0.75rem 2rem;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
            font-family: 'Segoe UI', sans-serif;
        }

        /* Flex container */
        .container {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        /* Brand */
        .brand {
            font-size: 1.4rem;
            font-weight: bold;
            color: #0077cc;
            text-decoration: none;
            transition: 0.3s ease;
        }
        .brand:hover {
            color: #005fa3;
        }

        /* Navbar links */
        .nav-links {
            list-style: none;
            display: flex;
            gap: 1.2rem;
            margin: 0;
            padding: 0;
        }
        .nav-links li {
            display: inline;
        }
        .nav-links a {
            text-decoration: none;
            color: #444;
            font-weight: 500;
            padding: 0.5rem 0.8rem;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }
        .nav-links a:hover {
            background: rgba(0, 119, 204, 0.1);
            color: #0077cc;
        }
        .nav-links a.active {
            color: #0077cc;
            font-weight: 600;
        }

        /* Right side */
        .right-side {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .welcome {
            color: #666;
            font-size: 0.95rem;
        }
        .logout-btn {
            background: #0077cc;
            color: white;
            text-decoration: none;
            padding: 0.45rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            transition: 0.3s ease;
        }
        .logout-btn:hover {
            background: #005fa3;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="container">
            <!-- Brand -->
            <a class="brand" href="home.jsp"><i class="fas fa-book-open"></i> Pahana Edu</a>

            <!-- Links -->
            <ul class="nav-links">
                <li><a href="home.jsp" class="active"><i class="fas fa-home"></i> Home</a></li>

                <!-- Admin menu -->
                <c:if test="${sessionScope.role == 'admin'}">
                    <li><a href="manageUsers.jsp"><i class="fas fa-users-cog"></i> Manage Users</a></li>
                    <li><a href="reports.jsp"><i class="fas fa-chart-line"></i> Reports</a></li>
                </c:if>

                <!-- Cashier menu -->
                <c:if test="${sessionScope.role == 'cashier'}">
                    <li><a href="sales.jsp"><i class="fas fa-cash-register"></i> Sales</a></li>
                    <li><a href="transactions.jsp"><i class="fas fa-file-invoice-dollar"></i> Transactions</a></li>
                </c:if>

                <!-- Customer menu -->
                <c:if test="${sessionScope.role == 'customer'}">
                    <li><a href="shop.jsp"><i class="fas fa-shopping-cart"></i> Shop Books</a></li>
                    <li><a href="myOrders.jsp"><i class="fas fa-box"></i> My Orders</a></li>
                </c:if>
            </ul>

            <!-- Right Side -->
            <div class="right-side">
                <c:if test="${not empty sessionScope.username}">
                    <span class="welcome">Welcome, <strong>${sessionScope.username}</strong></span>
                    <a href="logout.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </c:if>
            </div>
        </div>
    </nav>
</body>
</html>
