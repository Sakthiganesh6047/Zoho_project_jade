package DAO;

import java.sql.Connection;
import java.util.Collections;
import java.util.List;

import pojos.Customer;
import querybuilder.QueryBuilder;
import querybuilder.QueryExecutor;
import querybuilder.QueryResult;
import util.CustomException;

public class CustomerDAO {

//    private final QueryBuilder queryBuilder;
//    private final Map<String, Object> fieldMappings;
//
//    public CustomerDAO(QueryBuilder queryBuilder, Map<String, Object> fieldMappings) {
//        this.queryBuilder = queryBuilder;
//        this.fieldMappings = fieldMappings;
//    }

    public long createCustomer(Customer customer) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Customer.class);
        QueryResult query = queryBuilder.insert(customer).build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (long) executor.executeQuery(query, Customer.class);
    }
    
    public long createCustomer(Customer customer, Connection connection) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Customer.class);
        QueryResult query = queryBuilder.insert(customer).build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (long) executor.executeInsertWithConn(query, connection, false);
    }

    public Customer getCustomerById(Long customerId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Customer.class);
        QueryResult query = queryBuilder.select("*")
                .where("customer_id", "=", customerId)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (Customer) executor.executeQuery(query, Customer.class);
    }

    public List<Customer> getCustomersByBranchId(Long branchId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Customer.class);
        QueryResult query = queryBuilder.select("*")
                .where("branch_id", "=", branchId)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Customer.class));
    }

    public List<Customer> getCustomersByStatus(String status) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Customer.class);
        QueryResult query = queryBuilder.select("*")
                .where("customer_status", "=", status)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return castResult(executor.executeQuery(query, Customer.class));
    }

    public int updateCustomer(Customer customer) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Customer.class);
        QueryResult query = queryBuilder.update(customer)
                .where("customer_id", "=", customer.getCustomerId())
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(query, null);
    }

    public int deleteCustomer(Long customerId) throws CustomException {
    	QueryBuilder queryBuilder = new QueryBuilder(Customer.class);
        QueryResult query = queryBuilder.delete()
                .where("customer_id", "=", customerId)
                .build();
        QueryExecutor executor = QueryExecutor.getQueryExecutorInstance();
        return (int) executor.executeQuery(query, null);
    }

    @SuppressWarnings("unchecked")
    private List<Customer> castResult(Object result) {
        return result != null ? (List<Customer>) result : Collections.emptyList();
    }
}

