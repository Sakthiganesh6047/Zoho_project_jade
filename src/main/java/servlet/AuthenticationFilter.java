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
        HttpSession session = httpRequest.getSession(false); // do not create

        boolean isLoggedIn = session != null && session.getAttribute("userId") != null;

        boolean isLoginPage = uri.endsWith("/Login.jsp") || uri.endsWith("/login");
        boolean isSignUpPage = uri.endsWith("/SignUp.jsp") || uri.endsWith("/signup");
        boolean isPublic = uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png") || uri.endsWith("/LandingPage.jsp");

        // Redirect logged-in users away from login/signup pages
        if (isLoggedIn && (isLoginPage || isSignUpPage)) {
            Integer role = (Integer) session.getAttribute("role");
            String redirectUrl = httpRequest.getContextPath() + "/DashboardShell.jsp?page=";

            switch (role) {
                case 0: redirectUrl += "CustomerDashboard.jsp"; break;
                case 1: redirectUrl += "ClerkDashboard.jsp"; break;
                case 2: redirectUrl += "ManagerDashboard.jsp"; break;
                case 3: redirectUrl += "AdminDashboard.jsp"; break;
                default: redirectUrl += "CustomerDashboard.jsp"; break;
            }

            httpResponse.sendRedirect(redirectUrl);
            return;
        }

        // Let public resources and login/signup pages through
        if (isLoginPage || isSignUpPage || isPublic) {
            chain.doFilter(request, response);
            return;
        }

        // Protect everything else
        if (isLoggedIn) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/Login.jsp");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void destroy() {}
}


