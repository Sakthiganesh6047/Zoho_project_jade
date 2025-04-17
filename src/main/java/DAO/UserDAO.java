package DAO;

import java.util.List;

import pojos.User;
import querybuilder.QueryBuilder;
import querybuilder.QueryExecutor;
import querybuilder.QueryResult;
import util.results;

public class UserDAO {

    public int insertUser(User user) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult insertQuery = queryBuilder.insert(user).build();
        System.out.println("Insert Query: " + insertQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(insertQuery, User.class);
    }

    public int updateUser(User user, Long userId) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult updateQuery = queryBuilder.update(user)
                         .where("user_id", "=", userId)
                         .build();
        System.out.println("Update Query: " + updateQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(updateQuery, null);
    }

    public int deleteUser(Long userId) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult deleteQuery = queryBuilder.delete()
                         .where("user_id", "=", userId)
                         .build();
        System.out.println("Delete Query: " + deleteQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(deleteQuery, null);
    }

    public User getUserByEmail(String email) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult getQuery = queryBuilder.select("fullName", "userType", "status", "phone")
                         .where("email", "=", email)
                         .build();
        System.out.println("Select Query: " + getQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        @SuppressWarnings("unchecked")
		List<User> resultList = (List<User>) executor.executeQuery(getQuery, User.class);
        return results.getSingleResult(resultList);
    }

    @SuppressWarnings("unchecked")
	public List<User> getAllUsers(int limit, int offset) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(User.class);
        QueryResult getQuery = queryBuilder.select("*")
                         .limit(limit)
                         .build();
        System.out.println("Paginated Select Query: " + getQuery.toString());
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (List<User>) executor.executeQuery(getQuery, User.class);
    }
}

