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
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;


@WebServlet("/cashier/AddBookServlet")
public class AddBookServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String isbn = request.getParameter("isbn");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String publisher = request.getParameter("publisher");
        int year = Integer.parseInt(request.getParameter("year"));
        String edition = request.getParameter("edition");
        int stock = Integer.parseInt(request.getParameter("stock"));
        double price = Double.parseDouble(request.getParameter("price"));
        double discount = Double.parseDouble(request.getParameter("discount"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_billing", "root", "");
            String sql = "INSERT INTO books(isbn,title,author,publisher,year,edition,stock,price,discount) VALUES(?,?,?,?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, isbn);
            ps.setString(2, title);
            ps.setString(3, author);
            ps.setString(4, publisher);
            ps.setInt(5, year);
            ps.setString(6, edition);
            ps.setInt(7, stock);
            ps.setDouble(8, price);
            ps.setDouble(9, discount);
            int i = ps.executeUpdate();
            ps.close();
            con.close();

            if(i > 0) {
                response.sendRedirect("books.jsp?success=Book added successfully!");
            } else {
                response.sendRedirect("books.jsp?error=Failed to add book.");
            }

        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("books.jsp?error=An error occurred!");
        }
    }
}
