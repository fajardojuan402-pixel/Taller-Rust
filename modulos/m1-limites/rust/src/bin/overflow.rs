// Experimento 1 — overflow de enteros en Rust.
// ESPERADO: en debug hace panic "attempt to add with overflow";
// en --release (overflow-checks desactivado) envuelve a -2147483648.
fn main() {
    let x: i32 = (i32::MAX - 1) + std::env::args().count() as i32;
    println!("{}", x + 1);
}
