// Experimento 1 — Tarea propia: equivalente Java del arreglo de cinco
// elementos leido en el indice 5 (el "sexto" elemento de un arreglo de 5).
//
// A diferencia de C, Java comprueba los limites de todo acceso a un arreglo
// en tiempo de EJECUCION. No es comportamiento indefinido: el acceso invalido
// lanza una excepcion determinista.
// ESPERADO: ArrayIndexOutOfBoundsException ("Index 5 out of bounds for length 5").
public class Bounds {
    public static void main(String[] args) {
        int[] values = {10, 20, 30, 40, 50};
        int i = args.length + 5; // vale 5 sin argumentos (equivale a values[5])
        System.out.println(values[i]);
    }
}
