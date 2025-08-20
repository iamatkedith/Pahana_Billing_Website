<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pahana Edu | Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Roboto', sans-serif;
            background: #f0f4f8;
        }

        .container-fluid {
            height: 100%;
            display: flex;
        }

        /* Left side - login form */
        .login-side {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            background: #ffffff;
            box-shadow: 2px 0 8px rgba(0,0,0,0.08);
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.97);
            border-radius: 1rem;
            padding: 2.5rem;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
        }

        h2 {
            font-weight: 700;
            margin-bottom: 2rem;
            color: #333;
            text-align: center;
        }

        .form-control {
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
            margin-bottom: 1rem;
            border: 1px solid #ccc;
        }

        .btn-login {
            background-color: #6c63ff; 
            color: #fff;
            font-weight: 500;
            border-radius: 0.5rem;
            padding: 0.75rem;
            border: none;
            width: 100%;
            transition: background 0.3s;
        }

        .btn-login:hover {
            background-color: #5751d9;
        }

        .alert {
            background: #ffe6e6; 
            color: #d9534f;
            text-align: center;
            border-radius: 0.5rem;
            padding: 0.5rem 1rem;
            margin-bottom: 1rem;
            transition: opacity 0.5s ease;
        }

        
        .info-side {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #ffd194, #6a85b6);
            color: #333;
            padding: 2rem;
        }

        .info-side h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .info-side p {
            font-size: 1.2rem;
            line-height: 1.5;
        }

        @media (max-width: 768px) {
            .container-fluid {
                flex-direction: column;
            }
            .info-side, .login-side {
                flex: unset;
                width: 100%;
                height: 50%;
            }
            .info-side h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <!-- Left side: Login form -->
        <div class="login-side">
            <div class="glass-card">
                <h2>Login</h2>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" id="error-msg">${error}</div>
                </c:if>
                <form method="post" action="login">
                    <input type="text" class="form-control" id="username" name="username" placeholder="Username" required maxlength="50">
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required maxlength="100">
                    <button type="submit" class="btn btn-login fw-bold">Login</button>
                </form>
            </div>
        </div>

        <!-- Right side -->
        <div class="info-side">
            <div>
                <h1>Welcome to Pahana Edu Bookshop</h1>
                <p>Explore our wide collection of books. Manage your account, track orders, and enjoy a seamless bookstore experience. Login to continue your reading journey.</p>
            </div>
        </div>
    </div>

    <!-- JS to hide error after 4 seconds -->
    <script>
        window.onload = function() {
            const errorDiv = document.getElementById('error-msg');
            if (errorDiv) {
                setTimeout(() => {
                    errorDiv.style.opacity = '0';
                    setTimeout(() => errorDiv.remove(), 500);
                }, 4000);
            }
        };
    </script>
</body>
</html>
