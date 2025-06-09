package pojos;

public class Nominee {

	private Integer nomineeId;
	private String name;
	private Integer phoneNumber;
	private Integer accountId;
	private Integer createdBy;
	private Integer modifiedBy;
	private Long modifiedOn;
	private Integer nomineeCustomerId;
	
	//getters and setters
	
	public Integer getNomineeId() {
		return nomineeId;
	}
	public void setNomineeId(Integer nomineeId) {
		this.nomineeId = nomineeId;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public Integer getPhoneNumber() {
		return phoneNumber;
	}
	public void setPhoneNumber(Integer phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	
	public Integer getAccountId() {
		return accountId;
	}
	public void setAccountId(Integer accountId) {
		this.accountId = accountId;
	}
	
	public Integer getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(Integer createdBy) {
		this.createdBy = createdBy;
	}
	
	public Integer getModifiedBy() {
		return modifiedBy;
	}
	public void setModifiedBy(Integer modifiedBy) {
		this.modifiedBy = modifiedBy;
	}
	
	public Long getModifiedOn() {
		return modifiedOn;
	}
	public void setModifiedOn(Long modifiedOn) {
		this.modifiedOn = modifiedOn;
	}
	
	public Integer getNomineeCustomerId() {
		return nomineeCustomerId;
	}
	public void setNomineeCustomerId(Integer nomineeCustomerId) {
		this.nomineeCustomerId = nomineeCustomerId;
	}
	
}
