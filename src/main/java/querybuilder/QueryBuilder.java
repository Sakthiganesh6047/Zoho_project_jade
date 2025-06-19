package querybuilder;

import org.yaml.snakeyaml.Yaml;
import util.CustomException;

import java.io.InputStream;
import java.lang.reflect.Field;
import java.util.*;
import java.util.stream.Collectors;

public class QueryBuilder {

    private static final Map<String, Object> YAMLMAPPINGS = new HashMap<>();
    private String tableName;
    private Map<String, String> fieldMappings;
    private List<Condition> conditions = new ArrayList<>();
    private List<String> selectedFields = new ArrayList<>();
    private List<String> joins = new ArrayList<>();
    private List<String> orderByFields = new ArrayList<>();
    private List<Object> parameters = new ArrayList<>();
    private List<Object> setParameters = new ArrayList<>();
    private Set<String> updateOnlyFields = new HashSet<>();
    private boolean isUpdate = false, isDelete = false, isSelect = false, isInsert = false;
    private Object entity;
    private Integer limit = null, offset = null;
    private boolean forUpdate = false;

    // Helper class to store each WHERE clause with its logic (AND/OR)
    private static class Condition {
        String logic;
        String clause;

        Condition(String logic, String clause) {
            this.logic = logic;
            this.clause = clause;
        }
    }

    static {
        try (InputStream inputStream = Thread.currentThread().getContextClassLoader().getResourceAsStream("resources/orm_mapping.yaml")) {
            Yaml yaml = new Yaml();
            YAMLMAPPINGS.putAll(yaml.load(inputStream));
        } catch (Exception e) {
            throw new RuntimeException("Error loading YAML: " + e.getMessage());
        }
    }

    public QueryBuilder(Class<?> clazz) throws CustomException {
        loadYamlMapping(clazz);
    }

    @SuppressWarnings("unchecked")
    private void loadYamlMapping(Class<?> clazz) throws CustomException {
        Map<String, Object> classMapping = (Map<String, Object>) YAMLMAPPINGS.get(clazz.getSimpleName());
        if (classMapping != null) {
            this.tableName = (String) classMapping.get("table");
            this.fieldMappings = (Map<String, String>) classMapping.get("fields");
        } else {
            throw new CustomException("No YAML mapping found for class: " + clazz.getSimpleName());
        }
    }

    public List<Object> getParameters() {
        return parameters;
    }

    public QueryBuilder insert(Object entity) {
        this.entity = entity;
        this.isInsert = true;
        return this;
    }

    public QueryBuilder update(Object entity) {
        this.entity = entity;
        this.isUpdate = true;
        this.updateOnlyFields.clear();
        return this;
    }

    public QueryBuilder update(Object entity, String... fieldsToUpdate) {
        this.entity = entity;
        this.isUpdate = true;
        this.updateOnlyFields.clear();
        this.updateOnlyFields.addAll(Arrays.asList(fieldsToUpdate));
        return this;
    }

    public QueryBuilder delete() {
        this.isDelete = true;
        return this;
    }

    public QueryBuilder where(String field, String operator, Object value, String logic) {
        String column = fieldMappings.getOrDefault(field, field);
        String clause;

        if ("IN".equalsIgnoreCase(operator) && value instanceof Collection) {
            Collection<?> values = (Collection<?>) value;
            String placeholders = values.stream().map(v -> "?").collect(Collectors.joining(", "));
            clause = column + " IN (" + placeholders + ")";
            parameters.addAll(values);

        } else if ("BETWEEN".equalsIgnoreCase(operator) && value instanceof List) {
            List<?> values = (List<?>) value;
            if (values.size() == 2) {
                clause = column + " BETWEEN ? AND ?";
                parameters.add(values.get(0));
                parameters.add(values.get(1));
            } else {
                throw new IllegalArgumentException("BETWEEN operator requires a List of exactly 2 elements.");
            }

        } else if ("IS NULL".equalsIgnoreCase(operator) || "IS NOT NULL".equalsIgnoreCase(operator)) {
            clause = column + " " + operator;

        } else {
            clause = column + " " + operator + " ?";
            parameters.add(value);
        }

        conditions.add(new Condition(logic.toUpperCase(), clause));
        return this;
    }

    public QueryBuilder where(String field, String operator, Object value) {
        return where(field, operator, value, "AND");
    }

    public QueryBuilder orWhere(String field, String operator, Object value) {
        return where(field, operator, value, "OR");
    }

    public QueryBuilder select(String... fields) {
        this.isSelect = true;
        Collections.addAll(this.selectedFields, fields);
        return this;
    }

    public QueryBuilder limit(int limit) {
        this.limit = limit;
        return this;
    }

    public QueryBuilder offset(int offset) {
        this.offset = offset;
        return this;
    }

