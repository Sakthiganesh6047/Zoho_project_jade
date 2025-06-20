<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sign Up</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto+Flex:opsz,wght@8..144,100..1000&display=swap" rel="stylesheet">
    <style>
    
    	body {
			margin: 0; 
		    display: flex; 
		    flex-direction: column; 
		    min-height: 100vh;
		    font-family: 'Roboto Flex', sans-serif;
		}
		
		.body-wrapper {
		    display: flex; 
		    flex: 1;
		    min-height: 70vh;
		}
		
		.sidebar-wrapper {
		    width: 60px;
		    border-radius: 0 12px 12px 0;
		    background-color: #373962; /* Dark sidebar */
		    color: white;
		    height: 100vh;
		    position: fixed;
		    left: 0;
		    z-index: 1000;
		}
		
		.main-wrapper {
		    margin-left: 70px; /* Push content away from sidebar */
		    padding: 20px;
		    flex: 1;
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    flex-direction: column;
		}
		
		.form-container {
			display: flex;
			flex-direction: column;
    		align-items: center;
    		padding: 0px 40px 0px 40px;
		}
        
        .container-wrapper {
        	display: flex;
        	height: min-content;
        }
		
		.signuppage-container {
			display: flex;
			flex-direction: row;
		    align-items: center;
		    flex-wrap: nowrap;
		    justify-content: center;
		    border-radius: 10px;
		    box-shadow: 0px 0px 6px 0px #373962;
		}
		
		.clipart-container {
			display: flex;
		}
		
		.signup-clipart {
			height: 840px;
    		width: 600px;
		}
    
      label {
		    font-weight: 600;
		    color: #555;
		    margin-bottom: 5px;
		    display: block;
		}
		
		label span.required {
		    color: red !important;
		}
		
		
		label .required {
		    color: red !important;
		    font-size: 1.2rem;
		    margin-left: 5px;
		    font-weight: bold;
		}
		
		input[type="text"], 
		input[type="email"], 
		input[type="tel"], 
		input[type="date"], 
		input[type="password"],
		textarea {
		    width: 100%;
		    padding: 12px;
		    margin-bottom: 15px;
		    border: 1px solid #bbb;
		    border-radius: 8px;
		    font-size: 1rem;
		    box-sizing: border-box;
		}
		
		input:focus, textarea:focus {
		    border-color: #007BFF;
		    outline: none;
		}
		
		#address {
		    resize: none;
		}
		
		.gender-container, .checkbox-container {
		    display: flex;
		    align-items: center;
		    gap: 15px;
		    margin-bottom: 15px;
		}
		
		.gender-container label, .checkbox-container label {
		    margin: 0;
		}
		
		.proof-container {
			display: flex;
			flex-direction: row;
		    justify-content: space-between;
		    gap: 10px;
		}
		
		.password-container {
			display: flex;
			justify-content: space-between;
		}
		
		button {
		    background: #373962;;
		    color: #fff;
		    border: none;
		    padding: 14px;
		    border-radius: 8px;
		    cursor: pointer;
		    width: 100%;
		    font-size: 1rem;
		    transition: transform 0.2s;
		    text-align: center;
		    display: inline-block;
		    text-decoration: none;
		    text-transform: uppercase;
		    font-weight: bold;
		}
		
		button:hover {
		    transform: translateY(-3px);
		}
        
        h3 {
        	color: #373962;
        	margin: 0px;
        	font-size: 20px;
        }
        	
       .login-form {
		    max-width: 320px;
		    display: flex;
		    flex-direction: column;
		    gap: 25px;
		}
		
		.signup-form label {
		    font-size: 16px;
		    font-weight: bold;
		    color: #333;
		}
		
		.email-container {
			display: flex;
			flex-direction: column;
    		gap: 10px;
		}
		
		.signup-form input {
		    padding: 10px;
		    border: 1px solid #ccc;
		    border-radius: 5px;
		    background: #f8f9fa;
		    transition: border-color 0.3s ease-in-out;
		}
		
		.signup-form input:focus {
		    border-color: #007bff;
		    outline: none;
		    background: #fff;
		}
        
        .btn:hover { 
        	background-color: #218838; 
        }
        
    </style>
