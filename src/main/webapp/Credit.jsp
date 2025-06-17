<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Credit Amount</title>
    <style>
        body {
            font-family: "Roboto", sans-serif;
            background-color: #f7f7f7;
        }
        .credit-form-container {
            width: 400px;
            margin: 50px auto;
            padding: 25px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        label, input, button {
            display: block;
            width: 100%;
            margin-bottom: 15px;
        }
        input[type="number"], input[type="password"] {
            padding: 8px;
        }
        button {
            padding: 10px;
            background-color: #007bff;
            color: white;
            font-weight: bold;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        #account-info {
            font-size: 14px;
            margin-top: -10px;
            margin-bottom: 10px;
            color: #444;
        }
        #credit-status {
            margin-top: 10px;
            font-weight: bold;
            text-align: center;
        }
        /* Modal style */
        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background: white;
            padding: 20px;
            border-radius: 10px;
            width: 300px;
            text-align: center;
        }
    </style>
</head>
<body>
    <jsp:include page="LoggedInHeader.jsp" />

    <div class="credit-form-container">
        <h2>Credit Transaction</h2>
        <form id="creditForm">
            <label for="accountId">Account ID:</label>
            <input type="number" id="accountId" name="accountId" required>

            <div id="account-info"></div>

            <button type="button" onclick="fetchAccountDetails()">Check Details</button>

            <label for="amount">Amount:</label>
            <input type="number" id="amount" name="amount" step="0.01" required>

            <button type="button" onclick="openPasswordModal()">Credit</button>
            <div id="credit-status"></div>
        </form>
    </div>

    <!-- Password Modal -->
    <div class="modal" id="passwordModal">
        <div class="modal-content">
            <h3>Confirm Password</h3>
            <input type="password" id="confirmPassword" placeholder="Enter your password" required>
            <br>
            <button onclick="submitCredit()">Confirm</button>
        </div>
    </div>

    <jsp:include page="Footer.jsp" />

    <script>
        let accountDetails = null;

        function fetchAccountDetails() {
            const accountId = parseInt(document.getElementById("accountId").value);
            const infoDiv = document.getElementById("account-info");
            infoDiv.textContent = "";

            if (!accountId) {
                infoDiv.textContent = "Please enter a valid account ID.";
                return;
            }

            fetch(`${pageContext.request.contextPath}/jadebank/account/details`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ accountId: accountId })
            })
            .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch"))
            .then(data => {
                accountDetails = data;
                infoDiv.textContent = `Customer ID: ${data.customerId}, Name: ${data.fullName}`;
            })
            .catch(err => {
                infoDiv.textContent = "Error fetching account details.";
                console.error(err);
            });
        }

        function openPasswordModal() {
            document.getElementById("passwordModal").style.display = "flex";
        }

        function submitCredit() {
            const accountId = parseInt(document.getElementById("accountId").value);
            const amount = parseFloat(document.getElementById("amount").value);
            const password = document.getElementById("confirmPassword").value;
            const statusDiv = document.getElementById("credit-status");
            const modal = document.getElementById("passwordModal");

            if (!accountId || !amount || amount <= 0 || !password) {
                statusDiv.textContent = "All fields and password are required.";
                statusDiv.style.color = "red";
                return;
            }

            const data = {
                transaction: {
                    accountId: accountId,
                    amount: amount,
                    transactionType: 1
                },
                password: password
            };

            fetch(`${pageContext.request.contextPath}/jadebank/transaction/transfer`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(data)
            })
            .then(async res => {
                modal.style.display = "none";
                if (res.ok) {
                    statusDiv.textContent = "Amount credited successfully.";
                    statusDiv.style.color = "green";
                    document.getElementById("creditForm").reset();
                    document.getElementById("account-info").textContent = "";
                } else {
                    const error = await res.json();
                    statusDiv.textContent = error.error || "Credit failed.";
                    statusDiv.style.color = "red";
                }
            })
            .catch(err => {
                modal.style.display = "none";
                statusDiv.textContent = "Network error: " + err.message;
                statusDiv.style.color = "red";
            });
        }

        // Close modal on outside click
        window.onclick = function(event) {
            const modal = document.getElementById("passwordModal");
            if (event.target === modal) {
                modal.style.display = "none";
            }
        };
    </script>
</body>
</html>
