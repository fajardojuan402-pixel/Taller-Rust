// Experimento 3 — Rust: ¿seguro en memoria? ¿termina?
// ESPERADO: compila y es memory-safe, pero NO termina: t1 toma a y espera b,
// t2 toma b y espera a (deadlock). Ejecútelo SIEMPRE con timeout:
//   timeout 5 cargo run
// Rust: ¿seguro en memoria? ¿termina?
#[rustfmt::skip] // se conserva el formato exacto del documento del taller
use std::{sync::{Arc, Mutex}, thread, time::Duration};
#[rustfmt::skip]
fn main() {
    let (a, b) = (Arc::new(Mutex::new(0)), Arc::new(Mutex::new(0)));
    let (a1, b1) = (a.clone(), b.clone());
    let t1 = thread::spawn(move || {
        let _x = a1.lock().unwrap(); thread::sleep(Duration::from_millis(100));
        let _y = b1.lock().unwrap();
    });
    let t2 = thread::spawn(move || {
        let _y = b.lock().unwrap(); thread::sleep(Duration::from_millis(100));
        let _x = a.lock().unwrap();
    });
    t1.join().unwrap(); t2.join().unwrap();
}
