<!-- Include Font Awesome for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

<%@ page session="true" %>
<%
    Integer role = (Integer) session.getAttribute("role");
    if (role == null) role = -1;
    String currentPage = request.getRequestURI();
%>

<style>
	.sidebar {
	    position: fixed;
	    left: 0;
	    height: 100vh;
	    width: 70px;
	    background-color: #373962;
	    display: flex;
	    flex-direction: column;
	    justify-content: space-between;
	    box-shadow: 4px 0 12px rgba(0,0,0,0.3);
	    transition: width 0.3s ease;
	    z-index: 1000;
	    overflow-x: hidden;
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
	    background: #2c2e54;
	    color: white;
	    border: none;
	    width: 100%;
	    padding-top: 10px;
	    padding-bottom: 85px;
	    cursor: pointer;
	    font-size: 18px;
	    transition: transform 0.3s ease;
	}
	
	.toggle-btn:hover{
		background: white;
		color: black;
	}
	
	/* Tooltip (custom) */
	.sidebar:not(.expanded) .sidebar-link:hover::after {
	    content: attr(data-tooltip);
	    position: absolute;
	    left: 100%;
	    top: 50%;
	    transform: translateY(-50%);
	    background-color: #373962;
	    color: white;
	    padding: 4px 10px;
	    border-radius: 6px;
	    white-space: nowrap;
	    margin-left: 10px;
	    font-size: 12px;
	    z-index: 999;
	    box-shadow: 2px 2px 8px rgba(0,0,0,0.3);
	}

</style>

<div class="sidebar <%= request.getRequestURI().contains("Dashboard") ? "active" : "" %>" id="sidebar">
    <div class="nav-items">

        <% if (role == 0) { %>
        	<a href="CustomerDashboard.jsp" class="sidebar-link <%= request.getRequestURI().contains("Dashboard") ? "active" : "" %>" data-tooltip="Home">
	            <i class="fas fa-home"></i>
	            <span class="label">Home</span>
	        </a>
            <a href="CustomerTransfer.jsp" class="sidebar-link <%= request.getRequestURI().contains("CustomerTransfer") ? "active" : "" %>" data-tooltip="Transact">
                <i class="fas fa-money-bill-transfer"></i>
                <span class="label">Transact</span>
            </a>
            <a href="QuickTransfer.jsp" class="sidebar-link <%= request.getRequestURI().contains("QuickTransfer") ? "active" : "" %>" data-tooltip="Quick Transfer">
               	<i class="fas fa-bolt"></i>
                <span class="label">Quick Transfer</span>
            </a>
            <a href="CustomerAccTransactions.jsp" class="sidebar-link <%= request.getRequestURI().contains("CustomerAccTransactions") ? "active" : "" %>" data-tooltip="Transactions">
                <i class="fas fa-clock-rotate-left"></i>
                <span class="label">Transactions</span>
            </a>
            <a href="BeneficiaryList.jsp" class="sidebar-link <%= request.getRequestURI().contains("Beneficiary") ? "active" : "" %>" data-tooltip="Beneficiaries">
                <i class="fas fa-users"></i>
                <span class="label">Beneficiaries</span>
            </a>

        <% } else if (role == 1) { %>
        	<a href="ClerkDashboard.jsp" class="sidebar-link <%= request.getRequestURI().contains("ClerkDashboard") ? "active" : "" %>" data-tooltip="Home">
	            <i class="fas fa-home"></i>
	            <span class="label">Home</span>
	        </a>
            <a href="Transact.jsp" class="sidebar-link <%= request.getRequestURI().contains("Transact") ? "active" : "" %>" data-tooltip="Transact">
                <i class="fas fa-money-bill-transfer"></i>
                <span class="label">Transact</span>
            </a>
            <a href="Accounts.jsp" class="sidebar-link <%= request.getRequestURI().contains("Accounts") ? "active" : "" %>" data-tooltip="Accounts">
                <i class="fas fa-address-book"></i>
                <span class="label">Accounts</span>
            </a>
            <a href="CustomerSignUp.jsp" class="sidebar-link <%= request.getRequestURI().contains("CustomerSignUp") ? "active" : "" %>" data-tooltip="Add Customer">
                <i class="fas fa-user-plus"></i>
                <span class="label">Add Customer</span>
            </a>

        <% } else if (role == 2) { %>
        	<a href="ManagerDashboard.jsp" class="sidebar-link <%= request.getRequestURI().contains("ManagerDashboard") ? "active" : "" %>" data-tooltip="Home">
	            <i class="fas fa-home"></i>
	            <span class="label">Home</span>
	        </a>
            <a href="ManageBranches.jsp" class="sidebar-link <%= request.getRequestURI().contains("ManageBranches") ? "active" : "" %>" data-tooltip="Branches">
                <i class="fas fa-building-columns"></i>
                <span class="label">Branches</span>
            </a>
            <a href="Accounts.jsp" class="sidebar-link <%= request.getRequestURI().contains("Accounts") ? "active" : "" %>" data-tooltip="Accounts">
                <i class="fas fa-address-book"></i>
                <span class="label">Accounts</span>
            </a>
            <a href="ViewEmployees.jsp" class="sidebar-link <%= request.getRequestURI().contains("ViewEmployees") ? "active" : "" %>" data-tooltip="Employees">
                <i class="fas fa-user-tie"></i>
                <span class="label">Employees</span>
            </a>

        <% } else if (role == 3) { %>
        	<a href="AdminDashboard.jsp" class="sidebar-link <%= request.getRequestURI().contains("AdminDashboard") ? "active" : "" %>" data-tooltip="Home">
	            <i class="fas fa-home"></i>
	            <span class="label">Home</span>
	        </a>
            <a href="ManageBranches.jsp" class="sidebar-link <%= request.getRequestURI().contains("ManageBranches") ? "active" : "" %>" data-tooltip="Branches">
                <i class="fas fa-building-columns"></i>
                <span class="label">Branches</span>
            </a>
            <a href="AccountsList.jsp" class="sidebar-link <%= request.getRequestURI().contains("Accounts") ? "active" : "" %>" data-tooltip="Accounts">
                <i class="fas fa-address-book"></i>
                <span class="label">Accounts</span>
            </a>
            <a href="ViewEmployees.jsp" class="sidebar-link <%= request.getRequestURI().contains("ViewEmployees") ? "active" : "" %>" data-tooltip="Employees">
                <i class="fas fa-user-tie"></i>
                <span class="label">Employees</span>
            </a>
            <a href="UnifiedTransfer.jsp" class="sidebar-link <%= request.getRequestURI().contains("CustomerTransfer") ? "active" : "" %>" data-tooltip="Transact">
                <i class="fas fa-money-bill-transfer"></i>
                <span class="label">Transact</span>
            </a>
            

        <% } else { %>
            <a href="Login.jsp" class="sidebar-link" data-tooltip="Login">
                <i class="fas fa-sign-in-alt"></i>
                <span class="label">Login</span>
            </a>
        <% } %>
    </div>
    <button class="toggle-btn" id="toggleSidebar" onclick="toggleSidebar()">
	    <i class="fas fa-bars"></i>
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

