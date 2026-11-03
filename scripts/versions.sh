#!/usr/bin/env bash
# Imprime las versiones de todas las herramientas del laboratorio.
# Guarde esta salida en EVIDENCIAS/ (make versions > .../versions.txt).
set -u

mostrar() {
    printf '%-8s ' "$1"
    shift
    "$@" 2>&1 | head -n 1 || echo "NO DISPONIBLE"
}

echo "== Versiones del laboratorio ($(date -u +%Y-%m-%dT%H:%M:%SZ)) =="
mostrar gcc      gcc --version
mostrar clang    clang --version
mostrar rustc    rustc --version
mostrar cargo    cargo --version
mostrar nightly  rustc +nightly --version
mostrar miri     cargo +nightly miri --version
mostrar java     java -version
mostrar javac    javac -version
mostrar make     make --version
mostrar SO       sh -c '. /etc/os-release && echo "$PRETTY_NAME ($(uname -m))"'
