# ¿Quién protege la memoria?

Laboratorio avanzado comparativo de C, Rust y Java. Trabajo **individual** de
40 minutos.

La guía oficial del taller es
[docs/Taller_Avanzado_Memoria_C_Rust_Java.docx](docs/Taller_Avanzado_Memoria_C_Rust_Java.docx).
Es la fuente de verdad: los fragmentos de código, nombres de archivo y comandos
de este repositorio coinciden con ella.

## Objetivo

Responder con evidencia observable a la pregunta central:

> ¿Qué garantías ofrece cada modelo de gestión de memoria, qué costos
> introduce y qué riesgos permanecen incluso cuando el lenguaje se considera
> memory-safe?

Se distinguen garantías estáticas de comprobaciones dinámicas, se ubica dónde
terminan las garantías (RefCell, `unsafe`) y se separan memory safety, thread
safety y correctness. Se trabaja con programas pequeños y controlados: solo
detección y corrección, nunca explotación.

## Inicio rápido

Requisitos en el anfitrión: `git`, `make` y Docker.

```bash
git clone <URL-DEL-REPOSITORIO> && cd <repositorio>
make setup      # construye el contenedor con las herramientas
make versions   # guarde esta salida como evidencia
make m1         # módulos m1, m2 y m3 disponibles por separado
```

También puede abrir el repositorio en VS Code con **Dev Containers**
(`.devcontainer/`); dentro del contenedor los mismos objetivos de `make`
se ejecutan directamente.

| Objetivo | Qué hace |
| --- | --- |
| `make setup` | Construye la imagen `lab-memoria:1.0` |
| `make versions` | Imprime gcc, clang, rustc, cargo, Miri y Java |
| `make m1` | [Límites y comportamiento indefinido](modulos/m1-limites/README.md) |
| `make m2` | [Ownership y dónde termina la garantía](modulos/m2-ownership/README.md) |
| `make m3` | [Concurrencia](modulos/m3-concurrencia/README.md) |
| `make minivec` | [Ruta D: soundness](minivec/README.md) (`cargo test` + Miri) |
| `make test` | Todo lo anterior |
| `make clean` | Borra artefactos de compilación |

Cada módulo se ejecuta de forma aislada en un contenedor efímero. Los casos
que **deben** fallar (no compilar, panic, reporte de sanitizer, timeout) están
marcados con `ESPERADO:` en el código y los verifica `run-expect-fail.sh`.

## Reglas

1. **Trabajo individual.** Las evidencias, el análisis y la entrega deben ser propios.
2. **Prediga antes de ejecutar.** Registre su predicción en `INFORME.md` y
   haga commit **antes** de correr cada caso.
3. **Todo dentro del contenedor.** Los programas C con accesos inválidos, UB o
   data races se ejecutan solo dentro del contenedor y con sanitizers, nunca en
   su equipo anfitrión.
4. **No modifique los ejemplos base** antes de registrar el resultado original.
   Toda corrección debe explicar qué propiedad corrige, no solo "hacer que compile".
5. Una conclusión sin evidencia no recibe puntaje completo.

## Cómo entregar

```bash
cp -r entregas/PLANTILLA entregas/<su-usuario>
# 1. Escriba sus predicciones en entregas/<su-usuario>/INFORME.md y haga commit.
# 2. Ejecute y guarde evidencias:
make versions > entregas/<su-usuario>/EVIDENCIAS/versions.txt
make m1 2>&1 | tee entregas/<su-usuario>/EVIDENCIAS/m1.txt
# 3. Complete el informe y la lista de verificación (CHECKLIST.md).
```

La entrega debe permitir que otra persona reproduzca el razonamiento: indique
siempre el comando exacto con el que obtuvo cada resultado.

## Material de apoyo

- [Glosario](docs/GLOSARIO.md)
- [Afirmación débil vs. defendible](docs/AFIRMACIONES.md)
