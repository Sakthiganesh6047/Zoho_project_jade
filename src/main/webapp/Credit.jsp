<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Credit Amount</title>
    <style>
        body {
		    font-family: "Roboto", sans-serif;
		    background-image: url("contents/background.png"); /* Replace with your actual path */
		    background-size: cover;        /* Scales the image to cover the whole screen */
		    background-repeat: no-repeat;  /* Prevents tiling */
		    background-position: center;
		    margin: 0;
		    display: flex;
		    flex-direction: column;
		    min-height: 100vh;
		    padding-top: 70px; /* same as header height */
		}
		
		.body-wrapper {
		    display: flex;
		    flex: 1;
		    min-height: 70vh;
		}
		
		.sidebar-wrapper {
		    width: 60px;
		    border-radius: 0 12px 12px 0;
		    background-color: #373962;
		    color: white;
		    height: 100vh;
		    position: fixed;
		    left: 0;
		    z-index: 1000;
		}
		
		.content-wrapper {
		    margin-left: 70px;
		    flex: 1;
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    padding: 40px 20px;
		}
		
		.form-box {
		    background: white;
		    padding: 30px;
		    border-radius: 10px;
		    max-width: 450px;
		    width: 100%;
		    box-shadow: 0 0 12px rgba(0,0,0,0.1);
		}
		
		h2 {
		    text-align: center;
		    color: #373962;
		    margin-bottom: 25px;
		}
		
		label {
		    font-weight: bold;
		    margin-bottom: 6px;
		    display: block;
		    color: #333;
		}
		
		input[type="number"],
		input[type="password"] {
		    width: 100%;
		    padding: 10px;
		    border-radius: 6px;
		    border: 1px solid #ccc;
		    font-size: 1rem;
		    box-sizing: border-box;
		    margin-bottom: 15px;
		}
		
		input:focus {
		    outline: none;
		    border-color: #007bff;
		}
		
		button {
		    padding: 10px 20px;
		    background-color: #414485;
		    color: white;
		    font-weight: bold;
		    border: none;
		    border-radius: 6px;
		    cursor: pointer;
		    width: 100%;
		    transition: background-color 0.2s;
		}
		
		button:hover {
		    background-color: #0056b3;
		}
		
		#account-info {
		    font-size: 18px;
		    color: #414485;
		    margin: -10px 0 10px;
		    padding: 8px;
		}
		
		#credit-status {
		    margin-top: 15px;
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
		    z-index: 2000;
		}
		
		.modal-content {
		    background: white;
		    padding: 25px;
		    border-radius: 10px;
		    width: 320px;
		    text-align: center;
		    box-shadow: 0 0 12px rgba(0,0,0,0.2);
		}
		
		.modal-content h3 {
		    color: #373962;
		    margin-bottom: 15px;
		}
		
		.modal-content input {
		    margin-bottom: 15px;
		}
		
		.modal-content button {
		    width: auto;
		}
    </style>
</head>
<body>
    <jsp:include page="LoggedInHeader.jsp" />

	<div class="body-wrapper">
	    <div class="sidebar-wrapper">
	        <jsp:include page="SideBar.jsp" />
	    </div>
	
	    <div class="content-wrapper">
	        <div class="form-box">
	            <h2>Credit Transaction</h2>
	            <form id="creditForm">
	                <label for="accountId">Account ID:</label>
	                <input type="number" id="accountId" name="accountId" required>
	
	                <div id="account-info"></div>
	
	                <button type="button" onclick="fetchAccountDetails()">Check Details</button><br><br><br>
	
	                <label for="amount">Amount:</label>
	                <input type="number" id="amount" name="amount" step="0.01" required>
	
	                <button type="button" onclick="openPasswordModal()">Credit</button>
	                <div id="credit-status"></div>
	            </form>
	        </div>
	    </div>
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
            	if (!data || !data.fullName || !data.customerId) {
                    infoDiv.textContent = "No customer data found.";
                    return;
                }
                accountDetails = data;
                infoDiv.textContent = "Customer Data: Name: " + data.fullName + ", CustomerId: " + data.customerId ;
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
            
            if (!accountDetails || !accountDetails.customerId) {
                statusDiv.textContent = "Customer details are not loaded. Please use 'Check Details' first.";
                statusDiv.style.color = "red";
                return;
            }

            const data = {
                transaction: {
                    accountId: accountId,
                    customerId: accountDetails.customerId,
                    amount: amount,
                    transactionType: 1
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
                if (res.ok) {
                    statusDiv.textContent = "Amount credited successfully.";
                    statusDiv.style.color = "green";
                    document.getElementById("creditForm").reset();
                    document.getElementById("confirmPassword").value = "";
                    document.getElementById("account-info").textContent = "";
                } else {
                    const error = await res.json();
                    statusDiv.textContent = error.error || "Credit failed.";
                    document.getElementById("confirmPassword").value = "";
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
