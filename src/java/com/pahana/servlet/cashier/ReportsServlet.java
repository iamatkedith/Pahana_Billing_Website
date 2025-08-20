/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pahana.servlet.cashier;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.google.gson.Gson;

@WebServlet("/cashier/ReportsServlet")
public class ReportsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String type = request.getParameter("type");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/pahana_billing", "root", "");

            // ---------------- GET UNIQUE CUSTOMER NAMES ----------------
            if ("getCustomers".equals(type)) {
                String sql = "SELECT DISTINCT customer_name FROM invoices ORDER BY customer_name ASC";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);
                List<String> customers = new ArrayList<>();
                while (rs.next()) {
                    customers.add(rs.getString("customer_name"));
                }
                rs.close();
                stmt.close();
                out.print(new Gson().toJson(customers));
            }

            // ---------------- CUSTOMER HISTORY ----------------
            else if ("customerHistory".equals(type)) {
                String customerName = request.getParameter("customerName");
                String sql = "SELECT invoice_id, customer_name, customer_phone, total, payment, balance " +
                             "FROM invoices WHERE 1=1";
                if (customerName != null && !customerName.isEmpty()) {
                    sql += " AND customer_name=?";
                }

                PreparedStatement ps = conn.prepareStatement(sql);
                if (customerName != null && !customerName.isEmpty()) {
                    ps.setString(1, customerName);
                }

                ResultSet rs = ps.executeQuery();
                List<Map<String, Object>> data = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("invoice_id", rs.getInt("invoice_id"));
                    row.put("customer_name", rs.getString("customer_name"));
                    row.put("customer_phone", rs.getString("customer_phone"));
                    row.put("total", rs.getDouble("total"));
                    row.put("payment", rs.getDouble("payment"));
                    row.put("balance", rs.getDouble("balance"));
                    data.add(row);
                }
                rs.close();
                ps.close();
                out.print(new Gson().toJson(data));
            }

            // ---------------- STOCK DETAILS ----------------
            else if ("stockDetails".equals(type)) {
                String sql = "SELECT b.isbn, b.title, b.price, b.stock, " +
                             "IFNULL(SUM(ii.quantity),0) AS sold_qty " +
                             "FROM books b LEFT JOIN invoice_items ii ON b.title = ii.title " +
                             "GROUP BY b.id, b.isbn, b.title, b.price, b.stock";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);
                List<Map<String, Object>> data = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("isbn", rs.getString("isbn"));
                    row.put("title", rs.getString("title"));
                    row.put("price", rs.getDouble("price"));
                    row.put("stock_available", rs.getInt("stock") - rs.getInt("sold_qty"));
                    data.add(row);
                }
                rs.close();
                stmt.close();
                out.print(new Gson().toJson(data));
            }

            // ---------------- SALES REPORT ----------------
            else if ("salesReport".equals(type)) {
                String paymentType = request.getParameter("paymentType");
                String month = request.getParameter("month"); // format yyyy-MM

                String sql = "SELECT invoice_id, customer_name, total, payment, balance, payment_type AS payment_type, DATE(created_at) AS created_at " +
                             "FROM invoices WHERE 1=1";

                if (paymentType != null && !paymentType.isEmpty()) {
                    sql += " AND payment_type=?";
                }
                if (month != null && !month.isEmpty()) {
                    sql += " AND DATE_FORMAT(created_at,'%Y-%m')=?";
                }

                PreparedStatement ps = conn.prepareStatement(sql);
                int idx = 1;
                if (paymentType != null && !paymentType.isEmpty()) {
                    ps.setString(idx++, paymentType);
                }
                if (month != null && !month.isEmpty()) {
                    ps.setString(idx++, month);
                }

                ResultSet rs = ps.executeQuery();
                List<Map<String, Object>> data = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("invoice_id", rs.getInt("invoice_id"));
                    row.put("customer_name", rs.getString("customer_name"));
                    row.put("total", rs.getDouble("total"));
                    row.put("payment", rs.getDouble("payment"));
                    row.put("balance", rs.getDouble("balance"));
                    row.put("payment_type", rs.getString("payment_type"));
                    row.put("created_at", rs.getString("created_at"));
                    data.add(row);
                }
                rs.close();
                ps.close();
                out.print(new Gson().toJson(data));
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}