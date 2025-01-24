package org.example.assignmentee;

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
    // Handle GET requests to display order-related information (products, prices, etc.)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("GET request received for /placeOrder");

        // Get the user's session
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("User ID from session: " + userId);  // Log user ID


        // If user ID is not found, redirect to login page
        if (userId == null) {
            System.out.println("User not logged in, redirecting to login page.");
            response.sendRedirect("login.jsp");
            return;
        }

        // Get the cart items from session
        List<CartDTO> cartItems = (List<CartDTO>) session.getAttribute("cart");
        System.out.println("Cart Items: " + (cartItems != null ? cartItems.size() : 0));  // Log cart items count


        // If cart is empty, redirect to error page
        if (cartItems == null || cartItems.isEmpty()) {
            System.out.println("Cart is empty, redirecting to error page.");
            response.sendRedirect("error.jsp");
            return;
        }

        // Calculate total order amount
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartDTO cartItem : cartItems) {
            totalAmount = totalAmount.add(cartItem.getTotalPrice());
        }

        // Set attributes for the JSP page to display
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);

        // Forward to the Place Order page (JSP)
        RequestDispatcher dispatcher = request.getRequestDispatcher("placeOrder.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("POST request received for /placeOrder");

        // Get the user's session
        HttpSession session = request.getSession();
        List<CartDTO> cartItems = (List<CartDTO>) session.getAttribute("cart");

        // If cart is empty, redirect to error page
        if (cartItems == null || cartItems.isEmpty()) {
            System.out.println("Cart is empty, redirecting to error page.");
            response.sendRedirect("error.jsp");
            return;
        }

        // Get user ID from session
        Integer userId = (Integer) session.getAttribute("userId");

        // If user ID is not found, redirect to shopping cart
        if (userId == null) {
            System.out.println("User not logged in, redirecting to shopping cart.");
            response.sendRedirect("shoppingCart");
            return;
        }

        // Calculate total order amount
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartDTO cartItem : cartItems) {
            totalAmount = totalAmount.add(cartItem.getTotalPrice());
        }

        // Database connection setup
        Connection connection = null;
        PreparedStatement orderStmt = null;
        PreparedStatement orderDetailStmt = null;
        PreparedStatement clearCartStmt = null;

        try {
            // Get database connection from the pool
            connection = dataSource.getConnection();
            connection.setAutoCommit(false); // Start transaction

            // Insert into orders table
            String orderQuery = "INSERT INTO orders (user_id, order_date, total, status) VALUES (?, NOW(), ?, 'Pending')";
            orderStmt = connection.prepareStatement(orderQuery, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, userId);
            orderStmt.setBigDecimal(2, totalAmount);

            int affectedRows = orderStmt.executeUpdate();
            if (affectedRows == 0) {
                System.out.println("Order insertion failed, rolling back transaction.");
                connection.rollback();
                throw new SQLException("Creating order failed, no rows affected.");
            }

            // Get the generated order ID
            ResultSet generatedKeys = orderStmt.getGeneratedKeys();
            int orderId = 0;
            if (generatedKeys.next()) {
                orderId = generatedKeys.getInt(1);
                System.out.println("Order ID generated: " + orderId);
            } else {
                System.out.println("Order ID generation failed, rolling back transaction.");
                connection.rollback();
                throw new SQLException("Order creation failed, no ID obtained.");
            }

            // Insert into order_details table for each cart item
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

            // Execute batch insert for order details
            orderDetailStmt.executeBatch();

            // Clear cart items from database if stored in a table (optional)
            String clearCartQuery = "DELETE FROM cart WHERE user_id = ?";
            clearCartStmt = connection.prepareStatement(clearCartQuery);
            clearCartStmt.setInt(1, userId);
            clearCartStmt.executeUpdate();

            // Commit transaction
            connection.commit();
            System.out.println("Transaction committed successfully.");

            // Clear the cart in the session
            session.removeAttribute("cart");

            // Set attributes for the JSP to show order details
            request.setAttribute("orderId", orderId);
            request.setAttribute("orderDate", new java.util.Date());
            request.setAttribute("status", "Pending");
            request.setAttribute("totalAmount", totalAmount);

            // Add success alert and navigate back to placeOrder page
            String successMessage = "Order placed successfully!";
            request.setAttribute("successMessage", successMessage);

            // Forward to placeOrder page with the success alert
            RequestDispatcher dispatcher = request.getRequestDispatcher("orderConfirmation.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            // Rollback transaction if any error occurs
            if (connection != null) {
                try {
                    connection.rollback();
                    System.out.println("Transaction rolled back.");
                } catch (SQLException ex) {
                    ex.printStackTrace();  // More specific logging for rollback error
                }
            }
            // Log detailed error and forward to shoppingCart page
            System.out.println("Error occurred: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while processing your order. Please try again.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("shoppingCart.jsp");
            dispatcher.forward(request, response);
        } finally {
            // Clean up database resources
            try {
                if (orderStmt != null) orderStmt.close();
                if (orderDetailStmt != null) orderDetailStmt.close();
                if (clearCartStmt != null) clearCartStmt.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();  // Log closing errors
            }
        }
    }

}

