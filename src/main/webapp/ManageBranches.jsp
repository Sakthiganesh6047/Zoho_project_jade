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
		    padding: 20px;
		}
		
		table { 
		    border-collapse: collapse; 
		    width: 100%; 
		    margin-top: 20px; 
		}
		
		th, td { 
		    border: 1px solid #ddd; 
		    padding: 8px; 
		    text-align: left; 
		}
		
		th { 
		    background-color: #f2f2f2; 
		}
		
		.pagination-controls { 
		    margin-top: 20px; 
		    display: flex; 
		    gap: 10px; 
		    align-items: center; 
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
                console.log("Fetched branches:", data);
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
                	        "<td><button onclick=\"editBranch(" + branch.branchId + ")\">Edit</button></td>";
                	    tbody.appendChild(row);
                	});
                } else {
                    const row = document.createElement("tr");
                    row.innerHTML = "<td colspan='4'>No branches found.</td>";
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
            return value; // for numbers or valid non-null objects
        }
        return fallback;
    }
    
    function editBranch(branchId) {
        // Option 1: Redirect to an edit page
        window.location.href = "AddNewBranch.jsp?branchId=" + encodeURIComponent(branchId);

        // Option 2: (if using modal or inline form)
        // fetch(`/jadebank/branch/id?branchId=${branchId}`)
        //     .then(res => res.json())
        //     .then(data => {
        //         // Populate form fields here
        //     });
    }


    document.getElementById("limit").addEventListener("change", () => {
        const limit = parseInt(document.getElementById("limit").value);
        offset = 0;
        fetchBranches(limit, offset);
    });
</script>


</body>
</html>
