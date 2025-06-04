package handlers;

import java.sql.Connection;
import java.time.Instant;
import java.util.Map;
import DAO.UserDAO;
import annotations.FromBody;
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

    @Route(path = "user/list", method = "GET")
    public String getAllUsers(int limit, int offset) throws CustomException {
        return Results.respondJson(userDAO.getAllUsers(limit, offset));
    }

    @Route(path = "user/new/admin", method = "POST")
    public String createAdminUser(@FromBody User user) throws CustomException {
    	user.setPasswordHash(Password.hashPassword(user.getPasswordHash()));
    	user.setModifiedOn(Instant.now().toEpochMilli());
        long result = userDAO.insertUser(user);
        return Results.respondJson(Map.of("status", "created", "userId", result));
    }
    
    @Route(path = "user/new", method = "POST")
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
    
    @Route(path = "user/signup", method = "POST")
    public String publicCreateCustomer(@FromBody UserProfile profile) throws Exception {
        Connection connection = null;

        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);

            User user = profile.getUser();
            user.setUserType(1);
            user.setCreatedBy(0L); // Optional: 0 or -1 for public created
            user.setModifiedOn(Instant.now().toEpochMilli());

            long generatedUserId = userDAO.insertUser(user, connection);
            user.setUserId(generatedUserId);

            Customer customer = profile.getCustomerDetails();
            customer.setCustomerId(generatedUserId);

            customerHandler.insertCustomer(customer, connection);

            connection.commit();
            return Results.respondJson(Map.of("status", "created", "userId", generatedUserId));

        } catch (Exception e) {
            if (connection != null) connection.rollback();
            e.printStackTrace();
            throw new CustomException("Public customer creation failed", e);
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
    
    @Route(path = "user/update", method = "PUT")
    public String updateUser(@FromBody User user, @FromSession("user") User modifier) throws CustomException {
    	try {
    		user.setModifiedBy(modifier.getUserId());
    		user.setModifiedOn(Instant.now().toEpochMilli());
            int result = userDAO.updateUser(user, user.getUserId());
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
    
    @Route(path = "user/email", method = "POST")
    public String getUserProfileByEmail(@FromBody User user) throws CustomException {
        User fetchedUser = userDAO.getUserByEmail(user.getEmail());
        if (fetchedUser == null) {
        	return null;
        }

        UserProfile profile = new UserProfile(fetchedUser);
        switch (fetchedUser.getUserType()) {
            case 2:
                Employee employee = employeeHandler.getEmployeeDetails(fetchedUser.getUserId());
                profile.setEmployeeDetails(employee);
                break;
            case 1:
                Customer customer = customerHandler.getCustomerDetails(fetchedUser.getUserId());
                profile.setCustomerDetails(customer);
                break;
        }
        return Results.respondJson(profile);
    }
    
    @Route(path = "user/id", method = "POST")
    public String getUserProfileById(@FromBody User user) throws CustomException {
        User fetchedUser = userDAO.getUserById(user.getUserId());
        if (fetchedUser == null) {
        	return null;
        }

        UserProfile profile = new UserProfile(fetchedUser);
        switch (fetchedUser.getUserType()) {
            case 2:
                Employee employee = employeeHandler.getEmployeeDetails(fetchedUser.getUserId());
                profile.setEmployeeDetails(employee);
                break;
            case 1:
                Customer customer = customerHandler.getCustomerDetails(fetchedUser.getUserId());
                profile.setCustomerDetails(customer);
                break;
        }
        return Results.respondJson(profile);
    }

    @Route(path = "user/delete", method = "POST")
    public String deleteUser(@FromBody User user) throws CustomException {
        try {
            int result = userDAO.deleteUser(user.getUserId());
            return Results.respondJson(Map.of("status", result > 0 ? "deleted" : "not found", "rowsAffected", result));
        } catch (Exception e) {
            //resp.setStatus(400);
            return Results.respondJson(Map.of("error", "Invalid userId or deletion failed"));
        }
    }

}