    public QueryBuilder forUpdate() {
        this.forUpdate = true;
        return this;
    }

    public QueryBuilder orderBy(String field, String order) {
        String column = fieldMappings.getOrDefault(field, field);
        this.orderByFields.add(column + " " + order);
        return this;
    }

    public QueryBuilder join(String joinType, String joinTable, String condition) {
        joins.add(joinType + " JOIN " + joinTable + " ON " + condition);
        return this;
    }

    public QueryResult build() throws CustomException {
        try {
            StringBuilder query = new StringBuilder();

            if (isInsert) {
                parameters.clear();
                query.append("INSERT INTO ").append(tableName).append(" (");
                StringBuilder valuesPlaceholder = new StringBuilder("VALUES (");

                for (Field field : entity.getClass().getDeclaredFields()) {
                    field.setAccessible(true);
                    String columnName = fieldMappings.get(field.getName());
                    Object value = field.get(entity);

                    if (columnName != null) {
                        query.append(columnName).append(", ");
                        valuesPlaceholder.append("?, ");
                        parameters.add(value);
                    }
                }

                query.setLength(query.length() - 2);
                valuesPlaceholder.setLength(valuesPlaceholder.length() - 2);
                query.append(") ").append(valuesPlaceholder).append(")");

            } else if (isUpdate) {
                query.append("UPDATE ").append(tableName).append(" SET ");

                setParameters.clear();
                List<Object> whereParams = new ArrayList<>(parameters); // save WHERE params
                parameters.clear(); // reset for SET first

                for (String fieldName : fieldMappings.keySet()) {
                    Field field;
                    try {
                        field = entity.getClass().getDeclaredField(fieldName);
                    } catch (NoSuchFieldException e) {
                        continue;
                    }

                    field.setAccessible(true);
                    Object value = field.get(entity);
                    String columnName = fieldMappings.get(fieldName);
                    boolean includeField = updateOnlyFields.isEmpty() || updateOnlyFields.contains(fieldName);

                    if (includeField && columnName != null) {
                        query.append(columnName).append(" = ?, ");
                        setParameters.add(value);
                    }
                }

                if (setParameters.isEmpty()) {
                    throw new CustomException("No valid fields to update.");
                }

                query.setLength(query.length() - 2);

                if (!conditions.isEmpty()) {
                    query.append(" WHERE ");
                    for (int i = 0; i < conditions.size(); i++) {
                        Condition cond = conditions.get(i);
                        if (i > 0) query.append(" ").append(cond.logic).append(" ");
                        query.append(cond.clause);
                    }
                }

                parameters.addAll(setParameters);
                parameters.addAll(whereParams);

            } else if (isDelete) {
                query.append("DELETE FROM ").append(tableName);
                if (!conditions.isEmpty()) {
                    query.append(" WHERE ");
                    for (int i = 0; i < conditions.size(); i++) {
                        Condition cond = conditions.get(i);
                        if (i > 0) query.append(" ").append(cond.logic).append(" ");
                        query.append(cond.clause);
                    }
                }

            } else if (isSelect) {
                query.append("SELECT ");
                if (selectedFields.isEmpty()) {
                    query.append("*");
                } else {
                    for (String field : selectedFields) {
                        query.append(fieldMappings.getOrDefault(field, field)).append(", ");
                    }
                    query.setLength(query.length() - 2);
                }

                query.append(" FROM ").append(tableName);

                if (!joins.isEmpty()) {
                    query.append(" ").append(String.join(" ", joins));
                }

                if (!conditions.isEmpty()) {
                    query.append(" WHERE ");
                    for (int i = 0; i < conditions.size(); i++) {
                        Condition cond = conditions.get(i);
                        if (i > 0) query.append(" ").append(cond.logic).append(" ");
                        query.append(cond.clause);
                    }
                }

                if (!orderByFields.isEmpty()) {
                    query.append(" ORDER BY ").append(String.join(", ", orderByFields));
                }

                if (limit != null) {
                    query.append(" LIMIT ").append(limit);
                }

                if (offset != null) {
                    query.append(" OFFSET ").append(offset);
                }

                if (forUpdate) {
                    query.append(" FOR UPDATE");
                }
            }

            QueryResult result = new QueryResult(query.toString(), new ArrayList<>(parameters));
            reset();
            return result;

        } catch (IllegalAccessException e) {
            throw new CustomException("Error occurred while building the query", e);
        }
    }

    private void reset() {
        this.conditions.clear();
        this.selectedFields.clear();
        this.joins.clear();
        this.orderByFields.clear();
        this.parameters.clear();
        this.setParameters.clear();
        this.updateOnlyFields.clear();
        this.limit = null;
        this.offset = null;
        this.forUpdate = false;
        this.entity = null;
        this.isSelect = false;
        this.isInsert = false;
        this.isUpdate = false;
        this.isDelete = false;
    }
}
