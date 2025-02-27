package org.example.assignmentee;

import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if ("admin1@gmail.com".equals(email) && "admin123".equals(password)) {
            HttpSession session = request.getSession();
            session.setAttribute("userId", 0);
            session.setAttribute("username", "Admin");
            response.sendRedirect("index");
            return;
        }

        String query = "SELECT id, username, password, status FROM users WHERE email = ?";

        try (Connection connection = dataSource.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, email);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                String status = resultSet.getString("status");

                if ("Inactive".equalsIgnoreCase(status)) {
                    request.setAttribute("errorMessage", "Your account is inactive. Please contact support.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                int userId = resultSet.getInt("id");
                String username = resultSet.getString("username");
                String hashedPassword = resultSet.getString("password");

                if (BCrypt.checkpw(password, hashedPassword)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", userId);
                    session.setAttribute("username", username);
                    session.setAttribute("isLoggedIn", true);
                    response.sendRedirect("productBrowsing");
                } else {
                    request.setAttribute("errorMessage", "Invalid email or password.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Invalid email or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
