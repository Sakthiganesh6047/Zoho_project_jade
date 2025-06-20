 package DAO;

import java.sql.Connection;
import java.util.List;

import pojos.EmployeeProfile;
import pojos.User;
import querybuilder.QueryBuilder;
import querybuilder.QueryExecutor;
import querybuilder.QueryResult;
import util.CustomException;
import util.Results;
import util.ValidationsUtil;

public class UserDAO {
	
	private UserDAO() {
		if (UserDAOHelper.INSTANCE != null) {
			throw new IllegalStateException("UserDAO instance already created");
		}
	}
	
	private static class UserDAOHelper{
		private static final UserDAO INSTANCE = new UserDAO();
	}
	
	public static UserDAO getUserDAOInstance() {
		return UserDAOHelper.INSTANCE;
	}

    public long insertUser(User user) throws CustomException {
        QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult insertQuery = queryBuilder.insert(user).build();
        System.out.println("Insert Query: " + insertQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (Long) executor.executeQuery(insertQuery, User.class);
    }
    
    public long insertUser(User user, Connection conn) throws CustomException {
        QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult insertQuery = queryBuilder.insert(user).build();
        System.out.println("Insert Query: " + insertQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (Long) executor.executeInsertWithConn(insertQuery, conn, true);
    }

    public int updateUser(User user) throws CustomException {
        QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult updateQuery = queryBuilder.update(user)
                         .where("user_id", "=", user.getUserId())
                         .build();
        System.out.println("Update Query: " + updateQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(updateQuery, null);
    }
    
    public int updatePassword(User user) throws CustomException {
        QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult updateQuery = queryBuilder.update(user, "passwordHash", "modifiedBy", "modifiedOn")
                         .where("user_id", "=", user.getUserId())
                         .build();
        System.out.println("Update Query: " + updateQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(updateQuery, null);
    }
    
    public int updateUser(User user, Connection connection) throws CustomException {
        QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult updateQuery = queryBuilder.update(user)
                         .where("user_id", "=", user.getUserId())
                         .build();
        System.out.println("Update Query: " + updateQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(updateQuery, connection, null);
    }

    public int deleteUser(Long userId) throws CustomException {
        QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult deleteQuery = queryBuilder.delete()
                         .where("user_id", "=", userId)
                         .build();
        System.out.println("Delete Query: " + deleteQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(deleteQuery, null);
    }

    public User getUserByEmail(String email) throws CustomException {
        QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult getQuery = queryBuilder.select("userId", "fullName", "email", "userType", "status", "passwordHash")
                         .where("email", "=", email)
                         .build();
        System.out.println("Select Query: " + getQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        @SuppressWarnings("unchecked")
		List<User> resultList = (List<User>) executor.executeQuery(getQuery, User.class);
        User user = Results.getSingleResult(resultList);
        if (user != null) {
        	return user;
        } else {
        	throw new CustomException("No users found for this email");
        }
    }
    
    public User getUserByPhone(String phone) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(User.class);
    	QueryResult getQuery = queryBuilder.select("userId", "fullName", "email", "userType", "status")
                							.where("phone", "LIKE", phone)
                							.build();
    	System.out.println("Select Query: " + getQuery);
    	QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
    	@SuppressWarnings("unchecked")
		List<User> resultList = (List<User>) executor.executeQuery(getQuery, User.class);
        User user = Results.getSingleResult(resultList);
        if (user != null) {
        	return user;
        } else {
        	throw new CustomException("No users found for this Phone Number");
        }
    }
    
    public User getUserById(Long userId) throws CustomException {
        QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult getQuery = queryBuilder.select("user_id", "fullName", "email", "userType", "status", "dob", "phone", "gender")
                         .where("user_id", "=", userId)
                         .build();
        System.out.println("Select Query: " + getQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        @SuppressWarnings("unchecked")
		List<User> resultList = (List<User>) executor.executeQuery(getQuery, User.class);
        User user = Results.getSingleResult(resultList);
        if (user != null) {
        	return user;
        } else {
        	throw new CustomException("No users found for this userId");
        }
    }
    
    public User getPasswordById(Long userId) throws CustomException {
        QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult getQuery = queryBuilder.select("user_id", "passwordHash")
                         .where("user_id", "=", userId)
                         .build();
        System.out.println("Select Query: " + getQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        @SuppressWarnings("unchecked")
		List<User> resultList = (List<User>) executor.executeQuery(getQuery, User.class);
        User user = Results.getSingleResult(resultList);
        if (user != null) {
        	return user;
        } else {
        	throw new CustomException("No users found for this userId");
        }
    }
    
    public User getUserById(Long userId, Connection connection) throws CustomException {
        QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult getQuery = queryBuilder.select("user_id", "fullName", "email", "userType", "status", "passwordHash")
                         .where("user_id", "=", userId)
                         .build();
        System.out.println("Select Query: " + getQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        @SuppressWarnings("unchecked")
		List<User> resultList = (List<User>) executor.executeQuery(getQuery, connection, User.class);
        User user = Results.getSingleResult(resultList);
        if (user != null) {
        	return user;
        } else {
        	throw new CustomException("No users found for this userId");
        }
    }
    
    public User getUserPassword(Long userId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult getQuery = queryBuilder.select("user_id", "passwordHash")
                         .where("user_id", "=", userId)
                         .build();
        System.out.println("Select Query: " + getQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        @SuppressWarnings("unchecked")
		List<User> resultList = (List<User>) executor.executeQuery(getQuery, User.class);
        User user = Results.getSingleResult(resultList);
        if (user != null) {
        	return user;
        } else {
        	throw new CustomException("No users found for this userId");
        }
    }
    
    @SuppressWarnings("unchecked")
	public List<EmployeeProfile> getAllEmployeeDetails(int limit, int offset) throws CustomException {
    	
    	ValidationsUtil.checkLimitAndOffset(limit, offset);
    	
        QueryBuilder queryBuilder = new QueryBuilder(EmployeeProfile.class);
        QueryResult getQuery = queryBuilder.select( "u.user_id AS employee_id",
                									"u.full_name AS employee_name",
                									"u.email AS employee_email",
                									"e.role AS employee_role",
                									"e.branch AS employee_branch",
                									"b.branch_name AS employee_branch_name")
        											.join("INNER", "Employee e", "u.user_id = e.employee_id")
        											.join("INNER", "Branch b", "e.branch = b.branch_id")
        											.limit(limit)
        											.offset(offset)
        											.orderBy("employee_id", "ASC")
        											.build();
        System.out.println("Select Query: " + getQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (List<EmployeeProfile>) executor.executeQuery(getQuery, EmployeeProfile.class);
    }
    
    @SuppressWarnings("unchecked")
	public List<EmployeeProfile> getAllEmployeeDetails(Long branchId, int limit, int offset) throws CustomException {
    	
    	ValidationsUtil.checkLimitAndOffset(limit, offset);
    	
        QueryBuilder queryBuilder = new QueryBuilder(EmployeeProfile.class);
        QueryResult getQuery = queryBuilder.select( "u.user_id AS employee_id",
        											"u.full_name AS employee_name",
                									"u.email AS employee_email",
                									"e.role AS employee_role",
                									"e.branch_id AS employee_branch",
        											"b.branch_name AS employee_branch_name")
        											.join("INNER", "Employee e", "u.user_id = e.employee_id")
        											.join("INNER", "Branch b", "e.branch_id = b.branch_id")
        											.where("e.branch_id", "=", branchId)
        											.limit(limit)
        											.offset(offset)
        											.orderBy("employee_id", "ASC")
        											.build();
        System.out.println("Select Query: " + getQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (List<EmployeeProfile>) executor.executeQuery(getQuery, EmployeeProfile.class);
    }

    @SuppressWarnings("unchecked")
	public List<User> getAllUsers(int limit, int offset) throws CustomException {
        QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult getQuery = queryBuilder.select("*")
                         .limit(limit)
                         .build();
        System.out.println("Paginated Select Query: " + getQuery.toString());
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (List<User>) executor.executeQuery(getQuery, User.class);
    }
}

