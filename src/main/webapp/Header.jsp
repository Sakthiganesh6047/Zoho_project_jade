<style>
	/* Header Styling */
	.header {
		display: flex;
	    justify-content: space-between;
	    align-items: center;
	    background-color: #ffffff00;
	    flex-wrap: nowrap;
		margin: 5px;
		position: sticky;
	    top: 0;
	}
	
	/* Logo Styling */
	.logo {
	    height: 65px; 
	}
	
	/* Right and Left Sections */
	.header-right {
		display: flex;
	    align-items: center;
	    padding: 5px 20px;
	    border: 20px;
	    border-radius: 10px;
	    background-color: white;
	    box-shadow: 0px 2px 10px #373962;
	    margin: 5px 15px 5px 5px;
	    width: 10%;
	}
	
	.header-left {
		display: flex;
	    gap: 15px;
	    padding: 5px 20px 5px 20px;
	    background-color: #373962;
	    box-shadow: 0px 2px 10px #0c0c0c;
	    height: 65px;
	    border-radius: 10px;
	    width: 90%;
	    flex-direction: row-reverse;
	}
	
	/* Button Styling */
	.button-container {
	    text-decoration: none;
	    font-weight: bold;
	    padding: 10px 20px;
	    border-radius: 25px;
	    transition: all 0.3s ease;
	    display: flex;
	    flex-direction: row;
	    flex-wrap: wrap;
	    justify-content: space-between;
	    align-items: center;
	    gap: 15px;
	}
	
	/* Login Button */
	.login-button {
		background-color: #ffffff;
	    color: #373962;
	    border: 2px solid #ffffff;
	    display: flex;
	    align-content: center;
	    align-items: center;
	    flex-wrap: wrap;
	    flex-direction: row;
	    justify-content: space-between;
	    padding: 10px;
	    border-radius: 20px;
	    text-decoration: none;
	}
	
	.login-button:hover {
	    background-color: #373962;
	    color: white;
	}
	
	/* Sign-Up Button */
	.signup-button {
		background-color: transparent;
	    color: #ffffff;
	    border: 2px solid #ffffff;
	    display: flex;
	    align-content: center;
	    align-items: center;
	    flex-wrap: wrap;
	    flex-direction: row;
	    justify-content: space-between;
	    padding: 10px;
	    border-radius: 20px;
	    text-decoration: none;
	}
	
	.signup-button:hover {
		color: #373962;
	    background-color: #ffffff;
	}

</style>

<!-- Header Section -->
<div class="header">
	<div class="header-right">
		<img src="contents/jade_bank_logo.png" alt="Jade Bank Logo" class="logo"> <!-- Logo -->
    </div>
    <div class="header-left">
    	<div class="button-container">
			<div class="login-container">
				<a href="Login.jsp" class="login-button">Login</a>
			</div>
			<div class="signup-container">
				<a href="SignUp.jsp" class="signup-button">Sign-Up</a>
			</div>
		</div>
	</div>
</div>
























