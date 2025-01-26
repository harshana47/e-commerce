<%@ page import="DTO.OrderDetailDTO" %>
<%@ page import="java.util.List" %>
<%
    // Get the list of order details from the request
    List<OrderDetailDTO> orderDetails = (List<OrderDetailDTO>) request.getAttribute("orderDetails");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Order Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h1 class="text-center">All Order Details</h1>
    <table class="table table-bordered table-striped mt-4">
        <thead>
        <tr>
            <th>Order ID</th>
            <th>User ID</th>
            <th>Product ID</th>
            <th>Quantity</th>
            <th>Price</th>
            <th>Order Date</th>
            <th>Total</th>
        </tr>
        </thead>
        <tbody>
        <% if (orderDetails != null && !orderDetails.isEmpty()) { %>
        <% for (OrderDetailDTO orderDetail : orderDetails) { %>
        <tr>
            <td><%= orderDetail.getOrderId() %></td>
            <td><%= orderDetail.getUserId() %></td>
            <td><%= orderDetail.getProductId() %></td>
            <td><%= orderDetail.getQuantity() %></td>
            <td><%= orderDetail.getPrice() %></td>
            <td><%= orderDetail.getOrderDate() %></td>
            <td><%= orderDetail.getTotal() %></td>
        </tr>
        <% } %>
        <% } else { %>
        <tr>
            <td colspan="7" class="text-center">No order details found.</td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <a href="index" class="btn btn-secondary mt-3">Back</a>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
