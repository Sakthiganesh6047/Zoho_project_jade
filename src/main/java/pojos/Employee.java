package pojos;

public class Employee {

	private int employeeId;
	private String role;
	private String branch;
	
	//getters and setters
	
	public void setEmployeeId(int employeeId) {
		this.employeeId = employeeId;
	}
	
	public int getEmployeeId() {
		return employeeId;
	}
	
	public void setRole(String role) {
		this.role = role;
	}
	
	public String getRole() {
		return role;
	}
	
	public void setBranch(String branch) {
		this.branch = branch;
	}
	
	public String getBranch() {
		return branch;
	}
}
