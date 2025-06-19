<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Transactions</title>
    <style>
        body {
            font-family: "Roboto", sans-serif;
            background: #f5f7fa;
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
            padding: 30px;
            flex: 1;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        .search-section {
            max-width: 600px;
            margin: 0 auto 30px auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .search-section label {
            font-weight: bold;
            display: block;
            margin-top: 15px;
        }

        .search-section input,
        .search-section button {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        .search-section button {
            background-color: #414485;
            color: white;
            font-weight: bold;
            border: none;
            margin-top: 20px;
        }

        .search-section button:hover {
            background-color: #005fa3;
        }

        .error {
            color: red;
            text-align: center;
            margin-top: 10px;
        }

        .search-box {
            max-width: 300px;
            margin: 0 auto 20px auto;
        }

        .search-box input {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        table {
            width: 95%;
            margin: 0 auto 30px auto;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }

        th {
            background-color: #e6f2ff;
        }

        .credit { color: green; font-weight: bold; }
        .debit { color: red; font-weight: bold; }

        .pagination {
            text-align: center;
            margin-bottom: 40px;
        }

        .pagination button {
            padding: 8px 16px;
            border-radius: 5px;
            border: none;
            background-color: #414485;
            color: white;
            margin: 0 10px;
        }

        .pagination button:hover {
            background-color: #005fa3;
        }

        #pageInfo {
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

    <div class="main-wrapper">
        <h2>View Transactions</h2>

        <div style="max-width: 700px; margin: 0 auto 20px;">
		    <div style="display: flex; gap: 20px; align-items: flex-end;">
		        <div style="flex: 1;">
		            <label for="accountId"><strong>Account ID:</strong></label>
		            <input type="number" id="accountId" placeholder="Enter Account ID" style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid #ccc;">
		        </div>
		        <div style="width: 100px;">
		            <label for="limit"><strong>Limit:</strong></label>
		            <input type="number" id="limit" value="10" min="1" style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid #ccc;">
		        </div>
		        <div>
		            <button type="button" onclick="fetchTransactions(true)" style="padding: 10px 16px; background-color: #414485; color: white; border: none; border-radius: 6px;">Fetch</button>
		        </div>
		    </div>
		    <div id="errorMsg" class="error" style="margin-top: 10px;"></div>
		</div>

        <div class="search-box">
            <input type="text" id="localSearch" placeholder="Search in table..." onkeyup="filterTable()" />
        </div>

        <table id="transactionTable" style="display: none;">
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

        <div class="pagination">
            <button onclick="prevPage()">Previous</button>
            <span id="pageInfo">Page 1</span>
            <button onclick="nextPage()">Next</button>
        </div>
    </div>
</div>

<jsp:include page="Footer.jsp" />

<script>
    let currentOffset = 0;
    const pageSize = 10;

    function fetchTransactions(resetPage = false) {
        const accountId = parseInt(document.getElementById("accountId").value.trim());
        const limit = parseInt(document.getElementById("limit").value.trim());
        const errorMsg = document.getElementById("errorMsg");

        if (!accountId || limit < 1) {
            errorMsg.textContent = "Please enter a valid Account ID and Limit.";
            return;
        }

        if (resetPage) {
            currentOffset = 0; // Reset to first page
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
            document.getElementById("pageInfo").textContent = "Page " + (Math.floor(currentOffset / limit) + 1);
        })
        .catch(err => {
            errorMsg.textContent = "Error: " + err;
            console.error(err);
        });
    }

    function nextPage() {
        const limit = parseInt(document.getElementById("limit").value.trim()) || 10;
        currentOffset += limit;
        fetchTransactions();
    }

    function prevPage() {
        const limit = parseInt(document.getElementById("limit").value.trim()) || 10;
        if (currentOffset >= limit) {
            currentOffset -= limit;
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
