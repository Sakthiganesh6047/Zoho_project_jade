<style>
	.form-box {
	    padding: 30px;
	    border-radius: 16px;
	    max-width: 750px;
	}
	
	.form-box h2 {
	    text-align: center;
	    color: #1d3557;
	    font-size: 24px;
	    margin-bottom: 20px;
	}
	
	input[type="number"],
	input[type="password"] {
	    width: 100%;
	    padding: 10px;
	    margin-bottom: 16px;
	    border: 1px solid #ccc;
	    border-radius: 6px;
	}
	
	.submit-wrapper {
	    display: flex;
	    justify-content: center;
	}
	
	#debitForm button[type="button"] {
	    padding: 14px 28px;
	    font-size: 16px;
	    font-weight: 600;
	    background-color: #1d3557;
	    color: white;
	    border: none;
	    border-radius: 8px;
	    cursor: pointer;
	    transition: background 0.3s ease;
	}
	
	#debitForm button[type="button"]:hover {
	    background-color: #274c77;
	}
	
	.status-box {
	    margin-top: 16px;
	    font-weight: bold;
	    text-align: center;
	}
	
	/* Info Box */
	.info-box {
	    margin-bottom: 15px;
	    color: #1d3557;
	    background: #e3f2fd;
	    padding: 12px;
	    border-left: 4px solid #2196F3;
	    border-radius: 6px;
	}
	
	.info-box.hidden {
	    display: none;
	}
	
	/* Modal Styling */
	.modal {
	    display: none;
	    position: fixed;
	    inset: 0;
	    background-color: rgba(0, 0, 0, 0.45);
	    z-index: 2000;
	    justify-content: center;
	    align-items: center;
	    animation: fadeInBackdrop 0.3s ease;
	}
	
	.modal-content {
	    background: white;
	    padding: 24px;
	    border-radius: 16px;
	    width: 320px;
	    max-width: 90%;
	    text-align: center;
	    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
	    animation: scaleIn 0.3s ease;
	}
	
	.modal-content h3 {
	    color: #1d3557;
	    margin-bottom: 16px;
	    font-size: 18px;
	    font-weight: 600;
	}
	
	.modal-content input {
	    width: 100%;
	    padding: 10px;
	    margin-bottom: 12px;
	    border-radius: 6px;
	    border: 1px solid #ccc;
	}
	
	.modal-content .button-group {
	    display: flex;
	    justify-content: center;
	    gap: 10px;
	}
	
	.modal-content button {
	    padding: 8px 14px;
	    border: none;
	    border-radius: 6px;
	    font-size: 14px;
	    font-weight: 600;
	    cursor: pointer;
	}
	
	.modal-content button:first-child {
	    background-color: #1d3557;
	    color: white;
	}
	
	.modal-content button:last-child {
	    background-color: #e0e0e0;
	    color: #333;
	}
	
	/* Animations */
	@keyframes scaleIn {
	    from {
	        opacity: 0;
	        transform: scale(0.95);
	    }
	    to {
	        opacity: 1;
	        transform: scale(1);
	    }
	}
	
	@keyframes fadeInBackdrop {
	    from {
	        background-color: rgba(0, 0, 0, 0);
	    }
	    to {
	        background-color: rgba(0, 0, 0, 0.45);
	    }
	}
</style>
<div class="form-box">
    <h2>Debit Transaction</h2>
    <form id="debitForm">
        <label for="debitAccountId">Account ID:</label>
        <input type="text" id="debitAccountId"
         maxlength="10" required
       	pattern="\d{1,10}" title="Enter up to 10 digits only"
       	oninput="this.value = this.value.replace(/[^0-9]/g, '')"
       	onblur="fetchDebitAccountDetails()">

        <div id="debit-account-info" class="info-box hidden"></div>

        <label for="debitAmount">Amount:</label>
        <input type="number" step="0.01" name="amount" id="debitAmount" required min="0.01" max="100000" />

        <div class="submit-wrapper">
            <button type="button" onclick="openDebitPasswordModal()">Debit</button>
        </div>
        <div id="debit-status" class="status-box"></div>
    </form>
</div>

<!-- Password Modal -->
<div class="modal" id="debitPasswordModal">
    <div class="modal-content">
        <h3>Confirm Password</h3>
        <input type="password" id="debitConfirmPassword" placeholder="Enter your password">
        <div class="button-group">
            <button onclick="submitDebit()">Confirm</button>
            <button onclick="closeDebitPasswordModal()">Cancel</button>
        </div>
    </div>
