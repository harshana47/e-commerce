<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Optional" %>
<%
    // Retrieve the message from the query parameters (if available)
    String message = Optional.ofNullable(request.getParameter("message")).orElse("");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Category</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>
<body>
<div class="container mt-5">
    <h1 class="text-center text-danger">Delete Category</h1>

    <% if (!message.isEmpty()) { %>
    <div class="alert alert-info text-center">
        <%= message %>
    </div>
    <% } else { %>
    <div class="alert alert-warning text-center">
        Are you sure you want to delete this category? This action cannot be undone.
    </div>
    <!-- Add your form for confirming deletion -->
    <form action="deleteCategory" method="get" class="text-center">
        <!-- Include the category ID as a hidden field -->
        <input type="hidden" name="id" value="<%= request.getParameter("id") %>">
        <button type="submit" class="btn btn-danger">Confirm Delete</button>
        <a href="adminHome.jsp" class="btn btn-secondary">Cancel</a>
    </form>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
