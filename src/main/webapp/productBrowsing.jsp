<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="DTO.ProductDTO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .product-card {
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .product-card img {
            max-height: 150px;
            object-fit: contain;
        }
        .product-card .card-body {
            flex-grow: 1;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h1 class="text-center">Product Catalog</h1>

    <!-- Search and Filter Form -->
    <form method="get" action="productBrowsing" class="row g-3 mb-4">
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

    <!-- Display Products by Category -->
    <% Map<String, List<ProductDTO>> groupedProducts = (Map<String, List<ProductDTO>>) request.getAttribute("groupedProducts");
        if (groupedProducts.isEmpty()) { %>
    <div class="alert alert-info text-center">No products found.</div>
    <% } else { %>
    <% for (Map.Entry<String, List<ProductDTO>> entry : groupedProducts.entrySet()) { %>
    <section class="mb-5">
        <h2 class="text-primary"><%= entry.getKey() %></h2>
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <% for (ProductDTO product : entry.getValue()) { %>
            <div class="col">
                <div class="card product-card">
                    <img src="placeholder.jpg" class="card-img-top" alt="<%= product.getName() %>">
                    <div class="card-body">
                        <h5 class="card-title"><%= product.getName() %></h5>
                        <p class="card-text"><%= product.getDescription() %></p>
                        <p class="text-success fw-bold">$<%= product.getPrice() %></p>
                    </div>
                    <div class="card-footer text-center">
                        <button class="btn btn-primary">Add to Cart</button>
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
