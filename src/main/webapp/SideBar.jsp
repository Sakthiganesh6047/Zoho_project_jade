<!-- Include Font Awesome for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

<%@ page session="true" %>
<%
    Integer role = (Integer) session.getAttribute("role");
    if (role == null) {
    	response.sendRedirect("Login.jsp");
    }
    String currentPage = request.getRequestURI();
%>

<style>
	.sidebar {
	    position: absolute; /* Change from fixed to absolute */
	    top: 70px; /* Adjust based on your header height */
	    left: 0;
	    height: calc(100vh - 70px); /* Full height minus header */
	    width: 70px;
	    background-color: #373962;
	    display: flex;
	    flex-direction: column;
	    justify-content: space-between;
	    box-shadow: 4px 0 12px rgba(0,0,0,0.3);
	    transition: width 0.3s ease;
	    z-index: 1000;
	    box-shadow: 6px 0 16px rgba(0, 0, 0, 0.3); /* subtle shadow */
    	transition: width 0.3s ease, box-shadow 0.3s ease;
	}
	
	.sidebar {
	    transition: all 0.3s ease;
	    box-shadow: 4px 0 15px rgba(0, 0, 0, 0.2);
	}
	
	.sidebar.expanded a span {
	    font-size: 16px;
	    transition: font-size 0.3s ease;
	}
	
	.sidebar.collapsed a span {
	    font-size: 10px;
	    transition: font-size 0.3s ease;
	}
	
	#toggleSidebar.rotate i {
	    transform: rotate(180deg);
	}
	
	.sidebar.expanded {
	    width: 223px;
	}
	
	.sidebar .nav-items {
	    display: flex;
	    flex-direction: column;
	}
	
	.sidebar-link {
	    color: white;
	    text-decoration: none;
	    padding: 18px 10px;
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	    position: relative;
	    transition: background 0.3s ease;
	    font-size: 16px;
	}
	
	.sidebar-link i {
	    font-size: 22px;
	    margin-bottom: 5px;
	}
	
	.sidebar.expanded .sidebar-link {
	    flex-direction: row;
	    align-items: center;
	    justify-content: flex-start;
	    padding-left: 20px;
	}
	
	.sidebar.expanded .sidebar-link i {
	    margin-right: 16px;
	    margin-bottom: 0;
	}
	
	.sidebar .label {
	    font-size: 10px;
	    white-space: nowrap;
	}
	
	.sidebar:not(.expanded) .label {
	    display: block;
	}
	
	.sidebar-link:hover, .sidebar-link.active {
	    background-color: #ffffff;
	    color: #373962;
	}
	
	.toggle-btn {
	    position: absolute;
	    top: 50%;
	    right: -19px;
	    transform: translateY(-50%);
	    background: #2c2e54;
	    color: white;
	    border: none;
	    border-radius: 0 5px 5px 0;
	    height: 80px;
	    cursor: pointer;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    transition: transform 0.3s ease, background 0.3s ease;
	    box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.3);
	    z-index: 1000;
	}
	
	.toggle-btn:hover {
	    background: white;
	    color: #373962;
	}
	
	/* Rotate icon when sidebar is expanded */
	.sidebar.expanded .toggle-btn i {
	    transform: rotate(180deg);
	    transition: transform 0.3s ease;
	}

</style>

