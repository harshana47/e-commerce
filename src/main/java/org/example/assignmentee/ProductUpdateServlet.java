package org.example.assignmentee;

import DTO.ProductDTO;
import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.sql.DataSource;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;

@WebServlet(name = "ProductUpdateServlet", value = "/updateProduct")
public class ProductUpdateServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");

        if (id != null) {
            try (Connection connection = dataSource.getConnection()) {
                String query = "SELECT * FROM products WHERE id = ?";
                try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                    preparedStatement.setInt(1, Integer.parseInt(id));
                    ResultSet resultSet = preparedStatement.executeQuery();

                    if (resultSet.next()) {
                        // Create a ProductDTO object to pass to the JSP
                        ProductDTO product = new ProductDTO(
                                resultSet.getInt("id"),
                                resultSet.getString("name"),
                                resultSet.getString("description"),
                                resultSet.getBigDecimal("price"),
                                resultSet.getInt("stock"),
                                resultSet.getInt("category_id")
                        );

                        // Set the ProductDTO as an attribute in the request
                        request.setAttribute("product", product);

                        // Forward the request to the updateProduct.jsp
                        request.getRequestDispatcher("updateProduct.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("adminHome.jsp?message=Product not found");
                    }
                }
            } catch (SQLException | NumberFormatException e) {
                response.sendRedirect("adminHome.jsp?message=Error retrieving product");
            }
        } else {
            response.sendRedirect("adminHome.jsp?message=No product ID provided");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int productId = Integer.parseInt(req.getParameter("product_id"));
        String productName = req.getParameter("product_name");
        String productDescription = req.getParameter("product_description");
        BigDecimal productPrice = new BigDecimal(req.getParameter("product_price"));
        int productStock = Integer.parseInt(req.getParameter("product_stock"));
        int categoryId = Integer.parseInt(req.getParameter("category_id"));

        try (Connection connection = dataSource.getConnection()) {
            String sql = "UPDATE products SET name = ?, description = ?, price = ?, stock = ?, category_id = ? WHERE id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, productName);
                stmt.setString(2, productDescription);
                stmt.setBigDecimal(3, productPrice);
                stmt.setInt(4, productStock);
                stmt.setInt(5, categoryId);
                stmt.setInt(6, productId);
                int rowsUpdated = stmt.executeUpdate();

                if (rowsUpdated > 0) {
                    resp.sendRedirect("product"); // Redirect to the homepage or product list page
                } else {
                    resp.getWriter().println("Error: Product not found or no changes made.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
