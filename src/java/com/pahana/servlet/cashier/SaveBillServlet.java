
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pahana.servlet.cashier;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/servlet/cashier/SaveBillServlet")
public class SaveBillServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        StringBuilder sb = new StringBuilder();
        String line;

        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        } catch (Exception e) {
            out.print("{\"status\":\"error\",\"message\":\"Invalid request\"}");
            return;
        }

        try {
            JSONObject data = new JSONObject(sb.toString());
            String customerName = data.getString("customerName");
            String customerPhone = data.getString("customerContact");
            double totalAmount = data.getDouble("totalAmount");
            double paidAmount = data.getDouble("paidAmount");
            double balance = data.getDouble("balance");
            JSONArray cartItems = data.getJSONArray("cartItems");

            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_billing1", "root", "")) {

                conn.setAutoCommit(false);

                // Insert invoice (header)
                String insertInvoiceSQL = "INSERT INTO invoices(customer_name, customer_phone, total, payment, balance) VALUES(?,?,?,?,?)";
                PreparedStatement psInvoice = conn.prepareStatement(insertInvoiceSQL, Statement.RETURN_GENERATED_KEYS);
                psInvoice.setString(1, customerName);
                psInvoice.setString(2, customerPhone);
                psInvoice.setDouble(3, totalAmount);
                psInvoice.setDouble(4, paidAmount);
                psInvoice.setDouble(5, balance);
                psInvoice.executeUpdate();

                ResultSet rsKeys = psInvoice.getGeneratedKeys();
                int invoiceId = 0;
                if (rsKeys.next()) {
                    invoiceId = rsKeys.getInt(1);
                }
                psInvoice.close();

                // Insert invoice items (details)
                String insertItemSQL = "INSERT INTO invoice_items(invoice_id, title, price, quantity, subtotal) VALUES(?,?,?,?,?)";
                PreparedStatement psItem = conn.prepareStatement(insertItemSQL);
                for (int i = 0; i < cartItems.length(); i++) {
                    JSONObject item = cartItems.getJSONObject(i);
                    psItem.setInt(1, invoiceId);                      // invoice_id
                    psItem.setString(2, item.getString("name"));      // title
                    psItem.setDouble(3, item.getDouble("price"));     // price
                    psItem.setInt(4, item.getInt("qty"));            // quantity
                    psItem.setDouble(5, item.getInt("qty") * item.getDouble("price")); // subtotal
                    psItem.addBatch();
                
            }
            psItem.executeBatch();
            psItem.close();

            conn.commit();

            // Return success JSON with invoice redirect
            JSONObject json = new JSONObject();
            json.put("status", "success");
            json.put("redirect", "../cashier/invoice_preview.jsp?invoice_id=" + invoiceId);
            out.print(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"status\":\"error\",\"message\":\"DB Error: " + e.getMessage() + "\"}");
        }

    }
    catch (Exception e

    
        ) {
            e.printStackTrace();
        out.print("{\"status\":\"error\",\"message\":\"JSON Parse Error\"}");
    }
}
}
