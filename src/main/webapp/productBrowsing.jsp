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

        .top-right-icons {
            position: absolute;
            top: 10px;
            right: 10px;
            display: flex;
            gap: 15px;
        }

        .icon {
            font-size: 24px;
            position: relative;
        }

        .icon a {
            text-decoration: none;
            color: #333;
        }

        .badge {
            position: absolute;
            top: -5px;
            right: -10px;
            font-size: 12px;
            background-color: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 3px 7px;
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
        }

        .product-card .card-body {
            flex-grow: 1;
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

        .card-footer {
            background-color: #f8f9fa;
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

        .search-container {
            margin-bottom: 40px;
        }

        .section-header {
            font-size: 1.5rem;
            font-weight: bold;
            color: #007bff;
            margin-bottom: 20px;
        }
    </style>
    <script>
        window.onload = function () {
            const urlParams = new URLSearchParams(window.location.search);

            if (urlParams.has('searchSuccess')) {
                alert(urlParams.get('searchSuccess') === 'true'
                    ? 'Search completed successfully.'
                    : 'No products matched your search.');
            }

            if (urlParams.has('addToCartSuccess')) {
                alert(urlParams.get('addToCartSuccess') === 'true'
                    ? 'Product added to cart successfully.'
                    : 'Failed to add product to cart.');
            }
        };
    </script>
</head>
<body>
<div class="container mt-5 position-relative">

    <!-- Top Right Icons -->
    <div class="top-right-icons">
        <!-- Cart Icon with Count -->
        <div class="icon">
            <a href="shoppingCart" title="View Cart">
                <i class="fas fa-shopping-cart"></i>
                <span class="badge" id="cartCount">
                    <c:if test="${not empty cartCount}">
                        ${cartCount}
                    </c:if>
                </span>
            </a>
        </div>

        <!-- Order History Button -->
        <div class="icon">
            <a href="orderHistory" title="Order History">
                <i class="fas fa-history"></i>
            </a>
        </div>
    </div>

    <!-- Page Title -->
    <h1 class="text-center text-primary mb-4">Product Catalog</h1>

    <!-- Search and Filter Form -->
    <form method="get" action="productBrowsing" class="row g-3 mb-4 search-container">
        <div class="col-md-3">
            <select name="categoryId" class="form-select">
                <option value="">All Categories</option>
                <% Map<Integer, String> categories = (Map<Integer, String>) request.getAttribute("categories");
                    for (Map.Entry<Integer, String> category : categories.entrySet()) { %>
                <option value="<%= category.getKey() %>"><%= category.getValue() %></option>
                <% } %>
            </select>
        </div>
        <div class="col-md-4">
            <input type="text" name="search" class="form-control" placeholder="Search by product name">
        </div>
        <div class="col-md-2">
            <select name="sort" class="form-select">
                <option value="">Sort by</option>
                <option value="asc">Price: Low to High</option>
                <option value="desc">Price: High to Low</option>
            </select>
        </div>
        <div class="col-md-3">
            <button type="submit" class="btn btn-primary w-100">Search</button>
        </div>
    </form>

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
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
