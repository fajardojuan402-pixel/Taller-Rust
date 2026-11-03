// Experimento 1 — Rust, índice calculado en ejecución.
// ESPERADO: v.get(i) imprime None; v[i] hace panic "index out of bounds".
// rust_dyn.rs
#[rustfmt::skip] // se conserva el formato exacto del documento del taller
fn main() {
    let v = vec![10, 20, 30, 40, 50];
    let i = std::env::args().count() + 4;   // 5 sin argumentos
    println!("{:?}", v.get(i));
    println!("{}", v[i]);
}
