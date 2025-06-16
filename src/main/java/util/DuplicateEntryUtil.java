package util;

public class DuplicateEntryUtil {

	public static void handleDuplicateEntryExceptions(String msg) throws CustomException {
		if (msg.contains("User.phone")) {
            throw new CustomException("Phone number already exists.");
        } 
		
		if (msg.contains("User.email")) {
            throw new CustomException("Email already exists.");
        }
		
		if (msg.contains("Customer.aadhar_number")) {
        	throw new CustomException("Aadhar already exists");
        } 
		
		if (msg.contains("Customer.pan_id")) {
        	throw new CustomException("PanId already exists");
		}
		
		if (msg.contains("Branch.branch_name")) {
			throw new CustomException("Branch Name already exists");
		}
		
		if (msg.contains("Branch.ifsc_code")) {
			throw new CustomException("Duplicate IFSC Code found");
		}
	}
}
