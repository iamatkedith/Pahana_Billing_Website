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
import java.sql.*;

@WebServlet("/admin/UpdateCashierServlet")
public class UpdateCashierServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/pahana_billing","root","");

            PreparedStatement ps;
            if(password != null && !password.isEmpty()) {
                ps = con.prepareStatement(
                    "UPDATE cashiers SET name=?, email=?, phone=?, username=?, password=? WHERE id=?");
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, phone);
                ps.setString(4, username);
                ps.setString(5, password); // hash if needed
                ps.setInt(6, id);
            } else {
                ps = con.prepareStatement(
                    "UPDATE cashiers SET name=?, email=?, phone=?, username=? WHERE id=?");
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, phone);
                ps.setString(4, username);
                ps.setInt(5, id);
            }

            int result = ps.executeUpdate();
            ps.close();
            con.close();

            if(result > 0) {
                response.sendRedirect("cashiers.jsp?success=Cashier updated successfully!");
            } else {
                response.sendRedirect("cashiers.jsp?error=Failed to update cashier.");
            }

        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("cashiers.jsp?error=" + e.getMessage());
        }
    }
}
