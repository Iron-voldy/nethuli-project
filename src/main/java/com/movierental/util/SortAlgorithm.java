package com.movierental.util;

import java.util.List;
import java.util.Comparator;

public class SortAlgorithm {
    // Generic bubble sort method for any list with a comparator
    public static <T> void bubbleSort(List<T> list, Comparator<? super T> comparator) {
        int n = list.size();
        boolean swapped;

        for (int i = 0; i < n - 1; i++) {
            swapped = false;

            for (int j = 0; j < n - i - 1; j++) {
                if (comparator.compare(list.get(j), list.get(j + 1)) > 0) {
                    // Swap elements
                    T temp = list.get(j);
                    list.set(j, list.get(j + 1));
                    list.set(j + 1, temp);
                    swapped = true;
                }
            }

            // If no swapping occurred, list is already sorted
            if (!swapped) {
                break;
            }
        }
    }

    // Bubble sort method for numerical comparisons
    public static <T extends Comparable<T>> void bubbleSort(List<T> list) {
        int n = list.size();
        boolean swapped;

        for (int i = 0; i < n - 1; i++) {
            swapped = false;

            for (int j = 0; j < n - i - 1; j++) {
                if (list.get(j).compareTo(list.get(j + 1)) > 0) {
                    // Swap elements
                    T temp = list.get(j);
                    list.set(j, list.get(j + 1));
                    list.set(j + 1, temp);
                    swapped = true;
                }
            }

            // If no swapping occurred, list is already sorted
            if (!swapped) {
                break;
            }
        }
    }
}