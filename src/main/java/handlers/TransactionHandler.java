package handlers;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.Instant;
import java.util.Map;
import DAO.AccountDAO;
import DAO.BeneficiaryDAO;
import DAO.TransactionDAO;
import DAO.UserDAO;
import annotations.FromBody;
import annotations.FromPath;
import annotations.FromQuery;
import annotations.FromSession;
import annotations.Route;
import pojos.Account;
import pojos.Beneficiary;
import pojos.Employee;
import pojos.Transaction;
import pojos.TransferWrapper;
import pojos.User;
import util.AuthorizeUtil;
import util.CustomException;
import util.DBConnection;
import util.Password;
import util.Results;
import util.ValidationsUtil;

public class TransactionHandler {

	private final TransactionDAO transactionDAO;

    public TransactionHandler(TransactionDAO transactionDAO) {
        this.transactionDAO = transactionDAO;
    }
    
    @Route(path = "transactions/account", method = "POST")
    public String fetchTransactionsofAccount(@FromBody Account account, @FromQuery("limit") int limit, @FromQuery("offset") int offset, 
    									@FromSession("userId") Long userId, @FromSession("role") Integer userRole) throws CustomException {
    	
    	Long accountId = account.getAccountId();
    	ValidationsUtil.isNull(userId, "UserId");
    	ValidationsUtil.isNull(userRole, "User Role");
    	ValidationsUtil.checkUserRole(userRole);
    	ValidationsUtil.checkLimitAndOffset(limit, offset);
    	
    	if (userRole.equals(0)) {
    		if(!AuthorizeUtil.isAuthorizedOwner(userId, accountId)) {
    			throw new CustomException("Unauthorized Access, check account number");
    		}
    	} 
    	if (userRole.equals(1) || userRole.equals(2)){
    		if(!AuthorizeUtil.isSameBranch(userId, accountId)) {
    			throw new CustomException("Unauthorized Access, contact specific branch");
    		}
    	}
    	return Results.respondJson(transactionDAO.getTransactionsByAccountId(accountId, limit, offset));
    }
    
    @Route(path = "transactions/customer", method = "POST")
    public String fetchTransactionsOfCustomer(@FromBody Account account, @FromQuery("limit") int limit, @FromQuery("offset") int offset, 
    									@FromSession("userId") Long userId, @FromSession("role") Integer userRole) throws CustomException {
    	
    	long customerId = account.getCustomerId();
    	ValidationsUtil.isNull(customerId, "Customer Id");
    	ValidationsUtil.isNull(userId, "UserId");
    	ValidationsUtil.isNull(userRole, "User Role");
    	ValidationsUtil.checkUserRole(userRole);
    	
    	if (userRole == 0) {
    		if(!(userId.equals(customerId))) {
    			throw new CustomException("Unauthoried Access, check customer Id");
    		}
    	}
    	return Results.respondJson(transactionDAO.getTransactionsByCustomerId(customerId, limit, offset));
    }
    
    @Route(path = "transactions/{transactionId}", method = "GET")
    public String fetchTransactionbyTransactionId(@FromPath("transactionId") Long transactionId, @FromSession("userId") Long userId, 
    										@FromSession("role") Integer userRole) throws CustomException {
    	
    	ValidationsUtil.isNull(transactionId, "Transaction Id");
    	ValidationsUtil.isNull(userId, "UserId");
    	ValidationsUtil.isNull(userRole, "User Role");
    	ValidationsUtil.checkUserRole(userRole);
    	
    	Transaction transaction = transactionDAO.getTransactionById(transactionId);
    	if (userRole == 0) {
    		if(transaction.getCustomerId() != userId) {
    			throw new CustomException("Unauthorized Access, check transaction Number");
    		}
    	}
    	if (userRole < 3 || userRole > 0) {
    		if(!AuthorizeUtil.isSameBranch(userId, transaction.getAccountId())) {
    			throw new CustomException("Unauthorized Access, contact specific branch");
    		}
    	}
    	return Results.respondJson(transaction);
    }
    
