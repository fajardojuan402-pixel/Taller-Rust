// Experimento 2 — Puzzle A: move.
// ESPERADO: NO compila (error E0382, "borrow of moved value: `first`").
// A: move
fn main() {
    let first = String::from("Hola");
    let second = first;
    println!("{first} {second}");
}
