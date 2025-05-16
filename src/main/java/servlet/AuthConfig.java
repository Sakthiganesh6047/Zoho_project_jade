package servlet;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.yaml.snakeyaml.Yaml;

public class AuthConfig {
    private final Map<String, Map<String, List<Integer>>> permissions;

    public AuthConfig(String yamlFile) {
        Yaml yaml = new Yaml();
        try (InputStream inputStream = new FileInputStream(yamlFile)) {
            permissions = yaml.load(inputStream);
        } catch (Exception e) {
            throw new RuntimeException("Failed to load permissions.yaml", e);
        }
    }

    public boolean isAuthorized(String handlerKey, String action, int role) {
        if (role <  0 || role > 3) {
        	return false;
        }
        List<Integer> allowedRoles = permissions
                .getOrDefault(handlerKey, Collections.emptyMap())
                .getOrDefault(action, Collections.emptyList());
        return allowedRoles.stream().anyMatch(r -> r.equals(role));
    }
} 
