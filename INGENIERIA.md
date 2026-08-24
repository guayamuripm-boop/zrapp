# INGENIERÍA — CÓMO SE CONSTRUYE ZR APP

> Escrito el 23 de agosto de 2026. Este documento define **el proceso**, no el producto.
> Qué es el producto está en `spec/`. Qué se construye ahora está en `plan/`.
>
> Si una regla de aquí estorba, se cambia el documento y se avisa. Lo que no se hace es
> saltársela en silencio.

---

## 0. LAS CINCO IDEAS QUE ORDENAN TODO LO DEMÁS

1. **La base de datos manda, no el repositorio.** `zr-prod` está vivo y con datos. El
   repositorio describe lo que hay; cuando divergen, se corrige el repositorio.
2. **La lógica de negocio vive en el servidor.** El navegador muestra resultados. Nunca los
   calcula.
3. **El prototipo v10 es la especificación visual.** Ante una duda de cómo se ve o se comporta
   una pantalla, se abre el prototipo. No se inventa.
4. **Se entrega en trozos que funcionan de punta a punta.** Nunca «el backend de todo» y
   después «el frontend de todo». Una pantalla completa que sirve vale más que diez a medias.
5. **Nada se da por terminado sin haberlo probado en un teléfono real.** El taller no es una
   oficina: hay poca luz, manos sucias y señal mala.

---

## 1. LOS CUATRO ENTORNOS

| Entorno | Qué es | Quién lo toca |
|---|---|---|
| **Local** | Supabase local (`supabase start`) + `next dev` | Cualquiera, sin pedir permiso |
| **`zr-dev`** | Proyecto Supabase de pruebas. **Todavía no existe — hay que crearlo** | Cualquiera |
| **`zr-prod`** | La base real, con los estudiantes reales | Solo por migración revisada |
| **Vercel** | `preview` por rama · `production` desde `main` | Automático |

### 1.1 Regla de oro de los entornos

> **Ninguna migración toca `zr-prod` sin haber corrido antes en local y en `zr-dev`.**

Hoy esta regla no se puede cumplir porque `zr-dev` no existe. **Crearlo es la primera tarea
de infraestructura del proyecto** (ver `plan/07` §T-00).

### 1.2 Bloqueante abierto — la cuenta del CLI

El `supabase` CLI de esta máquina está autenticado con una cuenta que **no tiene acceso a
`zr-prod`** (organización `xxkutznknslzarpddycq`). Sin resolverlo no se puede hacer
`supabase link`, `db pull`, ni `functions deploy` desde aquí.

Además, una de las Edge Functions desplegadas apunta a un repositorio distinto
(`.../DEV/zr-app-github/`), en otra máquina. **Hay que averiguar quién más despliega a
`zr-prod` antes de escribir una migración.** Dos personas migrando la misma base en paralelo
es la forma más rápida de romperla.

---

## 2. EL CICLO DE UNA TAREA

Siete pasos. No se saltan.

```
 1. Entender  →  2. Rama  →  3. Migración  →  4. Servidor  →
 5. Pantalla  →  6. Pruebas  →  7. Revisión y merge
```

### Paso 1 · Entender antes de escribir

Antes de la primera línea:

- [ ] Leí la tarea en `plan/` y **entiendo su criterio de terminado**
- [ ] Abrí la pantalla en el prototipo v10 y la usé
- [ ] Busqué en `spec/` la regla de negocio que aplica
- [ ] **Si algo no está escrito en ningún lado, pregunté.** No lo inventé

> Una decisión inventada cuesta días de retrabajo. Una pregunta cuesta cinco minutos.

### Paso 2 · Una rama por tarea

```
T-09-qr-un-solo-uso
T-13b-abrir-diagnostico
fix-escaneo-camara-gama-baja
```

Nombre en minúsculas, con guiones, empezando por el código de la tarea. **Nunca se trabaja
directo en `main`.**

