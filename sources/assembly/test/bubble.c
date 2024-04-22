int main() {
    int a[5] = {5, 4, 3, 2, 1}, n = 5;
    for(int i = n - 1; i > 0; i--) {
        for(int j = 0; j < i; j++) {
            if(a[j] > a[j + 1]) {
                int t = a[j];
                a[j] = a[j + 1];
                a[j + 1] = t;
            }
        }
    }
}