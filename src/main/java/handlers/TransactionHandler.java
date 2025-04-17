package handlers;

import DAO.TransactionDAO;

public class TransactionHandler {

	private final TransactionDAO transactionDAO;

    public TransactionHandler(TransactionDAO transactionDAO) {
        this.transactionDAO = transactionDAO;
    }
}
