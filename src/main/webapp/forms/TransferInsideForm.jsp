<div class="form-box">
    <h2>Inside Bank Transfer</h2>
    <form id="insideTransferForm">
        <input type="hidden" name="transaction.transactionType" value="3" />

        <!-- Sender Section -->
        <fieldset>
            <legend>Sender Details</legend>
            <label for="insideSenderAccountId">Sender Account ID:</label>
            <input type="number" name="transaction.accountId" id="insideSenderAccountId" required onblur="fetchInsideSenderDetails()" />
            <div id="insideInfoDiv" class="info-box hidden"></div>

            <label for="insideAmount">Amount:</label>
			<input type="number" step="0.01" name="transaction.amount" id="insideAmount" required min="0.01" max="100000" oninput="validateAmount(this)" />

            <label for="insideDescription">Description:</label>
            <input type="text" name="transaction.description" id="insideDescription" />
        </fieldset>

        <!-- Receiver Section -->
        <fieldset>
            <legend>Receiver Details</legend>

            <label for="insideReceiverAccount2">Receiver Account Number:</label>
            <input type="number" id="insideReceiverAccount2" required onblur="checkInsideReceiverDetails()" />

            <div id="insideReceiverDetails" class="info-box hidden"></div>
        </fieldset>

        <button type="button" onclick="openInsidePasswordModal()">Transfer</button>
    </form>
</div>

<!-- Password Modal -->
<div class="modal" id="insidePasswordModal" style="display:none">
    <div class="modal-content">
        <p><strong>Confirm Password:</strong></p>
        <input type="password" id="insideConfirmPassword" placeholder="Enter your password">
        <button type="button" onclick="submitInsideTransfer()">Confirm</button>
        <button type="button" onclick="closeInsidePasswordModal()">Cancel</button>
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
	
	document.getElementById("insideAmount").addEventListener("keydown", function(e) {
	    // Disallow: e, +, -, and multiple dots
	    if (
	        ["e", "E", "+", "-"].includes(e.key) ||
	        (e.key === "." && this.value.includes("."))
	    ) {
	        e.preventDefault();
	    }
	});

    let insideSenderDetails = null;

    function fetchInsideSenderDetails() {
        const accountId = parseInt(document.getElementById("insideSenderAccountId").value);
        const infoDiv = document.getElementById("insideInfoDiv");
        if (!accountId) return;

        fetch(`${pageContext.request.contextPath}/jadebank/account/details`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ accountId: accountId })
        })
        .then(res => res.ok ? res.json() : Promise.reject("Fetch failed"))
        .then(data => {
            if (!data || !data.fullName || !data.customerId) {
                infoDiv.textContent = "No sender data found.";
                infoDiv.classList.remove("hidden");
                return;
            }
            insideSenderDetails = data;
            infoDiv.textContent = "Sender: " + data.fullName + ", Customer ID: " + data.customerId;
            infoDiv.classList.remove("hidden");
        })
        .catch(err => {
            infoDiv.textContent = "Account not found";
            infoDiv.classList.remove("hidden");
            console.error(err);
        });
    }

    function checkInsideReceiverDetails() {
        const accountId = parseInt(document.getElementById("insideReceiverAccount2").value);
        const receiverDiv = document.getElementById("insideReceiverDetails");
        if (!accountId) return;

        fetch(`${pageContext.request.contextPath}/jadebank/account/details`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ accountId: accountId })
        })
        .then(res => res.ok ? res.json() : Promise.reject("Fetch failed"))
        .then(data => {
            if (!data || !data.fullName || !data.customerId) {
                receiverDiv.textContent = "No receiver data found.";
                receiverDiv.classList.remove("hidden");
                return;
            }
            receiverDiv.textContent = "Receiver: " + data.fullName + ", Customer ID: " + data.customerId;
            receiverDiv.classList.remove("hidden");
        })
        .catch(err => {
            receiverDiv.textContent = "Account not found";
            receiverDiv.classList.remove("hidden");
            console.error(err);
        });
    }

    function openInsidePasswordModal() {
        document.getElementById("insidePasswordModal").style.display = "flex";
    }

    function closeInsidePasswordModal() {
        document.getElementById("insidePasswordModal").style.display = "none";
        document.getElementById("insideConfirmPassword").value = "";
    }

    function submitInsideTransfer() {
        const accountId = parseInt(document.getElementById("insideSenderAccountId").value);
        const receiverAcc2 = document.getElementById("insideReceiverAccount2").value.trim();
        const amount = parseFloat(document.getElementById("insideAmount").value);
        const description = document.getElementById("insideDescription").value;
        const password = document.getElementById("insideConfirmPassword").value;
        const statusDiv = document.getElementById("insideReceiverDetails");

        if (!accountId || !amount || amount <= 0 || !password || !insideSenderDetails) {
            statusDiv.textContent = "All fields, password, and sender check are required.";
            statusDiv.style.color = "red";
            return;
        }

        const data = {
            transaction: {
                accountId: accountId,
                customerId: insideSenderDetails.customerId,
                amount: amount,
                description: description,
                transactionType: 3
            },
            beneficiary: {
                beneficiaryAccountNumber: receiverAcc2
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
            closeInsidePasswordModal();
            const result = await res.json();

            if (res.ok && result.status === "success") {
                statusDiv.textContent = "Transfer completed successfully.";
                statusDiv.style.color = "green";
                document.getElementById("insideTransferForm").reset();
                document.getElementById("insideInfoDiv").textContent = "";
                insideSenderDetails = null;
            } else {
                statusDiv.textContent = result.message || "Transfer failed.";
                statusDiv.style.color = "red";
            }
        })
        .catch(err => {
            closeInsidePasswordModal();
            statusDiv.textContent = "Network error: " + err.message;
            statusDiv.style.color = "red";
        });
    }
</script>
