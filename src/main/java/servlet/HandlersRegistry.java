package servlet;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import annotations.Route;
import util.AuthorizeUtil;
import util.CustomException;
import util.Results;
import util.RouteInfo;

import java.lang.reflect.*;

public class HandlersRegistry {
	private final Map<String, List<RouteInfo>> routeMap = new HashMap<>();
    private final Map<String, Object> handlerInstances = new HashMap<>();
    private final AuthConfig authConfig = new AuthConfig("resources/permissions.yaml");

    
    public void register(String key, Object handler) {
        handlerInstances.put(key, handler);
        for (Method method : handler.getClass().getDeclaredMethods()) {
            if (method.isAnnotationPresent(Route.class)) {
                Route route = method.getAnnotation(Route.class);
                String httpMethod = route.method().toUpperCase();
                RouteInfo info = compileRoute(route.path(), method, handler);
                routeMap.computeIfAbsent(httpMethod, k -> new ArrayList<>()).add(info);
            }
        }
    }
    
    private RouteInfo compileRoute(String rawPath, Method method, Object handler) {
        List<String> pathVars = new ArrayList<>();
        Matcher m = Pattern.compile("\\{([^/]+)}").matcher(rawPath);
        StringBuffer regex = new StringBuffer();
        while (m.find()) {
            pathVars.add(m.group(1));
            m.appendReplacement(regex, "([^/]+)");
        }
        m.appendTail(regex);
        Pattern pattern = Pattern.compile("^" + regex.toString() + "$");
        return new RouteInfo(pattern, method, pathVars, handler);
    }
    
    
    public void dispatch(HttpServletRequest request, HttpServletResponse response) {
        try {
            long startTime = System.currentTimeMillis();
            String pathInfo = request.getPathInfo();
            if (pathInfo == null) {
                Results.respondError(response, 400, "Invalid path");
                return;
            }
            if (pathInfo.startsWith("/")) {
                pathInfo = pathInfo.substring(1); // remove leading slash
            }
 
            String method = request.getMethod();     
            int role = getUserRole(request, response);

            System.out.println("\n[LOG] Incoming request: " + method + " " + pathInfo + " | Role: " + role);

            List<RouteInfo> routes = routeMap.getOrDefault(method.toUpperCase(), Collections.emptyList());

            for (RouteInfo info : routes) {
                Matcher matcher = info.pattern.matcher(pathInfo);
                if (matcher.matches()) {
                    Map<String, String> pathParams = new HashMap<>();
                    for (int i = 0; i < info.pathVariables.size(); i++) {
                        pathParams.put(info.pathVariables.get(i), matcher.group(i + 1));
                    }

                    if (!authConfig.isAuthorized(info.handler, info.method, role)) {
                        Results.respondError(response, 403, "Unauthorized access");
                        return;
                    }

                    try {
                        Object[] args = AuthorizeUtil.resolveParameters(request, info.method, pathParams);
                        String json = (String) info.method.invoke(info.handler, args);
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
                    return;
                }
            }

            Results.respondError(response, 404, "Route not found");

        } catch (CustomException e) {
            e.printStackTrace();
        }
    }
    
    private int getUserRole(HttpServletRequest request, HttpServletResponse response) throws CustomException {
    	HttpSession session = request.getSession(false);
    	if (session == null) {
    		Results.respondError(response, 403, "Session not found, Please login");
    	}
    	return (int) session.getAttribute("role");
    }

}

