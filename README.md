Markdown
# Travel Booking Platform

## Project Overview
A comprehensive, full-stack travel booking web application designed for seamless trip planning, smart filtering, and secure checkouts. This platform acts as a unified hub, allowing users to search, filter, and book flights, hotels, homestays, trains, buses, and cabs within a single intuitive interface.

## Key Features
* **AI Travel Agent:** Integrated Google Gemini API for dynamic, multi-day itinerary generation based on user destination and duration, complete with an offline fallback mechanism.
* **Dual Payment Gateway:** Live Razorpay integration for card/net banking and dynamic UPI QR code generation for mobile payments.
* **Smart Search & Filters:** Dynamic data rendering and sorting across all services based on price, availability, and transport class.
* **Secure Authentication:** Persistent user accounts and secure session management linked to a relational database.

## Tech Stack
* **Backend:** Java Servlets, Apache Tomcat
* **Frontend:** JSP, HTML, CSS, JavaScript
* **Database:** MySQL (JDBC)
* **APIs:** Google Gemini 1.5 Flash, Razorpay

## 📂 Project Structure
```text
📦 Travel-Booking-Platform
 ┣ 📂 src
 ┃ ┗ 📂 main
 ┃   ┣ 📂 java/com/Travel
 ┃   ┃ ┣ 📂 config       (Database Configuration)
 ┃   ┃ ┣ 📂 controller   (Java Servlets & API logic)
 ┃   ┃ ┣ 📂 dao          (Data Access Objects for MySQL)
 ┃   ┃ ┗ 📂 model        (Data Models)
 ┃   ┗ 📂 webapp
 ┃     ┣ 📂 WEB-INF      (Deployment descriptors)
 ┃     ┣ 📜 dashboard.jsp
 ┃     ┣ 📜 index.jsp
 ┃     ┣ 📜 login.jsp
 ┃     ┗ 📜 results.jsp
 ┣ 📜 pom.xml            (Maven Dependencies)
 ┗ 📜 README.md
🛠️ Prerequisites & Requirements
To run this project locally, ensure you have the following installed:
Java Development Kit (JDK): Version 11 or higher
Web Server: Apache Tomcat 9 or 10
Database: MySQL Server
Build Tool: Maven
IDE: IntelliJ IDEA (Recommended) or Eclipse
🚀 Setup & Installation
1. Clone the Repository
Bash
git clone [https://github.com/shivamparashar912-create/Travel-Booking-Platform.git](https://github.com/shivamparashar912-create/Travel-Booking-Platform.git)
2. Database Setup
Open your MySQL client and create a new database.
Update the database connection credentials (URL, username, and password) in your Data Access Object (DAO) classes or database configuration file to match your local MySQL setup.
3. API Configuration
Locate dashboard.jsp and results.jsp in the src/main/webapp folder.
Ensure your Gemini API Key and Razorpay Test Key are correctly inserted into the respective JavaScript variables.
💻 How to Run the Project
Open the project folder in IntelliJ IDEA.
Allow Maven to automatically download all required dependencies listed in the pom.xml.
Go to Run > Edit Configurations, add a new Local Tomcat Server, and select your Tomcat installation directory.
Under the Deployment tab in the Tomcat configuration, add the project artifact (Travel-Booking-Platform:war exploded).
Click Run. The application will compile, deploy, and launch automatically at http://localhost:8080.