    @Route(path = "transactions/period", method = "POST")
    public String fetchTransactionsByDate(@FromBody Account account, @FromQuery("from") Long fromDate, @FromQuery("to") Long toDate, 
    								@FromQuery("limit") int limit, @FromQuery("offset") int offset, @FromSession("userId") Long userId, 
    							@FromSession("role") Integer userRole) throws CustomException {
    	
    	Long accountId = account.getAccountId();
    	ValidationsUtil.isNull(accountId, "Account Number");
    	ValidationsUtil.isNull(fromDate, "From date");
    	ValidationsUtil.isNull(toDate, "To date");
    	ValidationsUtil.checkLimitAndOffset(limit, offset);
    	ValidationsUtil.isNull(userId, "UserId");
    	ValidationsUtil.isNull(userRole, "User Role");
    	ValidationsUtil.checkUserRole(userRole);
    	
    	if (userRole == 0) {
    		if(!AuthorizeUtil.isAuthorizedOwner(userId, accountId)) {
    			throw new CustomException("Unauthorized Access, check account number");
    		}
    	} if(userRole < 3 || userRole > 0) {
    		if(!AuthorizeUtil.isSameBranch(userId, accountId)) {
    			throw new CustomException("Unauthorized Access, contact specific branch");
    		}
    	}
    	return Results.respondJson(transactionDAO.getTransactionsBasedOnTime(accountId, fromDate, toDate, limit, offset));
    }
    
    @Route(path = "transaction/transfer", method = "POST")
    public String newTransfer(@FromBody TransferWrapper transferWrapper, @FromSession("userId") long userId, 
    					@FromSession("role") Integer userRole) throws CustomException {
    	
    	ValidationsUtil.isNull(userId, "UserId");
    	ValidationsUtil.isNull(userRole, "User Role");
    	ValidationsUtil.checkUserRole(userRole);
    	
    	User inputUser = transferWrapper.getUser();
    	UserDAO userDAO = UserDAO.getUserDAOInstance();
    	User fetchedUser = userDAO.getUserPassword(userId);
    	if (!Password.verifyPassword(inputUser.getPasswordHash(), fetchedUser.getPasswordHash())) {
    		throw new CustomException("Password Wrong, Transaction Aborted");
    	}
    	
    	Connection connection = null;

        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);
            
            Transaction transaction = transferWrapper.getTransaction();
            Beneficiary beneficiary = transferWrapper.getBeneficiary();
            ValidationsUtil.ValidateTransactions(transaction);
            
            Account account = AuthorizeUtil.getAccountDetails(transaction.getAccountId());
            if (account.getAccountStatus().equals(0)) {
            	throw new CustomException("Account blocked");
            }
            
            if (userRole.equals(0)) {
                String bankName = beneficiary.getBankName();
                String ifscCode = beneficiary.getIfscCode();

                if (bankName != null && ifscCode != null &&
                    bankName.equalsIgnoreCase("jade bank") &&
                    ifscCode.toUpperCase().startsWith("JADE")) {

                    transaction.setTransactionType(3); // Inside bank
                } else {
                    transaction.setTransactionType(4); // Outside bank
                }
            }

            int type = transaction.getTransactionType(); // "1 - credit", "2 - debit", "3 - inside bank", "4 - outside bank"
            //double amount = transaction.getAmount();

            switch (type) {
                case 1:
                    handleCredit(transaction, userId, userRole, connection);
                    break;
                case 2:
                    handleDebit(transaction, userId, userRole, connection);
                    break;
                case 3:
                	
                    handleTransferInside(transaction, beneficiary, userId, userRole, connection);
                    break;
                case 4:
                	handleTransferOutside(transaction, beneficiary, userId, userRole, connection);
                	break;
                default:
                    throw new CustomException("Invalid transaction type: " + type);
            }

