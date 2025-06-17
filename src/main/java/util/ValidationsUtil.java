package util;

import java.math.BigDecimal;

import pojos.Account;
import pojos.Beneficiary;
import pojos.Branch;
import pojos.Customer;
import pojos.Employee;
import pojos.Transaction;
import pojos.User;

public class ValidationsUtil {
	
	public static <T> void isNull(T Object, String fieldName) throws CustomException {
		if (Object == null) {
			throw new CustomException(fieldName + " can't be null");
		}
	}
	
	public static <T> void isEmpty(String inputString, String fieldName) throws CustomException {
		if (inputString.isEmpty()) {
			throw new CustomException(fieldName + " can't be empty");
		}
	}

	public static void checkLimitAndOffset(int limit, int offset) throws CustomException {
		if (limit <= 0 || offset < 0)
			throw new CustomException("Invalid pagination values");
	}
	
	public static void checkUserRole(Integer role) throws CustomException {
		if (role < 0 || role > 4) {
		    throw new CustomException("Invalid user role.");
		}
	}
	
	public static void validateUser(User user) throws CustomException {
		
	    String fullName = user.getFullName();
	    String email = user.getEmail();
	    String phone = user.getPhone();
	    String dob = user.getDob();
	    Integer age = user.getAge();
	    String gender = user.getGender();
	    Integer userType = user.getUserType();
		
	    if (fullName == null || !fullName.matches("^[A-Za-z ]{2,50}$")) {
	        throw new CustomException("Full name must contain only letters and spaces (2–50 characters).");
	    }

	    if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.[A-Za-z]{2,6}$")) {
	        throw new CustomException("Invalid email format.");
	    }

//	    if (passwordHash == null || passwordHash.length() < 8) {
//	        throw new CustomException("Password must be at least 8 characters long.");
//	    }

	    if (phone == null || !phone.matches("^[6-9]\\d{9}$")) {
	        throw new CustomException("Phone number must be a valid 10-digit Indian number starting with 6–9.");
	    }

	    if (dob == null || !dob.matches("^\\d{4}-\\d{2}-\\d{2}$")) {
	        throw new CustomException("Date of birth must be in YYYY-MM-DD format.");
	    }

	    if (age == null || age < 0 || age > 120) {
	        throw new CustomException("Age must be between 0 and 120.");
	    }

	    if (gender == null || !(gender.equalsIgnoreCase("male") || gender.equalsIgnoreCase("female") || gender.equalsIgnoreCase("other"))) {
	        throw new CustomException("Gender must be 'male', 'female', or 'other'.");
	    }

	    if (userType == null || userType < 0 || userType > 3) {
	        throw new CustomException("Invalid user type.");
	    }
	}
	
	public static void validateCustomer(Customer customer) throws CustomException {
		
		String aadharNumber = customer.getAadharNumber();
		String panId = customer.getPanId();
		String address = customer.getAddress();
		
		if (aadharNumber == null || !aadharNumber.matches("^\\d{12}$")) {
		    throw new CustomException("Aadhar number must be exactly 12 digits.");
		}

		if (panId == null || !panId.matches("^[A-Z]{5}[0-9]{4}[A-Z]{1}$")) {
		    throw new CustomException("PAN ID must follow the format: 5 uppercase letters, 4 digits, 1 uppercase letter (e.g., ABCDE1234F).");
		}

		if (address == null || address.isBlank() || address.length() < 5 || address.length() > 250) {
		    throw new CustomException("Address must be between 5 and 250 characters.");
		}
		
	}
	
	public static void validateEmployee(Employee employee) throws CustomException {
		
		Integer role = employee.getRole();
		Long branch = employee.getBranch();
		
		if (role == null || role <= 1 || role >= 3) {
			throw new CustomException ("Invalid employee Role");
		}
		
		ValidationsUtil.isNull(branch, "Branch");
	}
	
	public static void validateBranch(Branch branch) throws CustomException {
		
		String branchName = branch.getBranchName();
		String branchDistrict = branch.getBranchDistrict();
		String address = branch.getBranchDistrict();
		
		if (branchName == null || !branchName.matches("^[A-Za-z0-9 .'-]{3,100}$")) {
		    throw new CustomException("Branch name must be 3 to 100 characters long");
		}

		if (branchDistrict == null || !branchDistrict.matches("^[A-Za-z ]{2,50}$")) {
		    throw new CustomException("Branch district must contain only 2–50 characters");
		}

		if (address == null || address.isBlank() || address.length() < 5 || address.length() > 250) {
		    throw new CustomException("Address must be between 5 and 250 characters");
		}

	}
	
	public static void ValidateBeneficiary(Beneficiary beneficiary) throws CustomException {
		
		String beneficiaryName = beneficiary.getBeneficiaryName();
		String bankName = beneficiary.getBankName();
		Long beneficiaryAccountNumber = beneficiary.getBeneficiaryAccountNumber();
		String ifscCode = beneficiary.getIfscCode();
		Long accountId = beneficiary.getAccountId();
		
		if (beneficiaryName == null || !beneficiaryName.matches("^[A-Za-z .'-]{2,100}$")) {
		    throw new CustomException("Beneficiary name must only 2 to 100 characters long");
		}

		if (bankName == null || !bankName.matches("^[A-Za-z0-9 .'-]{2,100}$")) {
		    throw new CustomException("Bank name must be 2 to 100 characters long");
		}

		if (beneficiaryAccountNumber == null || beneficiaryAccountNumber <= 0) {
		    throw new CustomException("Beneficiary account number must be a positive number.");
		}

		if (ifscCode == null || !ifscCode.matches("^[A-Z]{4}[A-Z0-9]{7}$")) {
		    throw new CustomException("Invalid IFSC code");
		}

		if (accountId == null || accountId <= 0) {
		    throw new CustomException("Invalid Associated account ID");
		}

	}
	
	public static void ValidateAccount(Account account) throws CustomException {
		
		Long customerId = account.getCustomerId();
	    Long branchId = account.getBranchId();
	    Integer accountType = account.getAccountType();
	    BigDecimal balance = account.getBalance();
	    
	    if (customerId == null || customerId <= 0) {
		    throw new CustomException("Invalid customer Id");
		}
	    
	    if (branchId == null || branchId <= 0) {
		    throw new CustomException("Invalid branch Id");
		}
	    
	    if (accountType == null || accountType <= 0) {
		    throw new CustomException("Invalid account type");
		}
	    
	    if (balance == null || balance.compareTo(BigDecimal.ZERO) < 0) {
	        throw new CustomException("Invalid Balance");
	    }
	    
	}
	
	public static void ValidateTransactions(Transaction transaction) throws CustomException {
		
		Long accountId = transaction.getAccountId();
		Long customerId = transaction.getCustomerId();
		BigDecimal amount = transaction.getAmount();
		Integer transactionType = transaction.getTransactionType();
		
		if (accountId == null || accountId <= 0) {
		    throw new CustomException("Valid account ID is required.");
		}

		if (customerId == null || customerId <= 0) {
		    throw new CustomException("Valid customer ID is required.");
		}

		if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
		    throw new CustomException("Transaction amount must be greater than zero.");
		}

		if (transactionType == null || !(transactionType >= 0 || transactionType <= 4)) {
		    throw new CustomException("Invalid transaction Type");
		}

	}
	

}
