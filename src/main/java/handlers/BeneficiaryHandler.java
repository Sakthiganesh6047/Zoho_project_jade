package handlers;

import java.time.Instant;
import java.util.Map;
import DAO.BeneficiaryDAO;
import annotations.FromBody;
import annotations.FromPath;
import annotations.FromQuery;
import annotations.FromSession;
import annotations.Route;
import pojos.Beneficiary;
import util.AuthorizeUtil;
import util.CustomException;
import util.Results;
import util.ValidationsUtil;

public class BeneficiaryHandler {
	
	public final BeneficiaryDAO beneficiaryDAO;
	
	public BeneficiaryHandler(BeneficiaryDAO beneficiaryDAO) {
		this.beneficiaryDAO = beneficiaryDAO;
	}

	@Route(path = "beneficiary/add", method = "POST")
	public String addBeneficiary(@FromBody Beneficiary beneficiary, @FromSession("userId") Long userId) throws CustomException {
		
		ValidationsUtil.isNull(userId, "UserId");
		ValidationsUtil.ValidateBeneficiary(beneficiary);
		
		beneficiary.setCreatedBy(userId);
		beneficiary.setModifiedOn(Instant.now().toEpochMilli());
		beneficiary.setModifiedBy(0L);
		
		int result = beneficiaryDAO.insertBeneficiary(beneficiary);
		return Results.respondJson(Map.of("Status", "Created", "BeneficiaryId", result));
	}
	
	@Route(path = "beneficiary/update", method = "POST")
	public String updateBeneficiary(@FromBody Beneficiary beneficiary, @FromSession("userId") Long userId,
								@FromSession("role") Integer role) throws CustomException {
		
		ValidationsUtil.isNull(userId, "UserId");
		ValidationsUtil.isNull(role, "User Role");
		ValidationsUtil.checkUserRole(role);
		ValidationsUtil.ValidateBeneficiary(beneficiary);
		
		if (role == 0) {
			if(!AuthorizeUtil.isAuthorizedOwner(userId, beneficiary.getAccountId())) {
				throw new CustomException("Unauthorized Access, Updation failed");
			}
		}
		beneficiary.setModifiedBy(userId);
		beneficiary.setModifiedOn(Instant.now().toEpochMilli());
		int result = beneficiaryDAO.updateBeneficiary(beneficiary);
		return Results.respondJson(Map.of("Status", "updated", "Rows Affected", result));
	}
	
	@Route(path = "beneficiary/id", method = "POST")
	public String getBeneficiaries(@FromBody Beneficiary beneficiary, @FromQuery("limit") int limit, @FromQuery("offset") int offset, 
							@FromSession("userId") Long userId, @FromSession("role") Integer role) throws CustomException {
		
		ValidationsUtil.checkLimitAndOffset(limit, offset);
		ValidationsUtil.isNull(userId, "UserId");
		ValidationsUtil.isNull(role, "User Role");
		ValidationsUtil.checkUserRole(role);
		
		if (role == 0) {
			if(!AuthorizeUtil.isAuthorizedOwner(userId, beneficiary.getAccountId())) {
				throw new CustomException("You can't access this account's beneficiary list");
			}
		}
		return Results.respondJson(beneficiaryDAO.getBeneficiariesByAccountId(beneficiary.getAccountId(), userId, limit, offset));	
	}
	
	@Route(path = "beneficiary/{beneficiarId}", method = "DELETE")
	public String deleteBeneficiary(@FromPath("beneficiarId") Long beneficiarId, @FromSession("userId") Long userId,
									@FromSession("role") Integer role) throws CustomException {
		
		ValidationsUtil.isNull(beneficiarId, "Beneficiar Id");
		ValidationsUtil.isNull(userId, "UserId");
		ValidationsUtil.isNull(role, "User Role");
		ValidationsUtil.checkUserRole(role);
		
		if (role == 0) {
			if(!AuthorizeUtil.isAuthorizedOwner(userId, beneficiarId)) {
				throw new CustomException("Unauthorized Access, Deletion Failed");
			}
		}
		int results = beneficiaryDAO.deleteBeneficiary(beneficiarId);
		return Results.respondJson(Map.of("Status", "Deleted", "Rows Affected", results));
	}
	
//	@Route(path = "beneficiary/list", method = "GET")
//	public String listBeneficiaries(@FromQuery("limit") int limit, @FromQuery("offset") int offset) throws CustomException {
//		return Results.respondJson(beneficiaryDAO.getAllBeneficiaries(limit, offset));
//	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
