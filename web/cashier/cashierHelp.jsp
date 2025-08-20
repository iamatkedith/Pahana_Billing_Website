<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cashier Help | Books POS</title>
    <style>
        * { box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { background: #f5f6fa; margin: 0; padding: 0; }
        .help-wrapper { max-width: 1000px; margin: auto; padding: 40px; }
        h1 { text-align: center; margin-bottom: 20px; color: #0F52BA; }
        p.subtitle { text-align: center; font-size: 18px; color: #555; margin-bottom: 50px; }

        .help-cards { display: flex; flex-wrap: wrap; gap: 20px; justify-content: space-around; }
        .help-card {
            background: #fff;
            flex: 1 1 450px;
            padding: 30px 20px;
            border-radius: 12px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .help-card:hover { transform: translateY(-5px); box-shadow: 0 15px 25px rgba(0,0,0,0.2); }

        .help-card h3 { color: #4682B4; margin-top: 0; }
        .help-card p { color: #333; line-height: 1.6; }

        ul.steps {
            margin: 10px 0 0 0;
            padding-left: 20px;
        }
        ul.steps li {
            margin-bottom: 8px;
        }

        .section-title {
            font-size: 24px;
            margin-top: 50px;
            color: #0F52BA;
            border-bottom: 2px solid #4682B4;
            padding-bottom: 5px;
            display: inline-block;
        }

        .faq-item {
            margin: 20px 0;
            background: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .faq-item h4 { margin: 0 0 10px 0; color: #4682B4; }
        .faq-item p { margin: 0; color: #333; }
    </style>
</head>
<body>
<div class="help-wrapper">
    <h1>Cashier Help</h1>
    <p class="subtitle">Learn how to efficiently use the Books POS system to manage sales and inventory.</p>

    <div class="help-cards">
        <div class="help-card">
            <h3>Processing Sales</h3>
            <p>To create a new sale:</p>
            <ul class="steps">
                <li>Select the customer from the dropdown or add a new customer.</li>
                <li>Add books to the cart by searching by title or ISBN.</li>
                <li>Adjust quantities and apply discounts if needed.</li>
                <li>Choose payment type (Cash or Card) and click "Complete Sale".</li>
            </ul>
        </div>

        <div class="help-card">
            <h3>Managing Inventory</h3>
            <p>Keep track of your stock to avoid running out of popular books:</p>
            <ul class="steps">
                <li>Go to the Stock Details section in the Reports tab.</li>
                <li>Check low-stock items highlighted in red.</li>
                <li>Update quantities when new stock arrives.</li>
            </ul>
        </div>

        <div class="help-card">
            <h3>Viewing Reports</h3>
            <p>Use the Reports Dashboard to monitor sales and performance:</p>
            <ul class="steps">
                <li>Customer Purchase History: See what each customer has bought.</li>
                <li>Stock Details: Track inventory levels and sold quantities.</li>
                <li>Sales Reports: Filter by month and payment type to analyze revenue.</li>
            </ul>
        </div>

        <div class="help-card">
            <h3>Tips & Tricks</h3>
            <ul class="steps">
                <li>Always check low-stock warnings to prevent stockouts.</li>
                <li>Use CSV download for offline analysis or backups.</li>
                <li>Keep the POS refreshed to get the latest data on sales and inventory.</li>
                <li>Hover over dashboard info boxes for quick insights.</li>
            </ul>
        </div>
    </div>

    <div class="section-title">Frequently Asked Questions (FAQ)</div>

    <div class="faq-item">
        <h4>Q1: How do I add a new customer?</h4>
        <p>A: In the sales panel, type the customer name in the search box. If it doesn't exist, click "Add New Customer" and fill the details.</p>
    </div>
    <div class="faq-item">
        <h4>Q2: How do I know which books are low in stock?</h4>
        <p>A: Low-stock items are highlighted in red in the Stock Details section of the Reports tab.</p>
    </div>
    <div class="faq-item">
        <h4>Q3: Can I filter sales by payment type or month?</h4>
        <p>A: Yes. In the Sales Reports panel, select the payment type and/or month to filter the data.</p>
    </div>
    <div class="faq-item">
        <h4>Q4: How can I download reports?</h4>
        <p>A: Each report table has a "Download CSV" button above it. Click it to export the data.</p>
    </div>
    <div class="faq-item">
        <h4>Q5: Who do I contact for support?</h4>
        <p>A: Contact your system administrator or call support at <strong>+94 123 456 789</strong>.</p>
    </div>
</div>
</body>
</html>
