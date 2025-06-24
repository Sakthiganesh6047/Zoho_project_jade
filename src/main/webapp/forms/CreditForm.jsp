<div class="form-box">
    <h2>Credit Transaction</h2>
    <form id="creditForm">
        <label for="creditAccountId">Account ID:</label>
        <input type="number" id="creditAccountId" name="accountId" required onblur="fetchCreditAccountDetails()">

        <div id="credit-account-info"></div>

        <label for="creditAmount">Amount:</label>
        <input type="number" step="0.01" name="amount" id="creditAmount" required min="0.01" max="100000" oninput="validateAmount(this)" />

        <button type="button" onclick="openCreditPasswordModal()">Credit</button>
        <div id="credit-status" style="display: flex;justify-content: center;"></div>
    </form>
</div>

<!-- Password Modal -->
<div class="modal" id="creditPasswordModal" style="display:none">
    <div class="modal-content">
        <h3>Confirm Password</h3>
        <input type="password" id="creditConfirmPassword" placeholder="Enter your password" required>
        <br>
        <button onclick="submitCredit()">Confirm</button>
        <button onclick="closeCreditPasswordModal()">Cancel</button>
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
            infoDiv.textContent = "Customer: " + data.fullName + ", Customer ID: " + data.customerId;
        })
        .catch(err => {
            infoDiv.textContent = "Error fetching account details.";
            console.error(err);
        });
    }

    function openCreditPasswordModal() {
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
