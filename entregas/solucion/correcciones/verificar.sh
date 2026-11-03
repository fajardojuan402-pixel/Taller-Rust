#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
echo "== CarreraAtomic (3 ejecuciones, debe dar 400000) =="
for i in 1 2 3; do java CarreraAtomic.java; done
echo "== deadlock_fix (debe terminar, orden global de locks) =="
rustc --edition 2021 deadlock_fix.rs -o /tmp/deadlock_fix
set +e
timeout 5 /tmp/deadlock_fix
echo "deadlock_fix exit: $?"
