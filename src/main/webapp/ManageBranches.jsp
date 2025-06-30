<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Branch List - JadeBank</title>
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
            min-height: 88vh;
        }

        .main-wrapper {
        	margin-left: 20px;
            padding: 30px;
            flex: 1;
            transition: margin-left 0.3s ease;
        }
        
        .add-buttonwrap{
        	display: flex;
        	margin-left: 80%
        }

        /* Adjust margin when sidebar expands */
        .sidebar.expanded ~ .main-wrapper {
            margin-left: 220px;
        }

		.table-header {
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    margin-bottom: 25px;
		}
		
		.page-title {
		    font-size: 26px;
		    font-weight: 700;
		    color: #2e2f60;
		    background: linear-gradient(to right, #e0e7ff, #f4f4fb);
		    border-left: 6px solid #414485;
		    padding: 10px 20px;
		    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
		    margin-top: 0px;
		}

        .branch-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: #ffffff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            font-size: 15px;
        }

        .branch-table thead {
            background-color: #414485;
            color: white;
            font-weight: bold;
        }

        .branch-table th,
        .branch-table td {
            padding: 14px 18px;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
        }

        .branch-table tbody tr:nth-child(even) {
            background-color: #f4f4fb;
        }

        .branch-table tbody tr:hover {
            background-color: #eef1f8;
        }

        .branch-table td:last-child {
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

        .branch-table tr:hover .action-wrapper {
            visibility: visible;
            opacity: 1;
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

        .edit-button {
            background-color: #414485;
        }

        .edit-button:hover {
            background-color: #125ea8;
        }

        .add-button {
            background-color: #414485;
        }

        .add-button:hover {
            background-color: #373962;
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
        
        .pagination button:disabled {
		    cursor: not-allowed;
		    background-color: #aaa;
		    color: #eee;
		    opacity: 0.6;
		    transform: none;
		}
		
    </style>
</head>
<body>

<div class="body-wrapper">

    <!-- Main Content -->
    <div class="main-wrapper">
		<div class="table-header">
		    <h2 class="page-title">Branches</h2>
		    <button class="icon-button add-button" onclick="window.location.href='AddNewBranch.jsp'" title="Add Branch">
		        <i class="fas fa-plus"></i>
		    </button>
		</div>
        <table class="branch-table" id="branch-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>District</th>
                    <th>IFSC Code</th>
                    <th></th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
        <div class="pagination">
            <button onclick="previousPage()" class="icon-button"><i class="fas fa-angle-left"></i></button>
            <span id="pageIndicator">Page 1</span>
            <button onclick="nextPage()" class="icon-button"><i class="fas fa-angle-right"></i></button>
        </div>
    </div>
</div>
<jsp:include page="Footer.jsp" />

<script>
    let offset = 0;
    let currentPage = 1;
    const limit = 10;
    let hasNextPage = false;

    function fetchBranches() {
        fetch("${pageContext.request.contextPath}/jadebank/branch/all?limit=" + limit + "&offset=" + offset)
            .then(res => res.json())
            .then(data => {
                const tbody = document.querySelector("#branch-table tbody");
                tbody.innerHTML = "";

                if (Array.isArray(data) && data.length > 0) {
                    data.forEach(function(branch) {
                        const row = document.createElement("tr");
                        row.innerHTML =
                            "<td>" + branch.branchId + "</td>" +
                            "<td>" + branch.branchName + "</td>" +
                            "<td>" + branch.branchDistrict + "</td>" +
                            "<td>" + branch.ifscCode + "</td>" +
                            "<td><div class='action-wrapper'><button class='icon-button edit-button' onclick='editBranch(" + branch.branchId + ")'><i class='fas fa-edit'></i></button></div></td>";
                        tbody.appendChild(row);
                    });
                } else {
                    const row = document.createElement("tr");
                    row.innerHTML = "<td colspan='5' style='text-align: center;'>No branches found.</td>";
                    tbody.appendChild(row);
                }
                document.getElementById("pageIndicator").textContent = "Page " + currentPage;
                hasNextPage = data.length === limit;
                updatePaginationButtons();
            })
            .catch(error => {
                console.error("Error:", error);
            });
    }

    function nextPage() {
        offset += limit;
        currentPage++;
        fetchBranches();
    }

    function previousPage() {
        if (offset > 0) {
            offset -= limit;
            currentPage--;
            fetchBranches();
        }
    }
    
    function updatePaginationButtons() {
        document.querySelector(".pagination button:nth-child(1)").disabled = offset === 0;
        document.querySelector(".pagination button:nth-child(3)").disabled = !hasNextPage;
    }

    function editBranch(branchId) {
        window.location.href = "AddNewBranch.jsp?branchId=" + encodeURIComponent(branchId);
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

    window.onload = fetchBranches;
</script>
</body>
</html>
