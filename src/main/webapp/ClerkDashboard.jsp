<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>
<%
    Integer role = (Integer) session.getAttribute("role");
    Long userId = (Long) session.getAttribute("userId");
    if (role == null || role == 4 || userId == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JadeBank Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            margin: 0;
            background-color: #f4f6f8;
        }
        .dashboard-wrapper {
            max-width: 1200px;
            margin: auto;
            padding: 20px;
        }
        .section-wrapper {
            margin-top: 40px;
        }
        .section-title {
            font-size: 20px;
            color: #414485;
            margin-bottom: 10px;
            border-left: 5px solid #414485;
            padding-left: 10px;
        }
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        .dashboard-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            text-align: center;
            text-decoration: none;
            color: #373962;
            transition: 0.3s;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        }
        .dashboard-card i {
            font-size: 30px;
            margin-bottom: 10px;
            color: #414485;
        }
        .dashboard-card h4 {
            margin: 10px 0 5px;
        }
        .dashboard-card p {
            font-size: 14px;
            color: #666;
        }
        .profile-banner {
            display: flex;
            align-items: center;
            background: linear-gradient(135deg, #414485, #5c6bc0);
            color: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            justify-content: space-between;
        }
        .profile-info {
            display: flex;
            align-items: center;
        }
        .profile-banner img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin-right: 20px;
        }
        .profile-banner h2 {
            margin: 0;
            font-size: 24px;
        }
        .profile-banner p {
            margin: 4px 0 0;
            font-size: 14px;
        }
        .editbutton-wrapper {
            display: flex;
        }
        .edit-icon {
            margin-left: 10px;
            font-size: 30px;
            color: white;
            cursor: pointer;
            transition: color 0.3s ease;
        }
        .edit-icon:hover {
            color: #007bff;
        }
    </style>
</head>
<body>
<jsp:include page="LoggedInHeader.jsp" />
<div class="dashboard-wrapper">
    <div class="profile-banner">
        <div class="profile-info">
            <img id="profilePic" src="contents/man_6997551.png" alt="Profile Pic">
            <div>
                <h2 id="userName">Loading...</h2>
                <p id="userEmail">Email: -</p>
                <p id="userPhone">Phone: -</p>
            </div>
        </div>
        <div class="editbutton-wrapper">
            <i class="fas fa-pen-to-square edit-icon" title="Edit Profile" onclick="redirectToEditProfile()"></i>
        </div>
    </div>

    <% if (role == 0) { %>
    <div class="section-wrapper">
        <div class="section-title">Account Services</div>
        <div class="cards-grid">
            <a href="Balance.jsp" class="dashboard-card">
                <i class="fas fa-wallet"></i>
                <h4>Balance</h4>
                <p>Check your accounts</p>
            </a>
            <a href="CustomerAccTransactions.jsp" class="dashboard-card">
                <i class="fas fa-clock-rotate-left"></i>
                <h4>Transactions</h4>
                <p>Review history</p>
            </a>
        </div>
    </div>
    <div class="section-wrapper">
        <div class="section-title">Transfers</div>
        <div class="cards-grid">
            <a href="CustomerTransfer.jsp" class="dashboard-card">
                <i class="fas fa-exchange-alt"></i>
                <h4>Transfer</h4>
                <p>Send money</p>
            </a>
            <a href="QuickTransfer.jsp" class="dashboard-card">
                <i class="fas fa-bolt"></i>
                <h4>Quick Transfer</h4>
                <p>Instant transfer</p>
            </a>
            <a href="AddBeneficiary.jsp" class="dashboard-card">
                <i class="fas fa-user-plus"></i>
                <h4>Add Beneficiary</h4>
                <p>Trusted contacts</p>
            </a>
            <a href="BeneficiaryList.jsp" class="dashboard-card">
                <i class="fa-regular fa-address-book"></i>
                <h4>Manage Beneficiaries</h4>
                <p>View & Edit</p>
            </a>
        </div>
    </div>
    <% } else if (role == 1 || role == 2 || role == 3) { %>
    <div class="section-wrapper">
        <div class="section-title">Staff Operations</div>
        <div class="cards-grid">
            <% if (role != 1) { %>
            <a href="ManageBranches.jsp" class="dashboard-card">
                <i class="fas fa-code-branch"></i>
                <h4>Manage Branches</h4>
                <p>Branch operations</p>
            </a>
            <% } %>
            <% if (role == 3) { %>
            <a href="AddNewBranch.jsp" class="dashboard-card">
                <i class="fa-solid fa-building-columns"></i>
                <h4>Add New Branch</h4>
                <p>New Jade Branch</p>
            </a>
            <% } %>
            <a href="ViewEmployees.jsp" class="dashboard-card">
                <i class="fas fa-users"></i>
                <h4>View Employees</h4>
                <p>Employee records</p>
            </a>
            <a href="EmployeeSignUp.jsp" class="dashboard-card">
                <i class="fas fa-user-plus"></i>
                <h4>Add Employee</h4>
                <p>Register new staff</p>
            </a>
        </div>
    </div>
    <div class="section-wrapper">
        <div class="section-title">Customer Management</div>
        <div class="cards-grid">
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
            <a href="AccountsList.jsp" class="dashboard-card">
                <i class="fa-regular fa-address-book"></i>
                <h4>View Bank Accounts</h4>
                <p>Accounts List</p>
            </a>
        </div>
    </div>
    <div class="section-wrapper">
        <div class="section-title">Transactions</div>
        <div class="cards-grid">
            <a href="Credit.jsp" class="dashboard-card">
                <i class="fa-solid fa-indian-rupee-sign"></i>
                <h4>Credit</h4>
                <p>Add Money</p>
            </a>
            <a href="Debit.jsp" class="dashboard-card">
                <i class="fa-solid fa-indian-rupee-sign"></i>
                <h4>Debit</h4>
                <p>Withdraw Money</p>
            </a>
            <a href="TransferInside.jsp" class="dashboard-card">
                <i class="fa-solid fa-money-bill-transfer"></i>
                <h4>Internal Transfer</h4>
                <p>Send Inside Bank</p>
            </a>
            <a href="TransaferOutside.jsp" class="dashboard-card">
                <i class="fa-solid fa-globe"></i>
                <h4>External Transfer</h4>
                <p>Send Outside Bank</p>
            </a>
        </div>
    </div>
    <% } %>
</div>
<script>
    const userId = <%= userId %>;
    fetch(`${pageContext.request.contextPath}/jadebank/user/profile`)
        .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch user"))
        .then(data => {
            document.getElementById("userName").textContent = data.fullName || "Unknown User";
            document.getElementById("userEmail").textContent = "Email: " + (data.email || "N/A");
            document.getElementById("userPhone").textContent = "Phone: " + (data.phone || "N/A");
            if (data.gender && data.gender.toLowerCase() === "female") {
                document.getElementById("profilePic").src = "contents/woman_6997664.png";
            } else {
                document.getElementById("profilePic").src = "contents/man_6997551.png";
            }
        })
        .catch(err => console.error("Profile load error:", err));

    function redirectToEditProfile() {
        <%-- Redirect to form based on role --%>
        <% if (role == 0) { %>
        window.location.href = `CustomerSignUp.jsp?userId=${userId}`;
        <% } else { %>
        window.location.href = `CustomerSignUp.jsp?employeeId=${userId}`;
        <% } %>
    }
</script>
</body>
</html>