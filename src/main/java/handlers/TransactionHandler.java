package handlers;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.Instant;
import java.util.Map;
import DAO.AccountDAO;
import DAO.BeneficiaryDAO;
import DAO.TransactionDAO;
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
import util.AuthorizeUtil;
import util.CustomException;
import util.DBConnection;
import util.Results;

public class TransactionHandler {

	private final TransactionDAO transactionDAO;

    public TransactionHandler(TransactionDAO transactionDAO) {
        this.transactionDAO = transactionDAO;
    }
    
    @Route(path = "transactions/Account", method = "POST")
    public String fetchTransactionsofAccount(@FromBody Account account, @FromQuery("limit") int limit, @FromQuery("offset") int offset, 
    									@FromSession("userid") long userId, @FromSession("role")int userRole) throws CustomException {
    	long accountId = account.getAccountId();
    	if (userRole == 0) {
    		if(!AuthorizeUtil.isAuthorizedOwner(userId, accountId)) {
    			throw new CustomException("Unauthorized Access, check account number");
    		}
    	} 
    	if (userRole < 3 || userRole > 0) {
    		if(!AuthorizeUtil.isSameBranch(userId, accountId)) {
    			throw new CustomException("Unauthorized Access, contact specific branch");
    		}
    	}
    	return Results.respondJson(transactionDAO.getTransactionsByAccountId(accountId, limit, offset));
    }
    
    @Route(path = "transactions/customer", method = "POST")
    public String fetchTransactionsOfCustomer(@FromBody Account account, @FromQuery("limit") int limit, @FromQuery("offset") int offset, 
    									@FromSession("userId") long userId, @FromSession("role") int userRole) throws CustomException {
    	long customerId = account.getCustomerId();
    	if (userRole == 0) {
    		if(userId != customerId) {
    			throw new CustomException("Unauthoried Access, check customer Id");
    		}
    	}
    	return Results.respondJson(transactionDAO.getTransactionsByCustomerId(customerId, limit, offset));
    }
    
