package DAO;

import java.util.List;

import pojos.Nominee;
import querybuilder.QueryBuilder;
import querybuilder.QueryExecutor;
import querybuilder.QueryResult;
import util.CustomException;

public class NomineeDAO {

	public int insertNominee(Nominee nominee) throws CustomException {
		QueryBuilder queryBuilder = new QueryBuilder(Nominee.class);
		QueryResult insertQuery = queryBuilder.insert(nominee).build();
        System.out.println("Insert Query: " + insertQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(insertQuery, Nominee.class);
	}
	
	public int updateNominee(Nominee nominee, Long nomineeId) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(Nominee.class);
        QueryResult updateQuery = queryBuilder.update(nominee)
                         .where("nominee_id", "=", nomineeId)
                         .build();
        System.out.println("Update Query: " + updateQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(updateQuery, null);
    }
	
	public int deleteNominee(Long nomineeId) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(Nominee.class);
        QueryResult deleteQuery = queryBuilder.delete()
                         .where("employee_id", "=", nomineeId)
                         .build();
        System.out.println("Delete Query: " + deleteQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(deleteQuery, null);
    }
	
	@SuppressWarnings("unchecked")
	public List<Nominee> getNomineeForAccountId(int accountId) throws CustomException{
		QueryBuilder queryBuilder = new QueryBuilder(Nominee.class);
		QueryResult getNomineeByIdQuery = queryBuilder.select("*")
						.where("account_id", "=", accountId)
						.build();
		System.out.println("Delete Query: " + getNomineeByIdQuery);
		QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
		return (List<Nominee>) executor.executeQuery(getNomineeByIdQuery, Nominee.class);
	}
	
	@SuppressWarnings("unchecked")
	public List<Nominee> getAllNominees(int limit, int offset) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(Nominee.class);
        QueryResult getQuery = queryBuilder.select("*")
                         .limit(limit)
                         .offset(offset)
                         .build();
        System.out.println("Paginated Select Query: " + getQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (List<Nominee>) executor.executeQuery(getQuery, Nominee.class);
    }
}