<div class="sidebar <%= request.getRequestURI().contains("Dashboard") ? "active" : "" %>" id="sidebar">
    <div class="nav-items">

        <% if (role == 0) { %>
        	<a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('CustomerDashboard.jsp', this)" data-tooltip="Home" data-page="CustomerDashboard.jsp">
	            <i class="fas fa-home"></i>
	            <span class="label">Home</span>
	        </a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('CustomerTransfer.jsp', this)" data-tooltip="Transact" data-page="CustomerTransfer.jsp">
                <i class="fas fa-money-bill-transfer"></i>
                <span class="label">Transact</span>
            </a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('QuickTransfer.jsp', this)" data-tooltip="Quick Transfer" data-page="QuickTransfer.jsp">
               	<i class="fas fa-bolt"></i>
                <span class="label">Quick Transfer</span>
            </a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('CustomerAccTransactions.jsp', this)" data-tooltip="Transactions" data-page="CustomerAccTransactions.jsp">
                <i class="fas fa-clock-rotate-left"></i>
                <span class="label">Transactions</span>
            </a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('BeneficiaryList.jsp', this)" data-tooltip="Beneficiaries" data-page="BeneficiaryList.jsp">
                <i class="fas fa-users"></i>
                <span class="label">Beneficiaries</span>
            </a>

        <% } else if (role == 1) { %>
        	<a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('ClerkDashboard.jsp', this)" data-tooltip="Home" data-page="ClerkDashboard.jsp">
	            <i class="fas fa-home"></i>
	            <span class="label">Home</span>
	        </a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('UnifiedTransfer.jsp', this)" data-tooltip="Transact" data-page="UnifiedTransfer.jsp">
                <i class="fas fa-money-bill-transfer"></i>
                <span class="label">Transact</span>
            </a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('AccountsList.jsp', this)" data-tooltip="Accounts" data-page="AccountsList.jsp">
                <i class="fas fa-address-book"></i>
                <span class="label">Accounts</span>
            </a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('CustomerSignUp.jsp', this)" data-tooltip="Add Customer" data-page="CustomerSignUp.jsp">
                <i class="fas fa-user-plus"></i>
                <span class="label">Add Customer</span>
            </a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('AccountTransactions.jsp', this)" data-tooltip="Past Transactions" data-page="AccountTransactions.jsp">
                <i class="fas fa-clock-rotate-left"></i>
                <span class="label">Transactions</span>
            </a>

        <% } else if (role == 2) { %>
        	<a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('Managerdashboard.jsp', this)" data-tooltip="Home" data-page="ManagerDashboard.jsp">
	            <i class="fas fa-home"></i>
	            <span class="label">Home</span>
	        </a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('ManageBranches.jsp', this)" data-tooltip="Branches" data-page="ManageBranches.jsp">
                <i class="fas fa-building-columns"></i>
                <span class="label">Branches</span>
            </a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('AccountsList.jsp', this)" data-tooltip="Accounts" data-page="AccountsList.jsp">
                <i class="fas fa-address-book"></i>
                <span class="label">Accounts</span>
            </a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('ViewEmployees.jsp', this)" data-tooltip="Employees" data-page="ViewEmployees.jsp">
                <i class="fas fa-user-tie"></i>
                <span class="label">Employees</span>
            </a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('AccountTransactions.jsp', this)" data-tooltip="Past Transactions" data-page="AccountTransactions.jsp">
                <i class="fas fa-clock-rotate-left"></i>
                <span class="label">Transactions</span>
            </a>

        <% } else if (role == 3) { %>
        	<a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('AdminDashboard.jsp', this)" data-tooltip="Home" data-page="AdminDashboard.jsp">
			    <i class="fas fa-home"></i>
			    <span class="label">Home</span>
			</a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('ManageBranches.jsp', this)" data-tooltip="Branches" data-page="ManageBranches.jsp">
                <i class="fas fa-building-columns"></i>
                <span class="label">Branches</span>
            </a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('AccountsList.jsp', this)" data-tooltip="Accounts" data-page="AccountsList.jsp">
                <i class="fas fa-address-book"></i>
                <span class="label">Accounts</span>
            </a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('ViewEmployees.jsp', this)" data-tooltip="Employees" data-page="ViewEmployees.jsp">
                <i class="fas fa-user-tie"></i>
                <span class="label">Employees</span>
            </a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('UnifiedTransfer.jsp', this)" data-tooltip="Transact" data-page="UnifiedTransfer.jsp">
                <i class="fas fa-money-bill-transfer"></i>
                <span class="label">Transact</span>
            </a>
            <a href="javascript:void(0)" class="sidebar-link" onclick="loadPage('AccountTransactions.jsp', this)" data-tooltip="Past Transactions" data-page="AccountTransactions.jsp">
                <i class="fas fa-clock-rotate-left"></i>
                <span class="label">Transactions</span>
            </a>
            

        <% } else { %>
            <a href="Login.jsp" class="sidebar-link" data-tooltip="Login">
                <i class="fas fa-sign-in-alt"></i>
                <span class="label">Login</span>
            </a>
        <% } %>
    </div>
    <!-- Centered toggle button -->
    <button class="toggle-btn" id="toggleSidebar" onclick="toggleSidebar()">
        <i class="fas fa-chevron-right"></i>
    </button>

</div>

<script>

function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const bodyWrapper = document.querySelector('.body-wrapper');

    sidebar.classList.toggle('expanded');

    if (sidebar.classList.contains('expanded')) {
        bodyWrapper.classList.add('sidebar-expanded');
        bodyWrapper.classList.remove('sidebar-collapsed');
    } else {
        bodyWrapper.classList.remove('sidebar-expanded');
        bodyWrapper.classList.add('sidebar-collapsed');
    }
}

</script>

