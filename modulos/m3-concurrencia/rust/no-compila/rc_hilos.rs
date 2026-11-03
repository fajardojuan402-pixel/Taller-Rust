// Experimento 3 — Rust: Rc entre hilos.
// ESPERADO: NO compila (error E0277: `Rc<i32>` cannot be sent between threads
// safely). Rc no implementa Send: su contador de referencias no es atómico.
// Rust: Rc entre hilos
use std::{rc::Rc, thread};
fn main() {
    let c = Rc::new(0);
    let c2 = Rc::clone(&c);
    thread::spawn(move || println!("{}", c2)).join().unwrap();
}
