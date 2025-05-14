#include <stdlib.h>

int main() {
    int *x = malloc(10 * sizeof(int));
    
    // We deliberately don't free this memory to test Valgrind
    
    free(x);

    return 0;
}
