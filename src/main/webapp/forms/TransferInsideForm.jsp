<div class="form-box">
    <h2>Inside Bank Transfer</h2>
    <form id="insideTransferForm">
        <input type="hidden" name="transaction.transactionType" value="3" />

        <!-- Sender Section -->
        <fieldset>
            <legend>Sender Details</legend>
            <label for="insideSenderAccountId">Sender Account ID:</label>
            <input type="text" id="insideSenderAccountId" name="transaction.accountId" 
            maxlength="10" 
            required 
            pattern="\d{1,10}" title="Enter up to 10 digits only"
       		oninput="this.value = this.value.replace(/[^0-9]/g, '')"
            onblur="fetchInsideSenderDetails()" />
            <div id="insideInfoDiv" class="info-box hidden"></div>

            <label for="insideAmount">Amount:</label>
            <input type="number" step="0.01" id="insideAmount" name="transaction.amount" required min="0.01" max="100000" oninput="validateAmount(this)" />

            <label for="insideDescription">Description:</label>
            <input type="text" id="insideDescription" name="transaction.description"
			       maxlength="100"
			       pattern="[A-Za-z0-9 ,.\-']*"
			       placeholder="Reason for transfer..."
			       title="Only letters, numbers, spaces, comma, dot, hyphen, and apostrophe allowed. Max 100 characters."/>
        </fieldset>

        <!-- Receiver Section -->
        <fieldset>
            <legend>Receiver Details</legend>
            <label for="insideReceiverAccount2">Receiver Account Number:</label>
            <input type="text" id="insideReceiverAccount2" required
            maxlength="10"
            pattern="\d{1,10}" title="Enter up to 10 digits only"
       		oninput="this.value = this.value.replace(/[^0-9]/g, '')"
            onblur="checkInsideReceiverDetails()" />
            <div id="insideReceiverDetails" class="info-box hidden"></div>
        </fieldset>

        <!-- Status -->
        <div id="insideTransferStatus" class="status-box"></div>

        <!-- Transfer Button -->
        <div class="submit-section">
            <button type="button" onclick="openInsidePasswordModal()">Transfer</button>
        </div>
    </form>
</div>

<!-- Password Modal -->
<div class="modal" id="insidePasswordModal">
    <div class="modal-content">
        <p><strong>Confirm Password</strong></p>
        <input type="password" id="insideConfirmPassword" placeholder="Enter your password" />
        <div>
            <button type="button" onclick="submitInsideTransfer()">Confirm</button>
            <button type="button" onclick="closeInsidePasswordModal()">Cancel</button>
        </div>
    </div>
</div>

<script>
    let insideSenderDetails = null;
    const contextPath = "<%= request.getContextPath() %>";

    function validateAmount(input) {
        input.value = input.value.replace(/[^\d.]/g, '').replace(/^(\d*\.\d{0,2}).*$/, '$1');
        if (Number(input.value) > 100000) input.value = "100000";
    }

    document.getElementById("insideAmount").addEventListener("keydown", function (e) {
        if (["e", "E", "+", "-"].includes(e.key) || (e.key === "." && this.value.includes("."))) {
            e.preventDefault();
        }
    });

    function fetchInsideSenderDetails() {
        const accountId = parseInt(document.getElementById("insideSenderAccountId").value);
        const infoDiv = document.getElementById("insideInfoDiv");
        infoDiv.classList.add("hidden");
        if (!accountId) return;

        fetch(contextPath + "/jadebank/account/details", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ accountId })
        })
        .then(res => res.ok ? res.json() : Promise.reject("Fetch failed"))
        .then(data => {
            if (!data || !data.fullName || !data.customerId) {
                infoDiv.textContent = "No sender data found.";
            } else {
                insideSenderDetails = data;
                infoDiv.textContent = "Sender: " + data.fullName + ", Customer ID: " + data.customerId;
            }
            infoDiv.classList.remove("hidden");
        })
        .catch(err => {
            infoDiv.textContent = "Account not found";
            infoDiv.classList.remove("hidden");
        });
    }

    function checkInsideReceiverDetails() {
        const accountId = parseInt(document.getElementById("insideReceiverAccount2").value);
        const receiverDiv = document.getElementById("insideReceiverDetails");
        receiverDiv.classList.add("hidden");
        if (!accountId) return;

        fetch(contextPath + "/jadebank/account/details", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ accountId })
        })
        .then(res => res.ok ? res.json() : Promise.reject("Fetch failed"))
        .then(data => {
            if (!data || !data.fullName || !data.customerId) {
                receiverDiv.textContent = "No receiver data found.";
            } else {
                receiverDiv.textContent = "Receiver: " + data.fullName + ", Customer ID: " + data.customerId;
            }
            receiverDiv.classList.remove("hidden");
        })
        .catch(err => {
            receiverDiv.textContent = "Account not found";
            receiverDiv.classList.remove("hidden");
        });
    }

    function openInsidePasswordModal() {
        const senderAcc = parseInt(document.getElementById("insideSenderAccountId").value);
        const receiverAcc = document.getElementById("insideReceiverAccount2").value.trim();
        const amount = parseFloat(document.getElementById("insideAmount").value);
        const statusDiv = document.getElementById("insideTransferStatus");
        const description = document.getElementById("insideDescription");

        statusDiv.classList.remove("hidden");
        statusDiv.style.color = "red";
        statusDiv.textContent = "";

        if (!senderAcc) {
            statusDiv.textContent = "Sender details not valid.";
            return;
        }
        if (!receiverAcc || isNaN(receiverAcc)) {
            statusDiv.textContent = "Please enter a valid receiver account number.";
            return;
        }
        if (!amount || isNaN(amount) || amount <= 0) {
            statusDiv.textContent = "Please enter a valid amount.";
            return;
        }
        
     // Validate description pattern manually only if it's not empty
        const descPattern = /^[A-Za-z0-9 ,.\-']*$/;
        if (description.length > 0 && (!descPattern.test(description) || description.length > 100)) {
            showStatusMessage("Description can only contain letters, numbers, space, comma, dot, hyphen, apostrophe. Max 100 chars.", "red");
            return;
        }

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
        const statusDiv = document.getElementById("insideTransferStatus");

        if (!accountId || !amount || amount <= 0 || !password || !insideSenderDetails) {
            statusDiv.textContent = "All fields, password, and sender check are required.";
            statusDiv.style.color = "red";
            statusDiv.classList.remove("hidden");
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

        fetch(contextPath + "/jadebank/transaction/transfer", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
            },
            body: JSON.stringify(data)
        })
        .then(async res => {
            closeInsidePasswordModal();

            if (res.status === 401) {
                window.location.href = contextPath + "/Login.jsp?expired=true";
                return;
            }

            const result = await res.json();

            if (res.ok && result.status === "success") {
                statusDiv.textContent = "Transfer completed successfully.";
                statusDiv.style.color = "green";
                document.getElementById("insideTransferForm").reset();
                document.getElementById("insideInfoDiv").textContent = "";
                document.getElementById("insideReceiverDetails").textContent = "";
                document.getElementById("insideInfoDiv").style.display = "none";
                document.getElementById("insideReceiverDetails").style.display = "none";
                insideSenderDetails = null;
            } else {
                statusDiv.textContent = result.error || "Transfer failed.";
                statusDiv.style.color = "red";
            }

            statusDiv.classList.remove("hidden");
        })
        .catch(err => {
            closeInsidePasswordModal();
            statusDiv.textContent = "Network error: " + err.message;
            statusDiv.style.color = "red";
            statusDiv.classList.remove("hidden");
        });
    }
</script>
