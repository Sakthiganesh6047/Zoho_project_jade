<div class="form-box">
    <h2>Debit Transaction</h2>
    <form id="debitForm">
        <label for="debitAccountId">Account ID:</label>
      	<input type="number" id="debitAccountId" required onblur="fetchDebitAccountDetails()">

        <div id="debit-account-info" style="color: green;display: flex;justify-content: center;"></div>

        <label for="debitAmount">Amount:</label>
		<input type="number" step="0.01" name="amount" id="debitAmount" required min="0.01" max="100000" oninput="validateAmount(this)" />

        <button type="button" onclick="openDebitPasswordModal()">Debit</button>
        <div id="debit-status"></div>
    </form>
</div>

<!-- Password Modal -->
<div class="modal" id="debitPasswordModal" style="display:none">
    <div class="modal-content">
        <h3>Confirm Password</h3>
        <input type="password" id="debitConfirmPassword" placeholder="Enter your password">
        <br>
        <button onclick="submitDebit()">Confirm</button>
        <button onclick="closeDebitPasswordModal()">Cancel</button>
    </div>
</div>

<script>

	function validateAmount(input) {
	    input.value = input.value
	        .replace(/[^\d.]/g, '')        // Remove anything except digits and dot
	        .replace(/^(\d*\.\d{0,2}).*$/, '$1'); // Limit to 2 decimal places
	
	    if (Number(input.value) > 100000) {
	        input.value = "100000";
	    }
	}
	
	document.getElementById("debitAmount").addEventListener("keydown", function(e) {
	    // Disallow: e, +, -, and multiple dots
	    if (
	        ["e", "E", "+", "-"].includes(e.key) ||
	        (e.key === "." && this.value.includes("."))
	    ) {
	        e.preventDefault();
	    }
	});

    let debitAccountDetails = null;

    function fetchDebitAccountDetails() {
        const accountId = parseInt(document.getElementById("debitAccountId").value);
        const infoDiv = document.getElementById("debit-account-info");
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
        .then(res => res.ok ? res.json() : Promise.reject("Fetch failed"))
        .then(data => {
            if (!data || !data.fullName || !data.customerId) {
                infoDiv.textContent = "No customer data found.";
                return;
            }
            debitAccountDetails = data;
            infoDiv.textContent = "Customer: " + data.fullName + ", Customer ID: " + data.customerId;
        })
        .catch(err => {
            infoDiv.textContent = "Error fetching account details.";
            console.error(err);
        });
    }

    function openDebitPasswordModal() {
        document.getElementById("debitPasswordModal").style.display = "flex";
    }

    function closeDebitPasswordModal() {
        document.getElementById("debitPasswordModal").style.display = "none";
        document.getElementById("debitConfirmPassword").value = "";
    }

    function submitDebit() {
        const accountId = parseInt(document.getElementById("debitAccountId").value);
        const amount = parseFloat(document.getElementById("debitAmount").value);
        const password = document.getElementById("debitConfirmPassword").value;
        const statusDiv = document.getElementById("debit-status");
        const modal = document.getElementById("debitPasswordModal");

        if (!accountId || !amount || amount <= 0 || !password || !debitAccountDetails) {
            statusDiv.textContent = "All fields, password, and account check are required.";
            statusDiv.style.color = "red";
            return;
        }

        const data = {
            transaction: {
                accountId: accountId,
                customerId: debitAccountDetails.customerId,
                amount: amount,
                transactionType: 2
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
            document.getElementById("debitConfirmPassword").value = "";

            if (res.ok) {
                statusDiv.textContent = "Amount debited successfully.";
                statusDiv.style.color = "green";
                document.getElementById("debitForm").reset();
                document.getElementById("debit-account-info").textContent = "";
                debitAccountDetails = null;
            } else {
                const result = await res.json();
                statusDiv.textContent = result.error || "Debit failed.";
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
