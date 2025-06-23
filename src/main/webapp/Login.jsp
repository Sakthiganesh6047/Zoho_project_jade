<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<link href="https://fonts.googleapis.com/css2?family=Roboto+Flex:opsz,wght@8..144,100..1000&display=swap" rel="stylesheet">
    <title>JadeBank-Login</title>
    <style>
    
        body { 
        	font-family: "Roboto Flex", sans-serif; 
        	text-align: center; 
        	margin: 0px;
        }
        form { 
			width: 400px;
    		height: 200px;
        	margin: auto;
        	text-align: left;
        }
        
        .main-container {
        	display: flex;
		    flex-direction: row;
		    flex-wrap: wrap;
		    align-content: center;
		    justify-content: center;
		    align-items: center;
		    height: 70vh;
		    gap: 3%;
        }
        
        .main-wrapper {
        	height: 86.3vh;
        	display: flex;
    		flex-direction: column;
    		align-content: center;
   			justify-content: center;
        }
        
        .clipart-container {
        	display: flex;
        }
        
        .login-clipart {
        	height: 43vh;
        }
        
        .logindetails-container {
			display: flex;
		    flex-direction: column;
		    justify-content: center;
		    flex-wrap: nowrap;
		    align-items: center;
		    padding: 20px;
		    margin: 2px;
		    border-radius: 15px;
		    box-shadow: 0px 0px 6px 0px #373962;
		    gap: 25px;
        }
        
        h2 {
        	color: #373962;
        	margin: 0px;
        	font-size: 30px;
        }
        	
       .login-form {
		    max-width: 320px;
		    display: flex;
		    flex-direction: column;
		    gap: 25px;
		}
		
		.login-form label {
		    font-size: 16px;
		    font-weight: bold;
		    color: #333;
		}
		
		.email-container {
			display: flex;
			flex-direction: column;
    		gap: 10px;
		}
		
		.login-form input {
		    padding: 10px;
		    border: 1px solid #ccc;
		    border-radius: 5px;
		    background: #f8f9fa;
		    transition: border-color 0.3s ease-in-out;
		}
		
		.login-form input:focus {
		    border-color: #007bff;
		    outline: none;
		    background: #fff;
		}
		
		.btn {
		    width: 100%;
		    padding: 12px;
		    background-color: #373962;
		    color: white;
		    border: none;
		    font-weight: bold;
		    font-size: 15px;
		    border-radius: 5px;
		    cursor: pointer;
		    transition: background-color 0.3s ease-in-out;
		}

		.btn:hover {
		    background-color: #0056b3;
		}
        
    </style>
</head>
<body>
	<div>
		<jsp:include page="Header.jsp" />
	</div>
    
    <div class=main-wrapper>
    
    	<div id="login-error" style="color: red; font-weight: bold; margin-bottom: 10px;"></div>
	    <div class=main-container>
	    	<div class=clipart-container>
	    		<img src="contents/login_page_clipart.png" alt="Login Page Clipart" class=login-clipart>
	    	</div>
	    
	    	<div class=logindetails-container>
	    		<h2>Login</h2>
				<form id="login-form" class="login-form">
					<div class=email-container>
						<label for="email">Email</label>
				    	<input type="email" id="email" name="email" placeholder="Enter your email" maxlength=100 required>
					</div>
					<div class=email-container>
						<label for="password">Password</label>
				    	<input type="password" id="password" name="password" placeholder="Enter your password" maxlength=70 required>
					</div>
					<div>
						<button type="submit" class="btn">Login</button>
					</div>
				</form>
				<div>
					<p>Don't have an account? <a href="SignUp.jsp">Sign up here</a></p>
				</div>
	    	</div>
	    	<script>
		    	document.getElementById("login-form").addEventListener("submit", function(e) {
		    	    e.preventDefault(); // prevent normal form submission
	
		    	    const data = {
		    	        email: document.querySelector('input[name="email"]').value,
		    	        password: document.querySelector('input[name="password"]').value
		    	    };
	
		    	    fetch("${pageContext.request.contextPath}/login", {
		    	        method: "POST",
		    	        headers: {
		    	            "Content-Type": "application/json"
		    	        },
		    	        body: JSON.stringify(data)
		    	    })
		    	    .then(async response => {
		    	        if (response.ok) {
		    	            const responseData = await response.json();
		    	            const role = responseData.role;
	
		    	            // Redirect based on role
		    	            switch (role) {
		    	                case 0:
		    	                    window.location.href = "CustomerDashboard.jsp";
		    	                    break;
		    	                case 1:
		    	                    window.location.href = "ClerkDashboard.jsp";
		    	                    break;
		    	                case 2:
		    	                    window.location.href = "ManagerDashboard.jsp";
		    	                    break;
		    	                case 3:
		    	                    window.location.href = "AdminDashboard.jsp";
		    	                    break;
		    	                default:
		    	                    window.location.href = "Dashboard.jsp"; // fallback
		    	            }
		    	        } else {
		    	            const errorData = await response.json();
		    	            const errorMsg = errorData.error || "Login Failed";
		    	            document.getElementById("login-error").textContent = errorMsg;
		    	        }
		    	    })
		    	    .catch(err => {
		    	        document.getElementById("login-error").textContent = "An error occurred: " + err.message;
		    	    });
		    	});
			</script>
	    </div>
	</div>
	<jsp:include page="Footer.jsp" />
</body>
</html>
