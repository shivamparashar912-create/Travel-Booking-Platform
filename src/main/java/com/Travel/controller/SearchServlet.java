package com.Travel.controller;

import com.Travel.model.Flight;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { doPost(request, response); }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String travelClass = request.getParameter("travelClass");
        String serviceType = request.getParameter("serviceType");
        String duration = request.getParameter("duration"); // Dynamic user input

        if (destination == null || destination.trim().isEmpty()) destination = "Goa";
        if (travelClass == null) travelClass = "Economy";
        if (serviceType == null) serviceType = "Flight";
        if (duration == null) duration = "5";

        double priceMult = travelClass.equals("Premium") ? 2.5 : 1.0;
        List<Flight> listings = new ArrayList<>();

        // Massive, Service-Specific Inventory & Pricing
        if (serviceType.equals("Flight")) {
            listings.add(new Flight("Vistara Airlines", "UK-988", "08:30 AM", "11:00 AM", "Non-Stop", (int)(5400 * priceMult)));
            listings.add(new Flight("Air India", "AI-214", "11:15 AM", "01:45 PM", "1-Stop", (int)(4800 * priceMult)));
            listings.add(new Flight("IndiGo", "6E-554", "04:00 PM", "06:15 PM", "Non-Stop", (int)(3900 * priceMult)));
        } else if (serviceType.equals("Hotel")) {
            listings.add(new Flight("Taj Exotica Resort", "Luxury", "Check-in: 2PM", "Check-out: 11AM", "Top Rated", (int)(15000 * priceMult)));
            listings.add(new Flight("Marriott Courtyard", "Premium", "Check-in: 3PM", "Check-out: 12PM", "Poolside", (int)(9000 * priceMult)));
        } else if (serviceType.equals("Homestay")) {
            listings.add(new Flight("Beachfront Villa", "Entire Home", "Check-in: 1PM", "Check-out: 11AM", "Cozy", (int)(4000 * priceMult)));
            listings.add(new Flight("Mountain Cabin", "Private Room", "Check-in: 2PM", "Check-out: 10AM", "Nature", (int)(2500 * priceMult)));
        } else if (serviceType.equals("Train")) {
            listings.add(new Flight("Rajdhani Express", "AC 1st Class", "04:00 PM", "08:30 AM", "Fastest", (int)(3000 * priceMult)));
            listings.add(new Flight("Shatabdi Express", "AC Chair Car", "06:00 AM", "12:00 PM", "Morning", (int)(1800 * priceMult)));
        } else if (serviceType.equals("Bus")) {
            listings.add(new Flight("Volvo Multi-Axle Sleeper", "AC", "10:00 PM", "07:00 AM", "Overnight", (int)(1500 * priceMult)));
            listings.add(new Flight("Zingbus Premium", "Semi-Sleeper", "11:30 PM", "08:30 AM", "WiFi", (int)(1200 * priceMult)));
        } else if (serviceType.equals("Cab")) {
            listings.add(new Flight("Uber Intercity Sedan", "Private", "Pickup Now", "Drop-off", "AC", (int)(3500 * priceMult)));
            listings.add(new Flight("Ola Outstation SUV", "6-Seater", "Pickup Now", "Drop-off", "Spacious", (int)(5500 * priceMult)));
        }

        // Pass everything to the frontend, but let JavaScript/Gemini build the itinerary LIVE
        request.setAttribute("flights", listings);
        request.setAttribute("origin", origin != null ? origin : "New Delhi");
        request.setAttribute("destination", destination);
        request.setAttribute("serviceType", serviceType);
        request.setAttribute("travelClass", travelClass);
        request.setAttribute("duration", duration);

        request.getRequestDispatcher("results.jsp").forward(request, response);
    }
}