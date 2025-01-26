package org.example.assignmentee;

import DTO.ProductDTO;
import DTO.CategoryDTO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet(name = "ProductServlet", value = "/product")
public class ProductServlet extends HttpServlet {
    String DB_URL = "jdbc:mysql://localhost:3306/ecommerce";
    String DB_USER = "root";
    String DB_PASSWORD = "harshima@147";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<CategoryDTO> categoryList = new ArrayList<>();
        Map<Integer, List<ProductDTO>> productsByCategory = new HashMap<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String categorySql = "SELECT * FROM categories";
            Statement categoryStatement = connection.createStatement();
            ResultSet categoryResultSet = categoryStatement.executeQuery(categorySql);

            while (categoryResultSet.next()) {
                CategoryDTO category = new CategoryDTO(
                        categoryResultSet.getInt("id"),
                        categoryResultSet.getString("name"),
                        categoryResultSet.getString("description")
                );
                categoryList.add(category);

                String productSql = "SELECT * FROM products WHERE category_id = ?";
                PreparedStatement productStatement = connection.prepareStatement(productSql);
                productStatement.setInt(1, category.getId());
                ResultSet productResultSet = productStatement.executeQuery();

                List<ProductDTO> productList = new ArrayList<>();
                while (productResultSet.next()) {
                    ProductDTO product = new ProductDTO(
                            productResultSet.getInt("id"),
                            productResultSet.getString("name"),
                            productResultSet.getString("description"),
                            productResultSet.getBigDecimal("price"),
                            productResultSet.getInt("stock"),
                            productResultSet.getInt("category_id"),
                            productResultSet.getString("image_path")
                    );
                    productList.add(product);
                }
                productsByCategory.put(category.getId(), productList);
            }

            req.setAttribute("categories", categoryList);
            req.setAttribute("productsByCategory", productsByCategory);
            RequestDispatcher rd = req.getRequestDispatcher("/product.jsp");
            rd.forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
