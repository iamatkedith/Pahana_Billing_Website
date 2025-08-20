<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Available Books</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Roboto', sans-serif; background: #f2f7fa; margin:0; }
        .books-container { display: flex; flex-wrap: wrap; justify-content: center; padding: 40px 20px; gap: 20px; }
        .book-card { background: #fff; border-radius:12px; padding:20px; width:250px; box-shadow:0 8px 20px rgba(0,0,0,0.1); text-align:center; }
        .book-card button { margin-top:10px; padding:8px 16px; border:none; border-radius:6px; cursor:pointer; background-color:#3498db; color:#fff; }
        .book-card button:hover:not(:disabled) { background-color:#2980b9; }
        .book-card button:disabled { background-color:#ccc; cursor:not-allowed; }
    </style>
</head>
<body>
    <h1 style="text-align:center; margin-top:30px;">Available Books</h1>
    <div class="books-container">
        <c:forEach var="book" items="${books}">
            <div class="book-card">
                <h3>${book.title}</h3>
                <p><strong>Author:</strong> ${book.author}</p>
                <p><strong>Publisher:</strong> ${book.publisher}</p>
                <p><strong>Year:</strong> ${book.year}</p>
                <p><strong>Edition:</strong> ${book.edition}</p>
                <p><strong>Price:</strong> LKR${book.price}</p>
                <p><strong>Discount:</strong> ${book.discount}%</p>
                <p><strong>Stock:</strong> ${book.stock}</p>
                <c:choose>
                    <c:when test="${book.stock == 0}">
                        <button disabled>Unavailable</button>
                    </c:when>
                    <c:otherwise>
                        <button onclick="purchaseBook(${book.id}, '${book.title}', ${book.price}, ${book.stock})">Purchase</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:forEach>
    </div>

    <script>
        function purchaseBook(id, title, price, stock) {
            if(stock <= 0) { alert("This book is out of stock!"); return; }
            alert(`Purchasing "${title}" for ${price}. Available stock: ${stock}`);
        }
    </script>
</body>
</html>
