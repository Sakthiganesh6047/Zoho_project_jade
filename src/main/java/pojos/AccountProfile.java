package pojos;

import java.math.BigDecimal;

public class AccountProfile {

	Long AccountId;
	Long customerId;
	String fullName;
	String phone;
	String email;
	BigDecimal balance;
	Integer accountType;
	Long CreatedAt;
	
	public Long getAccountId() {
		return AccountId;
	}
	public void setAccountId(Long accountId) {
		AccountId = accountId;
	}
	
	public Long getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
	}
	
	public String getFullName() {
		return fullName;
	}
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}
	
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	
	public BigDecimal getBalance() {
		return balance;
	}
	public void setBalance(BigDecimal balance) {
		this.balance = balance;
	}
	
	public Integer getAccountType() {
		return accountType;
	}
	public void setAccountType(Integer accountType) {
		this.accountType = accountType;
	}
	
	public Long getCreatedAt() {
		return CreatedAt;
	}
	public void setCreatedAt(Long createdAt) {
		CreatedAt = createdAt;
	}
	
}
