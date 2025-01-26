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
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "ProductDeleteServlet", value = "/deleteProduct")
public class ProductDeleteServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam != null) {
            int productId = Integer.parseInt(idParam);

            try (Connection connection = dataSource.getConnection()) {
                String deleteQuery = "DELETE FROM products WHERE id = ?";
                try (PreparedStatement preparedStatement = connection.prepareStatement(deleteQuery)) {
                    preparedStatement.setInt(1, productId);

                    int rowsAffected = preparedStatement.executeUpdate();
                    if (rowsAffected > 0) {
                        response.sendRedirect("product?message=Product deleted successfully");
                    } else {
                        response.sendRedirect("adminHome.jsp?message=Product not found");
                    }
                }
            } catch (SQLException | NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("adminHome.jsp?message=Error deleting product");
            }
        } else {
            response.sendRedirect("adminHome.jsp?message=Invalid product ID");
        }
    }
}
