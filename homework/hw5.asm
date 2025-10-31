#include <stdio.h>

int main() {
    int AH = 28; // ширина конверта
    int AL = 14; // высота конверта

    for (int y = 0; y < AL; y++) {
        for (int x = 0; x < AH; x++) {
            if (y == 0 || y == AL - 1 || x == 0 || x == AH - 1 ||
                x == y * (AH - 1) / (AL - 1) ||
                x == (AH - 1) - y * (AH - 1) / (AL - 1))
                printf("*");
            else
                printf(" ");
        }
        printf("\n");
    }

    return 0;
}
