package pojos;

public class Customer {

	private long customerId;
	private String aadharNumber;
	private String panId;
	private String address;
	
	//getters and setters
	
	public void setCustomerId(long customerId) {
		this.customerId = customerId;
	}
	
	public long getCustomerId() {
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
