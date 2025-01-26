package org.example.assignmentee.adminControllers;

import DTO.UserDTO;
import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "UserManagementServlet", value = "/userManagement")
public class UserManagementServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<UserDTO> users = new ArrayList<>();

        String query = "SELECT id, username, email, status FROM users";

        try (Connection connection = dataSource.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                UserDTO user = new UserDTO(
                        resultSet.getInt("id"),
                        resultSet.getString("username"),
                        resultSet.getString("email"),
                        resultSet.getString("status")
                );
                users.add(user);
            }

            request.setAttribute("users", users);
            request.getRequestDispatcher("userManagement.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index?message=Error retrieving users");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userId = request.getParameter("userId");
        String action = request.getParameter("action");

        String updateQuery = "UPDATE users SET status = ? WHERE id = ?";

        try (Connection connection = dataSource.getConnection();
             PreparedStatement statement = connection.prepareStatement(updateQuery)) {

            if (action.equals("activate")) {
                statement.setString(1, "active");
            } else if (action.equals("deactivate")) {
                statement.setString(1, "inactive");
            }

            statement.setInt(2, Integer.parseInt(userId));
            int rowsUpdated = statement.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("userManagement");
            } else {
                response.sendRedirect("index?message=Error updating user status");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index?message=Error updating user status");
        }
    }
}
