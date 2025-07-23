package util;

public class UnauthorizedAccessException extends CustomException {
    private static final long serialVersionUID = 1L;

	public UnauthorizedAccessException(String message) {
        super(message);
    }
}
