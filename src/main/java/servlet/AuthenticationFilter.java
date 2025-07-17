package servlet;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();
        System.out.println(uri);

        HttpSession session = httpRequest.getSession(false); // do not create
        boolean isLoggedIn = session != null && session.getAttribute("userId") != null;

        boolean isLoginPage = uri.endsWith("/Login.jsp") || uri.endsWith("/login");
        boolean isSignUpPage = uri.endsWith("/SignUp.jsp") || uri.endsWith("/signup");
        boolean isPublic = uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png") || uri.endsWith("/LandingPage.jsp");

        // If logged-in user tries to visit login/signup, redirect to dashboard
        if (isLoggedIn && (isLoginPage || isSignUpPage)) {
            Integer role = (Integer) session.getAttribute("role");
            String redirectUrl = httpRequest.getContextPath() + "/DashboardShell.jsp?page=";

            switch (role != null ? role : -1) {
                case 0: redirectUrl += "CustomerDashboard.jsp"; break;
                case 1: redirectUrl += "ClerkDashboard.jsp"; break;
                case 2: redirectUrl += "ManagerDashboard.jsp"; break;
                case 3: redirectUrl += "AdminDashboard.jsp"; break;
                default: redirectUrl += "CustomerDashboard.jsp"; break;
            }

            httpResponse.sendRedirect(redirectUrl);
            return;
        }

        // Allow public resources through
        if (isLoginPage || isSignUpPage || isPublic) {
            chain.doFilter(request, response);
            return;
        }

        // If user is logged in, proceed
        if (isLoggedIn) {
            chain.doFilter(request, response);
        } else {
            // Check if it's an AJAX/API request
            String acceptHeader = httpRequest.getHeader("Accept");
            boolean isAjax = acceptHeader != null && acceptHeader.contains("application/json");

            if (isAjax) {
                httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
                httpResponse.setContentType("application/json");
                httpResponse.getWriter().write("{\"error\": \"SESSION_EXPIRED\"}");
                return;
            } else {
            	httpResponse.sendRedirect(httpRequest.getContextPath() + "/Login.jsp?expired=true");
            }
        }
    }

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void destroy() {}
}


