package handlers;

import java.sql.Connection;
import java.time.Instant;
import java.util.Map;
import DAO.UserDAO;
import annotations.FromBody;
import annotations.FromQuery;
import annotations.FromSession;
import annotations.Route;
import pojos.Customer;
import pojos.Employee;
import pojos.User;
import pojos.UserProfile;
import util.CustomException;
import util.DBConnection;
import util.Password;
import util.Results;

public class UserHandler {

    private final UserDAO userDAO;
    private final EmployeeHandler employeeHandler;
    private final CustomerHandler customerHandler;

    public UserHandler(UserDAO userDAO, EmployeeHandler employeeHandler, CustomerHandler customerHandler) {
        this.userDAO = userDAO;
        this.customerHandler = customerHandler;
        this.employeeHandler = employeeHandler;
    }

    @Route(path = "getAll", method = "GET")
    public String getAllUsers() throws CustomException {
        return Results.respondJson(userDAO.getAllUsers(5, 5));
    }

    @Route(path = "create", method = "POST")
    public String createUser(@FromBody User user) throws CustomException {
    	user.setPasswordHash(Password.hashPassword(user.getPasswordHash()));
    	user.setModifiedOn(Instant.now().toEpochMilli());
        long result = userDAO.insertUser(user);
        return Results.respondJson(Map.of("status", "created", "userId", result));
    }
    
    @Route(path = "signup", method = "POST")
    public String createUser(@FromBody UserProfile profile, @FromSession("userId") long creatorId, @FromSession("role") int creatorRole) throws Exception {
		
    	Connection connection = null;
		
		try {
			connection = DBConnection.getConnection();
			connection.setAutoCommit(false);
		
			User user = profile.getUser();
			user.setCreatedBy(creatorId);
			user.setModifiedOn(Instant.now().toEpochMilli());
		
			long generatedUserId = userDAO.insertUser(user, connection); 
			user.setUserId(generatedUserId);
		
			int userType = user.getUserType();
			
		switch (userType) {
			case 2: // Employee
				createEmployee(profile.getEmployeeDetails(), user, creatorId, creatorRole, connection);
				break;
			case 1: // Customer
				createCustomer(profile.getCustomerDetails(), user, connection);
				break;
			default:
				throw new IllegalArgumentException("Invalid user type: " + userType);
			}
		
		connection.commit();
		return Results.respondJson(Map.of("status", "created", "userId", generatedUserId));
		
		} catch (Exception e) {
			if (connection != null) connection.rollback();
			e.printStackTrace();
			throw new CustomException("Transaction Failed", e);
		} finally {
			if (connection != null) connection.close();
		}
    }
    
    private void createCustomer(Customer customer, User user, Connection connection) throws Exception {
        customer.setCustomerId(user.getUserId());
        customerHandler.insertCustomer(customer, connection);
    }

    private void createEmployee(Employee employee, User user, long creatorId, int creatorRole, Connection connection) throws CustomException {
    	
        int newEmployeeRole = employee.getRole(); // Role to be assigned to the new employee

        // Validate creator's authority
        switch (newEmployeeRole) {
            case 2: // Manager
                if (creatorRole != 3) { // Only GM can add Manager
                    throw new CustomException("Only GM can create a Manager.");
                }
                break;
            case 1: // Clerk
                if (creatorRole != 2) {
                    throw new CustomException("Only Manager can create a Clerk.");
                }
                // Check branch match
                Employee manager = employeeHandler.getEmployeeDetails(creatorId);
                if (manager.getBranch() != employee.getBranch()) {
                    throw new CustomException("Manager can only create Clerks in their own branch.");
                }
                break;
            default:
                throw new CustomException("Invalid employee role: " + newEmployeeRole);
        }

        employee.setEmployeeId(user.getUserId());
        employeeHandler.insertEmployeeDetails(employee, connection);
    }
    
    @Route(path = "update", method = "PUT")
    public String updateUser(@FromBody User user, @FromQuery("userid") long userId, @FromSession("user") User modifier) throws CustomException {
    	try {
    		user.setModifiedBy(modifier.getUserId());
    		user.setModifiedOn(Instant.now().toEpochMilli());
            int result = userDAO.updateUser(user, userId);
            return Results.respondJson(Map.of("status", result > 0 ? "updated" : "not found", "rowsAffected", result));
        } catch (Exception e) {
            return Results.respondJson(Map.of("error", "Invalid input or update failed"));
        }
    }
    
//    @Route(path = "getByEmail", method = "GET")
//    public String userInfo(@FromQuery("email") String email) throws Exception {
//    	User user = userDAO.getUserByEmail(email);
//    	return Results.respondJson(user);
//    }
    
    @Route(path = "getByEmail", method = "GET")
    public String getUserProfileByEmail(@FromQuery("email") String email) throws CustomException {
        User user = userDAO.getUserByEmail(email);
        if (user == null) {
        	return null;
        }

        UserProfile profile = new UserProfile(user);
        switch (user.getUserType()) {
            case 2:
                Employee employee = employeeHandler.getEmployeeDetails(user.getUserId());
                profile.setEmployeeDetails(employee);
                break;
            case 1:
                Customer customer = customerHandler.getCustomerDetails(user.getUserId());
                profile.setCustomerDetails(customer);
                break;
        }
        return Results.respondJson(profile);
    }

    @Route(path = "delete", method = "DELETE")
    public String deleteUser(@FromQuery("userId") Long userId) throws CustomException {
        try {
            int result = userDAO.deleteUser(userId);
            return Results.respondJson(Map.of("status", result > 0 ? "deleted" : "not found", "rowsAffected", result));
        } catch (Exception e) {
            //resp.setStatus(400);
            return Results.respondJson(Map.of("error", "Invalid userId or deletion failed"));
        }
    }

}

