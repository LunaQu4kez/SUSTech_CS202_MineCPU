int arr[10] = {5, 4, 3, 2, 1, 0, 9, 8, 7, 6};

int main() {
    for(int i = 0; i < 10; i++) {
        for(int j = i; j < 9; j++) {
            if(arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}