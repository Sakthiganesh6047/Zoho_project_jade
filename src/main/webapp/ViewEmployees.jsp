<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Employees - JadeBank</title>
    <style>
        
        body { 
		    margin: 0; 
		    display: flex; 
		    flex-direction: column; 
		    min-height: 100vh;
		    font-family: Arial, sans-serif;
		}
		
		.body-wrapper {
		    display: flex; 
		    flex: 1;
		    min-height: 70vh;
		}
		
		.sidebar-wrapper {
		    width: 70px;
		    color: white;
		}
		
		.content-wrapper {
		    width: calc(100% - 70px);
		    padding: 20px;
		}

        h2 {
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 8px;
            text-align: left;
            border: 1px solid #ccc;
        }

        th {
            background-color: #f0f0f0;
        }

        .pagination-controls {
            margin-top: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
    </style>
</head>
<body>

	<jsp:include page="LoggedInHeader.jsp" />
	
	<div class="body-wrapper">
		
		<div class="sidebar-wrapper">
			<jsp:include page="SideBar.jsp" />
		</div>
	
		<div class="content-wrapper">
			<h2>Employee List</h2>
			
			<div class="pagination-controls">
			    <label for="limit">Rows per page:</label>
			    <select id="limit">
			        <option value="5">5</option>
			        <option value="10" selected>10</option>
			        <option value="20">20</option>
			    </select>
			    <button onclick="previousPage()">Previous</button>
			    <button onclick="nextPage()">Next</button>
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
			            <th>Actions</th>
			        </tr>
			    </thead>
			    <tbody></tbody>
			</table>
		</div>
	</div>
	<jsp:include page="Footer.jsp" />

<script>
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
                            "<td><button onclick=\"editEmployee(" + emp.employeeId + ")\">Edit</button></td>";
                        tbody.appendChild(row);
                    });
                } else {
                    const row = document.createElement("tr");
                    row.innerHTML = "<td colspan='5'>No employees found.</td>";
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

    window.onload = function () {
        const limit = parseInt(document.getElementById("limit").value);
        fetchEmployees(limit, offset);
    };

    document.getElementById("limit").addEventListener("change", () => {
        offset = 0;
        const limit = parseInt(document.getElementById("limit").value);
        fetchEmployees(limit, offset);
    });
</script>

</body>
</html>
