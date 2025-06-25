package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import pojos.Account;
import querybuilder.QueryBuilder;
import querybuilder.QueryExecutor;
import querybuilder.QueryResult;
import util.CustomException;
import util.DBConnection;
import util.Results;

public class AccountDAO {
	
	private AccountDAO() {
		if (AccountDAOHelper.INSTANCE != null) {
			throw new IllegalStateException("AccountDAO instance already created");
		}
	}
	
	private static class AccountDAOHelper{
		private static final AccountDAO INSTANCE = new AccountDAO();
	}
	
	public static AccountDAO getAccountDAOInstance() {
		return AccountDAOHelper.INSTANCE;
	}

    public Long createAccount(Account account) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult createQuery = queryBuilder.insert(account).build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (Long) executor.executeQuery(createQuery, null);
    }

    public Account getAccountById(long accountId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.select("*")
						                .where("account_id", "=", accountId)
						                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        @SuppressWarnings("unchecked")
		List<Account> accounts = (List<Account>) executor.executeQuery(query, Account.class);
        return Results.getSingleResult(accounts);
    }
    
    public Account getAccountForUpdate(long accountId, Connection connection) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.select("*")
						                .where("account_id", "=", accountId)
						                .forUpdate()
						                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        @SuppressWarnings("unchecked")
		List<Account> accounts = (List<Account>) executor.executeQuery(query, connection, Account.class);
        return Results.getSingleResult(accounts);
    }

    public List<Account> getAccountsByCustomerId(long customerId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.select("*")
                						.where("customer_id", "=", customerId)
                						.build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Account.class));
    }
    
    public List<Account> getAccNosByCustomerId(long customerId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.select("account_id")
                .where("customer_id", "=", customerId)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Account.class));
    }
    
    public List<Account> getAccountsFiltered(Long branchId, String status, String type, int limit, int offset) throws CustomException {
        QueryBuilder queryBuilder = new QueryBuilder(Account.class)
            .select("*")
            .where("branch_id", "=", branchId);

        if (type != null && !type.isEmpty()) {
            Integer typeCode = getAccountTypeCode(type); // e.g., savings → 1, current → 2
            if (typeCode != null) {
                queryBuilder.where("accountType", "=", typeCode);
            }
        }

        if (status != null && !status.isEmpty()) {
        	Integer statusCode = getAccountStatusCode(status);
        	if(statusCode != null) {
        		queryBuilder.where("accountStatus", "=", statusCode); // assuming it's a string column
        	}
        }

        queryBuilder.limit(limit).offset(offset);

        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        QueryResult query = queryBuilder.build();
        return castResult(executor.executeQuery(query, Account.class));
    }
    
    private Integer getAccountTypeCode(String type) {
        switch (type.toLowerCase()) {
            case "savings": return 1;
            case "current": return 2;
            default: return null;
        }
    }
    
    private Integer getAccountStatusCode(String status) {
    	switch(status.toLowerCase()) {
	    	case "active": return 1;
	    	case "blocked": return 0;
	    	case "new": return 2;
	    	default: return null;
    	}
    }
    
    public List<Account> getAccountsByStatus(Long branchId, int status, int limit, int offset) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.select("*")
                .where("account_status", "=", status) //1 - active, 2 - new, 0 - closed
                .where("branchId", "=", branchId)
                .limit(limit)
                .offset(offset)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Account.class));
    }

    public List<Account> getAccountsByStatus(int status, int limit, int offset) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.select("*")
                .where("account_status", "=", status) //1 - active, 2 - new, 0 - closed
                .limit(limit)
                .offset(offset)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Account.class));
    }
    
    public List<Account> getAccountByStatus(int status, long branchId, int limit, int offset) throws CustomException{
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
    	QueryResult query = queryBuilder.select("*")
    			.where("account_status", "=", status)
    			.where("branch_id", "=", branchId)
    			.limit(limit)
    			.offset(offset)
    			.build();
    	QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
    	return castResult(executor.executeQuery(query, Account.class));
    }
    
    public List<Account> getAccountsList(long branchId) throws CustomException{
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
    	QueryResult query = queryBuilder.select("*")
    			.where("branch_id", "=", branchId)
    			.build();
    	QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
    	return castResult(executor.executeQuery(query, Account.class));
    }
    
    public List<Account> getAccountsList() throws CustomException{
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
    	QueryResult query = queryBuilder.select("*")
    			.build();
    	QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
    	return castResult(executor.executeQuery(query, Account.class));
    }

    public int updateAccount(Account account) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.update(account, "balance", "modifiedBy", "modifiedOn")
                .where("account_id", "=", account.getAccountId())
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(query, null);
    }
    
    public int blockAccount(Account account) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.update(account, "accountStatus", "modifiedBy", "modifiedOn")
                .where("account_id", "=", account.getAccountId())
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(query, null);
    }
    
    public int updateAccount(Account account, Connection connection) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.update(account, "balance", "modifiedBy", "modifiedOn")
                .where("account_id", "=", account.getAccountId())
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(query, connection, null);
    }
    
    public Map<String, Integer> getCurrentWeekTransactionSplitByDayName() throws CustomException  {
	    try(Connection connection = DBConnection.getConnection()){    
	    	String sql = """
	    	        SELECT
	    	            DATE(FROM_UNIXTIME(transaction_date / 1000)) AS txn_date,
	    	            COUNT(*) AS transaction_count
	    	        FROM `Transaction`
	    	        WHERE FROM_UNIXTIME(transaction_date / 1000) BETWEEN
	    	              DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY)
	    	          AND DATE_ADD(DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY), INTERVAL 6 DAY)
	    	        GROUP BY txn_date
	    	        ORDER BY txn_date
	    	        """;

	    	    Map<String, Integer> result = new LinkedHashMap<>();

	    	    // Step 1: Get current week's Monday to Sunday
	    	    LocalDate today = LocalDate.now();
	    	    LocalDate monday = today.minusDays(today.getDayOfWeek().getValue() - 1);
	    	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEE", Locale.ENGLISH);

	    	    Map<LocalDate, String> dateToDayName = new HashMap<>();
	    	    for (int i = 0; i < 7; i++) {
	    	        LocalDate date = monday.plusDays(i);
	    	        String dayName = date.format(formatter);
	    	        result.put(dayName, 0); // initialize with 0
	    	        dateToDayName.put(date, dayName);
	    	    }

	    	    try (PreparedStatement ps = connection.prepareStatement(sql);
	    	         ResultSet rs = ps.executeQuery()) {
	    	        while (rs.next()) {
	    	            LocalDate txnDate = rs.getDate("txn_date").toLocalDate();
	    	            int count = rs.getInt("transaction_count");
	    	            String dayName = dateToDayName.get(txnDate);
	    	            if (dayName != null) {
	    	                result.put(dayName, count);
	    	            }
	    	        }
	    	    }
	    	    return result;
	    } catch(Exception e) {
	    	throw new CustomException(e.getMessage());
	    }
    }
    
    public Map<String, Integer> getCurrentWeekTransactionSplitByBranch(long branchId) throws CustomException {
    	try(Connection connection = DBConnection.getConnection()) {

		    String sql = """
		        SELECT
		            DATE(FROM_UNIXTIME(t.transaction_date / 1000)) AS txn_date,
		            COUNT(*) AS transaction_count
		        FROM `Transaction` t
		        JOIN `Account` a ON t.account_id = a.account_id
		        WHERE a.branch_id = ? AND FROM_UNIXTIME(t.transaction_date / 1000) BETWEEN
		              DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY)
		          AND DATE_ADD(DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY), INTERVAL 6 DAY)
		        GROUP BY txn_date
		        ORDER BY txn_date
		        """;

		    Map<String, Integer> result = new LinkedHashMap<>();

		    // Get current week's Monday
		    LocalDate today = LocalDate.now();
		    LocalDate monday = today.minusDays(today.getDayOfWeek().getValue() - 1);
		    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEE", Locale.ENGLISH); // Mon, Tue, ...

		    Map<LocalDate, String> dateToDayName = new HashMap<>();
		    for (int i = 0; i < 7; i++) {
		        LocalDate date = monday.plusDays(i);
		        String dayName = date.format(formatter);
		        result.put(dayName, 0);  // Initialize with 0
		        dateToDayName.put(date, dayName);
		    }

		    try (PreparedStatement ps = connection.prepareStatement(sql)) {
		        ps.setLong(1, branchId);
		        try (ResultSet rs = ps.executeQuery()) {
		            while (rs.next()) {
		                LocalDate txnDate = rs.getDate("txn_date").toLocalDate();
		                int count = rs.getInt("transaction_count");
		                String dayName = dateToDayName.get(txnDate);
		                if (dayName != null) {
		                    result.put(dayName, count);
		                }
		            }
		        }
		    }

		    return result;

    	} catch(Exception e) {
    		throw new CustomException(e.getMessage());
    	}
    }

    public int deleteAccount(long accountId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.delete()
                .where("account_id", "=", accountId)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(query, null);
    }

    @SuppressWarnings("unchecked")
    private List<Account> castResult(Object result) {
        return result != null ? (List<Account>) result : Collections.emptyList();
    }
}

