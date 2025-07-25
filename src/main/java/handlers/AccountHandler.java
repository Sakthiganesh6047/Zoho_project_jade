package handlers;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.Instant;
import java.util.Map;
import DAO.AccountDAO;
import DAO.BranchDAO;
import DAO.UserDAO;
import annotations.FromBody;
import annotations.FromPath;
import annotations.FromQuery;
import annotations.FromSession;
import annotations.Route;
import pojos.Account;
import pojos.AccountProfile;
import pojos.Branch;
import pojos.Employee;
import pojos.User;
import util.AuthorizeUtil;
import util.CustomException;
import util.DBConnection;
import util.Results;
import util.UnauthorizedAccessException;
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
    	
    	accountDAO.setAllPrimaryFlagsFalse(account.getCustomerId());
    	account.setIsPrimary(true);
    	account.setCreatedBy(creatorId);
    	account.setCreatedAt(Instant.now().toEpochMilli());
    	if (creatorRole == 0) {
    		account.setAccountStatus(2);
    	} else {
    		account.setAccountStatus(1);
    	}
    	long accountId = accountDAO.createAccount(account);
    	return Results.respondJson(Map.of("Account Id", accountId));
    }
    
    @Route(path = "account/id", method = "POST")
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
    
    @Route(path = "account/accountId", method = "POST")
    public String getAccountById(@FromBody Account account, @FromSession("userId") Long sessionId, 
    								@FromSession("role") Integer role) throws CustomException {
    	
    	Long accountId = account.getAccountId();
    	
    	ValidationsUtil.isNull(accountId, "accountId");;
    	ValidationsUtil.isNull(sessionId, "UserId");
    	ValidationsUtil.isNull(role, "User Role");
    	ValidationsUtil.checkUserRole(role);
    	
    	if(role == 0) {
    		if(!(AuthorizeUtil.isAuthorizedOwner(sessionId, accountId))) {
    			throw new UnauthorizedAccessException("Unauthorized access, Check account number");
    		}
    		return Results.respondJson(accountDAO.getAccountById(accountId));
    	} else {
    		return Results.respondJson(accountDAO.getAccountById(accountId));
    	}
    }
    
    @Route(path = "account/updateStatus", method = "PUT")
    public String updateAccountStatus(@FromBody Account account, @FromSession("userId") Long modifierId, 
    							@FromSession("role") Integer role) throws CustomException {
    	
    	Long accountId = account.getAccountId();
    	
    	ValidationsUtil.isNull(accountId, "AccountId");
    	ValidationsUtil.isNull(modifierId, "User Id");
    	ValidationsUtil.isNull(role, "User Role");
    	ValidationsUtil.checkUserRole(role);
    	
//    	if (role.equals(0)) {
//    		if(!(customerId.equals(modifierId))) {
//    			throw new UnauthorizedAccessException("Unauthorized Access, Check account Number");
//    		}
//    	}
    	
    	if (role.equals(1) || role.equals(2)) {
    		if(!(AuthorizeUtil.isSameBranch(modifierId, accountId))) {
    			throw new UnauthorizedAccessException("Unauthorized access, Contact respective branch");
    		}
    	}
    	
    	account.setModifiedBy(modifierId);
    	account.setModifiedOn(Instant.now().toEpochMilli());
    	return Results.respondJson(accountDAO.updateAccount(account, "accountType", "accountStatus", "modifiedBy", "modifiedOn"));
    }
    
    @Route(path = "account/primary", method = "GET")
    public String getPrimaryAccount(@FromSession("userId") Long sessionId) throws CustomException {
    	ValidationsUtil.isNull(sessionId, "UserId");
    	
    	return Results.respondJson(accountDAO.getPrimary(sessionId));
    }
    
    @Route(path = "account/setprimary", method = "POST")
    public String setPrimaryAccount(@FromBody Account account, @FromSession("userId") Long userId) throws CustomException {
        ValidationsUtil.isNull(userId, "User Id");
        
        Long accountId = account.getAccountId();
        ValidationsUtil.isNull(accountId, "Account Number");
        AuthorizeUtil.checkAccountStatus(accountId);

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);     // Begin transaction

            accountDAO.setAllPrimaryFlagsFalse(userId, conn);
            accountDAO.setPrimary(accountId, conn);

            conn.commit(); // Commit if both succeed
            return Results.respondJson(Map.of("status", "success"));
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on any failure
                } catch (SQLException ex) {
                    throw new CustomException("Rollback failed", ex);
                }
            }
            throw new CustomException("Failed to update primary account", e);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    throw new CustomException("Failed to close connection", e);
                }
            }
        }
    }
    
    @Route(path = "accounts/list/{branchId}", method = "GET")
    public String getAccountsList(
            @FromPath("branchId") Long branchId,
            @FromQuery("limit") int limit,
            @FromQuery("offset") int offset,
            @FromQuery("status") String status,           // e.g., "new", "active", "blocked"
            @FromQuery("type") String type,               // e.g., "savings", "current"
            @FromSession("userId") Long userId,
            @FromSession("role") Integer role
    ) throws CustomException {

        ValidationsUtil.isNull(userId, "UserId");
        ValidationsUtil.isNull(role, "User Role");
        ValidationsUtil.checkLimitAndOffset(limit, offset);
        ValidationsUtil.checkUserRole(role);

        if (role <= 2) {
            Employee employee = AuthorizeUtil.getEmployeeDetails(userId);
            branchId = employee.getBranch(); // override with own branch
        }
        return Results.respondJson(accountDAO.getAccountsFiltered(branchId, status, type, limit, offset));
    }

    
    @Route(path = "account/beneficiarydetail", method = "POST")
    public String getAccountDetailsForBeneficiary(@FromBody Account account, @FromSession("userId") Long userId, 
    											@FromSession("role") Integer role) throws CustomException  {
    	
    	Long accountId = account.getAccountId();
    	
    	ValidationsUtil.isNull(accountId, "Account Number");
    	ValidationsUtil.isNull(userId, "UserId");
    	ValidationsUtil.isNull(role, "User Role");
    	ValidationsUtil.checkUserRole(role);
    	AuthorizeUtil.checkAccountStatus(accountId);
    	
    	Account fetchedAccount = accountDAO.getAccountById(accountId);
    	AccountProfile accountProfile = new AccountProfile();
    	BranchDAO branchDAO = BranchDAO.getBranchDAOInstance();
    	Branch branch = branchDAO.getBranchById(fetchedAccount.getBranchId());
    	UserDAO userDAO = UserDAO.getUserDAOInstance();
    	User user = userDAO.getUserById(fetchedAccount.getCustomerId());
    	accountProfile.setAccountId(accountId);
    	accountProfile.setFullName(user.getFullName());
    	accountProfile.setIfscCode(branch.getIfscCode());
    	return Results.respondJson(accountProfile);
    }
    
    @Route(path = "account/details", method = "POST")
    public String getAccountDetails(@FromBody Account account, @FromSession("userId") Long sessionId, 
    							@FromSession("role") Integer role) throws CustomException {
    	
    	Long accountId = account.getAccountId();
    	
    	ValidationsUtil.isNull(accountId, "Account Number");
    	ValidationsUtil.isNull(sessionId, "UserId");
    	ValidationsUtil.isNull(role, "User Role");
    	ValidationsUtil.checkUserRole(role);
    	
//    	if(role == 2) {
//    		AuthorizeUtil.isSameBranch(sessionId, accountId);
//    	}
    	
    	Account fetchedAccount = accountDAO.getAccountById(accountId);
    	Long customerId = fetchedAccount.getCustomerId();
    	
    	if(role == 0) {
    		if (!(customerId.equals(sessionId))) {
    			throw new UnauthorizedAccessException("Unauthorized access, check Account Number");
    		} 
    	}
    	
    	UserDAO userDAO = UserDAO.getUserDAOInstance();
    	User user = userDAO.getUserById(customerId);
    	
    	AccountProfile accountProfile = new AccountProfile();
    	accountProfile.setFullName(user.getFullName());
    	accountProfile.setCustomerId(customerId);
    	accountProfile.setBalance(fetchedAccount.getBalance());
    	return Results.respondJson(accountProfile);
    }
    
    @Route(path = "account/update", method = "POST")
    public String updateAccount(@FromBody Account account, @FromSession("userId") Long modifierId, 
    							@FromSession("role") Integer role) throws CustomException {
    	
    	Long customerId = account.getAccountId();
    	
    	ValidationsUtil.isNull(customerId, "CustomerId");
    	ValidationsUtil.isNull(modifierId, "User Id");
    	ValidationsUtil.isNull(role, "User Role");
    	ValidationsUtil.checkUserRole(role);
    	
    	if (role.equals(0)) {
    		if(!(customerId.equals(modifierId))) {
    			throw new UnauthorizedAccessException("Unauthorized Access, Check account Number");
    		}
    	}
    	account.setModifiedBy(modifierId);
    	account.setModifiedOn(Instant.now().toEpochMilli());
    	return Results.respondJson(accountDAO.updateAccount(account, "balance", "modifiedBy", "modifiedOn"));
    }
    
    @Route(path = "account/block", method = "POST")
    public String blockAccount(@FromBody Account account, @FromSession("userId") Long modifierId, 
    							@FromSession("role") Integer role) throws CustomException {
    	
    	Long accountId = account.getAccountId();
    	
    	ValidationsUtil.isNull(accountId, "AccountId");
    	ValidationsUtil.isNull(modifierId, "User Id");
    	ValidationsUtil.isNull(role, "User Role");
    	ValidationsUtil.checkUserRole(role);
    	
    	Account fetchedAccount = accountDAO.getAccountById(accountId);
    	
    	if (role.equals(0)) {
    		if(!(fetchedAccount.getCustomerId().equals(modifierId))) {
    			throw new UnauthorizedAccessException("Unauthorized Access, Check account Number");
    		}
    	}
    	
    	fetchedAccount.setAccountStatus(2);
    	fetchedAccount.setModifiedBy(modifierId);
    	fetchedAccount.setModifiedOn(Instant.now().toEpochMilli());
    	return Results.respondJson(accountDAO.updateAccount(fetchedAccount, "accountStatus", "modifiedBy", "modifiedOn"));
    }
    
    @Route(path = "account/unblock", method = "POST")
    public String unblockAccount(@FromBody Account account, @FromSession("userId") Long modifierId, 
    							@FromSession("role") Integer role) throws CustomException {
    	
    	Long accountId = account.getAccountId();
    	
    	ValidationsUtil.isNull(accountId, "AccountId");
    	ValidationsUtil.isNull(modifierId, "User Id");
    	ValidationsUtil.isNull(role, "User Role");
    	ValidationsUtil.checkUserRole(role);
    	
    	Account fetchedAccount = accountDAO.getAccountById(accountId);
    	
    	if (role.equals(0)) {
    		if(!(fetchedAccount.getCustomerId().equals(modifierId))) {
    			throw new UnauthorizedAccessException("Unauthorized Access, Check account Number");
    		}
    	}
    	
    	fetchedAccount.setAccountStatus(1);
    	fetchedAccount.setModifiedBy(modifierId);
    	fetchedAccount.setModifiedOn(Instant.now().toEpochMilli());
    	return Results.respondJson(accountDAO.updateAccount(fetchedAccount, "accountStatus", "modifiedBy", "modifiedOn"));
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
    			throw new UnauthorizedAccessException("Unauthorized Access, Cannot activate account of different branch");
    		} 
    	}
    		fetchedAccount.setAccountStatus(1);
    		fetchedAccount.setModifiedBy(modifierId);
    		fetchedAccount.setModifiedOn(Instant.now().toEpochMilli());
	    	return Results.respondJson(accountDAO.updateAccount(fetchedAccount, "balance", "modifiedBy", "modifiedOn"));
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
    
