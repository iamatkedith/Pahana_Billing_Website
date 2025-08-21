/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pahana.servlet.admin;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

@WebServlet("/admin/UpdateCustomerServlet")
public class UpdateCustomerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/pahana_billing1", "root", "");
            con.setAutoCommit(false);

            // 1. Get user_id from customers table
            PreparedStatement psGetUser = con.prepareStatement("SELECT user_id FROM customers WHERE id=?");
            psGetUser.setInt(1, id);
            ResultSet rs = psGetUser.executeQuery();
            int userId = -1;
            if (rs.next()) {
                userId = rs.getInt("user_id");
            } else {
                con.rollback();
                response.sendRedirect(request.getContextPath() + "/admin/customers.jsp?error=Customer not found!");
                return;
            }
            rs.close();
            psGetUser.close();

            // 2. Update users table
            String userSql;
            if (password != null && !password.isEmpty()) {
                userSql = "UPDATE users SET username=?, password=? WHERE id=?";
            } else {
                userSql = "UPDATE users SET username=? WHERE id=?";
            }
            PreparedStatement psUser = con.prepareStatement(userSql);
            psUser.setString(1, username);
            if (password != null && !password.isEmpty()) {
                psUser.setString(2, password);
                psUser.setInt(3, userId);
            } else {
                psUser.setInt(2, userId);
            }
            psUser.executeUpdate();
            psUser.close();

            // 3. Update customers table
            String customerSql = "UPDATE customers SET full_name=?, email=?, phone=?, address=? WHERE id=?";
            PreparedStatement psCustomer = con.prepareStatement(customerSql);
            psCustomer.setString(1, fullName);
            psCustomer.setString(2, email);
            psCustomer.setString(3, phone);
            psCustomer.setString(4, address);
            psCustomer.setInt(5, id);
            psCustomer.executeUpdate();
            psCustomer.close();

            con.commit();
            con.close();
            response.sendRedirect(request.getContextPath() + "/admin/customers.jsp?success=Customer updated successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/customers.jsp?error=An error occurred!");
        }
    }
}