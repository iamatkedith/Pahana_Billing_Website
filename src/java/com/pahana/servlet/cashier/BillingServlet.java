/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pahana.servlet.cashier;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/BillingServlet")
public class BillingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final String DB_URL = "jdbc:mysql://localhost:3306/pahana_billing";
    private final String DB_USER = "root";
    private final String DB_PASS = "";

    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if("search".equals(action)) {
            String query = request.getParameter("query");
            List<Map<String, Object>> books = new ArrayList<>();
            try(Connection conn = getConnection()) {
                PreparedStatement ps = conn.prepareStatement("SELECT isbn,title,price FROM books WHERE title LIKE ?");
                ps.setString(1, "%" + query + "%");
                ResultSet rs = ps.executeQuery();
                while(rs.next()) {
                    Map<String,Object> b = new HashMap<>();
                    b.put("isbn", rs.getString("isbn"));
                    b.put("title", rs.getString("title"));
                    b.put("price", rs.getDouble("price"));
                    books.add(b);
                }
            } catch(Exception e) { e.printStackTrace(); }
            response.setContentType("application/json");
            response.getWriter().write(new JSONArray(books).toString());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while((line=reader.readLine())!=null) sb.append(line);
        JSONObject json = new JSONObject(sb.toString());

        String customerName = json.getString("customerName");
        String customerPhone = json.getString("customerPhone");
        double paid = json.getDouble("paid");
        JSONArray cart = json.getJSONArray("cart");

        double total = 0;
        for(int i=0;i<cart.length();i++) total += cart.getJSONObject(i).getDouble("subtotal");
        double balance = paid - total;
        int invoiceId = 0;

        try(Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            PreparedStatement psInvoice = conn.prepareStatement(
                "INSERT INTO invoices(customer_name, customer_phone, total, payment, balance) VALUES(?,?,?,?,?)",
                Statement.RETURN_GENERATED_KEYS);
            psInvoice.setString(1, customerName);
            psInvoice.setString(2, customerPhone);
            psInvoice.setDouble(3, total);
            psInvoice.setDouble(4, paid);
            psInvoice.setDouble(5, balance);
            psInvoice.executeUpdate();

            ResultSet rs = psInvoice.getGeneratedKeys();
            if(rs.next()) invoiceId = rs.getInt(1);

            PreparedStatement psItem = conn.prepareStatement(
                "INSERT INTO invoice_items(invoice_id, isbn, title, price, quantity, subtotal) VALUES(?,?,?,?,?,?)");
            for(int i=0;i<cart.length();i++) {
                JSONObject b = cart.getJSONObject(i);
                psItem.setInt(1, invoiceId);
                psItem.setString(2, b.getString("isbn"));
                psItem.setString(3, b.getString("title"));
                psItem.setDouble(4, b.getDouble("price"));
                psItem.setInt(5, b.getInt("qty"));
                psItem.setDouble(6, b.getDouble("subtotal"));
                psItem.addBatch();
            }
            psItem.executeBatch();
            conn.commit();
        } catch(Exception e) { e.printStackTrace(); }

        JSONObject res = new JSONObject();
        res.put("invoiceId", invoiceId);
        response.setContentType("application/json");
        response.getWriter().write(res.toString());
    }
}