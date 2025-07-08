<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
%>
<%
    Integer role = (Integer) session.getAttribute("role");
    if (role == null || role < 0 || role > 3) {
        response.sendRedirect("Login.jsp");
        return;
    }
    String defaultPage = "Login.jsp";
    switch (role) {
        case 0: defaultPage = "CustomerDashboard.jsp"; break;
        case 1: defaultPage = "ClerkDashboard.jsp"; break;
        case 2: defaultPage = "ManagerDashboard.jsp"; break;
        case 3: defaultPage = "AdminDashboard.jsp"; break;
    }
    String requestedPage = request.getParameter("page");
    String initialPage = (requestedPage != null && !requestedPage.equals("#")) ? requestedPage : defaultPage;
    if ("Login.jsp".equals(initialPage)) {
        response.sendRedirect("Login.jsp");
        return;
    }

%>
<!DOCTYPE html>
<html>
<head>
    <title>JadeBank Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        body, html {
			font-family: "Roboto", sans-serif;
            margin: 0;
            padding: 0;
            height: auto;
        }
        .body-wrapper {
            display: block;
            margin-left: 70px;
            transition: margin-left 0.3s ease;
        }
        .sidebar-expanded .body-wrapper {
            margin-left: 223px;
        }
        iframe#content-frame {
            display: block;
            width: 100%;
            min-height: 100vh;
            border: none;
        }
        iframe::-webkit-scrollbar {
            display: none; /* Chrome */
        }
    </style>
</head>
<body>
    <jsp:include page="LoggedInHeader.jsp" />

    <jsp:include page="SideBar.jsp" />

    <div class="body-wrapper" id="bodyWrapper">
        <iframe id="content-frame" name="mainFrame"></iframe>
    </div>

    <script>
    const initialPage = "<%= initialPage %>";

    function loadPage(pageUrl, element, push = true) {
        if (!pageUrl || pageUrl === "#") return;

        const iframe = document.getElementById("content-frame");
        if (iframe) iframe.src = pageUrl;
        
        document.querySelectorAll('.sidebar-link').forEach(link => console.log(link.getAttribute('data-page')));
        console.log("Matching against:", pageUrl);

        document.querySelectorAll('.sidebar-link').forEach(link => {
            link.classList.remove('active');
            const target = link.getAttribute('data-page');
            if (target === pageUrl) {
                link.classList.add('active');
            }
        });

        if (push) {
            var base = window.location.href.split('?')[0];
        	history.pushState({ page: pageUrl }, "", base + "?page=" + pageUrl);
        }
    }

    window.addEventListener("DOMContentLoaded", () => {
        const params = new URLSearchParams(window.location.search);
        let page = params.get("page");

        if (!page || page === "#") {
            page = initialPage;
        }

        setTimeout(() => {
            loadPage(page, null, false);
        }, 0); // Defer to ensure iframe is ready
    });

    window.addEventListener("popstate", (event) => {
        if (event.state && event.state.page) {
            loadPage(event.state.page, null, false);
        }
    });

    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const body = document.body;

        sidebar.classList.toggle('expanded');
        body.classList.toggle('sidebar-expanded');
    }

</script>

</body>
</html>