//    @Route(path = "account/transactionchart", method = "GET")
//    public String getTransactionCount(@FromSession("userId") Long userId, @FromSession("role") Integer role) throws CustomException {
// 
//    	ValidationsUtil.isNull(role, "User Role");
//    	ValidationsUtil.isNull(role, "User Role");
//    	
//    	if(role ==  2) {
//    		Employee employee = AuthorizeUtil.getEmployeeDetails(userId);
//    		return Results.respondJson(accountDAO.getCurrentWeekTransactionSplitByBranch(employee.getBranch()));
//    	}
//    	return Results.respondJson(accountDAO.getCurrentWeekTransactionSplitByDayName());
//    }
    
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
    	    	return Results.respondJson(accountDAO.updateAccount(account, "balance", "modifiedBy", "modifiedOn"));
    		} else {
    			throw new CustomException("Unauthorized access, Contact respective branch");
    		}
    	} else {
    		fetchedAccount.setAccountStatus(0);
    		fetchedAccount.setModifiedBy(modifierId);
        	fetchedAccount.setModifiedOn(Instant.now().toEpochMilli());
        	return Results.respondJson(accountDAO.updateAccount(fetchedAccount, "balance", "modifiedBy", "modifiedOn"));
    	}
    }
    
    @Route(path = "account/delete", method = "DELETE")
    public String deleteAccount(@FromBody Account account) throws CustomException {
    	
    	Long accountId = account.getAccountId();
    	ValidationsUtil.isNull(accountId, "Account Number");
    	
    	return Results.respondJson(accountDAO.deleteAccount(accountId));
    }
    
}
