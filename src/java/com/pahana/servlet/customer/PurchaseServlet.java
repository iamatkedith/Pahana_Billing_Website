package com.pahana.servlet.customer;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.*;
import java.sql.*;
import org.json.*;

@WebServlet("/customer/PurchaseServlet")
public class PurchaseServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");

        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }

        JSONObject json = new JSONObject(sb.toString());
        String customerName = json.getString("customerName");
        String customerPhone = json.getString("customerPhone");
        JSONArray cartJson = json.getJSONArray("cart");

        if (customerName == null || customerPhone == null || cartJson == null) {
            response.getWriter().write("Missing parameters");
            return;
        }

        try {
            JSONArray cart = new JSONArray(cartJson);
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_billing1", "root", "");
            conn.setAutoCommit(false);

            double total = 0;
            for (int i = 0; i < cart.length(); i++) {
                JSONObject b = cart.getJSONObject(i);
                total += b.getDouble("price") * b.getInt("qty");
            }

            PreparedStatement psInvoice = conn.prepareStatement(
                    "INSERT INTO invoices(customer_name, customer_phone, total, payment, balance, payment_type) VALUES(?,?,?,?,?,?)",
                    Statement.RETURN_GENERATED_KEYS);
            psInvoice.setString(1, customerName);
            psInvoice.setString(2, customerPhone);
            psInvoice.setDouble(3, total);
            psInvoice.setDouble(4, total);
            psInvoice.setDouble(5, 0);
            psInvoice.setString(6, "Cash");
            psInvoice.executeUpdate();
            ResultSet rsKeys = psInvoice.getGeneratedKeys();
            int invoiceId = 0;
            if (rsKeys.next()) {
                invoiceId = rsKeys.getInt(1);
            }

            PreparedStatement psItem = conn.prepareStatement(
                    "INSERT INTO invoice_items(invoice_id, title, price, quantity, subtotal) VALUES(?,?,?,?,?)");
            PreparedStatement psStock = conn.prepareStatement(
                    "UPDATE books SET stock = stock - ? WHERE id = ? AND stock >= ?");

            for (int i = 0; i < cart.length(); i++) {
                JSONObject b = cart.getJSONObject(i);
                int id = b.getInt("id"), qty = b.getInt("qty");
                double price = b.getDouble("price");
                double subtotal = price * qty;

                psStock.setInt(1, qty);
                psStock.setInt(2, id);
                psStock.setInt(3, qty);
                int updated = psStock.executeUpdate();
                if (updated == 0) {
                    conn.rollback();
                    response.getWriter().write("Insufficient stock for " + b.getString("title"));
                    return;
                }

                psItem.setInt(1, invoiceId);
                psItem.setString(2, b.getString("title"));
                psItem.setDouble(3, price);
                psItem.setInt(4, qty);
                psItem.setDouble(5, subtotal);
                psItem.addBatch();
            }
            psItem.executeBatch();
            conn.commit();
            conn.close();
            response.getWriter().write("success");

        } catch (Exception e) {
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
