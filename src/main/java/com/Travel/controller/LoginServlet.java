package com.Travel.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/travel_platform?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "password";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            if ("SIGNUP".equals(action)) {
                PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM users WHERE email = ?");
                checkStmt.setString(1, email);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    request.setAttribute("errorMessage", "Error: Email ID already exists! Please go to Login.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                } else {
                    // FIXED: Added 'name' to the query and passing a default value so MySQL accepts it
                    PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
                    insertStmt.setString(1, "Traveler"); // Fills the missing 'name' field
                    insertStmt.setString(2, email);
                    insertStmt.setString(3, password);
                    insertStmt.executeUpdate();

                    session.setAttribute("loggedUser", email);
                    response.sendRedirect("dashboard.jsp");
                }
            } else if ("LOGIN".equals(action)) {
                PreparedStatement loginStmt = conn.prepareStatement("SELECT * FROM users WHERE email = ? AND password = ?");
                loginStmt.setString(1, email);
                loginStmt.setString(2, password);
                ResultSet rs = loginStmt.executeQuery();

                if (rs.next()) {
                    session.setAttribute("loggedUser", email);
                    response.sendRedirect("dashboard.jsp");
                } else {
                    request.setAttribute("errorMessage", "Error: Invalid email/password, or user does not exist. Sign up first!");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else if ("GOOGLE".equals(action)) {
                PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM users WHERE email = ?");
                checkStmt.setString(1, email);
                ResultSet rs = checkStmt.executeQuery();

                if (!rs.next()) {
                    // FIXED: Added 'name' here as well
                    PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
                    insertStmt.setString(1, "Google User");
                    insertStmt.setString(2, email);
                    insertStmt.setString(3, "GOOGLE_AUTH_SSO");
                    insertStmt.executeUpdate();
                }
                session.setAttribute("loggedUser", email);
                response.sendRedirect("dashboard.jsp");
            }
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "SYSTEM ERROR: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}