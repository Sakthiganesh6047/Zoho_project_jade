package pojos;

public class TransferWrapper {

	private Transaction transaction;
	private Beneficiary beneficiary;
	
	//constructors
	
	public TransferWrapper() {
	}
	
	public TransferWrapper(Transaction transaction, Beneficiary beneficiary) {
		this.beneficiary = beneficiary;
		this.transaction = transaction;
	}

	public Transaction getTransaction() {
		return transaction;
	}

	public void setTransaction(Transaction transaction) {
		this.transaction = transaction;
	}

	public Beneficiary getBeneficiary() {
		return beneficiary;
	}

	public void setBeneficiary(Beneficiary beneficiary) {
		this.beneficiary = beneficiary;
	}
}
