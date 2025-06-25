<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Branch Accounts</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        body {
        	transition: opacity 0.2s ease-in;
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
            position: relative;
        }

        .add-account-btn {
            position: absolute;
            top: 0;
            right: 0;
            background: #414485;
            color: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            font-size: 18px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .add-account-btn:hover {
            background: #2a2d63;
        }

        .controls {
            display: flex;
            justify-content: center;
            align-items: center;
            background: #fff;
            padding: 15px 20px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            max-width: 700px;
            margin: 0 auto 20px auto;
            gap: 30px;
        }

        .controls label {
            margin-right: 10px;
        }

        .controls select {
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        .controls button {
            margin-left: 10px;
            padding: 10px;
            background-color: #414485;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
        }

        .controls button:hover {
            background-color: #2a2d63;
        }

		.filter-wrapper {
			display: flex;
			align-items: center;
		}
		
        .message {
            text-align: center;
            font-weight: bold;
            color: #333;
            margin: 15px 0;
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

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 16px;
            margin-bottom: 40px;
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

        .page-controls {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .page-controls select {
            padding: 6px 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        .hidden {
            display: none;
        }
    </style>
</head>
<body>

<jsp:include page="LoggedInHeader.jsp" />

<div class="body-wrapper">
    <jsp:include page="SideBar.jsp" />

    <div class="main-wrapper">
        <h2>
            Branch Accounts List
            <button class="add-account-btn" title="Add Account" onclick="window.location.href='OpenAccount.jsp'">
                <i class="fas fa-plus"></i>
            </button>
        </h2>

        <div class="controls">
        	<div class="filter-wrapper">
			    <label for="branchId">Select Branch:</label>
			    <select id="branchId" onchange="loadAccounts(0)">
			        <option value="">-- Select --</option>
			    </select>
			</div>
			<div class = "filter-wrpper">
			    <label for="accountType">Type:</label>
			    <select id="accountType" onchange="loadAccounts(0)">
			        <option value="">-- All --</option>
			        <option value="savings">Savings</option>
			        <option value="current">Current</option>
			    </select>
			</div>
			<div class="filter-wrapper">
			    <label for="accountStatus">Status:</label>
			    <select id="accountStatus" onchange="loadAccounts(0)">
			        <option value="">-- All --</option>
			        <option value="new">New</option>
			        <option value="active">Active</option>
			        <option value="blocked">Blocked</option>
			    </select>
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
                    <th>Status</th>
                    <th>Created Date</th>
                </tr>
            </thead>
            <tbody id="accountTableBody"></tbody>
        </table>

        <div class="pagination">
            <button onclick="prevPage()"><i class="fas fa-angle-left"></i></button>
            <span id="pageInfo">Page 1</span>
            <button onclick="nextPage()"><i class="fas fa-angle-right"></i></button>

            <div class="page-controls">
                <label for="pageLimit">Rows:</label>
                <select id="pageLimit" onchange="changePageSize()">
                    <option value="5" selected>5</option>
                    <option value="10">10</option>
                    <option value="20">20</option>
                    <option value="50">50</option>
                </select>
            </div>
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
        const accountType = document.getElementById("accountType").value;
        const accountStatus = document.getElementById("accountStatus").value;
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

        // Use JSP expression to get context path
        let url = "<%= request.getContextPath() %>" + "/jadebank/accounts/list/" + branchId + "?limit=" + pageSize + "&offset=" + offset;

        if (accountType) {
            url += "&type=" + accountType;
        }

        if (accountStatus) {
            url += "&status=" + accountStatus;
        }

        fetch(url)
            .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch"))
            .then(accounts => {
                if (!Array.isArray(accounts) || accounts.length === 0) {
                    if (currentPage > 0) {
                        currentPage--;
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
                "<td>" + (acc.accountStatus == 1 ? "Active" : "Inactive") + "</td>" +
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
