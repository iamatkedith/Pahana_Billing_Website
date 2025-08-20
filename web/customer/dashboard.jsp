<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: 'Roboto', sans-serif;
            background: #f2f7fa;
        }

        .customer-dashboard-container {
            width: 100%;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            padding: 40px 20px 50px 20px; 
            box-sizing: border-box;
        }

        .welcome-section {
            text-align: center;
            margin-bottom: 50px;
            animation: fadeIn 1.5s ease forwards;
        }

        .welcome-section h1 {
            font-size: 36px;
            color: #2c3e50;
            margin-bottom: 15px;
        }

        .welcome-section p {
            font-size: 18px;
            color: #34495e;
            line-height: 1.6;
            max-width: 700px;
            margin: 0 auto;
        }

        /* Feedback Form Styles */
        .customer-feedback-form-container {
            background: #fff;
            border-radius: 12px;
            padding: 30px;
            max-width: 500px;
            width: 100%;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            animation: slideUp 1s ease forwards;
        }

        .customer-feedback-form-container h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #2c3e50;
        }

        .customer-feedback-form-container form {
            display: flex;
            flex-direction: column;
        }

        .customer-feedback-form-container label {
            margin-bottom: 5px;
            font-weight: 500;
            color: #34495e;
        }

        .customer-feedback-form-container input,
        .customer-feedback-form-container textarea {
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
            resize: vertical;
        }

        .customer-feedback-form-container button {
            background: #3498db;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .customer-feedback-form-container button:hover {
            background: #2980b9;
        }

        /* Animations */
        @keyframes fadeIn {
            0% {opacity: 0; transform: translateY(-20px);}
            100% {opacity: 1; transform: translateY(0);}
        }

        @keyframes slideUp {
            0% {opacity: 0; transform: translateY(50px);}
            100% {opacity: 1; transform: translateY(0);}
        }

    </style>
</head>
<body>
    <div class="customer-dashboard-container">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <h1>Welcome to Pahan Edu!</h1>
            <p>Discover a world of books at Pahan Edu. Browse our latest collections, keep track of your purchases, and share your thoughts with us through feedback. Happy reading!</p>
        </div>

        <!-- Feedback Form -->
        <div class="customer-feedback-form-container">
    <h2>Send us your Feedback</h2>
    <form id="customerFeedbackForm" action="<%= request.getContextPath()%>/customer/FeedbackServlet" method="post">
        <label for="customerName">Name</label>
        <input type="text" name="name" id="customerName" required>

        <label for="customerEmail">Email</label>
        <input type="email" name="email" id="customerEmail" required>

        <label for="customerMessage">Message</label>
        <textarea name="message" id="customerMessage" rows="5" required></textarea>

        <button type="submit">Submit Feedback</button>
    </form>
    <div id="feedbackSuccessAlert" style="display:none; text-align:center; margin-top:10px; color:green; font-weight:bold;">
        Thank you for your feedback!
    </div>
</div>

<script>
    // Show success message after form submission without page reload
    document.getElementById("customerFeedbackForm").addEventListener("submit", function(e) {
        e.preventDefault(); 
        let form = this;

        fetch(form.action, {
            method: "POST",
            body: new FormData(form)
        }).then(res => res.text())
        .then(data => {
            document.getElementById("feedbackSuccessAlert").style.display = "block";
            // animate
            document.getElementById("feedbackSuccessAlert").style.opacity = 0;
            let opacity = 0;
            let interval = setInterval(() => {
                if (opacity >= 1) clearInterval(interval);
                document.getElementById("feedbackSuccessAlert").style.opacity = opacity;
                opacity += 0.05;
            }, 30);
            // clear form
            form.reset();
        })
        .catch(err => alert("Error submitting feedback!"));
    });
</script>
</body>
</html>
