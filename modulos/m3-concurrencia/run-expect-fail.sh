#!/usr/bin/env bash
# Módulo 3 — Concurrencia: seguridad no significa ausencia de bloqueos.
# Uso: make m3   (o, dentro del contenedor: bash modulos/m3-concurrencia/run-expect-fail.sh)
DIR="$(cd "$(dirname "$0")" && pwd)"
RAIZ="$(cd "$DIR/../.." && pwd)"
source "$RAIZ/scripts/lib.sh"
exigir_contenedor

CC="${CC:-gcc}"
OUT="$RAIZ/build/m3"
mkdir -p "$OUT"
EJECUCIONES="${EJECUCIONES:-5}"

cd "$DIR/java"
titulo "Java — lost update (Carrera.java, $EJECUCIONES ejecuciones)"
javac -d "$OUT" Carrera.java || { _mal "Carrera.java no compiló"; resumen; }
VALORES=()
for n in $(seq "$EJECUCIONES"); do
    V=$(timeout "$TIEMPO_LIMITE" java -cp "$OUT" Carrera 2>&1)
    echo "ejecución $n: $V"
    VALORES+=("$V")
done
PERDIDAS=0
for V in "${VALORES[@]}"; do [ "$V" != "400000" ] && PERDIDAS=$((PERDIDAS + 1)); done
if [ "$PERDIDAS" -gt 0 ]; then
    _ok "se perdieron incrementos en $PERDIDAS de $EJECUCIONES ejecuciones (data race bajo el JMM, no UB)"
else
    echo ">> ESPERADO (posible): ninguna ejecución perdió incrementos; eso NO prueba que el código sea correcto."
fi

cd "$DIR/c"
titulo "C — data race con pthread (compilador: $CC, solo con TSan)"
# En kernels recientes (vm.mmap_rnd_bits=32, p. ej. WSL2 o runners de CI) TSan
# termina con "unexpected memory mapping" si ASLR está activo. setarch -R lo
# desactiva solo para este proceso, pero requiere que el contenedor permita
# la llamada personality(ADDR_NO_RANDOMIZE).
SIN_ASLR=()
if setarch "$(uname -m)" -R true 2>/dev/null; then
    SIN_ASLR=(setarch "$(uname -m)" -R)
else
    echo "AVISO: este contenedor no permite desactivar ASLR; TSan puede fallar con"
    echo "       'unexpected memory mapping'. Vea modulos/m3-concurrencia/README.md."
fi
compilar "-g -O1 -fsanitize=thread" "$CC" -g -O1 -fsanitize=thread -pthread carrera.c -o "$OUT/carrera_tsan" &&
    esperar_fallo "ejecución con TSan (data race: ESPERADO)" "ThreadSanitizer: data race" \
        "${SIN_ASLR[@]}" "$OUT/carrera_tsan"

cd "$DIR/rust"
titulo "Rust — Rc entre hilos"
esperar_fallo "rc_hilos.rs (Rc no es Send)" "E0277" \
    rustc --edition 2021 no-compila/rc_hilos.rs -o "$OUT/rc_hilos"

titulo "Rust — dos Mutex adquiridos en orden opuesto"
cargo build -q --bin deadlock || _mal "deadlock.rs no compiló"
esperar_timeout "deadlock (ESPERADO: no termina)" 5 cargo run -q --bin deadlock

resumen
