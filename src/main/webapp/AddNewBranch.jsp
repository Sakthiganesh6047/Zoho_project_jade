<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <title>Add New Branch - JadeBank</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
        }
        
        .body-wrapper{
        	margin: 0; display: flex; flex-direction: column; min-height: 100vh;
        }

        .branch-form-wrapper {
		    padding: 40px;
		    width: 100%;
		    display: flex;
		    justify-content: center;
		    align-items: flex-start;
		}

        .branch-form-container {
            background-color: white;
            padding: 40px 50px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 400px;
        }

        h2 {
            text-align: center;
            color: #2c3e50;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            margin-top: 15px;
            margin-bottom: 5px;
            font-weight: bold;
        }

        input, textarea {
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            margin-top: 25px;
            padding: 12px;
            font-size: 16px;
            background-color: #373962;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s;
        }

        button:hover {
            background-color: #1c6ca1;
        }

        .response-message {
            margin-top: 15px;
            text-align: center;
            font-weight: bold;
            color: green;
        }
        
        .styled-select {
		    font-size: 14px;
		    padding: 6px;
		    border-radius: 5px;
		    border: 1px solid #ccc;
		    width: 100%;
		    max-width: 400px;
		    margin-bottom: 15px;
		}
		
		.select2-container--default .select2-selection--single {
		    height: 38px;
		    padding: 4px 8px;
		    border-radius: 5px;
		}
        
    </style>
</head>
<body>

	<div class="body-wrapper">

	    <jsp:include page="LoggedInHeader.jsp" />  
	
		<div style="display: flex; flex: 1;">
	
		<!-- Sidebar (fixed width) -->
		    <div style="width: 240px;">
		        <jsp:include page="SideBar.jsp" />
		    </div>
		    
		    <div class="branch-form-wrapper">
		        <div class="branch-form-container">
		            <h2 id="form-title">Add New Branch</h2>
		            <form id="branch-form">
		            	<input type="hidden" name="branchId" id="branchId">
		            	
		                <label for="branchName">Branch Name</label>
		                <input type="text" name="branchName" required>
		
		                <label for="branchDistrict">District</label>
						<select name="branchDistrict" id="branchDistrict" class="styled-select" required>
						    <option value="">-- Select District --</option>
						    <option value="Chennai">Chennai</option>
						    <option value="Coimbatore">Coimbatore</option>
						    <option value="Madurai">Madurai</option>
						    <option value="Tiruchirappalli">Tiruchirappalli</option>
						    <option value="Salem">Salem</option>
						    <option value="Tirunelveli">Tirunelveli</option>
						    <option value="Erode">Erode</option>
						    <option value="Vellore">Vellore</option>
						    <option value="Thoothukudi">Thoothukudi</option>
						    <option value="Dindigul">Dindigul</option>
						</select>
		
		                <label for="address">Address</label>
		                <textarea name="address" rows="4" required></textarea>
		
		                <button type="submit">Create Branch</button>
		
		                <div class="response-message" id="response"></div>
		            </form>
		        </div>
		    </div>
		</div>
	
	    <jsp:include page="Footer.jsp" />
	    
	</div>

   <!-- Load jQuery and Select2 -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
	
	<!-- Your custom script -->
	<script>
		$(document).ready(function () {
		    const urlParams = new URLSearchParams(window.location.search);
		    const branchId = urlParams.get("branchId");
	
		    $('#branchDistrict').select2({
		        placeholder: "-- Select District --",
		        width: '100%'
		    });
	
		    // If editing, fetch existing branch data
		    if (branchId) {
		        document.getElementById("form-title").innerText = "Edit Branch";
		        console.log(branchId);
		        console.log(`<%= request.getContextPath() %>/jadebank/branch/id/${branchId}`);
		        fetch('${pageContext.request.contextPath}/jadebank/branch/id/' + branchId)
		            .then(response => response.json())
		            .then(branch => {
		                document.querySelector('input[name="branchName"]').value = branch.branchName;
		                document.querySelector('select[name="branchDistrict"]').value = branch.branchDistrict;
		                document.querySelector('textarea[name="address"]').value = branch.address;
		                document.getElementById("branchId").value = branch.branchId;
		                $('#branchDistrict').val(branch.branchDistrict).trigger('change');
		            })
		            .catch(err => {
		                console.error("Failed to load branch details:", err);
		                document.getElementById("response").innerText = "Error loading branch data.";
		            });
		    }
	
		    document.getElementById("branch-form").addEventListener("submit", function (e) {
		        e.preventDefault();
	
		        const branchData = {
		            branchId: document.getElementById("branchId").value || null,
		            branchName: document.querySelector('input[name="branchName"]').value,
		            branchDistrict: document.querySelector('select[name="branchDistrict"]').value,
		            address: document.querySelector('textarea[name="address"]').value
		        };
	
		        const isEdit = !!branchData.branchId;
		        const apiUrl = isEdit ? "<%= request.getContextPath() %>/jadebank/branch/update" : "<%= request.getContextPath() %>/jadebank/branch/new";
	
		        fetch(apiUrl, {
		            method: "POST",
		            headers: {
		                "Content-Type": "application/json"
		            },
		            body: JSON.stringify(branchData)
		        })
		            .then(async (response) => {
		                const data = await response.json();
	
		                if (!response.ok) {
		                    document.getElementById("response").innerText = data.error || "Failed to save branch.";
		                    document.getElementById("response").style.color = "red";
		                } else {
		                    document.getElementById("response").innerText = isEdit ? "Branch updated successfully." : "Branch created successfully.";
		                    document.getElementById("response").style.color = "green";
	
		                    if (!isEdit) {
		                        document.getElementById("branch-form").reset();
		                        $('#branchDistrict').val('').trigger('change');
		                    }
		                }
		            })
		            .catch(err => {
		                document.getElementById("response").innerText = "Something went wrong.";
		                document.getElementById("response").style.color = "red";
		                console.error(err);
		            });
		    });
		});
	</script>

</body>
</html>
