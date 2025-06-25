<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>JadeBank - Home</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto+Flex:opsz,wght@8..144,400;600&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: "Roboto Flex", sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            text-align: center;
            background-image: url("contents/background.png"); /* Replace with your actual path */
		    background-size: cover;        /* Scales the image to cover the whole screen */
		    background-repeat: no-repeat;  /* Prevents tiling */
		    background-position: center;
        }

        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-botton: 100px;
        }

        .logo {
            width: 300px;
            margin-bottom: 20px;
        }

        h2 {
            font-weight: 600;
            margin-bottom: 20px;
        }

        .btn {
            background-color: #e1483b;
            color: #fff;
            border: none;
            padding: 10px 25px;
            font-size: 16px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            margin-bottom: 15px;
        }

        .signup {
            font-size: 14px;
            color: #555;
        }

        .signup a {
            color: #4090f6;
            text-decoration: none;
        }

        .footer {
            position: absolute;
            bottom: 20px;
            font-size: 13px;
            color: #999;
        }
    </style>
</head>
<body>
    <div class="container">
        <img src="contents/jade_bank_logo.png" alt="JadeBank Logo" class="logo"/>

        <h2>Log in to access JadeBank.</h2>

        <a href="Login.jsp" class="btn">SIGN IN</a>

        <div class="signup">
            Don’t have a JadeBank account? <a href="SignUp.jsp">Sign Up Now</a>
        </div>
    </div>

    <div class="footer">
        © 2025, JadeBank Pvt. Ltd. All Rights Reserved.
    </div>
</body>
</html>
