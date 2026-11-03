/* Experimento 1 — C, índice calculado.
 * Lee el sexto elemento de un arreglo de cinco: comportamiento indefinido.
 * ESPERADO: con -fsanitize=address, ASan reporta stack-buffer-overflow.
 * Con -O0 y -O2 el resultado NO es estable: no lo trate como un dato fiable.
 * Ejecutar SOLO dentro del contenedor (make m1). */
#include <stdio.h>
int main(int argc, char **argv) {
    (void)argv;
    int values[5] = {10, 20, 30, 40, 50};
    int i = argc + 4;                 /* vale 5 sin argumentos */
    printf("%d\n", values[i]);
    return 0;
}
