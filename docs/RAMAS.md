# Mantenimiento de las ramas

| Rama | Contenido | Dónde vive |
| --- | --- | --- |
| `main` | Material para estudiantes. **Nunca** contiene `instructor/`. | Repositorio público del curso |
| `solutions` | `main` + `instructor/` (soluciones, notas de verificación). | Solo local o en un repositorio privado |

Una rama de un repositorio público es visible para cualquiera que pueda leerlo:
no publique `solutions` en el remoto de los estudiantes.

## Flujo de trabajo

1. Todo cambio al material de estudiantes se hace en `main`.
2. Luego se integra en `solutions`:

   ```bash
   git switch solutions
   git merge main          # instructor/ no existe en main: no hay conflictos
   ```

3. Los cambios de soluciones se hacen solo en `solutions`, dentro de `instructor/`.
4. Nunca fusione `solutions` en `main`. Antes de publicar, verifique:

   ```bash
   git switch main
   git ls-tree -r --name-only HEAD | grep '^instructor/' && echo "ERROR: instructor/ en main"
   ```

5. Para respaldar `solutions` en un repositorio privado:

   ```bash
   git remote add privado <URL-PRIVADA>
   git push privado solutions
   ```

Si cambia la versión de una herramienta en el `Dockerfile`, vuelva a ejecutar
`make test` en ambas ramas y actualice las notas de verificación del instructor.
