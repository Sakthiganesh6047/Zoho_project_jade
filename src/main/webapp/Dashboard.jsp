<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>
<%
    Integer role = (Integer) session.getAttribute("role");
    if (role == null || role == 4) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: #f5f5f5;
        }
        header {
            background-color: #2b4c7e;
            color: white;
            padding: 1rem;
            text-align: center;
        }
        .dashboard-container {
            max-width: 900px;
            margin: 2rem auto;
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .button-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1.5rem;
        }
        .btn {
            padding: 1rem;
            background-color: #2b4c7e;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
        }
        .btn:hover {
            background-color: #4568a2;
        }
    </style>
</head>
<body>

<header style="display: flex; justify-content: space-between; align-items: center;">
    <h2>Welcome to Jade Bank</h2>
    <form action="Logout.jsp" method="post" style="margin: 0;">
        <button type="submit" style="background-color: #ff4d4d; color: white; border: none; padding: 0.5rem 1rem; border-radius: 6px; cursor: pointer;">
            Logout
        </button>
    </form>
</header>


<div class="dashboard-container">
    <h3>Your Dashboard</h3>

    <div class="button-grid">
        <%-- Customer --%>
        <% if (role == 0) { %>
            <a href="CustomerTransfer.jsp" class="btn">Transfer Money</a>
            <a href="ViewBalance.jsp" class="btn">View Balance</a>
            <a href="CustomerAccTransactions.jsp" class="btn">View Transactions</a>
            <a href="AddBeneficiary.jsp" class="btn">Add Beneficiary</a>
            <a href="BeneficiaryList.jsp" class="btn">Manage Beneficiaries</a>
            <a href="QuickTransfer.jsp" class="btn">Instant Money Transfer</a>

        <%-- Employee --%>
        <% } else if (role == 1) { %>
            <a href="AddCustomer.jsp" class="btn">Add Customer</a>
            <a href="OpenAccount.jsp" class="btn">Open Account</a>
            <a href="SearchCustomer.jsp" class="btn">View Customer Details</a>
            <a href="OpenAccount.jsp" class="btn">Open New Account</a>
            <a href="AccountsList.jsp" class="btn">Branch Accounts List</a>
            <a href="Debit.jsp" class="btn">Debit</a>
            <a href="TransferInside.jsp" class="btn">Transfer Inside the Bank</a>
            <a href="TransferOutside.jsp" class="btn">Transfer Outside Bank</a>
            <a href="AccountTransactions.jsp" class="btn">View Transactions</a>

        <%-- Manager --%>
        <% } else if (role == 2) { %>
        	<a href="ViewEmployees.jsp" class="btn">View Employees</a>
            <a href="ApproveAccounts.jsp" class="btn">Approve Accounts</a>
            <a href="EmployeePerformance.jsp" class="btn">Employee Performance</a>
            <a href="BranchOverview.jsp" class="btn">Branch Overview</a>
            <a href="EmployeeSignUp.jsp" class="btn">Add Employee</a>
            <a href="OpenAccount.jsp" class="btn">Open New Account</a>
            <a href="AccountsList.jsp" class="btn">Branch Accounts List</a>
            <a href="Debit.jsp" class="btn">Debit</a>
            <a href="TransferInside.jsp" class="btn">Transfer Inside Bank</a>
            <a href="TransferOutside.jsp" class="btn">Transfer Outside Bank</a>
            <a href="AccountTransactions.jsp" class="btn">View Transactions</a>

        <%-- Admin / GM --%>
        <% } else if (role == 3) { %>
            <a href="EmployeeSignUp.jsp" class="btn">Add Employee</a>
            <a href="ViewEmployees.jsp" class="btn">View Employees</a>
            <a href="ManageBranches.jsp" class="btn">Manage Branches</a>
            <a href="AddNewBranch.jsp" class="btn">Add New Branch</a>
            <a href="CustomerSignUp.jsp" class="btn">Add New Customer</a>
            <a href="OpenAccount.jsp" class="btn">Open New Account</a>
            <a href="AccountsList.jsp" class="btn">Branch Accounts List</a>
            <a href="Credit.jsp" class="btn">Credit</a>
            <a href="Debit.jsp" class="btn">Debit</a>
            <a href="TransferInside.jsp" class="btn">Transfer Inside the Bank</a>
            <a href="TransferOutside.jsp" class="btn">Transfer Outside Bank</a>
            <a href="AccountTransactions.jsp" class="btn">View Transactions</a>
        <% } %>
    </div>
</div>

</body>
</html>
