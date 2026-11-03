// Experimento 1 — Rust con unsafe: get_unchecked fuera de rango es UB.
// ESPERADO: `cargo +nightly miri run` reporta "Undefined Behavior".
// En debug (cargo run), rustc >= 1.78 incluye comprobaciones de precondición
// de unsafe y puede abortar con "unsafe precondition(s) violated".
// En --release no hay comprobación: el resultado NO es estable.
fn main() {
    let v = vec![10, 20, 30, 40, 50];
    let i = v.len();
    println!("{}", unsafe { *v.get_unchecked(i) });
}
