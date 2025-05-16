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
import util.AuthorizeUtil;
import util.CustomException;
import util.Results;

public class AccountHandler {
	
	private final AccountDAO accountDAO;

    public AccountHandler(AccountDAO accountDAO) {
        this.accountDAO = accountDAO;
    }
    
    @Route(path = "create", method = "POST")
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
    
    @Route(path = "accounts", method = "GET")
    public String getCustomerAccounts(@FromQuery("UserId") long userId, @FromSession("userId") long sessionId, 
    									@FromSession("role") int role) throws CustomException {
    	if(role == 0) {
    		return Results.respondJson(accountDAO.getAccountsByCustomerId(sessionId));
    	} else {
    		return Results.respondJson(accountDAO.getAccountsByCustomerId(userId));
    	}
    }
    
    @Route(path = "getList", method = "GET")
    public String getAccountsList(@FromSession("userId")long userId, @FromSession("role") int role) throws CustomException {
    	if (role <= 2) {
    		Employee employee = AuthorizeUtil.getEmployeeDetails(userId);
    		return Results.respondJson(accountDAO.getAccountsList(employee.getBranch()));
    	} else {
    		return Results.respondJson(accountDAO.getAccountsList());
    	}
    }
    
    @Route(path = "detail", method = "GET")
    public String getAccountDetails(@FromQuery("AccountNo") long accountId, @FromSession("userId") long sessionId, 
    							@FromSession("role") int role) throws CustomException {
    	if(role == 0) {
    		Account account = accountDAO.getAccountById(accountId);
    		if (account.getCustomerId() == sessionId) {
    			return Results.respondJson(account);
    		} else {
    			throw new CustomException("Unauthorized access");
    		}
    	} else {
    		return Results.respondJson(accountDAO.getAccountById(accountId));
    	}
    }
    
    @Route(path = "update", method = "POST")
    public String updateAccount(@FromBody Account account, @FromSession("userId") long modifierId) throws CustomException {
    	account.setModifiedBy(modifierId);
    	account.setModifiedOn(Instant.now().toEpochMilli());
    	return Results.respondJson(accountDAO.updateAccount(account));
    }
    
    @Route(path = "activate", method = "POST")
    public String activateAccount(@FromQuery("accountNo") long accountId, @FromSession("userId") long modifierId, 
    						@FromSession("role") int role) throws CustomException {
    	
    	Account account = accountDAO.getAccountById(accountId);
    	
    	if(role <= 2) {
    		Employee employee = AuthorizeUtil.getEmployeeDetails(modifierId);
    		if(employee.getBranch() == account.getBranchId()) {
    			account.setAccountStatus(1);
    	    	account.setModifiedBy(modifierId);
    	    	account.setModifiedOn(Instant.now().toEpochMilli());
    			return Results.respondJson(accountDAO.updateAccount(account));
    		} else {
    			throw new CustomException("Unauthorized Access, Cannot activate account of different branch");
    		}
    	} else {
	    	account.setAccountStatus(1);
	    	account.setModifiedBy(modifierId);
	    	account.setModifiedOn(Instant.now().toEpochMilli());
	    	return Results.respondJson(accountDAO.updateAccount(account));
    	}
    }
    
    @Route(path = "aprlWaiting", method = "GET")
    public String getNewAccounts(@FromSession("userId") long userId) throws CustomException {
    	Employee employee = AuthorizeUtil.getEmployeeDetails(userId);
    	if (employee.getRole() <= 2) {
    		return Results.respondJson(accountDAO.getAccountByStatus(2, employee.getBranch()));
    	} else {
    		return Results.respondJson(accountDAO.getAccountsByStatus(2));
    	}
    }
    
    @Route(path = "close", method = "PUT")
    public String closeAccount(@FromQuery("accountNo") long accountId, @FromSession("userId") long modifierId, 
    						@FromSession("role") int role) throws CustomException {
    	
    	Account account = accountDAO.getAccountById(accountId);
    	
    	if (role <= 2) {
    		Employee employee = AuthorizeUtil.getEmployeeDetails(modifierId);
    		if(employee.getBranch() == account.getBranchId()) {
    			account.setAccountStatus(0);
    	    	account.setModifiedBy(modifierId);
    	    	account.setModifiedOn(Instant.now().toEpochMilli());
    	    	return Results.respondJson(accountDAO.updateAccount(account));
    		} else {
    			throw new CustomException("Unauthorized access, Contact respective branch");
    		}
    	} else {
    		account.setAccountStatus(0);
        	account.setModifiedBy(modifierId);
        	account.setModifiedOn(Instant.now().toEpochMilli());
        	return Results.respondJson(accountDAO.updateAccount(account));
    	}
    }
    
    @Route(path = "delete", method = "DELETE")
    public String deleteAccount(@FromQuery("accountNo") long accountId) throws CustomException {
    	return Results.respondJson(accountDAO.deleteAccount(accountId));
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
