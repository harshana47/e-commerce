package org.example.assignmentee;

import DTO.OrderDetailDTO;
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
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CustomerOrderDetailsServlet", value = "/viewAllOrders")
public class CustomerOrderDetailsServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<OrderDetailDTO> orderDetails = new ArrayList<>();

        String query = """
                SELECT o.id AS order_id, od.product_id, od.quantity, od.price, 
                       o.order_date, o.total, o.user_id
                FROM orders o
                JOIN order_details od ON o.id = od.order_id
                """;

        try (Connection connection = dataSource.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                OrderDetailDTO orderDetail = new OrderDetailDTO(
                        resultSet.getInt("order_id"),
                        resultSet.getInt("product_id"),
                        resultSet.getInt("quantity"),
                        resultSet.getDouble("price"),
                        resultSet.getString("order_date"),
                        resultSet.getDouble("total"),
                        resultSet.getInt("user_id")
                );
                orderDetails.add(orderDetail);
            }

            request.setAttribute("orderDetails", orderDetails);
            request.getRequestDispatcher("viewAllOrders.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminHome.jsp?message=Error retrieving order details");
        }
    }
}
