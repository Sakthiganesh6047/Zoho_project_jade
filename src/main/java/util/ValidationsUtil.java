package util;

import java.math.BigDecimal;

import pojos.Account;
import pojos.Beneficiary;
import pojos.Branch;
import pojos.Credential;
import pojos.Customer;
import pojos.Employee;
import pojos.Transaction;
import pojos.User;

public class ValidationsUtil {
	
	public static <T> void isNull(T Object, String fieldName) throws CustomException {
		if (Object == null) {
			throw new BadRequestException(fieldName + " can't be null");
		}
	}
	
	public static <T> void isEmpty(String inputString, String fieldName) throws CustomException {
		if (inputString.isEmpty()) {
			throw new BadRequestException(fieldName + " can't be empty");
		}
	}

	public static void checkLimitAndOffset(int limit, int offset) throws CustomException {
		if (limit <= 0 || offset < 0 || limit > 101)
			throw new BadRequestException("Invalid pagination values");
	}
	
	public static void checkUserRole(Integer role) throws CustomException {
		if (role < 0 || role > 4) {
		    throw new BadRequestException("Invalid user role.");
		}
	}
	
	public static void validateCredential(Credential credential) throws CustomException {
		
		String email = credential.getEmail();
		//String password = credential.getPassword();
		
		if (email == null || !email.matches("^(?=.{1,100}$)[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$")) {
		    throw new BadRequestException("Invalid email format.");
		}
		
//		if (password == null || password.matches("^(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\\\\W).{8,20}$")) {
//	        throw new CustomException("Password must be 8-20 characters, include uppercase, lowercase, number, and a special character.");
//	    }
	}
	
	public static void validateUser(User user) throws CustomException {
		
	    String fullName = user.getFullName();
	    String email = user.getEmail();
	    String phone = user.getPhone();
	    String dob = user.getDob();
	    Integer age = user.getAge();
	    String gender = user.getGender();
	    Integer userType = user.getUserType();
	    String password = user.getPasswordHash();
		
	    if (fullName == null || !fullName.matches("^(?=.{2,50}$)[A-Za-z]+(?:[\\-' ][A-Za-z]+)*$")) {
	        throw new BadRequestException("Full name must contain only letters and spaces (2–50 characters).");
	    }

	    if (email == null || !email.matches("^(?=.{1,70}$)[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$")) {
	        throw new BadRequestException("Invalid email format.");
	    }

	    if (password == null || password.matches("^(?=.*\\\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\\\\W).{8,20}$")) {
	        throw new BadRequestException("Password must be 8-20 characters, include uppercase, lowercase, number, and a special character.");
	    }

	    if (phone == null || !phone.matches("^[6-9]\\d{9}$")) {
	        throw new BadRequestException("Phone number must be a valid 10-digit Indian number starting with 6–9.");
	    }

	    if (dob == null || !dob.matches("^\\d{4}-\\d{2}-\\d{2}$")) {
	        throw new BadRequestException("Date of birth must be in YYYY-MM-DD format.");
	    }

	    if (age == null || age < 18 || age > 120) {
	        throw new BadRequestException("Age must be between 0 and 120.");
	    }

	    if (gender == null || !(gender.equalsIgnoreCase("male") || gender.equalsIgnoreCase("female") || gender.equalsIgnoreCase("other"))) {
	        throw new BadRequestException("Gender must be 'male', 'female', or 'other'.");
	    }

	    if (userType == null || userType < 0 || userType > 3) {
	        throw new BadRequestException("Invalid user type.");
	    }
	}
	
	public static void validateUserForUpdate(User user) throws CustomException {
		
	    String fullName = user.getFullName();
	    String email = user.getEmail();
	    String phone = user.getPhone();
	    String dob = user.getDob();
	    Integer age = user.getAge();
	    String gender = user.getGender();
	    Integer userType = user.getUserType();
		
	    if (fullName == null || !fullName.matches("^(?=.{2,50}$)[A-Za-z]+(?:[\\-' ][A-Za-z]+)*$")) {
	        throw new BadRequestException("Full name must contain only letters and spaces (2–50 characters).");
	    }

	    if (email == null || !email.matches("^(?=.{1,70}$)[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$")) {
	        throw new BadRequestException("Invalid email format.");
	    }

	    if (phone == null || !phone.matches("^[6-9]\\d{9}$")) {
	        throw new BadRequestException("Phone number must be a valid 10-digit Indian number starting with 6–9.");
	    }

	    if (dob == null || !dob.matches("^\\d{4}-\\d{2}-\\d{2}$")) {
	        throw new BadRequestException("Date of birth must be in YYYY-MM-DD format.");
	    }

	    if (age == null || age < 18 || age > 120) {
	        throw new BadRequestException("Age must be between 0 and 120.");
	    }

	    if (gender == null || !(gender.equalsIgnoreCase("male") || gender.equalsIgnoreCase("female") || gender.equalsIgnoreCase("other"))) {
	        throw new BadRequestException("Gender must be 'male', 'female', or 'other'.");
	    }

	    if (userType == null || userType < 0 || userType > 3) {
	        throw new BadRequestException("Invalid user type.");
	    }
	}
	
