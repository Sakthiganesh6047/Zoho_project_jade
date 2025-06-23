<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Branch Accounts</title>
    <style>
        body {
            font-family: "Roboto", sans-serif;
            background-color: #f5f7fa;
            margin: 0;
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
            padding: 30px;
            flex: 1;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        .controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #fff;
            padding: 15px 20px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            max-width: 1000px;
            margin: 0 auto 20px auto;
        }

        .controls select,
        .controls input {
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        .controls button {
            padding: 10px 16px;
            background-color: #414485;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .controls button:hover {
            background-color: #005fa3;
        }

        .message {
            text-align: center;
            font-weight: bold;
            color: #333;
            margin: 15px 0;
        }

        table {
            width: 95%;
            margin: auto;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }

        th {
            background-color: #e6f2ff;
        }

        .pagination {
            text-align: center;
            margin: 20px auto 40px auto;
        }

        .pagination button {
            padding: 8px 16px;
            margin: 0 5px;
            border: none;
            border-radius: 6px;
            background-color: #414485;
            color: white;
            cursor: pointer;
        }

        .pagination button:hover {
            background-color: #005fa3;
        }

        .hidden {
            display: none;
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
        <h2>Branch Accounts List</h2>

        <div class="controls">
	        <div>
			    <label for="pageLimit">Rows per page:</label>
			    <select id="pageLimit" onchange="changePageSize()">
			        <option value="5" selected>5</option>
			        <option value="10">10</option>
			        <option value="20">20</option>
			        <option value="50">50</option>
			    </select>
			</div>
            <div>
                <label for="branchId">Select Branch:</label>
                <select id="branchId">
                    <option value="">-- Select --</option>
                </select>
                <button onclick="loadAccounts(0)">Load</button>
            </div>

            <div class="search-box">
                <label for="searchInput">Search:</label>
                <input type="text" id="searchInput" oninput="filterAccounts()" placeholder="Search ID, Customer, Type...">
            </div>
        </div>

        <div id="statusMessage" class="message"></div>

        <table id="accountsTable" class="hidden">
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
		    <button onclick="prevPage()">Previous</button>
		    <span id="pageInfo">Page 1</span>
		    <button onclick="nextPage()">Next</button>
		</div>
    </div>
</div>

<jsp:include page="Footer.jsp" />

<script>
    let pageSize = 5;
    let currentPage = 0;
    let lastPageReached = false;

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

    function changePageSize() {
        pageSize = parseInt(document.getElementById("pageLimit").value);
        currentPage = 0;
        lastPageReached = false;
        loadAccounts();
    }

    function loadAccounts() {
        const branchId = document.getElementById("branchId").value;
        const offset = currentPage * pageSize;
        const statusMessage = document.getElementById("statusMessage");
        const tbody = document.getElementById("accountTableBody");
        const table = document.getElementById("accountsTable");

        statusMessage.textContent = "";
        tbody.innerHTML = "";
        table.classList.add("hidden");

        if (!branchId) {
            statusMessage.textContent = "Please select a branch.";
            return;
        }

        fetch("${pageContext.request.contextPath}/jadebank/accounts/list/" + branchId + "?limit=" + pageSize + "&offset=" + offset)
            .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch"))
            .then(accounts => {
                if (!Array.isArray(accounts) || accounts.length === 0) {
                    if (currentPage > 0) {
                        currentPage--; // Step back to last valid page
                        lastPageReached = true;
                        updatePageInfo();
                    } else {
                        statusMessage.textContent = "No accounts found.";
                    }
                    return;
                }

                lastPageReached = accounts.length < pageSize;
                renderAccounts(accounts);
                updatePageInfo();
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

        table.classList.remove("hidden");
    }

    function updatePageInfo() {
        document.getElementById("pageInfo").textContent = `Page ${currentPage + 1}`;
    }

    function nextPage() {
        if (!lastPageReached) {
            currentPage++;
            loadAccounts();
        }
    }

    function prevPage() {
        if (currentPage > 0) {
            currentPage--;
            lastPageReached = false;
            loadAccounts();
        }
    }
</script>

</body>
</html>
