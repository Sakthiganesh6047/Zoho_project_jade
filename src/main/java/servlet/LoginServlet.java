package servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.fasterxml.jackson.databind.ObjectMapper;
import DAO.EmployeeDAO;
import DAO.UserDAO;
import pojos.Credential;
import pojos.Employee;
import pojos.User;
import util.Password;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    
    Credential credential;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    	ObjectMapper mapper = new ObjectMapper();
    	Credential login = mapper.readValue(request.getReader(), Credential.class);
    	String email = login.getEmail();
    	String password = login.getPassword();
        
        try {
            UserDAO userDAO = UserDAO.getUserDAOInstance();
            User user = userDAO.getUserByEmail(email);

            if (user != null && user.getEmail().equals(email) && Password.verifyPassword(password, user.getPasswordHash())) {
            	
            	if (user.getStatus() == 0) {
            		response.setContentType("application/json");
            		response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            		response.getWriter().write("{\"error\":\"User Blocked\"}");
            	}
            	
            	int role;
            	
            	if(user.getUserType() == 2) {
            		EmployeeDAO employeeDAO = EmployeeDAO.getEmployeeDAOInstance();
            		Employee employee = employeeDAO.getEmployeeById(user.getUserId());
            		role = employee.getRole(); // 1 - clerk, 2 - Manager, 3 - GM
            	} else {
            		role = 0; // 0 for customer
            	}
            	
                // Create a new session
                HttpSession session = request.getSession(true);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("role", role);
                session.setMaxInactiveInterval(15 * 60); // 15 minutes

                // Respond with 200 OK and basic user info
                response.setContentType("application/json");
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"message\":\"Login successful\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"Invalid credentials\"}");
            }

        } catch(Exception e) {
        	e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}


