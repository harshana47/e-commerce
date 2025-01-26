package org.example.assignmentee.customerControllers;

import DTO.CartDTO;
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
import java.util.List;

@WebServlet(name = "PlaceOrderServlet", value = "/placeOrder")
public class PlaceOrderServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("GET request received for /placeOrder");

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("User ID from session: " + userId);  // Log user ID


        if (userId == null) {
            System.out.println("User not logged in, redirecting to login page.");
            response.sendRedirect("login.jsp");
            return;
        }

        List<CartDTO> cartItems = (List<CartDTO>) session.getAttribute("cart");
        System.out.println("Cart Items: " + (cartItems != null ? cartItems.size() : 0));  // Log cart items count


        if (cartItems == null || cartItems.isEmpty()) {
            System.out.println("Cart is empty, redirecting to error page.");
            response.sendRedirect("error.jsp");
            return;
        }

        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartDTO cartItem : cartItems) {
            totalAmount = totalAmount.add(cartItem.getTotalPrice());
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);

        RequestDispatcher dispatcher = request.getRequestDispatcher("placeOrder.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("POST request received for /placeOrder");
        boolean orderPlaced = false;

        HttpSession session = request.getSession();
        List<CartDTO> cartItems = (List<CartDTO>) session.getAttribute("cart");

        if (cartItems == null || cartItems.isEmpty()) {
            System.out.println("Cart is empty, redirecting to error page.");
            response.sendRedirect("error.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            System.out.println("User not logged in, redirecting to shopping cart.");
            response.sendRedirect("shoppingCart");
            return;
        }

        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartDTO cartItem : cartItems) {
            totalAmount = totalAmount.add(cartItem.getTotalPrice());
        }

        Connection connection = null;
        PreparedStatement orderStmt = null;
        PreparedStatement orderDetailStmt = null;
        PreparedStatement clearCartStmt = null;
        PreparedStatement updateProductStmt = null;

        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);

            String orderQuery = "INSERT INTO orders (user_id, order_date, total, status) VALUES (?, NOW(), ?, 'Pending')";
            orderStmt = connection.prepareStatement(orderQuery, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, userId);
            orderStmt.setBigDecimal(2, totalAmount);
            int affectedRows = orderStmt.executeUpdate();

            if (affectedRows == 0) {
                connection.rollback();
                throw new SQLException("Creating order failed, no rows affected.");
            }

            ResultSet generatedKeys = orderStmt.getGeneratedKeys();
            int orderId = 0;
            if (generatedKeys.next()) {
                orderId = generatedKeys.getInt(1);
            } else {
                connection.rollback();
                throw new SQLException("Order creation failed, no ID obtained.");
            }

            String orderDetailQuery = "INSERT INTO order_details (order_id, product_id, quantity, price, user_id) VALUES (?, ?, ?, ?, ?)";
            orderDetailStmt = connection.prepareStatement(orderDetailQuery);

            for (CartDTO cartItem : cartItems) {
                orderDetailStmt.setInt(1, orderId);
                orderDetailStmt.setInt(2, cartItem.getProduct().getId());
                orderDetailStmt.setInt(3, cartItem.getQuantity());
                orderDetailStmt.setBigDecimal(4, cartItem.getTotalPrice());
                orderDetailStmt.setInt(5, userId);
                orderDetailStmt.addBatch();
            }

            orderDetailStmt.executeBatch();

            String updateProductQuery = "UPDATE products SET stock = stock - ? WHERE id = ?";
            updateProductStmt = connection.prepareStatement(updateProductQuery);

            for (CartDTO cartItem : cartItems) {
                updateProductStmt.setInt(1, cartItem.getQuantity());
                updateProductStmt.setInt(2, cartItem.getProduct().getId());
                updateProductStmt.addBatch();
            }

            updateProductStmt.executeBatch();

            String clearCartQuery = "DELETE FROM cart WHERE user_id = ?";
            clearCartStmt = connection.prepareStatement(clearCartQuery);
            clearCartStmt.setInt(1, userId);
            clearCartStmt.executeUpdate();

            connection.commit();
            System.out.println("Transaction committed successfully.");

            session.removeAttribute("cart");

            request.setAttribute("orderId", orderId);
            request.setAttribute("orderDate", new java.util.Date());
            request.setAttribute("status", "Pending");
            request.setAttribute("totalAmount", totalAmount);

            String successMessage = "Order placed successfully!";
            request.setAttribute("orderPlaced", true);
            request.setAttribute("successMessage", successMessage);

            RequestDispatcher dispatcher = request.getRequestDispatcher("orderConfirmation.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                    System.out.println("Transaction rolled back.");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while processing your order. Please try again.");
            request.setAttribute("orderPlaced", false);
            RequestDispatcher dispatcher = request.getRequestDispatcher("shoppingCart.jsp");
            dispatcher.forward(request, response);
        } finally {
            try {
                if (orderStmt != null) orderStmt.close();
                if (orderDetailStmt != null) orderDetailStmt.close();
                if (clearCartStmt != null) clearCartStmt.close();
                if (updateProductStmt != null) updateProductStmt.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

