package DAO;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import pojos.Branch;
import querybuilder.QueryBuilder;
import querybuilder.QueryExecutor;
import querybuilder.QueryResult;
import util.CustomException;
import util.DBConnection;
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
    
    public Map<String, Integer> getAccountCountPerBranch() throws CustomException {
	     try(Connection connection = DBConnection.getConnection()){   
    		String sql = """
	            SELECT
	                b.branch_name,
	                COUNT(a.account_id) AS account_count
	            FROM
	                Branch b
	            LEFT JOIN
	                Account a ON b.branch_id = a.branch_id
	            GROUP BY
	                b.branch_name
	            ORDER BY
	                b.branch_name
	            """;
	
	        Map<String, Integer> branchAccountMap = new LinkedHashMap<>();
	
	        try (PreparedStatement ps = connection.prepareStatement(sql);
	             ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                String branchName = rs.getString("branch_name");
	                int count = rs.getInt("account_count");
	                branchAccountMap.put(branchName, count);
	            }
	        }
	
	        return branchAccountMap;
	     } catch(Exception e) {
	    	 throw new CustomException(e.getMessage());
	     }
    }
    
    public Map<String, BigDecimal> getTotalBalancePerBranch() throws CustomException {
    	try(Connection connection = DBConnection.getConnection()) {
    		String sql = """
	            SELECT
	                b.branch_name,
	                SUM(a.balance) AS total_balance
	            FROM
	                Branch b
	            JOIN
	                Account a ON b.branch_id = a.branch_id
	            GROUP BY
	                b.branch_id, b.branch_name
	            ORDER BY
	                b.branch_name
	            """;
	
	        Map<String, BigDecimal> branchBalanceMap = new LinkedHashMap<>();
	
	        try (PreparedStatement ps = connection.prepareStatement(sql);
	             ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                String branchName = rs.getString("branch_name");
	                BigDecimal totalBalance = rs.getBigDecimal("total_balance");
	                branchBalanceMap.put(branchName, totalBalance);
	            }
	        }
	
	        return branchBalanceMap;
    	} catch(Exception e) {
    		throw new CustomException(e.getMessage());
    	}
    }
    
    public Map<String, Map<String, Integer>> getBranchEmployeeAndAccountStats() throws CustomException {
    	try (Connection connection = DBConnection.getConnection()) {
    		String query = """
	            SELECT 
	                b.branch_name,
	                COUNT(DISTINCT e.employee_id) AS employee_count,
	                COUNT(DISTINCT a.account_id) AS account_count
	            FROM Branch b
	            LEFT JOIN Employee e ON e.branch = b.branch_id
	            LEFT JOIN Account a ON a.branch_id = b.branch_id
	            GROUP BY b.branch_name
	        """;
	
	        Map<String, Map<String, Integer>> result = new HashMap<>();
	
	        try (PreparedStatement stmt = connection.prepareStatement(query);
	             ResultSet rs = stmt.executeQuery()) {
	            while (rs.next()) {
	                String branchName = rs.getString("branch_name");
	                int employeeCount = rs.getInt("employee_count");
	                int accountCount = rs.getInt("account_count");
	
	                Map<String, Integer> counts = new HashMap<>();
	                counts.put("employees", employeeCount);
	                counts.put("accounts", accountCount);
	
	                result.put(branchName, counts);
	            }
	        }
	
	        return result;
    	}catch(Exception e) {
    		throw new CustomException(e.getMessage());
    	}
    }

    @SuppressWarnings("unchecked")
    private List<Branch> castResult(Object result) {
        return result != null ? (List<Branch>) result : Collections.emptyList();
    }
}

