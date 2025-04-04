package zoho_jade_bank;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import pojos.Account;
import pojos.Transaction;
import pojos.User;

public class TestQB {
	
    public static void main(String[] args) {
    	
    	try {
    		
	        // Insert a new User
	        User user = new User();
	        user.setFullName("Alice Johnson");
	        user.setEmail("alice@example.com");
	        user.setPasswordHash("hashedpassword123");
	        user.setPhone("9876543210");
	        user.setDob("1995-05-10");
	        user.setAge(29);
	        user.setGender("f");
	        user.setUserType("customer");
	        user.setStatus("active");
	        user.setModifiedBy(1l);
	        user.setCreatedBy(null);
	        user.setModifiedOn(null);
	        QueryBuilder qbUser = new QueryBuilder(User.class);
	        QueryResult insertQuery = qbUser.insert(user).build();
	        System.out.println(insertQuery.getQuery());
	    	TestQB testQB = new TestQB();
	        testQB.executeQuery(insertQuery);
	
	        // Insert a new Account
	        Account account = new Account();
	        account.setAccountId(1l);
	        account.setCustomerId(1l);
	        account.setBranchId(1l);
	        account.setAccountType("savings");
	        account.setBalance(1.09);
	        account.setAccountStatus("active");
	        account.setCreatedBy(null);
	        account.setCreatedAt(null);
	        account.setModifiedBy(null);
	        account.setModifiedOn(null);
	        QueryBuilder qbAccount = new QueryBuilder(Account.class);
	        QueryResult insertAccountQuery = qbAccount.insert(account).build();
	        System.out.println(insertAccountQuery.getQuery());
	        testQB.executeQuery(insertAccountQuery);
	        
	        // Fetch Account Balance
	        QueryBuilder qbFetchBalance = new QueryBuilder(Account.class);
	        QueryResult fetchBalanceQuery = qbFetchBalance.select("balance").where("account_id", 101).build();
	        System.out.println(fetchBalanceQuery.getQuery());
	        testQB.executeQuery(fetchBalanceQuery);
	        
	        // Fetch Account Details
	        QueryBuilder qbFetchAccountDetails = new QueryBuilder(Account.class);
	        QueryResult fetchAccountDetailsQuery = qbFetchAccountDetails.select("*").where("account_id", 101).build();
	        System.out.println(insertAccountQuery.getQuery());
	        testQB.executeQuery(fetchAccountDetailsQuery);
	
	        // Fetch Customer Details
	        QueryBuilder qbFetchCustomerDetails = new QueryBuilder(User.class);
	        QueryResult fetchCustomerDetailsQuery = qbFetchCustomerDetails.select("*").where("customer_id", 1).build();
	        System.out.println(fetchCustomerDetailsQuery.getQuery());
	        testQB.executeQuery(fetchCustomerDetailsQuery);
	        
	        QueryBuilder qbJoin = new QueryBuilder(Account.class);
	        QueryResult joinQuery = qbJoin
	            .select("a.account_id, a.account_type, a.balance, c.full_name, c.aadhar_number")
	            .join("INNER", "customer c" , "a.customer_id = c.customer_id")
	            .where("a.account_status", "active")
	            .build();
	        System.out.println(joinQuery.getQuery());
	        testQB.executeQuery(joinQuery);
	        
	        QueryBuilder qb3 = new QueryBuilder(Transaction.class);
	        QueryResult query3 = qb3.select("*")
	            .where("account_id", 101)
	            .orderBy("transaction_date", "DESC")
	            .limit(5)
	            .offset(10)
	            .build();
	        System.out.println(query3.getQuery());
	        testQB.executeQuery(query3);
    	
    	} catch(Exception e) {
    		e.printStackTrace();
    	}
    }
    
    private void executeQuery(QueryResult queryResult) {
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/jadeDB", "root", "Asg@$^*6047007");
             PreparedStatement stmt = conn.prepareStatement(queryResult.getQuery())) {

            List<Object> parameters = queryResult.getParameters();
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }
            
            System.out.println(stmt.toString());

//            if (queryResult.getQuery().startsWith("SELECT")) {
//                ResultSet rs = stmt.executeQuery();
//                while (rs.next()) {
//                    System.out.println("Fetched Data: " + rs.getString(1));
//                }
//            } else {
//                int affectedRows = stmt.executeUpdate();
//                System.out.println("Rows affected: " + affectedRows);
//            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    	
    	//System.out.println(queryResult.getQuery());
    }

}

