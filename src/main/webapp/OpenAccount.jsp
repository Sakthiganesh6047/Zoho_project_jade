<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Open New Account</title>
    <style>
        body {
		    font-family: 'Roboto', sans-serif;
		    background-image: url("contents/background.png"); /* Replace with your actual path */
		    background-size: cover;        /* Scales the image to cover the whole screen */
		    background-repeat: no-repeat;  /* Prevents tiling */
		    background-position: center;
		    margin: 0; 
		    display: flex; 
		    flex-direction: column; 
		    min-height: 93vh;
		    padding-top: 70px; /* same as header height */
		}
		
		.body-wrapper {
		    display: flex; 
		    flex: 1;
		    min-height: 70vh;
		}
		
		.sidebar-wrapper {
		    width: 60px;
		    border-radius: 0 12px 12px 0;
		    background-color: #373962;
		    color: white;
		    height: 100vh;
		    position: fixed;
		    left: 0;
		    z-index: 1000;
		}
		
		.content-wrapper {
		    flex: 1;
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    padding: 40px 20px;
		}
		
		.form-box {
		    background: white;
		    padding: 30px;
		    border-radius: 10px;
		    max-width: 600px;
		    width: 100%;
		    box-shadow: 0 0 12px rgba(0,0,0,0.1);
		}
		
		h2 {
		    text-align: center;
		    color: #373962;
		    margin-bottom: 25px;
		}
		
		.form-group {
		    margin-bottom: 20px;
		}
		
		label {
		    display: block;
		    font-weight: bold;
		    margin-bottom: 8px;
		    color: #333;
		}
		
		input[type="text"], input[type="number"], select {
		    width: 100%;
		    padding: 10px;
		    border-radius: 6px;
		    border: 1px solid #ccc;
		    font-size: 1rem;
		    background-color: #fff;
		    box-sizing: border-box;
		}
		
		input[readonly], input[disabled] {
		    background-color: #e9ecef;
		}
		
		input:focus, select:focus {
		    outline: none;
		    border-color: #007bff;
		}
		
		.phone-search-group {
		    display: flex;
		    gap: 10px;
		    align-items: center;
		}
		
		.btn {
		    padding: 10px 20px;
		    border: none;
		    background-color: #414485;
		    color: white;
		    border-radius: 6px;
		    font-size: 16px;
		    cursor: pointer;
		    transition: background-color 0.2s;
		}
		
		.btn:hover {
		    background-color: #0056b3;
		}
		
		.btn:disabled {
		    background-color: #888;
		    cursor: not-allowed;
		}
		
		.error {
		    color: red;
		    font-weight: bold;
		    margin-bottom: 10px;
		    text-align: center;
		}
		
		.success {
		    color: green;
		    font-weight: bold;
		    margin-bottom: 10px;
		    text-align: center;
		}
    </style>
</head>
<body>

	<div class="body-wrapper">
	
	    <div class="content-wrapper">
	        <div class="form-box">
	            <h2>Open New Account</h2>
	
	            <div id="form-message" class="error"></div>
	
	            <form id="open-account-form">
	                <div class="form-group phone-search-group">
	                    <div style="flex: 1;">
	                        <label for="phone">Customer Phone Number:</label>
	                        <input type="text" id="phone" name="phone" pattern="[0-9]{10}" required>
	                    </div>
	                    <div>
	                        <label>&nbsp;</label>
	                        <button type="button" id="search-btn" class="btn">Search</button>
	                    </div>
	                </div>
	
	                <div class="form-group">
	                    <label for="customerIdDisplay">Customer ID:</label>
	                    <input type="text" id="customerIdDisplay" readonly disabled>
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
	
	                <div class="form-group" style="text-align: center;">
	                    <button type="submit" class="btn">Open Account</button>
	                </div>
	            </form>
	        </div>
	    </div>
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
