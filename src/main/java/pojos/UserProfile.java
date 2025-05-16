package pojos;

public class UserProfile {
    private User user;
    private Employee employeeDetails;
    private Customer customerDetails;

    // Constructors
    public UserProfile(User user) {
        this.user = user;
    }
    
    public UserProfile() {
    }

    // Getters and Setters
    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Employee getEmployeeDetails() {
        return employeeDetails;
    }

    public void setEmployeeDetails(Employee employeeDetails) {
        this.employeeDetails = employeeDetails;
    }

    public Customer getCustomerDetails() {
        return customerDetails;
    }

    public void setCustomerDetails(Customer customerDetails) {
        this.customerDetails = customerDetails;
    }
}

