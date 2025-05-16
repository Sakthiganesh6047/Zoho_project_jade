package pojos;

public class Employee {

	private long employeeId;
	private int role;
	private long branch;
	
	//getters and setters
	
	public void setEmployeeId(long employeeId) {
		this.employeeId = employeeId;
	}
	
	public long getEmployeeId() {
		return employeeId;
	}
	
	public void setRole(int role) {
		this.role = role;
	}
	
	public int getRole() {
		return role;
	}
	
	public void setBranch(long branch) {
		this.branch = branch;
	}
	
	public long getBranch() {
		return branch;
	}
}
