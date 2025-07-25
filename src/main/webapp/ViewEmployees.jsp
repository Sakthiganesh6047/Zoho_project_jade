<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.jsp.*" %>
<%
    Long userId = (Long) session.getAttribute("userId");
%>
<html>
<head>
    <title>Employee List - JadeBank</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" />
    <style>
        body {
            opacity: 0;
            transition: opacity 0.5s ease-in;
            font-family: 'Roboto', sans-serif;
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
        	gap: 560px;
        }

        .add-btn {
            background-color: #414485;
            color: white;
            border: none;
            border-radius: 50%;
            font-size: 18px;
            padding: 10px;
            cursor: pointer;
            transition: background 0.3s ease;
            margin-bottom: 20px;
        }

        .add-btn:hover {
            background-color: #2a2d63;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            overflow: hidden;
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

        .edit-button {
		    visibility: hidden;
		    background-color: #414485;
		    color: white;
		    border: none;
		    padding: 6px 10px;
		    border-radius: 6px;
		    cursor: pointer;
		    opacity: 0;
		    transition: visibility 0.2s ease, opacity 0.2s ease;
		}
		
		tr:hover .edit-button {
			opacity: 1;
		    visibility: visible;
		}

        .pagination-controls {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 30px;
            gap: 20px;
        }

        .pagination-controls button {
            background-color: #414485;
            color: white;
            border: none;
            padding: 10px 12px;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .pagination-controls button:hover:not(:disabled) {
            background-color: #2c2f5a;
        }

        .pagination-controls button:disabled {
            background-color: #aaa;
            cursor: not-allowed;
            opacity: 0.6;
        }
        
        button.disabled {
		    background-color: #aaa !important;
		    cursor: not-allowed;
		    opacity: 0.6;
		}
        
        .message {
		    text-align: center;
		    font-weight: bold;
		    color: #d63333;
		    margin: 15px 0;
		    font-size: 15px;
		}
		
		.filter-section {
		    display: flex;
		    gap: 25px;
		    align-items: flex-end;
		    margin-bottom: 25px;
		    background: #ffffff;
		    padding: 15px 20px;
		    border-radius: 10px;
		    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
		    justify-content: center;
		    max-width: fit-content;
		    margin-left: 33%
		}
		
		.filter-group {
		    display: flex;
		    flex-direction: row;
		    align-items: center;
		    gap: 7px;
		}
		
		.filter-group label {
		    font-weight: bold;
		    color: #2e2f60;
		}
		
		.filter-group select {
		    padding: 8px 12px;
		    border: 1px solid #ccc;
		    border-radius: 6px;
		    font-size: 14px;
		    background-color: #fff;
		    outline: none;
		    transition: border-color 0.3s ease;
		}
		
		.filter-group select:focus {
		    border-color: #414485;
		}

        #pageInfo {
            font-weight: bold;
            color: #333;
        }
    </style>
</head>
<body>

<div class="body-wrapper">
    <div class="main-wrapper">
        <div class="page-title-wrapper">
		    <h2 class="page-title">Employee List</h2>
		</div>
		<div class="control-add">
			<div class="filter-section">
			    <div class="filter-group">
			        <label for="branchFilter">Branch:</label>
			        <select id="branchFilter">
			            <option value="">All</option>
			        </select>
			    </div>
			    <div class="filter-group">
			        <label for="roleFilter">Role:</label>
			        <select id="roleFilter">
			            <option value="">All</option>
			            <option value="1">Clerk</option>
			            <option value="2">Manager</option>
			            <option value="3">General Manager</option>
			        </select>
			    </div>
			</div>
			<div>
				<button class="add-btn" onclick="window.location.href='EmployeeSignUp.jsp'" title="Add Employee">
			        <i class="fas fa-plus"></i>
			    </button>
			</div>
		</div>

        <table id="employee-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Branch ID</th>
                    <th>Branch Name</th>
                    <th></th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
		<div id="messageBox" class="message" style="display: none;"></div>
		<div class="pagination-controls">
		    <button id="prevBtn" onclick="previousPage()"><i class="fas fa-angle-left"></i></button>
		    <span id="pageInfo">Page 1</span>
		    <button id="nextBtn" onclick="nextPage()"><i class="fas fa-angle-right"></i></button>
		</div>
    </div>
</div>

<jsp:include page="Footer.jsp" />

<script>
    let currentPage = 0;
    const limit = 10;
    let lastPageReached = false;

    window.addEventListener('DOMContentLoaded', () => {
        document.body.style.opacity = 1;
        loadBranches();

        document.getElementById("branchFilter").addEventListener("change", () => {
            currentPage = 0;
            lastPageReached = false;
            fetchEmployees();
        });

        document.getElementById("roleFilter").addEventListener("change", () => {
            currentPage = 0;
            lastPageReached = false;
            fetchEmployees();
        });

        fetchEmployees();
    });

    function getRoleName(roleId) {
        const roles = {
            1: "Clerk",
            2: "Manager",
            3: "General Manager"
        };
        return roles[roleId] || "Unknown";
    }
    
    function loadBranches() {
        fetch("<%= request.getContextPath() %>/jadebank/branch/list")
            .then(response => response.json())
            .then(data => {
                const branchSelect = document.getElementById("branchFilter");
                branchSelect.innerHTML = '<option value="">All</option>'; // Reset

                data.forEach(branch => {
                    const option = document.createElement("option");
                    option.value = branch.branchId;
                    option.textContent = branch.branchName + " - " + branch.branchDistrict;
                    branchSelect.appendChild(option);
                });
            })
            .catch(err => {
                console.error("Failed to load branches:", err);
            });
    }

    function fetchEmployees() {
        const offset = currentPage * limit;
        const branchId = document.getElementById("branchFilter").value;
        const roleType = document.getElementById("roleFilter").value;

        let url = "<%= request.getContextPath() %>/jadebank/user/employeelist?limit=" + limit + "&offset=" + offset;
        if (branchId) url += "&branchId=" + encodeURIComponent(branchId);
        if (roleType) url += "&roleType=" + encodeURIComponent(roleType);

        fetch(url, {
            method: 'GET',
            headers: {
                'Accept': 'application/json'
            }
        })
        .then(res => {
            if (res.status === 401) {
                window.location.href = "<%= request.getContextPath() %>/Login.jsp?expired=true";
                return; // Stop further processing
            }

            if (!res.ok) {
                return Promise.reject("Fetch error: " + res.status);
            }

            return res.json();
        })
        .then(data => {
            if (!data) return;

            const tbody = document.querySelector("#employee-table tbody");
            tbody.innerHTML = "";

            if (Array.isArray(data) && data.length > 0) {
                lastPageReached = data.length < limit;

                data.forEach(emp => {
                    const row = document.createElement("tr");
                    row.innerHTML =
                        "<td>" + emp.employeeId + "</td>" +
                        "<td>" + (emp.employeeName || "N/A") + "</td>" +
                        "<td>" + (emp.employeeEmail || "N/A") + "</td>" +
                        "<td>" + getRoleName(emp.employeeRole) + "</td>" +
                        "<td>" + (emp.employeeBranch || "N/A") + "</td>" +
                        "<td>" + (emp.employeeBranchName || "N/A") + "</td>" +
                        "<td><button class='edit-button' onclick='editEmployee(" + emp.employeeId + ")'><i class='fas fa-edit'></i></button></td>";
                    tbody.appendChild(row);
                });

            } else {
                if (currentPage > 0) {
                    currentPage--;
                    lastPageReached = true;
                    fetchEmployees();
                } else {
                    const row = document.createElement("tr");
                    row.innerHTML = "<td colspan='7' style='text-align:center;'>No employees found.</td>";
                    tbody.appendChild(row);
                }
            }

            updatePageInfo();
        })
        .catch(err => {
            console.error("Failed to fetch employee list:", err);
        });
    }

    function applyFilters() {
        currentPage = 0;
        lastPageReached = false;
        fetchEmployees();
    }

    function editEmployee(employeeId) {
        window.location.href = "EmployeeSignUp.jsp?userId=" + (employeeId);
    }

    function updatePageInfo() {
        document.getElementById("pageInfo").textContent = `Page ${currentPage + 1}`;

        const prevBtn = document.getElementById("prevBtn");
        const nextBtn = document.getElementById("nextBtn");

        prevBtn.disabled = currentPage === 0;
        nextBtn.disabled = lastPageReached;

        prevBtn.classList.toggle("disabled", prevBtn.disabled);
        nextBtn.classList.toggle("disabled", nextBtn.disabled);
    }

    function previousPage() {
        const messageBox = document.getElementById("messageBox");
        messageBox.style.display = "none";

        if (currentPage > 0) {
            currentPage--;
            lastPageReached = false;
            fetchEmployees();
        } else {
            messageBox.textContent = "You are already on the first page.";
            messageBox.style.display = "block";
            setTimeout(() => messageBox.style.display = "none", 3000);
            updatePageInfo();
        }
    }

    function nextPage() {
        const messageBox = document.getElementById("messageBox");
        messageBox.style.display = "none";

        if (!lastPageReached) {
            currentPage++;
            fetchEmployees();
        } else {
            messageBox.textContent = "You are already on the last page.";
            messageBox.style.display = "block";
            setTimeout(() => messageBox.style.display = "none", 3000);
            updatePageInfo();
        }
    }

    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const mainWrapper = document.querySelector('.main-wrapper');
        sidebar.classList.toggle('expanded');
        mainWrapper.style.marginLeft = sidebar.classList.contains('expanded') ? "220px" : "70px";
    }
</script>


</body>
</html>