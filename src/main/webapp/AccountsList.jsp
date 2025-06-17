<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Branch Accounts</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .container {
            max-width: 1000px;
            margin: auto;
            padding: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #aaa;
            text-align: center;
        }
        .controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .search-box {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .pagination {
            margin-top: 10px;
            text-align: right;
        }
        .message {
            margin: 10px 0;
            font-weight: bold;
        }
    </style>
</head>
<body>
<jsp:include page="LoggedInHeader.jsp" />
<div class="container">
    <h2>Branch Account List</h2>

    <div class="controls">
        <div>
            <label for="branchId">Select Branch:</label>
            <select id="branchId">
                <option value="">-- Select --</option>
            </select>
            <button onclick="loadAccounts(0)">Load</button>
        </div>

        <div class="search-box">
            <label>Search:</label>
            <input type="text" id="searchInput" oninput="filterAccounts()" placeholder="Search ID, Customer, Type...">
        </div>
    </div>

    <div id="statusMessage" class="message"></div>

    <table id="accountsTable" style="display: none;">
        <thead>
            <tr>
                <th>Account ID</th>
                <th>Customer ID</th>
                <th>Account Type</th>
                <th>Balance</th>
                <th>Created Date</th>
            </tr>
        </thead>
        <tbody id="accountTableBody"></tbody>
    </table>

    <div class="pagination">
        <button onclick="prevPage()">Prev</button>
        <span id="pageIndicator">Page 1</span>
        <button onclick="nextPage()">Next</button>
    </div>
</div>

<script>
    const pageSize = 5;
    let currentPage = 0;
    let allAccounts = [];

    window.onload = function () {
        fetch("<%= request.getContextPath() %>/jadebank/branch/list")
            .then(res => res.json())
            .then(data => {
                const branchSelect = document.getElementById("branchId");
                data.forEach(branch => {
                    const option = document.createElement("option");
                    option.value = branch.branchId;
                    option.textContent = (branch.branchName ?? "Unnamed") + " - " + (branch.branchDistrict ?? "Unknown");
                    branchSelect.appendChild(option);
                });
            });
    };

    function loadAccounts(offset = 0) {
        const branchId = document.getElementById("branchId").value;
        const statusMessage = document.getElementById("statusMessage");
        const table = document.getElementById("accountsTable");
        const tbody = document.getElementById("accountTableBody");
        statusMessage.textContent = "";
        tbody.innerHTML = "";
        table.style.display = "none";
        allAccounts = [];

        if (!branchId) {
            statusMessage.textContent = "Please select a branch.";
            return;
        }

        fetch('${pageContext.request.contextPath}/jadebank/accounts/list/' + branchId + '?limit=' + pageSize + '&offset=' + offset)
            .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch"))
            .then(accounts => {
                if (!accounts || accounts.length === 0) {
                    statusMessage.textContent = "No accounts found for this branch.";
                    return;
                }

                allAccounts = accounts;
                currentPage = offset / pageSize;
                renderAccounts(accounts);
                document.getElementById("pageIndicator").textContent = `Page ${currentPage + 1}`;
            })
            .catch(err => {
                console.error(err);
                statusMessage.textContent = "Error loading accounts.";
            });
    }

    function renderAccounts(accountList) {
        const tbody = document.getElementById("accountTableBody");
        const table = document.getElementById("accountsTable");

        tbody.innerHTML = "";
        accountList.forEach(acc => {
            const dateStr = acc.createdAt ? new Date(acc.createdAt).toLocaleDateString('en-IN') : "-";
            const row = document.createElement("tr");
            row.innerHTML = 
                "<td>" + acc.accountId + "</td>" +
                "<td>" + acc.customerId + "</td>" +
                "<td>" + (acc.accountType == 1 ? "Savings" : "Current") + "</td>" +
                "<td>" + acc.balance.toFixed(2) + "</td>" +
                "<td>" + dateStr + "</td>";
            tbody.appendChild(row);
        });

        table.style.display = "table";
    }

    function filterAccounts() {
        const query = document.getElementById("searchInput").value.toLowerCase();
        const filtered = allAccounts.filter(acc => {
            const type = acc.accountType === 1 ? "savings" : "current";
            return (
                acc.accountId.toString().includes(query) ||
                acc.customerId.toString().includes(query) ||
                type.includes(query)
            );
        });
        renderAccounts(filtered);
    }

    function nextPage() {
        loadAccounts((currentPage + 1) * pageSize);
    }

    function prevPage() {
        if (currentPage > 0) {
            loadAccounts((currentPage - 1) * pageSize);
        }
    }
</script>

<jsp:include page="Footer.jsp" />
</body>
</html>
