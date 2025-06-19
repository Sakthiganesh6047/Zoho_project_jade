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

<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<style>
    .sidebar {
        width: 60px;
        height: 100vh;
        position: fixed;
        left: 0;
        background-color: #373962;
        border-radius: 0 12px 12px 0;
        border-left: none;
        box-shadow: 4px 0 12px rgba(0, 0, 0, 0.3);
        color: white;
        overflow-x: hidden;
        transition: width 0.3s ease;
        z-index: 1000;
        display: flex;
        flex-direction: column;
        align-items: center;
        padding-top:10px;
    }

    .sidebar:hover {
        width: 240px;
        align-items: stretch;
    }

    .mini-logo {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100%;
        margin-top: 20px;
        font-size: 24px;
        font-weight: bold;
        letter-spacing: 2px;
    }

    .sidebar:hover .mini-logo {
        display: none;
    }

    .sidebar-content {
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
	    display: flex;
	    align-items: center;
	    justify-content: flex-start;
	    padding: 16px 20px;
	    color: white;
	    text-decoration: none;
	    white-space: nowrap;
	    overflow: hidden;
	    transition: background 0.3s, color 0.3s;
	    margin-bottom: 5px; /* NEW: spacing between options */
	}
	
	.sidebar a i {
	    min-width: 24px;
	    text-align: center;
	    font-size: 22px; /* was 18px */
	    margin-right: 12px;
	}
	
	.sidebar a span {
	    display: none;
	    transition: opacity 0.3s ease;
	}
	
	.sidebar:hover a span {
	    display: inline;
	    opacity: 1;
	}

    .sidebar:hover a span {
        display: inline;
        opacity: 1;
    }

    .sidebar a:hover {
        background-color: white;
        color: #373962;
    }

    .dropdown {
        position: relative;
    }

    .dropdown-content {
        display: none;
        flex-direction: column;
        background-color: white;
        margin-left: 20px;
        padding-left: 10px;
        border-radius: 6px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    }

    .sidebar:hover .dropdown:hover .dropdown-content {
        display: flex;
    }

    .dropdown-content a {
        padding: 10px 15px;
        background-color: white;
        color: #373962;
        text-decoration: none;
        transition: background 0.5s;
    }

    .dropdown-content a:hover {
        background-color: #f0f0f0;
        color: #373962;
    }
</style>

<div class="sidebar">
    <!-- Sidebar with always-visible icons and hover-expandable labels -->
    <a href="Dashboard.jsp"><i class="fas fa-home"></i><span>Home</span></a>

    <% if (role > 0 && role <= 3) { %>
        <div class="dropdown">
            <a href="#"><i class="fas fa-money-bill-transfer"></i><span>Transact</span></a>
            <div class="dropdown-content">
                <a href="Credit.jsp">- Credit</a>
                <a href="Debit.jsp">- Debit</a>
                <a href="TransferInside.jsp">- Internal Transfer</a>
                <a href="TransferOutside.jsp">- External Transfer</a>
            </div>
        </div>
    <% } %>

    <% if (role == 0) { %>
    
        <a href="CustomerTransfer.jsp"><i class="fas fa-money-bill-transfer"></i><span>Transact</span></a>
        
        <a href="QuickTransfer.jsp"><i class="fa-solid fa-money-bill-trend-up"></i><span>Instant Transfer</span></a>
        
        <a href="CustomerAccTransactions.jsp"><i class="fas fa-clock-rotate-left"></i><span>View Transactions</span></a>

        <div class="dropdown">
        	<a href="#"><i class="fa-solid fa-user-plus"></i><span>Beneficiaries</span></a>
        		<div class="dropdown-content">
        			<a href="AddBeneficiary.jsp" class="btn">- Add Beneficiary</a>
        			<a href="BeneficiaryList.jsp" class="btn">- Manage Beneficiaries</a>
        		</div>
        </div>
        
    <% } else if (role == 1) { %>
    
    	<div class="dropdown">
        	<a href="#"><i class="fas fa-address-book"></i><span>Bank Accounts</span></a>
        		<div class="dropdown-content">
        			 <a href="AccountsList.jsp" class="btn">- Branch Accounts List</a>
        			<a href="OpenAccount.jsp" class="btn">- Open New Account</a>
        		</div>
        </div>
        
        <a href="AccountTransactions.jsp"><i class="fa-solid fa-money-bill-trend-up"></i><span>View Transactions</span></a>
        
        <a href="CustomerSignUp.jsp"><i class="fa-solid fa-user-plus"></i><span>Add Customer</span></a>
        
    <% } else if (role == 2) { %>
    
    	<a href="ManageBranches.jsp"><i class="fa-solid fa-building-columns"></i><span>Manage Branch</span></a>
    	
    	<div class="dropdown">
        	<a href="#"><i class="fa-solid fa-user-tie"></i><span>Employees</span></a>
        		<div class="dropdown-content">
        			<a href="ViewEmployees.jsp" class="btn">- View Employees</a>
        			<a href="EmployeeSignUp.jsp" class="btn">- Add Employee</a>
        		</div>
        </div>
        
        <div class="dropdown">
        	<a href="#"><i class="fas fa-address-book"></i><span>Bank Accounts</span></a>
        		<div class="dropdown-content">
        			 <a href="AccountsList.jsp" class="btn">- Branch Accounts List</a>
        			<a href="OpenAccount.jsp" class="btn">- Open New Account</a>
        		</div>
        </div>
        
        <a href="AccountTransactions.jsp"><i class="fa-solid fa-money-bill-trend-up"></i><span>View Transactions</span></a>
        
        <a href="CustomerSignUp.jsp"><i class="fa-solid fa-user-plus"></i><span>Add Customer</span></a>
    	
    <% } else if (role == 3) { %>
        
        <div class="dropdown">
        	<a href="#"><i class="fa-solid fa-building-columns"></i><span>Branches</span></a>
	        	<div class="dropdown-content">
	        		<a href="ManageBranches.jsp" class="btn">Manage Branches</a>
	            	<a href="AddNewBranch.jsp" class="btn">Add New Branch</a>
	        	</div>
        </div>
        
        <div class="dropdown">
        	<a href="#"><i class="fa-solid fa-user-tie"></i><span>Employees</span></a>
        		<div class="dropdown-content">
        			<a href="ViewEmployees.jsp" class="btn">- View Employees</a>
        			<a href="EmployeeSignUp.jsp" class="btn">- Add Employee</a>
        		</div>
        </div>
        
        <div class="dropdown">
        	<a href="#"><i class="fas fa-address-book"></i><span>Bank Accounts</span></a>
        		<div class="dropdown-content">
        			 <a href="AccountsList.jsp" class="btn">- Branch Accounts List</a>
        			<a href="OpenAccount.jsp" class="btn">- Open New Account</a>
        		</div>
        </div>
        
        <a href="AccountTransactions.jsp"><i class="fa-solid fa-money-bill-trend-up"></i><span>View Transactions</span></a>
        
        <a href="CustomerSignUp.jsp"><i class="fa-solid fa-user-plus"></i><span>Add Customer</span></a>

    <% } else { %>
        <a href="Login.jsp"><i class="fas fa-sign-in-alt"></i><span>Login</span></a>
    <% } %>
	<a href="profile.jsp"><i class="fa-solid fa-id-card"></i><span>My Profile</span></a>
    <a href="Logout.jsp"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
</div>

