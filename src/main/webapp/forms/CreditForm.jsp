<style>
	.form-box {
	    padding: 30px;
	    border-radius: 16px;
	    max-width: 750px;
	}
	
	.form-box h2 {
	    margin-bottom: 25px;
	    color: #1d3557;
	    text-align: center;
	    font-size: 26px;
	    font-weight: 600;
	}
	
	label {
	    font-weight: 500;
	    display: block;
	    margin-top: 10px;
	    margin-bottom: 5px;
	    color: #264653;
	}
	
	input[type="text"],
	input[type="number"],
	input[type="password"] {
	    width: 100%;
	    padding: 10px;
	    margin-bottom: 16px;
	    border-radius: 6px;
	    border: 1px solid #ccc;
	    font-size: 15px;
	    background: #ffffff;
	    box-shadow: inset 0 1px 2px rgba(0,0,0,0.05);
	    transition: border 0.2s ease;
	}
	
	input[type="number"]::-webkit-inner-spin-button,
	input[type="number"]::-webkit-outer-spin-button {
	    -webkit-appearance: none;
	    margin: 0;
	}
	
	input:focus {
	    border-color: #457b9d;
	    outline: none;
	}
	
	#credit-account-info {
	    margin: 12px 0;
	    color: #333;
	    background: #e9f5ff;
	    padding: 10px;
	    border-left: 4px solid #2196F3;
	    border-radius: 4px;
	    font-size: 14px;
	}
	
	.form-box .submit-wrapper {
	    display: flex;
	    justify-content: center;
	    margin-top: 20px;
	}
	
	#creditForm button[type="button"] {
	    padding: 12px 24px;
	    font-size: 16px;
	    font-weight: 600;
	    background-color: #1d3557;
	    color: white;
	    border-radius: 8px;
	    border: none;
	    transition: background 0.3s ease;
	}
	
	#creditForm button[type="button"]:hover {
	    background-color: #274c77;
	}
	
	button {
	    padding: 10px 20px;
	    border: none;
	    border-radius: 6px;
	    cursor: pointer;
	    font-weight: 500;
	    font-size: 15px;
	}
	
	button[type="button"] {
	    background: #1d3557;
	    color: white;
	    transition: background 0.3s ease;
	}
	
	button[type="button"]:hover {
	    background: #274c77;
	}
	
	#credit-status {
	    margin-top: 16px;
	    font-weight: bold;
	    font-size: 14px;
	    text-align: center;
	}
	
	.modal {
	    display: none;
	    position: fixed;
	    inset: 0;
	    background-color: rgba(0, 0, 0, 0.45);
	    z-index: 2000;
	    justify-content: center;
	    align-items: center;
	    animation: fadeInBackdrop 0.3s ease;
	}

	.modal-content {
	    background: #ffffff;
	    padding: 30px 24px;
	    border-radius: 16px;
	    width: 340px;
	    max-width: 90%;
	    text-align: center;
	    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
	    animation: scaleIn 0.3s ease;
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	}
	
	.modal-content .button-group {
	    display: flex;
	    justify-content: center;
	    gap: 12px;
	    margin-top: 10px;
	    width: 100%;
	}
	
	.modal-content h3 {
	    color: #1d3557;
	    margin-bottom: 20px;
	    font-size: 20px;
	    font-weight: 600;
	}
	
	.modal-content input[type="password"] {
	    width: 100%;
	    padding: 12px;
	    border-radius: 6px;
	    border: 1px solid #ccc;
	    margin-bottom: 20px;
	    font-size: 15px;
	    box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.05);
	}
	
	.modal-content button {
	    padding: 8px 16px;
	    font-size: 14px;
	    border-radius: 6px;
	    width: auto;
	    flex: 1;
	}
	
	.modal-content button:first-child {
	    background-color: #1d3557;
	    color: white;
	}
	
	.modal-content button:last-child {
	    background-color: #e0e0e0;
	    color: #333;
	}
	
	.modal-content button:first-of-type:hover {
	    background-color: #274c77;
	}
	
	.modal-content button:last-of-type:hover {
	    background-color: #d5d5d5;
	}
	
	/* Animations */
	@keyframes scaleIn {
	    0% {
	        opacity: 0;
	        transform: scale(0.95);
	    }
	    100% {
	        opacity: 1;
	        transform: scale(1);
	    }
	}
	
	@keyframes fadeInBackdrop {
	    0% {
	        background-color: rgba(0, 0, 0, 0);
	    }
	    100% {
	        background-color: rgba(0, 0, 0, 0.45);
	    }
	}


