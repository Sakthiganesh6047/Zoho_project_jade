<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Transfer Funds</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-image: url("contents/background.png"); /* Replace with your actual path */
		    background-size: cover;        /* Scales the image to cover the whole screen */
		    background-repeat: no-repeat;  /* Prevents tiling */
		    background-position: center;
            padding-top: 70px; /* same as header height */
        }

        .container {
            max-width: 500px;
            margin: 60px auto;
            padding: 30px 40px;
            background-color: #fff;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            border-radius: 12px;
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
            color: #34495e;
        }

        select, input, textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
            margin-bottom: 20px;
            box-sizing: border-box;
        }

        textarea {
            resize: vertical;
        }

        .button-group {
            display: flex;
            justify-content: space-between;
        }

        .btn {
            padding: 10px 18px;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-inside {
            background-color: #27ae60;
            color: #fff;
        }

        .btn-outside {
            background-color: #e67e22;
            color: #fff;
        }

        .btn-inside:hover { background-color: #1e8449; }
        .btn-outside:hover { background-color: #ca6f1e; }

        .message {
            text-align: center;
            font-weight: bold;
            margin-top: 20px;
        }
    </style>

    <script>
        let accounts = [];
        let beneficiaries = [];

        window.onload = () => {
            const userId = sessionStorage.getItem("userId");
            if (!userId) return;

            fetchAccounts(userId);
        };

        function fetchAccounts(userId) {
            fetch("jadebank/account/byUserId", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ userId: Number(userId) })
            })
            .then(res => res.json())
            .then(data => {
                accounts = data;
                populateAccounts(data);
            });
        }

        function populateAccounts(accounts) {
            const accountDropdown = document.getElementById("account-list");
            accountDropdown.innerHTML = `<option value="">-- Select Account --</option>`;
            accounts.forEach(acc => {
                const opt = document.createElement("option");
                opt.value = acc.accountId;
                opt.text = `Account #${acc.accountId} (₹${acc.balance})`;
                accountDropdown.appendChild(opt);
            });

            accountDropdown.onchange = () => {
                const accountId = accountDropdown.value;
                if (accountId) fetchBeneficiaries(accountId);
            };
        }

        function fetchBeneficiaries(accountId) {
            fetch("jadebank/beneficiary/id", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ accountId: Number(accountId) })
            })
            .then(res => res.json())
            .then(data => {
                beneficiaries = data;
                populateBeneficiaries(data);
            });
        }

        function populateBeneficiaries(list) {
            const benList = document.getElementById("beneficiary-list");
            benList.innerHTML = `<option value="">-- Select Beneficiary --</option>`;
            list.forEach(b => {
                const opt = document.createElement("option");
                opt.value = b.beneficiaryId;
                opt.text = `${b.name} - ${b.beneficiaryAccountNumber}`;
                benList.appendChild(opt);
            });
        }

        function submitTransfer(type) {
            const accountId = document.getElementById("account-list").value;
            const beneficiaryId = document.getElementById("beneficiary-list").value;
            const amount = Number(document.getElementById("amount").value);
            const description = document.getElementById("description").value;
            const userId = sessionStorage.getItem("userId");

            if (!accountId || !beneficiaryId || !amount) {
                showMessage("Please fill in all required fields", "red");
                return;
            }

            const beneficiary = beneficiaries.find(b => b.beneficiaryId == beneficiaryId);

            const payload = {
                transaction: {
                    accountId: Number(accountId),
                    amount,
                    description,
                    transactionType: type
                },
                beneficiary
            };

            fetch("jadebank/transaction/transfer", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(payload)
            })
            .then(res => res.json())
            .then(response => {
                if (response.status === "success") {
                    showMessage("Transfer successful!", "green");
                } else {
                    showMessage(response.error || "Transfer failed", "red");
                }
            });
        }

        function showMessage(message, color) {
            const box = document.getElementById("message-box");
            box.style.color = color;
            box.textContent = message;
        }
    </script>
</head>
<body>
<jsp:include page="LoggedInHeader.jsp" />

<div class="container">
    <h2>Transfer Funds</h2>

    <label for="account-list">Select Your Account</label>
    <select id="account-list" required></select>

    <label for="beneficiary-list">Select Beneficiary</label>
    <select id="beneficiary-list" required></select>

    <label for="amount">Amount</label>
    <input type="number" id="amount" placeholder="Enter amount" required />

    <label for="description">Description</label>
    <textarea id="description" rows="3" placeholder="Optional description..."></textarea>

    <div class="button-group">
        <button class="btn btn-inside" onclick="submitTransfer(3)">Transfer Inside Bank</button>
        <button class="btn btn-outside" onclick="submitTransfer(4)">Transfer Outside Bank</button>
    </div>

    <div id="message-box" class="message"></div>
</div>

<jsp:include page="Footer.jsp" />
</body>
</html>
