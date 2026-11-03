# Módulo 2 — Ownership y dónde termina la garantía

**Pregunta.** ¿Qué rechaza el compilador de Rust, qué se comprueba solo en
ejecución (RefCell) y qué no lo detecta nadie (fugas, retención de objetos)?

## Antes de ejecutar: prediga y haga commit

- `rust/no-compila/a_move.rs` y `rust/no-compila/b_push_iter.rs`: ¿qué
  propiedad violan? ¿Qué habría pasado en C y en Java?
- `rust/src/bin/refcell.rs`: compila. ¿Qué ocurre al ejecutarlo y por qué?
- `java/ForEach.java`: complete el TODO (agregar un elemento dentro del
  for-each). ¿Qué detecta Java y cuándo, frente a Rust?
- `java/CacheEstatico.java`: ¿puede el GC liberar esos buffers?

## Comando

```bash
make m2
```

A mano, dentro del contenedor:

```bash
cd modulos/m2-ownership/rust
rustc no-compila/a_move.rs        # lea el mensaje completo
rustc no-compila/b_push_iter.rs
cargo run                         # RefCell
cd ../java && java ForEach.java && java -Xmx128m CacheEstatico.java
```

## Evidencia que guardar

```bash
make m2 2>&1 | tee entregas/<su-usuario>/EVIDENCIAS/m2.txt
```

Incluya los mensajes completos de los errores E0382 y E0502, el panic de
RefCell, la `ConcurrentModificationException` y la salida del caché. Sus
correcciones van en `INFORME.md` sin modificar los archivos base hasta haber
registrado el resultado original.
