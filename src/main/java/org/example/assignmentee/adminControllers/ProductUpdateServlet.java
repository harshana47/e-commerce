package org.example.assignmentee.adminControllers;

import DTO.ProductDTO;
import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import javax.sql.DataSource;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ProductUpdateServlet", value = "/updateProduct")
@MultipartConfig // Enable file uploads
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
                        ProductDTO product = new ProductDTO(
                                resultSet.getInt("id"),
                                resultSet.getString("name"),
                                resultSet.getString("description"),
                                resultSet.getBigDecimal("price"),
                                resultSet.getInt("stock"),
                                resultSet.getInt("category_id"),
                                resultSet.getString("image_path")
                        );

                        String categoryQuery = "SELECT id, name FROM categories";
                        try (PreparedStatement categoryStmt = connection.prepareStatement(categoryQuery);
                             ResultSet categoryRs = categoryStmt.executeQuery()) {

                            List<String> categories = new ArrayList<>();
                            while (categoryRs.next()) {
                                categories.add(categoryRs.getInt("id") + ":" + categoryRs.getString("name"));
                            }

                            request.setAttribute("product", product);
                            request.setAttribute("categories", categories);

                            request.getRequestDispatcher("updateProduct.jsp").forward(request, response);
                        }
                    } else {
                        response.sendRedirect("adminHome.jsp?message=Product not found");
                    }
                }
            } catch (SQLException | NumberFormatException e) {
                e.printStackTrace();
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

        Part filePart = req.getPart("product_image");
        String imagePath = null;

        try (Connection connection = dataSource.getConnection()) {

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadDir = getServletContext().getRealPath("/images");
                File uploadDirectory = new File(uploadDir);

                if (!uploadDirectory.exists()) {
                    uploadDirectory.mkdir();
                }

                String filePath = uploadDir + File.separator + fileName;
                filePart.write(filePath);
                imagePath = "images/" + fileName;
            } else {
                String query = "SELECT image_path FROM products WHERE id = ?";
                try (PreparedStatement stmt = connection.prepareStatement(query)) {
                    stmt.setInt(1, productId);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        imagePath = rs.getString("image_path");
                    }
                }
            }

            String sql = "UPDATE products SET name = ?, description = ?, price = ?, stock = ?, category_id = ?, image_path = ? WHERE id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, productName);
                stmt.setString(2, productDescription);
                stmt.setBigDecimal(3, productPrice);
                stmt.setInt(4, productStock);
                stmt.setInt(5, categoryId);
                stmt.setString(6, imagePath);
                stmt.setInt(7, productId);

                int rowsUpdated = stmt.executeUpdate();

                if (rowsUpdated > 0) {
                    resp.sendRedirect("product");
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
