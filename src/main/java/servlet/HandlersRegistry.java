package servlet;

import java.io.IOException;
import java.lang.reflect.Method;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.fasterxml.jackson.databind.ObjectMapper;
import annotations.FromBody;
import annotations.FromHeader;
import annotations.FromQuery;
import annotations.FromSession;
import annotations.Route;
import util.CustomException;
import util.Results;
import java.lang.reflect.*;

public class HandlersRegistry {
    private final Map<String, Map<String, Method>> routeMap = new HashMap<>();
    private final Map<String, Object> handlerInstances = new HashMap<>();
    private final AuthConfig authConfig = new AuthConfig("/home/sakthi-pt7767/eclipse-workspace/zoho_jade_bank/src/main/java/resources/permissions.yaml");

    public void register(String key, Object handler) {
        handlerInstances.put(key, handler);
        for (Method method : handler.getClass().getDeclaredMethods()) {
            if (method.isAnnotationPresent(Route.class)) {
                Route route = method.getAnnotation(Route.class);
                String routeKey = route.method().toUpperCase() + ":" + route.path();
                routeMap.computeIfAbsent(key, k -> new HashMap<>()).put(routeKey, method);
            }
        }
    }

    public void dispatch(HttpServletRequest request, HttpServletResponse response) {
    	try {
	        long startTime = System.currentTimeMillis();
	
	        String pathInfo = request.getPathInfo(); 
	        String method = request.getMethod();     
	        String action = request.getParameter("action"); 
	        int role = getUserRole(request, response);
	
	        System.out.println("\n[LOG] Incoming request: " + method + " " + pathInfo + "?action=" + action + " | Role: " + role);
	
	        if (pathInfo == null || pathInfo.split("/").length < 2) {
	            Results.respondError(response, 400, "Invalid URL");
	            return;
	        }
	
	        String handlerKey = pathInfo.split("/")[1];
	        Object handler = handlerInstances.get(handlerKey);
	        Method targetMethod = routeMap.getOrDefault(handlerKey, Collections.emptyMap())
	                .get(method + ":" + action);
	
	        if (handler == null || targetMethod == null) {
	            Results.respondError(response, 404, "Route not found");
	            return;
	        }
	
	        if (!authConfig.isAuthorized(handlerKey, action, role)) {
	            Results.respondError(response, 403, "Unauthorized access");
	            return;
	        }
	
	        try {
	            Object[] args = resolveParameters(request, targetMethod);
	            String json = (String) targetMethod.invoke(handler, args);
	            response.setContentType("application/json");
	            response.getWriter().write(json);
	        } catch (InvocationTargetException e) {
	            Results.respondError(response, 500, e.getCause().getMessage());
	            e.printStackTrace();
	        } catch (Exception e) {
	        	Results.respondJson(response, e.getMessage());
	        } finally {
	            long duration = System.currentTimeMillis() - startTime;
	            System.out.println("[LOG] Execution time: " + duration + "ms");
	        }
	        
    	} catch(CustomException e) {
    		e.printStackTrace();
    	}
    }

    private Object[] resolveParameters(HttpServletRequest request, Method method) throws IOException {
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

            } else if(param.isAnnotationPresent(FromSession.class)) {
            	String value;
            	if (session != null) {
	            	String key = param.getAnnotation(FromSession.class).value();
	            	value = (String) session.getAttribute(key);
	            	args[i] = convertToType(value, type);
            	} else {
            		args[i] = null;
            	}
            	
//            } else if (param.isAnnotationPresent(FromSession.class)){ 
//            	String key = param.getAnnotation(FromSession.class).value();
//            	Object obj = session.getAttribute(key);
//            	args[i] = obj;
            } else {
                args[i] = null;
            }
        }
        return args;
    }
    
    private int getUserRole(HttpServletRequest request, HttpServletResponse response) throws CustomException {
    	HttpSession session = request.getSession(false);
    	if (session == null) {
    		Results.respondError(response, 403, "Session not found, Please login");
    	}
    	return (int) session.getAttribute("role");
    }

    private Object convertToType(String value, Class<?> type) {
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

