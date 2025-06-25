<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Long userId = (Long) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Beneficiary - JadeBank</title>
    <style>
        /* Styles remain unchanged */
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
            min-height: 87vh;
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
        h2 {
            text-align: center;
            margin-bottom: 25px;
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
        input, select {
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
                    <option value="Other">Other</option>
                </select>

                <label for="accountNumber">Account Number:</label>
                <input type="number" id="accountNumber" required>

                <label for="beneficiaryName">Beneficiary Name:</label>
                <input type="text" id="beneficiaryName" required>

                <label for="ifscCode">IFSC Code:</label>
                <input type="text" id="ifscCode" required>

                <button type="submit">Add Beneficiary</button>
                <div id="status"></div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="Footer.jsp" />

<script>
    const userId = <%= userId != null ? userId : "null" %>;

    if (userId) {
        fetch(`${pageContext.request.contextPath}/jadebank/account/id`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ userId: userId })
        })
        .then(res => res.ok ? res.json() : Promise.reject("Failed to load accounts"))
        .then(accounts => {
            const select = document.getElementById("accountId");
            accounts.forEach(acc => {
                const option = document.createElement("option");
                option.value = acc.accountId;
                option.textContent = "ID: " + acc.accountId + " | Type: " + (acc.accountType === 1 ? "Savings" : "Current");
                select.appendChild(option);
            });
        })
        .catch(err => console.error("Error fetching accounts:", err));
    }

    document.getElementById("bankName").addEventListener("change", function () {
        const bank = this.value;
        const accField = document.getElementById("accountNumber");
        const nameField = document.getElementById("beneficiaryName");
        const ifscField = document.getElementById("ifscCode");

        if (bank === "Jade Bank") {
            accField.addEventListener("blur", () => {
                const enteredAcc = parseInt(accField.value);
                if (enteredAcc) {
                    fetch(`${pageContext.request.contextPath}/jadebank/account/beneficiarydetail`, {
                        method: "POST",
                        headers: { "Content-Type": "application/json" },
                        body: JSON.stringify({ accountId: enteredAcc })
                    })
                    .then(res => res.ok ? res.json() : Promise.reject("Not found"))
                    .then(data => {
                        if (data.fullName) nameField.value = data.fullName;
                        if (data.ifscCode) ifscField.value = data.ifscCode;
                    })
                    .catch(() => {
                        nameField.value = "";
                        ifscField.value = "";
                    });
                }
            });
        } else {
            nameField.value = "";
            ifscField.value = "";
        }
    });

    document.getElementById("beneficiaryForm").addEventListener("submit", function(e) {
        e.preventDefault();

        const data = {
            accountId: parseInt(document.getElementById("accountId").value),
            beneficiaryName: document.getElementById("beneficiaryName").value.trim(),
            bankName: document.getElementById("bankName").value.trim(),
            beneficiaryAccountNumber: parseInt(document.getElementById("accountNumber").value),
            ifscCode: document.getElementById("ifscCode").value.trim()
        };

        fetch(`${pageContext.request.contextPath}/jadebank/beneficiary/add`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data)
        })
        .then(async response => {
            const result = await response.json();
            const statusDiv = document.getElementById("status");

            if (response.ok) {
                statusDiv.textContent = "Beneficiary added successfully.";
                statusDiv.style.color = "green";
                document.getElementById("beneficiaryForm").reset();
                document.getElementById("accountId").selectedIndex = 0;
            } else {
                statusDiv.textContent = result.error || "Failed to add beneficiary.";
                statusDiv.style.color = "red";
            }
        })
        .catch(err => {
            document.getElementById("status").textContent = "Error: " + err.message;
            document.getElementById("status").style.color = "red";
        });
    });
</script>

</body>
</html>
