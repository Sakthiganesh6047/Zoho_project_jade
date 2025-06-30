<!-- Add this HTML for the modal to your existing page -->
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

<style>
.modal {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(0,0,0,0.6);
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
  box-shadow: 0 8px 20px rgba(0,0,0,0.2);
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

.modal-content form label {
  margin-top: 10px;
  display: block;
  font-weight: 600;
}

.modal-content form input,
.modal-content form textarea,
.modal-content form select {
  width: 100%;
  padding: 10px;
  margin-top: 4px;
  margin-bottom: 12px;
  border-radius: 8px;
  border: 1px solid #ccc;
  font-size: 14px;
}
</style>

<script>
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
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(payload)
  })
  .then(res => res.ok ? res.json() : Promise.reject("Update failed"))
  .then(data => {
    alert("Profile updated successfully");
    closeModal();
    location.reload();
  })
  .catch(err => {
    console.error(err);
    alert("Error updating profile");
  });
});
</script>
