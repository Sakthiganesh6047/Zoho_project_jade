<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Long userId = (Long) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Beneficiaries - JadeBank</title>
    <style>
        body {
            font-family: "Roboto", sans-serif;
            background-color: #f5f7fa;
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

        .form-section {
            max-width: 600px;
            margin: auto;
            margin-bottom: 20px;
        }

        .form-section label {
            font-weight: bold;
            margin-right: 10px;
        }

        .form-section select {
            padding: 8px;
            border-radius: 6px;
        }

        .beneficiary-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }

        .beneficiary-table th,
        .beneficiary-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ccc;
        }

        .pagination {
            text-align: center;
            margin-top: 20px;
        }

        .pagination button {
            padding: 8px 16px;
            margin: 0 5px;
            border: none;
            background-color: #4CAF50;
            color: white;
            border-radius: 5px;
            cursor: pointer;
        }
        
        .del-button{
        	background-color:#e53935;
			color:white;
			border:none;
			padding:6px 10px;
			border-radius:4px;
        }

        .pagination button:hover {
            background-color: #388e3c;
        }

        #status {
            margin-top: 10px;
            color: red;
            font-weight: bold;
            text-align: center;
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
        <div class="form-section">
            <label for="accountId">Select Account:</label>
            <select id="accountId">
                <option value="">-- Select Account --</option>
            </select>
        </div>

        <table class="beneficiary-table" id="beneficiaryTable" style="display: none;">
            <thead>
			    <tr>
			        <th>Name</th>
			        <th>Bank</th>
			        <th>Account Number</th>
			        <th>IFSC Code</th>
			        <th>Actions</th>
			    </tr>
			</thead>
            <tbody id="beneficiaryTableBody"></tbody>
        </table>

        <div id="status"></div>

        <div class="pagination">
            <button onclick="prevPage()">Previous</button>
            <span id="pageIndicator">Page 1</span>
            <button onclick="nextPage()">Next</button>
        </div>
    </div>
</div>

<jsp:include page="Footer.jsp" />

<script>
    const userId = <%= userId != null ? userId : "null" %>;
    let currentPage = 0;
    const pageSize = 5;

    document.addEventListener("DOMContentLoaded", () => {
        if (!userId) return;

        // Populate account dropdown
        fetch(`${pageContext.request.contextPath}/jadebank/account/id`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ userId: userId })
        })
        .then(res => res.ok ? res.json() : Promise.reject("Failed to load accounts"))
        .then(accounts => {
            const accountSelect = document.getElementById("accountId");
            accounts.forEach(acc => {
                const option = document.createElement("option");
                option.value = acc.accountId;
                option.textContent = "ID: " + acc.accountId + " | Type: " + (acc.accountType === 1 ? "Savings" : "Current");
                accountSelect.appendChild(option);
            });
        })
        .catch(err => {
            console.error(err);
            document.getElementById("status").textContent = "Unable to load accounts.";
        });

        document.getElementById("accountId").addEventListener("change", () => {
            currentPage = 0;
            loadBeneficiaries();
        });
    });

    function loadBeneficiaries() {
        const accountId = document.getElementById("accountId").value;
        const statusDiv = document.getElementById("status");
        const table = document.getElementById("beneficiaryTable");

        if (!accountId) {
            table.style.display = "none";
            statusDiv.textContent = "Please select an account.";
            return;
        }

        statusDiv.textContent = "";
        const offset = currentPage * pageSize;

        fetch("${pageContext.request.contextPath}/jadebank/beneficiary/id?limit=" + pageSize + "&offset=" + offset, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ accountId: parseInt(accountId) })
        })
        .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch beneficiaries"))
        .then(beneficiaries => {
            const tbody = document.getElementById("beneficiaryTableBody");
            tbody.innerHTML = "";

            if (!beneficiaries || beneficiaries.length === 0) {
                table.style.display = "none";
                statusDiv.textContent = "No beneficiaries found.";
                return;
            }

            beneficiaries.forEach(b => {
                const row = document.createElement("tr");
                row.innerHTML = 
                    "<td>" + b.beneficiaryName + "</td>" +
                    "<td>" + b.bankName + "</td>" +
                    "<td>" + b.beneficiaryAccountNumber + "</td>" +
                    "<td>" + b.ifscCode + "</td>" +
                    "<td><button class=\"del-button\" onclick=\"deleteBeneficiary(" + b.beneficiaryId + ")\">Delete</button></td>";
                tbody.appendChild(row);
            });

            table.style.display = "table";
            document.getElementById("pageIndicator").textContent = `Page ${currentPage + 1}`;
        })
        .catch(err => {
            console.error(err);
            table.style.display = "none";
            statusDiv.textContent = "Error loading beneficiaries.";
        });
    }
    
    function deleteBeneficiary(beneficiaryId) {
        if (!confirm("Are you sure you want to delete this beneficiary?")) return;

        fetch("${pageContext.request.contextPath}/jadebank/beneficiary/id/" + beneficiaryId, {
            method: "POST"
        })
        .then(async res => {
            const statusDiv = document.getElementById("status");
            if (res.ok) {
                statusDiv.textContent = "Beneficiary deleted successfully.";
                statusDiv.style.color = "green";
                loadBeneficiaries(); // Reload the current list
            } else {
                const error = await res.json();
                statusDiv.textContent = error.error || "Failed to delete beneficiary.";
                statusDiv.style.color = "red";
            }
        })
        .catch(err => {
            document.getElementById("status").textContent = "Network error: " + err.message;
            document.getElementById("status").style.color = "red";
        });
    }

    function nextPage() {
        currentPage++;
        loadBeneficiaries();
    }

    function prevPage() {
        if (currentPage > 0) {
            currentPage--;
            loadBeneficiaries();
        }
    }
</script>
</body>
</html>
