/* Experimento 1 — overflow de enteros con signo en C.
 * INT_MAX + 1 es comportamiento indefinido.
 * ESPERADO: con clang -fsanitize=undefined, UBSan reporta
 * "signed integer overflow". gcc puede plegar x + 1 > x a 1 incluso con -O0,
 * y entonces UBSan no ve la suma: compare ambos compiladores.
 * Ejecutar SOLO dentro del contenedor (make m1). */
#include <limits.h>
#include <stdio.h>
int siempre_mayor(int x) { return x + 1 > x; }
/* Se conserva el formato exacto del documento del taller. */
/* clang-format off */
int main(void) { printf("%d\n", siempre_mayor(INT_MAX)); return 0; }
/* clang-format on */
