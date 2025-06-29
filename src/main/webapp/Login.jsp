<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<link href="https://fonts.googleapis.com/css2?family=Roboto+Flex:opsz,wght@8..144,100..1000&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />
    <title>JadeBank-Login</title>
    <style>
    
        body { 
        	font-family: "Roboto Flex", sans-serif; 
        	text-align: center; 
        	margin: 0px;
        	background-image: url("contents/background.png"); /* Replace with your actual path */
		    background-size: cover;        /* Scales the image to cover the whole screen */
		    background-repeat: no-repeat;  /* Prevents tiling */
		    background-position: center;
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
		    height: 95vh;
		    gap: 3%;
        }
        
        .main-wrapper {
        	height: 95vh;
        	display: flex;
    		flex-direction: column;
    		align-content: center;
   			justify-content: center;
        }
        
        .content-container{
        	display: flex;
        	gap: 30px;
		    padding: 20px;
		    background: white;
		    border-radius: 20px;
		    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
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
        	
       .login-form input,
		.login-form .input-group {
			max-width: 100%;
			width: 100%;
			box-sizing: border-box;
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
    		margin-bottom: 20px;
		}
		
		.password-container{
			display: flex;
			flex-direction: column;
    		gap: 10px;
    		margin-bottom: 20px;
		}
		
		.input-group {
			position: relative;
		}
		.input-group input {
			width: 100%;
			padding: 10px 38px 10px 10px; /* Leave space for the eye icon */
			border: 1px solid #ccc;
			border-radius: 5px;
			background: #f8f9fa;
			transition: border-color 0.3s;
		}
		.input-group input:focus {
			border-color: #414485;
			background: #fff;
			outline: none;
		}
		.input-group .toggle-password {
			position: absolute;
			right: 10px;
			top: 50%;
			transform: translateY(-50%);
			cursor: pointer;
			color: #888;
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
    
    <div class=main-wrapper>
    
	    <div class=main-container>
	    	<div>
	    		<div>
	    			<div id="login-error" style="color: red; font-weight: bold; margin-bottom: 10px;"></div>
	    		</div>
	    		<div class="content-container">
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
							<div class="password-container">
								<label for="password">Password</label>
								<div class="input-group">
									<input type="password" id="password" name="password" placeholder="Enter your password" maxlength="70" required>
									<i class="fas fa-eye toggle-password" id="togglePassword"></i>
								</div>
							</div>
							<div>
								<button type="submit" class="btn">Login</button>
							</div>
						</form>
						<div>
							<p>Don't have an account? <a href="SignUp.jsp">Sign up here</a></p>
						</div>
			    	</div>
			    </div>
	    	</div>
	    	<script>
	    	
		    	// Password toggle
				const togglePassword = document.getElementById("togglePassword");
				const passwordInput = document.getElementById("password");
	
				togglePassword.addEventListener("click", function () {
					const type = passwordInput.getAttribute("type") === "password" ? "text" : "password";
					passwordInput.setAttribute("type", type);
					this.classList.toggle("fa-eye");
					this.classList.toggle("fa-eye-slash");
				});
	    	
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
		    	                    window.location.href = "DashboardShell.jsp?page=CustomerDashboard.jsp";
		    	                    break;
		    	                case 1:
		    	                    window.location.href = "DashboardShell.jsp?page=ClerkDashboard.jsp";
		    	                    break;
		    	                case 2:
		    	                    window.location.href = "DashboardShell.jsp?page=ManagerDashboard.jsp";
		    	                    break;
		    	                case 3:
		    	                    window.location.href = "DashboardShell.jsp?page=AdminDashboard.jsp";
		    	                    break;
		    	                default:
		    	                    window.location.href = "DashboardShell.jsp"; // fallback
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
<script>
if (window.top !== window.self) {
    // We are inside an iframe — break out!
    window.top.location = window.location.href;
}
</script>
</body>
</html>
