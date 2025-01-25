package org.example.assignmentee;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "UserProfileServlet", value = "/userProfile")
public class UserProfileServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/ecommerce";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "harshima@147";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp"); // Redirect to login if user is not logged in
            return;
        }

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "SELECT username, email FROM users WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                request.setAttribute("username", resultSet.getString("username"));
                request.setAttribute("email", resultSet.getString("email"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching user details: " + e.getMessage());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("userProfile.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp"); // Redirect to login if user is not logged in
            return;
        }

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            doGet(request, response);
            return;
        }

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            // Verify current password
            String verifyPasswordSql = "SELECT password FROM users WHERE id = ?";
            PreparedStatement verifyStmt = connection.prepareStatement(verifyPasswordSql);
            verifyStmt.setInt(1, userId);
            ResultSet resultSet = verifyStmt.executeQuery();

            if (resultSet.next()) {
                String storedHashedPassword = resultSet.getString("password");

                // Compare hashed password with the current password
                if (!BCrypt.checkpw(currentPassword, storedHashedPassword)) {
                    request.setAttribute("error", "Current password is incorrect.");
                    doGet(request, response);
                    return;
                }
            }

            // Hash the new password
            String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

            // Update user details
            String updateSql = "UPDATE users SET username = ?, email = ?, password = ? WHERE id = ?";
            PreparedStatement updateStmt = connection.prepareStatement(updateSql);
            updateStmt.setString(1, username);
            updateStmt.setString(2, email);
            updateStmt.setString(3, hashedNewPassword);
            updateStmt.setInt(4, userId);

            int rowsUpdated = updateStmt.executeUpdate();
            if (rowsUpdated > 0) {
                request.setAttribute("success", "Profile updated successfully.");
            } else {
                request.setAttribute("error", "Failed to update profile.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        doGet(request, response);
    }
}
