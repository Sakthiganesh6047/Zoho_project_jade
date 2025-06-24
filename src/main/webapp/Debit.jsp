<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Debit Amount</title>
    <style>
        body {
		    font-family: "Roboto", sans-serif;
		    background-color: #f7f7f7;
		    margin: 0;
		    display: flex;
		    flex-direction: column;
		    min-height: 100vh;
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
		    margin-left: 70px;
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
		    max-width: 450px;
		    width: 100%;
		    box-shadow: 0 0 12px rgba(0,0,0,0.1);
		}
		
		h2 {
		    text-align: center;
		    color: #373962;
		    margin-bottom: 25px;
		}
		
		label {
		    font-weight: bold;
		    margin-bottom: 6px;
		    display: block;
		    color: #333;
		}
		
		input[type="number"],
		input[type="password"] {
		    width: 100%;
		    padding: 10px;
		    border-radius: 6px;
		    border: 1px solid #ccc;
		    font-size: 1rem;
		    box-sizing: border-box;
		    margin-bottom: 15px;
		}
		
		input:focus {
		    outline: none;
		    border-color: #007bff;
		}
		
		button {
		    padding: 10px 20px;
		    background-color: #414485;
		    color: white;
		    font-weight: bold;
		    border: none;
		    border-radius: 6px;
		    cursor: pointer;
		    width: 100%;
		    transition: background-color 0.2s;
		    margin-bottom: 10px;
		}
		
		button:hover {
		    background-color: #0056b3;
		}
		
		#infoDiv {
		    font-size: 18px;
		    color: #414485;
		    margin: -10px 0 10px;
		    padding: 8px;
		}
		
		#debit-status {
		    font-weight: bold;
		    text-align: center;
		    margin-top: 10px;
		}
		
		.modal {
		    display: none; /* Hidden by default */
		    position: fixed;
		    top: 0;
		    left: 0;
		    height: 100vh;
		    width: 100vw;
		    background: rgba(0, 0, 0, 0.5);
		    justify-content: center;  /* center horizontally */
		    align-items: center;      /* center vertically */
		    z-index: 2000;
		}
		
		.modal.show {
		    display: flex; /* flex is only applied when modal is active */
		}
		
		.modal-content {
		    background: white;
		    padding: 20px 30px;
		    border-radius: 12px;
		    box-shadow: 0 5px 20px rgba(0,0,0,0.2);
		    width: 320px;
		    text-align: center;
		}
		
		.modal-content input {
		    width: 100%;
		    padding: 10px;
		    margin: 10px 0;
		    border: 1px solid #ccc;
		    border-radius: 6px;
		}
		
		.modal-content button {
		    width: 100%;
		    padding: 10px;
		    margin: 5px 0;
		    background-color: #373962;
		    color: white;
		    border: none;
		    border-radius: 6px;
		    font-weight: bold;
		    cursor: pointer;
		}
		
		.modal-content button:hover {
		    background-color: #2b2d4f;
		}

    </style>
</head>
<body>
    <jsp:include page="LoggedInHeader.jsp" />

	<div class="body-wrapper">
	    <div class="sidebar-wrapper">
	        <jsp:include page="SideBar.jsp" />
	    </div>
	
	    <div class="content-wrapper">
	        <div class="form-box">
	            <h2>Debit Amount from Account</h2>
	
	            <form id="debitForm">
	                <label for="accountId">Account ID:</label>
	                <input type="number" id="accountId" required>
	
	                <div id="infoDiv"></div>
	
	                <button type="button" onclick="checkDetails()">Check Details</button><br><br><br>
	
	                <label for="amount">Amount:</label>
	                <input type="number" id="amount" required>
	
	                <button type="button" onclick="showPasswordModal()">Submit Debit</button>
	                <div id="debit-status"></div>
	            </form>
	        </div>
	    </div>
	</div>
	
	<!-- Password Modal -->
	<div id="passwordModal" class="modal">
	    <div class="modal-content">
	        <label for="confirmPassword">Enter Password to Confirm:</label>
	        <input type="password" id="confirmPassword">
	        <button onclick="submitDebit()">Confirm</button>
	        <button onclick="closeModal()">Cancel</button>
	    </div>
	</div>

<jsp:include page="Footer.jsp" />


    <script>
        let accountDetails = null;

        function checkDetails() {
            const accountId = parseInt(document.getElementById("accountId").value);
            if (!accountId) return;

            fetch(`${pageContext.request.contextPath}/jadebank/account/details`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ accountId: accountId })
            })
            .then(res => res.ok ? res.json() : Promise.reject("Fetch failed"))
            .then(data => {
            	if (!data || !data.fullName || !data.customerId) {
                    infoDiv.textContent = "No customer data found.";
                    return;
                }
                accountDetails = data;
                document.getElementById("infoDiv").textContent = "Customer Data: Name: " + data.fullName + ", CustomerId: " + data.customerId;
            })
            .catch(err => {
                document.getElementById("infoDiv").textContent = "Account not found";
                console.error(err);
            });
        }
        
        function showPasswordModal() {
            document.getElementById("passwordModal").classList.add("show");
        }

        function closeModal() {
            document.getElementById("passwordModal").classList.remove("show");
        }


        function closeModal() {
            document.getElementById("passwordModal").style.display = "none";
            document.getElementById("confirmPassword").value = "";
        }

        function submitDebit() {
            const accountId = parseInt(document.getElementById("accountId").value);
            const amount = parseFloat(document.getElementById("amount").value);
            const password = document.getElementById("confirmPassword").value;
            const statusDiv = document.getElementById("debit-status");
            const modal = document.getElementById("passwordModal");

            if (!accountId || !amount || amount <= 0 || !password || !accountDetails) {
                statusDiv.textContent = "All fields, password, and account check are required.";
                statusDiv.style.color = "red";
                return;
            }

            const data = {
                transaction: {
                    accountId: accountId,
                    customerId: accountDetails.customerId,
                    amount: amount,
                    transactionType: 2 // 2 = Debit
                },
                user: {
                    passwordHash: password
                }
            };

            fetch(`${pageContext.request.contextPath}/jadebank/transaction/transfer`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(data)
            })
            .then(async res => {
			    modal.style.display = "none";
			    document.getElementById("confirmPassword").value = "";
			
			    const result = await res.json();
			
			    if (res.ok && result.status === "success") {
			        statusDiv.textContent = "Amount debited successfully.";
			        statusDiv.style.color = "green";
			        document.getElementById("debitForm").reset();
			        document.getElementById("infoDiv").textContent = "";
			        accountDetails = null;
			    } else {
			        statusDiv.textContent = result.error || "Debit failed.";
			        statusDiv.style.color = "red";
			    }
			})
            .catch(err => {
                modal.style.display = "none";
                document.getElementById("confirmPassword").value = "";
                statusDiv.textContent = "Network error: " + err.message;
                statusDiv.style.color = "red";
            });
        }
    </script>
</body>
</html>
