#include "crt.h"

void swap(int *arr, int i, int j) {
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
}

void bubble_sort(int arr[], int size) {

    for (int i = 0; i < size - 1; i++) {
        for (int j = 0; j < size - i - 1; j++) {
            if (arr[j] > arr[j + 1])
                swap(arr, j, j + 1);
        }
    }
}

int main() {

    int arr[10] = {57, 72, 17, 79, 56, 35, 10, 82, 81, 13};

    int size = sizeof(arr) / sizeof(arr[0]);

    mini_printf("Numbers before sorting:\n");
    for (int i = 0; i < size; i++)
        mini_printf("0x%x ", arr[i]);

    bubble_sort(arr, size);

    mini_printf("\nNumbers after sorting: \n");
    for (int i = 0; i < size; i++)
        mini_printf("0x%x ", arr[i]);

    return 0;
}