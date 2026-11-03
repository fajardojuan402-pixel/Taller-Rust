// Experimento 1 — overflow de enteros en Java.
// La primera línea envuelve (semántica definida: complemento a dos).
// ESPERADO: Math.addExact lanza ArithmeticException ("integer overflow").
public class Overflow {
    public static void main(String[] args) {
        System.out.println(Integer.MAX_VALUE + 1);
        System.out.println(Math.addExact(Integer.MAX_VALUE, 1));
    }
}
