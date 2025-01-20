package org.example.assignmentee;

import DTO.ProductDTO;
import jakarta.annotation.Resource;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import javax.sql.DataSource;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

@WebServlet(name = "ProductBrowseServlet", value = "/productBrowsing")
public class ProductBrowseServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String categoryId = request.getParameter("categoryId");
        String search = request.getParameter("search");
        String sort = request.getParameter("sort");

        Map<Integer, String> categoryMap = new LinkedHashMap<>();
        List<ProductDTO> products = new ArrayList<>();

        try (Connection conn = dataSource.getConnection()) {
            // Fetch categories
            String categoryQuery = "SELECT id, name FROM categories ORDER BY name ASC";
            try (PreparedStatement stmt = conn.prepareStatement(categoryQuery);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    categoryMap.put(rs.getInt("id"), rs.getString("name"));
                }
            }

            // Fetch products
            StringBuilder productQuery = new StringBuilder(
                    "SELECT id, name, description, price, stock, category_id FROM products WHERE 1=1 "
            );

            if (categoryId != null && !categoryId.isEmpty()) {
                productQuery.append("AND category_id = ? ");
            }
            if (search != null && !search.isEmpty()) {
                productQuery.append("AND name LIKE ? ");
            }
            if ("asc".equals(sort)) {
                productQuery.append("ORDER BY price ASC ");
            } else if ("desc".equals(sort)) {
                productQuery.append("ORDER BY price DESC ");
            }

            try (PreparedStatement stmt = conn.prepareStatement(productQuery.toString())) {
                int paramIndex = 1;
                if (categoryId != null && !categoryId.isEmpty()) {
                    stmt.setInt(paramIndex++, Integer.parseInt(categoryId));
                }
                if (search != null && !search.isEmpty()) {
                    stmt.setString(paramIndex++, "%" + search + "%");
                }

                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        ProductDTO product = new ProductDTO();
                        product.setId(rs.getInt("id"));
                        product.setName(rs.getString("name"));
                        product.setDescription(rs.getString("description"));
                        product.setPrice(rs.getBigDecimal("price"));
                        product.setStock(rs.getInt("stock"));
                        product.setCategoryId(rs.getInt("category_id"));
                        products.add(product);
                    }
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        // Group products by category
        Map<String, List<ProductDTO>> groupedProducts = new LinkedHashMap<>();
        for (ProductDTO product : products) {
            String categoryName = categoryMap.get(product.getCategoryId());
            groupedProducts.computeIfAbsent(categoryName, k -> new ArrayList<>()).add(product);
        }

        request.setAttribute("groupedProducts", groupedProducts);
        request.setAttribute("categories", categoryMap);

        // Forward to JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("productBrowsing.jsp");
        dispatcher.forward(request, response);
    }
}
