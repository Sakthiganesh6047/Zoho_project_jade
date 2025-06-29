<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>
<%
    Integer role = (Integer) session.getAttribute("role");
    Long userId = (Long) session.getAttribute("userId");
    if (role == null || (role != 2 && role != 3) || userId == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manager Dashboard - JadeBank</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", sans-serif;
            background-image: url("contents/background.png"); /* Replace with your actual path */
		    background-size: cover;        /* Scales the image to cover the whole screen */
		    background-repeat: no-repeat;  /* Prevents tiling */
		    background-position: center;
            padding-top: 70px; /* same as header height */
        }

        .body-wrapper {
            display: flex;
            min-height: 100vh;
        }

        .content-wrapper {
            flex-grow: 1;
            margin-left: 20px;
            padding: 20px 30px;
            display: flex;
            gap: 30px;
        }

        .stats-panel {
            flex-grow: 1;
        }

        .operations-panel {
            width: 250px;
            display: flex;
            flex-direction: column;
            gap: 20px;
            order: 2;
        }
        
        .stat-section {
        	display: flex;
        	gap: 30px;
        }
        
        .stat-cards {
        	background: white;
		    padding: 20px;
		    padding-right: 115px;
		    padding-left:115px;
		    border-radius: 12px;
		    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
		    margin-bottom: 20px;
        }
        
        .stat-cards h3 {
		    margin-bottom: 15px;
		}
		
		.info-cards-grid {
		    display: flex;
		    gap: 20px;
		    flex-wrap: wrap;
		}
		
		.info-card {
		    display: flex;
		    align-items: center;
		    gap: 20px;
		    background-color: #ffffff;
		    padding: 20px;
		    border-radius: 12px;
		    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
		    min-width: 180px;
		    min-height: 120px;
		    flex: 1;
		}
		
		.info-card i {
		    font-size: 32px;
		    color: #414485;
		}
		
		.info-text {
		    display: flex;
		    flex-direction: column;
		    justify-content: center;
		}
		
		.info-text h4 {
		    margin: 0;
		    font-size: 17px;
		    color: #333;
		}
		
		.info-text p {
		    margin: 4px 0 0;
		    font-size: 18px;
		    font-weight: bold;
		    color: #414485;
		}

        .dashboard-card {
            background: white;
            padding: 30px 20px;
            border-radius: 12px;
            text-align: center;
            text-decoration: none;
            color: #373962;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: 0.3s;
            min-height: 120px;
        }

        .dashboard-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.15);
        }

        .dashboard-card i {
            font-size: 24px;
            color: #414485;
            margin-bottom: 10px;
        }

        .dashboard-card h4 {
            margin: 5px 0;
            font-size: 17px;
        }

        .dashboard-card p {
            font-size: 13px;
            color: #666;
        }

        .profile-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
            padding: 20px;
            background: linear-gradient(135deg, #414485, #5c6bc0);
            color: white;
            border-radius: 12px;
        }

        .profile-header .info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .profile-header img {
            width: 60px;
            height: 60px;
            border-radius: 50%;
        }

        .profile-header .name-role {
            display: flex;
            flex-direction: column;
        }

        .profile-header .name-role h2 {
            margin: 0;
            font-size: 20px;
        }

        .profile-header .name-role p {
            margin: 0;
            font-size: 13px;
            color: #e0e0e0;
        }

        .edit-icon {
            font-size: 22px;
            color: white;
            cursor: pointer;
        }

        .chart-section {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .chart-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 30px;
        }

        .info-cards {
            display: flex;
            flex-direction: column;
            gap: 10px;
            width: 100%;
        }

        .info-card {
            background-color: white;
            padding: 16px 20px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: bold;
            color: #373962;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .branch-item {
		    display: flex;
		    justify-content: space-between;
		    padding: 12px 20px;
		    background-color: #fff;
		    border-radius: 8px;
		    box-shadow: 0 2px 6px rgba(0,0,0,0.08);
		    margin-bottom: 10px;
		    font-size: 15px;
		    font-weight: 500;
		    color: #414485;
		}
		
		.branch-name {
		    flex: 1;
		    white-space: nowrap;
		    overflow: hidden;
		    text-overflow: ellipsis;
		}
		
		.branch-count {
		    color: #333;
		    font-weight: bold;
		}

        .branch-list-section {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

    </style>
</head>
<body>
<div class="body-wrapper">
    <div class="content-wrapper">
        <div class="stats-panel">
            <div class="profile-header">
                <div class="info">
                    <img id="profilePic" src="contents/man_6997551.png" alt="Profile Pic">
                    <div class="name-role">
                        <h2 id="userName">Loading...</h2>
                        <p id="userEmail">Email: -</p>
                        <p id="userPhone">Phone: -</p>
                    </div>
                </div>
                <i class="fas fa-pen-to-square edit-icon" onclick="redirectToEditProfile()"></i>
            </div>

			<div class="stat-section">
	            <div class="chart-section">
	                <h3>Employee Role Distribution</h3>
	                <div class="chart-container">
	                    <div style="width: 200px; height: 200px;">
	                        <canvas id="employeePieChart" width="180" height="180"></canvas>
	                    </div>
	                </div>
	            </div>
	            
	            <div class="stat-cards">
			        <h3>Stats</h3>
			        <div class="info-cards-grid">
			            <div class="info-card">
			                <i class="fas fa-code-branch"></i>
			                <div>
			                    <h4>Branches</h4>
			                    <p>12</p>
			                </div>
			            </div>
			            <div class="info-card">
			                <i class="fas fa-users"></i>
			                <div>
			                    <h4>Employees</h4>
			                    <p>100</p>
			                </div>
			            </div>
			            <div class="info-card">
			                <i class="fas fa-user-circle"></i>
			                <div>
			                    <h4>Customers</h4>
			                    <p>800</p>
			                </div>
			            </div>
			            <div class="info-card">
			                <i class="fas fa-user-circle"></i>
			                <div>
			                    <h4>Accounts</h4>
			                    <p>8000</p>
			                </div>
			            </div>
			        </div>
			    </div>
			</div>
			
            <div class="chart-section">
                <h3>Daily Transactions</h3>
                <canvas id="transactionBarChart" width="400" height="120"></canvas>
            </div>
        </div>

        <div class="operations-panel">
            <a href="EmployeeSignUp.jsp" class="dashboard-card">
                <i class="fas fa-user-plus"></i>
                <h4>Add Employee</h4>
                <p>Register new staff</p>
            </a>
            <a href="CustomerSignUp.jsp" class="dashboard-card">
                <i class="fa-solid fa-user-plus"></i>
                <h4>Add Customer</h4>
                <p>Create User Account</p>
            </a>
            <a href="OpenAccount.jsp" class="dashboard-card">
                <i class="fa-solid fa-file-invoice-dollar"></i>
                <h4>New Bank Account</h4>
                <p>Create Bank Account</p>
            </a>
            <a href="ViewEmployees.jsp" class="dashboard-card">
                <i class="fas fa-users"></i>
                <h4>Employees</h4>
                <p>Clerks, Managers</p>
            </a>
        </div>
    </div>
</div>
<script>
const userId = <%= userId %>;

// 1. Load Admin Profile
fetch(`${pageContext.request.contextPath}/jadebank/user/profile`)
    .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch user"))
    .then(data => {
        document.getElementById("userName").textContent = data.fullName || "Unknown";
        document.getElementById("userEmail").textContent = "Email: " + (data.email || "N/A");
        document.getElementById("userPhone").textContent = "Phone: " + (data.phone || "N/A");
        document.getElementById("profilePic").src = data.gender?.toLowerCase() === "female"
            ? "contents/woman_6997664.png"
            : "contents/man_6997551.png";
    })
    .catch(err => console.error("Profile fetch error:", err));

function redirectToEditProfile() {
    window.location.href = `AdminSignUp.jsp?userId=${userId}`;
}

// 2. Load Employee Role Distribution
fetch(`${pageContext.request.contextPath}/jadebank/user/employeecount`)
    .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch role data"))
    .then(data => {
        const roleCounts = {
            clerks: data["1"] || 0,
            managers: data["2"] || 0,
            gms: data["3"] || 0
        };

        new Chart(document.getElementById('employeePieChart').getContext('2d'), {
            type: 'pie',
            data: {
                labels: ['Clerks', 'Managers', 'GMs'],
                datasets: [{
                    data: [roleCounts.clerks, roleCounts.managers, roleCounts.gms],
                    backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc']
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: 'right' } }
            }
        });
    })
    .catch(err => console.error("Pie chart fetch error:", err));


// 3. Load Summary Stats
fetch(`${pageContext.request.contextPath}/jadebank/user/dashboardstats`)
    .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch summary stats"))
    .then(data => {
        const stats = {
            branches: data.branchCount ?? 0,
            employees: data.employeeCount ?? 0,
            customers: data.userCount ?? 0,
            accounts: data.accountCount ?? 0
        };
        const statTexts = document.querySelectorAll(".info-cards-grid .info-card p");
        statTexts[0].textContent = stats.branches;
        statTexts[1].textContent = stats.employees;
        statTexts[2].textContent = stats.customers;
        statTexts[3].textContent = stats.accounts;
    })
    .catch(err => console.error("Stats fetch error:", err));

// 4. Load Daily Transactions (Line Chart)
fetch(`${pageContext.request.contextPath}/jadebank/account/transactionchart`)
    .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch transactions chart"))
    .then(data => {
        const labels = Object.keys(data);
        const counts = Object.values(data);

        const ctx = document.getElementById('transactionBarChart').getContext('2d');
        const lineChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Transactions',
                    data: counts,
                    backgroundColor: 'rgba(65, 68, 133, 0.2)',
                    borderColor: '#414485',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });
    })
    .catch(err => console.error("Transaction chart error:", err));

//3. Load Accounts per Branch
fetch(`${pageContext.request.contextPath}/jadebank/branch/accountstats`)
    .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch branch accounts"))
    .then(data => {
        const container = document.getElementById("branchAccountList");
        container.innerHTML = ""; // Clear any existing content

        Object.entries(data).forEach(([branch, count]) => {
            const row = document.createElement("div");
            row.className = "branch-item";
            row.innerHTML = 
                '<span class="branch-name">' + branch + '</span>' +
                '<span class="branch-count">' + count + ' Accounts</span>';
            container.appendChild(row);
        });
    })
    .catch(err => console.error("Branch account fetch error:", err));

</script>

</body>
</html>
