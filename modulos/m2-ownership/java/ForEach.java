// Experimento 2 — Esqueleto: agregar un elemento a un ArrayList dentro de un for-each.
// Es el equivalente Java del puzzle B de Rust.
// ESPERADO (tras completar el TODO): ConcurrentModificationException en ejecución.
import java.util.ArrayList;
import java.util.List;

public class ForEach {
    public static void main(String[] args) {
        List<Integer> v = new ArrayList<>(List.of(1, 2, 3));
        for (Integer x : v) {
            // Completado: mutar la coleccion mientras se itera.
            // ESPERADO: ConcurrentModificationException en tiempo de ejecucion.
            if (x == 2) {
                v.add(4);
            }
        }
        System.out.println(v);
    }
}
