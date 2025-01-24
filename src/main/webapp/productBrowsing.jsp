<%@ page import="java.util.Map" %>
<%@ page import="DTO.ProductDTO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Catalog</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f7f7f7;
            font-family: 'Arial', sans-serif;
        }
        .product-card {
            display: flex;
            flex-direction: column;
            height: 100%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
            background-color: #fff;
        }
        .product-card img {
            max-height: 180px;
            object-fit: cover;
            width: 100%;
        }
        .product-card .card-body h5 {
            font-size: 1.1rem;
            font-weight: 600;
            color: #333;
        }
        .product-card .card-body p {
            font-size: 0.9rem;
            color: #555;
        }
        .product-card .card-body .price {
            font-size: 1.2rem;
            color: #28a745;
            font-weight: bold;
        }
        .btn-custom {
            background-color: #007bff;
            color: white;
            border-radius: 5px;
            padding: 8px 15px;
            font-size: 14px;
        }
        .btn-custom:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h1 class="text-center text-primary mb-4">Product Catalog</h1>

    <% Map<String, List<ProductDTO>> groupedProducts = (Map<String, List<ProductDTO>>) request.getAttribute("groupedProducts");
        if (groupedProducts.isEmpty()) { %>
    <div class="alert alert-info text-center">No products found.</div>
    <% } else { %>
    <% for (Map.Entry<String, List<ProductDTO>> entry : groupedProducts.entrySet()) { %>
    <section class="mb-5">
        <h2 class="section-header text-primary"><%= entry.getKey() %></h2>
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <% for (ProductDTO product : entry.getValue()) { %>
            <div class="col">
                <div class="card product-card">
                    <!-- Product Image -->
                    <img src="<%= product.getImagePath() %>" class="card-img-top" alt="<%= product.getName() %>">

                    <div class="card-body">
                        <h5 class="card-title"><%= product.getName() %></h5>
                        <p class="card-text"><%= product.getDescription() %></p>
                        <p class="price">$<%= product.getPrice() %></p>
                    </div>
                    <div class="card-footer text-center">
                        <form method="post" action="productBrowsing">
                            <input type="hidden" name="productId" value="<%= product.getId() %>">
                            <input type="hidden" name="userId" value="1">
                            <div class="input-group mb-2">
                                <input type="number" name="quantity" class="form-control" value="1" min="1" placeholder="Quantity">
                            </div>
                            <button type="submit" class="btn btn-custom">Add to Cart</button>
                        </form>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </section>
    <% } %>
    <% } %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
