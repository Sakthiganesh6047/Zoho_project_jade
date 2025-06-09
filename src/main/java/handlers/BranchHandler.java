package handlers;

import java.time.Instant;
import java.util.Map;
import DAO.BranchDAO;
import annotations.FromBody;
import annotations.FromPath;
import annotations.FromQuery;
import annotations.FromSession;
import annotations.Route;
import pojos.Branch;
import pojos.Employee;
import util.AuthorizeUtil;
import util.CustomException;
import util.Results;
import util.ValidationsUtil;

public class BranchHandler {
	
	public final BranchDAO branchDAO;
	
	public BranchHandler(BranchDAO branchDAO) {
		this.branchDAO = branchDAO;
	}
	
	@Route(path = "branch/new", method = "POST")
	public String createBranch(@FromBody Branch branch, @FromSession("userId") long creatorId) throws CustomException {
		
		ValidationsUtil.validateBranch(branch);
		ValidationsUtil.isNull(creatorId, "UserId");
		
		branch.setCreatedBy(creatorId);
		branch.setModifiedOn(Instant.now().toEpochMilli());
		branch.setModifiedBy(null);
		int result = branchDAO.createBranch(branch);
		return Results.respondJson(Map.of("Status", "Created", "BranchId", result));
	}
	
	@Route(path = "branch/update", method = "POST")
	public String modifyBranch(@FromBody Branch branch, @FromSession("userId") long modifierId, 
								@FromSession("role") int modifierRole) throws CustomException {
		
		ValidationsUtil.validateBranch(branch);
		ValidationsUtil.isNull(modifierId, "UserId");
		ValidationsUtil.isNull(modifierRole, "UserRole");
		
		if (modifierRole == 2) {
			Employee manager = AuthorizeUtil.getEmployeeDetails(modifierId);
			if(manager.getBranch() != branch.getBranchId()) {
				throw new CustomException("You are not allowed to change this branch details");
			}
		}
		branch.setModifiedBy(modifierId);
		branch.setModifiedOn(Instant.now().toEpochMilli());
		int rowsAffected = branchDAO.updateBranch(branch);
		return Results.respondJson(Map.of("Status", "Updated", "Rows Affected", rowsAffected));
	}
	
	@Route(path = "branch/list", method = "GET")
	public String branchList(@FromQuery("limit") int limit, @FromQuery("offset") int offset) throws CustomException {
		ValidationsUtil.checkLimitAndOffset(limit, offset);
		return Results.respondJson(branchDAO.getAllBranches(limit, offset));
	}
	
	@Route(path = "branch/{ifsc}", method = "GET")
	public String getBranchByIFSC(@FromPath("ifsc") String ifsc) throws CustomException {
		
		ValidationsUtil.isNull(ifsc, "IFSC Code");
		ValidationsUtil.isEmpty(ifsc, "IFSC code");
		
		return Results.respondJson(branchDAO.getBranchByIfsc(ifsc));
	}
	
	@Route(path = "branch/{branchId}", method = "GET")
	public String getBranchById(@FromPath("branchId") long branchId) throws CustomException {
		
		ValidationsUtil.isNull(branchId, "BranchId");
		
		return Results.respondJson(branchDAO.getBranchById(branchId));
	}
	
}
