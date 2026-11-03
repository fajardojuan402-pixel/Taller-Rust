// Correccion del Experimento 3 (Java) con AtomicInteger.
// incrementAndGet() es una operacion atomica (read-modify-write indivisible),
// por lo que no hay actualizaciones perdidas: el total es SIEMPRE 400000.
import java.util.concurrent.atomic.AtomicInteger;

public class CarreraAtomic {
    static final AtomicInteger contador = new AtomicInteger(0);
    public static void main(String[] a) throws Exception {
        Thread[] ts = new Thread[4];
        for (int i = 0; i < 4; i++) {
            ts[i] = new Thread(() -> { for (int j = 0; j < 100_000; j++) contador.incrementAndGet(); });
            ts[i].start();
        }
        for (Thread t : ts) t.join();
        System.out.println(contador.get());
    }
}
