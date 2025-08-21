<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../navbar.jsp" %>
<html>
<head>
    <title>Customer Help | Pahana Edu Book Store</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f0f2f5; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }

        /* Container */
        .pahana-help-container {
            max-width: 900px;
            margin: 70px auto;
            padding: 2px;
        }

        /* Header */
        .pahana-help-header {
            text-align: center;
            margin-bottom: 60px;
        }
        .pahana-help-header h1 {
            font-weight: 700;
            color: #343a40;
        }
        .pahana-help-header p {
            font-size: 1.2rem;
            color: #6c757d;
        }

        /* Sections */
        .pahana-help-section {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 30px;
            margin-bottom: 40px;
        }

        .pahana-help-section h4 {
            font-weight: 700;
            color: #343a40;
            margin-bottom: 25px;
        }

        /* User Guide */
        .pahana-user-guide p {
            font-size: 1rem;
            line-height: 1.7;
            color: #495057;
            margin-bottom: 15px;
        }

        /* FAQ Accordion */
        .pahana-faq .pahana-faq-card {
            border-radius: 12px;
            margin-bottom: 15px;
            overflow: hidden;
        }

        .pahana-faq .pahana-faq-header {
            background-color: #343a40;
            color: #fff;
            font-weight: 600;
            cursor: pointer;
        }

        .pahana-faq .pahana-faq-body {
            background-color: #fff;
            color: #495057;
        }

        .pahana-faq-icon {
            margin-right: 10px;
            color: #ffc107;
        }
    </style>
</head>
<body>

<div class="pahana-help-container">

    <!-- Header -->
    <div class="pahana-help-header">
        <h1>Customer Help Center</h1>
        <p>Everything you need to know to use our Book Store effectively</p>
    </div>

    <!-- User Guide Section -->
    <div class="pahana-help-section pahana-user-guide">
        <h4>User Guide</h4>
        <p><strong>1. Placing an Order:</strong> Browse available books, add items to your cart, and click "Purchase". Ensure your name and phone are correct.</p>
        <p><strong>2. Viewing Orders:</strong> Go to "My Orders" to see past purchases. You can download invoices in PDF format.</p>
        <p><strong>3. Payment:</strong> Currently, only Cash payments are supported. Payment info is updated automatically.</p>
        <p><strong>4. Stock Availability:</strong> Orders cannot exceed the available stock. The system updates stock automatically after each purchase.</p>
    </div>

    <!-- FAQ Section -->
    <div class="pahana-help-section pahana-faq">
        <h4>Frequently Asked Questions</h4>
        <div class="accordion" id="pahanaFaqAccordion">

            <div class="pahana-faq-card">
                <div class="accordion-header pahana-faq-header" id="faq1" data-bs-toggle="collapse" data-bs-target="#collapse1" aria-expanded="true" aria-controls="collapse1">
                    <i class="fas fa-question-circle pahana-faq-icon"></i> How do I place an order?
                </div>
                <div id="collapse1" class="accordion-collapse collapse show" aria-labelledby="faq1" data-bs-parent="#pahanaFaqAccordion">
                    <div class="accordion-body pahana-faq-body">
                        Browse the books, add to cart, and click "Purchase". Make sure customer info is entered correctly.
                    </div>
                </div>
            </div>

            <div class="pahana-faq-card">
                <div class="accordion-header pahana-faq-header" id="faq2" data-bs-toggle="collapse" data-bs-target="#collapse2" aria-expanded="false" aria-controls="collapse2">
                    <i class="fas fa-question-circle pahana-faq-icon"></i> How can I download my invoice?
                </div>
                <div id="collapse2" class="accordion-collapse collapse" aria-labelledby="faq2" data-bs-parent="#pahanaFaqAccordion">
                    <div class="accordion-body pahana-faq-body">
                        Go to "My Orders" page and click "Download Invoice" next to the order.
                    </div>
                </div>
            </div>

            <div class="pahana-faq-card">
                <div class="accordion-header pahana-faq-header" id="faq3" data-bs-toggle="collapse" data-bs-target="#collapse3" aria-expanded="false" aria-controls="collapse3">
                    <i class="fas fa-question-circle pahana-faq-icon"></i> What payment methods are available?
                </div>
                <div id="collapse3" class="accordion-collapse collapse" aria-labelledby="faq3" data-bs-parent="#pahanaFaqAccordion">
                    <div class="accordion-body pahana-faq-body">
                        Currently, only Cash payments are supported. Online payments will be added later.
                    </div>
                </div>
            </div>

            <div class="pahana-faq-card">
                <div class="accordion-header pahana-faq-header" id="faq4" data-bs-toggle="collapse" data-bs-target="#collapse4" aria-expanded="false" aria-controls="collapse4">
                    <i class="fas fa-question-circle pahana-faq-icon"></i> What if a book is out of stock?
                </div>
                <div id="collapse4" class="accordion-collapse collapse" aria-labelledby="faq4" data-bs-parent="#pahanaFaqAccordion">
                    <div class="accordion-body pahana-faq-body">
                        You cannot add more than the available stock. Out-of-stock books are disabled in the store page.
                    </div>
                </div>
            </div>

        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
