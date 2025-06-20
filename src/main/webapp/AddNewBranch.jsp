<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add New Branch - JadeBank</title>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f6f8;
            margin: 0;
        }

        .body-wrapper {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .branch-form-wrapper {
            flex: 1;
            display: flex;
        }

        .sidebar {
            width: 240px;
        }

        .branch-form-container {
        	max-height: 450px;
            max-width: 500px;
            background-color: white;
            margin: 60px auto;
            padding: 40px 50px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 100%;
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            margin-bottom: 6px;
            font-weight: bold;
            color: #333;
        }

        input,
        textarea,
        select {
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 6px;
            margin-bottom: 20px;
            width: 100%;
            box-sizing: border-box;
        }

        textarea {
            resize: none; /* Prevent expansion */
            height: 100px;
        }

        button {
            padding: 12px;
            font-size: 16px;
            background-color: #2980b9;
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
        }

        .select2-container--default .select2-selection--single {
            height: 38px;
            padding: 4px 8px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>

<div class="body-wrapper">

    <jsp:include page="LoggedInHeader.jsp" />

    <div class="branch-form-wrapper">

        <!-- Sidebar -->
        <div class="sidebar">
            <jsp:include page="SideBar.jsp" />
        </div>

        <!-- Form Container -->
        <div class="branch-form-container">
            <h2 id="form-title">Add New Branch</h2>
            <form id="branch-form">
                <input type="hidden" name="branchId" id="branchId" />

                <label for="branchName">Branch Name</label>
                <input type="text" name="branchName" required />

                <label for="branchDistrict">District</label>
                <select name="branchDistrict" id="branchDistrict" required>
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
                <textarea name="address" rows="4" maxlength="300" required></textarea>

                <button type="submit">Create Branch</button>

                <div class="response-message" id="response"></div>
            </form>
        </div>
    </div>

    <jsp:include page="Footer.jsp" />
</div>

<!-- JS: jQuery + Select2 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
    $(document).ready(function () {
        const urlParams = new URLSearchParams(window.location.search);
        const branchId = urlParams.get("branchId");

        $('#branchDistrict').select2({
            placeholder: "-- Select District --",
            width: '100%'
        });

        if (branchId) {
            document.getElementById("form-title").innerText = "Edit Branch";

            fetch('${pageContext.request.contextPath}/jadebank/branch/id/' + branchId)
                .then(res => res.json())
                .then(branch => {
                    document.querySelector('input[name="branchName"]').value = branch.branchName;
                    document.querySelector('textarea[name="address"]').value = branch.address;
                    document.getElementById("branchId").value = branch.branchId;
                    $('#branchDistrict').val(branch.branchDistrict).trigger('change');
                })
                .catch(err => {
                    console.error("Load error:", err);
                    document.getElementById("response").innerText = "Error loading branch data.";
                    document.getElementById("response").style.color = "red";
                });
        }

        document.getElementById("branch-form").addEventListener("submit", function (e) {
            e.preventDefault();

            const data = {
                branchId: document.getElementById("branchId").value || null,
                branchName: document.querySelector('input[name="branchName"]').value,
                branchDistrict: document.querySelector('select[name="branchDistrict"]').value,
                address: document.querySelector('textarea[name="address"]').value
            };

            const isEdit = !!data.branchId;
            const url = isEdit
                ? "<%= request.getContextPath() %>/jadebank/branch/update"
                : "<%= request.getContextPath() %>/jadebank/branch/new";

            fetch(url, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(data)
            })
                .then(res => res.json().then(data => ({ ok: res.ok, data })))
                .then(({ ok, data }) => {
                    const resp = document.getElementById("response");
                    if (!ok) {
                        resp.innerText = data.error || "Error saving branch.";
                        resp.style.color = "red";
                    } else {
                        resp.innerText = isEdit ? "Branch updated successfully." : "Branch created successfully.";
                        resp.style.color = "green";
                        if (!isEdit) {
                            document.getElementById("branch-form").reset();
                            $('#branchDistrict').val('').trigger('change');
                        }
                    }
                })
                .catch(err => {
                    console.error(err);
                    const resp = document.getElementById("response");
                    resp.innerText = "Something went wrong.";
                    resp.style.color = "red";
                });
        });
    });
</script>

</body>
</html>
