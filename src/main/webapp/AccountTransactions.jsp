<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Transactions</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" />
    <style>
        body {
        	transition: opacity 0.2s ease-in;
            font-family: "Roboto", sans-serif;
            background-image: url("contents/background.png");
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            margin: 0;
            padding-top: 70px;
        }

        .body-wrapper {
            display: flex;
            min-height: 89vh;
        }

        .main-wrapper {
            margin-left: 70px;
            padding: 30px;
            flex: 1;
            transition: margin-left 0.3s ease;
        }

        .sidebar.expanded ~ .main-wrapper {
            margin-left: 220px;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        .search-section {
            max-width: 700px;
            margin: 0 auto 30px auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .search-row {
            display: flex;
            gap: 20px;
            align-items: flex-end;
        }

        .search-row div {
            flex: 1;
        }

        .search-section label {
            font-weight: bold;
            display: block;
            margin-top: 15px;
        }

        .search-section input {
            width: 80%;
            padding: 10px;
            margin-top: 5px;
            border-radius: 6px;
            border: 1px solid #ccc;
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
        
        .search-wrapper{
        	display: flex;
        	justify-content: center;
        	gap: 10px;
        }

        .search-box input {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #ffffff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin: 0 auto 30px auto;
            font-size: 15px;
        }

        thead {
            background-color: #414485;
            color: white;
            font-weight: bold;
        }

        th, td {
            padding: 14px 18px;
            text-align: center;
            border-bottom: 1px solid #f0f0f0;
        }

        tbody tr:nth-child(odd) {
            background-color: #f4f4fb;
        }

        tbody tr:nth-child(even) {
            background-color: #ffffff;
        }

        tbody tr:hover {
            background-color: #eef1f8;
        }

        .credit { color: #2e7d32; font-weight: bold; }
        .debit { color: #c62828; font-weight: bold; }

        .pagination {
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    gap: 30px;
		    margin-bottom: 40px;
		}


        .pagination-controls {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .pagination button {
            background-color: #414485;
            color: white;
            border: none;
            border-radius: 50%;
            padding: 10px 12px;
            font-size: 16px;
            cursor: pointer;
        }

        .pagination button:hover {
            background-color: #2a2d63;
        }

        .limit-container {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .limit-container input {
            width: 60px;
            padding: 8px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>

<jsp:include page="LoggedInHeader.jsp" />

<div class="body-wrapper">
    <jsp:include page="SideBar.jsp" />

    <div class="main-wrapper">
        <h2>View Transactions</h2>

        <div class="search-section">
            <div class="search-row">
                <div class="search-wrapper">
                    <label for="accountId">Account ID:</label>
                    <input type="number" id="accountId" placeholder="Enter Account ID"
                           onblur="fetchTransactions(true)" />
                </div>
            </div>
        </div>
        <div class="error" id="errorMsg"></div>

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

        <div class="pagination" style="justify-content: center;">
		    <div class="pagination-controls">
		        <button onclick="prevPage()"><i class="fas fa-angle-left"></i></button>
		        <span id="pageInfo">Page 1</span>
		        <button onclick="nextPage()"><i class="fas fa-angle-right"></i></button>
		        <div class="limit-container">
		            <label for="limit">Limit:</label>
		            <input type="number" id="limit" value="10" min="1" onchange="fetchTransactions(true)" />
		        </div>
		    </div>
</div>

    </div>
</div>

<jsp:include page="Footer.jsp" />

<script>
    let currentOffset = 0;

    function fetchTransactions(resetPage) {
        const accountId = parseInt(document.getElementById("accountId").value.trim());
        let limit = parseInt(document.getElementById("limit").value.trim());
        const errorMsg = document.getElementById("errorMsg");
        
        if (limit > 100) {
            limit = 100;
            document.getElementById("limit").value = 100; // reset input visually too
        }

        if (!accountId || limit < 1) {
            errorMsg.textContent = "Please enter a valid Account ID and Limit.";
            return;
        }

        if (resetPage) currentOffset = 0;
        errorMsg.textContent = "";

        const ctxPath = "<%= request.getContextPath() %>";
        const url = ctxPath + "/jadebank/transactions/account?limit=" + limit + "&offset=" + currentOffset;

        fetch(url, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ accountId: accountId })
        })
        .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch transactions"))
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
                const statusText = txn.transactionStatus === 1 ? "Success"
                                 : txn.transactionStatus === 2 ? "Failure" : "Unknown";
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
