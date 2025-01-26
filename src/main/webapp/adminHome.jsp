<%@ page import="DTO.CategoryDTO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<!DOCTYPE html>
<html>
<head>
    <title>Category Management</title>
</head>
<body>
<nav class="navbar navbar-expand-lg bg-body-tertiary">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Navbar</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="userManagement">User</a></li>
                <li class="nav-item"><a class="nav-link" href="viewAllOrders">Order</a></li>
                <li class="nav-item"><a class="nav-link" href="product">Product</a></li>
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
                <li class="nav-item"><a class="nav-link disabled" aria-disabled="true">Disabled</a></li>
            </ul>
            <form class="d-flex" role="search">
                <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
                <button class="btn btn-outline-success" type="submit">Search</button>
            </form>
        </div>
    </div>
</nav>

<div class="d-flex justify-content-end p-3">
    <a href="saveCategory.jsp" class="btn btn-primary">Add New Category</a>
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
                <img src="..." class="card-img-top" alt="<%= category.getName() %>">
                <div class="card-body">
                    <h5 class="card-title"><%= category.getName() %></h5>
                    <p class="card-text"><%= category.getDescription() %></p>
                    <a href="#" class="btn btn-primary">Go somewhere</a>
                    <br>
                    <a href="updateCategory?id=<%= category.getId() %>" class="btn btn-warning">Update</a>
                    <a href="deleteCategory.jsp?id=<%= category.getId() %>" class="btn btn-danger">Delete</a>
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
