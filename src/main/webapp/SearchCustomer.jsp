<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Branch Accounts</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        body {
            transition: opacity 0.2s ease-in;
            font-family: "Roboto", sans-serif;
            background-image: url("contents/background.png");
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            margin: 0;
            padding-top: 70px;
        }

        .body-wrapper {
            display: flex;
            min-height: 89vh;
        }

        .main-wrapper {
            margin-left: 20px;
            padding: 30px;
            flex: 1;
            transition: margin-left 0.3s ease;
        }

        .sidebar.expanded ~ .main-wrapper {
            margin-left: 220px;
        }

        .page-title-wrapper {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .page-title {
            font-size: 26px;
            font-weight: 700;
            color: #2e2f60;
            background: linear-gradient(to right, #e0e7ff, #f4f4fb);
            border-left: 6px solid #414485;
            padding: 10px 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 0px;
            margin-top: 0px;
        }
        
        .input-wrapper {
		    display: flex;
		    align-items: center;
		    gap: 16px;
		    padding: 16px 20px;
		    background: #f9f9ff;
		    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
		    margin: auto;
		    width: max-content;
		    justify-content: center;
		}
		
		.input-wrapper label {
		    font-size: 15px;
		    font-weight: 600;
		    color: #2e2f60;
		    white-space: nowrap;
		}
		
		.input-wrapper input {
		    padding: 10px 16px;
		    font-size: 14px;
		    border-radius: 8px;
		    border: 1px solid #ccc;
		    flex: 1;
		    transition: 0.2s ease;
		}
		
		.input-wrapper input:focus {
		    outline: none;
		    border-color: #414485;
		    box-shadow: 0 0 4px rgba(65, 68, 133, 0.3);
		}
		
		.input-wrapper .error {
		    margin-left: auto;
		    font-size: 13px;
		    color: red;
		    font-weight: 500;
		}

	    #profileCard.container {
		    display: flex;
		    background: #ffffffdd;
		    border-radius: 16px;
		    padding: 30px;
		    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
		    margin-top: 20px;
		    gap: 30px;
		    width: 1200px;
		    margin-left: 15%
		}
		
		.profile-image {
		    flex: 0 0 150px;
		    text-align: center;
		    padding-right: 24px;
		    border-right: 1px solid #e0e0e0;
		}
		
		.profile-image img {
		    width: 120px;
		    height: 120px;
		    border-radius: 50%;
		    object-fit: cover;
		    border: 4px solid #cdd1ff;
		    box-shadow: 0 0 10px rgba(65, 68, 133, 0.2);
		}
		
		.profile-image h2 {
		    margin-top: 12px;
		    font-size: 18px;
		    color: #2e2f60;
		    font-weight: 600;
		}
		
		.profile-info {
		    flex: 1;
		    display: flex;
		    flex-direction: column;
		    gap: 16px;
		}
		
		.section {
		    display: flex;
		    flex-wrap: wrap;
		    gap: 20px;
		    margin-bottom: 16px;
		    border-bottom: 1px solid #f0f0f0;
		    padding-bottom: 10px;
		}
		
		.info-item {
		    width: calc(33% - 20px);
		}
		
		.info-item label {
		    font-size: 13px;
		    color: #777;
		    font-weight: 500;
		}
		
		.info-item div {
		    font-size: 15px;
		    color: #222;
		    font-weight: 500;
		    margin-top: 4px;
		}
		
		.edit-btn {
		    align-self: flex-start;
		    margin-top: 10px;
		    padding: 10px 24px;
		    font-size: 15px;
		    font-weight: 600;
		    background-color: #414485;
		    color: white;
		    border: none;
		    border-radius: 8px;
		    cursor: pointer;
		    transition: background-color 0.3s ease;
		}
		
		.edit-btn:hover {
		    background-color: #2e2f60;
		}

    /* Modal styles */
    .modal {
        position: fixed;
        top: 0; left: 0; right: 0; bottom: 0;
        background: rgba(0, 0, 0, 0.6);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 9999;
    }

    .modal-content {
        background: white;
        padding: 30px;
        border-radius: 12px;
        width: 500px;
        max-width: 90%;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
        position: relative;
    }

    .modal-content .close {
        position: absolute;
        top: 10px;
        right: 20px;
        font-size: 24px;
        cursor: pointer;
        color: #333;
    }

    .modal-content h2 {
        margin-top: 0;
        margin-bottom: 20px;
        text-align: center;
        font-size: 22px;
        color: #2e2f60;
    }

    .modal-content form {
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .modal-content form label {
        margin-top: 10px;
        align-self: flex-start;
        font-size: 14px;
        font-weight: 600;
        color: #333;
    }

    .modal-content form input,
    .modal-content form textarea,
    .modal-content form select {
        width: 95%;
        padding: 10px;
        margin-top: 4px;
        margin-bottom: 12px;
        border-radius: 8px;
        border: 1px solid #ccc;
        font-size: 14px;
        transition: 0.2s ease-in-out;
    }
    
    .modal-content form select {
        width: 100%;
        padding: 10px;
        margin-top: 4px;
        margin-bottom: 12px;
        border-radius: 8px;
        border: 1px solid #ccc;
        font-size: 14px;
        transition: 0.2s ease-in-out;
    }

    .modal-content form input:focus,
    .modal-content form textarea:focus,
    .modal-content form select:focus {
        border-color: #414485;
        outline: none;
        box-shadow: 0 0 4px #cdd1ff;
    }

    .modal-content form textarea {
        height: 100px;
        resize: none;
    }

    .modal-content form button[type="submit"] {
        background-color: #414485;
        color: white;
        padding: 10px 24px;
        font-size: 15px;
        font-weight: 600;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: 0.3s;
    }

    .modal-content form button[type="submit"]:hover {
        background-color: #2f2f6b;
    }
    
    #statusMessage.success {
	    background-color: #d1e7dd;
	    color: #0f5132;
	    border: 1px solid #badbcc;
	    width: max-content;
	    margin: auto;
	}
	
	#statusMessage.error {
	    background-color: #f8d7da;
	    color: #842029;
	    border: 1px solid #f5c2c7;
	}
    
    </style>