### Paso 3 · La migración, si toca la base

Ver §3 completo. Es la parte que no se puede deshacer.

### Paso 4 · La lógica, en el servidor

Toda regla de negocio va en una Edge Function o en una ruta de servidor de Next.js:
cálculo de notas, validación de QR, corrección de exámenes, asignación de roles.

**El navegador solo muestra.** Si te encuentras escribiendo un `if` con un umbral dentro de un
componente, está en el lugar equivocado.

### Paso 5 · La pantalla

- Se construye a **360 px** primero. El escritorio después.
- Los cuatro estados: **cargando · vacío · error · con datos**. Ninguna pantalla se entrega con
  tres.
- Colores solo desde los tokens de `spec/06`. Cero hex sueltos.
- Textos en español de Venezuela, según la voz de `spec/06` §8.

### Paso 6 · Pruebas

Ver §4. Como mínimo: el camino feliz, el camino de error, y **el teléfono real**.

### Paso 7 · Revisión

Ver §5.

---

## 3. LA DISCIPLINA DE LAS MIGRACIONES

Es donde más caro sale un error, porque afecta datos de menores de edad.

### 3.1 Las seis reglas

1. **Una migración nunca se edita después de aplicada.** Se crea la siguiente con el número
   que sigue.
2. **Toda tabla nueva nace con RLS habilitada y con sus políticas escritas en la misma
   migración.** Una tabla con RLS y sin política no es «segura»: es inaccesible, y alguien la
   va a «arreglar» abriéndola.
3. **Toda migración se prueba con `npm run test:rls` antes de subirla.** El estudiante A no
   puede leer nada del estudiante B.
4. **Ningún número de negocio se escribe en el SQL.** Umbrales, pesos y ventanas van a
   `system_config`.
5. **Cada migración corre en local → `zr-dev` → `zr-prod`, en ese orden.** Nunca directo a
   producción.
6. **Después de cada migración se corre el linter de seguridad** (`get_advisors`). Si aparece
   un hallazgo de nivel `ERROR`, la migración no está terminada.

### 3.2 Numeración

La base va por la **033**. La siguiente migración es la **034**, no la 017.

Las migraciones 001–016 del repositorio están en `_archivo/migraciones-superadas/`.
**Nunca se aplican.** Se conservan solo porque de ahí salen las tablas de evaluación
práctica que todavía hacen falta — pero **se copian las tablas, no los umbrales**
(`spec/00` §2.4.1).

### 3.3 Plantilla de migración

```sql
-- 0NN_nombre_corto.sql
-- Qué hace: una frase.
-- Por qué: el enlace a la decisión (spec/00 §X, plan/0N §Y).
-- Reversión: cómo se deshace, o "no reversible" y por qué.

begin;

-- 1. DDL

-- 2. RLS: habilitar
alter table public.nueva_tabla enable row level security;

-- 3. RLS: políticas. Una por rol que necesite acceso.
--    Si un rol no aparece aquí, no tiene acceso. Eso es intencional.

-- 4. Índices para las columnas que usan las políticas.

commit;
```

### 3.4 Deuda de seguridad abierta

Los 62 hallazgos siguen abiertos. **Estos tres bloquean la carga de estudiantes reales:**

| Hallazgo | Nivel |
|---|---|
| `v_students` con `SECURITY DEFINER` | ERROR |
| `v_exam_questions_student` con `SECURITY DEFINER` | ERROR |
| `v_feedback_session_summary` con `SECURITY DEFINER` | ERROR |
| `student_qr_secrets` con RLS y sin ninguna política | INFO, pero grave |

`v_exam_questions_student` es el caso más grave: **esa vista existe precisamente para no
mostrarle al estudiante la respuesta correcta.** Con `SECURITY DEFINER` puede estar saltándose
el aislamiento que la justifica.

> **Regla dura: no se carga ni una cédula real mientras haya un hallazgo de nivel `ERROR`.**

