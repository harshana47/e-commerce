package org.example.assignmentee;

import DTO.CategoryDTO;
import jakarta.annotation.Resource;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ProductSaveServlet", value = "/addProduct")
public class ProductSaveServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;


    private static final String DB_URL = "jdbc:mysql://localhost:3306/ecommerce";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "harshima@147";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Fetch categories from the database
        List<CategoryDTO> categories = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = dataSource.getConnection();
            String sql = "SELECT id, name FROM categories";
            Statement stm = connection.createStatement();
            ResultSet rst = stm.executeQuery(sql);

            // Populate the category list
            while (rst.next()) {
                int id = rst.getInt("id");
                String name = rst.getString("name");
                categories.add(new CategoryDTO(id, name, null)); // Assuming CategoryDTO constructor
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching categories: " + e.getMessage());
        }

        // Set the categories attribute for the JSP
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("addProduct.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form data
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        double price = 0.0;
        int stock = 0;
        int categoryId = 0;

        try {
            price = Double.parseDouble(request.getParameter("price"));
            stock = Integer.parseInt(request.getParameter("stock"));
            categoryId = Integer.parseInt(request.getParameter("category_id"));
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input values.");
            doGet(request, response); // Reload categories and show form
            return;
        }

        // SQL Query for inserting product
        String insertProductQuery = "INSERT INTO products (name, description, price, stock, category_id) VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = dataSource.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insertProductQuery)) {

            // Set query parameters
            preparedStatement.setString(1, name);
            preparedStatement.setString(2, description);
            preparedStatement.setDouble(3, price);
            preparedStatement.setInt(4, stock);
            preparedStatement.setInt(5, categoryId);

            // Execute the query
            int rowsAffected = preparedStatement.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("product"); // Redirect to product list
            } else {
                request.setAttribute("error", "Failed to add product.");
                doGet(request, response); // Reload categories and show form
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred: " + e.getMessage());
            doGet(request, response); // Reload categories and show form
        }
    }
}
