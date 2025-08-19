/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pahana.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;


@WebServlet("/admin/AddCashierServlet")
public class AddCashierServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/pahana_billing", "root", "");

            String sql = "INSERT INTO cashiers(name,email,phone,username,password) VALUES(?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, username);
            ps.setString(5, password); // hash password if needed

            int result = ps.executeUpdate();
            ps.close();
            con.close();

            if (result > 0) {
                response.sendRedirect("cashiers.jsp?success=Cashier added successfully!");
            } else {
                response.sendRedirect("cashiers.jsp?error=Failed to add cashier.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cashiers.jsp?error=" + e.getMessage());
        }
    }
}