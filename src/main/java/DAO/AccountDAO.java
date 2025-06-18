package DAO;

import java.sql.Connection;
import java.util.Collections;
import java.util.List;

import pojos.Account;
import querybuilder.QueryBuilder;
import querybuilder.QueryExecutor;
import querybuilder.QueryResult;
import util.CustomException;
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

    public List<Account> getAccountsByBranchId(long branchId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.select("*")
                .where("branch_id", "=", branchId)
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
    
    public int updateAccount(Account account, Connection connection) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.update(account, "balance", "modifiedBy", "modifiedOn")
                .where("account_id", "=", account.getAccountId())
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(query, connection, null);
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

