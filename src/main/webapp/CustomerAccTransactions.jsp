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
		    margin-left: 70px; /* for collapsed mode */
		    transition: margin-left 0.3s ease;
		    padding: 30px;
		    flex: 1;
		}
		
		/* When sidebar is expanded */
		.sidebar.expanded ~ .main-wrapper {
		    margin-left: 220px; /* match expanded width */
		}

        .main-wrapper {
            margin-left: 100px;
            padding: 30px;
            flex: 1;
            transition: margin-left 0.3s ease;
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
            padding: 10px;
            border-radius: 50%;
            border: none;
            background-color: #414485;
            color: white;
            font-size: 16px;
        }

        .pagination button:hover {
            background-color: #005fa3;
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

<jsp:include page="LoggedInHeader.jsp" />

<div class="body-wrapper">
    <div class="sidebar-wrapper">
        <jsp:include page="SideBar.jsp" />
    </div>

    <div class="main-wrapper">
        <h2>View Transactions</h2>

        <div class="search-section">
            <label for="accountId">Account ID:</label>
            <select id="accountId" onchange="fetchTransactions(true)">
                <option value="">-- Select Account --</option>
                <option value="ALL">All Accounts</option>
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

<jsp:include page="Footer.jsp" />

<script>
document.addEventListener("DOMContentLoaded", function() {
    var userId = <%= userId != null ? userId : "null" %>;
    if (userId) {
        fetch("<%= request.getContextPath() %>/jadebank/account/id", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ userId: userId })
        })
        .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch accounts"))
        .then(accounts => {
            var dropdown = document.getElementById("accountId");
            accounts.forEach(function(acc) {
                var option = document.createElement("option");
                option.value = acc.accountId;
                option.textContent = "ID: " + acc.accountId + " | " + (acc.accountType === 1 ? "Savings" : "Current");
                dropdown.appendChild(option);
            });
        })
        .catch(function(err) {
            document.getElementById("errorMsg").textContent = "Failed to load account list.";
            console.error(err);
        });
    }
});

var currentOffset = 0;

function fetchTransactions(resetPage) {
    if (resetPage) currentOffset = 0;

    var selected = document.getElementById("accountId").value;
    var limit = parseInt(document.getElementById("limit").value);
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
                "<td>" + (txn.beneficiaryAccount || "-") + "</td>" +
                "<td>" + (txn.description || "") + "</td>" +
                `<td class="${statusClass}">` + statusText + "</td>";

            tbody.appendChild(row);
        });

        document.getElementById("transactionTable").style.display = "table";
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
    var limit = parseInt(document.getElementById("limit").value);
    currentOffset += limit;
    fetchTransactions();
}

function prevPage() {
    var limit = parseInt(document.getElementById("limit").value);
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
