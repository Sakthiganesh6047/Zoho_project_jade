package handlers;

import java.sql.Connection;
import java.util.Map;
import DAO.CustomerDAO;
import pojos.Customer;
import util.CustomException;
import util.Results;

public class CustomerHandler {

	private final CustomerDAO customerDAO;

    public CustomerHandler(CustomerDAO accountDAO) {
        this.customerDAO = accountDAO;
    }
    
    public Customer getCustomerDetails(Long userId) throws CustomException {
        return customerDAO.getCustomerById(userId);
    }
    
    public String insertCustomer(Customer customer) throws CustomException {
		long result = customerDAO.createCustomer(customer);
		return Results.respondJson(Map.of("Status", "Created", "Customer Id", result));
    }
    
    public String insertCustomer(Customer customer, Connection connection) throws CustomException {
    	long result = customerDAO.createCustomer(customer, connection);
    	return Results.respondJson(Map.of("Status", "Created", "Customer Id", result));
    }

}
