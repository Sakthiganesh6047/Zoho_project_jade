package handlers;

import java.time.Instant;
import java.util.Map;
import DAO.BranchDAO;
import annotations.FromBody;
import annotations.FromQuery;
import annotations.FromSession;
import annotations.Route;
import pojos.Branch;
import pojos.Employee;
import util.AuthorizeUtil;
import util.CustomException;
import util.Results;

public class BranchHandler {
	
	public final BranchDAO branchDAO;
	
	public BranchHandler(BranchDAO branchDAO) {
		this.branchDAO = branchDAO;
	}
	
	@Route(path = "create", method = "POST")
	public String createBranch(@FromBody Branch branch, @FromSession("userId") long creatorId) throws CustomException {
		branch.setCreatedBy(creatorId);
		branch.setModifiedOn(Instant.now().toEpochMilli());
		branch.setModifiedBy(null);
		long result = branchDAO.createBranch(branch);
		return Results.respondJson(Map.of("Status", "Created", "BranchId", result));
	}
	
	@Route(path = "modify", method = "POST")
	public String modifyBranch(@FromBody Branch branch, @FromQuery("branchid") long branchId, @FromSession("userId") long modifierId, 
								@FromSession("role") int modifierRole) throws CustomException {
		if (modifierRole == 2) {
			Employee manager = AuthorizeUtil.getEmployeeDetails(modifierId);
			if(manager.getBranch() != branchId) {
				throw new CustomException("You are not allowed to change this branch details");
			}
		}
		branch.setModifiedBy(modifierId);
		branch.setModifiedOn(Instant.now().toEpochMilli());
		int rowsAffected = branchDAO.updateBranch(branch);
		return Results.respondJson(Map.of("Status", "Updated", "Rows Affected", rowsAffected));
	}
	
	@Route(path = "getAll", method = "GET")
	public String branchList() throws CustomException {
		return Results.respondJson(branchDAO.getAllBranches());
	}
	
	@Route(path = "getByIfsc", method = "GET")
	public String getBranchByIFSC(@FromQuery("ifsc") String ifsc) throws CustomException {
		return Results.respondJson(branchDAO.getBranchByIfsc(ifsc));
	}
	
	@Route(path = "getById", method = "GET")
	public String getBranchById(@FromQuery("branchid") long branchId) throws CustomException {
		return Results.respondJson(branchDAO.getBranchById(branchId));
	}
	
}