</head>
<body>

<div class="body-wrapper">
    <div class="main-wrapper">
        <div class="page-title-wrapper">
            <h2 class="page-title">Search Customer</h2>
        </div>
		<div class="input-wrapper">
	        <label for="phone">Customer Phone Number:</label>
	        <input type="text" id="phone" name="phone" placeholder="Enter phone number..." onblur="fetchUserProfile()">
	        <div class="error" id="errorMsg"></div>
	    </div>
	    
	    <div id="statusMessage" style="display:none; padding: 12px 18px; margin-top: 20px; border-radius: 8px; font-weight: 500;"></div>

		<div id="profileCard" class="container" style="display: none;">
		    <div class="profile-image">
		        <img id="profilePic" src="" alt="Profile Picture">
		        <h2 id="fullName">Name</h2>
		    </div>
		    <div class="profile-info">
		        <div class="section">
		            <div class="info-item"><label>Email</label><div id="email">-</div></div>
		            <div class="info-item"><label>Phone</label><div id="phoneDisplay">-</div></div>
		            <div class="info-item"><label>Gender</label><div id="gender">-</div></div>
		            <div class="info-item"><label>Date of Birth</label><div id="dob">-</div></div>
		            <div class="info-item"><label>User ID</label><div id="userId">-</div></div>
		        </div>
		
		        <div class="section">
		            <div class="info-item"><label>Customer ID</label><div id="customerId">-</div></div>
		            <div class="info-item"><label>Aadhar Number</label><div id="aadhar">-</div></div>
		            <div class="info-item"><label>PAN ID</label><div id="pan">-</div></div>
		            <div class="info-item" style="width: 100%;"><label>Address</label><div id="address">-</div></div>
		        </div>
		
		        <button class="edit-btn" onclick="editProfile()">Edit Profile</button>
		    </div>
		</div>
    </div>
</div>

<jsp:include page="Footer.jsp" />


<!-- Edit Profile Modal -->
<div id="editProfileModal" class="modal" style="display:none;">
  <div class="modal-content">
    <span class="close" onclick="closeModal()">&times;</span>
    <h2>Edit Profile</h2>
    <form id="edit-profile-form">
      <input type="hidden" name="user.userId" id="editUserId">

      <label>Full Name</label>
      <input type="text" name="user.fullName" id="editFullName" required>

      <label>Email</label>
      <input type="email" name="user.email" id="editEmail" required>

      <label>Gender</label>
      <select id="editGender" name="user.gender">
        <option value="male">Male</option>
        <option value="female">Female</option>
        <option value="others">Others</option>
      </select>

      <label>Date of Birth</label>
      <input type="date" name="user.dob" id="editDob" required>

      <label>Phone</label>
      <input type="tel" name="user.phone" id="editPhone" required pattern="[0-9]{10}">

      <label>Aadhar Number</label>
      <input type="text" name="customerDetails.aadharNumber" id="editAadhar" required pattern="[0-9]{12}">

      <label>PAN ID</label>
      <input type="text" name="customerDetails.panId" id="editPan" required>

      <label>Address</label>
      <textarea name="customerDetails.address" id="editAddress" required></textarea>

      <button type="submit">Save Changes</button>
    </form>
  </div>