	public static void validateCustomer(Customer customer) throws CustomException {
		
		String aadharNumber = customer.getAadharNumber();
		String panId = customer.getPanId();
		String address = customer.getAddress();
		
		if (aadharNumber == null || !aadharNumber.matches("^\\d{12}$")) {
		    throw new BadRequestException("Aadhar number must be exactly 12 digits.");
		}

		if (panId == null || !panId.matches("^[A-Z]{5}[0-9]{4}[A-Z]{1}$")) {
		    throw new BadRequestException("PAN ID must follow the format: 5 uppercase letters, 4 digits, 1 uppercase letter (e.g., ABCDE1234F).");
		}

		if (address == null || address.isBlank() || address.length() < 5 || address.length() > 50) {
		    throw new BadRequestException("Address must be between 5 and 250 characters.");
		}
		
	}
	
	public static void validateEmployee(Employee employee) throws CustomException {
		
		Integer role = employee.getRole();
		Long branch = employee.getBranch();
		
		if (role == null || role < 1 || role > 3) {
			throw new BadRequestException ("Invalid employee Role");
		}
		
		if (branch == null || branch <= 0) {
		    throw new BadRequestException("Invalid branch Id");
		}
	}
	
	public static void validateBranch(Branch branch) throws CustomException {
		
		String branchName = branch.getBranchName();
		String branchDistrict = branch.getBranchDistrict();
		String address = branch.getBranchDistrict();
		
		if (branchName == null || !branchName.matches("^[A-Za-z0-9 .'-]{3,100}$")) {
		    throw new BadRequestException("Branch name must be 3 to 100 characters long");
		}

		if (branchDistrict == null || !branchDistrict.matches("^[A-Za-z ]{2,50}$")) {
		    throw new BadRequestException("Branch district must contain only 2–50 characters");
		}

		if (address == null || address.isBlank() || address.length() < 5 || address.length() > 300) {
		    throw new BadRequestException("Address must be between 5 and 300 characters");
		}

	}
	
	public static void ValidateBeneficiary(Beneficiary beneficiary) throws CustomException {
		
		String beneficiaryName = beneficiary.getBeneficiaryName();
		String bankName = beneficiary.getBankName();
		Long beneficiaryAccountNumber = beneficiary.getBeneficiaryAccountNumber();
		String ifscCode = beneficiary.getIfscCode();
		Long accountId = beneficiary.getAccountId();
		
		if (beneficiaryName == null || !beneficiaryName.matches("^[A-Za-z .'-]{2,100}$")) {
		    throw new BadRequestException("Beneficiary name must only 2 to 100 characters long");
		}

		if (bankName == null || !bankName.matches("^[A-Za-z0-9 .'-]{2,100}$")) {
		    throw new BadRequestException("Bank name must be 2 to 100 characters long");
		}

		if (beneficiaryAccountNumber == null || beneficiaryAccountNumber <= 0) {
		    throw new BadRequestException("Beneficiary account number must be a positive number.");
		}

		if (ifscCode == null || !ifscCode.matches("^[A-Z]{4}0[A-Z0-9]{6}$")) {
		    throw new BadRequestException("Invalid IFSC code");
		}

		if (accountId == null || accountId <= 0) {
		    throw new BadRequestException("Invalid Associated account ID");
		}

	}
	
	public static void ValidateAccount(Account account) throws CustomException {
		
		Long customerId = account.getCustomerId();
	    Long branchId = account.getBranchId();
	    Integer accountType = account.getAccountType();
	    BigDecimal balance = account.getBalance();
	    
	    if (customerId == null || customerId <= 0) {
		    throw new BadRequestException("Invalid customer Id");
		}
	    
	    if (branchId == null || branchId <= 0) {
		    throw new BadRequestException("Invalid branch Id");
		}
	    
	    if (accountType == null || accountType <= 0) {
		    throw new BadRequestException("Invalid account type");
		}
	    
	    BigDecimal MAX_TRANSACTION_LIMIT = new BigDecimal("100000"); // ₹10,00,000

	    if (balance == null || balance.compareTo(BigDecimal.ZERO) <= 0 || balance.compareTo(MAX_TRANSACTION_LIMIT) > 0) {
	        throw new BadRequestException("Initial balance should not exceed ₹1,00,000.");
	    }
 
	}
	
	public static void ValidateTransactions(Transaction transaction) throws CustomException {
		
		Long accountId = transaction.getAccountId();
		Long customerId = transaction.getCustomerId();
		BigDecimal amount = transaction.getAmount();
		Integer transactionType = transaction.getTransactionType();
		String description = transaction.getDescription();
		
		if (accountId == null || accountId <= 0) {
		    throw new BadRequestException("Valid account ID is required.");
		}

		if (customerId == null || customerId <= 0) {
		    throw new BadRequestException("Valid customer ID is required.");
		}

		BigDecimal MAX_TRANSACTION_LIMIT = new BigDecimal("100000"); // ₹1,00,000

		if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0 || amount.compareTo(MAX_TRANSACTION_LIMIT) > 0) {
		    throw new BadRequestException("Transaction amount must be greater than zero and not exceed 1,00,000.");
		}

		if (transactionType == null || transactionType < 0 || transactionType > 4) {
		    throw new BadRequestException("Invalid transaction Type");
		}
		
		// Optional description validation
	    if (description != null && !description.trim().isEmpty()) {
	        if (description.length() > 50) {
	            throw new BadRequestException("Description must not exceed 100 characters.");
	        }
	        if (!description.matches("[A-Za-z0-9 ,.\\-']*")) {
	            throw new BadRequestException("Description contains invalid characters.");
	        }
	    }

	}
	

}
