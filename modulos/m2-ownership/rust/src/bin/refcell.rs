// Experimento 2 — RefCell: compila, pero el préstamo se comprueba en ejecución.
// ESPERADO: panic "already borrowed" (BorrowMutError) en el segundo borrow_mut.
use std::cell::RefCell;
use std::rc::Rc;

fn main() {
    let c = Rc::new(RefCell::new(vec![1]));
    let r1 = c.borrow_mut();
    let r2 = c.borrow_mut();
    println!("{} {}", r1.len(), r2.len());
}
