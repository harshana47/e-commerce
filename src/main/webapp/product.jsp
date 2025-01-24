<%@ page import="DTO.CategoryDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="DTO.ProductDTO" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products by Category</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>
<body>
<div class="container my-5">
    <!-- Back Button -->
    <a href="index" class="btn btn-primary mb-3">Back to Categories</a>

    <h1 class="text-center mb-5">Products by Category</h1>

    <!-- Add Product Button -->
    <a href="addProduct" class="btn btn-success mb-3">Add New Product</a>

    <%
        List<CategoryDTO> categories = (List<CategoryDTO>) request.getAttribute("categories");
        Map<Integer, List<ProductDTO>> productsByCategory = (Map<Integer, List<ProductDTO>>) request.getAttribute("productsByCategory");

        // Iterate through categories and display their products
        for (CategoryDTO category : categories) {
    %>
    <div class="category-section">
        <h2><%= category.getName() %></h2>

        <div class="row">
            <%
                List<ProductDTO> products = productsByCategory.get(category.getId());
                if (products != null && !products.isEmpty()) {
                    for (ProductDTO product : products) {
            %>
            <div class="col-md-3">
                <div class="card mb-4">
                    <img src="https://via.placeholder.com/150" class="card-img-top" alt="<%= product.getName() %>">
                    <div class="card-body">
                        <h5 class="card-title"><%= product.getName() %></h5>
                        <p class="card-text"><%= product.getDescription() %></p>
                        <p class="card-text">Price: $<%= product.getPrice() %></p>
                        <p class="card-text">Stock: <%= product.getStock() %></p>

                        <a href="updateProduct?id=<%= product.getId() %>" class="btn btn-warning btn-sm">Update</a>
                        <a href="deleteProduct?id=<%= product.getId() %>" class="btn btn-danger btn-sm">Delete</a>
                    </div>
                </div>
            </div>
            <%
                }
            } else {
            %>
            <div class="col-12">
                <p>No products available in this category.</p>
            </div>
            <%
                }
            %>
        </div>
    </div>
    <hr class="my-4">
    <%
        }
    %>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.0.7/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
