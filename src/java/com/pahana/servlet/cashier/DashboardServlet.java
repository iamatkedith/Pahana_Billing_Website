/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pahana.servlet.cashier;

import com.pahana.db.DBConnection;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/cashier/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject json = new JSONObject();

        try (Connection conn = DBConnection.getConnection()) {

            // Total Sales
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT SUM(total) AS totalSales FROM invoices");
            json.put("totalSales", rs.next() ? rs.getDouble("totalSales") : 0);

            // Total Invoices
            rs = st.executeQuery("SELECT COUNT(*) AS totalInvoices FROM invoices");
            json.put("totalInvoices", rs.next() ? rs.getInt("totalInvoices") : 0);

            // Total Books Sold
            rs = st.executeQuery("SELECT SUM(quantity) AS booksSold FROM invoice_items");
            json.put("booksSold", rs.next() ? rs.getInt("booksSold") : 0);

            // Low Stock Items
            rs = st.executeQuery("SELECT COUNT(*) AS lowStock FROM books WHERE stock < 10");
            json.put("lowStockItems", rs.next() ? rs.getInt("lowStock") : 0);

            // Last 7 Days Sales
            rs = st.executeQuery(
                "SELECT DATE(created_at) AS day, SUM(total) AS sales FROM invoices " +
                "WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) " +
                "GROUP BY DATE(created_at)"
            );
            JSONArray dailySales = new JSONArray();
            while(rs.next()) {
                JSONObject day = new JSONObject();
                day.put("date", rs.getDate("day").toString());
                day.put("sales", rs.getDouble("sales"));
                dailySales.put(day);
            }
            json.put("dailySales", dailySales);

            out.print(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            json.put("error", e.getMessage());
            out.print(json.toString());
        }
    }
}