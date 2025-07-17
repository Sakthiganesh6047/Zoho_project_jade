<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />

<style>
    .header {
    	transition: opacity 0.2s ease-in;
    	display: flex;
	    align-items: center;
	    height: 70px;
	    position: fixed; /* changed from relative */
	    top: 0;           /* pin to top */
	    left: 0;
	    width: 100%;  
	    background: #373962;
	    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
	    z-index: 100;
	    margin-bottom: 10px;
        z-index: 100;
    }

    .header-left {
        position: relative;
	    background: white;
	    height: 100%;
	    display: flex;
	    align-items: center;
	    z-index: 1;
	    padding-left: 15px;
    }

    .header-left img {
        height: 70px;
        z-index: 10;
    }

    .header-left::after {
        content: '';
	    position: absolute;
	    right: -9px;
	    top: 0;
	    width: 50px;
	    height: 100%;
	    background: white;
	    /*transform: skewX(-25deg);*/
	    z-index: 0;
    }

    .header-right {
        flex-grow: 1;
	    height: 100%;
	    padding: 0 30px;
	    display: flex;
	    justify-content: flex-end;
	    align-items: center;
	    z-index: 0;
	}

    .profile-icon {
        font-size: 20px;
        padding: 10px;
        border-radius: 50%;
        background-color: white;
        border: 2px solid #ffffff;
        color: #414485;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .profile-icon:hover {
        background-color: #5865a6;
        color: white;
    }

    .profile-box {
        display: none;
        flex-direction: column;
        position: absolute;
        top: 90px;
        right: 30px;
        background: #fff;
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        border-radius: 10px;
        width: 250px;
        padding: 15px;
        z-index: 999;
        text-align: center;
        row-gap: 5px;
    }
    
    .profile-box {
	    opacity: 0;
	    pointer-events: none;
	    transition: opacity 0.3s ease;
	}
	.profile-box.active {
	    display: flex;
	    opacity: 1;
	    pointer-events: auto;
	    border-block: 3px solid #5c6bc0;
	    border-left: 3px solid #5c6bc0;
	    border-right: 3px solid #5c6bc0;
	}

    .profile-pic {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        margin: 10px auto;
        object-fit: cover;
    }

    .profile-box .profile-name {
        font-weight: bolder;
        font-size: 25px;
        color: #373962;
    }

    .profile-box .profile-role,
    .profile-box .profile-info {
        font-size: 14px;
        color: #555;
        margin-top: 3px;
    }

    .profile-box a {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        margin-top: 10px;
        font-weight: bold;
        color: #414485;
        text-decoration: none;
    }

    .profile-box a.logout-link {
        color: red;
    }

    .modal {
        display: none;
        position: fixed;
        z-index: 2000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.5);
    }

    .modal-content {
        background-color: #fff;
        margin: 10% auto;
        padding: 20px;
        border-radius: 10px;
        max-width: 400px;
    }

    .modal-content input {
        width: 94%;
        padding: 10px;
        margin-top: 6px;
        margin-bottom: 10px;
        border: 1px solid #ccc;
        border-radius: 6px;
    }

    .modal-content button {
        width: 100%;
        padding: 10px;
        background-color: #414485;
        color: white;
        border: none;
        border-radius: 6px;
        font-weight: bold;
    }
    
    .logout-box {
	    text-align: center;
	    margin: 0;
	    position: absolute;
	    top: 50%;
	    left: 50%;
	    transform: translate(-50%, -50%);
	    width: 350px;
	    padding: 25px;
	    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
	    background-color: #fff;
	    border-radius: 10px;
	}
	
	.logout-box h3 {
	    margin-bottom: 10px;
	    color: #373962;
	}
	
	.logout-box p {
	    font-size: 15px;
	    margin-bottom: 20px;
	    color: #444;
	}
	
	.button-group {
	    display: flex;
	    justify-content: space-between;
	    gap: 10px;
	}
	
	.button-group button {
	    flex: 1;
	    padding: 10px;
	    font-weight: bold;
	    border: none;
	    border-radius: 6px;
	    cursor: pointer;
	    transition: background 0.3s ease;
	}
	
	.confirm-btn {
	    background-color: #414485;
	    color: white;
	}
	
	.confirm-btn:hover {
	    background-color: #303268;
	}
	
	.cancel-btn {
	    background-color: #ccc;
	    color: #333;
	}
	
	.cancel-btn:hover {
	    background-color: #bbb;
	}
	
	.toggle-password {
	    position: absolute;
	    top: 41px;
	    right: 14px;
	    cursor: pointer;
	    color: #666;
	    font-size: 16px;
	}
	
	.password-field-wrapper {
	    position: relative;
	    width: 100%;
	    margin-bottom: 12px;
	}
	.password-field-wrapper input {
	    width: 87%;
	    padding-right: 40px; /* space for eye icon */
	}
	.password-field-wrapper .toggle-password {
	    position: absolute;
	    top: 50%;
	    right: 12px;
	    transform: translateY(-50%);
	    cursor: pointer;
	    color: #666;
	    font-size: 16px;
	}
	
    
