package DAO;

import java.sql.Connection;
import java.util.Collections;
import java.util.List;
import pojos.Transaction;
import querybuilder.QueryBuilder;
import querybuilder.QueryExecutor;
import querybuilder.QueryResult;
import util.CustomException;

public class TransactionDAO {

//    private final QueryBuilder queryBuilder;
//    private final Map<String, Object> fieldMappings;
//
//    public TransactionDAO(QueryBuilder queryBuilder, Map<String, Object> fieldMappings) {
//        this.queryBuilder = queryBuilder;
//        this.fieldMappings = fieldMappings;
//    }

	private TransactionDAO() {
		if (TransactionDAOHelper.INSTANCE != null) {
			throw new IllegalStateException("TransactionDAO instance already created");
		}
	}
	
	private static class TransactionDAOHelper{
		private static final TransactionDAO INSTANCE = new TransactionDAO();
	}
	
	public static TransactionDAO getBranchDAOInstance() {
		return TransactionDAOHelper.INSTANCE;
	}
	
    public Long createTransaction(Transaction transaction) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Transaction.class);
        QueryResult query = queryBuilder.insert(transaction).build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (Long) executor.executeQuery(query, null);
    }
    
    public Long createTransaction(Transaction transaction, Connection connection) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Transaction.class);
        QueryResult query = queryBuilder.insert(transaction).build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (Long) executor.executeQuery(query, connection, null);
    }

    public Transaction getTransactionById(Long transactionId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Transaction.class);
        QueryResult query = queryBuilder.select("*")
                .where("transaction_id", "=", transactionId)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (Transaction) executor.executeQuery(query, Transaction.class);
    }

    public List<Transaction> getTransactionsByAccountId(Long accountId, int limit, int offset) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Transaction.class);
        QueryResult query = queryBuilder.select("*")
                .where("account_id", "=", accountId)
                .limit(limit)
                .offset(offset)
                .orderBy("transactionDate", "ASC")
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Transaction.class));
    }

    public List<Transaction> getTransactionsByCustomerId(Long customerId, int limit, int offset) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Transaction.class);
        QueryResult query = queryBuilder.select("*")
                .where("customer_id", "=", customerId)
                .limit(limit)
                .offset(offset)
                .orderBy("transaction_date", "DESC")
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Transaction.class));
    }
    
    public List<Transaction> getTransactionsBasedOnTime(Long accountId, Long fromDate, Long toDate, int limit, int offset) throws CustomException {
    	List<Long> dateList = List.of(fromDate, toDate);
    	QueryBuilder queryBuilder = new QueryBuilder(Transaction.class);
        QueryResult query = queryBuilder.select("*")
                .where("account_id", "=", accountId)
                .where("transaction_date", "BETWEEN", dateList)
                .limit(limit)
                .offset(offset)
                .orderBy("transaction_date", "DSC")
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Transaction.class));
    }

    public List<Transaction> getTransactionsByStatus(String status) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Transaction.class);
        QueryResult query = queryBuilder.select("*")
                .where("transaction_status", "=", status)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Transaction.class));
    }

    @SuppressWarnings("unchecked")
    private List<Transaction> castResult(Object result) {
        return result != null ? (List<Transaction>) result : Collections.emptyList();
    }
}