---

## 4. PRUEBAS — QUÉ SE PRUEBA Y A QUÉ NIVEL

No se prueba todo igual. Se prueba **según lo que cuesta si falla**.

| Nivel | Herramienta | Qué cubre | Cuándo corre |
|---|---|---|---|
| **Aislamiento (RLS)** | Vitest + cliente Supabase | Que A no vea nada de B | En cada migración. **Obligatorio** |
| **Lógica de servidor** | Vitest | Cálculo de notas, validación de QR, corrección | En cada cambio de Edge Function |
| **Unidad** | Vitest | Validadores, formato de cédula, fechas | Al escribirlos |
| **Recorrido** | Playwright | Los tres caminos completos por rol | Antes de cada despliegue a producción |
| **Teléfono real** | Un teléfono, una mano | Todo lo que se toca | **Antes de dar por terminada cualquier pantalla** |

### 4.1 Lo que siempre se prueba

Para cada funcionalidad, tres casos:

1. **El camino feliz** — todo sale bien.
2. **El camino de error** — el código ya se usó, no hay señal, la sesión está cerrada.
3. **El caso del que no debería poder** — un estudiante intentando leer datos de otro, un
   profesor intentando ver feedback individual, el cliente pidiendo `correct_answer`.

El tercero es el que nadie escribe y el que más importa.

### 4.2 La prueba que no se recorta

> **Regla del proyecto: si algo se atrasa, se recorta alcance — nunca se recorta la prueba en
> teléfono real.**

Tres teléfonos distintos, uno de gama baja, **en el taller, con su luz real**. Una pantalla que
funciona en el simulador del navegador y no en un Android de 80 dólares no funciona.

### 4.3 El comando único

```bash
npm run verify
```

Debe correr: `typecheck` → `lint` → `test` → `test:rls` → `build`. Si falla cualquiera, la
tarea no está terminada.

---

## 5. REVISIÓN DE CÓDIGO

### 5.1 Qué se revisa, en este orden

1. **¿Hay una regla de negocio en el navegador?** Es el error más caro y el más fácil de colar.
2. **¿Hay una tabla nueva sin política de RLS?**
3. **¿Hay un número de negocio escrito en el código?**
4. **¿Se le manda al estudiante algo que no debería ver?**
5. **¿Funciona a 360 px?**
6. **¿Están los cuatro estados de carga?**
7. Ya después: nombres, duplicación, legibilidad.

### 5.2 Comandos disponibles

```bash
/code-review
```

Revisa el diff de la rama. Para las ramas que tocan la base o el escaneo, conviene subirle el
nivel; para un cambio de texto, no hace falta.

```bash
/security-review
```

Antes de cualquier despliegue que cargue datos reales.

### 5.3 Cuándo se salta la revisión

Nunca en migraciones, Edge Functions ni nada que toque autenticación o roles.
Un cambio de copy o de espaciado no la necesita.

---

## 6. COMMITS Y RAMAS

### 6.1 El mensaje de commit

En español, en imperativo, diciendo **qué cambia para el usuario**, no qué archivos tocaste.

```
Marcar refrigerio en el mismo escaneo de asistencia

Antes hacían falta dos acciones. Ahora validate-scan escribe
snack_claimed_at en el mismo evento. Idempotente: reintentar
el mismo código no duplica el refrigerio.
```

Mal: `fix bug`, `cambios varios`, `wip`, `actualiza index.ts`.

### 6.2 El flujo

```
main ─────────────────────●──────────●─────►  producción
                         ╱          ╱
        T-09-qr ────────●          ╱
        T-10b-manual ──────────────●
```

- `main` **siempre despliega**. Nunca se rompe.
- Una rama por tarea, vida corta: se abre y se cierra en el mismo día o dos.
- Se mergea cuando `npm run verify` pasa y la revisión está hecha.

