package querybuilder;

import java.io.InputStream;
import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.yaml.snakeyaml.Yaml;
import util.CustomException;
import util.DBConnection;

public class QueryExecutor {
	
	private static Map<String, Object> yamlMappings = new HashMap<>();
	
	private QueryExecutor() {
    	if (QueryExecutorHelper.INSTANCE != null) {
            throw new IllegalStateException("Singleton instance already created");
        }
    }

    private static class QueryExecutorHelper {
        private static final QueryExecutor INSTANCE = new QueryExecutor();
    }

    public static QueryExecutor getQueryExecutorInstance() {
        return QueryExecutorHelper.INSTANCE;
    }
	
    public <T> Object executeQuery(QueryResult queryResult, Class<T> pojoClass) throws CustomException {
        String sql = queryResult.getQuery().trim().toUpperCase();
        boolean isSelect = sql.startsWith("SELECT");
        boolean isInsert = sql.startsWith("INSERT");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = isInsert
                 ? conn.prepareStatement(queryResult.getQuery(), Statement.RETURN_GENERATED_KEYS)
                 : conn.prepareStatement(queryResult.getQuery())) {

            List<Object> params = queryResult.getParameters();
            if (params != null) {
                for (int i = 0; i < params.size(); i++) {
                    stmt.setObject(i + 1, params.get(i));
                }
            }

            System.out.println(stmt);

            if (isSelect) {
                ResultSet rs = stmt.executeQuery();
                loadYamlMappings();
                return mapResultSetToPojo(rs, pojoClass, yamlMappings);
            } else {
                int affectedRows = stmt.executeUpdate();

                if (isInsert) {
                    try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            return generatedKeys.getLong(1);
                        }
                    }
                }

                return affectedRows;
            }

        } catch (Exception e) {
            throw new CustomException("Failed in query execution", e);
        }
    }

    public long executeInsertWithConn(QueryResult queryResult, Connection conn, boolean returnGeneratedKeys) throws CustomException {
        try (PreparedStatement stmt = conn.prepareStatement(
                queryResult.getQuery(), 
                returnGeneratedKeys ? Statement.RETURN_GENERATED_KEYS : Statement.NO_GENERATED_KEYS
            )) {
            
            List<Object> params = queryResult.getParameters();
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            System.out.println(stmt);

            int affectedRows = stmt.executeUpdate();

            if (returnGeneratedKeys) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getLong(1);
                    } else {
                        throw new CustomException("No ID returned from insert.");
                    }
                }
            } else {
                return affectedRows;
            }
            
        } catch (SQLException e) {
            throw new CustomException("Error in query execution", e);
        }
    }
    
    private void loadYamlMappings() {
        try (InputStream inputStream = Thread.currentThread().getContextClassLoader().getResourceAsStream("resources/orm_mapping.yaml")) {
            Yaml yaml = new Yaml();
            Map<String, Object> rawMap = yaml.load(inputStream);

            for (Map.Entry<String, Object> entry : rawMap.entrySet()) {
                String className = entry.getKey();
                Object value = entry.getValue();

                if (value instanceof Map<?, ?>) {
                    Map<?, ?> classMapping = (Map<?, ?>) value;
                    Object fieldsObj = classMapping.get("fields");

                    if (fieldsObj instanceof Map<?, ?>) {
                        Map<?, ?> fields = (Map<?, ?>) fieldsObj;
                        Map<String, String> invertedFields = new HashMap<>();

                        for (Map.Entry<?, ?> fieldEntry : fields.entrySet()) {
                            String javaField = String.valueOf(fieldEntry.getKey());
                            String dbColumn = String.valueOf(fieldEntry.getValue());
                            invertedFields.put(dbColumn, javaField);
                        }

                        yamlMappings.put(className, invertedFields);
                    }
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error loading YAML: " + e.getMessage(), e);
        }
    }
    
    private <T> List<T> mapResultSetToPojo(ResultSet rs, Class<T> clazz, Map<String, Object> fieldMappings) throws SQLException {
        List<T> resultList = new ArrayList<>();
        ResultSetMetaData metaData = rs.getMetaData();
        int columnCount = metaData.getColumnCount();
        System.out.println(columnCount);

        @SuppressWarnings("unchecked")
        Map<String, String> columnToField = (Map<String, String>) fieldMappings.get(clazz.getSimpleName());
        if (columnToField == null) {
            throw new RuntimeException("No field mapping found for class: " + clazz.getSimpleName());
        }

        try {
            while (rs.next()) {
                T obj = clazz.getDeclaredConstructor().newInstance();
                for (int i = 1; i <= columnCount; i++) {
                    String columnName = metaData.getColumnLabel(i);
                    String fieldName = columnToField.get(columnName);

                    if (fieldName == null) continue;

                    try {
                        Field field = clazz.getDeclaredField(fieldName);
                        field.setAccessible(true);
                        field.set(obj, rs.getObject(i));
                    } catch (NoSuchFieldException ignore) {
                    }
                }
                resultList.add(obj);
            }
        
        } catch (Exception e) {
            e.printStackTrace();
        }

        return resultList;
    }
}
