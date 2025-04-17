package handlers;

import DAO.BranchDAO;

public class BranchHandler {
	
	public final BranchDAO branchDAO;
	
	public BranchHandler(BranchDAO branchDAO) {
		this.branchDAO = branchDAO;
	}
}