### 6.2.1 El estado real hoy, y por qué no cumple esto

Auditado el 24 de agosto de 2026:

| Hallazgo | Consecuencia |
|---|---|
| `main` está **4 commits atrás**. Todo el trabajo vive en ramas largas sin fusionar | `main` no representa el proyecto. Nadie puede clonarlo y entender dónde está |
| Dos ramas apiladas (`reconciliacion-y-plan-mvp` → `organizacion-v10`), de semanas de vida | Contradice «vida corta». Son ramas de documentación, no de código, pero el efecto es el mismo |
| **Sin tags.** Ninguna versión marcada | No hay forma de decir «esto es lo que había el día del piloto» |
| **Sin CI.** Se añadió el 30 de julio y se eliminó el 11 de agosto | Las reglas de §4 y §5 dependen de que alguien se acuerde. Ver §6.2.2 |

La historia es **lineal** — no hay divergencia — así que las dos ramas se fusionan a `main`
sin conflicto. Ver §6.4.

### 6.2.2 Por qué el proyecto lleva un mes sin CI

El commit del 11 de agosto se titula «Remover archivo workflow problemático». **El archivo no
era problemático.** Al intentar restaurarlo el 24 de agosto, GitHub rechazó el push:

```
refusing to allow a Personal Access Token to create or update workflow
`.github/workflows/ci.yml` without `workflow` scope
```

El token no tiene permiso para subir flujos de trabajo. Se borró el archivo para desatascar el
push, y con él se fue la única red de seguridad automática del proyecto —
la que impide que una tabla sin RLS o una clave de servicio filtrada lleguen a producción.

**Estado:** el flujo está en `.github/ci-pendiente.yml`, con las instrucciones para activarlo
en su cabecera. **Mientras no se active, las reglas de §4 y §5 se cumplen a mano.**

> Es un buen ejemplo de por qué este documento insiste en verificar: un título de commit
> asignó la culpa al archivo, y esa explicación sobrevivió un mes sin que nadie la comprobara.

### 6.3 Etiquetas

Se marca con tag todo lo que se puso delante de estudiantes reales:

```
piloto-2026-09-05      lo que corrió el día del piloto
v0.1-asistencia        el primer alcance completo
```

**Antes de cada clase real se etiqueta.** Es lo que permite responder «¿qué versión falló?»
sin adivinar.

### 6.4 Fusionar cuando una rama larga ya no lo es

Una rama de documentación que acumuló semanas no se rebasa ni se aplasta: **se fusiona con
merge y se conserva la historia**, porque cada commit explica una decisión y esa cadena vale
más que un historial limpio.

### 6.3 Congelamiento antes de una entrega

**El día antes de una clase real no se despliega nada.** Ese día es para recorrer los flujos
y escribir el plan B, no para arreglar cosas cosméticas.

---

## 7. CÓMO SE TRABAJA CON EL AGENTE

Buena parte del código lo escribe un agente. Eso cambia el proceso, no lo relaja.

### 7.1 Lo que hace el agente

- Implementar lo que ya está especificado en `spec/` y `plan/`.
- Escribir migraciones, Edge Functions, pantallas y pruebas.
- Encontrar contradicciones entre documentos y señalarlas.
- Verificar el estado real (la base, los despliegues) en vez de creerle a la documentación.

### 7.2 Lo que **no** hace el agente

- **Decidir reglas de negocio.** Si un umbral no está escrito, pregunta.
- **Aplicar migraciones a `zr-prod`** sin que alguien lo apruebe explícitamente.
- **Cargar datos reales de estudiantes.**
- **Construir algo de Fase 2 o Fase 3**, aunque se lo pidan.

### 7.3 La regla de la verificación

> **El agente no reporta «listo» sin haberlo comprobado.** Si dice que una función está
> desplegada, es porque la consultó. Si dice que las pruebas pasan, es porque las corrió.