</div>

<script>

    document.getElementById("debitAmount").addEventListener("keydown", function (e) {
        if (["e", "E", "+", "-"].includes(e.key) || (e.key === "." && this.value.includes("."))) {
            e.preventDefault();
        }
    });

    let debitAccountDetails = null;

    function fetchDebitAccountDetails() {
        const accountId = parseInt(document.getElementById("debitAccountId").value);
        const infoDiv = document.getElementById("debit-account-info");
        infoDiv.textContent = "";
        infoDiv.classList.add("hidden");

        if (!accountId) {
            infoDiv.textContent = "Please enter a valid account ID.";
            infoDiv.classList.remove("hidden");
            return;
        }

        fetch(`${pageContext.request.contextPath}/jadebank/account/details`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ accountId: accountId })
        })
            .then(res => res.ok ? res.json() : Promise.reject("Fetch failed"))
            .then(data => {
                if (!data || !data.fullName || !data.customerId) {
                    infoDiv.textContent = "No customer account found";
                } else {
                    debitAccountDetails = data;
                    infoDiv.textContent = "Customer: " + data.fullName + ", Customer ID: " + data.customerId;
                }
                infoDiv.classList.remove("hidden");
            })
            .catch(err => {
                infoDiv.textContent = "No customer account found";
                infoDiv.classList.remove("hidden");
                console.error(err);
            });
    }

    function openDebitPasswordModal() {
        const accountId = parseInt(document.getElementById("debitAccountId").value);
        const amount = parseFloat(document.getElementById("debitAmount").value);
        const statusDiv = document.getElementById("debit-status");

        // Clear previous status
        statusDiv.textContent = "";

        if (!accountId || accountId <= 0) {
            statusDiv.textContent = "Please enter a valid account ID.";
            statusDiv.style.color = "red";
            return;
        }

        const MAX_AMOUNT = 1000000; // 10,00,000
        
        if (!amount || isNaN(amount) || amount <= 0) {
            statusDiv.textContent = "Please enter a valid amount.";
            statusDiv.style.color = "red";
            return;
        }
        
        if (amount > MAX_AMOUNT) {
            statusDiv.textContent = "Amount must not exceed 10,00,000.";
            statusDiv.style.color = "red";
            return;
        }

        document.getElementById("debitPasswordModal").style.display = "flex";
    }

    function closeDebitPasswordModal() {
        document.getElementById("debitPasswordModal").style.display = "none";
        document.getElementById("debitConfirmPassword").value = "";
    }

    function submitDebit() {
        const accountId = parseInt(document.getElementById("debitAccountId").value);
        const amount = parseFloat(document.getElementById("debitAmount").value);
        const password = document.getElementById("debitConfirmPassword").value;
        const statusDiv = document.getElementById("debit-status");
        const infoDiv = document.getElementById("debit-account-info");
        const modal = document.getElementById("debitPasswordModal");

        statusDiv.textContent = "";

        if (!accountId || !amount || amount <= 0 || !password || !debitAccountDetails) {
            statusDiv.textContent = "All fields, password, and account check are required.";
            statusDiv.style.color = "red";
            return;
        }

        const data = {
            transaction: {
                accountId: accountId,
                customerId: debitAccountDetails.customerId,
                amount: amount,
                transactionType: 2
            },
            user: {
                passwordHash: password
            }
        };

        fetch(`${pageContext.request.contextPath}/jadebank/transaction/transfer`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
            },
            body: JSON.stringify(data)
        })
        .then(async res => {
            modal.style.display = "none";
            document.getElementById("debitConfirmPassword").value = "";

            if (res.status === 401) {
                window.location.href = `${pageContext.request.contextPath}/Login.jsp?expired=true`;
                return;
            }

            const result = await res.json();

            if (res.ok) {
                statusDiv.textContent = "Amount debited successfully.";
                statusDiv.style.color = "green";
                document.getElementById("debitForm").reset();
                document.getElementById("debit-account-info").style.display = "none";
                debitAccountDetails = null;
            } else {
                statusDiv.textContent = result.error || "Debit failed.";
                statusDiv.style.color = "red";
            }
        })
        .catch(err => {
            modal.style.display = "none";
            statusDiv.textContent = "Network error: " + err.message;
            statusDiv.style.color = "red";
        });
    }
</script>
