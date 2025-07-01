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
    <title>Admin Dashboard - JadeBank</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
    
    	html, body {
            margin: 0;
            padding: 0;
            overflow-x: hidden;
            max-width: 100vw;
            box-sizing: border-box;
            font-family: "Segoe UI", sans-serif;
        }

        *, *::before, *::after {
            box-sizing: inherit;
        }

        body {
            background-image: url("contents/background.png");
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            padding-top: 70px;
        }

        .body-wrapper {
            display: flex;
            transition: margin-left 0.3s ease;
            min-height: 85vh;
            width: 100%;
            margin-left: 20px;
        }

        body.expanded .body-wrapper {
            margin-left: 223px;
        }

        .content-wrapper {
            flex-grow: 1;
            margin-left: 5px;
            padding: 20px;
            padding-bottom: 2px;
            display: flex;
            gap: 20px;
            flex-wrap: wrap;           /* ✅ wrap instead of overflow */
            width: 100%;
            max-width: 100%;
        }

        .stats-panel {
            flex: 1 1 0;
            min-width: 300px;
             max-width: 1500px;
        }

        .operations-panel {
            flex: 0 0 250px;
            display: flex;
            flex-direction: column;
            gap: 20px;
            order: 2;
            margin-right: 20px;
        }

        .stat-section {
            display: flex;
            flex-wrap: nowrap;          /* ✅ allow wrapping */
            gap: 20px;
        }

        .chart-container {
            flex-wrap: wrap;
            gap: 20px;
        }

        .info-cards-grid {
            display: flex;
            flex-wrap: wrap;         /* ✅ wrap to fit */
            gap: 20px;
        }

        .chart-section, .stat-cards, .branch-list-section {
            max-width: 100%;         /* ✅ restrict width */
            overflow-x: auto;
        }

        canvas {
            max-width: 100%;
            height: auto;
        }
        
        .stat-cards {
        	background: white;
		    padding: 20px;
		    border-radius: 12px;
		    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
		    margin-bottom: 20px;
		    width: 100%
        }
        
        .stat-cards h3 {
		    margin-bottom: 15px;
		}
		
		.info-cards-grid {
		    display: flex;
		    gap: 37px;
		    flex-wrap: wrap;
		}
		
		.info-card {
		    display: flex;
		    flex-direction: column;
		    align-items: center;
		    justify-content: center;
		    gap: 10px;
		    background-color: #ffffff;
		    padding: 20px;
		    border-radius: 12px;
		    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
		    min-width: 180px;
		    min-height: 140px;
		    flex: 1;
		    text-decoration: none;
		    color: inherit;
		    transition: transform 0.2s ease;
		    cursor: pointer;
		}
		
		.info-card:hover {
		    transform: scale(1.03);
		    box-shadow: 0 6px 14px rgba(0,0,0,0.15);
		}
		
		.info-card h4 {
		    font-size: 18px;
		    font-weight: 600;
		    color: #373962;
		    margin: 0;
		}
		
		.info-card i {
		    font-size: 28px;
		    color: #414485;
		}
		
		.info-card p {
		    font-size: 24px;
		    font-weight: bold;
		    color: #414485;
		    margin: 0;
		}
		
		.infocard-logo {
			display: flex;
			gap: 15px;
			justify-content: center;
		}

        .dashboard-card {
            background: white;
            padding: 33px 20px;
            border-radius: 12px;
            text-align: center;
            text-decoration: none;
            color: #373962;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: 0.3s;
            min-height: 120px;
            border-block: 1px solid #373962;
            border-left: 1px solid #373962;
    		border-right: 1px solid #373962;
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
            max-height: 280px; /* LIMIT HEIGHT HERE */
        }
        
        .chart-section canvas {
		    max-height: 200px; /* Chart will stay within bounds */
		    width: 100% !important;
		    height: auto !important;
		}

        .chart-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 30px;
        }
        
        .scroll-container {
		    overflow-x: auto;
		    overflow-y: hidden;
		    width: 100%;
		}
		
		.scroll-container canvas {
		    min-width: 1000px; /* Enough to show 10 branches clearly */
		    height: 400px !important; /* Double height */
		    max-height: 400px;
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
            font-size: 20px;
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
        .donut-chart-section {
		    max-width: 400px;
		    overflow: hidden; /* Important: hides any overflow */
		    display: flex;
		    flex-direction: column;
		    justify-content: center;
		}
		
		.donut-wrapper {
		    width: 300px;
		    height: 300px;
		    position: relative;
		    margin-left: 30px;
		    margin-right: 130px;
		}
		
		#employeePieChart {
		    width: 100% !important;
		    height: 100% !important;
		    display: block;
		}

    </style>
