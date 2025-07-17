<%@ page session="false" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Transactions</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" />
    <style>
        body {
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
            margin-left: 20px;
            padding: 30px;
            padding-bottom: 0px;
            flex: 1;
            transition: margin-left 0.3s ease;
        }

        .sidebar.expanded ~ .main-wrapper {
            margin-left: 220px;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            font-size: 26px;
            color: #373962;
            position: relative;
        }
        
        .page-title {
		    font-size: 26px;
		    font-weight: 700;
		    color: #2e2f60;
		    background: linear-gradient(to right, #e0e7ff, #f4f4fb);
		    border-left: 6px solid #414485;
		    padding: 10px 20px;
		    margin-bottom: 0px;
		    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
		    width: fit-content;
		}
        
        .search-section {
            max-width: 600px;
            margin: 0 auto 30px auto;
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
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        .error {
            text-align: center;
            font-weight: bold;
            margin: 15px 0;
            color: #c62828;
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
            border-radius: 5px;
            padding: 10px 12px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .pagination button:hover {
            background-color: #2a2d63;
        }

        .pagination button:disabled {
            background-color: #aaa;
            cursor: not-allowed;
            opacity: 0.6;
        }
    </style>
</head>
<body>

<div class="body-wrapper">
    <div class="main-wrapper">
		    <h2 class="page-title">Transactions History</h2>

        <div class="search-section">
            <div class="search-row">
                <div class="search-wrapper">
				    <label for="accountId">Account ID:</label>
				    <input type="text" id="accountId"  maxlength="10"
            		pattern="\d{1,10}" title="Enter up to 10 digits only"
       				oninput="this.value = this.value.replace(/[^0-9]/g, '')" placeholder="Enter Account ID" />
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
                    <th>Reference Acc</th>
                    <th>Description</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody id="transactionBody"></tbody>
        </table>

        <div class="pagination">
            <div class="pagination-controls">
                <button id="prevBtn" onclick="prevPage()"><i class="fas fa-angle-left"></i></button>
                <span id="pageInfo">Page 1</span>
                <button id="nextBtn" onclick="nextPage()"><i class="fas fa-angle-right"></i></button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="Footer.jsp" />

<script>
    const pageSize = 13;
    let currentOffset = 0;
    let lastPageReached = false;

    function fetchTransactions(resetPage) {
        const accountId = parseInt(document.getElementById("accountId").value.trim());
        const errorMsg = document.getElementById("errorMsg");

        if (!accountId) {
            errorMsg.textContent = "Please enter a valid Account ID.";
            return;
        }

        if (resetPage) currentOffset = 0;
        lastPageReached = false;
        errorMsg.textContent = "";

        const url = "<%= request.getContextPath() %>/jadebank/transactions/account?limit=" + pageSize + "&offset=" + currentOffset;

        fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"  // Important for filter to detect it's AJAX
            },
            body: JSON.stringify({ accountId: accountId })
        })
        .then(async res => {
            if (res.status === 401) {
                // Session expired, redirect to login
                window.location.href = "<%= request.getContextPath() %>/Login.jsp?expired=true";
                return null; // prevent further processing
            }

            const contentType = res.headers.get("content-type");
            const isJson = contentType && contentType.includes("application/json");
            const data = isJson ? await res.json() : null;

            if (!res.ok) {
                const errorMsgFromServer = data?.error || "Failed to fetch transactions";
                throw new Error(errorMsgFromServer);
            }

            return data;
        })
        .then(data => {
            if (!data) return; // exit if session expired

            const tbody = document.getElementById("transactionBody");
            tbody.innerHTML = "";

            if (!Array.isArray(data) || data.length === 0) {
                if (currentOffset > 0) {
                    currentOffset -= pageSize;
                    lastPageReached = true;
                    updatePaginationControls();
                } else {
                    errorMsg.textContent = "No transactions found.";
                    document.getElementById("transactionTable").style.display = "none";
                }
                return;
            }

            lastPageReached = data.length < pageSize;

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
                    "<td>" + (txn.transferReference || "-") + "</td>" +
                    "<td>" + (txn.description || "") + "</td>" +
                    "<td>" + statusText + "</td>";
                tbody.appendChild(row);
            });

            document.getElementById("transactionTable").style.display = "table";
            updatePaginationControls();
        })
        .catch(err => {
            errorMsg.textContent = "Error: " + err.message;
            console.error(err);
        });
    }

    function nextPage() {
        if (!lastPageReached) {
            currentOffset += pageSize;
            fetchTransactions();
        } else {
            document.getElementById("errorMsg").textContent = "You are already on the last page.";
            updatePaginationControls();
        }
    }

    function prevPage() {
        if (currentOffset >= pageSize) {
            currentOffset -= pageSize;
            fetchTransactions();
        } else {
            document.getElementById("errorMsg").textContent = "You are already on the first page.";
            updatePaginationControls();
        }
    }

    function updatePaginationControls() {
        document.getElementById("pageInfo").textContent = "Page " + (Math.floor(currentOffset / pageSize) + 1);
        document.getElementById("prevBtn").disabled = currentOffset === 0;
        document.getElementById("nextBtn").disabled = lastPageReached;
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
    document.getElementById("accountId").addEventListener("input", function () {
        const value = this.value;
        if (value.length >= 10) {
            fetchTransactions(true);
        }
    });
</script>

</body>
</html>
