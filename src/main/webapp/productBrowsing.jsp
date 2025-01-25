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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            scroll-behavior: smooth;
            box-sizing: border-box;
            scroll-padding-top: 2rem;
            list-style: none;
            text-decoration: none;
            font-family: 'Poppins', sans-serif;
        }
        body {
            background-color: #f7f7f7;
            font-family: 'Arial', sans-serif;
            color: #2f2f2f;
            background: var(--bg-color););
        }
        :root {
            --main-color: #f54744;
            --text-color: #2f2f2f;
            --bg-color: #fff;

            --big-font: 3.2rem;
            --h2-font: 2rem;
        }
        .top-icons {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding: 10px 15px;
            /*background-color: #f8f9fa;*/
            /*border-bottom: 1px solid #e1e1e1;*/
        }

        .top-icons .icon {
            margin-left: 17px;
            font-size: 20px;
            position: relative;
        }

        .top-icons .icon a {
            text-decoration: none;
            color: #333;
        }

        .top-icons .badge {
            position: absolute;
            top: -5px;
            right: -10px;
            font-size: 12px;
            background-color: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 3px 7px;
        }

        .navbar {
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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
            background: var(--main-color);
            color: white;
            border-radius: 5px;
            padding: 8px 15px;
            font-size: 14px;
            width: 200px;
        }

        .btn-custom:hover {
            background-color: #fc5552;
        }

        .search-container {
            margin-bottom: 40px;
        }

        .section-header {
            font-size: 1.5rem;
            font-weight: bold;
            color: #F54744FF;
            margin-bottom: 20px;
        }

        #h1{
            margin-top: -40px;
            color: #F54744FF;
            font-family: 'Poppins', sans-serif;
            font-weight: 600;
        }
        #h3{
            margin-top: -5px;
            margin-bottom: 40px;
            color: #1b1a1a;
            font-family: 'Poppins', sans-serif;
            font-weight: 600;
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
<div class="container-fluid px-0">

    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Foods</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="http://localhost:8080/Assignment_EE_war_exploded">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="productBrowsing">Products</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="shoppingCart">Cart</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="orderHistory">Order History</a>
                    </li>

                    <!-- Account dropdown -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Account
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <!-- Show Log In if the user is NOT logged in -->
                            <c:if test="${sessionScope.isLoggedIn == null || !sessionScope.isLoggedIn}">
                                <li><a class="dropdown-item" href="login.jsp">Log In</a></li>
                            </c:if>

                            <!-- Show Log Out and User Details if the user is logged in -->
                            <c:if test="${sessionScope.isLoggedIn != null && sessionScope.isLoggedIn}">
                                <li><a class="dropdown-item" href="userProfile">User Details</a></li>
                                <li><a class="dropdown-item" href="login.jsp">Log Out</a></li>
                            </c:if>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Top Icons -->
    <div class="top-icons">
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
        <div class="icon">
            <a href="orderHistory" title="Order History">
                <i class="fas fa-history"></i>
            </a>
        </div>
    </div>
    <!-- Page Title -->
    <h1 id="h1" class="text-center ">Feeling Hungry?</h1>
    <h3 id="h3" class="text-center "> Your Cravings End Here!</h3>

    <!-- Search Form -->
    <form method="get" action="productBrowsing" class="row g-3 mb-4 search-container">
        <div class="col-md-3">
            <select name="categoryId" class="form-select" style="width: 250px;margin-left: 110px;">
                <option value="">All Categories</option>
                <% Map<Integer, String> categories = (Map<Integer, String>) request.getAttribute("categories");
                    for (Map.Entry<Integer, String> category : categories.entrySet()) { %>
                <option value="<%= category.getKey() %>"><%= category.getValue() %></option>
                <% } %>
            </select>
        </div>
        <div class="col-md-4" style="margin-left: -5px;margin-right: 5px;">
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
            <button type="submit" class="btn btn-custom ">Search</button>
        </div>
    </form>

    <!-- Product Listing -->
    <div class="container">
        <% Map<String, List<ProductDTO>> groupedProducts = (Map<String, List<ProductDTO>>) request.getAttribute("groupedProducts");
            if (groupedProducts.isEmpty()) { %>
        <div class="alert alert-info text-center">No products found.</div>
        <% } else { %>
        <% for (Map.Entry<String, List<ProductDTO>> entry : groupedProducts.entrySet()) { %>
        <section class="mb-5">
            <h2 class="section-header "><%= entry.getKey() %></h2>
            <div class="row row-cols-1 row-cols-md-3 g-4">
                <% for (ProductDTO product : entry.getValue()) { %>
                <div class="col">
                    <div class="card product-card">
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
                                <button type="submit" class="btn btn-success">Add to Cart</button>
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
