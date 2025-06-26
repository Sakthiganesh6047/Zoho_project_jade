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
    <title>View Employees - JadeBank</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" />
    <style>
        body {
			opacity: 0;
			transition: opacity 0.5 ease-in;
            font-family: 'Segoe UI', sans-serif;
            background-image: url("contents/background.png"); /* Replace with your actual path */
		    background-size: cover;        /* Scales the image to cover the whole screen */
		    background-repeat: no-repeat;  /* Prevents tiling */
		    background-position: center;
            margin: 0;
            padding-top: 70px;
        }

        .body-wrapper {
            display: flex;
            min-height: 100vh;
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
            color: #373962;
            font-size: 24px;
            margin-bottom: 20px;
        }
        
        .list-header{
        	display: flex;
        	justify-content: space-between;
		    align-items: center;
		    margin-left: 45%;
		    margin-right: 2%;
        }
        
        .add-buttonwrap{
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
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
            display: none;
            background-color: #414485;
            color: white;
            border: none;
            padding: 6px 10px;
            border-radius: 6px;
            cursor: pointer;
        }

        tr:hover .edit-button {
            display: inline-block;
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
            padding: 10px;
            border-radius: 50%;
            font-size: 16px;
            cursor: pointer;
        }

        .pagination-controls button:hover {
            background-color: #2c2f5a;
        }

        .limit-container {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .limit-container label {
            font-weight: bold;
        }

        .limit-container select {
            padding: 6px 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        .add-btn {
            background-color: #414485;
            color: white;
            border: none;
            border-radius: 50%;
            font-size: 20px;
            padding: 6px 8px;
            cursor: pointer;
        }
    </style>
</head>
<body>

<div class="body-wrapper">

    <div class="main-wrapper">
    	<div class="list-header">
	        <h2>Employees</h2>
			<div class="add-buttonwrap">
		        <button class="add-btn" onclick="window.location.href='EmployeeSignUp.jsp'">
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
                    <th>Branch Id</th>
                    <th>Branch Name</th>
                    <th> </th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>

        <div class="pagination-controls">
            <button onclick="previousPage()"><i class="fas fa-angle-left"></i></button>
            <span id="pageInfo">Page 1</span>
            <button onclick="nextPage()"><i class="fas fa-angle-right"></i></button>

            <div class="limit-container">
                <label for="limit">Rows:</label>
                <select id="limit">
                    <option value="5">5</option>
                    <option value="10" selected>10</option>
                    <option value="20">20</option>
                </select>
            </div>
        </div>
    </div>
</div>

<jsp:include page="Footer.jsp" />

<script>

window.addEventListener('DOMContentLoaded', () => {
    document.body.style.opacity = 1;
});

    let offset = 0;

    function getRoleName(roleId) {
        const roles = {
            1: "Clerk",
            2: "Manager",
            3: "General Manager"
        };
        return roles[roleId] || "Unknown";
    }

    function fetchEmployees(limit = 10, offset = 0) {
        fetch("<%= request.getContextPath() %>/jadebank/user/employeelist?limit=" + limit + "&offset=" + offset)
            .then(response => response.json())
            .then(data => {
                const tbody = document.querySelector("#employee-table tbody");
                tbody.innerHTML = "";

                if (Array.isArray(data) && data.length > 0) {
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
                    const row = document.createElement("tr");
                    row.innerHTML = "<td colspan='7' style='text-align:center;'>No employees found.</td>";
                    tbody.appendChild(row);
                }
            })
            .catch(err => {
                console.error("Failed to fetch employee list:", err);
                alert("Error loading employee list.");
            });
    }

    function editEmployee(employeeId) {
        window.location.href = "EmployeeSignUp.jsp?employeeId=" + encodeURIComponent(employeeId);
    }

    function previousPage() {
        const limit = parseInt(document.getElementById("limit").value);
        offset = Math.max(0, offset - limit);
        fetchEmployees(limit, offset);
    }

    function nextPage() {
        const limit = parseInt(document.getElementById("limit").value);
        offset += limit;
        fetchEmployees(limit, offset);
    }

    document.getElementById("limit").addEventListener("change", () => {
        offset = 0;
        const limit = parseInt(document.getElementById("limit").value);
        fetchEmployees(limit, offset);
    });

    window.onload = function () {
        const limit = parseInt(document.getElementById("limit").value);
        fetchEmployees(limit, offset);
    };
    
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
