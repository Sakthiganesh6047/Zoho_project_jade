package util;

import java.io.IOException;
import java.util.List;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class Results {

	public static <T> T getSingleResult(List<T> list) {
	    return (list == null || list.isEmpty()) ? null : list.get(0);
	}
	
	public static void respondJson(HttpServletResponse resp, Object data) throws CustomException {
		try {
        resp.setContentType("application/json");
        new ObjectMapper().writeValue(resp.getWriter(), data);
		} catch(IOException e) {
			throw new CustomException("Error while responding in JSON", e);
		}
    }
	
	public static void respondError(HttpServletResponse resp, int status, String message) throws CustomException {
		try {
        resp.setStatus(status);
        resp.setContentType("application/json");
        resp.getWriter().write("{\"error\":\"" + message + "\"}");
        System.out.println("[LOG] Response: " + status + " " + message);
		} catch (IOException e) {
			throw new CustomException("Error while responding in JSON", e);
		}
    }
	
	public static String respondJson(Object data) throws CustomException {
        ObjectMapper mapper = new ObjectMapper();
        try {
        	String result = mapper.writeValueAsString(data);
        	//System.out.print(result);
			return result;
		} catch (JsonProcessingException e) {
			throw new CustomException("Error while converting to JSON", e);
		}
    }

}
