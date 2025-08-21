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


@WebServlet("/cashier/DeleteCustomerServlet")
public class DeleteCustomerServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

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
                response.sendRedirect(request.getContextPath() + "/cashier/customers.jsp?error=Customer not found!");
                return;
            }
            rs.close();
            psGetUser.close();

            // 2. Delete from customers table
            PreparedStatement psCustomer = con.prepareStatement("DELETE FROM customers WHERE id=?");
            psCustomer.setInt(1, id);
            psCustomer.executeUpdate();
            psCustomer.close();

            // 3. Delete from users table
            PreparedStatement psUser = con.prepareStatement("DELETE FROM users WHERE id=?");
            psUser.setInt(1, userId);
            psUser.executeUpdate();
            psUser.close();

            con.commit();
            con.close();
            response.sendRedirect(request.getContextPath() + "/cashier/customers.jsp?success=Customer deleted successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cashier/customers.jsp?error=An error occurred!");
        }
    }
}