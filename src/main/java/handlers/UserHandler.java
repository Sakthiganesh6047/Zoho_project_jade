package handlers;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import DAO.UserDAO;
import annotations.Authorized;
import annotations.Route;
import pojos.User;

public class UserHandler {

    private final UserDAO userDAO;

    public UserHandler(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    @Route(path = "getAll", method = "GET")
    @Authorized(roles = {"CLERK", "MANAGER", "GM"})
    public void getAllUsers(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        List<User> users = userDAO.getAllUsers(5, 5);
        respondJson(resp, users);
    }

    @Route(path = "create", method = "POST")
    @Authorized(roles = {"MANAGER", "GM"})
    public void createUser(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        User user = new ObjectMapper().readValue(req.getReader(), User.class);
        int result = userDAO.insertUser(user);
        respondJson(resp, Map.of("status", "created", "rowsAffected", result));
    }
    
    @Route(path = "update", method = "PUT")
    @Authorized(roles = {"MANAGER", "GM"})
    public void updateUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            User updatedUser = new ObjectMapper().readValue(req.getReader(), User.class);
            long userId = Long.parseLong(req.getParameter("userid"));
            int result = userDAO.updateUser(updatedUser, userId);
            respondJson(resp, Map.of("status", result > 0 ? "updated" : "not found", "rowsAffected", result));
        } catch (Exception e) {
            resp.setStatus(400);
            respondJson(resp, Map.of("error", "Invalid input or update failed"));
        }
    }
    
    @Route(path = "getByEmail", method = "GET")
    @Authorized(roles = {"CUSTOMER", "MANAGER", "GM"})
    public void userInfo(HttpServletRequest req, HttpServletResponse resp) throws Exception {
    	String email = req.getParameter("email");
    	User user = userDAO.getUserByEmail(email);
    	respondJson(resp, user);
    }

    @Route(path = "delete", method = "DELETE")
    @Authorized(roles = {"GM"})
    public void deleteUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Long userId = Long.parseLong(req.getParameter("userId"));
            int result = userDAO.deleteUser(userId);
            respondJson(resp, Map.of("status", result > 0 ? "deleted" : "not found", "rowsAffected", result));
        } catch (Exception e) {
            resp.setStatus(400);
            respondJson(resp, Map.of("error", "Invalid userId or deletion failed"));
        }
    }

    private void respondJson(HttpServletResponse resp, Object data) throws IOException {
        resp.setContentType("application/json");
        new ObjectMapper().writeValue(resp.getWriter(), data);
    }
}

