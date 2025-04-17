package DAO;

import java.util.List;

import pojos.Employee;
import querybuilder.QueryBuilder;
import querybuilder.QueryExecutor;
import querybuilder.QueryResult;
import util.CustomException;

public class EmployeeDAO {

	public int insertEmployee(Employee employee) throws CustomException {
		QueryBuilder queryBuilder = new QueryBuilder(Employee.class);
		QueryResult insertQuery = queryBuilder.insert(employee).build();
        System.out.println("Insert Query: " + insertQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(insertQuery, Employee.class);
	}
	
	public int updateEmployee(Employee employee, Long employeeId) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(Employee.class);
        QueryResult updateQuery = queryBuilder.update(employee)
                         .where("employee_id", "=", employeeId)
                         .build();
        System.out.println("Update Query: " + updateQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(updateQuery, null);
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
}
