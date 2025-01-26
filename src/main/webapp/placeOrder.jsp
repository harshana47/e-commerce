<%@ page import="DTO.CartDTO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Place Order</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


    <style>
        body {
            padding: 20px;
        }
        .order-summary {
            margin-top: 30px;
        }
        .order-summary table th, .order-summary table td {
            text-align: center;
        }
        .btn-submit {
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Review Your Order</h2>

    <form action="placeOrder" method="POST">
        <div class="order-summary">
            <table class="table table-bordered">
                <thead>
                <tr>
                    <th>Product</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Total</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<CartDTO> cartItems = (List<CartDTO>) request.getAttribute("cartItems");
                    for (CartDTO cartItem : cartItems) {
                %>
                <tr>
                    <td><%= cartItem.getProduct().getName() %></td>
                    <td><%= cartItem.getQuantity() %></td>
                    <td><%= cartItem.getProduct().getPrice() %></td>
                    <td><%= cartItem.getTotalPrice() %></td>
                </tr>
                <input type="hidden" name="productId_<%= cartItem.getProduct().getId() %>" value="<%= cartItem.getProduct().getId() %>">
                <input type="hidden" name="quantity_<%= cartItem.getProduct().getId() %>" value="<%= cartItem.getQuantity() %>">
                <input type="hidden" name="price_<%= cartItem.getProduct().getId() %>" value="<%= cartItem.getProduct().getPrice() %>">
                <% } %>
                </tbody>
            </table>

            <div class="total-amount">
                <p><strong>Total Amount: </strong><%= request.getAttribute("totalAmount") %></p>
            </div>

            <button type="submit" class="btn btn-primary btn-submit">Place Order</button>
        </div>
    </form>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            <% if (request.getAttribute("orderPlaced") != null && (Boolean) request.getAttribute("orderPlaced")) { %>
            Swal.fire({
                title: 'Order Placed Successfully!',
                text: 'Your order has been successfully placed and is pending.',
                icon: 'success',
                confirmButtonText: 'OK'
            });
            <% } %>

            <% if (request.getAttribute("orderFailed") != null && (Boolean) request.getAttribute("orderFailed")) { %>
            Swal.fire({
                title: 'Oops!',
                text: 'An error occurred while processing your order. Please try again.',
                icon: 'error',
                confirmButtonText: 'OK'
            });
            <% } %>
        });
    </script>

</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
