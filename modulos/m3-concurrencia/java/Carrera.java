// Experimento 3 — Java: lost update.
// contador++ no es atómico (leer, sumar, escribir). En Java no es UB, pero
// el resultado queda sujeto al modelo de memoria: normalmente < 400000.
// Java: lost update
public class Carrera {
    static int contador = 0;
    public static void main(String[] a) throws Exception {
        Thread[] ts = new Thread[4];
        for (int i = 0; i < 4; i++) {
            ts[i] = new Thread(() -> { for (int j = 0; j < 100_000; j++) contador++; });
            ts[i].start();
        }
        for (Thread t : ts) t.join();
        System.out.println(contador);
    }
}
