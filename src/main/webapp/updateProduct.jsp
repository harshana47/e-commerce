<%@ page import="DTO.ProductDTO" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    ProductDTO product = (ProductDTO) request.getAttribute("product");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Product</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h1 class="mb-4 text-center">Update Product</h1>
    <form method="post" action="updateProduct" enctype="multipart/form-data">
        <input type="hidden" name="product_id" value="<%= product.getId() %>">

        <div class="mb-3">
            <label for="name" class="form-label">Product Name</label>
            <input type="text" class="form-control" id="name" name="product_name" required value="<%= product.getName() %>">
        </div>

        <div class="mb-3">
            <label for="description" class="form-label">Product Description</label>
            <textarea class="form-control" id="description" name="product_description" rows="3" required><%= product.getDescription() %></textarea>
        </div>

        <div class="mb-3">
            <label for="price" class="form-label">Product Price</label>
            <input type="number" class="form-control" id="price" name="product_price" required value="<%= product.getPrice() %>" step="0.01">
        </div>

        <div class="mb-3">
            <label for="stock" class="form-label">Product Stock</label>
            <input type="number" class="form-control" id="stock" name="product_stock" required value="<%= product.getStock() %>">
        </div>

        <div class="mb-3">
            <label for="category_id" class="form-label">Category</label>
            <select class="form-control" id="category_id" name="category_id" required>
                <%
                    List<String> categories = (List<String>) request.getAttribute("categories");
                    int currentCategoryId = product.getCategoryId(); // Current product category ID
                    for (String category : categories) {
                        String[] parts = category.split(":");
                        int categoryId = Integer.parseInt(parts[0]);
                        String categoryName = parts[1];
                %>
                <option value="<%= categoryId %>" <%= categoryId == currentCategoryId ? "selected" : "" %>>
                    <%= categoryName %>
                </option>
                <% } %>
            </select>
        </div>

        <!-- Product Image -->
        <div class="mb-3">
            <label for="image" class="form-label">Product Image</label>
            <input type="file" class="form-control" id="image" name="product_image">

            <%-- Show the current image if it exists --%>
            <%
                String imagePath = product.getImagePath(); // Adjust this field based on your DTO
                if (imagePath != null && !imagePath.trim().isEmpty()) {
            %>
            <div class="mt-3">
                <p>Current Image:</p>
                <img src="<%= imagePath %>" alt="Product Image" class="img-fluid" style="max-height: 200px;">
            </div>
            <% } else { %>
            <p class="mt-3 text-muted">No current image available for this product.</p>
            <% } %>
        </div>

        <!-- Submit and Back Buttons -->
        <div class="d-flex justify-content-between">
            <button type="submit" class="btn btn-primary">Update</button>
            <a href="adminHome.jsp" class="btn btn-secondary">Back</a>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
