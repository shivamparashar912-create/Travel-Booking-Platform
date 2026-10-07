package com.Travel.controller;

import com.Travel.dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Security: Ensure user is actually logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String email = (String) session.getAttribute("loggedUser");
        String destination = request.getParameter("destination");
        String travelDate = request.getParameter("travelDate");
        String travellers = request.getParameter("travellers");

        BookingDAO bookingDao = new BookingDAO();
        boolean success = bookingDao.createBooking(email, destination, travelDate, travellers);

        if (success) {
            request.setAttribute("bookingSuccess", "Success! Your trip to " + destination + " has been booked.");
        } else {
            request.setAttribute("bookingError", "Failed to book your trip. Please try again.");
        }

        // Send them back to the dashboard to see the message
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}