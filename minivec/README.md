# minivec — Ruta D: soundness

**Pregunta.** Una API segura es *sound* si desde código seguro es imposible
provocar UB a través de ella. ¿Lo es `minivec`?

`src/lib.rs` implementa un vector de `i32` con `unsafe` interno y una API
pública segura (`new`, `push`, `get`, `pop`, `len`). Contiene un defecto de
soundness.

## Antes de ejecutar: prediga y haga commit

Lea `src/lib.rs` y sus invariantes. Prediga qué método puede violarlos desde
código seguro y qué reportaría Miri.

## Comandos

```bash
make minivec                               # cargo test + cargo +nightly miri test
```

Dentro del contenedor:

```bash
cd minivec
cargo test
cargo +nightly miri test
cargo +nightly miri test -- --include-ignored   # incluye su test de la Ruta D
```

## Tarea

1. Complete `expone_el_defecto` en `tests/api.rs` usando solo la API segura,
   hasta que `cargo +nightly miri test` reporte UB. Quite el `#[ignore]`.
2. Corrija con el cambio mínimo.
3. Documente el contrato: `# Safety` donde corresponda y un comentario
   `// SAFETY:` en cada bloque `unsafe`, explicando qué invariante lo justifica.
4. Explique por qué una ejecución limpia de Miri no demostraría soundness.

## Evidencia que guardar

La salida de Miri **antes** y **después** de la corrección, y el diff de su cambio:

```bash
cargo +nightly miri test 2>&1 | tee ../entregas/<su-usuario>/EVIDENCIAS/minivec-miri.txt
```
