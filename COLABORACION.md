# CÓMO TRABAJAMOS JUNTOS
> Guía operativa para ti, tu técnico y yo (el agente de código).
> Léela completa el primer día. Después se consulta, no se lee.

---

## 1. QUIÉN HACE QUÉ

Somos tres, con fronteras claras. Cuando dos personas pueden decidir lo mismo, nadie decide.

| Quién | Rol | Decide sobre | NO decide sobre |
|---|---|---|---|
| **Tú** | Dueño de producto y arquitecto | Alcance, prioridades, reglas de negocio, cuándo se entrega | Detalles de implementación |
| **Tu técnico** | Desarrollador | Cómo se implementa una tarea, calidad del código | Qué se construye o cuándo |
| **Yo (Claude)** | Agente de código | Nada por mi cuenta | Todo — yo ejecuto lo escrito y pregunto cuando falta algo |

**Regla de oro:** yo no invento requisitos. Si algo no está en `spec/`, me detengo y pregunto.
Si alguno de ustedes me dice "hazlo como veas", la respuesta correcta es que decidan ustedes y
lo escribamos en `spec/`. Una decisión no escrita se olvida y se vuelve a discutir.

---

## 2. MONTAR EL REPOSITORIO — 20 MINUTOS, UNA SOLA VEZ

### Paso 1 · Crear el repositorio (lo haces tú)
```bash
cd "C:\Dev\ZR App"
git init
git add .
git commit -m "Especificación completa de Fase 1"
```

Crea el repositorio en GitHub, **privado**. Contiene datos de la academia y de menores de edad;
nunca lo pongas público.
```bash
gh repo create zr-app --private --source=. --remote=origin --push
```

### Paso 2 · Invitar a tu técnico
GitHub → Settings → Collaborators → agregar con permiso **Write**.
No le des `Admin`: nadie debe poder borrar el repositorio o reescribir la historia por accidente.

### Paso 3 · Proteger la rama principal
Settings → Branches → Add rule sobre `main`:
- [x] Require a pull request before merging
- [x] Require approvals: **1**
- [x] Require status checks to pass → seleccionar el flujo de CI
- [x] Do not allow bypassing the above settings

**Por qué importa:** con esto, nadie —ni tú— puede subir código roto a `main` un viernes.
La regla protege el sábado de la academia.

### Paso 4 · Compartir las claves de forma segura
Las claves de Supabase y Vercel **nunca se mandan por WhatsApp, correo ni Telegram.** Quedan
guardadas para siempre en el historial de un chat que alguien puede perder con el teléfono.

Usa una de estas dos:
- **Bitwarden** (gratis) — crea una organización, comparte una colección "ZR App".
- **1Password** — si ya lo pagan.

En el repositorio solo va `.env.example`, sin valores. `.env.local` está en `.gitignore` y
**nunca se sube**.

Verifícalo antes del primer push:
```bash
git status --ignored | grep .env.local
```
Debe aparecer como ignorado.

---

## 3. EL PRIMER DÍA DE TU TÉCNICO — LISTA DE VERIFICACIÓN

Que la haga él solo. Si se traba en algún punto, el problema está en la documentación y hay que
arreglarla, no explicárselo de palabra.

- [ ] `git clone` del repositorio.
- [ ] Leer `AGENTS.md` completo. **Es obligatorio, no opcional.**
- [ ] Leer `docs/08_AUDITORIA_TECNICA_Y_VIABILIDAD.md` §0 y §6 (por qué el proyecto es así).
- [ ] Leer `INGENIERIA.md` completo — **es el proceso**.
- [ ] Abrir `ZR_APP_PROTOTIPO_v10.html` en el navegador y recorrer los cuatro roles
      (las cédulas de prueba están en `spec/04` §0.3).
- [ ] Leer `plan/07_ALCANCE_V10.md` — qué se construye y en qué orden.
- [ ] Seguir `spec/01_SETUP.md` de principio a fin.
- [ ] Instalar Claude Code y abrirlo en la carpeta del proyecto.
- [ ] Guardar las claves desde el gestor de contraseñas.

