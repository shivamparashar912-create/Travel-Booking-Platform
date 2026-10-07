package com.Travel.dao;

import com.Travel.config.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class BookingDAO {
    public boolean createBooking(String email, String destination, String travelDate, String travellers) {
        String sql = "INSERT INTO bookings (user_email, destination, travel_date, travellers) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, destination);
            stmt.setString(3, travelDate);
            stmt.setString(4, travellers);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}