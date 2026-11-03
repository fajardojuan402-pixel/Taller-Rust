# Cómo sustentar las conclusiones

Cada afirmación comparativa debe apoyarse en un resultado del laboratorio o en
el mecanismo del lenguaje. Evite absolutos como "Rust nunca falla" o "C siempre
es más rápido". Tabla tomada de la sección 12 del documento del taller.

| Afirmación débil | Versión técnicamente defendible |
| --- | --- |
| "Rust detecta todos los errores antes de ejecutar." | "El compilador de Rust verifica varias propiedades de memoria en código seguro; otros errores, como índices dinámicos inválidos o violaciones de RefCell, se detectan en ejecución." |
| "Java es memory-safe, así que no tiene errores." | "Java ofrece gestión automática de memoria y comprobación de límites, pero siguen siendo posibles errores lógicos, retención de objetos, data races y deadlocks." |
| "C es inseguro y no sirve." | "C ofrece control de bajo nivel, pero la seguridad depende en mayor medida del código, las convenciones y las herramientas de análisis." |
| "Con sanitizer no falló, entonces es seguro." | "Una ejecución sin detección no demuestra ausencia de defectos; importan la cobertura, la configuración y los análisis complementarios." |
| "Miri no reportó nada, mi unsafe es correcto." | "Miri detecta UB en las ejecuciones realizadas; la soundness exige además razonar sobre invariantes." |

## Criterio de profundidad esperado

Una respuesta completa separa:

1. la propiedad deseada,
2. el mecanismo que la impone o comprueba,
3. el momento de detección,
4. el costo o la limitación, y
5. la evidencia que sostiene la conclusión.
