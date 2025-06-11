<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Logout - JadeBank</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f9f9f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .logout-container {
            background-color: white;
            padding: 40px 50px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            text-align: center;
            display: none;
        }

        h2 {
            color: #2c3e50;
        }

        p {
            font-size: 16px;
            color: #555;
            margin-bottom: 30px;
        }

        a {
            display: inline-block;
            padding: 10px 20px;
            margin: 10px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            transition: 0.3s;
        }

        .login-btn {
            background-color: #27ae60;
            color: white;
        }

        .signup-btn {
            background-color: #2980b9;
            color: white;
        }

        .login-btn:hover { background-color: #1e8449; }
        .signup-btn:hover { background-color: #1c6ca1; }
    </style>
</head>
<body>

    <div id="logout-container" class="logout-container">
        <h2>Thank you for choosing JadeBank!</h2>
        <p>You have been successfully logged out.</p>
        <a class="login-btn" href="Login.jsp">Login Again</a>
        <a class="signup-btn" href="SignUp.jsp">Create a New Account</a>
    </div>

    <script>
        // Immediately send POST request to /logout
        fetch("logout", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            }
        })
        .then(res => res.json())
        .then(data => {
            console.log(data.message);
            document.getElementById("logout-container").style.display = "block";
        })
        .catch(err => {
            alert("Logout failed. Try clearing cookies manually.");
        });
    </script>

</body>
</html>
