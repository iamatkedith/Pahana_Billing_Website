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
            /* Logout Modal Overlay */
            .logout-modal-overlay {
                display: none;
                position: fixed;
                z-index: 999;
                left: 0; top: 0;
                width: 100vw;
                height: 100vh;
                background-color: rgba(0, 0, 0, 0.4);
                justify-content: center;
                align-items: center;
                animation: fadeIn 0.3s ease-in-out;
            }

            /* Modal Box */
            .logout-modal-content {
                background-color: #fff;
                padding: 30px 35px;
                border-radius: 12px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
                text-align: center;
                width: 400px;
                animation: slideUp 0.3s ease-in-out;
            }

            /* Heading and Message */
            .logout-modal-content h2 {
                margin-top: 0;
                font-size: 24px;
                color: #333;
            }

            .logout-modal-content p {
                margin: 15px 0 25px;
                color: #555;
            }

            /* Buttons */
            .logout-buttons {
                display: flex;
                justify-content: center;
                gap: 15px;
            }

            .logout-confirm {
                background-color: #d9534f;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: bold;
                transition: background 0.3s;
            }

            .logout-confirm:hover {
                background-color: #c9302c;
            }

            .logout-cancel {
                background-color: #6c757d;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: bold;
                transition: background 0.3s;
            }

            .logout-cancel:hover {
                background-color: #5a6268;
            }

            /* Animations */
            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }

            @keyframes slideUp {
                from { transform: translateY(20px); opacity: 0; }
                to { transform: translateY(0); opacity: 1; }
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
                        <li><a href="books.jsp"><i class="fa-solid fa-book"></i> Books</a></li>
                        <li><a href="customers.jsp"><i class="fa-solid fa-users"></i> Customers</a></li>
                        <li><a href="cashiers.jsp"><i class="fa-solid fa-user-tie"></i> Cashiers</a></li>
                        <li><a href="reports.jsp"><i class="fa-solid fa-chart-line"></i> Reports</a></li>
                        <li><a href="settings.jsp"><i class="fa-solid fa-gear"></i> Settings</a></li>
                        </c:if>

                    <!-- Cashier menu -->
                    <c:if test="${sessionScope.role == 'cashier'}">
                        <li><a href="books.jsp"><i class="fa-solid fa-book"></i> Books</a></li>
                        <li><a href="cashier/customers.jsp"><i class="fa-solid fa-user-plus"></i> Customers</a></li>
                        <li><a href="cashier/generateBill.jsp"><i class="fa-solid fa-file-invoice-dollar"></i> Generate Bill</a></li>
                        <li><a href="cashier/reports.jsp"><i class="fa-solid fa-chart-pie"></i> Reports</a></li>
                        </c:if>

                    <!-- Customer menu -->
                    <c:if test="${sessionScope.role == 'customer'}">
                        <li><a href="customer/shop.jsp"><i class="fa-solid fa-store"></i> Shop Books</a></li>
                        <li><a href="customer/orders.jsp"><i class="fa-solid fa-bag-shopping"></i> My Orders</a></li>
                        <li><a href="customer/downloadReports.jsp"><i class="fa-solid fa-download"></i> Reports</a></li>
                        <li><a href="customer/help.jsp"><i class="fa-solid fa-circle-question"></i> Help</a></li>
                        </c:if>
                </ul>

                <!-- Right Side -->
                <div class="right-side">
                    <c:if test="${not empty sessionScope.username}">
                        <span class="welcome">Welcome, <strong>${sessionScope.username}</strong></span>
                        <a href="#" class="logout-btn" onclick="showLogoutModal()"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </c:if>
                </div>

            </div>
        </nav>
        <!-- Logout Confirmation Modal -->
        <div id="logoutModal" class="logout-modal-overlay">
            <div class="logout-modal-content">
                <h2>Confirm Logout</h2>
                <p>Are you sure you want to log out?</p>
                <div class="logout-buttons">
                    <button onclick="confirmLogout()" class="logout-confirm">Yes, Logout</button>
                    <button onclick="closeLogoutModal()" class="logout-cancel">Cancel</button>
                </div>
            </div>
        </div>


        <script>
            function showLogoutModal() {
                document.getElementById("logoutModal").style.display = "flex";
            }

            function closeLogoutModal() {
                document.getElementById("logoutModal").style.display = "none";
            }

            function confirmLogout() {
                // Ensure we include the context path
                var contextPath = '<%= request.getContextPath() %>';
                window.location.href = contextPath + "/login.jsp?logout=1";
            }
        </script>
    </body>
</html>
