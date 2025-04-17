package DAO;

import java.util.Collections;
import java.util.List;

import pojos.Account;
import querybuilder.QueryBuilder;
import querybuilder.QueryExecutor;
import querybuilder.QueryResult;
import util.CustomException;

public class AccountDAO {

    public int createAccount(Account account) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult createQuery = queryBuilder.insert(account).build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(createQuery, null);
    }

    public Account getAccountById(Long accountId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.select("*")
						                .where("account_id", "=", accountId)
						                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
       return (Account) executor.executeQuery(query, Account.class);
    }

    public List<Account> getAccountsByCustomerId(Long customerId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.select("*")
                .where("customer_id", "=", customerId)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Account.class));
    }

    public List<Account> getAccountsByBranchId(Long branchId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.select("*")
                .where("branch_id", "=", branchId)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Account.class));
    }

    public List<Account> getAccountsByStatus(String status) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.select("*")
                .where("account_status", "=", status)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Account.class));
    }

    public int updateAccount(Account account) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Account.class);
        QueryResult query = queryBuilder.update(account)
                .where("account_id", "=", account.getAccountId())
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(query, null);
    }

    public int deleteAccount(Long accountId) throws CustomException {
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

