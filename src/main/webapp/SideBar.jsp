<%@ page session="true" %>
<%
    Integer role = (Integer) session.getAttribute("role");
    if (role == null) role = -1;

    String roleLabel = "Unknown";
    switch (role) {
        case 0: roleLabel = "Customer"; break;
        case 1: roleLabel = "Employee"; break;
        case 2: roleLabel = "Manager"; break;
        case 3: roleLabel = "GM"; break;
    }
%>

<style>
    .sidebar {
        width: 60px;
        height: 100vh;
        position: fixed;
        left: 0;
        background-color: 373962;
        border-radius: 0 12px 12px 0;
        color: white;
        overflow-x: hidden;
        transition: width 0.3s ease;
        z-index: 1000;
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .sidebar:hover {
        width: 220px;
        align-items: stretch;
    }

    .sidebar .mini-logo {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        justify-content: center; /* center vertically */
    	height: 100%; /* full height of sidebar */
        margin-top: 20px;
        font-size: 24px;
        font-weight: bold;
        letter-spacing: 2px;
    }

    .sidebar:hover .mini-logo {
        display: none;
    }

    .sidebar .sidebar-content {
        display: none;
        padding: 10px;
    }

    .sidebar:hover .sidebar-content {
        display: block;
    }

    .sidebar h3 {
        text-align: center;
        font-size: 1.2em;
        margin-bottom: 10px;
    }

    .userinfo {
        text-align: center;
        font-size: 0.9em;
        color: #ccc;
        margin-bottom: 20px;
    }

    .sidebar a {
        display: block;
        padding: 12px 16px;
        color: white;
        text-decoration: none;
        white-space: nowrap;
        overflow: hidden;
        transition: background 0.3s;
    }

    .sidebar a:hover {
        background-color: #00509e;
    }

    .dropdown {
        position: relative;
    }

    .dropdown-content {
        display: none;
        flex-direction: column;
        background-color: #003f7d;
        margin-left: 20px;
        padding-left: 10px;
    }

    .sidebar:hover .dropdown:hover .dropdown-content {
        display: flex;
    }

    .dropdown-content a {
        padding: 10px 15px;
        background-color: #003f7d;
    }

    .dropdown-content a:hover {
        background-color: #00509e;
    }
</style>

<div class="sidebar">
    <!-- Mini logo shown when collapsed -->
    <div class="mini-logo">
        <span>J</span>
        <span>A</span>
        <span>D</span>
        <span>E</span>
        <span>-></span>
    </div>

    <!-- Full content shown on hover -->
    <div class="sidebar-content">
        <h3>JadeBank</h3>
        <div class="userinfo"><em><%= roleLabel %></em></div>

        <a href="Home.jsp">Home</a>

        <% if (role >= 0 && role <= 3) { %>
            <div class="dropdown">
                <a href="#">Transact</a>
                <div class="dropdown-content">
                    <a href="Credit.jsp">- Credit</a>
                    <a href="Debit.jsp">- Debit</a>
                    <a href="TransferInside.jsp">- Internal Transfer</a>
                    <a href="TransferOutside.jsp">- External Transfer</a>
                </div>
            </div>
        <% } %>

        <% if (role == 0) { %>
            <a href="ViewTransactions.jsp">Transaction History</a>
            <a href="AccountSummary.jsp">Account Summary</a>
        <% } else if (role == 1) { %>
            <a href="AccountCreation.jsp">Open Account</a>
            <a href="CustomerSearch.jsp">Search Customer</a>
            <a href="ViewTransactions.jsp">View Transactions</a>
        <% } else if (role == 2) { %>
            <a href="EmployeeSignUp.jsp">Add Employee</a>
            <a href="BranchManagement.jsp">Branch Management</a>
            <a href="ViewEmployees.jsp">View Employees</a>
        <% } else if (role == 3) { %>
            <a href="AllUsers.jsp">All Users</a>
            <a href="BranchList.jsp">All Branches</a>
            <a href="ManageRoles.jsp">Manage Roles</a>
        <% } else { %>
            <a href="Login.jsp">Login</a>
        <% } %>

        <a href="Logout.jsp">Logout</a>
    </div>
</div>
