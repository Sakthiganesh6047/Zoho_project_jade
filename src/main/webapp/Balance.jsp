<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>
<%
    Long userId = (Long) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Check Balance - JadeBank</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-image: url("contents/background.png"); /* Replace with your actual path */
		    background-size: cover;        /* Scales the image to cover the whole screen */
		    background-repeat: no-repeat;  /* Prevents tiling */
		    background-position: center;
            margin: 0;
            padding: 0;
            padding-top: 70px; /* same as header height */
        }

        .main-wrapper {
            margin-left: 60px; /* Space for sidebar */
            padding: 40px 20px;
        }

        .balance-container {
            max-width: 600px;
            margin: auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            padding: 30px;
            text-align: center;
        }

        h2 {
            color: #414485;
            margin-bottom: 20px;
        }

        .balance-container select {
            width: 100%;
            padding: 10px;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 8px;
            margin-top: 15px;
        }

        .balance-display {
            margin-top: 30px;
            font-size: 1.8rem;
            color: #2b4c7e;
            font-weight: bold;
        }

        .icon {
            font-size: 3rem;
            color: #5c6bc0;
            margin-bottom: 15px;
        }

        .loader {
            margin-top: 20px;
            font-size: 14px;
            color: #888;
            display: none;
        }
    </style>
</head>
<body>

<jsp:include page="LoggedInHeader.jsp" />

	<div class="body-wrapper">
		<div class="sidebar-wrapper">
			<jsp:include page="SideBar.jsp" />
		</div>
		<div class="main-wrapper">
		    <div class="balance-container">
		        <div class="icon"><i class="fas fa-wallet"></i></div>
		        <h2>Check Account Balance</h2>
		
		        <select id="accountDropdown" onchange="fetchBalance()">
		            <option value="">-- Select Account --</option>
		        </select>
		
		        <div class="loader" id="loader">Fetching balance...</div>
		        <div class="balance-display" id="balanceDisplay">₹ --.--</div>
		    </div>
		</div>
	</div>

<script>
    const userId = <%= userId %>;

    function loadAccounts() {
        fetch(`${pageContext.request.contextPath}/jadebank/account/id`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ userId })
        })
        .then(res => res.json())
        .then(accounts => {
            const dropdown = document.getElementById("accountDropdown");
            accounts.forEach(acc => {
                const option = document.createElement("option");
                option.value = acc.accountId;
                option.textContent = "ID: " + acc.accountId + " | Type: " + (acc.accountType === 1 ? "Savings" : "Current");
                dropdown.appendChild(option);
            });
        })
        .catch(err => console.error("Failed to fetch accounts:", err));
    }

    function fetchBalance() {
        const accountId = document.getElementById("accountDropdown").value;
        const loader = document.getElementById("loader");
        const display = document.getElementById("balanceDisplay");

        if (!accountId) {
            display.textContent = "₹ --.--";
            return;
        }

        loader.style.display = "block";
        display.textContent = "";

        fetch(`${pageContext.request.contextPath}/jadebank/account/details`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ accountId })
        })
        .then(res => res.json())
        .then(data => {
            loader.style.display = "none";
            const balance = parseFloat(data.balance).toFixed(2);
            display.textContent = "₹ " + balance;
        })
        .catch(err => {
            loader.style.display = "none";
            display.innerHTML = `<span style="color: red;">Error fetching balance</span>`;
            console.error("Balance fetch error:", err);
        });
    }

    // Initialize
    loadAccounts();
</script>

</body>
</html>