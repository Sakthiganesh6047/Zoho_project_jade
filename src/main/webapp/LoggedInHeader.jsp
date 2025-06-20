<!-- Font Awesome for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />

<style>
    .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background-color: #ffffff00;
        flex-wrap: nowrap;
        margin: 5px;
        position: sticky;
        top: 0;
        z-index: 100;
    }

    .logo {
        height: 65px;
    }

    .header-right {
        display: flex;
        align-items: center;
        padding: 5px 20px;
        border-radius: 10px;
        background-color: white;
        box-shadow: 0px 2px 10px #373962;
        margin: 5px 15px 5px 5px;
        width: 10%;
    }

    .header-left {
        display: flex;
        gap: 15px;
        padding: 5px 20px;
        background-color: #373962;
        box-shadow: 0px 2px 10px #0c0c0c;
        height: 65px;
        border-radius: 10px;
        width: 90%;
        flex-direction: row-reverse;
    }

    .button-container {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .profile-icon {
        cursor: pointer;
        font-size: 22px;
        background: white;
        padding: 8px;
        border-radius: 50%;
        border: 2px solid #373962;
        color: #373962;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .profile-box {
        display: none;
    	flex-direction: column;
        position: absolute;
        top: 70px;
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

    .profile-gender-icon i {
        font-size: 36px;
        color: #373962;
        margin-bottom: 8px;
    }

    .profile-box h4 {
        margin: 5px 0;
        color: #373962;
    }

    .profile-box p {
        font-size: 14px;
        margin: 4px 0;
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
    
    .profile-pic {
	    width: 80px;
	    height: 80px;
	    border-radius: 50%;
	    margin: 10px auto;
	    display: block;
	    object-fit: cover;
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
	    width: 100%;
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
    
</style>

<!-- Header Section -->
<div class="header">
    <div class="header-right">
        <img src="contents/jade_bank_logo.png" alt="Jade Bank Logo" class="logo">
    </div>
    <div class="header-left">
        <div class="button-container">
            <div class="profile-container">
                <!-- Profile Icon -->
				<div class="profile-icon" onclick="toggleProfile()">
                    <i class="fas fa-user"></i>
                </div>
				<!-- Profile Box -->
				<div id="profileBox" class="profile-box">
				    <img id="genderImage" src="contents/man_6997551.png" alt="Profile" class="profile-pic" />
				
				    <div class="profile-name" style="font-weight: bolder;font-size: 25px;" id="profileName">Full Name</div>
				    <div class="profile-role" id="profileRole">User Type</div>
				    <div class="profile-info" id="profileEmail">email@example.com</div>
				    <div class="profile-info" id="profilePhone">+91-9876543210</div>
				    
				    <a href="javascript:void(0)" class="profile-action" onclick="showPasswordChangeModal()">
					    <i class="fa-solid fa-key"></i> Change Password
					</a>
				    <a href="Logout.jsp" class="logout-link">
				        <i class="fa-solid fa-right-from-bracket"></i> Logout
				    </a>
				</div>
				<!-- Change Password Modal -->
				<div id="changePasswordModal" class="modal">
				    <div class="modal-content">
				        <h3 style="text-align:center;">Change Password</h3>
				        <label for="oldPassword">Old Password:</label>
				        <input type="password" id="oldPassword" required />
				
				        <label for="newPassword">New Password:</label>
				        <input type="password" id="newPassword" required />
				
				        <label for="confirmPassword">Confirm Password:</label>
				        <input type="password" id="confirmNewPassword" required />
				
				        <button onclick="submitPasswordChange()">Submit</button>
				        <button onclick="closePasswordChangeModal()" style="background-color: #ccc; margin-top: 10px;">Cancel</button>
				
				        <div id="passwordStatus" style="margin-top: 10px; text-align: center; font-weight: bold;"></div>
				    </div>
				</div>
            </div>
        </div>
    </div>
</div>

<script>
	function toggleProfile() {
	    const box = document.getElementById("profileBox");
	    box.style.display = (box.style.display === "flex") ? "none" : "flex";
	}

    document.addEventListener("click", function (e) {
        const box = document.getElementById("profileBox");
        const icon = document.querySelector(".profile-icon");
        if (!box.contains(e.target) && !icon.contains(e.target)) {
            box.style.display = "none";
        }
    });

    fetch(`${pageContext.request.contextPath}/jadebank/user/profile`)
	    .then(res => res.ok ? res.json() : Promise.reject("Failed to fetch profile"))
	    .then(profile => {
	        document.getElementById("profileName").textContent = profile.fullName || "Unknown";
	        document.getElementById("profileRole").textContent = profile.userType === 1 ? "Customer" : "Employee";
	        document.getElementById("profileEmail").textContent = ("Email: " + profile.email) || "Not provided";
	        document.getElementById("profilePhone").textContent = ("Phone No.: " + profile.phone) || "Not available";
	
	        const genderImage = document.getElementById("genderImage");
	        if (profile.gender && profile.gender.toLowerCase() === "female") {
	            genderImage.src = "contents/woman_6997664.png";
	        } else {
	            genderImage.src = "contents/man_6997551.png";
	        }
	    })
	    .catch(err => {
	        console.error("Error loading profile:", err);
	    });
    
 // Open and close modal
    function showPasswordChangeModal() {
        document.getElementById("changePasswordModal").style.display = "block";
        document.getElementById("passwordStatus").textContent = "";
    }

    function closePasswordChangeModal() {
        document.getElementById("changePasswordModal").style.display = "none";
        document.getElementById("oldPassword").value = "";
        document.getElementById("newPassword").value = "";
        document.getElementById("confirmNewPassword").value = "";
    }

    // Submit password change
    function submitPasswordChange() {
        const oldPassword = document.getElementById("oldPassword").value.trim();
        const newPassword = document.getElementById("newPassword").value.trim();
        const confirmNewPassword = document.getElementById("confirmNewPassword").value.trim();
        const statusDiv = document.getElementById("passwordStatus");

        if (!oldPassword || !newPassword || !confirmNewPassword) {
            statusDiv.textContent = "All fields are required.";
            statusDiv.style.color = "red";
            return;
        }

        if (newPassword !== confirmNewPassword) {
            statusDiv.textContent = "New and Confirm Password do not match.";
            statusDiv.style.color = "red";
            return;
        }

        fetch(`${pageContext.request.contextPath}/jadebank/user/password`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                password: oldPassword,
                newPassword: confirmNewPassword
            })
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === "success") {
                statusDiv.textContent = "Password changed successfully.";
                statusDiv.style.color = "green";
                setTimeout(() => closePasswordModal(), 2000);
            } else {
                statusDiv.textContent = data.error || "Failed to change password.";
                statusDiv.style.color = "red";
            }
        })
        .catch(err => {
            statusDiv.textContent = "Network error: " + err.message;
            statusDiv.style.color = "red";
        });
    }

</script>