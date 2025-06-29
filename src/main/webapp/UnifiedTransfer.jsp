<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Transaction Center - JadeBank</title>
    <style>
        body {
        	transition: opacity 0.2s ease-in;
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            background-image: url("contents/background.png"); /* Replace with your actual path */
		    background-size: cover;        /* Scales the image to cover the whole screen */
		    background-repeat: no-repeat;  /* Prevents tiling */
		    background-position: center;
            padding-top: 70px; /* same as header height */
        }

        .body-wrapper {
            display: flex;
            min-height: 88vh;
        }

        .content-wrapper {
            flex-grow: 1;
            display: flex;
            justify-content: center;
            padding: 40px 20px;
        }

        .transaction-container {
            width: 100%;
            max-width: 800px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        .tab-bar {
		    display: flex;
		    justify-content: space-around;
		    background-color: #414485;
		    position: sticky;
		    top: 0;
		    z-index: 10;
		    border-top-left-radius: 12px;
		    border-top-right-radius: 12px;
		    border-bottom: none;
		    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
		}
		
		.tab-bar div {
		    padding: 15px 58px;
		    cursor: pointer;
		    font-weight: 600;
		    border: 1px solid transparent;
		    border-bottom: none;
		    border-radius: 10px 10px 0 0;
		    background-color: transparent;
		    color: white;
		    transition: all 0.3s ease;
		    position: relative;
		    top: 0;
		}
		
		.tab-bar div:hover {
		    background-color: #3b5998;
		    color: white;
		}
		
		.tab-bar .active {
		    background-color: #fff;
		    color: #111;
		    border: 1px solid #d0d5dd;
		    border-bottom: 1px solid #fff;
		    z-index: 2;
		    top: 1px;
		    box-shadow: 0 -1px 3px rgba(0,0,0,0.04);
		}

        .tab-content {
            display: none;
            padding: 30px;
            animation: fadeIn 0.3s ease;
        }

        .tab-content.active {
            display: block;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive */
        @media screen and (max-width: 768px) {
            .tab-bar {
                flex-wrap: wrap;
                gap: 10px;
            }

            .tab-bar div {
                flex: 1 1 auto;
                text-align: center;
            }

            .tab-content {
                padding: 20px;
            }
        }
    </style>
</head>

<body>

    <div class="body-wrapper">

        <div class="content-wrapper">
            <div class="transaction-container">
                <div class="tab-bar">
                    <div onclick="showTab('creditTab')" id="creditTabBtn">Credit</div>
                    <div onclick="showTab('debitTab')" id="debitTabBtn">Debit</div>
                    <div onclick="showTab('insideTab')" id="insideTabBtn">Inside Transfer</div>
                    <div onclick="showTab('outsideTab')" id="outsideTabBtn">Outside Transfer</div>
                </div>

                <div id="creditTab" class="tab-content">
                    <%@ include file="forms/CreditForm.jsp" %>
                </div>

                <div id="debitTab" class="tab-content">
                    <%@ include file="forms/DebitForm.jsp" %>
                </div>

                <div id="insideTab" class="tab-content">
                    <%@ include file="forms/TransferInsideForm.jsp" %>
                </div>

                <div id="outsideTab" class="tab-content">
                    <%@ include file="forms/TransferOutsideForm.jsp" %>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="Footer.jsp" />

    <script>
        function showTab(tabId) {
            const tabs = document.querySelectorAll('.tab-content');
            const buttons = document.querySelectorAll('.tab-bar div');
            tabs.forEach(tab => tab.classList.remove('active'));
            buttons.forEach(btn => btn.classList.remove('active'));

            document.getElementById(tabId).classList.add('active');
            document.getElementById(tabId + 'Btn').classList.add('active');
        }

        // Show default tab
        showTab('creditTab');
    </script>
</body>
</html>
