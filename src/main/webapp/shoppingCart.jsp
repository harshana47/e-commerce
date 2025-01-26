<%@ page import="java.util.List" %>
<%@ page import="DTO.CartDTO" %>
<%@ page import="DTO.ProductDTO" %>
<%@ page import="java.text.DecimalFormat" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f7f6;
            color: #555;
            margin: 0;
            padding: 0;
        }

        .container {
            margin-top: 40px;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.5rem;
            color: #007bff;
        }

        .card {
            margin-bottom: 20px;
            border: none;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease-in-out;
            border-radius: 8px;
        }

        .card:hover {
            transform: scale(1.05);
        }

        .card-title {
            color: #007bff;
            font-size: 1.4rem;
            font-weight: bold;
        }

        .card-body {
            padding: 20px;
        }

        .btn {
            font-size: 0.9rem;
            border-radius: 20px;
        }

        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }

        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }

        .alert {
            text-align: center;
            padding: 20px;
            font-size: 1.2rem;
            margin-bottom: 30px;
            background-color: #ffecb3;
            color: #856404;
            border-radius: 8px;
        }

        .checkout-btn {
            text-align: center;
            margin-top: 30px;
        }

        .checkout-btn a {
            font-size: 1.3rem;
            padding: 15px 30px;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
        }

        .checkout-btn a i {
            margin-right: 10px;
        }

        .icon {
            margin-right: 8px;
        }

        .btn-icon {
            display: flex;
            align-items: center;
        }

        .btn-icon i {
            margin-right: 8px;
        }

    </style>
</head>
<body>
<div class="container">
    <a href="productBrowsing" class="btn btn-success btn-icon">
        <i class="fas fa-arrow-left"></i> Back to Products
    </a>
    <h2>Your Cart</h2>

    <%
        // Retrieve the cartItems from the request
        List<CartDTO> cartItems = (List<CartDTO>) request.getAttribute("cartItems");

        // Check if cart is empty
        if (cartItems == null || cartItems.isEmpty()) {
    %>
    <div class="alert" role="alert">
        Your cart is empty.
    </div>
    <div class="checkout-btn">
        <!-- Display "Back to Products" button when the cart is empty -->
        <a href="productBrowsing" class="btn btn-primary btn-icon">
            <i class="fas fa-arrow-left"></i> Back to Products
        </a>
    </div>
    <%
    } else {
    %>
    <div class="row">
        <%
            // Loop through each cart item and display it
            for (CartDTO item : cartItems) {
                ProductDTO product = item.getProduct();
                String formattedPrice = new DecimalFormat("#0.00").format(product.getPrice());
        %>
        <div class="col-md-6 col-lg-4">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title"><%= product.getName() %></h5>
                    <p class="card-text"><strong>Price:</strong> $<%= formattedPrice %></p>
                    <p class="card-text"><strong>Quantity:</strong></p>
                    <form method="POST" action="shoppingCart" class="d-inline">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="cartId" value="<%= item.getId() %>">
                        <input type="hidden" name="productId" value="<%= product.getId() %>">
                        <input type="number" name="quantity_<%= item.getId() %>" value="<%= item.getQuantity() %>" min="1" class="form-control d-inline w-50">
                        <button type="submit" class="btn btn-primary btn-sm mt-2"><i class="fas fa-sync-alt"></i> Update</button>
                    </form>
                    <form method="POST" action="shoppingCart" onsubmit="return confirm('Are you sure you want to remove this item from the cart?');">
                        <input type="hidden" name="action" value="remove">
                        <input type="hidden" name="cartId" value="<%= item.getId() %>">
                        <button type="submit" class="btn btn-danger btn-sm mt-2"><i class="fas fa-trash-alt"></i> Remove</button>
                    </form>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>

    <div class="checkout-btn">
        <a href="placeOrder" class="btn btn-success btn-icon">
            <i class="fas fa-credit-card"></i> Proceed to Checkout
        </a>
    </div>

    <%
        }
    %>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
