package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import pojos.Employee;
import querybuilder.QueryBuilder;
import querybuilder.QueryExecutor;
import querybuilder.QueryResult;
import util.CustomException;
import util.DBConnection;
import util.Results;

public class EmployeeDAO {
	
	private EmployeeDAO() {
		if (EmployeeDAOHelper.INSTANCE != null) {
			throw new IllegalStateException("EmployeeDAO instance already created");
		}
	}
	
	private static class EmployeeDAOHelper{
		private static final EmployeeDAO INSTANCE = new EmployeeDAO();
	}
	
	public static EmployeeDAO getEmployeeDAOInstance() {
		return EmployeeDAOHelper.INSTANCE;
	}

	public long insertEmployee(Employee employee) throws CustomException {
		QueryBuilder queryBuilder = new QueryBuilder(Employee.class);
		QueryResult insertQuery = queryBuilder.insert(employee).build();
        System.out.println("Insert Query: " + insertQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (long) executor.executeQuery(insertQuery, Employee.class);
	}
	
	public long insertEmployee(Employee employee, Connection conn) throws CustomException {
		QueryBuilder queryBuilder = new QueryBuilder(Employee.class);
		QueryResult insertQuery = queryBuilder.insert(employee).build();
        System.out.println("Insert Query: " + insertQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (long) executor.executeInsertWithConn(insertQuery, conn, false);
	}
	
	@SuppressWarnings("unchecked")
	public <T> Employee getEmployeeById(Long employeeId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Employee.class);
        QueryResult query = queryBuilder.select("*")
                .where("employee_id", "=", employeeId)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        Employee employee = (Employee) Results.getSingleResult((List<T>) executor.executeQuery(query, Employee.class));
        return employee ;
    }
	
	public int updateEmployee(Employee employee) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(Employee.class);
        QueryResult updateQuery = queryBuilder.update(employee)
                         .where("employee_id", "=", employee.getEmployeeId())
                         .build();
        System.out.println("Update Query: " + updateQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(updateQuery, null);
    }
	
	public int updateEmployee(Employee employee, Connection connection) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(Employee.class);
        QueryResult updateQuery = queryBuilder.update(employee)
                         .where("employee_id", "=", employee.getEmployeeId())
                         .build();
        System.out.println("Update Query: " + updateQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(updateQuery, connection, null);
    }
	
	public int deleteEmployee(Long employeeId) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(Employee.class);
        QueryResult deleteQuery = queryBuilder.delete()
                         .where("employee_id", "=", employeeId)
                         .build();
        System.out.println("Delete Query: " + deleteQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(deleteQuery, null);
    }
	
	@SuppressWarnings("unchecked")
	public List<Employee> getAllEmployees(int limit, int offset) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(Employee.class);
        QueryResult getQuery = queryBuilder.select("*")
                         .limit(limit)
                         .offset(offset)
                         .build();
        System.out.println("Paginated Select Query: " + getQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (List<Employee>) executor.executeQuery(getQuery, Employee.class);
    }
	
	public Map<Integer, Integer> getRoleCounts() throws CustomException {
	    	
    	try(Connection connection = DBConnection.getConnection()) {
	    	
	        String sql = "SELECT role, COUNT(*) AS total_count FROM Employee WHERE role IN (1, 2, 3) GROUP BY role";
	        Map<Integer, Integer> roleCounts = new HashMap<>();
	
	        try (PreparedStatement ps = ((Connection) connection).prepareStatement(sql);
	             ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                int role = rs.getInt("role");
	                int count = rs.getInt("total_count");
	                roleCounts.put(role, count);
	            }
	        }
	
	        return roleCounts;
    	} catch (Exception e) {
    		throw new CustomException(e.getMessage());
    	}
	 }
	
	public Map<Integer, Integer> getRoleCountsByBranch(long branchId) throws CustomException {
		
		try(Connection connection = DBConnection.getConnection()) {
		    String sql = "SELECT role, COUNT(*) AS total_count FROM Employee WHERE branch = ? AND role IN (1, 2, 3) GROUP BY role";
		    Map<Integer, Integer> roleCounts = new HashMap<>();
	
		    try (PreparedStatement ps = connection.prepareStatement(sql)) {
		        ps.setLong(1, branchId);
		        try (ResultSet rs = ps.executeQuery()) {
		            while (rs.next()) {
		                int role = rs.getInt("role");
		                int count = rs.getInt("total_count");
		                roleCounts.put(role, count);
		            }
		        }
		    }
	
		    return roleCounts;
		} catch(Exception e) {
			throw new CustomException(e.getMessage());
		}
	}
		

}
