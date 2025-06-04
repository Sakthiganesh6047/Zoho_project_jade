package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import DAO.AccountDAO;
import DAO.BeneficiaryDAO;
import DAO.BranchDAO;
import DAO.CustomerDAO;
import DAO.EmployeeDAO;
import DAO.TransactionDAO;
import DAO.UserDAO;
import handlers.AccountHandler;
import handlers.BeneficiaryHandler;
import handlers.BranchHandler;
import handlers.CustomerHandler;
import handlers.EmployeeHandler;
import handlers.TransactionHandler;
import handlers.UserHandler;

@WebServlet("/jadebank/*")
public class JadeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    
    private HandlersRegistry registry;

    @Override
    public void init() throws ServletException {
        try {

            UserDAO userDAO = UserDAO.getUserDAOInstance();
            AccountDAO accountDAO = AccountDAO.getAccountDAOInstance();
            TransactionDAO transactionDAO = new TransactionDAO();
            BranchDAO branchDAO = new BranchDAO();
            EmployeeDAO employeeDAO = EmployeeDAO.getEmployeeDAOInstance();
            CustomerDAO customerDAO = new CustomerDAO();
            BeneficiaryDAO beneficiaryDAO = BeneficiaryDAO.getBeneficiaryDAOInstance();
            
            AccountHandler accountHandler = new AccountHandler(accountDAO);
            TransactionHandler transactionHandler = new TransactionHandler(transactionDAO);
            BranchHandler branchHandler = new BranchHandler(branchDAO);
            EmployeeHandler employeeHandler = new EmployeeHandler(employeeDAO);
            CustomerHandler customerHandler = new CustomerHandler(customerDAO);
            UserHandler userHandler = new UserHandler(userDAO, employeeHandler, customerHandler);
            BeneficiaryHandler beneficiaryHandler = new BeneficiaryHandler(beneficiaryDAO);
            
            registry = new HandlersRegistry();
            registry.register("user", userHandler);
            registry.register("account", accountHandler);
            registry.register("transaction", transactionHandler);
            registry.register("branch", branchHandler);
            registry.register("beneficiary", beneficiaryHandler);

        } catch (Exception e) {
            throw new ServletException("Initialization failed", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) {
        registry.dispatch(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        registry.dispatch(req, resp);
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        registry.dispatch(req, resp);
    }
    
}

