package servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

   private static final long serialVersionUID = 1L;
   
   @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       
       // Invalidate the session if it exists
       HttpSession session = request.getSession(false); // don't create a new one
       if (session != null) {
           session.invalidate();
       }

       // Clear the JSESSIONID cookie
       Cookie cookie = new Cookie("JSESSIONID", null);
       cookie.setMaxAge(0);           // Delete it
       cookie.setPath(request.getContextPath());           // Must match path of original cookie
       cookie.setHttpOnly(true);      // Same as login
       cookie.setSecure(false);       // Set to true if using HTTPS
       response.addCookie(cookie);

       // Send a simple JSON response
       response.setContentType("application/json");
       response.setStatus(HttpServletResponse.SC_OK);
       response.getWriter().write("{\"message\": \"Logged out successfully\"}");
   }
}
