package org.example.assignmentee.adminControllers;

import DTO.CategoryDTO;
import jakarta.annotation.Resource;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CategoryServlet", value = "/adminHome")
public class CategoryServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<CategoryDTO> categoryDTOList = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = dataSource.getConnection();
            String sql = "SELECT * FROM categories";
            Statement stm = connection.createStatement();
            ResultSet rst = stm.executeQuery(sql);

            while (rst.next()) {
                CategoryDTO categoryDTO = new CategoryDTO(
                        rst.getInt("id"),
                        rst.getString("name"),
                        rst.getString("description")
                );
                categoryDTOList.add(categoryDTO);
            }

            System.out.println("Retrieved categories: " + categoryDTOList);

            req.setAttribute("categories", categoryDTOList);
            RequestDispatcher rd = req.getRequestDispatcher("adminHome.jsp");
            rd.forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}