</head>
<body>
<div class="body-wrapper" id="bodyWrapper">
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
				<div class="chart-section donut-chart-section">
				    <h3>Employee Role Distribution</h3>
				    <div class="donut-wrapper">
				        <canvas id="employeePieChart"></canvas>
				    </div>
				</div>
	            <div class="stat-cards">
				    <h3>Stats</h3>
				    <div class="info-cards-grid">
					    <div class="info-card" onclick="parent.loadPage('ManageBranches.jsp')">
					        <h4>Branches</h4>
					        <div class="infocard-logo">
						        <i class="fa-solid fa-building-columns"></i>
						        <p id="statBranches">0</p>
					        </div>
					    </div>
					    <div class="info-card" onclick="parent.loadPage('ViewEmployees.jsp')">
					        <h4>Employees</h4>
					        <div class="infocard-logo">
						        <i class="fas fa-user-tie"></i>
						        <p id="statEmployees">0</p>
						    </div>
					    </div>
					    <div class="info-card" onclick="parent.loadPage('SearchCustomer.jsp')">
					        <h4>Customers</h4>
					        <div class="infocard-logo">
						        <i class="fas fa-user-circle"></i>
						        <p id="statCustomers">0</p>
							</div>
					    </div>
					    <div class="info-card" onclick="parent.loadPage('AccountsList.jsp')">
					        <h4>Accounts</h4>
					        <div class="infocard-logo">
						        <i class="fa-solid fa-file-invoice-dollar"></i>
						        <p id="statAccounts">0</p>
							</div>
					    </div>
					</div>
				</div>
			</div>
		<div class="chart-section" style="max-height: 500px;">
		    <h3>Accounts Per Branch</h3>
		    <div class="scroll-container">
		        <canvas id="transactionBarChart"></canvas>
		    </div>
		</div>
        </div>

        <div class="operations-panel">
            <a href="AddNewBranch.jsp" class="dashboard-card">
                <i class="fa-solid fa-building-columns"></i>
                <h4>Add Branch</h4>
                <p>New Jade Branch</p>
            </a>
            <a href="EmployeeSignUp.jsp" class="dashboard-card">
                <i class="fas fa-user-tie"></i>
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
                <h4>Add Account</h4>
                <p>Create Bank Account</p>
            </a>
            <a href="ViewEmployees.jsp" class="dashboard-card">
                <i class="fas fa-users"></i>
                <h4>View Employees</h4>
                <p>Employee records</p>
            </a>
        </div>
    </div>
</div>
<jsp:include page="Footer.jsp" />

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
    parent.loadPage("EmployeeSignUp.jsp?userId=" + userId);
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
            type: 'doughnut',
            data: {
                labels: ['Clerks', 'Managers', 'GMs'],
                datasets: [{
                    data: [roleCounts.clerks, roleCounts.managers, roleCounts.gms],
                    backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc']
                }]
            },
            options: {
                responsive: true,
                cutout: '50%', // Donut hole
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right'
                    }
                }
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
        document.getElementById("statBranches").textContent = stats.branches;
        document.getElementById("statEmployees").textContent = stats.employees;
        document.getElementById("statCustomers").textContent = stats.customers;
        document.getElementById("statAccounts").textContent = stats.accounts;
    })
    .catch(err => console.error("Stats fetch error:", err));

//3. Load Accounts per Branch
fetch(`${pageContext.request.contextPath}/jadebank/branch/accountstats`)
    .then(res => res.json())
    .then(data => {
        const labels = Object.keys(data); // Branch names or codes
        const counts = Object.values(data); // Account counts

        new Chart(document.getElementById('transactionBarChart').getContext('2d'), {
            type: 'line',
            data: {
                labels,
                datasets: [{
                    label: 'No. of Accounts',
                    data: counts,
                    borderColor: '#414485',
                    backgroundColor: 'rgba(65, 68, 133, 0.1)',
                    tension: 0.1,
                    fill: true,
                    pointBackgroundColor: '#414485',
                    pointRadius: 5,
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true
                    }
                },
                scales: {
                    x: {
                        title: {
                            display: true,
                            text: 'Branch'
                        },
                        ticks: {
                            maxRotation: 30,
                            autoSkip: false
                        }
                    },
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Account Count'
                        }
                    }
                }
            }
        });
    });

</script>

</body>
</html>