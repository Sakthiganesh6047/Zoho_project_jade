<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Debit Amount</title>
    <style>
        body {
            font-family: "Roboto", sans-serif;
            background-color: #f7f7f7;
        }
        .debit-form-container {
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
    
    <div class="debit-form-container">
	    <h2>Debit Amount from Account</h2>
	
	    <form id="debitForm">
	        <label>Account ID: <input type="number" id="accountId" required></label><br>
	        <div id="infoDiv" style="font-weight: bold;"></div>
	        <button type="button" onclick="checkDetails()">Check Details</button><br>
	        <label>Amount: <input type="number" id="amount" required></label><br>
	        <button type="button" onclick="showPasswordModal()">Submit Debit</button>
	        <div id="debit-status"></div>
	    </form>
    </div>

    <!-- Password Modal -->
    <div id="passwordModal" class="modal">
        <div class="modal-content">
            <label>Enter Password to Confirm:</label><br>
            <input type="password" id="confirmPassword"><br><br>
            <button onclick="submitDebit()">Confirm</button>
            <button onclick="closeModal()">Cancel</button>
        </div>
    </div>

    <script>
        let accountDetails = null;

        function checkDetails() {
            const accountId = parseInt(document.getElementById("accountId").value);
            if (!accountId) return;

            fetch(`${pageContext.request.contextPath}/jadebank/account/details`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ accountId: accountId })
            })
            .then(res => res.ok ? res.json() : Promise.reject("Fetch failed"))
            .then(data => {
            	if (!data || !data.fullName || !data.customerId) {
                    infoDiv.textContent = "No customer data found.";
                    return;
                }
                accountDetails = data;
                document.getElementById("infoDiv").textContent = "Customer Data: Name: " + data.fullName + ", CustomerId: " + data.customerId;
            })
            .catch(err => {
                document.getElementById("infoDiv").textContent = "Account not found";
                console.error(err);
            });
        }

        function showPasswordModal() {
            document.getElementById("passwordModal").style.display = "block";
        }

        function closeModal() {
            document.getElementById("passwordModal").style.display = "none";
            document.getElementById("confirmPassword").value = "";
        }

        function submitDebit() {
            const accountId = parseInt(document.getElementById("accountId").value);
            const amount = parseFloat(document.getElementById("amount").value);
            const password = document.getElementById("confirmPassword").value;
            const statusDiv = document.getElementById("debit-status");
            const modal = document.getElementById("passwordModal");

            if (!accountId || !amount || amount <= 0 || !password || !accountDetails) {
                statusDiv.textContent = "All fields, password, and account check are required.";
                statusDiv.style.color = "red";
                return;
            }

            const data = {
                transaction: {
                    accountId: accountId,
                    customerId: accountDetails.customerId,
                    amount: amount,
                    transactionType: 2 // 2 = Debit
                },
                user: {
                    passwordHash: password
                }
            };

            fetch(`${pageContext.request.contextPath}/jadebank/transaction/transfer`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(data)
            })
            .then(async res => {
			    modal.style.display = "none";
			    document.getElementById("confirmPassword").value = "";
			
			    const result = await res.json();
			
			    if (res.ok && result.status === "success") {
			        statusDiv.textContent = "Amount debited successfully.";
			        statusDiv.style.color = "green";
			        document.getElementById("debitForm").reset();
			        document.getElementById("infoDiv").textContent = "";
			        accountDetails = null;
			    } else {
			        statusDiv.textContent = result.error || "Debit failed.";
			        statusDiv.style.color = "red";
			    }
			})
            .catch(err => {
                modal.style.display = "none";
                document.getElementById("confirmPassword").value = "";
                statusDiv.textContent = "Network error: " + err.message;
                statusDiv.style.color = "red";
            });
        }
    </script>

    <jsp:include page="Footer.jsp" />
</body>
</html>
