<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login & Sign Up - Travel Platform</title>
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; margin: 0; display: flex; align-items: center; justify-content: center; height: 100vh; background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), url('https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=1600&q=80') center/cover; }
        .auth-container { background: rgba(255, 255, 255, 0.95); width: 400px; border-radius: 12px; padding: 30px; box-shadow: 0 8px 32px rgba(0,0,0,0.3); text-align: center; }

        /* Toggle Tabs */
        .tab-container { display: flex; margin-bottom: 20px; border-bottom: 2px solid #ddd; }
        .tab { flex: 1; padding: 10px; cursor: pointer; font-weight: bold; color: #777; transition: 0.3s; }
        .tab.active { color: #d32f2f; border-bottom: 3px solid #d32f2f; }

        .form-section { display: none; }
        .form-section.active { display: block; }

        .input-group { margin-bottom: 15px; text-align: left; }
        .input-group label { display: block; font-size: 13px; color: #666; font-weight: 600; margin-bottom: 5px; }
        .input-group input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; }

        .submit-btn { width: 100%; padding: 12px; background: #d32f2f; color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; margin-top: 10px; }
        .otp-btn { width: 100%; padding: 10px; background: #2196f3; color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; margin-top: 5px; }

        .error-msg { background: #ffebee; color: #c62828; padding: 10px; border-radius: 4px; margin-bottom: 15px; font-size: 13px; font-weight: bold; display: <%= request.getAttribute("errorMessage") != null ? "block" : "none" %>; }

        .divider { display: flex; align-items: center; margin: 20px 0; color: #888; font-size: 12px; }
        .divider::before, .divider::after { content: ''; flex: 1; border-bottom: 1px solid #ccc; }
        .divider:not(:empty)::before { margin-right: 10px; }
        .divider:not(:empty)::after { margin-left: 10px; }
    </style>
</head>
<body>
    <div class="auth-container">
        <h2 style="margin-top:0; color:#333;">TravelPlatform</h2>

        <!-- Error Message Display -->
        <div class="error-msg"><%= request.getAttribute("errorMessage") %></div>

        <!-- Login / Signup Tabs -->
        <div class="tab-container">
            <div class="tab active" onclick="switchTab('login')">LOGIN</div>
            <div class="tab" onclick="switchTab('signup')">SIGN UP</div>
        </div>

        <!-- LOGIN FORM -->
        <div id="login-form" class="form-section active">
            <form action="LoginServlet" method="post">
                <input type="hidden" name="action" value="LOGIN">
                <div class="input-group"><label>Email ID</label><input type="email" name="email" required></div>
                <div class="input-group"><label>Password</label><input type="password" name="password" required></div>
                <button type="submit" class="submit-btn">SECURE LOGIN</button>
            </form>
        </div>

        <!-- SIGNUP FORM with Hackathon Mock OTP -->
        <div id="signup-form" class="form-section">
            <form action="LoginServlet" method="post" id="registerForm">
                <input type="hidden" name="action" value="SIGNUP">
                <div class="input-group"><label>Email ID</label><input type="email" name="email" required></div>
                <div class="input-group"><label>Password</label><input type="password" name="password" required></div>

                <!-- Mock OTP Flow -->
                <div class="input-group" id="phone-group">
                    <label>Mobile Number</label>
                    <input type="tel" id="mobile" placeholder="+91 XXXXX XXXXX" required>
                    <button type="button" class="otp-btn" onclick="sendMockOTP()">Send Free OTP</button>
                </div>

                <div class="input-group" id="otp-group" style="display:none;">
                    <label style="color:#2196f3;">Enter the OTP sent to your phone</label>
                    <input type="text" id="otp-input" placeholder="Enter 4-digit OTP">
                    <button type="button" class="submit-btn" style="background:#4caf50;" onclick="verifyOTP()">Verify & Register</button>
                </div>
            </form>
        </div>

        <div class="divider">OR CONTINUE WITH</div>

        <!-- Official Google Sign-In -->
        <!-- REPLACE THE data-client_id BELOW WITH YOUR REAL KEY -->
        <div id="g_id_onload"
             data-client_id="862287895475-2clntu7vofsh69v0q4f5mfhuhc28d3m0.apps.googleusercontent.com"
             data-context="signin" data-ux_mode="popup" data-callback="handleGoogleLogin" data-auto_prompt="false">
        </div>
        <div class="g_id_signin" data-type="standard" data-shape="rectangular" data-theme="outline" data-text="signin_with" data-size="large" data-logo_alignment="center" style="display:flex; justify-content:center;"></div>

        <!-- Hidden form for Google -->
        <form id="googleForm" action="LoginServlet" method="POST" style="display:none;">
            <input type="hidden" name="action" value="GOOGLE">
            <input type="hidden" name="email" id="googleEmail">
            <input type="hidden" name="password" value="GOOGLE_SSO_BYPASS">
        </form>
    </div>

    <script>
        // Tab Switcher Logic
        function switchTab(tabName) {
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.form-section').forEach(f => f.classList.remove('active'));

            if(tabName === 'login') {
                document.querySelectorAll('.tab')[0].classList.add('active');
                document.getElementById('login-form').classList.add('active');
            } else {
                document.querySelectorAll('.tab')[1].classList.add('active');
                document.getElementById('signup-form').classList.add('active');
            }
        }

        // Hackathon Mock OTP Logic
        let generatedOTP = "";
        function sendMockOTP() {
            let mobile = document.getElementById("mobile").value;
            if(mobile.length < 10) { alert("Please enter a valid 10-digit mobile number."); return; }

            // Generate random 4 digit number
            generatedOTP = Math.floor(1000 + Math.random() * 9000).toString();

            // Simulate the phone receiving a text message
            alert("MOCK SMS RECEIVED on " + mobile + ":\n\nYour TravelPlatform verification code is: " + generatedOTP + "\n\n(Note: This is a free simulated OTP for the hackathon).");

            // Show the OTP input field
            document.getElementById("phone-group").style.display = "none";
            document.getElementById("otp-group").style.display = "block";
        }

        function verifyOTP() {
            let userInput = document.getElementById("otp-input").value;
            if(userInput === generatedOTP) {
                alert("Phone Verified Successfully!");
                document.getElementById("registerForm").submit(); // Actually submit the form to Java
            } else {
                alert("Incorrect OTP. Please try again.");
            }
        }

        // Google Login Logic
        function handleGoogleLogin(response) {
            const payload = JSON.parse(atob(response.credential.split('.')[1]));
            document.getElementById('googleEmail').value = payload.email;
            document.getElementById('googleForm').submit();
        }
    </script>
</body>
</html>