package org.example.assignmentee.adminControllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "CategoryDeleteServlet", value = "/deleteCategory")
public class CategoryDeleteServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/ecommerce";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "harshima@147"; // Replace with your database password

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id"); // Get the category ID from the request

        if (id != null) {
            try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                String query = "DELETE FROM categories WHERE id = ?";
                try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                    preparedStatement.setInt(1, Integer.parseInt(id));
                    int rowsAffected = preparedStatement.executeUpdate();

                    if (rowsAffected > 0) {
                        response.sendRedirect("adminHome.jsp?message=Category deleted successfully");
                    } else {
                        response.sendRedirect("adminHome.jsp?message=Category not found");
                    }
                }
            } catch (SQLException | NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("adminHome.jsp?message=Error deleting category");
            }
        } else {
            response.sendRedirect("categories.jsp?message=No category ID provided");
        }
    }
}
