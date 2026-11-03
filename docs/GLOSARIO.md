# Glosario

Definiciones operativas tomadas de la sección 3 del documento del taller.

| Concepto | Definición operativa | Por qué importa |
| --- | --- | --- |
| Out-of-bounds | Leer o escribir fuera de los límites válidos de un arreglo o buffer. | UB en C; Rust y Java lo comprueban en el acceso seguro habitual. |
| Comportamiento indefinido (UB) | El estándar no define qué ocurre; el compilador puede asumir que nunca sucede. | Puede cambiar con la optimización; no es "un error que falla visiblemente". |
| Data race | Accesos concurrentes conflictivos a una ubicación, al menos uno de escritura, sin sincronización. | UB en C y en `unsafe`; en Java no es UB, pero el resultado queda sujeto al modelo de memoria. |
| Ownership y borrowing | Cada valor tiene un propietario; los préstamos distinguen referencias compartidas y mutables. | Restringe aliasing con mutación en tiempo de compilación. |
| Mutabilidad interior | `RefCell`, `Mutex`: mutar mediante una referencia compartida con comprobación en ejecución. | Mueve parte del borrow checking al runtime. |
| `Send` y `Sync` | Rasgos que indican si un tipo puede moverse o compartirse entre hilos. | Permiten al compilador rechazar estado compartido inseguro. |
| Garbage collection | El runtime recupera objetos inalcanzables. | No evita errores lógicos, retención de referencias ni deadlocks. |
| Soundness | Una API segura es sound si desde código seguro es imposible provocar UB a través de ella. | Criterio de calidad de toda abstracción con `unsafe` interno. |

## Tipos de resultado que debe distinguir

| Resultado | Cuándo ocurre | Ejemplo del laboratorio |
| --- | --- | --- |
| Error de compilación | El compilador rechaza el programa. | E0382 (move), E0502, E0277 (`Rc` no es `Send`) |
| Lint | Un análisis del compilador; puede ser deny por defecto. | `unconditional_panic` en `rust_const.rs` |
| Panic | Comprobación dinámica de Rust que detiene el hilo. | `v[i]` fuera de rango, `RefCell` ya prestado |
| Excepción | Comprobación dinámica de Java, capturable. | `ArithmeticException`, `ConcurrentModificationException` |
| Reporte de sanitizer | Instrumentación que detecta un defecto en *esa* ejecución. | ASan, UBSan, TSan |
| Reporte de Miri | Intérprete que detecta UB en *esa* ejecución de Rust. | `get_unchecked`, `minivec` |
| Comportamiento indefinido | Nada garantiza el resultado; puede parecer correcto. | `indice.c` con `-O0` o `-O2` |
