<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Long userId = (Long) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Beneficiary - JadeBank</title>
    <style>
        body {
            font-family: "Roboto", sans-serif;
            background: url("contents/background.png") center/cover no-repeat;
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
        h2 {
            text-align: center;
            margin-bottom: 25px;
        }
        label {
            font-weight: bold;
            display: block;
            margin: 12px 0 6px;
        }
        select, input {
            width: 100%;
            padding: 10px;
            margin-bottom: 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 6px;
            background-color: #414485;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }
        button:hover {
            background-color: #2e2f60;
        }
        input[readonly] {
		    background-color: #f3f3f3;
		}
        
        #status {
            margin-top: 16px;
            font-weight: bold;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="body-wrapper">
    <div class="main-wrapper">
        <div class="form-container">
            <h2>Add New Beneficiary</h2>
            <form id="beneficiaryForm">
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

                <label for="accountNumber">Account Number:</label>
                <input type="text" id="accountNumber" maxlength="15" inputmode="numeric"
                       pattern="(?!0{5,15})\d{5,15}" title="Account number must be 5 to 15 digits" required>

                <label for="beneficiaryName">Beneficiary Name:</label>
                <input type="text" id="beneficiaryName" maxlength="50"
                       pattern="[A-Za-z]+(?:[\-' ][A-Za-z]+)*"
                       title="Name should contain only letters, spaces, hyphens or apostrophes."
                       required>

                <label for="ifscCode">IFSC Code:</label>
                <input type="text" id="ifscCode" maxlength="11"
                       pattern="^[A-Z]{4}0[A-Z0-9]{6}$"
                       title="Enter a valid IFSC code (e.g., JADE0000000)." required>

                <button type="submit">Add Beneficiary</button>
                <div id="status"></div>
            </form>
        </div>
    </div>
</div>
<jsp:include page="Footer.jsp" />
<script>
    const userId = <%= userId != null ? userId : "null" %>;
    const contextPath = "<%= request.getContextPath() %>";

    // Populate user's account list
    if (userId) {
        fetch(contextPath + "/jadebank/account/id", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ userId: userId })
        })
        .then(res => res.ok ? res.json() : Promise.reject("Failed to load accounts"))
        .then(accounts => {
            const accountSelect = document.getElementById("accountId");
            accounts.forEach(function(acc) {
                const option = document.createElement("option");
                option.value = acc.accountId;
                option.textContent = "ID: " + acc.accountId + " | Type: " + (acc.accountType === 1 ? "Savings" : "Current");
                accountSelect.appendChild(option);
            });
        })
        .catch(console.error);
    }

    const accField = document.getElementById("accountNumber");
    const nameField = document.getElementById("beneficiaryName");
    const ifscField = document.getElementById("ifscCode");
    const bankSelect = document.getElementById("bankName");
    const statusDiv = document.getElementById("status");

    accField.addEventListener("input", function () {
        this.value = this.value.replace(/\D/g, '');
    });

    accField.addEventListener("blur", function () {
        const bank = bankSelect.value;
        const enteredAcc = parseInt(this.value);

        statusDiv.textContent = ""; // Clear previous status

        if (bank === "Jade Bank" && enteredAcc) {
            fetch(contextPath + "/jadebank/account/beneficiarydetail", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ accountId: enteredAcc })
            })
            .then(function(res) { return res.ok ? res.json() : Promise.reject("Not found"); })
            .then(function(data) {
                if (data.fullName && data.ifscCode) {
                    nameField.value = data.fullName;
                    ifscField.value = data.ifscCode;
                    statusDiv.textContent = ""; // Clear any previous error
                } else {
                    nameField.value = "";
                    ifscField.value = "";
                    statusDiv.textContent = "Invalid Jade Bank account.";
                    statusDiv.style.color = "red";
                }

                // Always keep them readonly for Jade Bank
                nameField.readOnly = true;
                ifscField.readOnly = true;
            })
            .catch(function() {
                nameField.value = "";
                ifscField.value = "";
                statusDiv.textContent = "Invalid Jade Bank account.";
                statusDiv.style.color = "red";

                nameField.readOnly = true;
                ifscField.readOnly = true;
            });
        } else {
            nameField.value = "";
            ifscField.value = "";

            nameField.readOnly = false;
            ifscField.readOnly = false;

            statusDiv.textContent = ""; // Clear status for non-Jade banks
        }
    });

    bankSelect.addEventListener("change", function () {
        accField.value = "";
        nameField.value = "";
        ifscField.value = "";

        if (this.value === "Jade Bank") {
            accField.readOnly = false;
            nameField.readOnly = true;
            ifscField.readOnly = true;
        } else {
            accField.readOnly = false;
            nameField.readOnly = false;
            ifscField.readOnly = false;
        }
    });

    document.getElementById("beneficiaryForm").addEventListener("submit", function (e) {
        e.preventDefault();

        const selectedAccountId = parseInt(document.getElementById("accountId").value);
        const enteredBeneficiaryAcc = parseInt(accField.value);
        const bank = bankSelect.value.trim();
        const name = nameField.value.trim();
        const ifsc = ifscField.value.trim();

        // Basic field validations
        if (!selectedAccountId || !enteredBeneficiaryAcc || !bank || !name || !ifsc) {
            statusDiv.textContent = "All fields are required.";
            statusDiv.style.color = "red";
            return;
        }

        // Same account check
        if (selectedAccountId === enteredBeneficiaryAcc) {
            statusDiv.textContent = "Your account and beneficiary account cannot be the same.";
            statusDiv.style.color = "red";
            return;
        }

        // For Jade Bank, do not allow manual empty values
        if (bank === "Jade Bank" && (!name || !ifsc)) {
            statusDiv.textContent = "Invalid beneficiary details for Jade Bank.";
            statusDiv.style.color = "red";
            return;
        }

        const data = {
            accountId: selectedAccountId,
            bankName: bank,
            beneficiaryName: name,
            beneficiaryAccountNumber: enteredBeneficiaryAcc,
            ifscCode: ifsc
        };

        fetch(contextPath + "/jadebank/beneficiary/add", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data)
        })
        .then(async function(res) {
            const result = await res.json();
            if (res.ok) {
                statusDiv.textContent = "Beneficiary added successfully.";
                statusDiv.style.color = "green";
                document.getElementById("beneficiaryForm").reset();

                // Reset readonly state
                nameField.readOnly = false;
                ifscField.readOnly = false;
            } else {
                statusDiv.textContent = result.error || "Failed to add beneficiary.";
                statusDiv.style.color = "red";
            }
        })
        .catch(function(err) {
            statusDiv.textContent = "Error: " + err.message;
            statusDiv.style.color = "red";
        });
    });

</script>
</body>
</html>
