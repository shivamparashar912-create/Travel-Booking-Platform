package com.Travel.model;
public class Flight {
    private String airline;
    private String flightCode;
    private String departureTime;
    private String arrivalTime;
    private String duration;
    private int price;

    public Flight(String airline, String flightCode, String departureTime, String arrivalTime, String duration, int price) {
        this.airline = airline;
        this.flightCode = flightCode;
        this.departureTime = departureTime;
        this.arrivalTime = arrivalTime;
        this.duration = duration;
        this.price = price;
    }

    public String getAirline() { return airline; }
    public String getFlightCode() { return flightCode; }
    public String getDepartureTime() { return departureTime; }
    public String getArrivalTime() { return arrivalTime; }
    public String getDuration() { return duration; }
    public int getPrice() { return price; }
}