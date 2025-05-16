package DAO;

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

    public int createTransaction(Transaction transaction) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Transaction.class);
        QueryResult query = queryBuilder.insert(transaction).build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(query, null);
    }

    public Transaction getTransactionById(Long transactionId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Transaction.class);
        QueryResult query = queryBuilder.select("*")
                .where("transaction_id", "=", transactionId)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (Transaction) executor.executeQuery(query, Transaction.class);
    }

    public List<Transaction> getTransactionsByAccountId(Long accountId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Transaction.class);
        QueryResult query = queryBuilder.select("*")
                .where("account_id", "=", accountId)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Transaction.class));
    }

    public List<Transaction> getTransactionsByCustomerId(Long customerId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Transaction.class);
        QueryResult query = queryBuilder.select("*")
                .where("customer_id", "=", customerId)
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

