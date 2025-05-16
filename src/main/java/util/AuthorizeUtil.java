package util;

import DAO.EmployeeDAO;
import pojos.Employee;

public class AuthorizeUtil {

	public static Employee getEmployeeDetails(long employeeId) throws CustomException {
    	EmployeeDAO employeeDAO = EmployeeDAO.getEmployeeDAOInstance();
    	return employeeDAO.getEmployeeById(employeeId);
    }
	
}
