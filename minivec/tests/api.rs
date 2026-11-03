//! Tests de la API pública de minivec. Ejecutar con:
//!   cargo test
//!   cargo +nightly miri test

use minivec::MiniVec;

#[test]
fn vacio_al_crear() {
    let v = MiniVec::new();
    assert_eq!(v.len(), 0);
    assert!(v.is_empty());
}

#[test]
fn push_y_get() {
    let mut v = MiniVec::new();
    for i in 0..10 {
        v.push(i * 10);
    }
    assert_eq!(v.len(), 10);
    assert_eq!(v.get(0), Some(&0));
    assert_eq!(v.get(9), Some(&90));
}

#[test]
fn pop_en_orden_inverso() {
    let mut v = MiniVec::new();
    v.push(1);
    v.push(2);
    assert_eq!(v.pop(), Some(2));
    assert_eq!(v.pop(), Some(1));
    assert_eq!(v.pop(), None);
}

/// Ruta D. Escriba aquí un test que use SOLO la API pública segura y exponga
/// el defecto de soundness con `cargo +nightly miri test -- --include-ignored`.
/// Cuando lo tenga, quite el `#[ignore]`.
#[test]
fn expone_el_defecto() {
    let mut v = MiniVec::new();
    v.push(1);
    v.push(2);
    // len == 2; el ultimo indice valido es 1. get(len) NO deberia leer nada.
    // Con el bug (indice <= len), get(2) lee la posicion 2, que no esta
    // inicializada: Miri lo reporta como Undefined Behavior.
    let fuera = v.get(v.len()); // get(2)
    assert_eq!(fuera, None);
}