</style>

<!-- Header -->
<div class="header">
    <div class="header-left">
        <img src="contents/jade_bank_logo.png" alt="Jade Bank Logo">
    </div>
    <div class="header-right">
        <div class="profile-icon" onclick="toggleProfile()" title="View Profile">
            <i class="fas fa-user"></i>
        </div>
    </div>

    <!-- Profile Dropdown -->
    <div id="profileBox" class="profile-box">
        <img id="genderImage" src="contents/man_6997551.png" alt="Profile" class="profile-pic" />
        <div class="profile-name" id="profileName">Full Name</div>
        <div class="profile-role" id="profileRole">User Type</div>
        <div class="profile-info" id="profileEmail">email@example.com</div>
        <div class="profile-info" id="profilePhone">+91-9876543210</div>
        <a href="javascript:void(0)" onclick="showPasswordChangeModal()">
            <i class="fa-solid fa-key"></i> Change Password
        </a>
        <a href="javascript:void(0);" class="logout-link" onclick="showLogoutModal()">
            <i class="fa-solid fa-right-from-bracket"></i> Logout
        </a>
    </div>

    <!-- Change Password Modal -->
    <div id="changePasswordModal" class="modal">
        <div class="modal-content">
            <h3 style="text-align:center;">Change Password</h3>
            
            <label for="oldPassword">Old Password:</label>
            <div class="password-field-wrapper">
			    <input type="password" id="oldPassword" maxlength=20 required />
			    <i class="fa-solid fa-eye toggle-password" toggle="#oldPassword"></i>
			</div>

            
            <label for="newPassword">New Password:</label>      
            <div class="password-field-wrapper">
				<input type="password" id="newPassword"
		        maxlength="20"
		        pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).{8,20}" required
		        title="Password must be 8-20 characters, include uppercase, lowercase, number, and a special character." 
		        oncopy="return false" 
		        oncut="return false" />
		    	<i class="fa-solid fa-eye toggle-password" toggle="#newPassword"></i>
			</div>
			
            <label for="confirmPassword">Confirm Password:</label>
            <div class="password-field-wrapper">
			    <input type="password" id="confirmNewPassword"
			        maxlength="20"
			        pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).{8,20}" required
			        title="Password must be 8-20 characters, include uppercase, lowercase, number, and a special character." 
			        oncopy="return false" 
			        oncut="return false" />
			    <i class="fa-solid fa-eye toggle-password" toggle="#confirmNewPassword"></i>
			</div>

            <button onclick="submitPasswordChange()">Submit</button>
            <button onclick="closePasswordChangeModal()" style="margin-top: 10px;">Cancel</button>
            <div id="passwordStatus" style="margin-top: 10px; text-align: center; font-weight: bold;"></div>
        </div>
    </div>
    
<!-- Logout Confirmation Modal -->
<div id="logoutConfirmModal" class="modal">
    <div class="modal-content logout-box">
        <h3>Confirm Logout</h3>
        <p>Are you sure you want to logout?</p>
        <div class="button-group">
            <button class="confirm-btn" onclick="confirmLogout()">Yes, Logout</button>
            <button class="cancel-btn" onclick="closeLogoutModal()">Cancel</button>
        </div>
    </div>
</div>
    
</div>