</style>

<div class="form-box">
    <h2>Credit Transaction</h2>
    <form id="creditForm">
        <label for="creditAccountId">Account ID:</label>
        <input type="number" id="creditAccountId" name="accountId" required onblur="fetchCreditAccountDetails()">

        <div id="credit-account-info" style="display: none;"></div>

        <label for="creditAmount">Amount:</label>
		<input type="number" step="0.01" name="amount" id="creditAmount"
		       required min="0.01" max="1000000"
		       title="Amount must be between 0.01 and 10,00,000">

        <div class="submit-wrapper">
		    <button type="button" onclick="openCreditPasswordModal()">Credit</button>
		</div>
        <div id="credit-status" style="display: flex;justify-content: center;"></div>
    </form>
</div>

<!-- Password Modal -->
<div class="modal" id="creditPasswordModal" style="display:none">
	<div class="modal-content">
	    <h3>Confirm Password</h3>
	    <input type="password" id="creditConfirmPassword" placeholder="Enter your password" required>
	    <div class="button-group">
	        <button onclick="submitCredit()">Confirm</button>
	        <button onclick="closeCreditPasswordModal()">Cancel</button>
	    </div>
	</div>
</div>

<script>
	
	document.getElementById("creditAmount").addEventListener("keydown", function(e) {
	    // Disallow: e, +, -, and multiple dots
	    if (
	        ["e", "E", "+", "-"].includes(e.key) ||
	        (e.key === "." && this.value.includes("."))
	    ) {
	        e.preventDefault();
	    }
	});

    let creditAccountDetails = null;

    function fetchCreditAccountDetails() {
        const accountId = parseInt(document.getElementById("creditAccountId").value);
        const infoDiv = document.getElementById("credit-account-info");
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
            creditAccountDetails = data;
            infoDiv.style.display = "block";
            infoDiv.textContent = "Customer: " + data.fullName + ", Customer ID: " + data.customerId;
        })
        .catch(err => {
        	infoDiv.style.display = "block";
        	infoDiv.textContent = "No customer data found.";
        });
    }
    
    function openCreditPasswordModal() {
        const accountId = parseInt(document.getElementById("creditAccountId").value);
        const amount = parseFloat(document.getElementById("creditAmount").value);
        const statusDiv = document.getElementById("credit-status");

        const MAX_AMOUNT = 1000000; // ₹10,00,000

        statusDiv.textContent = ""; // Clear previous messages

        if (!accountId || isNaN(amount) || !creditAccountDetails) {
            statusDiv.textContent = "Please fill all fields and validate the account before proceeding.";
            statusDiv.style.color = "red";
            return;
        }

        if (amount > MAX_AMOUNT || amount <= 0 ) {
            statusDiv.textContent = "Amount must not be below 1 or exceed 10,00,000.";
            statusDiv.style.color = "red";
            return;
        }

        // All checks passed → show modal
        document.getElementById("creditPasswordModal").style.display = "flex";
    }

    function closeCreditPasswordModal() {
        document.getElementById("creditPasswordModal").style.display = "none";
        document.getElementById("creditConfirmPassword").value = "";
    }

    function submitCredit() {
        const accountId = parseInt(document.getElementById("creditAccountId").value);
        const amount = parseFloat(document.getElementById("creditAmount").value);
        const password = document.getElementById("creditConfirmPassword").value;
        const statusDiv = document.getElementById("credit-status");
        const modal = document.getElementById("creditPasswordModal");

        if (!accountId || !amount || amount <= 0 || !password || !creditAccountDetails) {
            statusDiv.textContent = "All fields, password, and account check are required.";
            statusDiv.style.color = "red";
            return;
        }

        const data = {
            transaction: {
                accountId: accountId,
                customerId: creditAccountDetails.customerId,
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
            document.getElementById("creditConfirmPassword").value = "";

            if (res.ok) {
                statusDiv.textContent = "Amount credited successfully.";
                statusDiv.style.color = "green";
                document.getElementById("creditForm").reset();
                document.getElementById("credit-account-info").style.display = "none";
                document.getElementById("credit-account-info").textContent = "";
                creditAccountDetails = null;
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
</script>
