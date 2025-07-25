<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<%
    Long userId = (Long) session.getAttribute("userId");
%>
<head>
    <title>View Transactions</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" />
    <style>
        body {
            font-family: "Roboto", sans-serif;
            background-image: url("contents/background.png"); /* Replace with your actual path */
		    background-size: cover;        /* Scales the image to cover the whole screen */
		    background-repeat: no-repeat;  /* Prevents tiling */
		    background-position: center;
            margin: 0;
            padding-top: 70px;
        }

        .body-wrapper {
            display: flex;
            min-height: 89vh;
            margin-left: 20px;
        }
        
        .page-title {
		    text-align: center;
		    font-size: 28px;
		    font-weight: 700;
		    color: #2e2f60;
		    margin-bottom: 25px;
		    position: relative;
		    padding: 10px 20px;
		    background: linear-gradient(to right, #e0e7ff, #f4f4fb);
		    border-left: 6px solid #414485;
		    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
		    width: fit-content;
		    margin-right: auto;
		}

        .sidebar-wrapper {
            width: 70px;
            background-color: transparent;
            color: white;
            position: fixed;
            height: 100%;
            border-radius: 0 12px 12px 0;
            z-index: 1000;
        }
        
        .main-wrapper {
		    transition: margin-left 0.3s ease;
		    padding: 30px;
		    padding-bottom: 1px;
		    padding-top: 10px;
		    flex: 1;
		}
		
		/* When sidebar is expanded */
		.sidebar.expanded ~ .main-wrapper {
		    margin-left: 220px; /* match expanded width */
		}

        h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        .search-section {
            max-width: 700px;
            margin: 0 auto 30px auto;
            border-radius: 10px;
        }

        .search-section label {
            font-weight: bold;
            display: block;
            margin-top: 15px;
        }

        .search-section input,
        .search-section select {
            width: 100%;
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
            text-align: left;
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

        th:first-child, td:first-child {
            border-top-left-radius: 12px;
        }

        th:last-child, td:last-child {
            border-top-right-radius: 12px;
        }

        .credit { color: #2e7d32; font-weight: bold; }
        .debit { color: #c62828; font-weight: bold; }

        .pagination {
            text-align: center;
            margin-bottom: 40px;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 20px;
        }

        .pagination button {
            padding: 8px 16px;
            border: none;
            background-color: #414485;
            color: white;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.2s ease;
        }

        .pagination button:hover {
            background-color: #005fa3;
        }
        
        .pagination button:disabled {
		    cursor: not-allowed;
		    background-color: #aaa;
		    color: #eee;
		    transform: none;
		    opacity: 0.6;
		}
		
		.pagination button:disabled:hover {
		    background-color: #aaa;
		}

        .limit-container {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Type colors */
		.type-credit {
			color: green;
			font-weight: bold;
		}
		
		.type-debit {
			color: red;
			font-weight: bold;
		}
		
		.type-transfer {
			color: orange;
			font-weight: bold;
		}
		
		/* Status colors */
		.status-success {
			color: green;
			font-weight: bold;
		}
		
		.status-failure {
			color: red;
			font-weight: bold;
		}
		
		.status-unknown {
			color: gray;
			font-style: italic;
		}
        
        #limit {
            width: 60px;
            padding: 8px;
        }

        #pageInfo {
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="body-wrapper">

    <div class="main-wrapper">
		<h2 class="page-title">Transaction History</h2>

        <div class="search-section">
            <label for="accountId">Account ID:</label>
            <select id="accountId" onchange="fetchTransactions(true)">
                <option value="">-- Select Account --</option>
            </select>

            <div id="errorMsg" class="error"></div>
        </div>

        <table id="transactionTable" style="display: none;">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Date</th>
                    <th>Account</th>
                    <th>Type</th>
                    <th>Amount</th>
                    <th>Closing Balance</th>
                    <th>Beneficiary</th>
                    <th>Description</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody id="transactionBody"></tbody>
        </table>

		<div class="pagination">
		    <button id="prevBtn" onclick="prevPage()"><i class="fas fa-angle-left"></i></button>
		    <span id="pageInfo">Page 1</span>
		    <button id="nextBtn" onclick="nextPage()"><i class="fas fa-angle-right"></i></button>
		</div>
    </div>
</div>

<jsp:include page="Footer.jsp" />

<script>

let hasNextPage = false;

document.addEventListener("DOMContentLoaded", function () {
    const userId = <%= userId != null ? userId : "null" %>;
    const contextPath = "<%= request.getContextPath() %>";
    const dropdown = document.getElementById("accountId");

    if (!userId) return;

    // Fetch all accounts for dropdown
    fetch(contextPath + "/jadebank/account/id", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ userId: userId })
    })
        .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch accounts"))
        .then(accounts => {
            accounts.forEach(acc => {
                const option = document.createElement("option");
                option.value = acc.accountId;
                option.textContent = "ID: " + acc.accountId + " | " + (acc.accountType === 1 ? "Savings" : "Current");
                dropdown.appendChild(option);
            });

            // After adding accounts, fetch primary account and trigger transaction fetch
            return fetch(contextPath + "/jadebank/account/primary", {
                method: "GET"
            });
        })
        .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch primary account"))
        .then(primary => {
            if (primary && primary.accountId) {
                dropdown.value = primary.accountId;
                fetchTransactions(true);
            }
        })
        .catch(err => {
            document.getElementById("errorMsg").textContent = "Error loading account data.";
            console.error(err);
        });
});

var currentOffset = 0;
const PAGE_LIMIT = 13; // limit

function fetchTransactions(resetPage) {
    if (resetPage) currentOffset = 0;

    var selected = document.getElementById("accountId").value;
    var limit = PAGE_LIMIT;
    var errorMsg = document.getElementById("errorMsg");

    if (!selected || limit < 1) {
        errorMsg.textContent = "Select a valid account and limit.";
        return;
    }

    var url = "";
    var body = {};

    if (selected === "ALL") {
        url = "<%= request.getContextPath() %>/jadebank/transactions/customer?limit=" + limit + "&offset=" + currentOffset;
        body = { customerId: <%= userId %> };
    } else {
        url = "<%= request.getContextPath() %>/jadebank/transactions/account?limit=" + limit + "&offset=" + currentOffset;
        body = { accountId: parseInt(selected) };
    }

    fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body)
    })
    .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch transactions"))
    .then(function(data) {
        var tbody = document.getElementById("transactionBody");
        tbody.innerHTML = "";

        if (!Array.isArray(data) || data.length === 0) {
            errorMsg.textContent = "No transactions found.";
            document.getElementById("transactionTable").style.display = "none";
            return;
        }

        data.forEach(function(txn) {
            var row = document.createElement("tr");

            // Set type label and class
            let typeLabel = getTypeLabel(txn.transactionType);
            let typeClass = "";
            switch (txn.transactionType) {
                case 1: typeClass = "type-credit"; break;
                case 2: typeClass = "type-debit"; break;
                case 3: typeClass = "type-transfer"; break;
                default: typeClass = "";
            }

            // Set status text and class
            let statusText = "Unknown";
            let statusClass = "status-unknown";
            if (txn.transactionStatus === 1) {
                statusText = "Success";
                statusClass = "status-success";
            } else if (txn.transactionStatus === 2) {
                statusText = "Failure";
                statusClass = "status-failure";
            }

            row.innerHTML =
                "<td>" + txn.transactionId + "</td>" +
                "<td>" + formatDate(txn.transactionDate) + "</td>" +
                "<td>" + txn.accountId + "</td>" +
                `<td class="${typeClass}">` + typeLabel + "</td>" +
                "<td>" + txn.amount + "</td>" +
                "<td>" + txn.closingBalance + "</td>" +
                "<td>" + (txn.transferReference || "-") + "</td>" +
                "<td>" + (txn.description || "") + "</td>" +
                `<td class="${statusClass}">` + statusText + "</td>";

            tbody.appendChild(row);
        });

        document.getElementById("transactionTable").style.display = "table";
        hasNextPage = data.length === limit;
        updatePaginationButtons();
        document.getElementById("pageInfo").textContent = "Page " + (Math.floor(currentOffset / limit) + 1);

    })
    .catch(function(err) {
        errorMsg.textContent = "Error: " + err;
        console.error(err);
    });
}

function formatDate(timestamp) {
    var date = new Date(Number(timestamp));
    return date.toLocaleString("en-IN");
}

function nextPage() {
    if (!hasNextPage) return;
    currentOffset += PAGE_LIMIT;
    fetchTransactions();
}

function prevPage() {
    if (currentOffset >= PAGE_LIMIT) {
        currentOffset -= PAGE_LIMIT;
        fetchTransactions();
    }
}

function updatePaginationButtons() {
    const prevBtn = document.getElementById("prevBtn");
    const nextBtn = document.getElementById("nextBtn");

    prevBtn.disabled = currentOffset === 0;
    nextBtn.disabled = !hasNextPage;
}

function getTypeLabel(type) {
    switch (type) {
        case 1: return "Credit";
        case 2: return "Debit";
        case 3: return "Transfer";
        default: return "Unknown";
    }
}

function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const mainWrapper = document.querySelector('.main-wrapper');

    sidebar.classList.toggle('expanded');

    if (sidebar.classList.contains('expanded')) {
        mainWrapper.style.marginLeft = "220px";
    } else {
        mainWrapper.style.marginLeft = "70px";
    }
}


</script>
</body>
</html>
