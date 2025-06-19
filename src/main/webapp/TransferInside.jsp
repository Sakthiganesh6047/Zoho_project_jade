<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Inside Bank Transfer</title>
    <style>
        body {
		    font-family: "Roboto", sans-serif;
		    background-color: #f7f7f7;
		    margin: 0;
		    display: flex;
		    flex-direction: column;
		    min-height: 100vh;
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
		    padding: 40px 20px;
		    flex: 1;
		    display: flex;
		    justify-content: center;
		    align-items: flex-start;
		}
		
		form {
		    width: 100%;
		    max-width: 650px;
		    background: #fff;
		    padding: 30px;
		    border-radius: 12px;
		    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
		}
		
		h2 {
		    text-align: center;
		    margin-bottom: 25px;
		    color: #373962;
		}
		
		fieldset {
		    border: none;
		    margin-bottom: 30px;
		    padding: 0;
		}
		
		legend {
		    font-size: 1.2rem;
		    margin-bottom: 10px;
		    font-weight: bold;
		    color: #333;
		}
		
		label {
		    display: block;
		    margin-top: 10px;
		    font-weight: 600;
		    color: #444;
		}
		
		input {
		    width: 100%;
		    padding: 10px;
		    border-radius: 6px;
		    border: 1px solid #ccc;
		    margin-top: 5px;
		    box-sizing: border-box;
		}
		
		input:focus {
		    border-color: #007bff;
		    outline: none;
		}
		
		button {
		    background-color: #414485;
		    color: white;
		    border: none;
		    padding: 12px;
		    border-radius: 6px;
		    cursor: pointer;
		    font-weight: bold;
		    margin-top: 15px;
		    width: 100%;
		}
		
		button:hover {
		    background-color: #0056b3;
		}
		
		.info-box {
		    background-color: #eef6ff;
		    padding: 12px;
		    margin-top: 10px;
		    border-left: 4px solid #007acc;
		    border-radius: 6px;
		    font-size: 0.95rem;
		    color: #333;
		}
		
		/* Modal */
		#passwordModal {
		    display: none;
		    position: fixed;
		    top: 50%; left: 50%;
		    transform: translate(-50%, -50%);
		    background-color: #fff;
		    padding: 25px;
		    border-radius: 10px;
		    box-shadow: 0 4px 12px rgba(0,0,0,0.3);
		    z-index: 1001;
		    width: 320px;
		    text-align: center;
		}
		
		#passwordModal input {
		    width: 100%;
		    padding: 10px;
		    margin: 15px 0;
		    border: 1px solid #ccc;
		    border-radius: 6px;
		}
		
		#modalBackdrop {
		    display: none;
		    position: fixed;
		    top: 0; left: 0;
		    width: 100%; height: 100%;
		    background: rgba(0,0,0,0.5);
		    z-index: 1000;
		}
		
		.error {
		    color: red;
		    font-weight: bold;
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
		        <form id="transferForm" method="post" action="jadebank/transfer">
		            <h2>Inside Bank Transfer</h2>
		
		            <input type="hidden" name="transaction.transactionType" value="3" />
		
		            <!-- Sender Section -->
		            <fieldset>
		                <legend>Sender Details</legend>
		
		                <label for="senderAccountId">Sender Account ID:</label>
		                <input type="number" name="transaction.accountId" id="senderAccountId" required onblur="fetchSenderDetails()" />
		
		                <div id="infoDiv" class="info-box"></div>
		
		                <label for="amount">Amount:</label>
		                <input type="number" step="0.01" name="transaction.amount" id="amount" required />
		
		                <label for="description">Description:</label>
		                <input type="text" name="transaction.description" id="description" />
		            </fieldset>
		
		            <!-- Receiver Section -->
		            <fieldset>
		                <legend>Receiver Details</legend>
		
		                <label for="receiverAccount1">Receiver Account Number:</label>
		                <input type="number" id="receiverAccount1" name="beneficiary.accountNumber" required />
		
		                <label for="receiverAccount2">Confirm Account Number:</label>
		                <input type="number" id="receiverAccount2" required />
		
		                <button type="button" onclick="checkReceiverDetails()">Check Receiver Details</button>
		                <div id="receiverDetails" class="info-box"></div>
		            </fieldset>
		
		            <button type="button" onclick="showPasswordModal()">Transfer</button>
		        </form>
		    </div>
		</div>
		
		<!-- Modal for Password -->
		<div id="modalBackdrop"></div>
		<div id="passwordModal">
		    <p><strong>Confirm Password:</strong></p>
		    <input type="password" id="confirmPassword" placeholder="Enter your password">
		    <button type="button" onclick="submitTransfer()">Confirm</button>
		    <button type="button" onclick="closeModal()">Cancel</button>
		</div>
		
		<jsp:include page="Footer.jsp" />
    
    <script>
	    let senderDetails = null;
	
	    function fetchSenderDetails() {
	        const accountId = parseInt(document.getElementById("senderAccountId").value);
	        if (!accountId) return;
	
	        fetch(`${pageContext.request.contextPath}/jadebank/account/details`, {
	            method: "POST",
	            headers: { "Content-Type": "application/json" },
	            body: JSON.stringify({ accountId: accountId })
	        })
	        .then(res => res.ok ? res.json() : Promise.reject("Fetch failed"))
	        .then(data => {
	            if (!data || !data.fullName || !data.customerId) {
	                document.getElementById("infoDiv").textContent = "No sender data found.";
	                return;
	            }
	            senderDetails = data;
	            document.getElementById("infoDiv").textContent = "Sender: " + data.fullName + ", Customer ID: " + data.customerId;
	        })
	        .catch(err => {
	            document.getElementById("infoDiv").textContent = "Account not found";
	            console.error(err);
	        });
	    }
	    
	    function checkReceiverDetails() {
	        const accountId = parseInt(document.getElementById("receiverAccount2").value);
	        if (!accountId) return;
	
	        fetch(`${pageContext.request.contextPath}/jadebank/account/details`, {
	            method: "POST",
	            headers: { "Content-Type": "application/json" },
	            body: JSON.stringify({ accountId: accountId })
	        })
	        .then(res => res.ok ? res.json() : Promise.reject("Fetch failed"))
	        .then(data => {
	            if (!data || !data.fullName || !data.customerId) {
	                document.getElementById("receiverDetails").textContent = "No sender data found.";
	                return;
	            }
	            senderDetails = data;
	            document.getElementById("receiverDetails").textContent = "Receiver: " + data.fullName + ", Customer ID: " + data.customerId;
	        })
	        .catch(err => {
	            document.getElementById("receiverDetails").textContent = "Account not found";
	            console.error(err);
	        });
	    }
	    
	    function showPasswordModal() {
	        document.getElementById("passwordModal").style.display = "block";
	        document.getElementById("modalBackdrop").style.display = "block";
	    }

	    function closeModal() {
	        document.getElementById("passwordModal").style.display = "none";
	        document.getElementById("modalBackdrop").style.display = "none";
	        document.getElementById("confirmPassword").value = "";
	    }

	
	    function submitTransfer() {
	        const accountId = parseInt(document.getElementById("senderAccountId").value);
	        const receiverAcc1 = document.getElementById("receiverAccount1").value.trim();
	        const receiverAcc2 = document.getElementById("receiverAccount2").value.trim();
	        const amount = parseFloat(document.getElementById("amount").value);
	        const description = document.getElementById("description").value;
	        const password = document.getElementById("confirmPassword").value;
	        const statusDiv = document.getElementById("receiverDetails");
	        const modal = document.getElementById("passwordModal");
	
	        if (!accountId || !amount || amount <= 0 || !password || !senderDetails) {
	            statusDiv.textContent = "All fields, password, and account check are required.";
	            statusDiv.style.color = "red";
	            return;
	        }
	
	        if (receiverAcc1 !== receiverAcc2) {
	            statusDiv.textContent = "Receiver account numbers do not match.";
	            statusDiv.style.color = "red";
	            return;
	        }
	
	        const data = {
	            transaction: {
	                accountId: accountId,
	                customerId: senderDetails.customerId,
	                amount: amount,
	                description: description,
	                transactionType: 3
	            },
	            beneficiary: {
	                beneficiaryAccountNumber: receiverAcc1
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
	            document.getElementById("modalBackdrop").style.display = "none";
	            document.getElementById("confirmPassword").value = "";
	
	            const result = await res.json();
	
	            if (res.ok && result.status === "success") {
	                statusDiv.textContent = "Transfer completed successfully.";
	                statusDiv.style.color = "green";
	                document.getElementById("transferForm").reset();
	                document.getElementById("infoDiv").textContent = "";
	                senderDetails = null;
	            } else {
	                statusDiv.textContent = result.message || "Transfer failed.";
	                statusDiv.style.color = "red";
	            }
	        })
	        .catch(err => {
	            modal.style.display = "none";
	            document.getElementById("modalBackdrop").style.display = "none";
	            document.getElementById("confirmPassword").value = "";
	            statusDiv.textContent = "Network error: " + err.message;
	            statusDiv.style.color = "red";
	        });
	    }
	</script>
	    
</body>
</html>
