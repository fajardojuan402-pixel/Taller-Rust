// Experimento 2 — Puzzle B: mutar una colección mientras se itera.
// ESPERADO: NO compila (error E0502, préstamo mutable mientras existe uno compartido).
// B: mutar una colección mientras se itera
#[rustfmt::skip] // se conserva el formato exacto del documento del taller
fn main() {
    let mut v = vec![1, 2, 3];
    for x in &v {
        if *x == 2 { v.push(4); }
    }
}
