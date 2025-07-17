package util;

import java.io.IOException;
import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;

import DAO.AccountDAO;
import DAO.EmployeeDAO;
import annotations.FromBody;
import annotations.FromHeader;
import annotations.FromPath;
import annotations.FromQuery;
import annotations.FromSession;
import pojos.Account;
import pojos.Employee;

public class AuthorizeUtil {

	public static Employee getEmployeeDetails(Long employeeId) throws CustomException {
    	EmployeeDAO employeeDAO = EmployeeDAO.getEmployeeDAOInstance();
    	return employeeDAO.getEmployeeById(employeeId);
    }
	
	public static Account getAccountDetails(Long accountId) throws CustomException {
		AccountDAO accountDAO = AccountDAO.getAccountDAOInstance();
		return accountDAO.getAccountById(accountId);
	}
	
	public static boolean isSameBranch(Long staffId, long accountId) throws CustomException {
		Employee employee = getEmployeeDetails(staffId);
		Account account1 = getAccountDetails(accountId);
		if (!(employee.getBranch() == account1.getBranchId())) {
			return false;
		}
		return true;
	}
	
	public static boolean isAuthorizedOwner(Long customerId, Long accountId) throws CustomException {
		AccountDAO accountDAO = AccountDAO.getAccountDAOInstance();
	    List<Account> accounts = accountDAO.getAccNosByCustomerId(customerId);
	    for (Account account : accounts) {
	        if (account.getAccountId().equals(accountId)) {
	        	System.out.print(account.getAccountId());
	            return true;
	        }
	    }
	    return false;
	}
	
	public static void checkAccountStatus(Long accountId) throws CustomException {
		AccountDAO accountDAO = AccountDAO.getAccountDAOInstance();
		Account account = accountDAO.getAccountById(accountId);
		if (account.getAccountStatus().equals(2)) {
			throw new CustomException("Account Blocked");
		}
		if (account.getAccountStatus().equals(3)) {
			throw new CustomException("Account Closed");
		}
	}
	
	public static Object[] resolveParameters(HttpServletRequest request, Method method, Map<String, String> pathParams) throws CustomException {
		try {
	        Parameter[] parameters = method.getParameters();
	        Object[] args = new Object[parameters.length];
	        ObjectMapper mapper = new ObjectMapper();
	        
	        HttpSession session = request.getSession(false);
	
	        for (int i = 0; i < parameters.length; i++) {
	            Parameter param = parameters[i];
	            Class<?> type = param.getType();
	
	            if (param.isAnnotationPresent(FromQuery.class)) {
	                String key = param.getAnnotation(FromQuery.class).value();
	                String val = request.getParameter(key);
	                args[i] = convertToType(val, type);
	
	            } else if (param.isAnnotationPresent(FromHeader.class)) {
	                String key = param.getAnnotation(FromHeader.class).value();
	                String val = request.getHeader(key);
	                args[i] = convertToType(val, type);
	
	            } else if (param.isAnnotationPresent(FromBody.class)) {
	                String contentType = request.getContentType();
	                if (contentType == null || !contentType.contains("application/json")) {
	                    throw new CustomException("Invalid Content-Type. Expected application/json.");
	                }
	                args[i] = mapper.readValue(request.getReader(), type);
	                
	            } else if (param.isAnnotationPresent(FromSession.class)) {
	                Object value = null;
	                if (session != null) {
	                    String key = param.getAnnotation(FromSession.class).value();
	                    value = session.getAttribute(key);
	                }
	                args[i] = convertToType(value.toString(), type);
	
	            } else if (param.isAnnotationPresent(FromPath.class)) {
	                String key = param.getAnnotation(FromPath.class).value();
	                String val = pathParams.get(key);
	                args[i] = convertToType(val, type);
	
	            } else {
	                args[i] = null;
	            }
	        }
	        return args;
		} catch(Exception e) {
			throw new CustomException("Error in resolving parameters", e);
		}
    }
	
	public static Object[] resolveParameter(HttpServletRequest request, Method method) throws IOException {
        Parameter[] parameters = method.getParameters();
        Object[] args = new Object[parameters.length];
        ObjectMapper mapper = new ObjectMapper();

        for (int i = 0; i < parameters.length; i++) {
            Parameter param = parameters[i];
            Class<?> type = param.getType();

            if (param.isAnnotationPresent(FromHeader.class)) {
                String key = param.getAnnotation(FromHeader.class).value();
                String val = request.getHeader(key);
                args[i] = convertToType(val, type);

            } else if (param.isAnnotationPresent(FromBody.class)) {
                args[i] = mapper.readValue(request.getReader(), type);

            } else {
                args[i] = null;
            }
        }
        return args;
    }
	
	public static Object convertToType(String value, Class<?> type) {
        if (value == null) {
        	return null;
        }
        if (type == String.class) {
        	return value;
        }
        if (type == int.class || type == Integer.class) {
        	return Integer.parseInt(value);
        }
        if (type == long.class || type == Long.class) {
        	return Long.parseLong(value);
        }
        if (type == boolean.class || type == Boolean.class) {
        	return Boolean.parseBoolean(value);
        }
        return value;
    }
	
}
