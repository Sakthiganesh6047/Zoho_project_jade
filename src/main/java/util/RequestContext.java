package util;

import java.util.Map;

public class RequestContext {
    private final String role;
    private final Map<String, String[]> queryParams;

    public RequestContext(String role, Map<String, String[]> queryParams) {
        this.role = role;
        this.queryParams = queryParams;
    }

    public String getRole() {
        return role;
    }

    public String getQueryParam(String key) {
        String[] values = queryParams.get(key);
        return (values != null && values.length > 0) ? values[0] : null;
    }

    public Map<String, String[]> getQueryParams() {
        return queryParams;
    }
}

