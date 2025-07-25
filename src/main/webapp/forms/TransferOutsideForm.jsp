<style>
    .form-box {
        padding: 30px;
        padding-top: 5px;
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

    fieldset {
        /*border: none;*/
        padding: 20px;
        margin-bottom: 25px;
        border-radius: 10px;
    }

    legend {
        padding: 0 10px;
        font-weight: 600;
        color: #264653;
        font-size: 18px;
        margin-bottom: 10px;
    }

    label {
        font-weight: 500;
        display: block;
        margin-top: 10px;
    }

    input[type="text"],
    input[type="number"],
    input[type="password"] {
        width: 100%;
        padding: 10px;
        margin-bottom: 12px;
        border-radius: 6px;
        border: 1px solid #ccc;
    }

    .info-box {
        margin-bottom: 15px;
        color: #333;
        background: #e9f5ff;
        padding: 10px;
        border-left: 4px solid #2196F3;
        border-radius: 4px;
    }
    
    .status-box{
    	align-items: center;
    	margin-bottom: 15px;
    }

    .info-box.hidden {
        display: none;
    }

    button {
        padding: 8px 16px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
    }

    .form-box button[type="button"] {
        background: #1d3557;
        color: white;
        font-weight: 500;
    }

    .form-box button[type="button"]:hover {
        background: #274c77;
    }

    .submit-section {
        text-align: center;
    }

    .submit-section button {
        padding: 12px 24px;
        background: linear-gradient(to right, #457b9d, #1d3557);
        color: white;
        font-size: 16px;
        font-weight: 600;
        border-radius: 8px;
    }

    .modal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: rgba(0,0,0,0.4);
        justify-content: center;
        align-items: center;
    }

    .modal-content {
        background: white;
        padding: 30px;
        border-radius: 16px;
        width: 340px;
        text-align: center;
        box-shadow: 0 4px 15px rgba(0,0,0,0.2);
    }

    .modal-content button {
        margin-top: 10px;
    }
</style>

<div class="form-box">
    <h2>Outside Bank Transfer</h2>
    <form id="outsideTransferForm">
        <input type="hidden" name="transaction.transactionType" value="4" />

        <!-- Sender Section -->
        <fieldset>
            <legend>Sender Details</legend>

            <label for="outsideSenderAccountId">Sender Account ID:</label>
            <input type="text" name="transaction.accountId" id="outsideSenderAccountId" 
            required maxlength="10"
            pattern="\d{1,10}" title="Enter up to 10 digits only"
       		oninput="this.value = this.value.replace(/[^0-9]/g, '')"
            onblur="fetchOutsideSenderDetails()">

            <div id="outsideInfoDiv" class="info-box hidden"></div>

            <label for="outsideAmount">Amount:</label>
            <input type="number" step="0.01" name="transaction.amount" id="outsideAmount" required min="0.01" max="100000" oninput="validateAmount(this)" />

            <label for="outsideDescription">Description:</label>
            <input type="text" name="transaction.description" id="outsideDescription"
            maxlength="100"
			pattern="[A-Za-z0-9 ,.\-']*"
			placeholder="Reason for transfer..."
			title="Only letters, numbers, spaces, comma, dot, hyphen, and apostrophe allowed. Max 100 characters."/>
        </fieldset>

        <!-- Receiver Section -->
        <fieldset>
            <legend>Receiver Details</legend>

            <label for="outsideBeneficiaryAccountNumber">Account Number:</label>
            <input type="text" name="beneficiary.accountNumber" id="outsideBeneficiaryAccountNumber" 
            required maxlength="20"
            pattern="\d{1,10}" title="Enter up to 10 digits only"
       		oninput="this.value = this.value.replace(/[^0-9]/g, '')">

            <label for="outsideBeneficiaryName">Account Holder Name:</label>
            <input type="text" name="beneficiary.accountHolderName" id="outsideBeneficiaryName" maxlength="50"
				pattern="^(?![\s]+$)(?=[^@]*@?[^@]*$)[A-Za-z]+(?:[ '\-@][A-Za-z]+)*$"
				required
				title="Only letters, spaces, apostrophes, hyphens allowed, and '@' only once. No numbers or other special characters.">
            <label for="outsideBankName">Bank Name:</label>
            <input type="text" name="beneficiary.bankName" id="outsideBankName" maxlength="50"
				pattern="^(?![\s]+$)(?=[^@]*@?[^@]*$)[A-Za-z]+(?:[ '\-@][A-Za-z]+)*$"
				required
				title="Only letters, spaces, apostrophes, hyphens allowed, and '@' only once. No numbers or other special characters.">

            <label for="outsideIfscCode">IFSC Code:</label>
            <input type="text" name="beneficiary.ifscCode" id="outsideIfscCode" maxlength="50"
				pattern="^(?![\s]+$)(?=[^@]*@?[^@]*$)[A-Za-z]+(?:[ '\-@][A-Za-z]+)*$"
				title="Only letters, spaces, apostrophes, hyphens allowed, and '@' only once. No numbers or other special characters." required>
        </fieldset>

        <div id="outsideTransferStatus" class="info-box hidden"></div>

        <div class="submit-section">
            <button type="button" onclick="openOutsidePasswordModal()">Transfer</button>
        </div>
    </form>
</div>

<!-- Password Modal -->
<div class="modal" id="outsidePasswordModal">
    <div class="modal-content">
        <p><strong>Confirm Password</strong></p>
        <input type="password" id="outsideConfirmPassword" placeholder="Enter your password">
        <div>
            <button type="button" onclick="submitOutsideTransfer()">Confirm</button>
            <button type="button" onclick="closeOutsidePasswordModal()">Cancel</button>
        </div>
    </div>
</div>

<script>
    let senderDetails = null;

    function validateAmount(input) {
        input.value = input.value
            .replace(/[^\d.]/g, '')
            .replace(/^(\d*\.\d{0,2}).*$/, '$1');
        if (Number(input.value) > 100000) input.value = "100000";
    }

    document.getElementById("outsideAmount").addEventListener("keydown", function (e) {
        if (["e", "E", "+", "-"].includes(e.key) || (e.key === "." && this.value.includes("."))) {
            e.preventDefault();
        }
    });

    function fetchOutsideSenderDetails() {
        const accountId = parseInt(document.getElementById("outsideSenderAccountId").value);
        const infoDiv = document.getElementById("outsideInfoDiv");
        infoDiv.classList.add("hidden");

        if (!accountId) return;

        fetch(contextPath + "/jadebank/account/details", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ accountId: accountId })
        })
        .then(res => res.ok ? res.json() : Promise.reject("Fetch failed"))
        .then(data => {
            if (!data || !data.fullName || !data.customerId) {
                infoDiv.textContent = "No sender data found.";
            } else {
                senderDetails = data;
                infoDiv.textContent = "Sender: " + data.fullName + ", Customer ID: " + data.customerId;
            }
            infoDiv.classList.remove("hidden");
        })
        .catch(err => {
            infoDiv.textContent = "Account not found";
            infoDiv.classList.remove("hidden");
        });
    }

    function openOutsidePasswordModal() {
        const accountId = parseInt(document.getElementById("outsideSenderAccountId").value);
        const amount = parseFloat(document.getElementById("outsideAmount").value);
        const beneficiaryAccount = document.getElementById("outsideBeneficiaryAccountNumber").value.trim();
        const statusDiv = document.getElementById("outsideTransferStatus");
        const description = document.getElementById("outsideDescription");

        statusDiv.textContent = "";
        statusDiv.style.color = "red";
        statusDiv.classList.remove("hidden");

        if (!accountId) {
            statusDiv.textContent = "Valid sender account ID is required.";
            return;
        }
        if (!beneficiaryAccount || isNaN(beneficiaryAccount)) {
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

        statusDiv.classList.add("hidden");
        document.getElementById("outsidePasswordModal").style.display = "flex";
    }

    function closeOutsidePasswordModal() {
        document.getElementById("outsidePasswordModal").style.display = "none";
        document.getElementById("outsideConfirmPassword").value = "";
    }

    function submitOutsideTransfer() {
        const accountId = parseInt(document.getElementById("outsideSenderAccountId").value);
        const amount = parseFloat(document.getElementById("outsideAmount").value);
        const description = document.getElementById("outsideDescription").value.trim();
        const password = document.getElementById("outsideConfirmPassword").value;

        const beneficiary = {
            beneficiaryAccountNumber: document.getElementById("outsideBeneficiaryAccountNumber").value.trim(),
            beneficiaryName: document.getElementById("outsideBeneficiaryName").value.trim(),
            bankName: document.getElementById("outsideBankName").value.trim(),
            ifscCode: document.getElementById("outsideIfscCode").value.trim()
        };

        const statusDiv = document.getElementById("outsideTransferStatus");
        const infoDiv = document.getElementById("outsideInfoDiv");

        if (!accountId || !amount || amount <= 0 || !password || !senderDetails) {
            statusDiv.textContent = "All fields, password, and sender check are required.";
            statusDiv.style.color = "red";
            statusDiv.classList.remove("hidden");
            return;
        }

        const data = {
            transaction: {
                accountId: accountId,
                customerId: senderDetails.customerId,
                amount: amount,
                description: description,
                transactionType: 4
            },
            beneficiary: beneficiary,
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
            closeOutsidePasswordModal();
            if (res.status === 401) {
                window.location.href = contextPath + "/Login.jsp?expired=true";
                return;
            }

            let result;
            try {
                result = await res.json();
            } catch (e) {
                statusDiv.textContent = "Invalid server response.";
                statusDiv.style.color = "red";
                statusDiv.classList.remove("hidden");
                return;
            }

            statusDiv.classList.remove("hidden");

            if (res.ok && result.status === "success") {
                statusDiv.textContent = "Transfer completed successfully.";
                statusDiv.style.color = "green";

                document.getElementById("outsideTransferForm").reset();
                infoDiv.textContent = "";
                infoDiv.classList.add("hidden");
                senderDetails = null;

                setTimeout(() => {
                    statusDiv.classList.add("hidden");
                }, 5000);
            } else {
                statusDiv.textContent = result.error || "Transfer failed.";
                statusDiv.style.color = "red";
            }
        })
        .catch(err => {
            closeOutsidePasswordModal();
            statusDiv.textContent = "Network error: " + err.message;
            statusDiv.style.color = "red";
            statusDiv.classList.remove("hidden");
        });
    }
</script>
