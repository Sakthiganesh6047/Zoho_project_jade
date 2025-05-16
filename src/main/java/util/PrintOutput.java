package util;

import java.util.List;

public class PrintOutput {

	public static <T> void printList(List<T> list) {
        if (list.isEmpty()) {
            System.out.println("List is empty.");
            return;
        }

        for (T item : list) {
            System.out.println(item);
        }
    }
}
