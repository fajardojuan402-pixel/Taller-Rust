// Correccion del Experimento 3 (Rust): romper el deadlock con un orden global
// de adquisicion de los mutex. Ambos hilos toman SIEMPRE primero `a` y luego
// `b`, de modo que no puede formarse una espera circular. Ahora SI termina.
use std::{sync::{Arc, Mutex}, thread, time::Duration};

fn main() {
    let (a, b) = (Arc::new(Mutex::new(0)), Arc::new(Mutex::new(0)));
    let (a1, b1) = (a.clone(), b.clone());
    let t1 = thread::spawn(move || {
        let _x = a1.lock().unwrap();
        thread::sleep(Duration::from_millis(100));
        let _y = b1.lock().unwrap();
    });
    let t2 = thread::spawn(move || {
        let _x = a.lock().unwrap(); // mismo orden global: a antes que b
        thread::sleep(Duration::from_millis(100));
        let _y = b.lock().unwrap();
    });
    t1.join().unwrap();
    t2.join().unwrap();
    println!("terminado sin deadlock");
}
