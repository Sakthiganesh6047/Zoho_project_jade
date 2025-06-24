<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>
<%
    Integer role = (Integer) session.getAttribute("role");
    Long userId = (Long) session.getAttribute("userId");
    if (role == null || role != 0 || userId == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard - JadeBank</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" />
<style>
        body {
            margin: 0;
            font-family: "Segoe UI", sans-serif;
            background-color: #f4f6f8;
            padding-top: 70px; /* same as header height */
        }

        .body-wrapper {
            display: flex;
            min-height: 100vh;
        }

        .content-wrapper {
            flex-grow: 1;
            margin-left: 70px;
            padding: 20px 30px;
            display: flex;
            gap: 30px;
            transition: margin-left 0.3s ease;
        }
        
        .sidebar.expanded ~ .content-wrapper {
            margin-left: 220px;
        }

        .stats-panel {
            flex-grow: 1;
        }

        .operations-panel {
            width: 350px;
            display: flex;
            flex-direction: column;
            gap: 20px;
            order: 2;
        }

        .dashboard-card {
            background: white;
            padding: 30px 20px;
            border-radius: 12px;
            text-align: center;
            text-decoration: none;
            color: #373962;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: 0.3s;
            min-height: 120px;
            display: flex;
		    flex-direction: column;
		    justify-content: center;
		    align-items: center;
        }

        .dashboard-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.15);
        }

        .dashboard-card i {
            font-size: 24px;
            color: #414485;
            margin-bottom: 10px;
        }

        .dashboard-card h4 {
            margin: 5px 0;
            font-size: 17px;
        }

        .dashboard-card p {
            font-size: 13px;
            color: #666;
        }

        .profile-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
            padding: 20px;
            background: linear-gradient(135deg, #414485, #5c6bc0);
            color: white;
            border-radius: 12px;
        }

        .profile-header .info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .profile-header img {
            width: 60px;
            height: 60px;
            border-radius: 50%;
        }

        .profile-header .name-role {
            display: flex;
            flex-direction: column;
        }

        .profile-header .name-role h2 {
            margin: 0;
            font-size: 20px;
        }

        .profile-header .name-role p {
            margin: 0;
            font-size: 13px;
            color: #e0e0e0;
        }

        .edit-icon {
            font-size: 22px;
            color: white;
            cursor: pointer;
        }

        .account-summary {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .account-summary h3 {
            margin-bottom: 15px;
        }

        .account-card-list {
            display: flex;
            gap: 15px;
            overflow-x: auto;
        }

        .account-card {
            background: #f9fafb;
            padding: 20px;
            border-radius: 10px;
            min-width: 220px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            text-align: center;
        }

        .account-card h4 {
            margin: 5px 0;
            font-size: 17px;
            color: #414485;
        }

        .account-card p {
            margin: 0;
            font-size: 22px;
            font-weight: bold;
            color: green;
        }

        .recent-transactions, .account-control {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .account-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            font-size: 14px;
        }

        .account-meta {
            flex: 1;
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .toggle {
            position: relative;
            display: inline-block;
            width: 40px;
            height: 22px;
        }

        .toggle input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 22px;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 16px;
            width: 16px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }

        input:checked + .slider {
            background-color: #414485;
        }

        input:checked + .slider:before {
            transform: translateX(18px);
        }

        .transaction-item {
            font-size: 14px;
            padding: 5px 0;
            border-bottom: 1px solid #eee;
        }

        .popup {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translateX(-50%);
            background-color: #414485;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            z-index: 2000;
            display: none;
        }
    </style>
</head>
<body>
<jsp:include page="LoggedInHeader.jsp" />
<div class="body-wrapper">
    <jsp:include page="SideBar.jsp" />
    <div class="content-wrapper">
        <div class="stats-panel">
            <div class="profile-header">
                <div class="info">
                    <img id="profilePic" src="contents/man_6997551.png" alt="Profile Pic">
                    <div class="name-role">
                        <h2 id="userName">Loading...</h2>
                        <p id="userEmail">Email: -</p>
                        <p id="userPhone">Phone: -</p>
                    </div>
                </div>
                <i class="fas fa-pen-to-square edit-icon" onclick="redirectToEditProfile()"></i>
            </div>

            <div class="account-summary">
                <h3>Your Accounts</h3>
                <div class="account-card-list" id="accountList"></div>
            </div>
            
            <div class="account-control">
                <h3>Account Activation</h3>
                <div id="accountToggleList"></div>
            </div>

            <div class="recent-transactions">
                <h3>Last 10 Transactions</h3>
                <div id="transactionList" style="display: flex; gap: 20px; flex-wrap: wrap;"></div>
            </div>

        </div>

        <div class="operations-panel">
        	<a href="QuickTransfer.jsp" class="dashboard-card">
        		<i class="fas fa-bolt"></i>
        		<h4>Quick Transfer</h4>
        		<p>Instant Transfer</p>
        	</a>
        	<a href="CustomerTransfer.jsp" class="dashboard-card">
                <i class="fas fa-paper-plane"></i>
                <h4>Transfer</h4>
                <p>Send money</p>
            </a>
            <a href="CustomerAccTransactions.jsp" class="dashboard-card">
                <i class="fas fa-receipt"></i>
                <h4>Transactions</h4>
                <p>View history</p>
            </a>
            <a href="AddBeneficiary.jsp" class="dashboard-card">
                <i class="fas fa-user-plus"></i>
                <h4>Add Beneficiary</h4>
                <p>Save contacts</p>
            </a>
        </div>
    </div>
</div>
<div class="popup" id="popupMessage"></div>
<script>
	document.addEventListener("DOMContentLoaded", () => {
	    const wrapper = document.querySelector('.body-wrapper');
	    wrapper.classList.add('sidebar-collapsed');
	});
	
	const userId = <%= userId %>;
	const contextPath = "<%= request.getContextPath() %>";
	
	function showPopup(message) {
		const popup = document.getElementById("popupMessage");
	    popup.textContent = message;
	    popup.style.display = "block";
	    setTimeout(() => popup.style.display = "none", 2500);
	}
	
	fetch(`${pageContext.request.contextPath}/jadebank/user/profile`)
	    .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch user"))
	    .then(data => {
	        document.getElementById("userName").textContent = data.fullName || "Unknown";
	        document.getElementById("userEmail").textContent = "Email: " + (data.email || "N/A");
	        document.getElementById("userPhone").textContent = "Phone: " + (data.phone || "N/A");
	        document.getElementById("profilePic").src = data.gender?.toLowerCase() === "female"
	            ? "contents/woman_6997664.png"
	            : "contents/man_6997551.png";
	    });
	
	fetch(`${pageContext.request.contextPath}/jadebank/account/id`, {
	    method: "POST",
	    headers: { "Content-Type": "application/json" },
	    body: JSON.stringify({ userId })
	})
	.then(res => res.json())
	.then(accounts => {
	    const list = document.getElementById("accountList");
	    const toggleList = document.getElementById("accountToggleList");
	    list.innerHTML = "";
	    toggleList.innerHTML = "";
	    accounts.forEach(acc => {
	        const accType = acc.accountType === 1 ? "Savings" : "Current";
	        const accId = acc.accountId ?? "N/A";
	        const balance = acc.balance?.toLocaleString?.() ?? "0";
	        const card = document.createElement("div");
	        card.className = "account-card";
	        card.innerHTML =
	            "<h4>" + accType + " #" + accId + "</h4>" +
	            "<p>₹" + balance + "</p>";
	        list.appendChild(card);
	
	        const toggleRow = document.createElement("div");
	        toggleRow.className = "account-item";
	        toggleRow.innerHTML =
	            "<div class='account-meta'>" +
	                "<strong>" + accType + " #" + acc.accountId + "</strong><br>" +
	                "<span>Created: " + new Date(acc.createdAt).toLocaleDateString() + "</span>" +
	            "</div>" +
	            "<label class='toggle'>" +
	                "<input type='checkbox'" +
	                (acc.accountStatus === 1 ? " checked" : "") +
	                " onchange='handleToggle(this, " + acc.accountId + ", this.checked)'>" +
	                "<span class='slider'></span>" +
	            "</label>";
	        toggleList.appendChild(toggleRow);
	    });
	});
	
	function handleToggle(inputEl, accountId, isActive) {
	    const url = isActive ? "/jadebank/account/unblock" : "/jadebank/account/block";
	    const message = isActive ? "Account unblocked." : "Account blocked.";
	    fetch(contextPath+url, {
	        method: "POST",
	        headers: { "Content-Type": "application/json" },
	        body: JSON.stringify({ accountId })
	    })
	    .then(res => {
	        if (res.ok) {
	            showPopup(message);
	        } else {
	            inputEl.checked = !isActive;
	            showPopup("Operation failed.");
	        }
	    })
	    .catch(() => {
	        inputEl.checked = !isActive;
	        showPopup("Operation failed.");
	    });
	}
	
	fetch(contextPath + "/jadebank/transactions/customer?limit=10&offset=0", {
	    method: "POST",
	    headers: { "Content-Type": "application/json" },
	    body: JSON.stringify({ customerId: userId })
	})
	.then(res => res.json())
	.then(transactions => {
	    const transactionList = document.getElementById("transactionList");
	    transactionList.innerHTML = "";
	    transactions.forEach(tx => {
	    	const type = tx.transactionType === 1 ? "Credit" :
	             tx.transactionType === 2 ? "Debit" :
	             tx.transactionType === 3 ? "Transfer" :
	             "Unknown";
	        const amount = "₹" + tx.amount.toLocaleString();
	        const date = formatDate(tx.transactionDate);

	        const item = document.createElement("div");
	        item.className = "transaction-item";
	        item.style.flex = "1 1 40%";
	        const color = tx.transactionType === 1 ? "green" : "red";
	        item.innerHTML = date + " - " + amount + " <strong style='color:" + color + "'>" + type + "</strong>";

	        transactionList.appendChild(item);
	    });
	});
	
	function formatDate(timestamp) {
        const date = new Date(Number(timestamp));
        return date.toLocaleString("en-IN");
    }
	
	function redirectToEditProfile() {
	    window.location.href = `CustomerSignUp.jsp?userId=${userId}`;
	}
</script>
</body>
</html>
