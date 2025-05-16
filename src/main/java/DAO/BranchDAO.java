package DAO;

import java.util.Collections;
import java.util.List;

import pojos.Branch;
import querybuilder.QueryBuilder;
import querybuilder.QueryExecutor;
import querybuilder.QueryResult;
import util.CustomException;

public class BranchDAO {

//    private final QueryBuilder queryBuilder;
//    private final Map<String, Object> fieldMappings;
//
//    public BranchDAO(QueryBuilder queryBuilder, Map<String, Object> fieldMappings) {
//        this.queryBuilder = queryBuilder;
//        this.fieldMappings = fieldMappings;
//    }

    public int createBranch(Branch branch) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Branch.class);
        QueryResult query = queryBuilder.insert(branch).build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(query, null);
    }

    public Branch getBranchById(Long branchId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Branch.class);
        QueryResult query = queryBuilder.select("*")
                .where("branch_id", "=", branchId)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (Branch) executor.executeQuery(query, Branch.class);
    }

    public List<Branch> getAllBranches() throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Branch.class);
        QueryResult query = queryBuilder.select("*").build();
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

    public int updateBranch(Branch branch) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Branch.class);
        QueryResult query = queryBuilder.update(branch)
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

