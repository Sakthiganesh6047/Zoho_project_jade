<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDate"%>
<%
LocalDate today = LocalDate.now();
LocalDate minEligibleDate = today.minusYears(120); // Earliest acceptable birthdate (max 120 years old)
LocalDate maxEligibleDate = today.minusYears(18);  // Latest acceptable birthdate (at least 18 years old)
%>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Signup</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Roboto+Flex:opsz,wght@8..144,100..1000&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        body {
            margin: 0; 
		    display: flex; 
		    flex-direction: column; 
		    min-height: 93vh;
		    font-family: 'Roboto Flex', sans-serif;
		    padding-top: 70px; /* same as header height */
		    background-image: url("contents/background.png"); /* Replace with your actual path */
		    background-size: cover;        /* Scales the image to cover the whole screen */
		    background-repeat: no-repeat;  /* Prevents tiling */
		    background-position: center;
        }

        .main-wrapper {
        	display: flex;
            padding: 20px;
            flex: 1;
            flex-direction: column;
		    align-items: center;
		    justify-content: center;
        }
        
        .body-wrapper {
		    display: flex; 
		    flex: 1;
		    min-height: 70vh;
		}

        .container-wrapper {
            max-width: 900px;
            background: #fff;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .signuppage-container {
            display: flex;
            gap: 20px;
        }

        .clipart-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .signup-clipart {
            max-width: 100%;
            height: auto;
        }

        .form-container {
            flex: 1;
        }

        .field-container {
            margin-bottom: 15px;
        }

        .field-container label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
        }

        .field-container input {
            width: 95%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        
        .field-container select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .required {
            color: red;
        }

        .gender-container,
        .proof-container,
        .password-container {
            margin-bottom: 15px;
        }

        .gender-container label {
            margin-right: 15px;
        }

        .btn {
            background-color: #414485;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #155a9c;
        }
        
        .toggle-password {
		    position: absolute;
		    top: 32px;
		    right: 14px;
		    cursor: pointer;
		    color: #666;
		    font-size: 16px;
		}
    </style>
</head>
<body>
	<div class = "body-wrapper">
		<div class="main-wrapper">
		    <div id="signup-error" style="color: red; font-weight: bold; margin-bottom: 10px; display: flex; justify-content: center;"></div>
		    <div class="container-wrapper">
		        <div class="signuppage-container">
		            <div class="clipart-container">
		                <img src="contents/signup_page.png" alt="Sign-Up Page Image" class="signup-clipart">
		            </div>
		            <div class="form-container">
		                <h3 id="form-title">New Employee Creation</h3><br>
		                <form id="signup-form" class="signup-form">
		                    <input type="hidden" name="user.userId" id="userId">
		
		                    <div class="field-container">
		                        <label>Full Name:<span class="required">*</span></label>
		                        <input type="text" name="user.fullName"
						       maxlength="50"
						       pattern="^(?![\s]+$)(?=[^@]*@?[^@]*$)[A-Za-z]+(?:[ '\-@][A-Za-z]+)*$"
						       required
						       autofocus
						       title="Only letters, spaces, apostrophes, hyphens allowed, and '@' only once. No numbers or other special characters.">
		                    </div>
		                    
		                    <div class="field-container">
		                        <label>Email:<span class="required">*</span></label>
		                        <input type="email" name="user.email" maxlength="70" pattern="[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}" 
								title="Enter a valid email address (e.g., user@example.com)." required>
		                    </div>
		                    
		                    <div class="gender-container">
		                        <label>Gender:<span class="required">*</span></label>
		                        <input type="radio" id="male" name="user.gender" value="male" required title="Select your gender.">
		                        <label for="male">Male</label>
		                        
		                        <input type="radio" id="female" name="user.gender" value="female" required title="Select your gender.">
		                        <label for="female">Female</label>
		                        
		                        <input type="radio" id="other" name="user.gender" value="others" required title="Select your gender.">
		                        <label for="other">Others</label>
		                    </div>
		                    <div class="field-container">
		                        <label for="dob">Date of Birth:<span class="required">*</span></label>
		                        <input type="date" id="dob" name="user.dob"
						           min="<%=minEligibleDate%>"
						           max="<%=maxEligibleDate%>"
						           title="Age must be between 18 and 120 years." required>
		                    </div>
		                    <div class="field-container">
		                        <label for="phone">Phone Number:<span class="required">*</span></label>
		                        <input type="tel" id="phone" name="user.phone"
						           pattern="^[6-9][0-9]{9}$"
						           inputmode="numeric" maxlength="10"
						           title="Phone number must start with 6, 7, 8, or 9 and be exactly 10 digits."
						           required>
		                    </div>
		                    <div class="proof-container">
		                        <div class="field-container">
		                            <label for="role">Role<span class="required">*</span></label>
		                            <select id="role" name="employeeDetails.role" required>
		                                <option value="">-- Select Role --</option>
		                                <option value="1">Clerk</option>
		                                <option value="2">Manager</option>
		                                <option value="3">General Manager</option>
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
							    <div class="field-container" style="position: relative;">
							        <label>Password:<span class="required">*</span></label>
							        <input type="password" id="password" name="user.passwordHash" maxlength="20"
									pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).{8,20}" required
							 		title="Password must be 8-20 characters, include uppercase, lowercase, number, and a special character." oncopy="return false" oncut="return false">
							    </div>
							
							    <div class="field-container" style="position: relative;">
							        <label>Confirm Password:<span class="required">*</span></label>
							        <input type="password" id="confirmPassword" name="confirmPassword" maxlength="20"
						        pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).{8,20}" required
							 	title="Must match the new password." oncopy="return false" required oncopy="return false" oncut="return false" onpaste="return false">
							        <i class="fa-solid fa-eye toggle-password" toggle="#confirmPassword"></i>
							    </div>
							</div><br>
		                    <div>
		                        <button type="submit" class="btn" id="form-submit-btn">Register</button>
		                    </div>
		                    <br>
		                </form>
		            </div>
		        </div>
		    </div>
		</div>
		
	</div>
	<jsp:include page="Footer.jsp" />

