package servlet;

import java.io.IOException;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import annotations.Authorized;
import annotations.Route;

public class HandlersRegistry {
    private final Map<String, Map<String, Method>> routeMap = new HashMap<>();
    private final Map<String, Object> handlerInstances = new HashMap<>();

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

    public void dispatch(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        long startTime = System.currentTimeMillis();

        String pathInfo = req.getPathInfo(); // e.g., /user
        String method = req.getMethod();     // e.g., GET
        String action = req.getParameter("action"); // e.g., getAll
        String role = req.getHeader("Role"); // or get from session/token

        System.out.println("\n[LOG] Incoming request: " + method + " " + pathInfo + "?action=" + action + " | Role: " + role);

        if (pathInfo == null || pathInfo.split("/").length < 2) {
            resp.setStatus(400);
            resp.getWriter().write("{\"error\":\"Invalid URL\"}");
            System.out.println("[LOG] Response: 400 Bad Request");
            return;
        }

        String handlerKey = pathInfo.split("/")[1]; // "user", "account", etc.
        Object handler = handlerInstances.get(handlerKey);
        Method targetMethod = routeMap.getOrDefault(handlerKey, Collections.emptyMap())
                                      .get(method + ":" + action);

        if (handler == null || targetMethod == null) {
            resp.setStatus(404);
            resp.getWriter().write("{\"error\":\"Route not found\"}");
            System.out.println("[LOG] Response: 404 Route not found for " + method + ":" + action + " in " + handlerKey);
            return;
        }

        // Authorization
        if (targetMethod.isAnnotationPresent(Authorized.class)) {
            Authorized auth = targetMethod.getAnnotation(Authorized.class);
            if (role == null || Arrays.stream(auth.roles()).noneMatch(role::equalsIgnoreCase)) {
                resp.setStatus(403);
                resp.getWriter().write("{\"error\":\"Unauthorized access\"}");
                System.out.println("[LOG] Authorization failed for role: " + role);
                return;
            }
        }

        try {
            System.out.println("[LOG] Executing: " + handler.getClass().getSimpleName() + "." + targetMethod.getName());
            targetMethod.invoke(handler, req, resp);
            System.out.println("[LOG] Handler executed successfully");
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"" + e.getCause().getMessage() + "\"}");
            System.out.println("[LOG] Internal Server Error: " + e.getCause());
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            System.out.println("[LOG] Execution time: " + duration + "ms");
        }
    }

}