</head>
<body>
	<jsp:include page="LoggedInHeader.jsp" />
	
	<div class="body-wrapper">
	
		<div class="sidebar-wrapper">
			<jsp:include page="SideBar.jsp" />
		</div>
		
		<div class=main-wrapper>
		
			<div id="signup-error" style="color: red; font-weight: bold; margin-bottom: 10px;"></div>
			<div class=container-wrapper>
			
				<div class=signuppage-container>
					<div class=clipart-container>
			    		<img src="contents/signup_page.png" alt="Sign-Up Page Image" class=signup-clipart>
			    	</div>
			    	
					<div class=form-container>
						<h3 id="form-title">Create an User Account</h3><br>
					    <form 
					    		id="signup-form"
	    						class="signup-form">
	    						
							<input type="hidden" id="userId" name="user.userId">
					    	
					    	<div class=field-container>
						    	<label>Full Name:<span class="required">*</span></label>
						        <input type="text" name="user.fullName" maxlength="50" required>
					    	</div>
					        
					        <div class=field-container>
						        <label>Email:<span class="required">*</span></label>
						        <input type="email" name="user.email" maxlength="70" required>
					        </div>
					        
					        <div class="gender-container">
						        <label>Gender:<span class="required">*</span></label>
						        <input type="radio" id="male" name="user.gender" value="male">
						        <label for="male">Male</label>
						        
						        <input type="radio" id="female" name="user.gender" value="female">
						        <label for="female">Female</label>
						
						        <input type="radio" id="other" name="user.gender" value="others">
						        <label for="other">Others</label>
						    </div>
						    
						    <div>
						    	<label for="dob">Date of Birth:<span class="required">*</span></label>
					        	<input type="date" id="dob" name="user.dob" required>
						    </div>
						    
						    <div class=field-container>
								<label for="phone">Phone Number:<span class="required">*</span></label>
								<input type="tel" id="phone" name="user.phone" pattern="[0-9]{10}" inputmode="numeric" maxlength="10" required>
						    </div>
						    
							<div class=proof-container>
							    <div class=field-container>
									<label for="phone">Aadhar Card Number:<span class="required">*</span></label>
									<input type="tel" id="aadhar" name="customerDetails.aadharNumber" pattern="[0-9]{12}" inputmode="numeric" maxlength="12" required>
							    </div>
							    
							    <div class=field-container>
							        <label>PAN Card Number:<span class="required">*</span></label>
							        <input type="text" name="customerDetails.panId" maxlength="10" required>
						        </div>
							</div>
						    
						    <div class=field-container>
						    	<label for="address">Address:<span class="required">*</span></label>
					        	<textarea id="address" name="customerDetails.address" rows="3" maxlength="50" required></textarea>
					        </div>
					        
					        <div id="password-section" class=password-container>
						        <div class=field-container>
							        <label>Password:<span class="required">*</span></label>
							        <input type="password" name="user.passwordHash" maxlength="50" required>
						        </div>
						        
						        <div class=field-container>
									<label>Confirm Password:<span class="required">*</span></label>
									<input type="password" name="confirmPassword" maxlength="50" required>
						        </div>
							</div><br>
					        
					        <div>
					        	<button type="submit" class="btn" id="submit-btn">Register</button>
					        </div>
					    </form>
				    </div>
				</div>
			</div>
		</div>
	</div>
	
	<jsp:include page="Footer.jsp" />
	
	<script>
		document.addEventListener("DOMContentLoaded", async function () {
		    const urlParams = new URLSearchParams(window.location.search);
		    const userId = urlParams.get("userId");
	
		    const titleElement = document.getElementById("form-title");
		    const submitBtn = document.getElementById("submit-btn");
	
		    if (userId) {
		        // Set heading and button text
		        if (titleElement) titleElement.textContent = "Update User Account";
		        if (submitBtn) submitBtn.textContent = "Update";
	
		        // Remove password section in edit mode
		        const pwdSection = document.getElementById("password-section");
		        if (pwdSection) pwdSection.remove();
	
		        try {
		            const response = await fetch(`${pageContext.request.contextPath}/jadebank/user/id`, {
		                method: "POST",
		                headers: {
		                    "Content-Type": "application/json"
		                },
		                body: JSON.stringify({ userId: Number(userId) })
		            });
	
		            if (!response.ok) throw new Error("Failed to fetch user details");
	
		            const data = await response.json();
		            const user = data.user || {};
		            const customer = data.customerDetails || {};
	
		            // Fill form fields
		            document.querySelector('input[name="user.fullName"]').value = user.fullName || "";
		            document.querySelector('input[name="user.email"]').value = user.email || "";
		            document.querySelector('input[name="user.phone"]').value = user.phone || "";
		            document.querySelector('input[name="user.dob"]').value = user.dob || "";
	
		            const gender = (data.user.gender || "").toLowerCase();
	            	const genderInputs = document.querySelectorAll('input[name="user.gender"]');

	            	let found = false;
	            	genderInputs.forEach(input => {
	            	    if (input.value.toLowerCase() === gender) {
	            	        input.checked = true;
	            	        found = true;
	            	    }
	            	});
	
		            document.querySelector('input[name="customerDetails.aadharNumber"]').value = customer.aadharNumber || "";
		            document.querySelector('input[name="customerDetails.panId"]').value = customer.panId || "";
		            document.querySelector('textarea[name="customerDetails.address"]').value = customer.address || "";
	
		        } catch (err) {
		            document.getElementById("signup-error").textContent = "Error loading data: " + err.message;
		        }
		    }
		
		    // Form Submit Handler
		    document.getElementById("signup-form").addEventListener("submit", function (e) {
		        e.preventDefault(); // prevent normal form submission
		
		        const password = document.querySelector('input[name="user.passwordHash"]')?.value;
		        const confirmPassword = document.querySelector('input[name="confirmPassword"]')?.value;
		
		        if (!userId && password !== confirmPassword) {
		            document.getElementById("signup-error").textContent = "Passwords do not match.";
		            return;
		        }
		
		        const userData = {
		            fullName: document.querySelector('input[name="user.fullName"]').value,
		            email: document.querySelector('input[name="user.email"]').value,
		            phone: document.querySelector('input[name="user.phone"]').value,
		            dob: document.querySelector('input[name="user.dob"]').value,
		            gender: document.querySelector('input[name="user.gender"]:checked')?.value,
		            userType: 1
		        };
		
		        if (!userId) {
		            userData.passwordHash = password;
		        } else {
		            userData.userId = Number(userId);
		        }
		
		        const data = {
		            user: userData,
		            customerDetails: {
		                aadharNumber: document.querySelector('input[name="customerDetails.aadharNumber"]').value,
		                panId: document.querySelector('input[name="customerDetails.panId"]').value,
		                address: document.querySelector('textarea[name="customerDetails.address"]').value
		            }
		        };
		
		        const endpoint = userId
		            ? `${pageContext.request.contextPath}/jadebank/user/update`
		            : `${pageContext.request.contextPath}/jadebank/user/new`;
		
		        fetch(endpoint, {
		            method: "POST",
		            headers: {
		                "Content-Type": "application/json"
		            },
		            body: JSON.stringify(data)
		        })
		        .then(async response => {
				    if (response.ok) {
				        const successMsg = userId ? "User updated successfully." : "User created successfully.";
				        document.getElementById("signup-error").style.color = "green";
				        document.getElementById("signup-error").textContent = successMsg;
				    } else {
				        const errorData = await response.json();
				        const errorMsg = errorData.error || "Operation failed.";
				        document.getElementById("signup-error").style.color = "red";
				        document.getElementById("signup-error").textContent = errorMsg;
				    }
				})
		        .catch(err => {
		            document.getElementById("signup-error").textContent = "An error occurred: " + err.message;
		        });
		    });
		});
	</script>
</body>
</html>
