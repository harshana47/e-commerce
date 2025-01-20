<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Product</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h1 class="mb-4 text-center">Delete Product</h1>
    <div class="alert alert-warning text-center">
        <strong>Are you sure you want to delete this product?</strong>
    </div>
    <form method="get" action="deleteProduct">
        <input type="hidden" name="id" value="<%= request.getParameter("id") %>">
        <div class="d-flex justify-content-center">
            <button type="submit" class="btn btn-danger me-2">Delete</button>
            <a href="index" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
