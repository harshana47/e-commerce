package org.example.assignmentee;

import DTO.CategoryDTO;
import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "CategoryUpdateServlet", value = "/updateCategory")
public class CategoryUpdateServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");

        if (id != null) {
            try (Connection connection = dataSource.getConnection()) {
                String query = "SELECT * FROM categories WHERE id = ?";
                try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                    preparedStatement.setInt(1, Integer.parseInt(id));
                    ResultSet resultSet = preparedStatement.executeQuery();

                    if (resultSet.next()) {
                        // Create a CategoryDTO object to pass to the JSP
                        CategoryDTO category = new CategoryDTO(
                                resultSet.getInt("id"),
                                resultSet.getString("name"),
                                resultSet.getString("description")
                        );

                        // Set the CategoryDTO as an attribute in the request
                        request.setAttribute("category", category);

                        // Forward the request to the updateCategory.jsp
                        request.getRequestDispatcher("updateCategory.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("adminHome.jsp?message=Category not found");
                    }
                }
            } catch (SQLException | NumberFormatException e) {
                response.sendRedirect("adminHome.jsp?message=Error retrieving category");
            }
        } else {
            response.sendRedirect("adminHome.jsp?message=No category ID provided");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int categoryId = Integer.parseInt(req.getParameter("category_id"));
        String categoryName = req.getParameter("category_name");
        String categoryDescription = req.getParameter("category_description");

        try (Connection connection = dataSource.getConnection()) {
            String sql = "UPDATE categories SET name = ?, description = ? WHERE id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, categoryName);
                stmt.setString(2, categoryDescription);
                stmt.setInt(3, categoryId);
                int rowsUpdated = stmt.executeUpdate();

                if (rowsUpdated > 0) {
                    resp.sendRedirect("index");
                } else {
                    resp.getWriter().println("Error: Category not found or no changes made.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
