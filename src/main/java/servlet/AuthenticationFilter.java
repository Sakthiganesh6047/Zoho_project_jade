package servlet;


import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.RequestDispatcher;
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
    public void init(FilterConfig filterConfig) {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        @SuppressWarnings("unused")
		HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();
        HttpSession session = httpRequest.getSession(false);

        boolean isLoginRequest = uri.endsWith("/LoginServlet") || uri.endsWith("/Login.jsp") || uri.endsWith("/login");
        boolean isPublicResource = uri.startsWith("/public/") || uri.endsWith(".css") || uri.endsWith(".png") || uri.endsWith("LandingPage.jsp");
        boolean isLogoutRequest = uri.endsWith("/logout") || uri.endsWith("Logout.jsp");
        boolean isSignUpRequest = uri.endsWith("/signup") || uri.endsWith("SignUp.jsp");

        boolean isLoggedIn = session != null && session.getAttribute("userId") != null;

        if (isLoggedIn || isLoginRequest || isPublicResource || isLogoutRequest || isSignUpRequest) {
            chain.doFilter(request, response);
        } else {
//            httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
//            httpResponse.setContentType("application/json");
//            httpResponse.getWriter().write("{\"error\":\"Unauthorized access. Please login.\"}");
        	RequestDispatcher dispatcher = httpRequest.getRequestDispatcher("Login.jsp");
        	dispatcher.forward(request, response);

        }
    }

    @Override
    public void destroy() {}
}

