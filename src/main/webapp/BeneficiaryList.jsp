<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Long userId = (Long) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Beneficiaries - JadeBank</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        body {
            font-family: "Roboto", sans-serif;
            background-color: white;
            margin: 0;
            padding-top: 70px; /* same as header height */
        }

        .body-wrapper {
            display: flex;
            min-height: 89vh;
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
		    margin-left: 70px; /* default collapsed sidebar width */
		    padding: 30px;
		    flex: 1;
		    transition: margin-left 0.3s ease;
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
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 15px;
            width: 100%;
        }

        .beneficiary-table {
		    width: 100%;
		    border-collapse: separate;
		    border-spacing: 0;
		    background: #ffffff;
		    border-radius: 12px;
		    overflow: hidden;
		    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
		    font-size: 15px;
		}
		
		.beneficiary-table thead {
		    background-color: #414485;
		    color: white;
		    font-weight: bold;
		}
		
		.beneficiary-table th, 
		.beneficiary-table td {
		    padding: 14px 18px;
		    text-align: left;
		    border-bottom: 1px solid #f0f0f0;
		}
		
		.beneficiary-table tbody tr:nth-child(even) {
		    background-color: #f4f4fb;
		}
		
		.beneficiary-table tbody tr:hover {
		    background-color: #eef1f8;
		}
		
		.beneficiary-table th:first-child,
		.beneficiary-table td:first-child {
		    border-top-left-radius: 12px;
		}
		
		.beneficiary-table th:last-child,
		.beneficiary-table td:last-child {
		    border-top-right-radius: 12px;
		}

        .action-buttons {
            display: flex;
            gap: 10px;
        }
        
        .action-wrapper {
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    opacity: 0;
		    transition: opacity 0.2s ease;
		}
		
		.beneficiary-table tr:hover .action-wrapper {
		    opacity: 1;
		}
		
		.beneficiary-table td {
		    position: relative;
		}
		
		.icon-button {
		    background: none;
		    border: none;
		    color: #e53935;
		    cursor: pointer;
		    font-size: 16px;
		    padding: 5px;
		    border-radius: 50%;
		    transition: background-color 0.2s ease;
		}
		
		.icon-button:hover {
		    background-color: rgba(229, 57, 53, 0.1);
		}
		
		.beneficiary-table td:last-child {
		    width: 40px;
		}
		
		.action-wrapper {
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    visibility: hidden;
		    opacity: 0;
		    transition: visibility 0.2s ease, opacity 0.2s ease;
		}
		
		.beneficiary-table tr:hover .action-wrapper {
		    visibility: visible;
		    opacity: 1;
		}

        .edit-button {
            background-color: #1976d2;
            color: white;
            border: none;
            padding: 6px 10px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .edit-button:hover {
            background-color: #125ea8;
        }

        .del-button {
            background-color: #e53935;
            color: white;
            border: none;
            padding: 6px 10px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .del-button:hover {
            background-color: #c62828;
        }

        .pagination {
            text-align: center;
            margin-top: 30px;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
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
            background-color: #2e2f60;
        }
        
        .icon-button {
		    background-color: #414485;
		    color: white;
		    border: none;
		    padding: 10px;
		    border-radius: 50%;
		    cursor: pointer;
		    font-size: 16px;
		    transition: background-color 0.2s ease, transform 0.2s ease;
		}
		
		.icon-button:hover {
		    background-color: #2e2f60;
		    transform: scale(1.1);
		}
		
		.del-button {
		    background-color: #e53935;
		}
		
		.del-button:hover {
		    background-color: #c62828;
		}
		
		.add-button {
		    background-color: #414485;
		}
		
		.add-button:hover {
		    background-color: #125ea8;
		}

        #pageIndicator {
            font-weight: bold;
            color: #414485;
            font-size: 15px;
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
        
        <div style="display: flex; justify-content: flex-end; align-items: center; margin-bottom: 10px;">
		    <button class="icon-button add-button" onclick="window.location.href='AddBeneficiary.jsp'" title="Add Beneficiary">
		        <i class="fas fa-plus"></i>
		    </button>
		</div>
        
        <table class="beneficiary-table" id="beneficiaryTable" style="display: none;">
            <thead>
			    <tr>
			        <th>Name</th>
			        <th>Bank</th>
			        <th>Account Number</th>
			        <th>IFSC Code</th>
			        <th> </th>
			    </tr>
			</thead>
            <tbody id="beneficiaryTableBody"></tbody>
        </table>

        <div id="status"></div>

        <div class="pagination">
		    <button onclick="prevPage()" class="icon-button"><i class="fas fa-angle-left"></i></button>
		    <span id="pageIndicator">Page 1</span>
		    <button onclick="nextPage()" class="icon-button"><i class="fas fa-angle-right"></i></button>
		</div>
    </div>
</div>

<jsp:include page="Footer.jsp" />

<script>
    const userId = <%= userId != null ? userId : "null" %>;
    let currentPage = 0;
    const pageSize = 20;

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

            beneficiaries.forEach(function(b) {
                const row = document.createElement("tr");
                row.innerHTML =
                    "<td>" + b.beneficiaryName + "</td>" +
                    "<td>" + b.bankName + "</td>" +
                    "<td>" + b.beneficiaryAccountNumber + "</td>" +
                    "<td>" + b.ifscCode + "</td>" +
                    "<td>" +
                        "<div class='action-wrapper'>" +
                            "<button class='icon-button del-button' onclick='deleteBeneficiary(" + b.beneficiaryId + ")'>" +
                                "<i class='fas fa-trash-alt'></i>" +
                            "</button>" +
                        "</div>" +
                    "</td>";
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
        //if (!confirm("Are you sure you want to delete this beneficiary?")) return;

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
    
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const mainWrapper = document.querySelector('.main-wrapper');

        sidebar.classList.toggle('expanded');

        if (sidebar.classList.contains('expanded')) {
            mainWrapper.style.marginLeft = "220px"; // match expanded width
        } else {
            mainWrapper.style.marginLeft = "70px";  // collapsed width
        }
    }
</script>
</body>
</html>
