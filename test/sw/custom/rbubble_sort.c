#include "crt.h"

void swap(int *arr, int i, int j) {
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
}

void rbubble_sort(int arr[], int size) {

    if (size <= 0) return;

    for (int i = 0; i < size - 1; i++) {
        if (arr[i] > arr[i + 1]) {
            swap(arr, i, i + 1);
        }
    }

    size -= 1;

    rbubble_sort(arr, size);
}

int main() {

    int arr[10] = {57, 72, 17, 79, 56, 35, 10, 82, 81, 13};

    int size = sizeof(arr) / sizeof(arr[0]);

    mini_printf("Numbers before sorting:\n");
    for (int i = 0; i < size; i++)
        mini_printf("0x%x ", arr[i]);

    rbubble_sort(arr, size);

    mini_printf("\nNumbers after sorting: \n");
    for (int i = 0; i < size; i++)
        mini_printf("0x%x ", arr[i]);

    return 0;
}