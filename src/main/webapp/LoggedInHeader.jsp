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
</style>

<!-- Header -->
<div class="header">
    <div class="header-left">
        <img src="contents/jade_bank_logo.png" alt="Jade Bank Logo">
    </div>
    <div class="header-right">
        <div class="profile-icon" onclick="toggleProfile()">
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
            <button onclick="closePasswordChangeModal()" style="margin-top: 10px;">Cancel</button>
            <div id="passwordStatus" style="margin-top: 10px; text-align: center; font-weight: bold;"></div>
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
    }

    function closePasswordChangeModal() {
        document.getElementById("changePasswordModal").style.display = "none";
        ["oldPassword", "newPassword", "confirmNewPassword"].forEach(id => document.getElementById(id).value = "");
    }

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
            statusDiv.textContent = "Passwords do not match.";
            statusDiv.style.color = "red";
            return;
        }

        fetch(`${pageContext.request.contextPath}/jadebank/user/password`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ password: oldPassword, newPassword })
        })
        .then(res => res.json())
        .then(data => {
            statusDiv.textContent = data.status === "success"
                ? "Password changed successfully."
                : (data.error || "Failed to change password.");
            statusDiv.style.color = data.status === "success" ? "green" : "red";
            if (data.status === "success") setTimeout(closePasswordChangeModal, 2000);
        })
        .catch(err => {
            statusDiv.textContent = "Network error: " + err.message;
            statusDiv.style.color = "red";
        });
    }
</script>
