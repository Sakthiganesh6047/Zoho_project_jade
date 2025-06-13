<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Signup</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Roboto+Flex:opsz,wght@8..144,100..1000&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto Flex', sans-serif;
            background-color: #f9f9f9;
            margin: 0;
        }
        .form-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 0px 40px;
        }
        .main-wrapper {
            display: flex;
            justify-content: center;
            height: 86.3vh;
            flex-direction: column;
            align-items: center;
        }
        .container-wrapper {
            display: flex;
            height: min-content;
        }
        .signuppage-container {
            display: flex;
            flex-direction: row;
            align-items: flex-end;
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
        label .required {
            color: red;
            font-size: 1.2rem;
            margin-left: 5px;
            font-weight: bold;
        }
        input[type="text"], input[type="email"], input[type="tel"], input[type="date"], input[type="password"], select {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid #bbb;
            border-radius: 8px;
            font-size: 1rem;
            box-sizing: border-box;
        }
        input:focus, select:focus {
            border-color: #007BFF;
            outline: none;
        }
        .gender-container {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }
        .proof-container {
            display: flex;
            justify-content: space-between;
            gap: 10px;
        }
        .password-container {
            display: flex;
            justify-content: space-between;
        }
        button {
            background: #373962;
            color: #fff;
            border: none;
            padding: 14px;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            font-size: 1rem;
            transition: transform 0.2s;
            font-weight: bold;
        }
        button:hover {
            transform: translateY(-3px);
        }
        h3 {
            color: #373962;
            margin: 0;
            font-size: 20px;
        }
        .signup-form {
            max-width: 420px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .required {
            color: red;
            margin-left: 2px;
        }
    </style>
</head>
<body>
<jsp:include page="LoggedInHeader.jsp" />
<div class="main-wrapper">
    <div id="signup-error" style="color: red; font-weight: bold; margin-bottom: 10px;"></div>
    <div class="container-wrapper">
        <div class="signuppage-container">
            <div class="clipart-container">
                <img src="contents/signup_page.png" alt="Sign-Up Page Image" class="signup-clipart">
            </div>
            <div class="form-container">
                <h3>New Employee Creation</h3><br>
                <form id="signup-form" class="signup-form">
                    <div class="field-container">
                        <label>Full Name:<span class="required">*</span></label>
                        <input type="text" name="user.fullName" maxlength="50" required>
                    </div>
                    <div class="field-container">
                        <label>Email:<span class="required">*</span></label>
                        <input type="email" name="user.email" maxlength="70" required>
                    </div>
                    <div class="gender-container">
                        <label>Gender:<span class="required">*</span></label>
                        <input type="radio" id="male" name="user.gender" value="Male"><label for="male">Male</label>
                        <input type="radio" id="female" name="user.gender" value="Female"><label for="female">Female</label>
                        <input type="radio" id="other" name="user.gender" value="Others"><label for="other">Others</label>
                    </div>
                    <div>
                        <label for="dob">Date of Birth:<span class="required">*</span></label>
                        <input type="date" id="dob" name="user.dob" required>
                    </div>
                    <div class="field-container">
                        <label for="phone">Phone Number:<span class="required">*</span></label>
                        <input type="tel" id="phone" name="user.phone" pattern="[0-9]{10}" maxlength="10" required>
                    </div>
                    <div class="proof-container">
                        <div class="field-container">
                            <label for="role">Role<span class="required">*</span></label>
                            <select id="role" name="employeeDetails.role" required>
                                <option value="">-- Select Role --</option>
                                <option value="1">Employee</option>
                                <option value="2">Manager</option>
                                <option value="3">Admin</option>
                            </select>
                        </div>
                        <div class="field-container">
                            <label for="branchId">Branch<span class="required">*</span></label>
                            <select id="branchId" name="employeeDetails.branchId" required>
                                <option value="">-- Select Branch --</option>
                            </select>
                        </div>
                    </div>
                    <div class="password-container">
                        <div class="field-container" style= "padding-right: 10px">
                            <label>Password:<span class="required">*</span></label>
                            <input type="password" name="user.passwordHash" maxlength="50" required>
                        </div>
                        <div class="field-container">
                            <label>Confirm Password:<span class="required">*</span></label>
                            <input type="password" name="confirmPassword" maxlength="50" required>
                        </div>
                    </div><br>
                    <div>
                        <button type="submit" class="btn">Register</button>
                    </div>
                    <br>
                </form>
            </div>
        </div>
    </div>
</div>
<jsp:include page="Footer.jsp" />

<script>
document.addEventListener("DOMContentLoaded", function () {
  // Fetch branch list and populate select box
  fetch("${pageContext.request.contextPath}/jadebank/branch/list")
	  .then(response => response.json())
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
	  .catch(error => {
	    console.error("Error fetching branch list:", error);
	  });

  // Form submit
  document.getElementById("signup-form").addEventListener("submit", function (e) {
    e.preventDefault();

    const password = document.querySelector('input[name="user.passwordHash"]').value;
    const confirmPassword = document.querySelector('input[name="confirmPassword"]').value;
    if (password !== confirmPassword) {
      document.getElementById("signup-error").textContent = "Passwords do not match.";
      return;
    }

    const gender = document.querySelector('input[name="user.gender"]:checked')?.value;
    if (!gender) {
      document.getElementById("signup-error").textContent = "Please select a gender.";
      return;
    }

    const data = {
      user: {
        fullName: document.querySelector('input[name="user.fullName"]').value,
        email: document.querySelector('input[name="user.email"]').value,
        phone: document.querySelector('input[name="user.phone"]').value,
        dob: document.querySelector('input[name="user.dob"]').value,
        userType: 2,
        gender: gender,
        passwordHash: password
      },
      employeeDetails: {
        role: document.querySelector('select[name="employeeDetails.role"]').value,
        branch: document.querySelector('select[name="employeeDetails.branchId"]').value
      }
    };

    fetch("${pageContext.request.contextPath}/jadebank/user/new", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data)
    })
      .then(async response => {
		  if (response.ok) {
		    document.getElementById("signup-error").style.color = "green";
		    document.getElementById("signup-error").textContent = "Employee created successfully.";
		
		    // Clear the form
		    document.getElementById("signup-form").reset(); // Replace with your form's ID
		  } else {
		    const errorData = await response.json();
		    document.getElementById("signup-error").style.color = "red";
		    document.getElementById("signup-error").textContent = errorData.error || "Signup failed.";
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
