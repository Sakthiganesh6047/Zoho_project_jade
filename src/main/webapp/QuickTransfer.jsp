<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Long userId = (Long) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quick Transfer - JadeBank</title>
    <style>
        body {
            font-family: "Roboto", sans-serif;
            background-image: url("contents/background.png");
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            margin: 0;
            padding-top: 70px;
        }

        .body-wrapper {
            display: flex;
            min-height: 89vh;
        }

        .sidebar-wrapper {
            width: 60px;
            background-color: #373962;
            color: white;
            position: fixed;
            height: 100%;
            border-radius: 0 12px 12px 0;
            z-index: 1000;
        }

        .main-wrapper {
            padding: 40px 20px;
            flex: 1;
        }

        .form-container {
            max-width: 500px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        label {
            font-weight: bold;
            display: block;
            margin: 12px 0 6px;
        }

        select, input {
            width: 95%;
            padding: 10px;
            margin-bottom: 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            background-color: #414485;
            color: white;
            font-weight: bold;
            cursor: pointer;
            width: 100%;
        }

        button:hover {
            background-color: #3b5998;
        }

        #status {
            margin-top: 16px;
            font-weight: bold;
            text-align: center;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 2000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: #fff;
            margin: 15% auto;
            padding: 20px;
            border-radius: 10px;
            max-width: 400px;
        }
    </style>
</head>
<body>

<div class="body-wrapper">
    <div class="main-wrapper">
        <div class="form-container">
            <h2>Quick Money Transfer</h2>
            <form id="quickTransferForm">
                <label for="accountId">Select Your Account:</label>
                <select id="accountId" required>
                    <option value="">-- Select Account --</option>
                </select>

                <label for="bankName">Bank Name:</label>
                <select id="bankName" required>
                    <option value="">-- Select Bank --</option>
                    <option value="Jade Bank">Jade Bank</option>
                    <option value="SBI">SBI</option>
                    <option value="ICICI">ICICI</option>
                    <option value="HDFC">HDFC</option>
                    <option value="Axis">Axis</option>
                </select>

                <label for="beneficiaryName">Receiver Name:</label>
                <input type="text" id="beneficiaryName" maxlength="50" pattern="[A-Za-z]+(?:[\-' ][A-Za-z]+)*" required autofocus
                       title="Name should contain only letters, spaces, hyphens or apostrophes.">

                <label for="beneficiaryAccountNumber">Receiver Account Number:</label>
                <input type="text" name="beneficiaryAccountNumber" id="beneficiaryAccountNumber" maxlength="15" inputmode="numeric"
                       pattern="[1-9]\d{4,14}" title="Account number must be 5 to 15 digits" placeholder="Enter Receiver's Account No"  />

                <label for="ifscCode">IFSC Code:</label>
                <input type="text" id="ifscCode" maxlength="11" pattern="^[A-Z]{4}0[A-Z0-9]{6}$" title="Enter a valid IFSC code (e.g., JADE000000)." required>

                <label for="amount">Amount:</label>
                <input type="number" step="0.01" name="amount" id="amount" required min="0.01" max="100000" oninput="validateAmount(this)" />

                <label for="description">Description (optional):</label>
                <input type="text" id="description" name="description"
			       maxlength="100"
			       pattern="[A-Za-z0-9 ,.\-']*"
			       placeholder="Reason for transfer..."
			       title="Only letters, numbers, spaces, comma, dot, hyphen, and apostrophe allowed. Max 100 characters.">

                <button type="button" onclick="showPasswordModal()">Submit Transfer</button>
                <div id="status"></div>
            </form>
        </div>
    </div>
</div>

<!-- Password Modal -->
<div id="passwordModal" class="modal">
    <div class="modal-content">
        <label>Enter Password to Confirm:</label>
        <input type="password" id="confirmPassword">
        <br><br>
        <button onclick="submitTransfer()">Confirm</button><br><br>
        <button onclick="closeModal()">Cancel</button>
    </div>
</div>

<jsp:include page="Footer.jsp" />