</div>

<script>
    let currentProfileData = null;

    function fetchUserProfile() {
        const phone = document.getElementById("phone").value.trim();
        const errorMsg = document.getElementById("errorMsg");
        const profileCard = document.getElementById("profileCard");

        if (!phone || phone.length < 10) {
            errorMsg.textContent = "Please enter a valid phone number.";
            profileCard.style.display = "none";
            return;
        }

        errorMsg.textContent = "Fetching user details...";

        fetch("<%= request.getContextPath() %>/jadebank/user/details", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ phone })
        })
        .then(res => res.ok ? res.json() : Promise.reject("User not found"))
        .then(data => {
            currentProfileData = data;
            const user = data.user;
            const customer = data.customerDetails;

            document.getElementById("fullName").textContent = user.fullName || "-";
            document.getElementById("email").textContent = user.email || "-";
            document.getElementById("phoneDisplay").textContent = user.phone || "-";
            document.getElementById("dob").textContent = user.dob || "-";
            document.getElementById("gender").textContent = user.gender || "-";
            document.getElementById("userId").textContent = user.userId || "-";

            document.getElementById("profilePic").src =
                user.gender === "Male" ? "https://cdn-icons-png.flaticon.com/512/3135/3135715.png" :
                user.gender === "Female" ? "https://cdn-icons-png.flaticon.com/512/3135/3135789.png" :
                "https://cdn-icons-png.flaticon.com/512/747/747376.png";

            document.getElementById("customerId").textContent = customer?.customerId || "-";
            document.getElementById("aadhar").textContent = customer?.aadharNumber || "-";
            document.getElementById("pan").textContent = customer?.panId || "-";
            document.getElementById("address").textContent = customer?.address || "-";

            errorMsg.textContent = "";
            profileCard.style.display = "flex";
        })
        .catch(err => {
            console.error(err);
            errorMsg.textContent = "User not found or error occurred.";
            profileCard.style.display = "none";
        });
    }

    function editProfile() {
        if (currentProfileData) {
            openEditModal(currentProfileData);
        } else {
            alert("Please search for a user first.");
        }
    }

    function openEditModal(data) {
        document.getElementById('editUserId').value = data.user.userId;
        document.getElementById('editFullName').value = data.user.fullName;
        document.getElementById('editEmail').value = data.user.email;
        document.getElementById('editGender').value = data.user.gender?.toLowerCase();
        document.getElementById('editDob').value = data.user.dob;
        document.getElementById('editPhone').value = data.user.phone;

        const customer = data.customerDetails || {};
        document.getElementById('editAadhar').value = customer.aadharNumber || "";
        document.getElementById('editPan').value = customer.panId || "";
        document.getElementById('editAddress').value = customer.address || "";

        document.getElementById('editProfileModal').style.display = 'flex';
    }

    function closeModal() {
        document.getElementById('editProfileModal').style.display = 'none';
    }

    document.getElementById("edit-profile-form").addEventListener("submit", function (e) {
        e.preventDefault();

        const payload = {
            user: {
                userId: Number(document.getElementById("editUserId").value),
                fullName: document.getElementById("editFullName").value,
                email: document.getElementById("editEmail").value,
                gender: document.getElementById("editGender").value,
                dob: document.getElementById("editDob").value,
                phone: document.getElementById("editPhone").value,
                userType: 1
            },
            customerDetails: {
                aadharNumber: document.getElementById("editAadhar").value,
                panId: document.getElementById("editPan").value,
                address: document.getElementById("editAddress").value
            }
        };

        fetch("<%= request.getContextPath() %>/jadebank/user/update", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(payload)
        })
        .then(res => res.ok ? res.json() : Promise.reject("Update failed"))
        .then(data => {
            showStatusMessage("Profile updated successfully.", true);
            closeModal();
            fetchUserProfile(); // Reload the updated profile without full page reload
        })
        .catch(err => {
            console.error(err);
            showStatusMessage("Error updating profile. Please try again.", false);
        });
    });
    
    function showStatusMessage(message, isSuccess) {
        const statusDiv = document.getElementById("statusMessage");
        statusDiv.textContent = message;
        statusDiv.className = isSuccess ? "success" : "error";
        statusDiv.style.display = "block";

        setTimeout(() => {
            statusDiv.style.display = "none";
        }, 4000); // Message disappears after 4 seconds
    }

</script>

</body>
</html>