Este documento existe en parte porque la documentación del proyecto afirmaba cosas que no eran
ciertas: que las 16 migraciones estaban aplicadas (no lo estaban) y que `validate-scan` no
estaba desplegada (sí lo estaba). **Verificar cuesta una consulta; creerle a un documento
desactualizado cuesta un sprint.**

### 7.4 Cómo se le pide algo al agente

| Mal | Bien |
|---|---|
| «Haz la pantalla de asistencia» | «Implementa T-09 y T-10 de `plan/02`. La pantalla está en el prototipo v10, vista `pa-cod` y `v-escaneo`» |
| «Arregla la seguridad» | «Cierra los 3 hallazgos ERROR de `get_advisors`: quita `SECURITY DEFINER` de las tres vistas o justifica por escrito cada una» |
| «Que se vea mejor» | «Los botones de `/escanear` deben ser legibles a un metro, según `spec/06` §5» |

Una tarea con su criterio de terminado se puede verificar. Una tarea vaga se discute tres veces.

---

## 8. EL RITMO DE TRABAJO

### 8.1 La semana

| Día | Qué |
|---|---|
| **Lunes** | Se decide qué entra en la semana. Se revisa qué quedó abierto |
| **Martes a jueves** | Construcción |
| **Viernes** | Se congela. Recorrido completo de los tres roles. Nada nuevo se despliega |
| **Sábado** | **Clase real.** Se observa y se anota. **No se arregla nada en el momento** |
| **Domingo** | Se ordenan los fallos del sábado por gravedad |

### 8.2 Por qué no se arregla nada el sábado

Porque un arreglo apurado durante una clase con 24 estudiantes rompe algo más. El sábado se
anota; el domingo se ordena; el lunes se arregla. **Lo que falla en una clase real es
información, y se pierde si alguien la parcha antes de escribirla.**

### 8.3 Después de cada clase real

Cuatro cosas, siempre las mismas:

1. **El número:** cuántos presentes contra cuántos registrados.
2. **La lista de fallos**, con lo que se arregló y lo que quedó pendiente.
3. **Qué dijeron cinco estudiantes** a los que se les pregunte qué no entendieron.
4. Qué se recorta o se adelanta como consecuencia.

Eso es lo que convierte una clase en información en vez de en una anécdota.

---

## 9. DEFINICIONES

### 9.1 Definición de LISTO — se puede empezar

Una tarea se puede empezar cuando:

- [ ] Está escrito **qué hace** y **cómo se sabe que funciona**
- [ ] La pantalla existe en el prototipo v10, o está escrito por qué no
- [ ] La regla de negocio está en `spec/` o en `system_config`
- [ ] No depende de algo que todavía no existe
- [ ] Se sabe qué tablas y qué funciones toca

Si falta cualquiera, la tarea **no está lista** y empezarla es adelantar trabajo que se va a
rehacer.

### 9.2 Definición de TERMINADO — se puede cerrar

Las siete condiciones. Todas.

1. `npm run typecheck` pasa sin errores.
2. Si tocó la base, la migración está con número nuevo y corrió en local → `zr-dev` → `zr-prod`.
3. Si creó una tabla, tiene RLS y políticas escritas.
4. `npm run test:rls` pasa.
5. `npm run test` pasa.
6. Se probó el camino feliz **y** el camino de error.
7. **Funciona en un teléfono real de 360 px**, no en el simulador.

Más una octava, propia de este proyecto:

8. **El linter de seguridad no reporta ningún hallazgo nuevo de nivel `ERROR`.**

---

## 10. QUÉ HACER CUANDO ALGO SE ROMPE EN PRODUCCIÓN

En orden, sin saltarse pasos.

1. **¿Hay una clase en curso?** Si sí, se aplica el plan B de `plan/06` §8 y **no se toca el
   código**. La operación primero.
