package org.example.assignmentee.adminControllers;

import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "CategorySaveServlet", value = "/saveCategory")
public class CategorySaveServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String categoryName = req.getParameter("category_name");
        String categoryDescription = req.getParameter("category_description");

        try (Connection connection = dataSource.getConnection()) {
            String sql = "INSERT INTO categories (name, description) VALUES (?, ?)";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, categoryName);
                stmt.setString(2, categoryDescription);
                stmt.executeUpdate();
                resp.sendRedirect("index");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
