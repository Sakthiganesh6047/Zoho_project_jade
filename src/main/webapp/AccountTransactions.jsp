<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Transactions</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f7fa;
            padding: 30px;
        }

        form {
            background: white;
            padding: 20px;
            max-width: 600px;
            margin: auto;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        label {
            display: block;
            margin-top: 10px;
        }

        input, button, select {
            padding: 8px;
            width: 100%;
            margin-top: 5px;
            margin-bottom: 15px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        button {
            background-color: #007acc;
            color: white;
            border: none;
        }

        button:hover {
            background-color: #005fa3;
        }

        table {
            width: 95%;
            margin: 20px auto;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
        }

        th, td {
            padding: 10px 12px;
            border: 1px solid #ddd;
            text-align: center;
        }

        th {
            background-color: #e6f2ff;
        }
        
    	.credit { color: green; font-weight: bold; }
    	.debit { color: red; font-weight: bold; }
        
        .error {
            color: red;
            text-align: center;
        }

        .search-box {
            max-width: 300px;
            margin: 10px auto;
        }

    </style>
</head>
<body>

<jsp:include page="LoggedInHeader.jsp" />

<form id="searchForm">
    <h2>View Transactions</h2>

    <label for="accountId">Account ID:</label>
    <input type="number" id="accountId" placeholder="Enter Account ID" required />

    <label for="limit">Limit:</label>
    <input type="number" id="limit" value="10" min="1" />

    <div id="errorMsg" class="error" style="color: red;"></div>

    <button type="button" onclick="fetchTransactions()">Fetch Transactions</button>
</form>

<div class="search-box" style="margin-top: 10px;">
    <input type="text" id="localSearch" placeholder="Search in table..." onkeyup="filterTable()" />
</div>

<table id="transactionTable" style="display: none; margin-top: 20px;" border="1" cellpadding="10">
    <thead>
    <tr>
        <th>ID</th>
        <th>Date</th>
        <th>Account</th>
        <th>Amount</th>
        <th>Type</th>
        <th>Beneficiary</th>
        <th>Description</th>
        <th>Status</th>
    </tr>
    </thead>
    <tbody id="transactionBody"></tbody>
</table>

<div style="text-align: center; margin-top: 20px;">
    <button onclick="prevPage()">Previous</button>
    <span id="pageInfo" style="margin: 0 15px;">Page 1</span>
    <button onclick="nextPage()">Next</button>
</div>

<jsp:include page="Footer.jsp" />

<script>
    let currentOffset = 0;
    const pageSize = 10;

    function fetchTransactions() {
        const accountId = parseInt(document.getElementById("accountId").value.trim());
        const limit = parseInt(document.getElementById("limit").value.trim());
        const errorMsg = document.getElementById("errorMsg");

        if (!accountId || limit < 1) {
            errorMsg.textContent = "Please enter a valid Account ID and Limit.";
            return;
        }

        errorMsg.textContent = "";

        fetch("${pageContext.request.contextPath}/jadebank/transactions/account?limit=" + limit + "&offset=" + currentOffset, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ accountId: accountId })
        })
        .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch"))
        .then(data => {
            const tbody = document.getElementById("transactionBody");
            tbody.innerHTML = "";

            if (!Array.isArray(data) || data.length === 0) {
                errorMsg.textContent = "No transactions found.";
                document.getElementById("transactionTable").style.display = "none";
                return;
            }

            data.forEach(txn => {
                const row = document.createElement("tr");
                const color = txn.transactionType === 1 ? "green" : (txn.transactionType === 2 ? "red" : "black");
                const statusText = txn.transactionStatus === 1 ? "Success" : (txn.transactionStatus === 2 ? "Failure" : "Unknown");

                row.innerHTML =
                	"<td>" + txn.transactionId + "</td>" +
                	"<td>" + formatDate(txn.transactionDate) + "</td>" +
                	"<td>" + txn.accountId + "</td>" +
                    "<td>" + txn.amount + "</td>" +
                    "<td>" + getTypeLabel(txn.transactionType) + "</td>" +
                    "<td>" + (txn.beneficiaryAccount || "-") + "</td>" +
                    "<td>" + (txn.description || "") + "</td>" +
                    "<td>" + statusText + "</td>";
                tbody.appendChild(row);
            });

            document.getElementById("transactionTable").style.display = "table";
            document.getElementById("pageInfo").textContent = "Page " + (Math.floor(currentOffset / pageSize) + 1);
        })
        .catch(err => {
            errorMsg.textContent = "Error: " + err;
            console.error(err);
        });
    }

    function nextPage() {
        currentOffset += pageSize;
        fetchTransactions();
    }

    function prevPage() {
        if (currentOffset >= pageSize) {
            currentOffset -= pageSize;
            fetchTransactions();
        }
    }

    function getTypeLabel(type) {
        switch (type) {
            case 1: return "Credit";
            case 2: return "Debit";
            case 3: return "Transfer";
            default: return "Unknown";
        }
    }

    function formatDate(timestamp) {
        const date = new Date(Number(timestamp));
        return date.toLocaleString("en-IN");
    }

    function filterTable() {
        const input = document.getElementById("localSearch").value.toLowerCase();
        const rows = document.getElementById("transactionBody").getElementsByTagName("tr");

        for (let row of rows) {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(input) ? "" : "none";
        }
    }
</script>

</body>

</html>
