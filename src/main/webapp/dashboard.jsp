<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% if (session.getAttribute("loggedUser") == null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - TravelPlatform</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background-color: #f2f2f2; margin: 0; }
        .navbar { background: transparent; position: absolute; width: 100%; top: 0; padding: 20px 40px; box-sizing: border-box; display: flex; justify-content: space-between; align-items: center; color: white; z-index: 10; }
        .nav-links a { color: white; text-decoration: none; margin-left: 20px; font-weight: 600; cursor: pointer; text-shadow: 1px 1px 2px rgba(0,0,0,0.8); }
        .hero { height: 450px; background: linear-gradient(to bottom, rgba(0,0,0,0.8) 0%, rgba(0,0,0,0) 100%), url('https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=1600&q=80') center/cover; position: relative; }

        .search-widget { background: white; width: 90%; max-width: 1200px; margin: -120px auto 40px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.15); position: relative; z-index: 5; padding: 20px; }
        .widget-nav { display: flex; justify-content: space-around; border-bottom: 1px solid #ebebeb; padding-bottom: 15px; margin-bottom: 20px; background: white; border-radius: 12px 12px 0 0; }
        .widget-nav div { text-align: center; color: #4a4a4a; cursor: pointer; padding: 10px 20px; border-radius: 8px; font-weight: bold; transition: 0.3s; }
        .widget-nav div.active { color: #d32f2f; border-bottom: 3px solid #d32f2f; background: #fff5f5; }
        .widget-nav i { font-size: 24px; margin-bottom: 5px; display: block; }

        .search-inputs { display: flex; gap: 10px; align-items: center; justify-content: space-between; flex-wrap: wrap; }
        .input-box { flex: 1; border: 1px solid #dfdfdf; border-radius: 8px; padding: 10px 15px; min-width: 150px; }
        .input-box label { display: block; font-size: 12px; color: #777; font-weight: bold; margin-bottom: 5px; }
        .input-box input, .input-box select { border: none; width: 100%; font-size: 16px; font-weight: bold; outline: none; background: transparent; }
        .search-btn { background: linear-gradient(90deg, #2196f3, #00bcd4); color: white; border: none; border-radius: 30px; padding: 15px 40px; font-size: 20px; font-weight: bold; cursor: pointer; width: 100%; margin-top: 15px; box-shadow: 0 4px 10px rgba(33,150,243,0.3); }

        .grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 15px; max-width: 1200px; margin: 0 auto; padding-bottom: 50px; }
        .card { background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1); transition: 0.3s; display: flex; flex-direction: column; }
        .card:hover { transform: translateY(-5px); box-shadow: 0 8px 15px rgba(0,0,0,0.2); }
        .card img { width: 100%; height: 140px; object-fit: cover; }
        .card-details { padding: 15px; text-align: center; flex: 1; display: flex; flex-direction: column; justify-content: space-between; }
        .card-title { font-weight: bold; font-size: 16px; margin-bottom: 10px; color: #333; }
        .card-select { width: 100%; padding: 8px; margin-bottom: 10px; border-radius: 5px; border: 1px solid #ccc; font-size: 14px; outline: none; }
        .card-btn { width: 100%; padding: 10px; background: #002b5c; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; transition: 0.2s; }
        .card-btn:hover { background: #d32f2f; }

        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); z-index: 2000; justify-content: center; align-items: center; }
        .modal-content { background: white; width: 600px; padding: 25px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); }
        .history-item { border-left: 4px solid #4caf50; padding: 10px 15px; background: #f9f9f9; margin-bottom: 10px; border-radius: 4px; }

        .ai-chatbot { position: fixed; bottom: 30px; right: 30px; z-index: 1000; }
        .ai-btn { background: #6e8efb; color: white; border: none; border-radius: 50%; width: 60px; height: 60px; font-size: 24px; cursor: pointer; box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
        .chat-window { display: none; position: absolute; bottom: 80px; right: 0; width: 350px; background: white; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); overflow: hidden; }
        .chat-header { background: #6e8efb; color: white; padding: 15px; font-weight: bold; display: flex; justify-content: space-between; }
        .chat-body { height: 300px; padding: 15px; overflow-y: auto; background: #f9f9f9; font-size: 14px;}
        .bot-msg { background: #e0e0e0; padding: 10px; border-radius: 10px 10px 10px 0; margin-bottom: 10px; width: 85%; }
        .user-msg { background: #6e8efb; color: white; padding: 10px; border-radius: 10px 10px 0 10px; margin-bottom: 10px; width: 80%; margin-left: auto; text-align: right; }
        .chat-footer { display: flex; border-top: 1px solid #ddd; }
        .chat-footer input { flex: 1; padding: 15px; border: none; outline: none; }
        .chat-footer button { padding: 15px; background: white; border: none; color: #6e8efb; font-weight: bold; cursor: pointer; }
    </style>
</head>
<body>

    <div class="navbar">
        <h2 style="margin:0;"><i class="fa-solid fa-plane-departure"></i> TravelPlatform</h2>
        <div class="nav-links">
            <span style="margin-right: 20px;"><i class="fa-solid fa-user"></i> <%= session.getAttribute("loggedUser") %></span>
            <a onclick="document.getElementById('historyModal').style.display='flex'"><i class="fa-solid fa-clock-rotate-left"></i> My Trips & Transactions</a>
            <a href="mailto:shivamparashar912@gmail.com"><i class="fa-solid fa-headset"></i> Support</a>
            <a href="login.jsp" style="background: #d32f2f; padding: 5px 10px; border-radius: 4px;">Log Out</a>
        </div>
    </div>
    <div class="hero"></div>

    <div class="search-widget">
        <div class="widget-nav">
            <div class="active" onclick="switchTab('Flight', 'FROM', 'TO')"><i class="fa-solid fa-plane"></i><span>Flights</span></div>
            <div onclick="switchTab('Hotel', 'CITY', 'HOTEL NAME')"><i class="fa-solid fa-hotel"></i><span>Hotels</span></div>
            <div onclick="switchTab('Homestay', 'CITY', 'PROPERTY')"><i class="fa-solid fa-house"></i><span>Homestays</span></div>
            <div onclick="switchTab('Train', 'STATION FROM', 'STATION TO')"><i class="fa-solid fa-train"></i><span>Trains</span></div>
            <div onclick="switchTab('Bus', 'BOARDING', 'DROP-OFF')"><i class="fa-solid fa-bus"></i><span>Buses</span></div>
            <div onclick="switchTab('Cab', 'PICKUP LOCATION', 'DROP LOCATION')"><i class="fa-solid fa-taxi"></i><span>Cabs</span></div>
        </div>

        <form action="SearchServlet" method="post" id="main-search-form">
            <input type="hidden" name="serviceType" id="serviceType" value="Flight">
            <div class="search-inputs">
                <div class="input-box"><label id="lbl-origin">FROM</label><input type="text" name="origin" value="New Delhi"></div>
                <div class="input-box"><label id="lbl-dest">TO</label><input type="text" name="destination" value="Goa" required></div>
                <div class="input-box"><label>NO. OF DAYS</label><input type="number" name="duration" value="5" min="1" max="30" required></div>
                <div class="input-box">
                    <label>CLASS / TYPE</label>
                    <select name="travelClass" id="classType" class="form-control">
                        <option value="Economy">Economy</option>
                        <option value="Business">Business</option>
                        <option value="First Class">First Class</option>
                    </select>
                </div>
            </div>
            <button type="submit" class="search-btn">SEARCH</button>
        </form>
    </div>

    <h3 style="text-align:center;">Top Destinations (Dynamic AI Itinerary Included)</h3>
    <div class="grid" id="destGrid">
        <!-- Dynamically injected via JavaScript below to keep code clean -->
    </div>

    <div id="historyModal" class="modal">
        <div class="modal-content">
            <h2 style="margin-top:0; color:#004080;">Your Travel & Transaction History</h2>
            <div class="history-item">
                <b>Flight to Mumbai (Vistara UK-988)</b><br>
                <span style="color:#666; font-size:14px;">Transaction ID: pay_LMN890xyz | Amount: ₹5,400 | Status: <b style="color:green;">Success</b></span>
            </div>
            <div class="history-item">
                <b>Taj Exotica Resort, Goa (Premium)</b><br>
                <span style="color:#666; font-size:14px;">Transaction ID: pay_PQR123abc | Amount: ₹15,400 | Status: <b style="color:green;">Success</b></span>
            </div>
            <div style="text-align:right; margin-top:20px;">
                <button onclick="document.getElementById('historyModal').style.display='none'" style="padding:10px 20px; background:#d32f2f; color:white; border:none; border-radius:5px; cursor:pointer;">Close</button>
            </div>
        </div>
    </div>

    <div class="ai-chatbot">
        <button class="ai-btn" onclick="document.getElementById('chatWindow').style.display = document.getElementById('chatWindow').style.display === 'block' ? 'none' : 'block';"><i class="fa-solid fa-robot"></i></button>
        <div class="chat-window" id="chatWindow">
            <div class="chat-header"><span>Gemini AI Agent</span><span style="cursor:pointer;" onclick="document.getElementById('chatWindow').style.display='none'">✖</span></div>
            <div class="chat-body" id="chatBody"><div class="bot-msg">Hi! I am live. Ask me to plan a trip or suggest destinations!</div></div>
            <div class="chat-footer"><input type="text" id="chatInput" placeholder="Type a message..."><button onclick="askGemini()">SEND</button></div>
        </div>
    </div>

    <script>
        // Inject Top Destination Cards with dynamic Dropdowns
        const destinations = [
            { name: "Goa", img: "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=400&q=80" },
            { name: "Maldives", img: "https://images.unsplash.com/photo-1514282401047-d79a71a590e8?w=400&q=80" },
            { name: "Dubai", img: "https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=400&q=80" },
            { name: "Bali", img: "https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=400&q=80" },
            { name: "Paris", img: "https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=400&q=80" },
            { name: "Tokyo", img: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&q=80" },
            { name: "Swiss Alps", img: "https://images.unsplash.com/photo-1530122037265-a5f1f91d3b99?w=400&q=80" },
            { name: "Kerala", img: "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=400&q=80" },
            { name: "Singapore", img: "https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=400&q=80" },
            { name: "London", img: "https://images.unsplash.com/photo-1513635269975-59693e0cd102?w=400&q=80" }
        ];

        const grid = document.getElementById("destGrid");
        destinations.forEach((dest, index) => {
            grid.innerHTML += `
                <div class="card">
                    <img src="`+dest.img+`">
                    <div class="card-details">
                        <div class="card-title">`+dest.name+`</div>
                        <select id="srv-`+index+`" class="card-select">
                            <option value="Flight">✈️ Flights</option>
                            <option value="Hotel">🏨 Hotels</option>
                            <option value="Homestay">🏡 Homestays</option>
                            <option value="Train">🚆 Trains</option>
                            <option value="Bus">🚌 Buses</option>
                            <option value="Cab">🚕 Cabs</option>
                        </select>
                        <button class="card-btn" onclick="window.location.href='SearchServlet?origin=Delhi&duration=5&travelClass=Economy&destination=`+dest.name+`&serviceType=' + document.getElementById('srv-`+index+`').value">
                            Explore
                        </button>
                    </div>
                </div>
            `;
        });

        function switchTab(service, label1, label2) {
            document.querySelectorAll('.widget-nav div').forEach(t => t.classList.remove('active'));
            event.currentTarget.classList.add('active');

            document.getElementById('serviceType').value = service;
            document.getElementById('lbl-origin').innerText = label1;
            document.getElementById('lbl-dest').innerText = label2;

            const classSelect = document.getElementById("classType");
            if(classSelect) {
                classSelect.innerHTML = "";
                let options = [];

                if (service === 'Flight') {
                    options = ['Economy', 'Business', 'First Class'];
                } else if (service === 'Hotel' || service === 'Homestay') {
                    options = ['Premium', 'Budget'];
                } else if (service === 'Train') {
                    options = ['General', '1AC', '2AC', '3AC', 'Sleeper Class'];
                } else if (service === 'Cab') {
                    options = ['Premium', 'Economy', 'Sharing Taxi'];
                } else if (service === 'Bus') {
                    options = ['Sleeper', 'Non-Sleeper'];
                }

                options.forEach(opt => {
                    let el = document.createElement("option");
                    el.value = opt; el.innerText = opt;
                    classSelect.appendChild(el);
                });
            }
        }

        async function askGemini() {
            var input = document.getElementById("chatInput").value;
            if(!input) return;
            var chatBody = document.getElementById("chatBody");
            chatBody.innerHTML += `<div class="user-msg">${input}</div><div class="bot-msg" id="loadingMsg">Typing...</div>`;
            document.getElementById("chatInput").value = "";
            chatBody.scrollTop = chatBody.scrollHeight;

            const apiKey = 'AQ.Ab8RN6K2HTnROEVs05z7iC3zcbK-jWSGiBnD6Wex9NrWnFUTfw';

            try {
                const response = await fetch("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + apiKey, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ contents: [{ parts: [{ text: "You are a travel agent. Be concise. " + input }] }] })
                });

                const data = await response.json();
                if (!response.ok) throw new Error(data.error ? data.error.message : "API Error");

                document.getElementById("loadingMsg").remove();
                let aiResponse = data.candidates[0].content.parts[0].text;
                aiResponse = aiResponse.replace(/\*\*(.*?)\*\*/g, '<b>$1</b>').replace(/\n/g, '<br>');

                chatBody.innerHTML += `<div class="bot-msg">${aiResponse}</div>`;
                chatBody.scrollTop = chatBody.scrollHeight;
            } catch(e) {
                document.getElementById("loadingMsg").innerHTML = `<b style='color:red;'>Google Error:</b> ${e.message}`;
            }
        }
    </script>
</body>
</html>