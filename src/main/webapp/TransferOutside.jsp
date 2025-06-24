<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Outside Bank Transfer</title>
    <style>
        body {
            font-family: "Roboto", sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            padding-top: 70px; /* same as header height */
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

        .account-fetch {
            display: flex;
            gap: 10px;
            align-items: flex-end;
        }

        .account-fetch input {
            flex: 1;
            margin-bottom: 0;
        }

        .account-fetch button {
            padding: 10px 14px;
            margin-top: 0;
            height: 42px;
            width: 15%;
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
            border-radius: 6px;
            font-size: 0.95rem;
            color: #333;
        }

        .modal-backdrop {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            justify-content: center;
            align-items: center;
            z-index: 2000;
        }

        .modal-content {
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            width: 320px;
            text-align: center;
        }

        .modal-content input {
            width: 100%;
            margin-top: 15px;
            margin-bottom: 20px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        
        .hidden {
		    display: none;
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
            <h2>Outside Bank Transfer</h2>

            <input type="hidden" name="transaction.transactionType" value="4" />

            <!-- Sender Section -->
            <fieldset>
                <legend>Sender Details</legend>

                <label for="senderAccountId">Sender Account ID:</label>
                <div class="account-fetch">
                    <input type="number" name="transaction.accountId" id="senderAccountId" required />
                    <button type="button" onclick="fetchSenderDetails()">Fetch</button>
                </div>

                <div id="infoDiv" class="info-box hidden"></div>

                <label for="amount">Amount:</label>
                <input type="number" step="0.01" name="transaction.amount" id="amount" required />

                <label for="description">Description:</label>
                <input type="text" name="transaction.description" id="description" />
            </fieldset>

            <!-- Receiver Section -->
            <fieldset>
                <legend>Receiver Details</legend>

                <label for="beneficiaryAccountNumber">Account Number:</label>
                <input type="number" name="beneficiary.accountNumber" id="beneficiaryAccountNumber" required />

                <label for="beneficiaryAccountHolder">Account Holder Name:</label>
                <input type="text" name="beneficiary.accountHolderName" id="beneficiaryAccountHolder" required />

                <label for="beneficiaryBankName">Bank Name:</label>
                <input type="text" name="beneficiary.bankName" id="beneficiaryBankName" required />

                <label for="beneficiaryIfscCode">IFSC Code:</label>
                <input type="text" name="beneficiary.ifscCode" id="beneficiaryIfscCode" required />
            </fieldset>

            <div id="transfer-status" class="info-box hidden"></div>
            <button type="button" onclick="showPasswordModal()">Transfer</button>
        </form>
    </div>
</div>

<!-- Password Modal -->
<div id="passwordModal" class="modal-backdrop">
    <div class="modal-content">
        <p><strong>Confirm Password:</strong></p>
        <input type="password" id="confirmPassword" placeholder="Enter your password">
        <button type="button" onclick="submitTransfer()">Confirm</button>
        <button type="button" onclick="closeModal()">Cancel</button>
    </div>
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
            const infoDiv = document.getElementById("infoDiv");
            if (!data || !data.fullName || !data.customerId) {
                infoDiv.textContent = "No sender data found.";
                infoDiv.classList.remove("hidden");
                return;
            }
            senderDetails = data;
            infoDiv.textContent = "Sender: " + data.fullName + ", Customer ID: " + data.customerId;
            infoDiv.classList.remove("hidden");
        })
        .catch(err => {
            const infoDiv = document.getElementById("infoDiv");
            infoDiv.textContent = "Account not found";
            infoDiv.classList.remove("hidden");
            console.error(err);
        });
    }

    function showPasswordModal() {
        document.getElementById("passwordModal").style.display = "flex";
    }

    function closeModal() {
        document.getElementById("passwordModal").style.display = "none";
        document.getElementById("confirmPassword").value = "";
    }

    function submitTransfer() {
        const accountId = parseInt(document.getElementById("senderAccountId").value);
        const amount = parseFloat(document.getElementById("amount").value);
        const description = document.getElementById("description").value;
        const password = document.getElementById("confirmPassword").value;
        const statusDiv = document.getElementById("transfer-status");
        const infoDiv = document.getElementById("infoDiv");

        const beneficiary = {
            beneficiaryAccountNumber: document.getElementById("beneficiaryAccountNumber").value.trim(),
            beneficiaryName: document.getElementById("beneficiaryAccountHolder").value.trim(),
            bankName: document.getElementById("beneficiaryBankName").value.trim(),
            ifscCode: document.getElementById("beneficiaryIfscCode").value.trim()
        };

        // Validation
        if (!accountId || !amount || amount <= 0 || !password || !senderDetails) {
            statusDiv.textContent = "All fields, password, and sender fetch are required.";
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

        fetch(`${pageContext.request.contextPath}/jadebank/transaction/transfer`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data)
        })
        .then(async res => {
            closeModal();
            const result = await res.json();

            statusDiv.classList.remove("hidden");

            if (res.ok && result.status === "success") {
                statusDiv.textContent = "Transfer completed successfully.";
                statusDiv.style.color = "green";

                document.getElementById("transferForm").reset();
                infoDiv.textContent = "";
                infoDiv.classList.add("hidden");
                senderDetails = null;

                // Hide the status message after 5 seconds
                setTimeout(() => {
                    statusDiv.classList.add("hidden");
                }, 5000);
            } else {
                statusDiv.textContent = result.message || "Transfer failed.";
                statusDiv.style.color = "red";
            }
        })
        .catch(err => {
            closeModal();
            statusDiv.textContent = "Network error: " + err.message;
            statusDiv.style.color = "red";
            statusDiv.classList.remove("hidden");
        });
    }

</script>

</body>
</html>
