/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pahana.servlet.cashier;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

@WebServlet("/cashier/AddCustomerServlet")
public class AddCustomerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

            // 1. Insert into users table
            String userSql = "INSERT INTO users (username, password, role, created_at) VALUES (?, ?, 'customer', NOW())";
            PreparedStatement psUser = con.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, username);
            psUser.setString(2, password);
            int userInserted = psUser.executeUpdate();

            if (userInserted == 0) {
                con.rollback();
                response.sendRedirect(request.getContextPath() + "/cashier/customers.jsp?error=Failed to add user!");
                return;
            }

            ResultSet rs = psUser.getGeneratedKeys();
            int userId = -1;
            if (rs.next()) {
                userId = rs.getInt(1);
            } else {
                con.rollback();
                response.sendRedirect(request.getContextPath() + "/cashier/customers.jsp?error=Failed to retrieve user ID!");
                return;
            }
            rs.close();
            psUser.close();

            // 2. Insert into customers table
            String customerSql = "INSERT INTO customers (user_id, full_name, email, phone, address, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
            PreparedStatement psCustomer = con.prepareStatement(customerSql);
            psCustomer.setInt(1, userId);
            psCustomer.setString(2, fullName);
            psCustomer.setString(3, email);
            psCustomer.setString(4, phone);
            psCustomer.setString(5, address);

            int customerInserted = psCustomer.executeUpdate();
            psCustomer.close();

            if (customerInserted > 0) {
                con.commit(); // commit transaction
                response.sendRedirect(request.getContextPath() + "/cashier/customers.jsp?success=Customer added successfully!");
            } else {
                con.rollback();
                response.sendRedirect(request.getContextPath() + "/cashier/customers.jsp?error=Failed to add customer!");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cashier/customers.jsp?error=An error occurred!");
        }
    }
}
