<%@ page import="DTO.OrderDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    // Retrieve the list of orders from the request
    List<OrderDTO> orders = (List<OrderDTO>) request.getAttribute("orders");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h1 class="text-center">Order History</h1>
    <table class="table table-bordered table-striped mt-4">
        <thead>
        <tr>
            <th>Order ID</th>
            <th>Order Date</th>
            <th>Total Amount</th>
        </tr>
        </thead>
        <tbody>
        <% if (orders != null && !orders.isEmpty()) { %>
        <% DecimalFormat df = new DecimalFormat("#0.00"); %>
        <% for (OrderDTO order : orders) { %>
        <tr>
            <td><%= order.getId() %></td>
            <td><%= order.getOrderDate() %></td>
            <td>$<%= df.format(order.getTotal()) %></td>
        </tr>
        <% } %>
        <% } else { %>
        <tr>
            <td colspan="3" class="text-center">No orders found.</td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <a href="productBrowsing" class="btn btn-secondary mt-3">Back</a>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
