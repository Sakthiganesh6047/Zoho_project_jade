package handlers;

import java.sql.Connection;
import java.util.Map;
import DAO.EmployeeDAO;
import pojos.Employee;
import util.CustomException;
import util.Results;

public class EmployeeHandler {

	private final EmployeeDAO employeeDAO;

    public EmployeeHandler(EmployeeDAO employeeDAO) {
        this.employeeDAO = employeeDAO;
    }
    
    public Employee getEmployeeDetails(Long userId) throws CustomException {
        return employeeDAO.getEmployeeById(userId);
    }
    
    public String insertEmployeeDetails(Employee employee) throws CustomException {
    	long result = employeeDAO.insertEmployee(employee);
    	return Results.respondJson(Map.of("Status", "created", "EmployeeId", result));
    }
    
    public String insertEmployeeDetails(Employee employee, Connection conn) throws CustomException {
    	long result = employeeDAO.insertEmployee(employee, conn);
    	return Results.respondJson(Map.of("Status", "created", "EmployeeId", result));
    }

    
}
