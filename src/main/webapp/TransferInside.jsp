<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Inside Bank Transfer</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            padding: 40px;
        }

        form {
            max-width: 600px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        fieldset {
            border: none;
            margin-bottom: 25px;
        }

        legend {
            font-size: 1.2em;
            margin-bottom: 10px;
            font-weight: bold;
        }

        label {
            display: block;
            margin: 8px 0 5px;
        }

        input {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            margin-bottom: 10px;
        }

        button {
            background-color: #0066cc;
            color: white;
            border: none;
            padding: 12px 18px;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 10px;
        }

        button:hover {
            background-color: #004d99;
        }

        .info-box {
            background-color: #f0f9ff;
            padding: 10px;
            margin-top: 8px;
            border-left: 5px solid #007acc;
            border-radius: 4px;
        }
        
        #passwordModal {
		    display: none;
		    position: fixed;
		    top: 30%;
		    left: 50%;
		    transform: translate(-50%, -30%);
		    background-color: #fff;
		    padding: 20px 30px;
		    border-radius: 8px;
		    box-shadow: 0 4px 12px rgba(0,0,0,0.3);
		    z-index: 1000;
		}

		#passwordModal input {
		    margin-top: 10px;
		    margin-bottom: 15px;
		}

        .error {
            color: red;
        }
    </style>

</head>
<body>

	<jsp:include page="LoggedInHeader.jsp" />
	    
    <h2>Inside Bank Transfer</h2>
    <form id="transferForm" method="post" action="jadebank/transfer">
        <input type="hidden" name="transaction.transactionType" value="3" />

        <!-- Sender Section -->
        <fieldset>
            <legend>Sender Details</legend>
            <label for="senderAccountId">Your Account ID:</label>
            <input type="number" name="transaction.accountId" id="senderAccountId" required onblur="fetchSenderDetails()" />

            <div id="infoDiv" class="info-box"></div>

            <label for="transaction.amount">Amount:</label>
            <input type="number" step="0.01" name="transaction.amount" id="amount" required />

            <label for="transaction.description">Description:</label>
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

        <div id="passwordModal" style="display:none;">
		    <p>Confirm Password:</p>
		    <input type="password" id="confirmPassword" />
		    <button type="button" onclick="submitTransfer()">Confirm</button>
		    <button type="button" onclick="closeModal()">Cancel</button>
		</div>
		<div id="modalBackdrop" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:#00000080; z-index:999;"></div>


        <button type="button" onclick="showPasswordModal()">Transfer</button>
    </form>
    
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

	<jsp:include page="Footer.jsp" />
	    
</body>
</html>
