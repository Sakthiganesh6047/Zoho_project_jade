package util;

import java.lang.reflect.Method;
import java.util.List;
import java.util.regex.Pattern;

public class RouteInfo {

    public Pattern pattern;
    public Method method;
    public List<String> pathVariables;
    public Object handler;

    public RouteInfo(Pattern pattern, Method method, List<String> pathVariables, Object handler) {
        this.pattern = pattern;
        this.method = method;
        this.pathVariables = pathVariables;
        this.handler = handler;
    }
    
    @Override
    public String toString() {
        return "RouteInfo{" +
               "pattern=" + pattern.pattern() +
               ", method=" + method +
               ", pathVariables=" + pathVariables +
               ", handler=" + handler +
               '}';
    }


}
