package util;

import java.util.List;

public class results {

	public static <T> T getSingleResult(List<T> list) {
	    return (list == null || list.isEmpty()) ? null : list.get(0);
	}

}