> ⚠️ **Tres pasos de esta lista no se pueden completar todavía**, y no es culpa de quien entra:
>
> | Paso | Por qué |
> |---|---|
> | `supabase db reset` con sus conteos | `supabase/migrations/` está vacía hasta que se vuelque el esquema de `zr-prod` (T-03) |
> | `npm run test:rls` | No hay `package.json`: la aplicación Next.js no existe todavía (T-07) |
> | Entrar al tablero de Trello | El tablero se archivó. La planificación vive en `plan/` |
>
> **Se vuelven obligatorios en cuanto T-03 y T-07 estén hechas.** Hasta entonces, quien entra
> se pone al día leyendo y recorriendo el prototipo.

**Si termina la lista, está listo para tomar tareas.** Si algo falló, se corrige la
documentación en ese momento: la próxima persona no debería tropezar con lo mismo.

---

## 4. CÓMO SE REPARTE EL TRABAJO

Las tareas vienen numeradas y con criterio de terminado en **`plan/02_SPRINT.md`** (el sprint
vigente) y **`plan/07_ALCANCE_V10.md`** (todo lo que viene después, por épicos).

| Prefijo | Quién la toma | Ejemplos |
|---|---|---|
| Base de datos, Edge Functions, RLS, CI, despliegue | **Técnico backend (T1)** | T-03, T-04, T-05, T-06 |
| Pantallas, componentes, PWA, cámara | **Técnico frontend (T2)** | T-08, T-09, T-10, T-11, T-12 |
| Decisiones, datos reales, coordinación con la academia | **Tú (DP)** | T-02, T-17, T-19, T-19b |

**Trabajen en paralelo, no en fila.** Backend y frontend de un mismo sprint casi nunca chocan:
el contrato entre los dos ya está escrito en `spec/02_CONTRATOS.md` y
`spec/03_EDGE_FUNCTIONS.md`. Esa es exactamente la razón por la que esos documentos existen —
para que nadie tenga que esperar a que el otro termine.

---

## 5. EL CICLO DE UNA TAREA

```
Marcar la tarea como empezada en plan/02_SPRINT.md
   ↓
git checkout -b T-10-pantalla-escaneo
   ↓
Trabajar (con Claude Code o a mano)
   ↓
npm run verify          ← si falla, no sigas
   ↓
Probar en un teléfono real  ← esto no se salta nunca
   ↓
git push + abrir Pull Request
   ↓
El otro revisa y aprueba
   ↓
Merge a main → se despliega solo
   ↓
Marcar [x] en plan/02_SPRINT.md
```

> El detalle completo del ciclo, con la disciplina de migraciones y la definición de
> terminado, está en **`INGENIERIA.md`** §2 y §9.

### Nombres de rama
```
T-10-pantalla-escaneo
fix/T-203-ventana-totp
```

### Mensajes de commit
En español, en imperativo, y **con el número de tarea**:
```
T-205: agregar pantalla de escaneo con cámara

Lector con @zxing/browser, franja de resultado grande y sonido
distinto para éxito y error. Cola sin conexión pendiente (T-204).
```

El número permite rastrear cualquier línea de código hasta la tarea, la tarea hasta el sprint y
el sprint hasta la decisión que lo originó. En seis meses, cuando alguien pregunte "¿por qué
esto es así?", esa cadena es la respuesta.

### Lista de revisión del Pull Request
Pega esto en `.github/pull_request_template.md`:

```markdown
## Tarea
T-___

## Qué hace


## Verificación
- [ ] `npm run verify` pasa
- [ ] Si toca la base: migración nueva versionada, nunca editando una aplicada
- [ ] Si crea tabla: RLS habilitada + política escrita + prueba de acceso cruzado
- [ ] Probado en un teléfono real, no solo en el navegador de escritorio
- [ ] Ningún número de negocio escrito en duro (van en `system_config`)
- [ ] `SUPABASE_SERVICE_ROLE_KEY` no aparece en código de cliente
- [ ] Camino feliz y camino de error, ambos probados
```

---

## 6. CÓMO TRABAJAN CONMIGO

### Los dos pueden usarme al mismo tiempo
Cada uno abre Claude Code en **su propia copia del repositorio, en su propia rama**. No hay
conflicto: git resuelve el encuentro al hacer el merge.

### Cómo pedirme algo bien

**Mal:** *"hazme la pantalla de asistencia"*
**Bien:** *"implementa T-205 siguiendo spec/04_PANTALLAS.md §4"*

