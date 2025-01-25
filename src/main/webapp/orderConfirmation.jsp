<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .confirmation-container {
            margin-top: 50px;
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        .confirmation-header {
            text-align: center;
            margin-bottom: 20px;
        }
        .confirmation-header h2 {
            color: #343a40;
        }
        .confirmation-details {
            margin-bottom: 20px;
        }
        .confirmation-details p {
            font-size: 1.1rem;
            color: #495057;
        }
        .btn-primary {
            background-color: #007bff;
            border: none;
            padding: 10px 20px;
            font-size: 1rem;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .footer {
            margin-top: 30px;
            text-align: center;
            color: #6c757d;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
<div class="container d-flex justify-content-center align-items-center">
    <div class="confirmation-container">
        <div class="confirmation-header">
            <h2>Order Confirmed!</h2>
            <p class="text-muted">Thank you for your purchase. Your order details are as follows:</p>
        </div>
        <div class="confirmation-details">
            <p><strong>Order ID:</strong> ${orderId}</p>
            <p><strong>Order Date:</strong> ${orderDate}</p>
            <p><strong>Status:</strong> ${status}</p>
            <p><strong>Total Amount:</strong> ${totalAmount}</p>
        </div>
        <div class="text-center">
            <a href="productBrowsing" class="btn btn-primary">Continue Shopping</a>
        </div>
    </div>
</div>
<div class="footer">
    <p>&copy; 2025 Lusty Bites. All rights reserved.</p>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
