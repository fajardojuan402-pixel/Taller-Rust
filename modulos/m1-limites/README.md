# Módulo 1 — Límites y comportamiento indefinido

**Pregunta.** ¿Qué ocurre al leer el sexto elemento de un arreglo de cinco y
cómo cambia según el lenguaje, el tipo de índice y las herramientas activas?
¿Qué semántica de overflow elige cada lenguaje?

## Antes de ejecutar: prediga y haga commit

Para cada caso de la tabla del Experimento 1 en `INFORME.md`, prediga si se
detecta **al compilar**, **al ejecutar** o si **puede no detectarse**:

- C `c/indice.c` en (a) `-O0`, (b) `-O2 -Wall -Wextra`, (c) `-g -O1 -fsanitize=address`.
- C `c/overflow.c` con `-O0`, `-O2` y `-fsanitize=undefined`, con gcc **y** clang
  (¿por qué podrían diferir?).
- Rust `rust/no-compila/rust_const.rs` (índice constante) y `rust/src/bin/rust_dyn.rs` (`get` y `[]`).
- Rust `rust/src/bin/get_unchecked.rs` en debug, `--release` y Miri.
- Rust `rust/src/bin/overflow.rs` en debug y `--release`.
- Java `java/Overflow.java` y su propio `java/Bounds.java`.

## Comando

```bash
make m1
```

Dentro del contenedor también puede ejecutar cada caso a mano, por ejemplo:

```bash
cd modulos/m1-limites/rust
cargo run                     # get_unchecked (binario por defecto)
cargo run --release
cargo +nightly miri run
cargo run --bin rust_dyn
cd ../java && java Overflow.java
```

Para comparar compiladores de C (gcc por defecto): `make m1 CC=clang`.

## Tarea propia

Escriba `java/Bounds.java`, el equivalente Java del arreglo de cinco
elementos leído en el índice 5. El script lo ejecuta si existe.

## Evidencia que guardar

```bash
make m1 2>&1 | tee entregas/<su-usuario>/EVIDENCIAS/m1.txt
```

Incluya: warnings de cada configuración de C, el reporte de ASan y UBSan, el
error o panic de `rust_const.rs`, la salida de Miri y las excepciones de Java.
Recuerde: el resultado de (a) y (b) es comportamiento indefinido, no un dato estable.
