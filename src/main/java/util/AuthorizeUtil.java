package util;

import java.io.IOException;
import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;

import DAO.EmployeeDAO;
import annotations.FromBody;
import annotations.FromHeader;
import annotations.FromPath;
import annotations.FromQuery;
import annotations.FromSession;
import pojos.Employee;

public class AuthorizeUtil {

	public static Employee getEmployeeDetails(long employeeId) throws CustomException {
    	EmployeeDAO employeeDAO = EmployeeDAO.getEmployeeDAOInstance();
    	return employeeDAO.getEmployeeById(employeeId);
    }
	
	public static Object[] resolveParameters(HttpServletRequest request, Method method, Map<String, String> pathParams) throws IOException {
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
                args[i] = mapper.readValue(request.getReader(), type);

            } else if (param.isAnnotationPresent(FromSession.class)) {
                String value = null;
                if (session != null) {
                    String key = param.getAnnotation(FromSession.class).value();
                    value = (String) session.getAttribute(key);
                }
                args[i] = convertToType(value, type);

            } else if (param.isAnnotationPresent(FromPath.class)) {
                String key = param.getAnnotation(FromPath.class).value();
                String val = pathParams.get(key);
                args[i] = convertToType(val, type);

            } else {
                args[i] = null;
            }
        }
        return args;
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
