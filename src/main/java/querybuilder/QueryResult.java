package querybuilder;

import java.util.List;

public class QueryResult {
    private String query;
    private List<Object> parameters;

    public QueryResult(String query, List<Object> parameters) {
        this.query = query;
        this.parameters = parameters;
    }

    public String getQuery() {
        return query;
    }

    public List<Object> getParameters() {
        return parameters;
    }
}

