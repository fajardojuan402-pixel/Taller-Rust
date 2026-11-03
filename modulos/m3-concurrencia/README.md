# Módulo 3 — Concurrencia: seguridad no significa ausencia de bloqueos

**Pregunta.** Para cada programa: ¿hay data race, deadlock, error lógico o
ninguno? ¿Qué lo detecta: el compilador, un sanitizer, un test o nada?

## Antes de ejecutar: prediga y haga commit

- `java/Carrera.java`: ¿qué valores imprimirá en varias ejecuciones?
- `c/carrera.c` (el mismo programa con pthread): ¿qué reporta TSan? ¿Por qué
  en C la data race es UB y en Java no, aunque el resultado sea igual de incorrecto?
- `rust/no-compila/rc_hilos.rs`: ¿compila? ¿Qué rasgo falta?
- `rust/src/bin/deadlock.rs`: ¿es seguro en memoria? ¿termina?

## Comando

```bash
make m3
```

A mano, dentro del contenedor:

```bash
cd modulos/m3-concurrencia
for i in 1 2 3 4 5; do java java/Carrera.java; done
gcc -g -O1 -fsanitize=thread -pthread c/carrera.c -o /tmp/carrera && /tmp/carrera
rustc rust/no-compila/rc_hilos.rs
cd rust && timeout 5 cargo run; echo "código: $?"   # 124 = lo detuvo timeout
```

El deadlock se ejecuta **siempre** con `timeout`. El código 124 es el
resultado esperado.

## Evidencia que guardar

```bash
make m3 2>&1 | tee entregas/<su-usuario>/EVIDENCIAS/m3.txt
```

Registre la dispersión de valores de `Carrera.java` y su corrección con
`AtomicInteger`, el reporte completo de TSan, el error E0277 y la corrección
del deadlock con un orden global de adquisición.
