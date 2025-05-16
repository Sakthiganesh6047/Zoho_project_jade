package util;

import java.io.IOException;
import java.util.List;
import javax.servlet.http.HttpServletResponse;
import com.fasterxml.jackson.databind.ObjectMapper;

public class results {

	public static <T> T getSingleResult(List<T> list) {
	    return (list == null || list.isEmpty()) ? null : list.get(0);
	}
	
	public static void respondJson(HttpServletResponse resp, Object data) throws IOException {
        resp.setContentType("application/json");
        new ObjectMapper().writeValue(resp.getWriter(), data);
    }
	
	public static void respondError(HttpServletResponse resp, int status, String message) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json");
        resp.getWriter().write("{\"error\":\"" + message + "\"}");
        System.out.println("[LOG] Response: " + status + " " + message);
    }
	
	public static String respondJson(Object data) throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.writeValueAsString(data);
    }

}
