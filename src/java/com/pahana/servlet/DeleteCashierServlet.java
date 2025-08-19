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

@WebServlet("/admin/DeleteCashierServlet")
public class DeleteCashierServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/pahana_billing","root","");
            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM cashiers WHERE id=?");
            ps.setInt(1, id);

            int result = ps.executeUpdate();
            ps.close();
            con.close();

            if(result > 0) {
                response.sendRedirect("cashiers.jsp?success=Cashier deleted successfully!");
            } else {
                response.sendRedirect("cashiers.jsp?error=Failed to delete cashier.");
            }

        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("cashiers.jsp?error=" + e.getMessage());
        }
    }
}