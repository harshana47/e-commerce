package org.example.assignmentee;

import DTO.OrderDTO;
import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OrderHistoryServlet", value = "/orderHistory")
public class OrderHistoryServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?message=Please login to view orders");
            return;
        }
        int userId = (int) session.getAttribute("userId");

        List<OrderDTO> orders = new ArrayList<>();
        String query = "SELECT id, order_date, total FROM orders WHERE user_id = ?";

        try (Connection connection = dataSource.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                OrderDTO order = new OrderDTO(
                        resultSet.getInt("id"),
                        resultSet.getString("order_date"),
                        resultSet.getDouble("total")
                );
                orders.add(order);
            }

            request.setAttribute("orders", orders);
            request.getRequestDispatcher("orderHistory.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp?message=Error retrieving orders");
        }
    }
}
