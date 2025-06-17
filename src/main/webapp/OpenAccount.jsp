<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Open New Account</title>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f5f5f5;
        }

        .main-wrapper {
            max-width: 600px;
            margin: 50px auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 8px;
        }

        input[type="text"], input[type="number"], select {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            background-color: #007BFF;
            color: white;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        .btn:disabled {
            background-color: #888;
        }

        .error {
            color: red;
            font-weight: bold;
        }

        .success {
            color: green;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <jsp:include page="LoggedInHeader.jsp" />

    <div class="main-wrapper">
        <h2>Open New Account</h2>

        <div id="form-message" class="error"></div>

        <form id="open-account-form">
            <!-- Phone number to fetch customerId -->
            <div class="form-group">
                <label for="phone">Customer Phone Number:</label>
                <input type="text" id="phone" name="phone" pattern="[0-9]{10}" required>
                <button type="button" id="search-btn" class="btn">Search</button>
            </div>
            
            <div class="form-group">
			    <label for="customerId">Customer ID:</label>
			    <input type="text" id="customerIdDisplay" readonly disabled style="background-color: #e9ecef;">
			</div>
            

            <div class="form-group">
                <label for="branchId">Select Branch:</label>
                <select id="branchId" name="branchId" required>
                    <option value="">-- Select Branch --</option>
                </select>
            </div>

            <div class="form-group">
                <label for="accountType">Account Type:</label>
                <select id="accountType" name="accountType" required>
                    <option value="">-- Select Type --</option>
                    <option value="1">Savings</option>
                    <option value="2">Current</option>
                </select>
            </div>

            <div class="form-group">
                <label for="balance">Initial Balance:</label>
                <input type="number" id="balance" name="balance" required min="0">
            </div>

            <input type="hidden" id="customerId" name="customerId">

            <button type="submit" class="btn">Open Account</button>
        </form>
    </div>

    <jsp:include page="Footer.jsp" />

    <script>
        const contextPath = "<%= request.getContextPath() %>";

        window.addEventListener("DOMContentLoaded", () => {
            fetch("${pageContext.request.contextPath}/jadebank/branch/list")
                .then(res => res.json())
                .then(data => {
		            const branchSelect = document.getElementById("branchId");
		            branchSelect.innerHTML = '<option value="">-- Select Branch --</option>';
		            data.forEach(branchData => {
		                const option = document.createElement("option");
		                option.value = branchData.branchId;
		                option.textContent = (branchData.branchName ?? "Unnamed") + " - " + (branchData.branchDistrict ?? "Unknown");
		                branchSelect.appendChild(option);
		            });
		        })
                .catch(err => {
                    document.getElementById("form-message").textContent = "Failed to load branch list.";
                });
        });

        document.getElementById("search-btn").addEventListener("click", () => {
            const phone = document.getElementById("phone").value;
            if (!phone || phone.length !== 10) {
                document.getElementById("form-message").textContent = "Enter valid 10-digit phone number.";
                return;
            }

            fetch("${pageContext.request.contextPath}/jadebank/user/phone", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
    				phone: phone
                })
            })
            .then(res => res.json())
            .then(data => {
			    if (data && data.userId) {
			        document.getElementById("customerId").value = data.userId;
			        document.getElementById("customerIdDisplay").value = data.userId;
			        document.getElementById("form-message").className = "success";
			        document.getElementById("form-message").textContent = "Customer found successfully.";
			    } else {
			        document.getElementById("form-message").className = "error";
			        document.getElementById("form-message").textContent = "Customer not found.";
			        document.getElementById("customerIdDisplay").value = "";
			        document.getElementById("customerId").value = "";
			    }
			})
            .catch(err => {
                document.getElementById("form-message").textContent = "Error searching customer.";
            });
        });

        document.getElementById("open-account-form").addEventListener("submit", e => {
            e.preventDefault();

            const customerId = document.getElementById("customerId").value;
            const branchId = document.getElementById("branchId").value;
            const accountType = document.getElementById("accountType").value;
            const balance = document.getElementById("balance").value;

            if (!customerId) {
                document.getElementById("form-message").textContent = "Search and select a customer first.";
                return;
            }

            const accountData = {
                customerId: parseInt(customerId),
                branchId: parseInt(branchId),
                accountType: parseInt(accountType),
                balance: parseFloat(balance)
            };

            fetch("${pageContext.request.contextPath}/jadebank/account/new", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(accountData)
            })
            .then(async res => {
                if (res.ok) {
                    document.getElementById("form-message").className = "success";
                    document.getElementById("form-message").textContent = "Account successfully created.";
                    document.getElementById("open-account-form").reset();
                } else {
                    const error = await res.json();
                    document.getElementById("form-message").className = "error";
                    document.getElementById("form-message").textContent = error.error || "Failed to open account.";
                }
            })
            .catch(err => {
                document.getElementById("form-message").className = "error";
                document.getElementById("form-message").textContent = "Server error occurred.";
            });
        });
    </script>
</body>
</html>