La diferencia es enorme. En el segundo caso leo la especificación, respeto los contratos y
produzco algo que encaja con lo que hizo el otro. En el primero, invento — y lo que invento no
coincide con lo que espera el frontend.

### Al empezar cada sesión conmigo
Basta con esto:
```
Lee AGENTS.md e INGENIERIA.md. Vamos a hacer T-10 de plan/02_SPRINT.md.
```
Yo cargo el contexto que necesito. No hace falta pegarme documentos.

### Cuándo NO usarme
- Para decidir reglas de negocio → eso lo decide la academia.
- Para elegir entre dos diseños → eso lo decides tú.
- Para "arreglar rápido" algo en producción sin pasar por Pull Request → nunca.

### Si te doy algo que no encaja
Dímelo con la referencia: *"eso contradice `spec/02_CONTRATOS.md` §3"*. Lo corrijo de una vez.
Y si la especificación es la que está mal, la actualizamos ahí mismo — la especificación es el
producto, no un adorno.

---

## 7. RITMO DE TRABAJO

| Cuándo | Qué | Cuánto |
|---|---|---|
| **Todos los días, misma hora** | Qué hice / qué sigue / qué me bloquea | 15 min |
| **Lunes** | Vaciar el sprint anterior, cargar el nuevo desde el Backlog | 20 min |
| **Jueves** | Corte de despliegue. Lo que no esté listo, espera al lunes | — |
| **Viernes** | **No se despliega nada** | — |
| **Sábado** | En la sede. Probar con usuarios reales | Media jornada |
| **Domingo** | Mover a "Hecho" lo que cumple las 7 condiciones | 15 min |

**Un bloqueo que dura más de 24 horas se escala el mismo día.** No al día siguiente, no en la
reunión del lunes. Con cinco semanas de plazo, un bloqueo de tres días es el 8% del proyecto.

---

## 8. REGLAS QUE NO SE ROMPEN

1. **Nadie sube directo a `main`.** Ni para "un cambio chiquito". Los cambios chiquitos son los
   que rompen producción, precisamente porque nadie los revisa.
2. **Nadie despliega en viernes.**
3. **Nadie edita una migración ya aplicada.** Se crea una nueva.
4. **Nadie crea una tabla sin RLS y sin su prueba de acceso cruzado.**
5. **Nadie comparte claves por chat.**
6. **Nadie agrega una función que no esté en `plan/`.** Va al backlog del nivel siguiente
   (`plan/07_ALCANCE_V10.md`).
7. **Si las pruebas de RLS fallan, no se publica.** No hay excepción y no hay urgencia que la
   justifique: es una fuga de datos de menores de edad.

---

## 9. QUÉ HACER CUANDO ALGO SALE MAL

| Situación | Qué hacer |
|---|---|
| Producción se rompió | Revertir al despliegue anterior en Vercel (un clic). Investigar después, con calma. |
| Una migración falló en producción | **No la parches a mano en la base.** Escribe una migración nueva que corrija. Si tocaste la base a mano, el próximo `db reset` te lo destruye. |
| Los dos tocaron el mismo archivo | Git te avisa. Resuelve el conflicto, corre `npm run verify` y sigue. |
| Yo te di código que no funciona | Dímelo con el error completo pegado. No lo arregles a ciegas. |
| Un dato de la academia no llega | Sigue construyendo con los datos ficticios. **El plan nunca depende de un dato externo para avanzar, solo para entregar.** |
| Se cae internet (pasa) | Todo el desarrollo funciona sin conexión: Supabase local, Next.js local, pruebas locales. Solo hacen falta datos para el push y para desplegar. |

---

## 10. LOS DOCUMENTOS QUE IMPORTAN

Si alguien solo va a leer cuatro cosas:

1. **`AGENTS.md`** — las 10 reglas absolutas y el orden de trabajo.
2. **`INGENIERIA.md`** — cómo se construye, se prueba y se despliega.
3. **`plan/02_SPRINT.md`** — qué toca ahora, con criterio de verificación.
4. **`ZR_APP_PROTOTIPO_v10.html`** — cómo se ve y se comporta cada pantalla.

Todo lo demás es contexto: útil para entender el porqué, innecesario para el día a día.