2. **Escribir qué pasó** antes de arreglar nada. Qué se esperaba, qué ocurrió, quién lo vio.
3. **¿Se puede resolver con `system_config`?** Muchos problemas son un umbral mal puesto. Eso
   se cambia sin desplegar.
4. **¿Se puede revertir?** Volver al despliegue anterior es casi siempre más rápido y más
   seguro que arreglar en caliente.
5. **Arreglar, con su prueba.** Un fallo que llegó a producción es un caso de prueba que
   faltaba. Se escribe la prueba primero.
6. **Anotarlo** en el registro de fallos.

### 10.1 Lo único que admite papel

Si se cae Supabase completo durante una clase, se usa la lista impresa. **Es el único
escenario.** Todo lo demás — cámara rota, teléfono sin batería, sin señal — tiene salida dentro
de la aplicación, y por eso el registro manual no es opcional.

---

## 11. LA JERARQUÍA CUANDO DOS COSAS SE CONTRADICEN

En este orden exacto:

| # | Fuente | Alcance |
|---|---|---|
| 1 | **El estado real de `zr-prod`** | Qué existe de verdad |
| 2 | **`spec/00_RECONCILIACION.md`** | Calificación, ciclo semanal, compuertas, QR |
| 3 | **`fase0/00_LEEME.md`** | El alcance del 5 de septiembre (supera a `plan/06`) |
| 4 | **`ZR_APP_PROTOTIPO_v10.html`** | Cómo se ve y se comporta cada pantalla |
| 5 | **`spec/`** | El resto del contrato técnico |
| 6 | **`docs/`** | El porqué de las decisiones |
| 7 | `_archivo/` | **No es fuente de verdad.** No se sigue |

Cuando encuentres una contradicción: **corrige el documento de menor rango y avisa.** No la
dejes ahí para que la encuentre el siguiente.

---

## 12. RESPALDO, CONTINUIDAD Y MONITOREO

> **La regla, textual del MDV: un respaldo que no se ha restaurado nunca no es un respaldo.**

### 12.1 Respaldo

Supabase respalda automáticamente, pero eso **no basta**:

- [ ] Verificar cada cuánto respalda `zr-prod` y cuánta retención tiene el plan contratado
- [ ] **Restaurar una copia a `zr-dev` al menos una vez**, antes de cargar estudiantes reales.
      Ese es el único momento en que se sabe si el respaldo sirve
- [ ] Exportar el esquema al repositorio en cada migración — es la otra mitad del respaldo

### 12.2 Monitoreo

Dos comprobaciones, con alerta a WhatsApp o Telegram:

1. **La app responde.**
2. **Supabase responde.**

**Por qué importa concretamente:** si algo se cae un viernes por la noche, el sábado a las
7:40 hay 24 estudiantes en la puerta y nadie puede escanear. Es el fallo más probable y el más
fácil de detectar a tiempo.

> Hoy no hay ningún monitoreo. Es una tarea del épico A de `plan/07`.

### 12.3 La medición no es opcional

`metodologia/02_MEDICION.md` define los ocho indicadores y la línea base. Dos consecuencias
para ingeniería:

- Los ocho indicadores son **una pantalla que hay que construir** (épico M) y **un correo
  automático los lunes** que todavía no está en el plan.
- **Lo que no se capture antes de la primera clase ya no se puede capturar.** La línea base
  vence el 5 de septiembre.

---

## 13. HISTORIAL

| Fecha | Cambio |
|---|---|
| 2026-08-23 | Documento creado. Sale de la revisión del estado real del proyecto: base en 033, repositorio en 016, 13 Edge Functions desplegadas que el repositorio no conocía, 62 hallazgos de seguridad abiertos y cero líneas de aplicación |
| 2026-08-24 | Auditoría del control de versiones (§6.2.1). Se añaden etiquetas (§6.3), respaldo y monitoreo (§12) — que faltaban por completo — y el enlace con `metodologia/`, restaurada tras haberse archivado de más |