<script>
	function validateAmount(input) {
	    input.value = input.value
	        .replace(/[^\d.]/g, '')
	        .replace(/^(\d*\.\d{0,2}).*$/, '$1');
	}

	document.getElementById("amount").addEventListener("keydown", function(e) {
	    if (["e", "E", "+", "-"].includes(e.key) || (e.key === "." && this.value.includes("."))) {
	        e.preventDefault();
	    }
	});

	document.getElementById("beneficiaryAccountNumber").addEventListener("input", function () {
	    this.value = this.value.replace(/\D/g, '');
	});

	const userId = <%= userId != null ? userId : "null" %>;

	window.onload = function () {
	    if (userId) {
	        fetch("<%= request.getContextPath() %>" + "/jadebank/account/id", {
	            method: "POST",
	            headers: { "Content-Type": "application/json" },
	            body: JSON.stringify({ userId: userId })
	        })
	        .then(res => res.ok ? res.json() : Promise.reject("Failed to load accounts"))
	        .then(accounts => {
	            const accountSelect = document.getElementById("accountId");
	            accounts.forEach(acc => {
	                const option = document.createElement("option");
	                option.value = acc.accountId;
	                option.textContent = "ID: " + acc.accountId + " | Type: " + (acc.accountType === 1 ? "Savings" : "Current");
	                accountSelect.appendChild(option);
	            });
	        })
	        .catch(err => console.error("Error loading accounts:", err));
	    }
	};

	function showPasswordModal() {
	    const form = document.getElementById("quickTransferForm");
	    const statusDiv = document.getElementById("status");
	    statusDiv.textContent = "";
	    if (!form.checkValidity()) {
	        form.reportValidity();
	        return;
	    }
	    document.getElementById("passwordModal").style.display = "block";
	}

	function closeModal() {
	    document.getElementById("passwordModal").style.display = "none";
	    document.getElementById("confirmPassword").value = "";
	}
	
	function showStatusMessage(message, color = "black", duration = 5000) {
        const statusDiv = document.getElementById("status");
        statusDiv.textContent = message;
        statusDiv.style.color = color;

        // Clear message after `duration` ms
        setTimeout(() => {
            statusDiv.textContent = "";
        }, duration);
    }

	function submitTransfer() {
	    const accountId = parseInt(document.getElementById("accountId").value);
	    const beneficiaryName = document.getElementById("beneficiaryName").value.trim();
	    const bankName = document.getElementById("bankName").value.trim();
	    const beneficiaryAccountNumber = parseInt(document.getElementById("beneficiaryAccountNumber").value);
	    const ifscCode = document.getElementById("ifscCode").value.trim();
	    const amount = parseFloat(document.getElementById("amount").value);
	    const description = document.getElementById("description").value.trim();
	    const password = document.getElementById("confirmPassword").value;
	    const statusDiv = document.getElementById("status");
	    const modal = document.getElementById("passwordModal");

	    if (!accountId || !beneficiaryName || !bankName || !beneficiaryAccountNumber || !ifscCode || !amount || !password) {
	        showStatusMessage("All fields are required.", "red");
	        return;
	    }

	    const data = {
	        transaction: {
	            accountId: accountId,
	            customerId: userId,
	            amount: amount,
	            description: description,
	            transactionType: 4
	        },
	        beneficiary: {
	        	beneficiaryId: 0,
	            beneficiaryName: beneficiaryName,
	            bankName: bankName,
	            beneficiaryAccountNumber: beneficiaryAccountNumber,
	            ifscCode: ifscCode
	        },
	        user: {
	            passwordHash: password
	        }
	    };

	    fetch("<%= request.getContextPath() %>" + "/jadebank/transaction/transfer", {
	        method: "POST",
	        headers: { "Content-Type": "application/json" },
	        body: JSON.stringify(data)
	    })
	    .then(async res => {
	        modal.style.display = "none";
	        document.getElementById("confirmPassword").value = "";
	        const result = await res.json();
	        if (res.ok && result.status === "success") {
	            showStatusMessage("Transfer successful", "green");
	            document.getElementById("quickTransferForm").reset();
	        } else {
	            showStatusMessage(result.error || "Transfer failed.", "red");
	        }
	    })
	    .catch(err => {
	        modal.style.display = "none";
	        showStatusMessage("Network error: " + err.message, "red");
	    });
	}
</script>
</body>
</html>