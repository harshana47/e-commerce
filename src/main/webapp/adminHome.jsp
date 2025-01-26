<%@ page import="DTO.CategoryDTO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<style>
    /* Modern button styles */
    .btn-custom {
        border-radius: 30px;
        padding: 4px 16px;
        font-size: 14px;
        font-weight: bold;
        text-transform: uppercase;
        transition: all 0.2s ease-in-out;
    }

    .btn-primary-custom {
        background: linear-gradient(to right, #4CAF50, #81C784);
        border: none;
        color: white;
    }

    .btn-primary-custom:hover {
        background: linear-gradient(to right, #388E3C, #66BB6A);
    }

    .btn-warning-custom {
        background: linear-gradient(to right, #FF9800, #FFB74D);
        border: none;
        color: white;
    }

    .btn-warning-custom:hover {
        background: linear-gradient(to right, #F57C00, #FF7043);
    }

    .btn-danger-custom {
        background: linear-gradient(to right, #F44336, #EF5350);
        border: none;
        color: white;
    }

    .btn-danger-custom:hover {
        background: linear-gradient(to right, #D32F2F, #F44336);
    }

    /* Modern card styles */
    .card {
        border-radius: 12px;
        background-color: #f9f9f9;
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
        transition: transform 0.2s ease-in-out;
        margin-bottom: 20px;
    }

    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    }

    .card-title {
        font-size: 18px;
        color: #333;
        font-weight: bold;
    }

    .card-text {
        font-size: 14px;
        color: #555;
    }

    /* Navbar styling */
    .navbar {
        background-color: #3b3f42;
    }

    .navbar-brand, .nav-link {
        color: white !important;
    }

    .nav-link:hover {
        color: #81C784 !important;
    }

    /* Compact card grid */
    .container {
        margin-top: 30px;
    }

</style>
<!DOCTYPE html>
<html>
<head>
    <title>Category Management</title>
</head>
<body>
<nav class="navbar navbar-expand-lg">
    <div class="container-fluid">
        <a class="navbar-brand" href="http://localhost:8080/Assignment_EE_war_exploded/">Home</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="userManagement">User</a></li>
                <li class="nav-item"><a class="nav-link" href="viewAllOrders">Order</a></li>
                <li class="nav-item"><a class="nav-link" href="product">Foods</a></li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Category</a>
                    <ul class="dropdown-menu">
                        <%
                            // Iterate over categories to dynamically populate the dropdown
                            List<CategoryDTO> categories = (List<CategoryDTO>) request.getAttribute("categories");
                            if (categories != null) {
                                for (CategoryDTO category : categories) {
                        %>
                        <li><a class="dropdown-item" href="#<%= category.getName() %>"><%= category.getName() %></a></li>
                        <%
                            }
                        } else {
                        %>
                        <li><a class="dropdown-item" href="#">No Categories Available</a></li>
                        <%
                            }
                        %>
                    </ul>
                </li>
            </ul>
            <form class="d-flex" role="search">
                <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
                <button class="btn btn-outline-success" type="submit">Search</button>
            </form>
        </div>
    </div>
</nav>

<div class="d-flex justify-content-end p-3">
    <a href="saveCategory.jsp" class="btn btn-primary-custom btn-custom">Add New Category</a>
</div>
<br><br>
<div class="container">
    <div class="row">
        <%
            if (categories != null) {
                for (CategoryDTO category : categories) {
        %>
        <div class="col-md-3">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title"><%= category.getName() %></h5>
                    <p class="card-text"><%= category.getDescription() %></p>
                    <br>
                    <a href="updateCategory?id=<%= category.getId() %>" class="btn btn-warning-custom btn-custom">Update</a>
                    <a href="deleteCategory.jsp?id=<%= category.getId() %>" class="btn btn-danger-custom btn-custom">Delete</a>
                </div>
            </div>
        </div>
        <%
                }
            }
        %>
    </div>
</div>
</body>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</html>
