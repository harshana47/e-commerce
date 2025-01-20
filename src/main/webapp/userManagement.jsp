<%@ page import="DTO.UserDTO" %>
<%@ page import="java.util.List" %>
<%
    // Get the list of users from the request
    List<UserDTO> users = (List<UserDTO>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h1 class="text-center">User Management</h1>
    <table class="table table-bordered table-striped mt-4">
        <thead>
        <tr>
            <th>User ID</th>
            <th>Username</th>
            <th>Email</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% if (users != null && !users.isEmpty()) { %>
        <% for (UserDTO user : users) { %>
        <tr>
            <td><%= user.getId() %></td>
            <td><%= user.getUsername() %></td>
            <td><%= user.getEmail() %></td>
            <td><%= user.getStatus() %></td>
            <td>
                <form action="userManagement" method="post" style="display:inline;">
                    <input type="hidden" name="userId" value="<%= user.getId() %>">
                    <button type="submit" name="action" value="activate" class="btn btn-success">Activate</button>
                </form>
                <form action="userManagement" method="post" style="display:inline;">
                    <input type="hidden" name="userId" value="<%= user.getId() %>">
                    <button type="submit" name="action" value="deactivate" class="btn btn-danger">Deactivate</button>
                </form>
            </td>
        </tr>
        <% } %>
        <% } else { %>
        <tr>
            <td colspan="5" class="text-center">No users found.</td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <a href="index" class="btn btn-secondary mt-3">Back</a>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
