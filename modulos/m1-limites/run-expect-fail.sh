#!/usr/bin/env bash
# Módulo 1 — Límites y comportamiento indefinido.
# Ejecuta todos los casos y verifica que los que DEBEN fallar fallen como se espera.
# Uso: make m1   (o, dentro del contenedor: bash modulos/m1-limites/run-expect-fail.sh)
DIR="$(cd "$(dirname "$0")" && pwd)"
RAIZ="$(cd "$DIR/../.." && pwd)"
source "$RAIZ/scripts/lib.sh"
exigir_contenedor

CC="${CC:-gcc}"
OUT="$RAIZ/build/m1"
mkdir -p "$OUT"
cd "$DIR"

titulo "C — índice calculado (compilador: $CC)"
compilar "(a) -O0" "$CC" -O0 c/indice.c -o "$OUT/indice_a" &&
    ejecutar "(a) ejecución: UB, resultado NO estable" "$OUT/indice_a"
compilar "(b) -O2 -Wall -Wextra" "$CC" -O2 -Wall -Wextra c/indice.c -o "$OUT/indice_b" &&
    ejecutar "(b) ejecución: UB, resultado NO estable" "$OUT/indice_b"
compilar "(c) -g -O1 -fsanitize=address" "$CC" -g -O1 -fsanitize=address c/indice.c -o "$OUT/indice_c" &&
    esperar_fallo "(c) ejecución con ASan" "stack-buffer-overflow" "$OUT/indice_c"

titulo "C — overflow con INT_MAX y siempre_mayor (gcc y clang)"
# Se compila con ambos compiladores a propósito: gcc pliega `x + 1 > x` a 1
# en el front-end incluso con -O0, así que UBSan no ve la suma; clang sí la
# instrumenta. Compare ambos resultados: el UB no es un resultado estable.
for C in gcc clang; do
    compilar "$C -O0" "$C" -O0 c/overflow.c -o "$OUT/overflow_${C}_O0" &&
        ejecutar "$C -O0 ejecución: UB" "$OUT/overflow_${C}_O0"
    compilar "$C -O2" "$C" -O2 c/overflow.c -o "$OUT/overflow_${C}_O2" &&
        ejecutar "$C -O2 ejecución: UB (el compilador puede plegar la comparación)" "$OUT/overflow_${C}_O2"
    compilar "$C -fsanitize=undefined" "$C" -fsanitize=undefined c/overflow.c -o "$OUT/overflow_${C}_ubsan" || continue
    if [ "$C" = clang ]; then
        esperar_reporte "clang: ejecución con UBSan" "signed integer overflow" "$OUT/overflow_${C}_ubsan"
    else
        ejecutar "gcc: ejecución con UBSan (gcc ya plegó la comparación: puede no haber reporte)" \
            "$OUT/overflow_${C}_ubsan"
    fi
done

titulo "Rust — índice constante (rust_const.rs)"
# Según la versión de rustc: error del lint unconditional_panic al compilar,
# o compila y hace panic en ejecución. Ambos se aceptan como ESPERADO.
printf '\n--- compilación\n$ rustc no-compila/rust_const.rs -o %s\n' "$OUT/rust_const"
SAL=$(rustc rust/no-compila/rust_const.rs -o "$OUT/rust_const" 2>&1)
EST=$?
printf '%s\n' "$SAL"
if [ "$EST" -ne 0 ] && grep -q "unconditional_panic" <<<"$SAL"; then
    _ok "rechazado en compilación por el lint unconditional_panic"
elif [ "$EST" -eq 0 ]; then
    echo "(esta versión de rustc compiló el fragmento: se verifica el panic en ejecución)"
    esperar_fallo "ejecución" "index out of bounds" "$OUT/rust_const"
else
    _mal "falló la compilación por otro motivo (código $EST)"
fi

cd "$DIR/rust"
titulo "Rust — índice calculado (rust_dyn.rs)"
esperar_fallo "get devuelve None; [] hace panic" "index out of bounds" \
    cargo run -q --bin rust_dyn

titulo "Rust — get_unchecked fuera de rango (unsafe)"
ejecutar "debug (puede abortar por la comprobación de precondición; depende de la versión)" \
    cargo run -q --bin get_unchecked
ejecutar "--release: UB, resultado NO estable" \
    cargo run -q --release --bin get_unchecked
esperar_fallo "Miri" "Undefined Behavior" \
    cargo +nightly miri run -q --bin get_unchecked

titulo "Rust — overflow"
esperar_fallo "debug" "attempt to add with overflow" cargo run -q --bin overflow
ejecutar "--release: envuelve (overflow-checks desactivado)" cargo run -q --release --bin overflow

cd "$DIR/java"
titulo "Java — overflow"
esperar_fallo "Overflow.java" "ArithmeticException" java Overflow.java

titulo "Java — arreglo de cinco (Bounds.java, lo escribe el estudiante)"
if [ -f Bounds.java ]; then
    esperar_fallo "Bounds.java" "ArrayIndexOutOfBoundsException" java Bounds.java
else
    echo "PENDIENTE: cree modulos/m1-limites/java/Bounds.java (equivalente Java del arreglo de cinco)."
fi

resumen
