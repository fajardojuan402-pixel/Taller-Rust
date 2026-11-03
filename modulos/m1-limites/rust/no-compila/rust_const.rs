// Experimento 1 — Rust, índice constante sobre un arreglo.
// ESPERADO: con rustc reciente NO compila: el lint `unconditional_panic`
// (deny por defecto) detecta en compilación que v[5] siempre hará panic.
// Con versiones antiguas de rustc puede compilar y hacer panic en ejecución
// ("index out of bounds"). El script acepta ambos resultados.
// rust_const.rs
#[rustfmt::skip] // se conserva el formato exacto del documento del taller
fn main() { let v = [10, 20, 30, 40, 50]; println!("{}", v[5]); }
