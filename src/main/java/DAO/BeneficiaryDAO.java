package DAO;

import java.sql.Connection;
import java.util.List;

import pojos.Beneficiary;
import querybuilder.QueryBuilder;
import querybuilder.QueryExecutor;
import querybuilder.QueryResult;
import util.CustomException;
import util.Results;

public class BeneficiaryDAO {
	
	private BeneficiaryDAO() {
		if (BeneficiaryDAOHelper.INSTANCE != null) {
			throw new IllegalStateException("BeneficiaryDAO instance already created");
		}
	}
	
	private static class BeneficiaryDAOHelper{
		private static final BeneficiaryDAO INSTANCE = new BeneficiaryDAO();
	}
	
	public static BeneficiaryDAO getBeneficiaryDAOInstance() {
		return BeneficiaryDAOHelper.INSTANCE;
	}

	public Long insertBeneficiary(Beneficiary benefiaciary) throws CustomException {
		QueryBuilder queryBuilder = new QueryBuilder(Beneficiary.class);
		QueryResult insertQuery = queryBuilder.insert(benefiaciary).build();
        System.out.println("Insert Query: " + insertQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (Long) executor.executeQuery(insertQuery, Beneficiary.class);
	}
	
	public Long addAsBeneficiary(Beneficiary benefiaciary, Connection connection) throws CustomException {
		QueryBuilder queryBuilder = new QueryBuilder(Beneficiary.class);
		QueryResult insertQuery = queryBuilder.insert(benefiaciary)
											  .build();
        System.out.println("Insert Query: " + insertQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (Long) executor.executeInsertWithConn(insertQuery, connection, true);
	}
	
	public Integer updateBeneficiary(Beneficiary beneficiary) throws CustomException {
        QueryBuilder queryBuilder = new QueryBuilder(Beneficiary.class);
        QueryResult updateQuery = queryBuilder.update(beneficiary)
                         .where("beneficiar_id", "=", beneficiary.getBeneficiaryId())
                         .build();
        System.out.println("Update Query: " + updateQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (Integer) executor.executeQuery(updateQuery, null);
    }
	
	public int deleteBeneficiary(Long beneficiaryId) throws CustomException {
        QueryBuilder queryBuilder = new QueryBuilder(Beneficiary.class);
        QueryResult deleteQuery = queryBuilder.delete()
                         .where("beneficiary_id", "=", beneficiaryId)
                         .build();
        System.out.println("Delete Query: " + deleteQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(deleteQuery, null);
    }
	
	public Beneficiary getBeneficiaryById(long beneficiarId) throws CustomException {
		QueryBuilder queryBuilder = new QueryBuilder(Beneficiary.class);
        QueryResult getQuery = queryBuilder.select("*")
        				.where("beneficiar_id", "=", beneficiarId)	
        				.build();
        System.out.println("Paginated Select Query: " + getQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        @SuppressWarnings("unchecked")
		List<Beneficiary> beneficiaries = (List<Beneficiary>) executor.executeQuery(getQuery, Beneficiary.class);
        return Results.getSingleResult(beneficiaries);
	}
	
	public Beneficiary getUniqueBeneficiary(String ifscCode, Long accountId, Long beneficiaryAccNumber, Long creatorId) throws CustomException {
		QueryBuilder queryBuilder = new QueryBuilder(Beneficiary.class);
        QueryResult getQuery = queryBuilder.select("*")
        				.where("ifsc_code", "=", ifscCode)
        				.where("account_id", "=", accountId)
        				.where("account_number", "=", beneficiaryAccNumber)
        				.where("created_by", "=", creatorId)
        				.build();
        System.out.println("Paginated Select Query: " + getQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        @SuppressWarnings("unchecked")
		List<Beneficiary> beneficiaries = (List<Beneficiary>) executor.executeQuery(getQuery, Beneficiary.class);
        return Results.getSingleResult(beneficiaries);
	}
	
	@SuppressWarnings("unchecked")
	public List<Beneficiary> getBeneficiariesByAccountId(long accountId, long userId, int limit, int offset) throws CustomException {
        QueryBuilder queryBuilder = new QueryBuilder(Beneficiary.class);
        QueryResult getQuery = queryBuilder.select("*")
        				.where("account_id", "=", accountId)
        				.where("created_by", "=", userId)
        				.limit(limit)
        				.offset(offset)
        				.build();
        System.out.println("Paginated Select Query: " + getQuery);
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (List<Beneficiary>) executor.executeQuery(getQuery, Beneficiary.class);
    }
	
	@SuppressWarnings("unchecked")
	public List<Beneficiary> getAllBeneficiaries(int limit, int offset) throws CustomException {
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
