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
import java.sql.ResultSet;

@WebServlet("/cashier/UpdateBookServlet")
public class UpdateBookServlet extends HttpServlet {

    // Show the book details in the edit form
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/books.jsp?error=Book ID missing.");
            return;
        }

        int id = Integer.parseInt(idStr);
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/pahana_billing", "root", "");
            PreparedStatement ps = con.prepareStatement("SELECT * FROM books WHERE id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                request.setAttribute("book", rs);
                request.getRequestDispatcher("/admin/editBook.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/books.jsp?error=Book not found.");
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/books.jsp?error=An error occurred!");
        }
    }

    // Handle the update after form submission
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String isbn = request.getParameter("isbn");
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String publisher = request.getParameter("publisher");
            int year = Integer.parseInt(request.getParameter("year"));
            String edition = request.getParameter("edition");
            int stock = Integer.parseInt(request.getParameter("stock"));
            double price = Double.parseDouble(request.getParameter("price"));
            double discount = Double.parseDouble(request.getParameter("discount"));

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/pahana_billing", "root", "");
            String sql = "UPDATE books SET isbn=?, title=?, author=?, publisher=?, year=?, edition=?, stock=?, price=?, discount=? WHERE id=?";
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
            ps.setInt(10, id);

            int i = ps.executeUpdate();
            ps.close();
            con.close();

            if (i > 0) {
                response.sendRedirect(request.getContextPath() + "/cashier/books.jsp?success=Book updated successfully!");
            } else {
                response.sendRedirect(request.getContextPath() + "/cashier/books.jsp?error=Failed to update book.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cashier/books.jsp?error=An error occurred!");
        }
    }
}
