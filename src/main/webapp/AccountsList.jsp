<%@ page session="false" %>
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
            flex: 1;
            transition: margin-left 0.3s ease;
        }

        .sidebar.expanded ~ .main-wrapper {
            margin-left: 220px;
        }

        .page-title-wrapper {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title {
            font-size: 26px;
            font-weight: 700;
            color: #2e2f60;
            background: linear-gradient(to right, #e0e7ff, #f4f4fb);
            border-left: 6px solid #414485;
            padding: 10px 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 0px;
            margin-top: 0px;
        }
        
        .control-add{
        	display: flex;
        	align-items: center;
        }

        .add-account-btn {
            background: #414485;
            color: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            font-size: 18px;
            cursor: pointer;
            transition: background 0.3s ease;
            margin-bottom: 20px;
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
        
        .searchbyid {
        	display: flex;
        	gap: 5px;
        }

        .controls label {
            margin-right: 10px;
        }

        .controls select, input {
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
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
            gap: 20px;
            margin-bottom: 40px;
        }

        .pagination button {
            background-color: #414485;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 10px 14px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .pagination button:disabled {
            background-color: #aaa;
            cursor: not-allowed;
            opacity: 0.6;
        }

        .pagination button:hover:not(:disabled) {
            background-color: #2a2d63;
        }

        .hidden {
            display: none;
        }
        
        #editModal {
		    display: none; /* Keep it hidden by default */
		    position: fixed;
		    top: 0;
		    left: 0; 
		    right: 0;
		    bottom: 0;
		    background-color: rgba(0,0,0,0.4);
		    z-index: 9999;
		    align-items: center;
		    justify-content: center;
		}
        
    </style>
</head>
<body>

<div class="body-wrapper">
    <div class="main-wrapper">
        <div class="page-title-wrapper">
            <h2 class="page-title">Branch Accounts List</h2>
        </div>
		<div class="control-add">
	        <div class="controls">
	            <div>
	                <label for="branchId">Branch:</label>
	                <select id="branchId" onchange="loadAccounts()">
	                    <option value="">-- Select --</option>
	                </select>
	            </div>
	            <div>
	                <label for="accountType">Type:</label>
	                <select id="accountType" onchange="loadAccounts()">
	                    <option value="">-- All --</option>
	                    <option value="savings">Savings</option>
	                    <option value="current">Current</option>
	                </select>
	            </div>
	            <div>
	                <label for="accountStatus">Status:</label>
	                <select id="accountStatus" onchange="loadAccounts()">
	                    <option value="">-- All --</option>
	                    <option value="new">New</option>
	                    <option value="active">Active</option>
	                    <option value="blocked">Blocked</option>
	                </select>
	            </div>
	            <div>
				    <label for="searchAccountId">Search by Account ID:</label>
				    <div class="searchbyid">
				    	<input type="text" id="searchAccountId" placeholder="Enter account number..." 
				    		maxlength="10"
       						pattern="\d{1,10}" title="Enter up to 10 digits only"
       						oninput="this.value = this.value.replace(/[^0-9]/g, '')"
				    		onkeydown="if(event.key==='Enter') searchByAccountId()" />
				    	<button onclick="searchByAccountId()"><i class="fas fa-search"></i></button>
					</div>
				</div>
	        </div>
	        <div>
		        <button class="add-account-btn" title="Add Account" onclick="window.location.href='OpenAccount.jsp'">
		           <i class="fas fa-plus"></i>
		       </button>
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
                    <th>Actions</th>
                    
                </tr>
            </thead>
            <tbody id="accountTableBody"></tbody>
        </table>

        <div class="pagination">
            <button onclick="prevPage()" id="prevBtn"><i class="fas fa-angle-left"></i></button>
            <span id="pageInfo">Page 1</span>
            <button onclick="nextPage()" id="nextBtn"><i class="fas fa-angle-right"></i></button>
        </div>
    </div>
</div>

<!-- Edit Account Modal -->
<div id="editModal" class="hidden">
    <div style="
        background: white; padding: 30px; border-radius: 12px; width: 400px; position: relative;
    ">
        <h3>Edit Account</h3>
        <input type="hidden" id="editAccountId" />

        <label for="editAccountType">Account Type:</label>
        <select id="editAccountType" style="width: 100%; margin-bottom: 15px;">
            <option value="1">Savings</option>
            <option value="2">Current</option>
        </select>

        <label for="editAccountStatus">Account Status:</label>
        <select id="editAccountStatus" style="width: 100%; margin-bottom: 20px;">
            <option value="1">Active</option>
            <option value="2">Blocked</option>
            <option value="3">Closed</option>
        </select>

        <div style="text-align: right;">
            <button onclick="saveAccountChanges()" style="margin-right: 10px;">Save</button>
            <button onclick="closeEditModal()">Cancel</button>
        </div>
    </div>
</div>

<jsp:include page="Footer.jsp" />

<script>
    const pageSize = 10;
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

    function loadAccounts() {
        const branchId = document.getElementById("branchId").value;
        const accountType = document.getElementById("accountType").value;
        const accountStatus = document.getElementById("accountStatus").value;
        const offset = currentPage * pageSize;
        const tbody = document.getElementById("accountTableBody");
        const table = document.getElementById("accountsTable");
        const statusMessage = document.getElementById("statusMessage");

        tbody.innerHTML = "";
        table.classList.add("hidden");
        statusMessage.textContent = "";

        if (!branchId) {
            statusMessage.textContent = "Please select a branch.";
            return;
        }

        let url = "<%= request.getContextPath() %>" + "/jadebank/accounts/list/" + branchId + "?limit=" + pageSize + "&offset=" + offset;
        if (accountType) url += "&type=" + accountType;
        if (accountStatus) url += "&status=" + accountStatus;

        fetch(url, {
            method: 'GET',
            headers: {
                'Accept': 'application/json'
            }
        })
        .then(res => {
            if (res.status === 401) {
                // Session expired, redirect to login
                window.location.href = "<%= request.getContextPath() %>/Login.jsp?expired=true";
                return; // Stop further processing
            }

            if (!res.ok) {
                return Promise.reject("Fetch error: " + res.status);
            }

            return res.json();
        })
        .then(accounts => {
            if (!Array.isArray(accounts) || accounts.length === 0) {
                if (currentPage > 0) currentPage--;
                else statusMessage.textContent = "No accounts found.";
                updatePagination();
                return;
            }

            renderAccounts(accounts);
            lastPageReached = accounts.length < pageSize;
            updatePagination();
        })
        .catch(err => {
            console.error(err);
            statusMessage.textContent = "Error loading accounts.";
        });
    }

    function renderAccounts(accounts) {
        const tbody = document.getElementById("accountTableBody");
        const table = document.getElementById("accountsTable");
        accounts.forEach(acc => {
            const row = document.createElement("tr");
            const dateStr = acc.createdAt ? new Date(acc.createdAt).toLocaleDateString('en-IN') : "-";
            const statusLabel = acc.accountStatus == 1 ? "Active" : acc.accountStatus == 2 ? "Blocked" : "Closed";

            row.innerHTML = 
                "<td>" + acc.accountId + "</td>" +
                "<td>" + acc.customerId + "</td>" +
                "<td>" + (acc.accountType == 1 ? "Savings" : "Current") + "</td>" +
                "<td>" + acc.balance.toFixed(2) + "</td>" +
                "<td>" + statusLabel + "</td>" +
                "<td>" + dateStr + "</td>" +
                "<td>" +
                    "<button onclick=\"openEditModal(" + acc.accountId + ", " + acc.accountType + ", " + acc.accountStatus + ")\" title=\"Edit Account\">" +
                        "<i class=\"fas fa-edit\"></i>" +
                    "</button>" +
                "</td>";
            tbody.appendChild(row);
        });
        table.classList.remove("hidden");
    }
    
    function searchByAccountId() {
        const accountId = document.getElementById("searchAccountId").value.trim();
        const tbody = document.getElementById("accountTableBody");
        const table = document.getElementById("accountsTable");
        const statusMessage = document.getElementById("statusMessage");

        tbody.innerHTML = "";
        table.classList.add("hidden");
        statusMessage.textContent = "";

        if (!accountId) {
            statusMessage.textContent = "Please enter a valid account ID.";
            return;
        }

        fetch("<%= request.getContextPath() %>/jadebank/account/accountId", {
            method: "POST",
            headers: { "Content": "application/json",
            	"Accept": "application/json" },
        	body: JSON.stringify({ accountId: accountId })
        })
        .then(res => {
            if (res.status === 401) {
                window.location.href = "<%= request.getContextPath() %>/Login.jsp?expired=true";
                return;
            }
            if (!res.ok) {
                throw new Error("Account not found");
            }
            return res.json();
        })
        .then(acc => {
            if (!acc || !acc.accountId) {
                statusMessage.textContent = "Account not found.";
                return;
            }

            renderAccounts([acc]);
            document.getElementById("pageInfo").textContent = "Search Result";
            document.getElementById("prevBtn").disabled = true;
            document.getElementById("nextBtn").disabled = true;
        })
        .catch(err => {
            console.error(err);
            statusMessage.textContent = "Account not found.";
        });
    }

    function openEditModal(accountId, type, status) {
        document.getElementById("editAccountId").value = accountId;
        document.getElementById("editAccountType").value = type;
        document.getElementById("editAccountStatus").value = status;

        const modal = document.getElementById("editModal");
        modal.style.display = "flex"; // <- now using flex only on open
    }

    function closeEditModal() {
        document.getElementById("editModal").style.display = "none";
    }

    function saveAccountChanges() {
        const accountId = document.getElementById("editAccountId").value;
        const accountType = document.getElementById("editAccountType").value;
        const accountStatus = document.getElementById("editAccountStatus").value;

        fetch("<%= request.getContextPath() %>/jadebank/account/updateStatus", {
            method: "PUT",
            headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
            },
            body: JSON.stringify({
                accountId: parseInt(accountId),
                accountType: parseInt(accountType),
                accountStatus: parseInt(accountStatus)
            })
        })
        .then(res => {
            if (!res.ok) throw new Error("Update failed");
            return res.json();
        })
        .then(result => {
            closeEditModal();
            loadAccounts(); // Refresh the table
        })
        .catch(err => {
            alert("Error updating account: " + err.message);
            console.error(err);
        });
    }

    function updatePagination() {
        document.getElementById("pageInfo").textContent = `Page ${currentPage + 1}`;
        document.getElementById("prevBtn").disabled = currentPage === 0;
        document.getElementById("nextBtn").disabled = lastPageReached;
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