<script>
document.addEventListener("DOMContentLoaded", function () {
    const urlParams = new URLSearchParams(window.location.search);
    const employeeId = urlParams.get("userId");

    // Load branch list
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

    // Edit mode: populate form
    if (employeeId) {
        document.getElementById("form-title").textContent = "Edit Employee";
        document.getElementById("form-submit-btn").textContent = "Update";

        fetch(`${pageContext.request.contextPath}/jadebank/user/id`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
				userId: employeeId
            })
        })
            .then(response => response.json())
            .then(data => {
            	const user = data.user;
            	const emp = data.employeeDetails;

            	document.getElementById("userId").value = user.userId || "";
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

            	if (!found) {
            	    console.warn("No matching gender input found for:", gender);
            	}

            	document.querySelector('select[name="employeeDetails.role"]').value = emp.role || "";
            	document.querySelector('select[name="employeeDetails.branchId"]').value = emp.branch || "";


                // Hide password section in edit mode
                document.querySelectorAll('.password-container').forEach(el => el.style.display = "none");
                document.getElementById("password").removeAttribute("required");
                document.getElementById("confirmPassword").removeAttribute("required");
            })
            .catch(err => {
                console.error("Failed to fetch employee data:", err);
                document.getElementById("signup-error").textContent = "Failed to load employee data.";
            });
    }

    // Submit handler
    document.getElementById("signup-form").addEventListener("submit", function (e) {
        e.preventDefault();

        const gender = document.querySelector('input[name="user.gender"]:checked')?.value;
        if (!gender) {
            document.getElementById("signup-error").textContent = "Please select a gender.";
            return;
        }

        const password = document.querySelector('input[name="user.passwordHash"]')?.value;
        const confirmPassword = document.querySelector('input[name="confirmPassword"]')?.value;
        if (!employeeId && password !== confirmPassword) {
            document.getElementById("signup-error").textContent = "Passwords do not match.";
            return;
        }
        
        const userPayload = {
        	    userId: employeeId,
        	    fullName: document.querySelector('input[name="user.fullName"]').value,
        	    email: document.querySelector('input[name="user.email"]').value,
        	    phone: document.querySelector('input[name="user.phone"]').value,
        	    dob: document.querySelector('input[name="user.dob"]').value,
        	    userType: 2,
        	    gender: gender
        	};

        	if (!employeeId) {
        	    userPayload.passwordHash = password;
        	}

        const data = {
        	    user: userPayload,
        	    employeeDetails: {
        	        role: document.querySelector('select[name="employeeDetails.role"]').value,
        	        branch: document.querySelector('select[name="employeeDetails.branchId"]').value
        	    }
        	};

        const isEdit = !!employeeId;
        const endpoint = isEdit ? "update" : "new";

        fetch(`${pageContext.request.contextPath}/jadebank/user/` + endpoint, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
            },
            body: JSON.stringify(data)
        })
        .then(async response => {
            if (response.status === 401) {
                window.location.href = `${pageContext.request.contextPath}/Login.jsp?expired=true`;
                return;
            }

            const errorElement = document.getElementById("signup-error");

            if (response.ok) {
                errorElement.style.color = "green";
                errorElement.textContent = isEdit
                    ? "Employee updated successfully."
                    : "Employee created successfully.";

                if (!isEdit) {
                    document.getElementById("signup-form").reset();
                }

                if (isEdit && window.parent && typeof window.parent.loadUserProfile === "function") {
                    window.parent.loadUserProfile();
                }
            } else {
                const errorData = await response.json();
                errorElement.style.color = "red";
                errorElement.textContent = errorData.error || "Operation failed.";
            }
        })
        .catch(err => {
            const errorElement = document.getElementById("signup-error");
            errorElement.style.color = "red";
            errorElement.textContent = "An error occurred: " + err.message;
        });

    });
});
document.querySelectorAll('.toggle-password').forEach(function (icon) {
    icon.addEventListener('click', function () {
        const input = document.querySelector(icon.getAttribute('toggle'));
        const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
        input.setAttribute('type', type);
        icon.classList.toggle('fa-eye');
        icon.classList.toggle('fa-eye-slash');
    });
});
document.querySelector('input[name="user.fullName"]').addEventListener('input', function (e) {
	  const value = this.value;

	  // Allow letters, spaces, hyphens, apostrophes, and ONE @
	  // Remove all invalid characters
	  let cleaned = value.replace(/[^A-Za-z\s\-@']/g, '');

	  // Ensure only one @ is present
	  const atCount = (cleaned.match(/@/g) || []).length;
	  if (atCount > 1) {
	    // Remove all but the first @
	    let firstAtIndex = cleaned.indexOf('@');
	    cleaned = cleaned.slice(0, firstAtIndex + 1) + cleaned.slice(firstAtIndex + 1).replace(/@/g, '');
	  }

	  this.value = cleaned;
	});

function allowOnlyDigits(e) {
	    e.target.value = e.target.value.replace(/\D/g, '');
	  }

	  document.getElementById('phone').addEventListener('input', allowOnlyDigits);
	  document.getElementById('aadhar').addEventListener('input', allowOnlyDigits);
</script>

</body>
</html>
