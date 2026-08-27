# TRABAJO_REMOTO.md — Cómo trabajar en ZR App desde el teléfono

Este archivo es para cuando estás de viaje y la PC de la academia está apagada.
Todo lo que aquí se describe funciona desde un navegador de teléfono.

**Regla de oro: lo que no esté subido a GitHub, no existe para el agente de la nube.**
El agente que corre en claude.ai/code no ve `C:\Dev\ZR App`. Ve el repositorio
`guayamuripm-boop/zrapp` y nada más. Antes de salir de viaje, sube lo que tengas
pendiente.

---

## 0. Los dos pasos que solo puedes dar tú

Ambos se hacen **una sola vez**, y ambos se pueden hacer desde el teléfono.
Hasta que estén hechos, trabajar de viaje funciona pero sin red de seguridad.

### 0.1 🔴 Activar el CI — 30 segundos

El flujo está escrito y verificado, pero lleva desde el 11 de agosto de 2026 sin
poder subirse: GitHub rechaza el push porque el token no tiene permiso `workflow`.
El mensaje exacto es:

```
refusing to allow a Personal Access Token to create or update workflow
`.github/workflows/ci.yml` without `workflow` scope
```

**Desde el teléfono, sin tocar el token:**

1. Abre `github.com/guayamuripm-boop/zrapp`.
2. *Add file › Create new file*.
3. Nombre del archivo: `.github/workflows/ci.yml`
4. Pega el contenido íntegro de `.github/ci-pendiente.yml`.
5. *Commit*.
6. Borra `.github/ci-pendiente.yml`, que ya queda duplicado.

**La alternativa**, si prefieres arreglarlo de raíz: dale el permiso `workflow`
al token en `github.com/settings/tokens`. Después, desde la PC, un `git mv` basta.

### 0.2 🟠 Conectar Vercel al repositorio

Entra a vercel.com, *Add New Project*, importas `guayamuripm-boop/zrapp`, autorizas.

Desde ese momento cada merge a `main` despliega solo. No hay un botón de
«desplegar» aparte: **mezclar el PR es desplegar.**

Mientras no exista `package.json`, Vercel no tiene una app Next.js que construir.
Conectarlo ya de todos modos tiene sentido: el día que el técnico suba la
aplicación, el despliegue está enchufado y no hay que acordarse de nada.

---

## 1. El ciclo completo, en cinco pasos

```
  hablas la tarea  →  el agente abre un PR  →  el CI lo verifica
                                   ↓
                        lo lees  →  lo mezclas  →  se despliega
```

1. **Abres** claude.ai/code en el teléfono y eliges el repositorio `zrapp`.
2. **Dictas la tarea.** Escribir con el pulgar es un castigo; usa el micrófono.
   Le hablas en prosa, no en sintaxis, así que el dictado funciona bien.
3. **El agente trabaja** en la nube y abre un Pull Request cuando termina.
4. **El CI corre solo** sobre ese PR (ver §3). Si sale en rojo, no lo mezcles.
5. **Mezclas el PR** desde la web de GitHub. Un botón.

No necesitas terminal, ni Git, ni la PC.

---

## 2. Cómo se le habla al agente desde el teléfono

El agente arranca en frío: no recuerda ninguna conversación anterior. Lo que sí
lee siempre es `CLAUDE.md`, y desde ahí llega al resto. Aprovéchalo: en vez de
explicarle el proyecto, **mándalo al archivo**.

Mal (obliga al agente a adivinar):

> «Agrégale a la app la pantalla donde el estudiante ve lo que domina.»

Bien (el agente sabe exactamente dónde mirar):

> «Lee `fase0/01_ENTREGABLE.md` y `spec/04_PANTALLAS.md`. Implementa el mapa de
> dominio tal como está descrito ahí. Respeta las diez reglas de `CLAUDE.md`.
> Si algo no está especificado, detente y pregúntame en vez de inventarlo.»

Tres frases que conviene repetir en casi toda tarea desde el teléfono, porque no
vas a estar revisando el detalle:

- «Si algo no está especificado, **pregunta**, no inventes.»
- «No construyas nada de Fase 2 ni Fase 3.»
- «Si tocas la base, la migración es la **034 o posterior**, nunca una 001-033.»

### Tareas que salen bien desde el teléfono

- Redactar y corregir documentación (`spec/`, `plan/`, `fase0/`, `docs/`).
- Cambiar textos, etiquetas y contenido del prototipo HTML.
- Escribir migraciones SQL nuevas y sus políticas de RLS.
- Escribir Edge Functions.
- Revisar un PR que dejaste abierto y pedir ajustes.

### Tareas que conviene dejar para la PC

- Cualquier cosa que necesites **ver funcionando** antes de aprobar.
- Ajustes finos de diseño visual del prototipo, donde el ojo decide.
- Depurar algo que solo falla contra la base real de `zr-prod`.

---

## 3. Qué te protege mientras no estás mirando

Una vez hecho el §0.1, el CI corre en cada PR contra `main`. Hoy verifica cuatro
cosas, todas baratas y todas reales:

| Comprobación | Por qué existe |
|---|---|
| Ninguna clave `service_role` en el repositorio | Esa clave se salta RLS y abre toda la base |
| Ninguna migración 001-033 de vuelta | Están superadas; `zr-prod` ya va por la 033 |
| Toda migración que crea tabla habilita RLS | Es la regla 1 de `CLAUDE.md` |
| Ningún enlace roto en la documentación | Un enlace roto manda al siguiente agente a un archivo que no está |

Las cuatro se verificaron en verde contra el estado actual del repositorio el 27
de agosto de 2026, así que al activarlo no te encuentras un CI en rojo heredado.

Cuando exista `package.json`, el mismo archivo activa solo la verificación
completa: tipos, linter, pruebas, y las **pruebas de acceso cruzado**, que
bloquean la fusión. Ese es el punto: cuando la app exista, ya no vas a poder
mezclar desde el teléfono algo que deje los datos de un menor expuestos a otro
estudiante. La red queda puesta antes de que haga falta.

**Esto no te exime de leer el PR.** El CI atrapa lo mecánico. Que la
funcionalidad sea la correcta lo decides tú.

---

## 4. Antes de cada viaje

- [ ] `git push` de todo lo que tengas sin subir.
- [ ] Que no queden ramas locales con trabajo que solo esté en la PC.
- [ ] Que los PR abiertos estén en verde o anotados con qué les falta.

---

## 5. Lo que no cambia porque estés de viaje

Las diez reglas absolutas de `CLAUDE.md` §2 valen igual desde un teléfono en un
aeropuerto que desde la PC de la academia. La más fácil de saltarse cuando tienes
prisa y una pantalla de seis pulgadas es la primera: **ninguna tabla sin RLS.**

Si un PR toca `supabase/migrations/` y andas con prisa, la respuesta correcta no
es mezclarlo rápido. Es dejarlo abierto hasta que puedas leerlo.
