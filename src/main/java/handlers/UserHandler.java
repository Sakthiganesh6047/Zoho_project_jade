package handlers;

import java.sql.Connection;
import java.time.Instant;
import java.util.Map;

import DAO.CustomerDAO;
import DAO.EmployeeDAO;
import DAO.UserDAO;
import annotations.FromBody;
import annotations.FromQuery;
import annotations.FromSession;
import annotations.Route;
import pojos.Credential;
import pojos.Customer;
import pojos.Employee;
import pojos.User;
import pojos.UserProfile;
import util.AuthorizeUtil;
import util.BadRequestException;
import util.CustomException;
import util.DBConnection;
import util.Password;
import util.Results;
import util.TimeConversion;
import util.UnauthorizedAccessException;
import util.ValidationsUtil;

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
    	ValidationsUtil.checkLimitAndOffset(limit, offset);
        return Results.respondJson(userDAO.getAllUsers(limit, offset));
    }

    @Route(path = "user/new/admin", method = "POST")
    public String createAdminUser(@FromBody User user) throws CustomException {
    	
    	ValidationsUtil.validateUser(user);
    	
    	user.setPasswordHash(Password.hashPassword(user.getPasswordHash()));
    	user.setModifiedOn(Instant.now().toEpochMilli());
        long result = userDAO.insertUser(user);
        return Results.respondJson(Map.of("status", "created", "userId", result));
    }
    
    @Route(path = "user/new", method = "POST")
    public String createUser(@FromBody UserProfile profile, @FromSession("userId") Long creatorId, @FromSession("role") Integer creatorRole) throws Exception {
    	
    	ValidationsUtil.isNull(creatorId, "UserId");
    	ValidationsUtil.isNull(creatorRole, "User Role");
    	ValidationsUtil.checkUserRole(creatorRole);
    	
    	User user = profile.getUser();
    	user.setAge(TimeConversion.calculateAge(user.getDob()));
    	ValidationsUtil.validateUser(user);
    	user.setPasswordHash(Password.hashPassword(user.getPasswordHash()));
    	
    	if (user.getUserType() == 1) {
			ValidationsUtil.validateCustomer(profile.getCustomerDetails());
    	}
		
    	Connection connection = null;
		
		try {
			connection = DBConnection.getConnection();
			connection.setAutoCommit(false);
			
			user.setStatus(1);
			user.setCreatedBy(creatorId);
			user.setModifiedOn(Instant.now().toEpochMilli());
		
			Long generatedUserId = userDAO.insertUser(user, connection); 
			user.setUserId(generatedUserId);
		
			Integer userType = user.getUserType();
			
		switch (userType) {
			case 2: // Employee
				//ValidationUtil.validateEmployee(employee);
				createEmployee(profile.getEmployeeDetails(), user, creatorId, creatorRole, connection);
				break;
			case 1: // Customer
				createCustomer(profile.getCustomerDetails(), user, connection);
				break;
			default:
				throw new BadRequestException("Invalid user type: " + userType);
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
        
        User user = profile.getUser();
        Customer customer = profile.getCustomerDetails();
        user.setAge(TimeConversion.calculateAge(user.getDob()));
        user.setUserType(1);
        
        ValidationsUtil.validateUser(user);
        ValidationsUtil.validateCustomer(customer);

        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);

            user.setCreatedBy(0L); // Optional: 0 or -1 for public created
            user.setStatus(1);
            user.setPasswordHash(Password.hashPassword(user.getPasswordHash()));
            user.setModifiedOn(Instant.now().toEpochMilli());

            Long generatedUserId = userDAO.insertUser(user, connection);
            user.setUserId(generatedUserId);

            
            customer.setCustomerId(generatedUserId);

            customerHandler.insertCustomer(customer, connection);

            connection.commit();
            return Results.respondJson(Map.of("status", "created", "userId", generatedUserId));

        } catch (Exception e) {
            if (connection != null) {
            	connection.rollback();
            }
            e.printStackTrace();
            throw new CustomException("Public customer creation failed", e);
        } finally {
            if (connection != null) {
            	connection.close();
            }
        }
    }
    
    private void createCustomer(Customer customer, User user, Connection connection) throws Exception {
        customer.setCustomerId(user.getUserId());
        customerHandler.insertCustomer(customer, connection);
    }

    private void createEmployee(Employee employee, User user, Long creatorId, Integer creatorRole, Connection connection) throws CustomException {
    	
        Integer newEmployeeRole = employee.getRole(); // Role to be assigned to the new employee

        // Validate creator's authority
        switch (newEmployeeRole) {
            case 2: // Manager
                if (!(creatorRole.equals(3))) { // Only GM can add Manager
                    throw new UnauthorizedAccessException("Only GM can create a Manager.");
                }
                break;
            case 1: // Clerk
                if ( !(creatorRole.equals(2)) && !(creatorRole.equals(3))) {
                    throw new UnauthorizedAccessException("Only Managers and GM can create a Clerk.");
                }
                // Check branch match
                if (creatorRole.equals(2)) {
	                Employee manager = employeeHandler.getEmployeeDetails(creatorId);
	                if (manager.getBranch() != employee.getBranch()) {
	                    throw new UnauthorizedAccessException("Manager can only create Clerks in their own branch.");
	                }
                }
                break;
        }

        employee.setEmployeeId(user.getUserId());
        employeeHandler.insertEmployeeDetails(employee, connection);
    }
    
    @Route(path = "user/update", method = "POST")
    public String updateUserProfile(@FromBody UserProfile profile, @FromSession("userId") long updaterId) throws Exception {
        Connection connection = null;

        User user = profile.getUser();
        user.setModifiedOn(Instant.now().toEpochMilli());

        if (user.getUserId() == null) {
            throw new BadRequestException("User ID is required for update.");
        }

        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);

            // Validate and update user
            user.setAge(TimeConversion.calculateAge(user.getDob()));
            user.setStatus(1);
            ValidationsUtil.validateUserForUpdate(user);

            // Check if password is being updated
            if (user.getPasswordHash() != null && !user.getPasswordHash().isEmpty()) {
                user.setPasswordHash(Password.hashPassword(user.getPasswordHash()));
            } else {
                // Retain the existing password hash
                User existing = userDAO.getUserById(user.getUserId(), connection);
                user.setPasswordHash(existing.getPasswordHash());
            }
            userDAO.updateUser(user, connection);

            // Depending on the userType, update customer or employee
            if (user.getUserType() == 1) { // Customer
                Customer customer = profile.getCustomerDetails();
                if (customer == null) {
                	throw new CustomException("Customer details missing.");
                }
                customer.setCustomerId(user.getUserId());
                ValidationsUtil.validateCustomer(customer);
                CustomerDAO customerDAO = CustomerDAO.getCustomerDAOInstance();
                customerDAO.updateCustomer(customer, connection);

            } else if (user.getUserType() == 2) { // Clerk / Manager / GM
                Employee employee = profile.getEmployeeDetails();
                if (employee == null) {
                	throw new CustomException("Employee details missing.");
                }
                employee.setEmployeeId(user.getUserId());
                // Optional: validate update authority for roles
                Employee updater = employeeHandler.getEmployeeDetails(updaterId);
                if (!hasPermissionToUpdate(updater, employee)) {
                    throw new UnauthorizedAccessException("Insufficient permission to update this employee.");
                }

                ValidationsUtil.validateEmployee(employee);
                EmployeeDAO employeeDAO = EmployeeDAO.getEmployeeDAOInstance();
                employeeDAO.updateEmployee(employee, connection);
            }

            connection.commit();
            return Results.respondJson(Map.of("status", "updated", "userId", user.getUserId()));

        } catch (Exception e) {
            if (connection != null) connection.rollback();
            e.printStackTrace();
            throw new CustomException("User update failed", e);
        } finally {
            if (connection != null) connection.close();
        }
    }
    
    private boolean hasPermissionToUpdate(Employee updater, Employee target) {
        if (updater.getRole() == 3) return true; // GM can update anyone
        if (updater.getRole() == 2 && target.getRole() == 1 &&
            updater.getBranch().equals(target.getBranch())) return true; // Manager can update clerks in same branch
        return false;
    }
    
    @Route(path = "user/email", method = "POST")
    public String getUserProfileByEmail(@FromBody User user) throws CustomException {
    	
    	String email = user.getEmail();
    	ValidationsUtil.isNull(email, "Email");
    	ValidationsUtil.isEmpty(email, "email");
    	
        User fetchedUser = userDAO.getUserByEmail(email);
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
    
    @Route(path = "user/phone", method = "POST")
    public String getUserByPhone(@FromBody User user) throws CustomException {
    	
    	String phone = user.getPhone();
    	ValidationsUtil.isEmpty(phone, "Phone Number");
    	
    	User fetchedUser = userDAO.getUserByPhone(phone);
    	if (fetchedUser.getUserType() == 2) {
    		throw new BadRequestException("Invalid User Type, check Phone Number");
    	}
    	return Results.respondJson(fetchedUser);
    }
    
    @Route(path = "user/id", method = "POST")
    public String getUserProfileById(@FromBody User user) throws CustomException {
    	
    	Long userId = user.getUserId();
    	ValidationsUtil.isNull(userId, "UserId");
    	
        User fetchedUser = userDAO.getUserById(userId);
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
    
    @Route(path = "user/details", method = "POST")
    public String getUserDetails(@FromBody User user) throws CustomException {
    	
    	String phone = user.getPhone();
    	ValidationsUtil.isEmpty(phone, "Phone Number");
    	
        User fetchedUser = userDAO.getUserByPhone(phone);
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
    
    @Route(path = "user/profile", method = "GET")
    public String getUserProfileById(@FromSession("userId") Long userId) throws CustomException {
    	
    	ValidationsUtil.isNull(userId, "UserId");
        return Results.respondJson(userDAO.getUserById(userId));
    }
    
    @Route(path = "user/password", method = "POST")
    public String changePassword(@FromBody Credential credential, @FromSession("userId") Long userId) throws CustomException {
    	
    	ValidationsUtil.isNull(userId, "UserId");
    	User fetchedUser = userDAO.getPasswordById(userId);
    	
    	if(!(Password.verifyPassword(credential.getPassword(), fetchedUser.getPasswordHash()))){
    		throw new BadRequestException("Old password is Incorrect");
    	}
    	
    	if(Password.verifyPassword(credential.getNewPassword(), fetchedUser.getPasswordHash())){
    		throw new BadRequestException("Your Old password cannot be your New password!");
    	}
    	
    	fetchedUser.setModifiedBy(userId);
    	fetchedUser.setModifiedOn(Instant.now().toEpochMilli());
    	fetchedUser.setPasswordHash(Password.hashPassword(credential.getNewPassword()));
    	userDAO.updatePassword(fetchedUser);
    	return Results.respondJson(Map.of("status", "success"));
    }
    
    @Route(path = "user/employeelist", method = "GET")
    public String getEmployeeProfiles(
            @FromSession("userId") Long userId,
            @FromSession("role") Integer role,
            @FromQuery("limit") int limit,
            @FromQuery("offset") int offset,
            @FromQuery("branchId") Long branchId,
            @FromQuery("roleType") Integer roleType // e.g., 0=Clerk, 1=Manager, etc.
    ) throws CustomException {

        ValidationsUtil.isNull(userId, "UserId");
        ValidationsUtil.isNull(role, "User Role");
        ValidationsUtil.checkLimitAndOffset(limit, offset);
        ValidationsUtil.checkUserRole(role);

        if (role == 2) {
            Employee employee = AuthorizeUtil.getEmployeeDetails(userId);
            branchId = employee.getBranch(); // enforce manager's own branch
        }

        return Results.respondJson(
            userDAO.getFilteredEmployeeDetails(branchId, roleType, limit, offset)
        );
    }
    
    @Route(path = "user/employeecount", method = "GET")
    public String getRoleCount(@FromSession("userId") Long userId, @FromSession("role") Integer role) throws CustomException {
    	
    	ValidationsUtil.isNull(userId, "UserId");
    	ValidationsUtil.isNull(role, "User Role");
    	
    	EmployeeDAO employeeDAO = EmployeeDAO.getEmployeeDAOInstance();
    	if(role==2) {
    		Employee employee = AuthorizeUtil.getEmployeeDetails(userId);
    		return Results.respondJson(employeeDAO.getRoleCountsByBranch(employee.getBranch()));
    	} else {
    		return Results.respondJson(employeeDAO.getRoleCounts());
    	}
    }
    
    @Route(path = "user/dashboardstats", method = "GET")
    public String getAdminStats(@FromSession("userId") Long userId, @FromSession("role") Integer role) throws CustomException {
    	
    	ValidationsUtil.isNull(userId, "UserId");
    	ValidationsUtil.isNull(role, "User Role");
    	
    	if(role==2) {
    		Employee employee = AuthorizeUtil.getEmployeeDetails(userId);
    		return Results.respondJson(userDAO.getBranchStats(employee.getBranch()));
    	} else {
    		return Results.respondJson(userDAO.getDashboardCounts());
    	}
    }

    @Route(path = "user/delete", method = "POST")
    public String deleteUser(@FromBody User user) throws CustomException {
    	
    	Long userId = user.getUserId();
    	ValidationsUtil.isNull(userId, "UserId");
    	
        try {
            int result = userDAO.deleteUser(userId);
            return Results.respondJson(Map.of("status", result > 0 ? "deleted" : "not found", "rowsAffected", result));
        } catch (CustomException e) {
            //resp.setStatus(400);
            throw new CustomException("User deletion failed");
        }
    }

}

