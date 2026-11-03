// Experimento 2 — Retención de objetos en Java: un caché estático que nunca se vacía.
// El GC solo recupera objetos INALCANZABLES; todo lo que el caché referencia
// sigue vivo aunque el programa ya no lo use. No es un acceso inválido: es una fuga lógica.
// ESPERADO: con -Xmx128m termina en OutOfMemoryError ("Java heap space").
import java.util.ArrayList;
import java.util.List;

public class CacheEstatico {
    static final List<byte[]> CACHE = new ArrayList<>();

    static void procesar(int peticion) {
        byte[] buffer = new byte[1024 * 1024]; // 1 MiB por petición
        CACHE.add(buffer); // "por si se vuelve a necesitar": nunca se elimina
    }

    public static void main(String[] args) {
        Runtime rt = Runtime.getRuntime();
        for (int i = 1; i <= 1000; i++) {
            procesar(i);
            if (i % 8 == 0) {
                System.gc();
                long usadoMiB = (rt.totalMemory() - rt.freeMemory()) / (1024 * 1024);
                System.out.println("peticiones=" + i + " heap usado tras GC=" + usadoMiB + " MiB");
            }
        }
    }
}
