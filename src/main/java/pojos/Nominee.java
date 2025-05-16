package pojos;

public class Nominee {

	private int nomineeId;
	private String name;
	private int phoneNumber;
	private int accountId;
	private int createdBy;
	private int modifiedBy;
	private long modifiedOn;
	private int nomineeCustomerId;
	
	//getters and setters
	
	public int getNomineeId() {
		return nomineeId;
	}
	public void setNomineeId(int nomineeId) {
		this.nomineeId = nomineeId;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public int getPhoneNumber() {
		return phoneNumber;
	}
	public void setPhoneNumber(int phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	
	public int getAccountId() {
		return accountId;
	}
	public void setAccountId(int accountId) {
		this.accountId = accountId;
	}
	
	public int getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(int createdBy) {
		this.createdBy = createdBy;
	}
	
	public int getModifiedBy() {
		return modifiedBy;
	}
	public void setModifiedBy(int modifiedBy) {
		this.modifiedBy = modifiedBy;
	}
	
	public long getModifiedOn() {
		return modifiedOn;
	}
	public void setModifiedOn(long modifiedOn) {
		this.modifiedOn = modifiedOn;
	}
	
	public int getNomineeCustomerId() {
		return nomineeCustomerId;
	}
	public void setNomineeCustomerId(int nomineeCustomerId) {
		this.nomineeCustomerId = nomineeCustomerId;
	}
	
}
