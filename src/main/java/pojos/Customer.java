package pojos;

public class Customer {

	private Long customerId;
	private String aadharNumber;
	private String panId;
	private String address;
	
	//getters and setters
	
	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
	}
	
	public Long getCustomerId() {
		return customerId;
	}
	
	public void setAadharNumber(String aadharNumber) {
		this.aadharNumber = aadharNumber;
	}
	
	public String getAadharNumber() {
		return aadharNumber;
	}
	
	public void setPanId(String panId) {
		this.panId = panId;
	}
	
	public String getPanId() {
		return panId;
	}
	
	public void setAddress(String address) {
		this.address = address;
	}
	
	public String getAddress() {
		return address;
	}
}
