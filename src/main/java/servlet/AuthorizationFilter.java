package servlet;

//import javax.servlet.*;
//import javax.servlet.annotation.WebFilter;
//import javax.servlet.http.*;
//import java.io.IOException;

//@WebFilter("/*")  // This filter will be applied to all URLs
public class AuthorizationFilter {//implements Filter {

//    @Override
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
//
//        HttpServletRequest req = (HttpServletRequest) request;
//        HttpServletResponse res = (HttpServletResponse) response;
//
//        String loginURI = req.getContextPath() + "/login";
//        String unauthorizedURI = req.getContextPath() + "/unauthorized.jsp";
//
//        // Check if session exists and the user is logged in
//        HttpSession session = req.getSession(false);
//        boolean loggedIn = false;
//        boolean hasRole = false;
//
//        // If there's a session, check if the user is logged in and has the correct role
//        if (session != null) {
//            String username = (String) session.getAttribute("user");
//            String role = (String) session.getAttribute("role");
//
//            if (username != null) {
//                loggedIn = true;
//                // Check if the user has the required role (e.g., "admin", "manager", "user")
//                // Modify this condition based on your access control requirements
//                if ("admin".equals(role) || "manager".equals(role)) {
//                    hasRole = true;
//                }
//            }
//        }
//
//        // URLs that don't require session or are for login/logout
//        boolean loginRequest = req.getRequestURI().equals(loginURI);
//        boolean loginPageRequest = req.getRequestURI().endsWith("login.jsp");
//        boolean logoutRequest = req.getRequestURI().endsWith("logout");
//
//        if (loggedIn && hasRole) {
//            // If the user is logged in and has the correct role, allow the request to proceed
//            chain.doFilter(request, response);
//        } else if (loginRequest || loginPageRequest || logoutRequest) {
//            // Allow login and logout pages to be accessed
//            chain.doFilter(request, response);
//        } else if (!loggedIn) {
//            // User is not logged in, redirect to login page
//            res.sendRedirect(loginURI);
//        } else if (!hasRole) {
//            // User is logged in but does not have the correct role, redirect to unauthorized page
//            res.sendRedirect(unauthorizedURI);
//        }
//    }
}

