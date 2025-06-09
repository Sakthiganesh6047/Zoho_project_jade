package pojos;

public class Employee {

	private Long employeeId;
	private Integer role;
	private Long branch;
	
	//getters and setters
	
	public void setEmployeeId(Long employeeId) {
		this.employeeId = employeeId;
	}
	
	public Long getEmployeeId() {
		return employeeId;
	}
	
	public void setRole(int role) {
		this.role = role;
	}
	
	public int getRole() {
		return role;
	}
	
	public void setBranch(Long branch) {
		this.branch = branch;
	}
	
	public Long getBranch() {
		return branch;
	}
}
