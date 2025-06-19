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
				    
				    <a href="ChangePassword.jsp" class="profile-action">
				        <i class="fa-solid fa-key"></i> Change Password
				    </a>
				    <a href="Logout.jsp" class="logout-link">
				        <i class="fa-solid fa-right-from-bracket"></i> Logout
				    </a>
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
</script>