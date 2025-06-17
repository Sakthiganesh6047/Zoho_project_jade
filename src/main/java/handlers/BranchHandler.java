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
	public String createBranch(@FromBody Branch branch, @FromSession("userId") Long creatorId) throws CustomException {
		
		ValidationsUtil.validateBranch(branch);
		ValidationsUtil.isNull(creatorId, "UserId");
		
		 // Generate IFSC code
	    String ifscCode = generateUniqueIFSC(branch.getBranchDistrict(), branchDAO);
	    branch.setIfscCode(ifscCode);
		
		branch.setCreatedBy(creatorId);
		branch.setCreatedOn(Instant.now().toEpochMilli());
		branch.setModifiedOn(Instant.now().toEpochMilli());
		Long result = branchDAO.createBranch(branch);
		return Results.respondJson(Map.of("BranchId", result));
	}
	
	private String generateUniqueIFSC(String district, BranchDAO branchDAO) throws CustomException {
	    String bankCode = "JADE"; // Replace with your fixed 4-letter bank code
	    String districtCode = getDistrictCode(district); // Convert district to numeric/short code

	    for (int i = 1; i <= 999; i++) {
	        String branchSerial = String.format("%03d", i);
	        String candidateIfsc = bankCode + districtCode + branchSerial;
	        if (!branchDAO.ifscExists(candidateIfsc)) {
	            return candidateIfsc;
	        }
	    }

	    throw new CustomException("Unable to generate unique IFSC code after 999 attempts");
	}
	
	private String getDistrictCode(String district) {
	    // Simplified example — ideally use a map or hashed code system
	    int hash = Math.abs(district.toLowerCase().hashCode());
	    return String.format("%03d", hash % 1000); // ensure 3-digit code
	}
	
	@Route(path = "branch/update", method = "POST")
	public String modifyBranch(@FromBody Branch branch, @FromSession("userId") Long modifierId, 
								@FromSession("role") Integer modifierRole) throws CustomException {
		
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
	
	@Route(path = "branch/all", method = "GET")
	public String branchList(@FromQuery("limit") int limit, @FromQuery("offset") int offset) throws CustomException {
		ValidationsUtil.checkLimitAndOffset(limit, offset);
		return Results.respondJson(branchDAO.getBranchList(limit, offset));
	}
	
	@Route(path = "branch/list", method = "GET")
	public String branchListForm(@FromSession("userId") Long userId, @FromSession("role") Integer userRole) throws CustomException {
		if(userRole == 2 || userRole == 1) {
			Employee employee = AuthorizeUtil.getEmployeeDetails(userId);
			return Results.respondJson(branchDAO.getAllBranches(employee.getBranch()));
		}
		return Results.respondJson(branchDAO.getAllBranches());
	}
	
	@Route(path = "branch/ifsc/{ifsc}", method = "GET")
	public String getBranchByIFSC(@FromPath("ifsc") String ifsc) throws CustomException {
		
		ValidationsUtil.isNull(ifsc, "IFSC Code");
		ValidationsUtil.isEmpty(ifsc, "IFSC code");
		
		return Results.respondJson(branchDAO.getBranchByIfsc(ifsc));
	}
	
	@Route(path = "branch/id/{branchId}", method = "GET")
	public String getBranchById(@FromPath("branchId") long branchId) throws CustomException {
		
		ValidationsUtil.isNull(branchId, "BranchId");
		
		return Results.respondJson(branchDAO.getBranchById(branchId));
	}
	
}