<script>
	function toggleProfile() {
	    const box = document.getElementById("profileBox");
	    box.classList.toggle("active");
	}
	
	document.addEventListener("click", function (e) {
	    const box = document.getElementById("profileBox");
	    const icon = document.querySelector(".profile-icon");
	
	    // Close only if clicked outside both icon and profile box
	    if (!box.contains(e.target) && !icon.contains(e.target)) {
	        box.classList.remove("active");
	    }
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
	
	// === New logic to detect iframe interaction ===
	const iframe = document.getElementById("content-frame"); // Change ID if needed
	
	if (iframe) {
	    iframe.addEventListener("mouseenter", () => {
	        const box = document.getElementById("profileBox");
	        box.classList.remove("active");
	    });
	}
	
	window.addEventListener("blur", () => {
	    const iframe = document.getElementById("content-frame");
	    const profileBox = document.getElementById("profileBox");

	    // If focus moved into the iframe, and the profile box is open, close it
	    if (document.activeElement === iframe && profileBox.classList.contains("active")) {
	        profileBox.classList.remove("active");
	    }
	});

    fetch(`${pageContext.request.contextPath}/jadebank/user/profile`)
        .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch profile"))
        .then(profile => {
            document.getElementById("profileName").textContent = profile.fullName || "Unknown";
            document.getElementById("profileRole").textContent = profile.userType === 1 ? "Customer" : "Employee";
            document.getElementById("profileEmail").textContent = "Email: " + (profile.email || "N/A");
            document.getElementById("profilePhone").textContent = "Phone No.: " + (profile.phone || "N/A");
            const genderImage = document.getElementById("genderImage");
            genderImage.src = profile.gender && profile.gender.toLowerCase() === "female"
                ? "contents/woman_6997664.png"
                : "contents/man_6997551.png";
        })
        .catch(err => console.error("Error loading profile:", err));

    function showPasswordChangeModal() {
        document.getElementById("changePasswordModal").style.display = "block";
        document.getElementById("passwordStatus").textContent = "";
        profileBox.classList.remove("active");
    }

    function closePasswordChangeModal() {
        document.getElementById("changePasswordModal").style.display = "none";
        ["oldPassword", "newPassword", "confirmNewPassword"].forEach(id => document.getElementById(id).value = "");
    }
    
    function showLogoutModal() {
        document.getElementById("logoutConfirmModal").style.display = "block";
    }

    function closeLogoutModal() {
        document.getElementById("logoutConfirmModal").style.display = "none";
    }

    function confirmLogout() {
        window.location.href = "Logout.jsp";
    }

    function submitPasswordChange() {
        const oldPassword = document.getElementById("oldPassword").value;
        const newPassword = document.getElementById("newPassword").value;
        const confirmNewPassword = document.getElementById("confirmNewPassword").value;
        const statusDiv = document.getElementById("passwordStatus");

        if (!oldPassword || !newPassword || !confirmNewPassword) {
            statusDiv.textContent = "All fields are required.";
            statusDiv.style.color = "red";
            return;
        }
        
        const passwordRegex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).{8,20}$/;
        
        if (newPassword === oldPassword) {
            statusDiv.textContent = "Both the entered old and new passwords are same!";
            statusDiv.style.color = "red";
            return;
        }
        
        if (!passwordRegex.test(newPassword)) {
            statusDiv.textContent = "Password must be 8-20 characters, include uppercase, lowercase, number, and a special character.";
            statusDiv.style.color = "red";
            return;
        }

        if (newPassword !== confirmNewPassword) {
            statusDiv.textContent = "New and Confirm Passwords do not match!";
            statusDiv.style.color = "red";
            return;
        }

        fetch(`${pageContext.request.contextPath}/jadebank/user/password`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
            },
            body: JSON.stringify({ password: oldPassword, newPassword })
        })
        .then(async res => {
            if (res.status === 401) {
                statusDiv.textContent = "Session expired. Redirecting to login...";
                statusDiv.style.color = "red";
                setTimeout(() => {
                    window.location.href = `${pageContext.request.contextPath}/Login.jsp?expired=true`;
                }, 2000);
                return;
            }

            const data = await res.json();
            statusDiv.textContent = data.status === "success"
                ? "Password changed successfully."
                : (data.error || "Failed to change password.");
            statusDiv.style.color = data.status === "success" ? "green" : "red";

            if (data.status === "success") {
                setTimeout(closePasswordChangeModal, 2000);
            }
        })
        .catch(err => {
            statusDiv.textContent = "Network error: " + err.message;
            statusDiv.style.color = "red";
        });

    }
</script>
