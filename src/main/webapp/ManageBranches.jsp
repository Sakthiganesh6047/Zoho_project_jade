<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Branch List - JadeBank</title>
    <style>
        body { 
		    margin: 0; 
		    display: flex; 
		    flex-direction: column; 
		    min-height: 100vh;
		    font-family: 'Segoe UI', sans-serif;
		    background-color: #f4f6f8;
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
		
		.list-wrapper {
		    width: calc(100% - 70px);
		    padding: 30px;
		}
		
		h2 {
		    color: #373962;
		    font-size: 24px;
		    margin-bottom: 20px;
		}
		
		table { 
		    border-collapse: collapse; 
		    width: 100%; 
		    margin-top: 20px; 
		    background-color: white;
		    border-radius: 8px;
		    overflow: hidden;
		    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
		}
		
		th, td { 
		    padding: 14px; 
		    text-align: left; 
		    border-bottom: 1px solid #ddd;
		    font-size: 14px;
		}
		
		th { 
		    background-color: #eaeaf1; 
		    font-weight: 600;
		    color: #414485;
		}

		td:last-child {
		    text-align: center;
		}

		.edit-button {
		    background-color: #414485;
		    color: white;
		    border: none;
		    padding: 6px 12px;
		    border-radius: 6px;
		    font-size: 14px;
		    cursor: pointer;
		    transition: background 0.3s ease;
		}

		.edit-button:hover {
		    background-color: #2c2f5a;
		}
		
		.pagination-controls { 
		    margin-top: 20px; 
		    display: flex; 
		    gap: 10px; 
		    align-items: center; 
		    font-size: 14px;
		}
		
		.pagination-controls label {
		    font-weight: bold;
		}
		
		.pagination-controls select {
		    padding: 6px 10px;
		    border-radius: 6px;
		    border: 1px solid #ccc;
		}
		
		.pagination-controls button {
		    background-color: #414485;
		    color: white;
		    border: none;
		    padding: 8px 16px;
		    border-radius: 6px;
		    cursor: pointer;
		    font-weight: bold;
		    transition: background 0.3s ease;
		}
		
		.pagination-controls button:hover {
		    background-color: #2c2f5a;
		}
    </style>
</head>
<body>
	<jsp:include page="LoggedInHeader.jsp" />
	<div class="body-wrapper">
	
		<div class="sidebar-wrapper">
			<jsp:include page="SideBar.jsp" />
		</div>
		
		<div class="list-wrapper">
			<h2>Branch List</h2>
			
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
			
			<table id="branch-table">
			    <thead>
			        <tr>
			            <th>ID</th>
			            <th>Name</th>
			            <th>District</th>
			            <th>IFSC Code</th>
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

    function fetchBranches(limit = 10, offset = 0) {
        fetch('${pageContext.request.contextPath}/jadebank/branch/all?limit=' + limit + '&offset=' + offset)
            .then(response => response.json())
            .then(data => {
                const tbody = document.querySelector("#branch-table tbody");
                tbody.innerHTML = "";

                if (Array.isArray(data) && data.length > 0) {
                	data.forEach(branch => {
                	    const row = document.createElement("tr");
                	    row.innerHTML =
                	        "<td>" + displayOrFallback(branch.branchId, "-") + "</td>" +
                	        "<td>" + displayOrFallback(branch.branchName, "Unnamed") + "</td>" +
                	        "<td>" + displayOrFallback(branch.branchDistrict, "Unknown") + "</td>" +
                	        "<td>" + displayOrFallback(branch.ifscCode, "-") + "</td>" +
                	        "<td><button class='edit-button' onclick='editBranch(" + branch.branchId + ")'>Edit</button></td>";
                	    tbody.appendChild(row);
                	});
                } else {
                    const row = document.createElement("tr");
                    row.innerHTML = "<td colspan='5' style='text-align: center;'>No branches found.</td>";
                    tbody.appendChild(row);
                }
            })
            .catch(error => {
                console.error("Error fetching branches:", error);
                alert("Failed to load branches.");
            });
    }

    window.onload = function () {
        const limit = parseInt(document.getElementById("limit").value);
        fetchBranches(limit, offset);
    };

    function previousPage() {
        const limit = parseInt(document.getElementById("limit").value);
        offset = Math.max(0, offset - limit);
        fetchBranches(limit, offset);
    }

    function nextPage() {
        const limit = parseInt(document.getElementById("limit").value);
        offset += limit;
        fetchBranches(limit, offset);
    }
    
    function displayOrFallback(value, fallback) {
        if (typeof value === "string") {
            return value.trim() !== "" ? value : fallback;
        } else if (value !== null && value !== undefined) {
            return value;
        }
        return fallback;
    }
    
    function editBranch(branchId) {
        window.location.href = "AddNewBranch.jsp?branchId=" + encodeURIComponent(branchId);
    }

    document.getElementById("limit").addEventListener("change", () => {
        const limit = parseInt(document.getElementById("limit").value);
        offset = 0;
        fetchBranches(limit, offset);
    });
</script>

</body>
</html>

