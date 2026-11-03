#!/usr/bin/env bash
# Módulo 2 — Ownership y dónde termina la garantía.
# Uso: make m2   (o, dentro del contenedor: bash modulos/m2-ownership/run-expect-fail.sh)
DIR="$(cd "$(dirname "$0")" && pwd)"
RAIZ="$(cd "$DIR/../.." && pwd)"
source "$RAIZ/scripts/lib.sh"
exigir_contenedor

OUT="$RAIZ/build/m2"
mkdir -p "$OUT"
cd "$DIR/rust"

titulo "Rust — puzzles que NO compilan"
esperar_fallo "Puzzle A: move" "E0382" \
    rustc --edition 2021 no-compila/a_move.rs -o "$OUT/a_move"
esperar_fallo "Puzzle B: push mientras se itera" "E0502" \
    rustc --edition 2021 no-compila/b_push_iter.rs -o "$OUT/b_push_iter"

titulo "Rust — RefCell (compila; comprobación en ejecución)"
esperar_fallo "dos borrow_mut simultáneos" "already (mutably )?borrowed|BorrowMutError" \
    cargo run -q --bin refcell

cd "$DIR/java"
titulo "Java — for-each sobre ArrayList (esqueleto con TODO)"
SAL=$(timeout "$TIEMPO_LIMITE" java ForEach.java 2>&1)
EST=$?
printf '\n--- ForEach.java\n$ java ForEach.java\n%s\n' "$SAL"
if grep -q "ConcurrentModificationException" <<<"$SAL"; then
    _ok "ConcurrentModificationException detectada en ejecución (código $EST)"
else
    echo "PENDIENTE: complete el TODO de java/ForEach.java y vuelva a ejecutar (código $EST)."
fi

titulo "Java — caché estático que retiene objetos"
esperar_fallo "CacheEstatico.java con heap de 128 MiB" "OutOfMemoryError" \
    java -Xmx128m CacheEstatico.java

resumen