            connection.commit();
            return Results.respondJson(Map.of("status", "success"));
        } catch (Exception e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    throw new CustomException("transaction failed", ex);
                }
            }
            e.printStackTrace();
            throw new CustomException("Transaction Failed: " + e.getMessage());
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    private void handleCredit(Transaction transaction, Long userId, Integer userRole, Connection connection) throws Exception {
    	Account account = null;
    	BigDecimal amount = null;
    	try {
    		
	        long accountId = transaction.getAccountId();
	        amount = transaction.getAmount();
	        AccountDAO accountDAO = AccountDAO.getAccountDAOInstance();
	
	        account = accountDAO.getAccountForUpdate(accountId, connection);
	        if (account == null) {
	        	throw new CustomException("Account not found.");
	        }
	
	        BigDecimal newBalance = account.getBalance().add(amount);
	        updateBalance(account, newBalance, userId, accountDAO, connection);
	
	        transaction.setCreatedBy(userId);
	        transaction.setTransactionDate(Instant.now().toEpochMilli());
	        transaction.setClosingBalance(newBalance);
	        transaction.setTransactionStatus(1); // success
	        transactionDAO.createTransaction(transaction, connection);
	        
    	} catch (CustomException e) {
    		try {
                addFailedStatement(account, amount, userId, 2, e.getLocalizedMessage(), connection);
                connection.commit();  // commit the failed transaction insert
            } catch (Exception logEx) {
                logEx.printStackTrace();
            }
            throw new CustomException(e.getMessage());
    	}
    }
    
    private void handleDebit(Transaction transaction, long userId, int userRole, Connection connection) throws CustomException {
        BigDecimal amount = transaction.getAmount();
        Account account = null;

        try {
            long accountId = transaction.getAccountId();

            AccountDAO accountDAO = AccountDAO.getAccountDAOInstance();
            account = accountDAO.getAccountForUpdate(accountId, connection);
            if (account == null) {
                throw new CustomException("Account not found.");
            }

            isSufficientBalance(account.getBalance(), amount);

            BigDecimal newBalance = account.getBalance().subtract(amount);
            updateBalance(account, newBalance, userId, accountDAO, connection);

            transaction.setCreatedBy(userId);
            transaction.setClosingBalance(newBalance);
            transaction.setTransactionDate(Instant.now().toEpochMilli());
            transaction.setTransactionStatus(1); // success
            transactionDAO.createTransaction(transaction, connection);

        } catch(CustomException e) {
            try {
                addFailedStatement(account, amount, userId, 2, e.getLocalizedMessage(), connection);
                connection.commit();  // commit the failed transaction insert
            } catch (Exception logEx) {
                logEx.printStackTrace();
            }
            throw new CustomException(e.getMessage());
        }
    }
    
    private void handleTransferInside(Transaction transaction, Beneficiary beneficiary, Long userId, Integer role, Connection connection) throws CustomException {
    	
    	long toAccountId = 0;
    	Account fromAccount = null;
    	BigDecimal amount = null;
    	
    	try {
    	
	        long fromAccountId = transaction.getAccountId();
	        toAccountId = beneficiary.getBeneficiaryAccountNumber(); //to account number
	        
	        if (role.equals(0)) {
	        	if ((beneficiary.getBeneficiaryId()) == null) {
			        BeneficiaryDAO beneficiaryDAO = BeneficiaryDAO.getBeneficiaryDAOInstance();
			        String ifscCode = beneficiary.getIfscCode();
			        Beneficiary existingBeneficiary = beneficiaryDAO.getUniqueBeneficiary(ifscCode, fromAccountId, toAccountId, userId);
			        if (existingBeneficiary == null) {
			        	beneficiaryDAO.addAsBeneficiary(beneficiary, connection);
			        }
	        	} 
	        }
	        
	        ValidationsUtil.isNull(toAccountId, "Receiver Account Number");
	        
	        amount = transaction.getAmount();
	        AccountDAO accountDAO = AccountDAO.getAccountDAOInstance();
	
	        if (fromAccountId == toAccountId) {
	            throw new CustomException("Cannot transfer to the same account.");
	        }
	
	        fromAccount = accountDAO.getAccountForUpdate(fromAccountId, connection);
	        Account toAccount = accountDAO.getAccountForUpdate(toAccountId, connection);
	
	        isSufficientBalance(fromAccount.getBalance(), amount);
	        
	        BigDecimal fromAccBalance = fromAccount.getBalance().subtract(amount);
	        BigDecimal toAccBalance = toAccount.getBalance().add(amount);
	
	        // Update balances
	        updateBalance(fromAccount, fromAccBalance, userId, accountDAO, connection);
	        updateBalance(toAccount, toAccBalance, userId, accountDAO, connection);
	
	        long timestamp = Instant.now().toEpochMilli();
	
	        // Insert debit transaction for sender
	        Transaction debitTxn = new Transaction();
	        debitTxn.setAccountId(fromAccountId);
	        debitTxn.setCustomerId(fromAccount.getCustomerId());
	        debitTxn.setAmount(amount);
	        debitTxn.setClosingBalance(fromAccBalance);
	        debitTxn.setTransactionType(3); //debit
	        debitTxn.setTransactionDate(timestamp);
	        debitTxn.setDescription(transaction.getDescription());
	        debitTxn.setTransferReference(toAccountId);
	        debitTxn.setTransactionStatus(1); // 1 - Success
	        debitTxn.setCreatedBy(userId);
	        transactionDAO.createTransaction(debitTxn, connection);
	
	        // Insert credit transaction for receiver
	        Transaction creditTxn = new Transaction();
	        creditTxn.setAccountId(toAccountId);
	        creditTxn.setCustomerId(toAccount.getCustomerId());
	        creditTxn.setAmount(amount);
	        creditTxn.setClosingBalance(toAccBalance);
	        creditTxn.setTransactionType(1);
	        creditTxn.setTransactionDate(timestamp);
	        creditTxn.setDescription("Transfered from " + fromAccountId);
	        creditTxn.setTransferReference(fromAccountId);
	        creditTxn.setTransactionStatus(1); // success
	        creditTxn.setCreatedBy(userId);
	        transactionDAO.createTransaction(creditTxn, connection);
	    } catch(CustomException e) {
	    	try {
                addFailedStatement(fromAccount, amount, userId, 2, toAccountId, e.getLocalizedMessage(), connection);
                connection.commit();  // commit the failed transaction insert
            } catch (Exception logEx) {
                logEx.printStackTrace();
            }
            throw new CustomException(e.getMessage());
	    }
    }
    
    private void handleTransferOutside(Transaction transaction, Beneficiary beneficiary, long userId, int userRole, Connection connection) throws CustomException {
    	
    	Account account = null;
    	BigDecimal amount = null;
    	Long beneficiaryAccountNumber = null;
    	
    	try {
	    	long accountId = transaction.getAccountId();
	    	amount = transaction.getAmount();
	        BeneficiaryDAO beneficiaryDAO = BeneficiaryDAO.getBeneficiaryDAOInstance();
	        
	        AccountDAO accountDAO = AccountDAO.getAccountDAOInstance();
	        account = accountDAO.getAccountForUpdate(accountId, connection);
	        
	        isSufficientBalance(account.getBalance(), amount); 
	        BigDecimal newBalance = null;
    	
    		switch(userRole) {
	    		case 0:
	    			
	    			if (beneficiary.getBeneficiaryId() == null || beneficiary.getBeneficiaryId().equals(0L)) {
	    				beneficiary.setAccountId(accountId);
		    			beneficiary.setCreatedBy(userId);
		    			beneficiary.setModifiedOn(Instant.now().toEpochMilli());
		    			beneficiaryAccountNumber = beneficiary.getBeneficiaryAccountNumber();
		    			ValidationsUtil.isNull(beneficiaryAccountNumber, "Beneficiary Account Number");
		    			Long createdBeneficiaryId = beneficiaryDAO.addAsBeneficiary(beneficiary, connection);
		    			transaction.setTransferReference(createdBeneficiaryId);
	    			} else {
	    				Beneficiary beneficiary1 = beneficiaryDAO.getBeneficiaryById(beneficiary.getBeneficiaryId());
		    			if (beneficiary1 == null) {
		    				throw new CustomException("Beneficiary details not found");
		    			}
		    			transaction.setTransferReference(beneficiary.getBeneficiaryId());
	    			}
	    		
	    			beneficiaryAccountNumber = beneficiary.getBeneficiaryAccountNumber();
	    	        
	    	        if (!(AuthorizeUtil.isAuthorizedOwner(userId, accountId))) {
	    	        	throw new CustomException("Unauthorized Access, please check your account number");
	    	        }
	    	        
	    	        newBalance = account.getBalance().subtract(amount);
	    	        updateBalance(account, newBalance, userId, accountDAO, connection);
	    	        break;
	    	
	    		case 1:
	    		case 2:
	    			Employee employee = AuthorizeUtil.getEmployeeDetails(userId);
	    			
	    			if (!(employee.getBranch() == account.getBranchId())) {
	    				throw new CustomException("Unauthorized Access, contact specific branch");
	    			}
	    			
	    			beneficiary.setAccountId(accountId);
	    			beneficiary.setCreatedBy(userId);
	    			beneficiary.setModifiedOn(Instant.now().toEpochMilli());
	    			beneficiaryAccountNumber = beneficiary.getBeneficiaryAccountNumber();
	    			long beneficiaryId1 = beneficiaryDAO.addAsBeneficiary(beneficiary, connection);
	    			newBalance = account.getBalance().subtract(amount);
	    			transaction.setTransferReference(beneficiaryId1);
	    			break;
	    			
	    		case 3:
	    			beneficiary.setAccountId(accountId);
	    			beneficiary.setCreatedBy(userId);
	    			beneficiary.setModifiedOn(Instant.now().toEpochMilli());
	    			beneficiaryAccountNumber = beneficiary.getBeneficiaryAccountNumber();
	    			long beneficiaryId2 = beneficiaryDAO.addAsBeneficiary(beneficiary, connection);
	    			newBalance = account.getBalance().subtract(amount);
	    			transaction.setTransferReference(beneficiaryId2);
	    			break;
	    	}
    		
    		transaction.setTransactionType(2);
    		transaction.setTransactionStatus(1);
    		transaction.setCreatedBy(userId);
	        transaction.setClosingBalance(newBalance);
	        transaction.setTransactionDate(Instant.now().toEpochMilli());
	        transactionDAO.createTransaction(transaction, connection);
    		
	    } catch (CustomException e) {
	    	try {
                addFailedStatement(account, amount, userId, 2, beneficiaryAccountNumber, e.getLocalizedMessage(), connection);
                connection.commit();  // commit the failed transaction insert
            } catch (Exception logEx) {
                logEx.printStackTrace();
            }
            throw new CustomException(e.getMessage());
	    }
    }
    
    private void isSufficientBalance(BigDecimal balance, BigDecimal amount) throws CustomException {
        if (balance == null || amount == null || balance.compareTo(amount) < 0) {
            throw new CustomException("Insufficient balance");
        }
    }

    private void updateBalance(Account account, BigDecimal amount, Long userId, AccountDAO accountDAO, Connection connection) throws CustomException {
    	try {
	    	account.setBalance(amount);
	    	account.setModifiedBy(userId);
	    	account.setModifiedOn(Instant.now().toEpochMilli());
	    	accountDAO.updateAccount(account, connection);
    	} catch (CustomException e) {
    		throw new CustomException("Error in updating account balance", e);
    	}
    }
    
    private void addFailedStatement(Account account, BigDecimal amount, Long userId, Integer type, String description, Connection connection) throws CustomException {
    	try {
	    	Transaction transaction = new Transaction();
	    	transaction.setAccountId(account.getAccountId());
	    	transaction.setCustomerId(account.getCustomerId());
	    	transaction.setAmount(amount);
	    	transaction.setClosingBalance(account.getBalance());
	    	transaction.setTransactionType(type);
	    	transaction.setTransactionDate(Instant.now().toEpochMilli());
	    	transaction.setDescription(description);
	    	transaction.setTransactionStatus(2);
	    	transaction.setCreatedBy(userId);
	    	transactionDAO.createTransaction(transaction, connection);
    	} catch(CustomException e) {
    		throw new CustomException("Error while adding failed statement in Transaction", e);
    	}
    }
    
    private void addFailedStatement(Account account, BigDecimal amount, Long userId, Integer type, Long transferId, String description, Connection connection) throws CustomException {
    	try {
	    	Transaction transaction = new Transaction();
	    	transaction.setAccountId(account.getAccountId());
	    	transaction.setCustomerId(account.getCustomerId());
	    	transaction.setAmount(amount);
	    	transaction.setClosingBalance(account.getBalance());
	    	transaction.setTransactionType(type);
	    	transaction.setTransactionDate(Instant.now().toEpochMilli());
	    	transaction.setDescription(description);
	    	transaction.setTransferReference(transferId);
	    	transaction.setTransactionStatus(2);
	    	transaction.setCreatedBy(userId);
	    	transactionDAO.createTransaction(transaction, connection);
    	} catch(CustomException e) {
    		throw new CustomException("Error while adding failed statement in Transaction", e);
    	}
    }

}
