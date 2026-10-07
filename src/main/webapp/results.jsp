<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String serviceType = request.getParameter("serviceType");
    if (serviceType == null || serviceType.isEmpty()) serviceType = "Flight";

    String destination = request.getParameter("destination");
    if (destination == null || destination.isEmpty()) destination = "Goa";

    String durationStr = request.getParameter("duration");
    if (durationStr == null || durationStr.isEmpty()) durationStr = "5";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Results - TravelPlatform</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- REAL RAZORPAY SCRIPT -->
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background-color: #f2f2f2; margin: 0; }
        .navbar { background: #002b5c; padding: 20px 40px; display: flex; justify-content: space-between; align-items: center; color: white; }
        .back-btn { background: #d32f2f; color: white; padding: 10px 20px; border-radius: 5px; text-decoration: none; font-weight: bold; }

        .layout-container { display: flex; max-width: 1300px; margin: 30px auto; gap: 20px; padding: 0 20px; }

        .sidebar { width: 250px; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); height: fit-content; }
        .sidebar h3 { margin-top: 0; border-bottom: 2px solid #002b5c; padding-bottom: 10px; }
        .filter-group { margin-bottom: 20px; }
        .filter-group label { display: block; font-weight: bold; margin-bottom: 8px; color: #444; }
        .filter-group select { width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ccc; font-size: 14px; outline: none; }

        .main-content { flex: 1; }
        .ai-banner { background: #e3f2fd; border: 1px solid #90caf9; padding: 20px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        .ai-banner h4 { margin: 0 0 10px 0; color: #1565c0; font-size: 18px; }

        .result-card { background: white; padding: 20px; border-radius: 10px; margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 8px rgba(0,0,0,0.1); transition: 0.2s; }
        .result-card:hover { transform: translateY(-3px); box-shadow: 0 5px 15px rgba(0,0,0,0.15); }
        .result-info h3 { margin: 0 0 5px 0; color: #333; display: flex; align-items: center; gap: 10px; }
        .result-info p { margin: 0; color: #666; }
        .sold-out-badge { background: #ffebee; color: #c62828; padding: 3px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; }

        .price-section { text-align: right; }
        .price-section h2 { margin: 0 0 10px 0; color: #d32f2f; }
        .book-btn { background: #2196f3; color: white; border: none; padding: 10px 25px; border-radius: 20px; font-weight: bold; cursor: pointer; font-size: 14px; }
        .book-btn:disabled { background: #ccc; cursor: not-allowed; }
    </style>
</head>
<body>

    <div class="navbar">
        <h2 style="margin:0;"><i class="fa-solid fa-plane-departure"></i> TravelPlatform</h2>
        <a href="dashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> BACK TO HOME</a>
    </div>

    <div class="layout-container">
        <!-- Sidebar Filters -->
        <div class="sidebar">
            <h3>Refine Search</h3>
            <div class="filter-group">
                <label>Sort by Price</label>
                <select id="priceFilter" onchange="applyFilters()">
                    <option value="none">Recommended</option>
                    <option value="low">Price: Low to High</option>
                    <option value="high">Price: High to Low</option>
                </select>
            </div>
            <div class="filter-group">
                <label>Availability</label>
                <select id="availFilter" onchange="applyFilters()">
                    <option value="all">Show All</option>
                    <option value="available">Available Only</option>
                </select>
            </div>
        </div>

        <!-- Main Content Area -->
        <div class="main-content">
            <h2 style="margin-top:0;">Available <%= serviceType %>s for <%= destination %></h2>

            <div class="ai-banner">
                <h4><i class="fa-solid fa-wand-magic-sparkles"></i> Live <%= durationStr %>-Day AI Itinerary & Route Map</h4>
                <div id="ai-body" style="line-height:1.6;">Generating custom itinerary... <i class="fa-solid fa-spinner fa-spin"></i></div>
            </div>

            <div id="resultsList"></div>
        </div>
    </div>

    <script>
        const currentService = "<%= serviceType %>";
        const targetDest = "<%= destination %>";
        const tripDays = parseInt("<%= durationStr %>") || 5;

        // 1. DUMMY DATABASE
        const database = {
            Flight: [
                { name: "Vistara Airlines", desc: "08:30 AM - Non-Stop", price: 5400, available: true },
                { name: "Air India", desc: "11:15 AM - 1-Stop", price: 4800, available: true },
                { name: "IndiGo", desc: "04:00 PM - Non-Stop", price: 3900, available: true },
                { name: "SpiceJet", desc: "06:20 AM - Non-Stop", price: 3200, available: false },
                { name: "Akasa Air", desc: "01:10 PM - 1-Stop", price: 4100, available: true },
                { name: "Vistara Premium", desc: "09:00 AM - Non-Stop", price: 8500, available: true },
                { name: "Air India Express", desc: "10:30 PM - Non-Stop", price: 3600, available: true },
                { name: "IndiGo Red-Eye", desc: "02:00 AM - Non-Stop", price: 2900, available: true },
                { name: "SpiceJet Max", desc: "05:45 PM - 1-Stop", price: 4700, available: false },
                { name: "AirAsia India", desc: "07:30 AM - Non-Stop", price: 3800, available: true }
            ],
            Hotel: [
                { name: "Taj Exotica", desc: "5-Star Luxury Resort", price: 15400, available: true },
                { name: "Marriott Suites", desc: "Premium City Center", price: 12000, available: true },
                { name: "Radisson Blu", desc: "4-Star Business Hotel", price: 8500, available: false },
                { name: "Holiday Inn", desc: "Family Friendly", price: 5500, available: true },
                { name: "Novotel", desc: "Modern & Sleek", price: 7200, available: true },
                { name: "Hyatt Regency", desc: "Luxury Experience", price: 18000, available: true },
                { name: "Lemon Tree", desc: "Budget Premium", price: 4000, available: true },
                { name: "ITC Grand", desc: "Heritage Style", price: 14500, available: false },
                { name: "Ibis Styles", desc: "Economy & Comfort", price: 3500, available: true },
                { name: "The Leela", desc: "Ultra Luxury", price: 22000, available: true }
            ],
            Homestay: [
                { name: "Cozy Hill Cabin", desc: "Scenic Views, 2BHK", price: 4500, available: true },
                { name: "Seaside Retreat", desc: "Beachfront Villa", price: 8500, available: true },
                { name: "Heritage Haveli", desc: "Cultural Experience", price: 6000, available: false },
                { name: "Urban Loft", desc: "City Center, Modern", price: 3500, available: true },
                { name: "Farmhouse Stay", desc: "Nature & Animals", price: 5000, available: true },
                { name: "Mountain Chalet", desc: "Fireplace included", price: 9200, available: true },
                { name: "Riverside Cottage", desc: "Peaceful & Quiet", price: 4800, available: true },
                { name: "Bamboo Treehouse", desc: "Unique Experience", price: 7500, available: false },
                { name: "Desert Camp", desc: "Tents & Bonfire", price: 5500, available: true },
                { name: "Backwater Houseboat", desc: "Floating Home", price: 12000, available: true }
            ],
            Train: [
                { name: "Rajdhani Express", desc: "1AC / 2AC / 3AC", price: 2800, available: true },
                { name: "Shatabdi Express", desc: "CC / EC", price: 1500, available: true },
                { name: "Vande Bharat", desc: "High-Speed CC", price: 1800, available: false },
                { name: "Duronto Express", desc: "Non-Stop Premium", price: 2400, available: true },
                { name: "Garib Rath", desc: "Economy 3AC", price: 900, available: true },
                { name: "Sampark Kranti", desc: "Superfast Express", price: 1200, available: true },
                { name: "Mail/Express", desc: "Sleeper / General", price: 450, available: true },
                { name: "Tejas Express", desc: "Premium AC", price: 2100, available: false },
                { name: "Jan Shatabdi", desc: "Non-AC / AC Seating", price: 600, available: true },
                { name: "Humsafar Express", desc: "Premium 3AC", price: 1600, available: true }
            ],
            Bus: [
                { name: "Volvo Multi-Axle AC", desc: "Sleeper", price: 1800, available: true },
                { name: "Scania Semi-Sleeper", desc: "AC Seating", price: 1200, available: true },
                { name: "State Roadways", desc: "Non-AC General", price: 450, available: true },
                { name: "SRS Travels", desc: "Premium Sleeper", price: 2100, available: false },
                { name: "RedBus SmartBus", desc: "AC Sleeper + WiFi", price: 1900, available: true },
                { name: "VRL Logistics", desc: "Semi-Sleeper", price: 1100, available: true },
                { name: "Orange Tours", desc: "AC Sleeper", price: 2000, available: true },
                { name: "Kallada Travels", desc: "Multi-Axle AC", price: 1700, available: false },
                { name: "Chartered Bus", desc: "AC Seating", price: 950, available: true },
                { name: "Neeta Travels", desc: "AC Sleeper", price: 1850, available: true }
            ],
            Cab: [
                { name: "Uber Premium", desc: "Sedan / SUV", price: 1200, available: true },
                { name: "Ola Mini", desc: "Hatchback", price: 800, available: true },
                { name: "MakeMyTrip Outstation", desc: "Toyota Innova", price: 3500, available: true },
                { name: "Savaari Cabs", desc: "Intercity Sedan", price: 2800, available: false },
                { name: "Local Shared Taxi", desc: "Economy Sharing", price: 400, available: true },
                { name: "Uber XL", desc: "6-Seater SUV", price: 1800, available: true },
                { name: "Ola Prime Sedan", desc: "Comfort + WiFi", price: 1000, available: true },
                { name: "Meru Cabs", desc: "Airport Transfer", price: 1500, available: false },
                { name: "Zoomcar", desc: "Self-Drive SUV", price: 4500, available: true },
                { name: "BluSmart EV", desc: "Electric Sedan", price: 900, available: true }
            ]
        };

        // 2. FILTER & RENDER
        function applyFilters() {
            let activeList = database[currentService] || database["Flight"];
            const priceMode = document.getElementById("priceFilter").value;
            const availMode = document.getElementById("availFilter").value;

            let filtered = activeList.filter(item => {
                if (availMode === 'available' && !item.available) return false;
                return true;
            });

            if (priceMode === 'low') filtered.sort((a, b) => a.price - b.price);
            else if (priceMode === 'high') filtered.sort((a, b) => b.price - a.price);

            const container = document.getElementById("resultsList");
            container.innerHTML = "";

            if (filtered.length === 0) {
                container.innerHTML = "<h3>No results match your filters.</h3>";
                return;
            }

            filtered.forEach(item => {
                let badge = !item.available ? `<span class="sold-out-badge">SOLD OUT</span>` : "";
                let btnAttr = !item.available ? "disabled" : `onclick="payWithRazorpay('${item.name}', ${item.price})"`;
                let btnText = !item.available ? "UNAVAILABLE" : "BOOK NOW";

                container.innerHTML += `
                    <div class="result-card">
                        <div class="result-info">
                            <h3><i class="fa-solid fa-star" style="color:#ffc107; font-size:16px;"></i> ${item.name} ${badge}</h3>
                            <p>${item.desc}</p>
                        </div>
                        <div class="price-section">
                            <h2>₹${item.price}</h2>
                            <button class="book-btn" ${btnAttr}>${btnText}</button>
                        </div>
                    </div>
                `;
            });
        }

        // 3. PERMANENT REAL RAZORPAY INTEGRATION
        function payWithRazorpay(itemName, price) {
            var options = {
                // REPLACE THIS WITH YOUR ACTUAL RAZORPAY TEST KEY ID
                "key": "rzp_test_Tl3IuLXmtMZWRP",
                "amount": price * 100, // Amount is in paise
                "currency": "INR",
                "name": "TravelPlatform",
                "description": "Booking: " + itemName,
                "image": "https://cdn-icons-png.flaticon.com/512/3125/3125713.png",
                "handler": function (response) {
                    // This runs automatically when Razorpay succeeds
                    alert("Payment Successful!\nTransaction ID: " + response.razorpay_payment_id);
                    window.location.href = "dashboard.jsp";
                },
                "prefill": {
                    "name": "Shivam Sharma",
                    "email": "shivam123@gmail.com",
                    "contact": "9999999999"
                },
                "theme": {
                    "color": "#002b5c"
                }
            };
            var rzp1 = new Razorpay(options);
            rzp1.on('payment.failed', function (response){
                alert("Payment Failed. Reason: " + response.error.description);
            });
            rzp1.open();
        }

        // 4. HARDCODED OFFLINE ITINERARIES (FAILSAFE)
        const offlineData = {
            "Goa": "<b>Day 1:</b> Arrive via " + currentService + ", relax at Baga Beach & enjoy local seafood.<br><b>Day 2:</b> Rent a scooter, visit Fort Aguada and Chapora Fort.<br><b>Day 3:</b> Trek to Dudhsagar Waterfalls and explore spice plantations.<br><b>Day 4:</b> Visit the Basilica of Bom Jesus in Old Goa.<br><b>Day 5:</b> Morning shopping at Anjuna Flea Market, departure.",
            "Maldives": "<b>Day 1:</b> Arrive via " + currentService + " & speed boat transfer to your overwater villa.<br><b>Day 2:</b> Morning Snorkeling at Banana Reef.<br><b>Day 3:</b> Relaxing Spa day and Sunset Dolphin Cruise.<br><b>Day 4:</b> Submarine tour and beachside BBQ dinner.<br><b>Day 5:</b> Morning leisure and departure to Male.",
            "Dubai": "<b>Day 1:</b> Arrive via " + currentService + ", explore Dubai Mall & watch the Burj Khalifa fountains.<br><b>Day 2:</b> Afternoon Desert Safari with dune bashing and BBQ.<br><b>Day 3:</b> Visit the Palm Jumeirah and Atlantis waterpark.<br><b>Day 4:</b> Old Dubai tour (Gold Souk and Abra ride on Dubai Creek).<br><b>Day 5:</b> Shopping and departure.",
            "Bali": "<b>Day 1:</b> Arrive via " + currentService + ", check into Ubud, visit the Monkey Forest.<br><b>Day 2:</b> Early morning Mount Batur sunrise trek.<br><b>Day 3:</b> Explore the Tegallalang Rice Terraces.<br><b>Day 4:</b> Move to Seminyak, watch the sunset at Uluwatu Temple.<br><b>Day 5:</b> Beach day and departure.",
            "Paris": "<b>Day 1:</b> Arrive via " + currentService + " and Evening Seine River Cruise.<br><b>Day 2:</b> Visit the Eiffel Tower and Arc de Triomphe.<br><b>Day 3:</b> Full day at the Louvre Museum and Notre-Dame.<br><b>Day 4:</b> Day trip to the Palace of Versailles.<br><b>Day 5:</b> Montmartre walk, Sacré-Cœur, and departure.",
            "Tokyo": "<b>Day 1:</b> Arrive via " + currentService + ", explore Shinjuku neon lights.<br><b>Day 2:</b> Shibuya Crossing and Meiji Shrine.<br><b>Day 3:</b> Morning at Tsukiji Outer Market, afternoon in Akihabara.<br><b>Day 4:</b> Visit Senso-ji Temple in Asakusa.<br><b>Day 5:</b> Tokyo Skytree and departure.",
            "Swiss Alps": "<b>Day 1:</b> Arrive via " + currentService + " in Interlaken, walk by Lake Thun.<br><b>Day 2:</b> Train ride to Jungfraujoch (Top of Europe).<br><b>Day 3:</b> Cable car to Grindelwald First, cliff walk.<br><b>Day 4:</b> Explore Lauterbrunnen waterfalls.<br><b>Day 5:</b> Transfer to Zurich/Geneva for departure.",
            "Kerala": "<b>Day 1:</b> Arrive via " + currentService + " in Kochi, see the Chinese Fishing Nets.<br><b>Day 2:</b> Drive to Munnar, explore the Tea Gardens.<br><b>Day 3:</b> Jeep safari in Thekkady Wildlife Sanctuary.<br><b>Day 4:</b> Overnight stay on an Alleppey Houseboat.<br><b>Day 5:</b> Morning canoe ride, departure.",
            "Singapore": "<b>Day 1:</b> Arrive via " + currentService + ", visit Marina Bay Sands and Merlion Park.<br><b>Day 2:</b> Full day at Gardens by the Bay & Cloud Forest.<br><b>Day 3:</b> Sentosa Island & Universal Studios.<br><b>Day 4:</b> Night Safari at Singapore Zoo.<br><b>Day 5:</b> Shopping at Orchard Road, departure.",
            "London": "<b>Day 1:</b> Arrive via " + currentService + ", ride the London Eye.<br><b>Day 2:</b> Buckingham Palace Guard Change, Westminster Abbey, Big Ben.<br><b>Day 3:</b> Explore the British Museum and Oxford Street.<br><b>Day 4:</b> Visit the Tower of London and Tower Bridge.<br><b>Day 5:</b> Hyde Park stroll, departure."
        };

        // 5. GEMINI API REVERTED TO PREVIOUS MODEL
        async function loadItinerary() {
            const apiKey = 'AQ.Ab8RN6K2HTnROEVs05z7iC3zcbK-jWSGiBnD6Wex9NrWnFUTfw';

            let placesCount = "3 to 4";
            if (tripDays <= 2) placesCount = "2 to 3";
            else if (tripDays === 5) placesCount = "5 to 6";
            else if (tripDays >= 10) placesCount = "exactly 10";

            const promptStr = `Act as an expert travel guide. Create a ${tripDays}-day travel itinerary and route map for ${targetDest}.
            Requirements:
            1. You MUST include exactly ${placesCount} famous places in ${targetDest}.
            2. Outline the best logical travel route between these places.
            3. The user is arriving via ${currentService}.
            Keep it highly structured, brief, and use HTML tags (<br>, <b>, <ul>, <li>) for styling.`;

            try {
                // REVERTED to gemini-1.5-flash which triggers the "High Demand" error
                const response = await fetch("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + apiKey, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ contents: [{ parts: [{ text: promptStr }] }] })
                });

                const data = await response.json();
                if (!response.ok) throw new Error("API Traffic");

                let aiText = data.candidates[0].content.parts[0].text;
                aiText = aiText.replace(/\*\*(.*?)\*\*/g, '<b>$1</b>').replace(/\n/g, '<br>');
                document.getElementById("ai-body").innerHTML = aiText;

            } catch (e) {
                // If API fails, pull from the hidden database
                let fallbackText = offlineData[targetDest] || "<b>Day 1:</b> Arrive via " + currentService + " and explore local landmarks.<br><b>Day 2:</b> Full day sightseeing tour of major attractions.<br><b>Day 3:</b> Shopping, local cuisine, and departure.";

                document.getElementById("ai-body").innerHTML = `
                    <div style="color:#d32f2f; font-weight:bold; margin-bottom:10px;">
                        <i class="fa-solid fa-triangle-exclamation"></i> High Demand: Instantly switched to Offline Guide
                    </div>
                    <p style="margin-top:0;">` + fallbackText + `</p>
                `;
            }
        }

        // Initialize page
        applyFilters();
        loadItinerary();
    </script>
</body>
</html>