#!/usr/bin/env bash
# Funciones comunes para los scripts run-expect-fail.sh.
# Cada caso muestra el comando exacto y su salida completa, para que el
# estudiante pueda copiarlos como evidencia.
set -u

FALLOS=0
# Incluye el tiempo de compilación de cargo/Miri en la primera ejecución.
TIEMPO_LIMITE="${TIEMPO_LIMITE:-180}"

# Los programas C con UB o data races solo se ejecutan dentro del contenedor.
exigir_contenedor() {
    if [ "${LAB_IN_CONTAINER:-0}" != "1" ]; then
        echo "ERROR: ejecute esto dentro del contenedor (make m1 / make m2 / make m3)." >&2
        exit 2
    fi
}

titulo() { printf '\n==================== %s ====================\n' "$*"; }

_cabecera() { printf '\n--- %s\n$ %s\n' "$1" "$2"; }

_ok() { printf '>> ESPERADO: %s\n' "$*"; }

_mal() {
    printf '>> NO ESPERADO: %s\n' "$*"
    FALLOS=$((FALLOS + 1))
}

# ejecutar "descripción" comando...
# Caso informativo: muestra salida y código de salida, no verifica nada.
ejecutar() {
    local desc="$1"
    shift
    _cabecera "$desc" "$*"
    timeout "$TIEMPO_LIMITE" "$@" 2>&1
    printf '>> código de salida: %s (informativo, no se verifica)\n' "$?"
}

# esperar_fallo "descripción" "regex" comando...
# El comando DEBE terminar con código distinto de 0 y su salida debe
# contener la expresión regular (error de compilación, panic, sanitizer...).
esperar_fallo() {
    local desc="$1" patron="$2" salida estado
    shift 2
    _cabecera "$desc" "$*"
    salida=$(timeout "$TIEMPO_LIMITE" "$@" 2>&1)
    estado=$?
    printf '%s\n' "$salida"
    if [ "$estado" -eq 124 ]; then
        _mal "se agotó el tiempo (${TIEMPO_LIMITE}s) y se esperaba un fallo"
    elif [ "$estado" -ne 0 ] && grep -Eq "$patron" <<<"$salida"; then
        _ok "falló como se esperaba (código $estado; coincide /$patron/)"
    else
        _mal "código $estado; se esperaba fallo con /$patron/"
    fi
}

# esperar_reporte "descripción" "regex" comando...
# Para sanitizers que reportan sin abortar (UBSan por defecto): solo se
# exige que la salida contenga el reporte.
esperar_reporte() {
    local desc="$1" patron="$2" salida estado
    shift 2
    _cabecera "$desc" "$*"
    salida=$(timeout "$TIEMPO_LIMITE" "$@" 2>&1)
    estado=$?
    printf '%s\n' "$salida"
    if grep -Eq "$patron" <<<"$salida"; then
        _ok "se generó el reporte esperado (código $estado; coincide /$patron/)"
    else
        _mal "no apareció el reporte /$patron/ (código $estado)"
    fi
}

# esperar_timeout "descripción" segundos comando...
# El programa NO debe terminar (deadlock): se espera código 124 de timeout.
esperar_timeout() {
    local desc="$1" seg="$2" estado
    shift 2
    _cabecera "$desc" "timeout $seg $*"
    timeout "$seg" "$@" 2>&1
    estado=$?
    if [ "$estado" -eq 124 ]; then
        _ok "no terminó en ${seg}s y timeout lo detuvo (código 124): bloqueo"
    else
        _mal "terminó con código $estado; se esperaba un bloqueo"
    fi
}

# compilar "descripción" comando...  (debe compilar; muestra warnings)
compilar() {
    local desc="$1" salida estado
    shift
    _cabecera "$desc" "$*"
    salida=$("$@" 2>&1)
    estado=$?
    [ -n "$salida" ] && printf '%s\n' "$salida" || echo "(sin mensajes del compilador)"
    if [ "$estado" -ne 0 ]; then
        _mal "no compiló (código $estado)"
        return 1
    fi
}

resumen() {
    echo
    if [ "$FALLOS" -eq 0 ]; then
        echo "RESUMEN: todos los casos se comportaron como se esperaba."
    else
        echo "RESUMEN: $FALLOS caso(s) NO se comportaron como se esperaba." >&2
    fi
    exit "$FALLOS"
}
