package handlers;

import java.time.Instant;
import java.util.Map;
import DAO.AccountDAO;
import annotations.FromBody;
import annotations.FromQuery;
import annotations.FromSession;
import annotations.Route;
import pojos.Account;
import pojos.Employee;
import pojos.User;
import util.AuthorizeUtil;
import util.CustomException;
import util.Results;

public class AccountHandler {
	
	private final AccountDAO accountDAO;

    public AccountHandler(AccountDAO accountDAO) {
        this.accountDAO = accountDAO;
    }
    
    @Route(path = "account/new", method = "POST")
    public String createAccount(@FromBody Account account, @FromSession("userId") long creatorId, 
    							@FromSession("role") int creatorRole) throws CustomException {
    	account.setCreatedBy(creatorId);
    	account.setCreatedAt(Instant.now().toEpochMilli());
    	if (creatorRole == 0) {
    		account.setAccountStatus(2);
    	} else {
    		account.setAccountStatus(1);
    	}
    	long accountId = accountDAO.createAccount(account);
    	return Results.respondJson(Map.of("Status", "Created", "Account Id", accountId));
    }
    
    @Route(path = "account/id", method = "GET")
    public String getCustomerAccounts(@FromBody User user, @FromSession("userId") long sessionId, 
    									@FromSession("role") int role) throws CustomException {
    	if(role == 0) {
    		return Results.respondJson(accountDAO.getAccountsByCustomerId(sessionId));
    	} else {
    		return Results.respondJson(accountDAO.getAccountsByCustomerId(user.getUserId()));
    	}
    }
    
    @Route(path = "accounts/list", method = "GET")
    public String getAccountsList(@FromSession("userId")long userId, @FromSession("role") int role) throws CustomException {
    	if (role <= 2) {
    		Employee employee = AuthorizeUtil.getEmployeeDetails(userId);
    		return Results.respondJson(accountDAO.getAccountsList(employee.getBranch()));
    	} else {
    		return Results.respondJson(accountDAO.getAccountsList());
    	}
    }
    
    @Route(path = "account/details", method = "GET")
    public String getAccountDetails(@FromBody Account account, @FromSession("userId") long sessionId, 
    							@FromSession("role") int role) throws CustomException {
    	if(role == 0) {
    		Account fetchedAccount = accountDAO.getAccountById(account.getAccountId());
    		if (fetchedAccount.getCustomerId() == sessionId) {
    			return Results.respondJson(fetchedAccount);
    		} else {
    			throw new CustomException("Unauthorized access");
    		}
    	} else {
    		return Results.respondJson(accountDAO.getAccountById(account.getAccountId()));
    	}
    }
    
    @Route(path = "account/update", method = "POST")
    public String updateAccount(@FromBody Account account, @FromSession("userId") long modifierId, 
    							@FromSession("role") int role) throws CustomException {
    	if (role == 0) {
    		if(account.getCustomerId() != modifierId) {
    			throw new CustomException("Unauthorized Access, Check account Number");
    		}
    	}
    	account.setModifiedBy(modifierId);
    	account.setModifiedOn(Instant.now().toEpochMilli());
    	return Results.respondJson(accountDAO.updateAccount(account));
    }
    
    @Route(path = "account/activate", method = "POST")
    public String activateAccount(@FromBody Account account, @FromSession("userId") long modifierId, 
    						@FromSession("role") int role) throws CustomException {
    	
    	Account fetchedAccount = accountDAO.getAccountById(account.getAccountId());
    	
    	if(role <= 2) {
    		Employee employee = AuthorizeUtil.getEmployeeDetails(modifierId);
    		if(employee.getBranch() == account.getBranchId()) {
    			fetchedAccount.setAccountStatus(1);
    			fetchedAccount.setModifiedBy(modifierId);
    			fetchedAccount.setModifiedOn(Instant.now().toEpochMilli());
    			return Results.respondJson(accountDAO.updateAccount(fetchedAccount));
    		} else {
    			throw new CustomException("Unauthorized Access, Cannot activate account of different branch");
    		}
    	} else {
    		fetchedAccount.setAccountStatus(1);
    		fetchedAccount.setModifiedBy(modifierId);
    		fetchedAccount.setModifiedOn(Instant.now().toEpochMilli());
	    	return Results.respondJson(accountDAO.updateAccount(fetchedAccount));
    	}
    }
    
    @Route(path = "account/needapproval", method = "GET")
    public String getNewAccounts(@FromQuery("limit") int limit, @FromQuery("offset") int offset, 
    						@FromSession("userId") long userId) throws CustomException {
    	Employee employee = AuthorizeUtil.getEmployeeDetails(userId);
    	if (employee.getRole() <= 2) {
    		return Results.respondJson(accountDAO.getAccountByStatus(2, employee.getBranch(), limit, offset));
    	} else {
    		return Results.respondJson(accountDAO.getAccountsByStatus(2, limit, offset));
    	}
    }
    
    @Route(path = "account/close", method = "PUT")
    public String closeAccount(@FromBody Account account, @FromSession("userId") long modifierId, 
    						@FromSession("role") int role) throws CustomException {
    	
    	Account fetchedAccount = accountDAO.getAccountById(account.getAccountId());
    	
    	if (role <= 2) {
    		Employee employee = AuthorizeUtil.getEmployeeDetails(modifierId);
    		if(employee.getBranch() == fetchedAccount.getBranchId()) {
    			fetchedAccount.setAccountStatus(0);
    			fetchedAccount.setModifiedBy(modifierId);
    			fetchedAccount.setModifiedOn(Instant.now().toEpochMilli());
    	    	return Results.respondJson(accountDAO.updateAccount(account));
    		} else {
    			throw new CustomException("Unauthorized access, Contact respective branch");
    		}
    	} else {
    		fetchedAccount.setAccountStatus(0);
    		fetchedAccount.setModifiedBy(modifierId);
        	fetchedAccount.setModifiedOn(Instant.now().toEpochMilli());
        	return Results.respondJson(accountDAO.updateAccount(fetchedAccount));
    	}
    }
    
    @Route(path = "account/delete", method = "DELETE")
    public String deleteAccount(@FromBody Account account) throws CustomException {
    	return Results.respondJson(accountDAO.deleteAccount(account.getAccountId()));
    }
    
}
