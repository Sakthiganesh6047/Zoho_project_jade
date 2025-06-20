package DAO;

import java.util.Collections;
import java.util.List;
import pojos.Branch;
import querybuilder.QueryBuilder;
import querybuilder.QueryExecutor;
import querybuilder.QueryResult;
import util.CustomException;
import util.Results;

public class BranchDAO {

//    private final QueryBuilder queryBuilder;
//    private final Map<String, Object> fieldMappings;
//
//    public BranchDAO(QueryBuilder queryBuilder, Map<String, Object> fieldMappings) {
//        this.queryBuilder = queryBuilder;
//        this.fieldMappings = fieldMappings;
//    }

	private BranchDAO() {
		if (BranchDAOHelper.INSTANCE != null) {
			throw new IllegalStateException("BranchDAO instance already created");
		}
	}
	
	private static class BranchDAOHelper{
		private static final BranchDAO INSTANCE = new BranchDAO();
	}
	
	public static BranchDAO getBranchDAOInstance() {
		return BranchDAOHelper.INSTANCE;
	}
	
    public Long createBranch(Branch branch) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Branch.class);
        QueryResult query = queryBuilder.insert(branch).build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (Long) executor.executeQuery(query, null);
    }

    @SuppressWarnings("unchecked")
	public Branch getBranchById(Long branchId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Branch.class);
        QueryResult query = queryBuilder.select("*")
                .where("branch_id", "=", branchId)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        List<Branch> branchList = (List<Branch>) executor.executeQuery(query, Branch.class);
        return Results.getSingleResult(branchList);
    }

    public List<Branch> getBranchList(int limit, int offset) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Branch.class);
        QueryResult query = queryBuilder.select("branchId", "branchName", "branchDistrict", "ifscCode")
        								.limit(limit)
        								.offset(offset)
        								.build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Branch.class));
    }
    
    public List<Branch> getAllBranches() throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Branch.class);
        QueryResult query = queryBuilder.select("branchId", "branchName", "branchDistrict")
        								.orderBy("branchDistrict", "ASC")
        								.build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Branch.class));
    }
    
    public List<Branch> getAllBranches(Long branchId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Branch.class);
        QueryResult query = queryBuilder.select("branchId", "branchName", "branchDistrict")
        								.where("branchId", "=", branchId)
        								.orderBy("branchDistrict", "ASC")
        								.build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Branch.class));
    }

    public Branch getBranchByIfsc(String ifsc) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Branch.class);
        QueryResult query = queryBuilder.select("branchId", "branchName", "branchDistrict", "address", "ifscCode")
                .where("ifsc_code", "=", ifsc)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (Branch) executor.executeQuery(query, Branch.class);
    }
    
    public boolean ifscExists(String ifscCode) throws CustomException {
        QueryBuilder builder = new QueryBuilder(Branch.class);
        QueryResult query = builder.select("branch_id")
                                   .where("ifsc_code", "=", ifscCode)
                                   .build();
        List<Branch> result = castResult(QueryExecutor.getQueryExecutorInstance().executeQuery(query, Branch.class));
        return !result.isEmpty();
    }


    public int updateBranch(Branch branch) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Branch.class);
        QueryResult query = queryBuilder.update(branch, "branchName", "branchDistrict", "address")
                .where("branch_id", "=", branch.getBranchId())
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(query, null);
    }

    public int deleteBranch(Long branchId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Branch.class);
        QueryResult query = queryBuilder.delete()
                .where("branch_id", "=", branchId)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(query, null);
    }

    @SuppressWarnings("unchecked")
    private List<Branch> castResult(Object result) {
        return result != null ? (List<Branch>) result : Collections.emptyList();
    }
}