    @Route(path = "transactions/{transactionId}", method = "GET")
    public String fetchTransactionbyTransactionId(@FromPath("transactionId") long transactionId, @FromSession("userId") long userId, 
    										@FromSession("role") int userRole) throws CustomException {
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
    public String fetchTransactionsByDate(@FromBody Account account, @FromQuery("from") long fromDate, @FromQuery("to") long toDate, 
    								@FromQuery("limit") int limit, @FromQuery("offset") int offset, @FromSession("userId") long userId, 
    							@FromSession("role") int userRole) throws CustomException {
    	long accountId = account.getAccountId();
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
    					@FromSession("role") int userRole) throws CustomException {
    	Connection connection = null;

        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);
            
            Transaction transaction = transferWrapper.getTransaction();
            Beneficiary beneficiary = transferWrapper.getBeneficiary();

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
            return Results.respondJson(Map.of("status", "failed", "message", e.getMessage()));
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
    
    private void handleCredit(Transaction transaction, long userId, int userRole, Connection connection) throws CustomException {
    	Account account = null;
    	double amount = 0;
    	try {
    		
	        long accountId = transaction.getAccountId();
	        amount = transaction.getAmount();
	        AccountDAO accountDAO = AccountDAO.getAccountDAOInstance();
	
	        account = accountDAO.getAccountForUpdate(accountId, connection);
	        if (account == null) {
	        	throw new CustomException("Account not found.");
	        }
	
	        double newBalance = account.getBalance() + amount;
	        updateBalance(account, newBalance, userId, accountDAO, connection);
	
	        transaction.setCreatedBy(userId);
	        transaction.setTransactionDate(Instant.now().toEpochMilli());
	        transaction.setClosingBalance(newBalance);
	        transaction.setTransactionStatus(1);
	        transaction.setTransferReference(0L);
	        transactionDAO.createTransaction(transaction, connection);
	        
    	} catch (CustomException e) {
    		addFailedStatement(account, amount, userId, 1, e.getLocalizedMessage(), connection);
    		throw new CustomException("Credit operation failed!", e);
    	}
    }
    
    private void handleDebit(Transaction transaction, long userId, int userRole, Connection connection) throws CustomException {
	    double amount = 0;
	    Account account = null;
    	
    	try {
    		long accountId = transaction.getAccountId();
	        amount = transaction.getAmount();
	
	        AccountDAO accountDAO = AccountDAO.getAccountDAOInstance();
	        account = accountDAO.getAccountForUpdate(accountId, connection);
	        if (account == null) {
	        	throw new CustomException("Account not found.");
	        }
	
	        if (account.getBalance() < amount) {
	        	//addFailedStatement(account, amount, userId, 2, "insufficient balance", connection);
	            throw new CustomException("Insufficient balance.");
	        }
	
	        double newBalance = account.getBalance() - amount;
	        updateBalance(account, newBalance, userId, accountDAO, connection);
	
	        transaction.setCreatedBy(userId);
	        transaction.setClosingBalance(newBalance);
	        transaction.setTransactionDate(Instant.now().toEpochMilli());
	        transactionDAO.createTransaction(transaction, connection);
    	} catch(CustomException e) {
    		addFailedStatement(account, amount, userId, 2, e.getLocalizedMessage(), connection);
    		throw new CustomException("Debit operation Failed", e);
    	}
    }
    
    private void handleTransferInside(Transaction transaction, Beneficiary beneficiary, long userId, int role, Connection connection) throws CustomException {
    	
    	long toAccountId = 0;
    	Account fromAccount = null;
    	double amount = 0;
    	
    	try {
    	
	        long fromAccountId = transaction.getAccountId();
	        toAccountId = beneficiary.getBeneficiaryAccountNumber(); //to account number
	        amount = transaction.getAmount();
	        AccountDAO accountDAO = AccountDAO.getAccountDAOInstance();
	
	        if (fromAccountId == toAccountId) {
	            throw new CustomException("Cannot transfer to the same account.");
	        }
	
	        fromAccount = accountDAO.getAccountForUpdate(fromAccountId, connection);
	        Account toAccount = accountDAO.getAccountForUpdate(toAccountId, connection);
	
	        isSufficientBalance(fromAccount.getBalance(), amount);
	        
	        double fromAccBalance = fromAccount.getBalance() - amount;
	        double toAccBalance = toAccount.getBalance() + amount;
	
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
	        debitTxn.setTransactionType(2); //debit
	        debitTxn.setTransactionDate(timestamp);
	        debitTxn.setDescription("Transfer to account " + toAccountId);
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
	        creditTxn.setDescription("Transfer from account " + fromAccountId);
	        creditTxn.setTransferReference(fromAccountId);
	        creditTxn.setTransactionStatus(1); // success
	        creditTxn.setCreatedBy(userId);
	        transactionDAO.createTransaction(creditTxn, connection);
	    } catch(CustomException e) {
	    	addFailedStatement(fromAccount, amount, userId, 3, toAccountId, e.getLocalizedMessage(), connection);
	    	throw new CustomException("Transfer operation failed", e);
	    }
    }
    
    private void handleTransferOutside(Transaction transaction, Beneficiary beneficiary, long userId, int userRole, Connection connection) {
    	
    	try {
	    	long accountId = transaction.getAccountId();
	        Double amount = transaction.getAmount();
	        BeneficiaryDAO beneficiaryDAO = BeneficiaryDAO.getBeneficiaryDAOInstance();
	        
	        AccountDAO accountDAO = AccountDAO.getAccountDAOInstance();
	        Account account = accountDAO.getAccountForUpdate(accountId, connection);
	        
	        isSufficientBalance(account.getBalance(), amount); 
	        double newBalance = 0;
    	
    		switch(userRole) {
	    		case 0:
	    			Beneficiary beneficiary1 = beneficiaryDAO.getBeneficiaryById(beneficiary.getBeneficiaryId());
	    			if (beneficiary1 == null) {
	    				throw new CustomException("Beneficiary details not found");
	    			}
	    	        
	    	        if (AuthorizeUtil.isAuthorizedOwner(userId, accountId)) {
	    	        	throw new CustomException("Unauthorized Access, please check your account number");
	    	        }
	    	        
	    	        newBalance = account.getBalance() - amount;
	    	        updateBalance(account, newBalance, userId, accountDAO, connection);
	    	        break;
	    	
	    		case 1:
	    		case 2:
	    			Employee employee = AuthorizeUtil.getEmployeeDetails(userId);
	    			
	    			if (!(employee.getBranch() == account.getBranchId())) {
	    				throw new CustomException("Unauthorized Access, contact specific branch");
	    			}
	    			
	    			beneficiary.setCreatedBy(userId);
	    			beneficiary.setModifiedOn(Instant.now().toEpochMilli());
	    			long beneficiaryId = beneficiaryDAO.addAsBeneficiary(beneficiary, connection);
	    			newBalance = account.getBalance() - amount;
	    			transaction.setTransferReference(beneficiaryId);
	    			break;
	    			
	    		case 3:
	    			beneficiary.setCreatedBy(userId);
	    			beneficiary.setModifiedOn(Instant.now().toEpochMilli());
	    			long beneficiaryId1 = beneficiaryDAO.addAsBeneficiary(beneficiary, connection);
	    			newBalance = account.getBalance() - amount;
	    			transaction.setTransferReference(beneficiaryId1);
	    			break;
	    	}
    		
    		transaction.setCreatedBy(userId);
	        transaction.setClosingBalance(newBalance);
	        transaction.setTransactionDate(Instant.now().toEpochMilli());
	        transactionDAO.createTransaction(transaction, connection);
    		
	    } catch (CustomException e) {
	    	
	    }
    		
    }
    
    private void isSufficientBalance(double balance, double amount) throws CustomException {
    	if (balance < amount) {
        	//addFailedStatement(account, amount, userId, 2, "insufficient balance", connection);
            throw new CustomException("Insufficient balance.");
        }
    }

    private void updateBalance(Account account, double amount, long userId, AccountDAO accountDAO, Connection connection) throws CustomException {
    	try {
	    	account.setBalance(amount);
	    	account.setModifiedBy(userId);
	    	account.setModifiedOn(Instant.now().toEpochMilli());
	    	accountDAO.updateAccount(account);
    	} catch (CustomException e) {
    		throw new CustomException("Error in updating account balance", e);
    	}
    }
    
    private void addFailedStatement(Account account, double amount, long userId, int type, String description, Connection connection) throws CustomException {
    	try {
	    	Transaction transaction = new Transaction();
	    	transaction.setAccountId(account.getAccountId());
	    	transaction.setCustomerId(account.getCustomerId());
	    	transaction.setAmount(amount);
	    	transaction.setClosingBalance(account.getBalance());
	    	transaction.setTransactionType(type);
	    	transaction.setTransactionDate(Instant.now().toEpochMilli());
	    	transaction.setDescription(description);
	    	transaction.setTransactionStatus(0);
	    	transactionDAO.createTransaction(transaction, connection);
    	} catch(CustomException e) {
    		throw new CustomException("Error while adding failed statement in Transaction", e);
    	}
    }
    
    private void addFailedStatement(Account account, double amount, long userId, int type, long transferId, String description, Connection connection) throws CustomException {
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
	    	transaction.setTransactionStatus(0);
	    	transactionDAO.createTransaction(transaction, connection);
    	} catch(CustomException e) {
    		throw new CustomException("Error while adding failed statement in Transaction", e);
    	}
    }
    
    
    
//    public String newTransaction(Transaction transaction, long userId, int role) throws CustomException {
//        Connection connection = null;
//
//        try {
//            connection = DBConnection.getConnection();
//            connection.setAutoCommit(false);
//
//            int type = transaction.getTransactionType(); // "1 - credit", "2 - debit", or "3 - transfer"
//            //double amount = transaction.getAmount();
//
//            switch (type) {
//                case 1:
//                    handleCredit(transaction, userId, role, connection);
//                    break;
//                case 2:
//                    handleDebit(transaction, userId, role, connection);
//                    break;
//                default:
//                    throw new CustomException("Invalid transaction type: " + type);
//            }
//
//            connection.commit();
//            return Results.respondJson(Map.of("status", "success"));
//        } catch (Exception e) {
//            if (connection != null) {
//                try {
//                    connection.rollback();
//                } catch (SQLException ex) {
//                    throw new CustomException("transaction failed", ex);
//                }
//            }
//            e.printStackTrace();
//            return Results.respondJson(Map.of("status", "failed", "message", e.getMessage()));
//        } finally {
//            if (connection != null) {
//                try {
//                    connection.close();
//                } catch (SQLException e) {
//                    e.printStackTrace();
//                }
//            }
//        }
//    }

}
