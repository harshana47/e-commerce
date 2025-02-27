package org.example.assignmentee.customerControllers;

import DTO.ProductDTO;
import jakarta.annotation.Resource;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import javax.sql.DataSource;
import java.io.IOException;
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

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            int userId = (int) session.getAttribute("userId");
            int cartCount = 0;
            try {
                cartCount = getCartCount(userId);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            request.setAttribute("cartCount", cartCount);
        }

        Map<Integer, String> categoryMap = new LinkedHashMap<>();
        List<ProductDTO> products = new ArrayList<>();

        try (Connection conn = dataSource.getConnection()) {
            String categoryQuery = "SELECT id, name FROM categories ORDER BY name ASC";
            try (PreparedStatement stmt = conn.prepareStatement(categoryQuery);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    categoryMap.put(rs.getInt("id"), rs.getString("name"));
                }
            }

            StringBuilder productQuery = new StringBuilder(
                    "SELECT id, name, description, price, stock, category_id, image_path FROM products WHERE 1=1 "
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
                        product.setImagePath(rs.getString("image_path"));
                        products.add(product);
                    }
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        Map<String, List<ProductDTO>> groupedProducts = new LinkedHashMap<>();
        for (ProductDTO product : products) {
            String categoryName = categoryMap.get(product.getCategoryId());
            groupedProducts.computeIfAbsent(categoryName, k -> new ArrayList<>()).add(product);
        }

        request.setAttribute("groupedProducts", groupedProducts);
        request.setAttribute("categories", categoryMap);

        RequestDispatcher dispatcher = request.getRequestDispatcher("productBrowsing.jsp");
        dispatcher.forward(request, response);
    }

    private int getCartCount(int userId) throws SQLException {
        String cartCountQuery = "SELECT SUM(quantity) AS totalQuantity FROM cart WHERE user_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(cartCountQuery)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("totalQuantity");
                }
            }
        }
        return 0;
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setContentType("text/html");
            response.getWriter().println("<script>alert('User is not logged in. Please log in to continue.'); window.location='login.jsp';</script>");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String productId = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");

        int productQty = (quantityParam != null) ? Integer.parseInt(quantityParam) : 1;

        if (productId == null) {
            response.setContentType("text/html");
            response.getWriter().println("<script>alert('Product ID is required.'); window.history.back();</script>");
            return;
        }

        try (Connection conn = dataSource.getConnection()) {
            String productQuery = "SELECT id, name, price, stock FROM products WHERE id = ?";
            try (PreparedStatement productStmt = conn.prepareStatement(productQuery)) {
                productStmt.setInt(1, Integer.parseInt(productId));

                try (ResultSet rs = productStmt.executeQuery()) {
                    if (rs.next()) {
                        int productStock = rs.getInt("stock");

                        if (productQty > productStock) {
                            response.setContentType("text/html");
                            response.getWriter().println("<script>alert('Insufficient stock available.'); window.history.back();</script>");
                            return;
                        }

                        String cartCheckQuery = "SELECT quantity FROM cart WHERE user_id = ? AND product_id = ?";
                        try (PreparedStatement cartCheckStmt = conn.prepareStatement(cartCheckQuery)) {
                            cartCheckStmt.setInt(1, userId);
                            cartCheckStmt.setInt(2, Integer.parseInt(productId));

                            try (ResultSet cartRs = cartCheckStmt.executeQuery()) {
                                if (cartRs.next()) {
                                    int existingQty = cartRs.getInt("quantity");
                                    String updateCartQuery = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
                                    try (PreparedStatement updateCartStmt = conn.prepareStatement(updateCartQuery)) {
                                        updateCartStmt.setInt(1, existingQty + productQty);
                                        updateCartStmt.setInt(2, userId);
                                        updateCartStmt.setInt(3, Integer.parseInt(productId));
                                        updateCartStmt.executeUpdate();
                                    }
                                } else {
                                    String insertCartQuery = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
                                    try (PreparedStatement insertCartStmt = conn.prepareStatement(insertCartQuery)) {
                                        insertCartStmt.setInt(1, userId);
                                        insertCartStmt.setInt(2, Integer.parseInt(productId));
                                        insertCartStmt.setInt(3, productQty);
                                        insertCartStmt.executeUpdate();
                                    }
                                }
                            }
                        }
                    } else {
                        response.setContentType("text/html");
                        response.getWriter().println("<script>alert('Product not found.'); window.history.back();</script>");
                        return;
                    }
                }
            }

            int cartCount = getCartCount(userId);
            request.setAttribute("cartCount", cartCount);

            response.setContentType("text/html");
            response.getWriter().println("<script>alert('Product successfully added to cart.'); window.location='productBrowsing';</script>");

        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}

