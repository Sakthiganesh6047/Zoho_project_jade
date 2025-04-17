package handlers;

import DAO.AccountDAO;

public class AccountHandler {
	
	private final AccountDAO accountDAO;

    public AccountHandler(AccountDAO accountDAO) {
        this.accountDAO = accountDAO;
    }
}
