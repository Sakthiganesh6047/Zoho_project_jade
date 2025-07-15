<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Long userId = (Long) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Fund Transfer - JadeBank</title>
    <style>
        body {
            font-family: "Roboto", sans-serif;
            background-image: url("contents/background.png"); /* Replace with your actual path */
		    background-size: cover;        /* Scales the image to cover the whole screen */
		    background-repeat: no-repeat;  /* Prevents tiling */
		    background-position: center;
            margin: 0;
            padding-top: 70px; /* same as header height */
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

        input, select, textarea {
            width: 99%;
            padding: 10px;
            margin-bottom: 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
            background-color: white;
        }
        
        input {
            width: 95.5%;
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
            <h2>Transfer Funds</h2>
            <form id="transferForm">
                <label for="accountId">Select Your Account:</label>
                <select id="accountId" required onchange="handleAccountChange()">
                    <option value="">-- Select Account --</option>
                </select>

                <label for="beneficiaryId">Select Beneficiary:</label>
                <select id="beneficiaryId" required>
                    <option value="">-- Select Beneficiary --</option>
                </select>

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
        // Disallow: e, +, -, and multiple dots
        if (
            ["e", "E", "+", "-"].includes(e.key) ||
            (e.key === "." && this.value.includes("."))
        ) {
            e.preventDefault();
        }
    });

    document.getElementById("amount").addEventListener("input", function () {
        const val = parseFloat(this.value);
        if (isNaN(val) || val < 0.01 || val > 100000) {
            this.setCustomValidity("Amount must be between ₹0.01 and ₹100000.");
        } else {
            this.setCustomValidity("");
        }
    });

    const userId = <%= userId != null ? userId : "null" %>;

    window.onload = function () {
        if (userId) {
            fetch(`${pageContext.request.contextPath}/jadebank/account/id`, {
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

    function handleAccountChange() {
        const accountId = parseInt(document.getElementById("accountId").value);
        if (!accountId) return;

        const select = document.getElementById("beneficiaryId");
        select.innerHTML = '<option value="">-- Select Beneficiary --</option>';

        fetch(`${pageContext.request.contextPath}/jadebank/beneficiary/id?limit=100&offset=0`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ accountId: accountId })
        })
        .then(res => res.ok ? res.json() : Promise.reject("Failed to load beneficiaries"))
        .then(beneficiaries => {
            if (!beneficiaries.length) {
                const opt = document.createElement("option");
                opt.value = "";
                opt.textContent = "No beneficiaries found";
                select.appendChild(opt);
                return;
            }

            beneficiaries.forEach(b => {
                const option = document.createElement("option");
                option.value = JSON.stringify(b);  // Store full object
                option.textContent = b.beneficiaryName + " - " + b.bankName + " - " + b.beneficiaryAccountNumber;
                select.appendChild(option);
            });
        })
        .catch(err => console.error("Error fetching beneficiaries:", err));
    }

    function showPasswordModal() {
        const accountId = document.getElementById("accountId").value;
        const beneficiaryId = document.getElementById("beneficiaryId").value;
        const amount = document.getElementById("amount").value;
        const amountVal = parseFloat(amount);
        const statusDiv = document.getElementById("status");
        statusDiv.textContent = ""; // Reset previous message
        
        if (amountVal < 0.01 || amountVal > 100000) {
            showStatusMessage("Amount must be between ₹0.01 and ₹1,00,000.", "red");

            return;
        }

        if (!accountId || !beneficiaryId || !amount || isNaN(amountVal)) {
        	showStatusMessage("Please fill all required fields correctly.", "red");
            return;
        }
        
     // Validate description pattern manually only if it's not empty
        const descPattern = /^[A-Za-z0-9 ,.\-']*$/;
        if (description.length > 0 && (!descPattern.test(description) || description.length > 100)) {
            showStatusMessage("Description can only contain letters, numbers, space, comma, dot, hyphen, apostrophe. Max 100 chars.", "red");
            return;
        }

        // All checks passed
        document.getElementById("passwordModal").style.display = "block";
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

    function closeModal() {
        document.getElementById("passwordModal").style.display = "none";
        document.getElementById("confirmPassword").value = "";
    }

    function submitTransfer() {
        const accountId = parseInt(document.getElementById("accountId").value);
        const beneficiaryJSON = document.getElementById("beneficiaryId").value;
        const amount = parseFloat(document.getElementById("amount").value);
        const descriptionInput = document.getElementById("description");
        const description = descriptionInput.value.trim();
        const password = document.getElementById("confirmPassword").value;

        const statusDiv = document.getElementById("status");
        const modal = document.getElementById("passwordModal");

        if (!accountId || !beneficiaryJSON || isNaN(amount) || amount < 0.01 || amount > 100000 || !password) {
            showStatusMessage("All fields are required. Amount must be between ₹0.01 and ₹100000.", "red");
            return;
        }

        const beneficiary = JSON.parse(beneficiaryJSON);

        const data = {
            transaction: {
                accountId: accountId,
                customerId: userId,
                amount: amount,
                description: description,
                transactionType: 4
            },
            beneficiary: beneficiary,
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
                showStatusMessage("Transfer successful.", "green");
                document.getElementById("transferForm").reset();
                document.getElementById("beneficiaryId").innerHTML = '<option value="">-- Select Beneficiary --</option>';
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
