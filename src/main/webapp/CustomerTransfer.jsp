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
            background-color: #f5f7fa;
            margin: 0;
        }

        .body-wrapper {
            display: flex;
            min-height: 100vh;
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
            margin-left: 70px;
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
            width: 100%;
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
            background-color: #388e3c;
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

<jsp:include page="LoggedInHeader.jsp" />

<div class="body-wrapper">
    <div class="sidebar-wrapper">
        <jsp:include page="SideBar.jsp" />
    </div>

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
                <input type="number" id="amount" min="1" required>

                <label for="description">Description:</label>
				<input type="text" id="description" placeholder="Reason for transfer..." required>

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

        fetch(`${pageContext.request.contextPath}/jadebank/beneficiary/id?limit=1000&offset=0`, {
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
        document.getElementById("passwordModal").style.display = "block";
    }

    function closeModal() {
        document.getElementById("passwordModal").style.display = "none";
        document.getElementById("confirmPassword").value = "";
    }

    function submitTransfer() {
        const accountId = parseInt(document.getElementById("accountId").value);
        const beneficiaryJSON = document.getElementById("beneficiaryId").value;
        const amount = parseFloat(document.getElementById("amount").value);
        const description = document.getElementById("description").value.trim();
        const password = document.getElementById("confirmPassword").value;

        const statusDiv = document.getElementById("status");
        const modal = document.getElementById("passwordModal");

        if (!accountId || !beneficiaryJSON || !amount || !description || !password) {
            statusDiv.textContent = "All fields are required.";
            statusDiv.style.color = "red";
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
                statusDiv.textContent = "Transfer successful.";
                statusDiv.style.color = "green";
                document.getElementById("transferForm").reset();
                document.getElementById("beneficiaryId").innerHTML = '<option value="">-- Select Beneficiary --</option>';
            } else {
                statusDiv.textContent = result.error || "Transfer failed.";
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

</body>
</html>
