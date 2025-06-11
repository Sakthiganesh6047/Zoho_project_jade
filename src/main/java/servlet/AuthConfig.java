package servlet;

import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.yaml.snakeyaml.Yaml;

public class AuthConfig {
    private final Map<String, Map<String, List<Integer>>> permissions;

    public AuthConfig(String yamlFile) {
        Yaml yaml = new Yaml();
        try (InputStream inputStream = Thread.currentThread().getContextClassLoader().getResourceAsStream(yamlFile)) {
            permissions = yaml.load(inputStream);
        } catch (Exception e) {
            throw new RuntimeException("Failed to load permissions.yaml", e);
        }
    }

    /**
     * Checks if the given role is authorized to invoke the given method on the handler.
     *
     * @param handler the handler object
     * @param method the method being invoked
     * @param role the user role
     * @return true if authorized, false otherwise
     */
    public boolean isAuthorized(Object handler, Method method, int role) {
        if (role < 0 || role > 4) {
            return false;
        }

        String handlerName = handler.getClass().getSimpleName(); // e.g., UserHandler
        String methodName = method.getName(); // e.g., getUser

        List<Integer> allowedRoles = permissions
                .getOrDefault(handlerName, Collections.emptyMap())
                .getOrDefault(methodName, Collections.emptyList());

        return allowedRoles.contains(role);
    }
}

