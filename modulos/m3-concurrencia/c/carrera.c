/* Experimento 3 — equivalente en C (pthread) de Carrera.java.
 * Cuatro hilos incrementan un int compartido sin sincronización: data race,
 * que en C es comportamiento indefinido.
 * ESPERADO: con -fsanitize=thread, TSan reporta
 * "WARNING: ThreadSanitizer: data race".
 * Ejecutar SOLO dentro del contenedor y con TSan (make m3). */
#include <pthread.h>
#include <stdio.h>

static int contador = 0;

static void *trabajar(void *arg) {
    (void)arg;
    for (int j = 0; j < 100000; j++) contador++;
    return NULL;
}

int main(void) {
    pthread_t ts[4];
    for (int i = 0; i < 4; i++) pthread_create(&ts[i], NULL, trabajar, NULL);
    for (int i = 0; i < 4; i++) pthread_join(ts[i], NULL);
    printf("%d\n", contador);
    return 0;
}
