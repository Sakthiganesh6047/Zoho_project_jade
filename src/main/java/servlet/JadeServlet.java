package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import DAO.AccountDAO;
import DAO.BranchDAO;
import DAO.TransactionDAO;
import DAO.UserDAO;
import handlers.AccountHandler;
import handlers.BranchHandler;
import handlers.TransactionHandler;
import handlers.UserHandler;

@WebServlet("/jadebank/*")
public class JadeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    
    private HandlersRegistry registry;

    @Override
    public void init() throws ServletException {
        try {

            UserDAO userDAO = new UserDAO();
            AccountDAO accountDAO = new AccountDAO();
            TransactionDAO transactionDAO = new TransactionDAO();
            BranchDAO branchDAO = new BranchDAO();

            UserHandler userHandler = new UserHandler(userDAO);
            AccountHandler accountHandler = new AccountHandler(accountDAO);
            TransactionHandler transactionHandler = new TransactionHandler(transactionDAO);
            BranchHandler branchHandler = new BranchHandler(branchDAO);

            registry = new HandlersRegistry();
            registry.register("user", userHandler);
            registry.register("account", accountHandler);
            registry.register("transaction", transactionHandler);
            registry.register("branch", branchHandler);

        } catch (Exception e) {
            throw new ServletException("Initialization failed", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
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

