# 05 · QUÉ NECESITO PARA CONSTRUIRLO

> Lista de bloqueantes reales. Ordenada por **cuándo bloquea**, no por importancia.
> Sin las cuatro primeras, hoy mismo no puedo avanzar más allá de crear el proyecto.

---

## 1. HOY — SIN ESTO NO ARRANCO

### 1.1 🔴 Acceso a `zr-prod` desde esta máquina

**El problema:** el CLI de Supabase de esta máquina está autenticado con una cuenta que **no
ve** el proyecto `zr-prod` (organización `xxkutznknslzarpddycq`). Ve otras siete organizaciones,
ninguna es la correcta.

Sin resolverlo no puedo hacer `supabase link`, ni `db pull`, ni `functions deploy`. Puedo leer
la base por otra vía, pero **no puedo desplegar nada**.

**Qué hacer — lo haces tú, no yo:**

```bash
supabase login
```

Con la cuenta dueña de `zr-prod`. Se abre el navegador y autorizas ahí.
**No me pases el token por chat** — no debo manejar credenciales en texto.

Después, para enlazar el proyecto:

```bash
supabase link --project-ref hagbqhnittynxebdssua
```

### 1.2 🔴 Quién más despliega a `zr-prod`

Una Edge Function desplegada apunta a `/Users/mdavi/OneDrive/Documentos/DEV/zr-app-github/`.
**Otra máquina, otro repositorio, otra persona.**

Necesito saber: **¿quién es y sigue trabajando en la base?** Si sí, hay que coordinar antes de
migrar. Dos personas migrando la misma base en paralelo es la forma más rápida de romperla.

### 1.3 🔴 Un proyecto Supabase de pruebas (`zr-dev`)

Hoy **no existe** y por eso todo apunta a producción. Es contra la regla de oro de
`INGENIERIA.md` §1.1: ninguna migración toca `zr-prod` sin haber corrido antes en local y en
pruebas.

**Qué hacer:** crear un proyecto nuevo llamado `zr-dev` en la misma organización. Es gratis.
Puedo crearlo yo si me confirmas que quieres que lo haga.

### 1.4 🟠 La presentación del módulo **[CAMINO CRÍTICO DEL CONTENIDO]**

**Lo más urgente de todo lo que no es acceso.** De ella salen los 5 casos y las competencias.

**Fecha límite: miércoles 26 de agosto.** Si llega después, no da tiempo de que el profesor y
dirección la revisen antes del 2 de septiembre, y Fase 0 se cae a un piloto de asistencia.

Ayuda mucho, si existe:
- **Dos o tres casos reales** que hayan entrado al taller
- Los errores que más comete el grupo
- El nivel del grupo

---

## 2. ESTA SEMANA

### 2.1 🟠 Proyecto en Vercel

No existe. Hace falta para desplegar, y **la cámara solo funciona sobre HTTPS** — así que sin
esto no puedo ni probar el riesgo máximo.

**Qué hacer:** crear una cuenta o proyecto en Vercel y conectarlo a
`github.com/guayamuripm-boop/zrapp`. Si me das acceso, lo configuro yo.

### 2.2 🟠 El permiso `workflow` en el token de GitHub

El CI está escrito pero **no se puede publicar**: GitHub rechaza el push porque el token no
tiene ese permiso. Es la razón por la que el proyecto lleva un mes sin red de seguridad.

**Dos caminos, cualquiera sirve:**

- **A) Desde la web, 30 segundos:** en el repositorio, *Add file › Create new file*, nombre
  `.github/workflows/ci.yml`, pegar el contenido de `.github/ci-pendiente.yml`, *Commit*.
- **B) Darle el permiso al token** en github.com/settings/tokens y luego moverlo por git.

### 2.3 🟡 Clave de la API de Claude

Solo para la función `resumir-dudas`. **Si no la hay, Fase 0 funciona igual**: el profesor ve
las dudas en crudo y alguien redacta las 3 preguntas a mano el viernes.

Se pone como secreto de las Edge Functions, **nunca en el repositorio**:

```bash
supabase secrets set ANTHROPIC_API_KEY=...
```

Ese comando lo corres tú, con la clave. No me la pases por chat.

---

## 3. ANTES DEL 5 DE SEPTIEMBRE

| Qué | Quién | Para cuándo |
|---|---|---|
| Los PDF de material del módulo | Dirección | Lunes 31 de agosto |
| **Los casos revisados y aprobados por el profesor** | Profesor + dirección | **Miércoles 2** |
| Cédulas y fechas de nacimiento de la cohorte nueva | Administración | Jueves 3 |
| Quién opera el registro manual el día 5 | Administración | Jueves 3 |
| Teléfonos prestados para el simulacro del 29 | Todos | Viernes 28 |

---

## 4. DECISIONES QUE TENGO PENDIENTES DE TI

| # | Pregunta | Bloquea | Mi recomendación |
|---|---|---|---|
| 1 | ¿Cuántos estudiantes son en la cohorte nueva? | El cálculo de la mañana del 5 | — |
| 2 | ¿Tendremos sus cédulas antes del día 5, o se inscriben ese mismo día? | **Toda la coreografía**. Si se inscriben ese día no hay cuentas que cargar por adelantado | Conseguirlas antes |
| 3 | ¿Se automatiza el resumen de dudas, o se hace a mano la primera semana? | Si es a mano, no hace falta la clave de Claude ahora | **A mano la primera semana.** El botón se añade después |
| 4 | ¿Creo yo `zr-dev`, o prefieres crearlo tú? | La regla de los entornos | Lo creo yo si me autorizas |

> **La 2 es la más importante.** Si los estudiantes se inscriben el mismo 5 de septiembre, no
> se pueden cargar las cuentas por adelantado y la mañana cambia otra vez: habría que crear
> usuarios en vivo, con la señal del taller. Conviene saberlo ya.

---

## 5. LO QUE **NO** NECESITO DE TI

Para que no gastes tiempo en esto:

- **Nada de diseño.** El prototipo v10 ya define cada pantalla.
- **Ninguna decisión de stack.** Está cerrado.
- **Ninguna regla de negocio nueva.** Están en `spec/00`.
- **Que me pases claves por chat.** Nunca. Los comandos de arriba los corres tú.

---

## 6. QUÉ PUEDO EMPEZAR YA MISMO, SIN NADA DE LO ANTERIOR

Para no quedarme parado mientras resuelves los accesos:

- [ ] **Crear el proyecto Next.js** con TypeScript, Tailwind 4 y los tokens de `spec/06`
- [ ] Montar la estructura de carpetas de `04_ARQUITECTURA.md` §2
- [ ] Los componentes de interfaz base y el `EstadoCarga`
- [ ] **La página de prueba de cámara** — solo falta Vercel para probarla de verdad
- [ ] Escribir las migraciones 034, 035 y 036 **sin aplicarlas**
- [ ] Reescribir `validate-scan` con el modelo de un solo uso, sin desplegarla

Eso es prácticamente todo el lunes 24 y el martes 25 del plan. **Dime y arranco.**
