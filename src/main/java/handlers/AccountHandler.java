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
import util.ValidationsUtil;

public class AccountHandler {
	
	private final AccountDAO accountDAO;

    public AccountHandler(AccountDAO accountDAO) {
        this.accountDAO = accountDAO;
    }
    
    @Route(path = "account/new", method = "POST")
    public String createAccount(@FromBody Account account, @FromSession("userId") Long creatorId, 
    							@FromSession("role") Integer creatorRole) throws CustomException {
    	
    	ValidationsUtil.ValidateAccount(account);
    	ValidationsUtil.isNull(creatorId, "UserId");
    	ValidationsUtil.isNull(creatorRole, "User Role");
    	ValidationsUtil.checkUserRole(creatorRole);
    	
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
    public String getCustomerAccounts(@FromBody User user, @FromSession("userId") Long sessionId, 
    									@FromSession("role") Integer role) throws CustomException {
    	
    	ValidationsUtil.isNull(user.getUserId(), "CustomerId");;
    	ValidationsUtil.isNull(sessionId, "UserId");
    	ValidationsUtil.isNull(role, "User Role");
    	ValidationsUtil.checkUserRole(role);
    	
    	if(role == 0) {
    		return Results.respondJson(accountDAO.getAccountsByCustomerId(sessionId));
    	} else {
    		return Results.respondJson(accountDAO.getAccountsByCustomerId(user.getUserId()));
    	}
    }
    
    @Route(path = "accounts/list", method = "GET")
    public String getAccountsList(@FromSession("userId") Long userId, @FromSession("role") Integer role) throws CustomException {
    	
    	ValidationsUtil.isNull(userId, "UserId");
    	ValidationsUtil.isNull(role, "User Role");
    	ValidationsUtil.checkUserRole(role);
    	
    	if (role <= 2) {
    		Employee employee = AuthorizeUtil.getEmployeeDetails(userId);
    		return Results.respondJson(accountDAO.getAccountsList(employee.getBranch()));
    	} else {
    		return Results.respondJson(accountDAO.getAccountsList());
    	}
    }
    
    @Route(path = "account/details", method = "GET")
    public String getAccountDetails(@FromBody Account account, @FromSession("userId") Long sessionId, 
    							@FromSession("role") Integer role) throws CustomException {
    	
    	Long accountId = account.getAccountId();
    	
    	ValidationsUtil.isNull(accountId, "Account Number");
    	ValidationsUtil.isNull(sessionId, "UserId");
    	ValidationsUtil.isNull(role, "User Role");
    	ValidationsUtil.checkUserRole(role);
    	
    	Account fetchedAccount = accountDAO.getAccountById(accountId);
    	
    	if(role == 0) {
    		if (!(fetchedAccount.getCustomerId() == sessionId)) {
    			throw new CustomException("Unauthorized access");
    		} 
    	}
    	return Results.respondJson(fetchedAccount);
    }
    
    @Route(path = "account/update", method = "POST")
    public String updateAccount(@FromBody Account account, @FromSession("userId") Long modifierId, 
    							@FromSession("role") Integer role) throws CustomException {
    	
    	Long customerId = account.getAccountId();
    	
    	ValidationsUtil.isNull(customerId, "CustomerId");
    	ValidationsUtil.isNull(modifierId, "User Id");
    	ValidationsUtil.isNull(role, "User Role");
    	ValidationsUtil.checkUserRole(role);
    	
    	if (role == 0) {
    		if(customerId != modifierId) {
    			throw new CustomException("Unauthorized Access, Check account Number");
    		}
    	}
    	account.setModifiedBy(modifierId);
    	account.setModifiedOn(Instant.now().toEpochMilli());
    	return Results.respondJson(accountDAO.updateAccount(account));
    }
    
    @Route(path = "account/activate", method = "POST")
    public String activateAccount(@FromBody Account account, @FromSession("userId") Long modifierId, 
    						@FromSession("role") Integer role) throws CustomException {
    	
    	Long accountId = account.getAccountId();
    	
    	ValidationsUtil.isNull(modifierId, "UserId");
    	ValidationsUtil.isNull(modifierId, "UserId");
    	ValidationsUtil.isNull(role, "User Role");
    	ValidationsUtil.checkUserRole(role);
    	
    	Account fetchedAccount = accountDAO.getAccountById(accountId);
    	
    	if(role <= 2) {
    		Employee employee = AuthorizeUtil.getEmployeeDetails(modifierId);
    		if(!(employee.getBranch() == account.getBranchId())) {
    			throw new CustomException("Unauthorized Access, Cannot activate account of different branch");
    		} 
    	}
    		fetchedAccount.setAccountStatus(1);
    		fetchedAccount.setModifiedBy(modifierId);
    		fetchedAccount.setModifiedOn(Instant.now().toEpochMilli());
	    	return Results.respondJson(accountDAO.updateAccount(fetchedAccount));
    }
    
    @Route(path = "account/needapproval", method = "GET")
    public String getNewAccounts(@FromQuery("limit") int limit, @FromQuery("offset") int offset, 
    						@FromSession("userId") Long userId) throws CustomException {
    	
    	ValidationsUtil.checkLimitAndOffset(limit, offset);
    	ValidationsUtil.isNull(userId, "UserId");
    	
    	Employee employee = AuthorizeUtil.getEmployeeDetails(userId);
    	if (employee.getRole() <= 2) {
    		return Results.respondJson(accountDAO.getAccountByStatus(2, employee.getBranch(), limit, offset));
    	} else {
    		return Results.respondJson(accountDAO.getAccountsByStatus(2, limit, offset));
    	}
    }
    
    @Route(path = "account/close", method = "PUT")
    public String closeAccount(@FromBody Account account, @FromSession("userId") Long modifierId, 
    						@FromSession("role") Integer role) throws CustomException {
    	
    	Long accountId = account.getAccountId();
    	ValidationsUtil.isNull(accountId, "Account Number");
    	ValidationsUtil.isNull(modifierId, "User Id");
    	ValidationsUtil.isNull(role, "User Role");
    	ValidationsUtil.checkUserRole(role);
    	
    	Account fetchedAccount = accountDAO.getAccountById(accountId);
    	
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
    	
    	Long accountId = account.getAccountId();
    	ValidationsUtil.isNull(accountId, "Account Number");
    	
    	return Results.respondJson(accountDAO.deleteAccount(accountId));
    }
    
}
