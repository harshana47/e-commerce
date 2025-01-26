package org.example.assignmentee.customerControllers;

import DTO.CartDTO;
import DTO.ProductDTO;
import jakarta.annotation.Resource;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.sql.DataSource;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ShoppingCartServlet", value = "/shoppingCart")
public class ShoppingCartServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            System.out.println("User ID is null. Redirecting to login page.");
            resp.sendRedirect("login.jsp");
            return;
        }

        List<CartDTO> cartItems = new ArrayList<>();

        try (Connection connection = dataSource.getConnection()) {
            // Fetch cart items for the user
            String sql = "SELECT id, product_id, quantity FROM cart WHERE user_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    int productId = rs.getInt("product_id");
                    ProductDTO product = getProductById(productId);
                    int quantity = rs.getInt("quantity");
                    BigDecimal totalPrice = product.getPrice().multiply(BigDecimal.valueOf(quantity));
                    CartDTO cartItem = new CartDTO(
                            rs.getInt("id"),
                            userId,
                            product,
                            quantity,
                            totalPrice
                    );
                    cartItems.add(cartItem);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Error while fetching cart items.");
            RequestDispatcher rd = req.getRequestDispatcher("errorPage.jsp");
            rd.forward(req, resp);
            return;
        }

        session.setAttribute("cart", cartItems);

        req.setAttribute("cartItems", cartItems);
        RequestDispatcher rd = req.getRequestDispatcher("shoppingCart.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            System.out.println("User ID is null. Redirecting to login page.");
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");

        try (Connection connection = dataSource.getConnection()) {
            if ("add".equals(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                addProductToCart(connection, userId, productId, quantity);

            } else if ("update".equals(action)) {
                int cartId = Integer.parseInt(req.getParameter("cartId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                updateCartQuantity(connection, cartId, quantity);

            } else if ("remove".equals(action)) {
                int cartId = Integer.parseInt(req.getParameter("cartId"));
                removeProductFromCart(connection, cartId);
            }

            List<CartDTO> updatedCartItems = getCartItemsFromDatabase(connection, userId);
            session.setAttribute("cart", updatedCartItems);

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Error while updating the cart.");
            RequestDispatcher rd = req.getRequestDispatcher("errorPage.jsp");
            rd.forward(req, resp);
            return;
        }

        resp.sendRedirect("shoppingCart");
    }

    private List<CartDTO> getCartItemsFromDatabase(Connection connection, int userId) throws SQLException {
        List<CartDTO> cartItems = new ArrayList<>();
        String sql = "SELECT id, product_id, quantity FROM cart WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int productId = rs.getInt("product_id");
                ProductDTO product = getProductById(productId);
                int quantity = rs.getInt("quantity");
                BigDecimal totalPrice = product.getPrice().multiply(BigDecimal.valueOf(quantity));
                CartDTO cartItem = new CartDTO(
                        rs.getInt("id"),
                        userId,
                        product,
                        quantity,
                        totalPrice
                );
                cartItems.add(cartItem);
            }
        }
        return cartItems;
    }


    private ProductDTO getProductById(int productId) throws SQLException {
        ProductDTO product = null;
        try (Connection connection = dataSource.getConnection()) {
            String sql = "SELECT id, name, price FROM products WHERE id = ?";
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, productId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    product = new ProductDTO(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getBigDecimal("price")
                    );
                }
            }
        }
        return product;
    }

    private void addProductToCart(Connection connection, int userId, int productId, int quantity) throws SQLException {
        String sql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.executeUpdate();
        }
    }

    private void updateCartQuantity(Connection connection, int cartId, int quantity) throws SQLException {
        String sql = "UPDATE cart SET quantity = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
            ps.executeUpdate();
        }
    }

    private void removeProductFromCart(Connection connection, int cartId) throws SQLException {
        String sql = "DELETE FROM cart WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.executeUpdate();
        }
    }
}
