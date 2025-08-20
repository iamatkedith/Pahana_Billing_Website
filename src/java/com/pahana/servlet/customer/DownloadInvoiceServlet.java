/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pahana.servlet.customer;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.*;
import java.sql.*;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.Document;

@WebServlet("/customer/DownloadInvoiceServlet")
public class DownloadInvoiceServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Invoice_" + invoiceId + ".pdf");

        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_billing1","root","");

            PreparedStatement psInvoice = conn.prepareStatement("SELECT * FROM invoices WHERE invoice_id=?");
            psInvoice.setInt(1, invoiceId);
            ResultSet rsInvoice = psInvoice.executeQuery();

            if(rsInvoice.next()){
                Document document = new Document();
                PdfWriter.getInstance(document, response.getOutputStream());
                document.open();

                document.add(new Paragraph("Invoice ID: " + invoiceId));
                document.add(new Paragraph("Customer: " + rsInvoice.getString("customer_name")));
                document.add(new Paragraph("Phone: " + rsInvoice.getString("customer_phone")));
                document.add(new Paragraph("Total: LKR " + rsInvoice.getDouble("total")));
                document.add(new Paragraph("Payment: LKR " + rsInvoice.getDouble("payment")));
                document.add(new Paragraph("Balance: LKR " + rsInvoice.getDouble("balance")));
                document.add(new Paragraph(" "));

                PdfPTable table = new PdfPTable(4);
                table.addCell("Book");
                table.addCell("Qty");
                table.addCell("Price");
                table.addCell("Subtotal");

                PreparedStatement psItems = conn.prepareStatement("SELECT * FROM invoice_items WHERE invoice_id=?");
                psItems.setInt(1, invoiceId);
                ResultSet rsItems = psItems.executeQuery();
                while(rsItems.next()){
                    table.addCell(rsItems.getString("title"));
                    table.addCell(String.valueOf(rsItems.getInt("quantity")));
                    table.addCell(String.valueOf(rsItems.getDouble("price")));
                    table.addCell(String.valueOf(rsItems.getDouble("subtotal")));
                }
                document.add(table);
                document.close();
                rsItems.close();
            }
            rsInvoice.close();
            psInvoice.close();
            conn.close();
        } catch(Exception e){
            e.printStackTrace();
        }
    }
}