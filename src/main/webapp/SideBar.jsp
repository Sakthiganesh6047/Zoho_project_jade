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
	    width: 220px;
	    height: 100%; /* Ensure it spans the full viewport height */
	    position: fixed;
	    left: 0;
	    background-color: #373962;
	    color: white;
	    padding: 20px 0;
	    font-family: Arial, sans-serif;
	    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3); /* Floating shadow effect */
	    border-right: 2px solid white; /* White right border */
	    border-radius: 0 12px 12px 0; /* Rounded right corners only */
	    z-index: 1000; /* Ensure it appears above other content */
	}

    .sidebar h3, .sidebar .userinfo {
        text-align: center;
        margin-bottom: 20px;
    }

    .sidebar .userinfo {
        font-size: 0.95em;
        color: #ccc;
    }

    .sidebar a {
        display: block;
        color: white;
        padding: 12px 20px;
        text-decoration: none;
        transition: background 0.3s;
        position: relative;
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
        position: absolute;
        left: 100%;
        top: 0;
        min-width: 180px;
        z-index: 1;
    }

    .dropdown:hover .dropdown-content {
        display: flex;
    }

    .dropdown-content a {
        padding: 10px 15px;
        color: white;
        text-decoration: none;
        background-color: #003f7d;
    }

    .dropdown-content a:hover {
        background-color: #00509e;
    }

    .content {
        margin-left: 240px;
        padding: 20px;
    }
</style>

<div class="sidebar">
    <h3>JadeBank</h3>
    <div class="userinfo">
        <em><%= roleLabel %></em>
    </div>

    <a href="Home.jsp">Home</a>

    <% if (role == 0 || role == 1 || role == 2 || role == 3) { %>
        <!-- Transact dropdown for Customer/Employee -->
        <div class="dropdown">
            <a href="#">Transact &#9662;</a>
            <div class="dropdown-content">
                <a href="Credit.jsp">Credit</a>
                <a href="Debit.jsp">Debit</a>
                <a href="TransferInside.jsp">Internal Bank Transfer</a>
                <a href="TransferOutside.jsp">External Bank Transfer</a>
            </div>
        </div>
    <% } %>

    <% if (role == 0) { %>
        <!-- Customer -->
        <a href="ViewTransactions.jsp">Transaction History</a>
        <a href="AccountSummary.jsp">Account Summary</a>
    <% } else if (role == 1) { %>
        <!-- Employee -->
        <a href="AccountCreation.jsp">Open Account</a>
        <a href="CustomerSearch.jsp">Search Customer</a>
        <a href="ViewTransactions.jsp">View Transactions</a>
    <% } else if (role == 2) { %>
        <!-- Manager -->
        <a href="EmployeeSignUp.jsp">Add Employee</a>
        <a href="BranchManagement.jsp">Branch Management</a>
        <a href="ViewEmployees.jsp">View Employees</a>
    <% } else if (role == 3) { %>
        <!-- GM -->
        <a href="AllUsers.jsp">All Users</a>
        <a href="BranchList.jsp">All Branches</a>
        <a href="ManageRoles.jsp">Manage Roles</a>
    <% } else { %>
        <!-- Guest -->
        <a href="Login.jsp">Login</a>
    <% } %>

    <a href="Logout.jsp">Logout</a>
</div>
