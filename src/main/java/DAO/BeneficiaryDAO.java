package DAO;

import java.util.List;

import pojos.Beneficiary;
import querybuilder.QueryBuilder;
import querybuilder.QueryExecutor;
import querybuilder.QueryResult;
import util.CustomException;

public class BeneficiaryDAO {

	public int insertBeneficiary(Beneficiary benefiaciary) throws CustomException {
		QueryBuilder queryBuilder = new QueryBuilder(Beneficiary.class);
		QueryResult insertQuery = queryBuilder.insert(benefiaciary).build();
        System.out.println("Insert Query: " + insertQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(insertQuery, Beneficiary.class);
	}
	
	public int updateBeneficiary(Beneficiary benefiaciary, Long beneficiaryId) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(Beneficiary.class);
        QueryResult updateQuery = queryBuilder.update(benefiaciary)
                         .where("nominee_id", "=", beneficiaryId)
                         .build();
        System.out.println("Update Query: " + updateQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(updateQuery, null);
    }
	
	public int deleteBeneficiary(Long beneficiaryId) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(Beneficiary.class);
        QueryResult deleteQuery = queryBuilder.delete()
                         .where("beneficiary_id", "=", beneficiaryId)
                         .build();
        System.out.println("Delete Query: " + deleteQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(deleteQuery, null);
    }
	
	@SuppressWarnings("unchecked")
	public List<Beneficiary> getBeneficiariesByAccountId(int accountId) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(Beneficiary.class);
        QueryResult getQuery = queryBuilder.select("*")
        				.where("account_id", "=", accountId)	
        				.build();
        System.out.println("Paginated Select Query: " + getQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (List<Beneficiary>) executor.executeQuery(getQuery, Beneficiary.class);
    }
	
	@SuppressWarnings("unchecked")
	public List<Beneficiary> getAllBeneficiaries(int limit, int offset) throws Exception {
        QueryBuilder queryBuilder = new QueryBuilder(Beneficiary.class);
        QueryResult getQuery = queryBuilder.select("*")
                         .limit(limit)
                         .offset(offset)
                         .build();
        System.out.println("Paginated Select Query: " + getQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (List<Beneficiary>) executor.executeQuery(getQuery, Beneficiary.class);
    }
}
