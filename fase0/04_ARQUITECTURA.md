# 04 · LA ESTRUCTURA TÉCNICA COMPLETA

> Todo lo que hay que construir para Fase 0, en un solo sitio.
> El proceso para construirlo está en `INGENIERIA.md`. Cómo se ve, en el prototipo v10.

---

## 1. EL STACK — YA DECIDIDO, NO SE CAMBIA

| Capa | Herramienta |
|---|---|
| Aplicación | Next.js 15 (App Router) + TypeScript |
| Estilos | Tailwind CSS 4, con los tokens de `spec/06` |
| Base, auth, archivos | Supabase (PostgreSQL) |
| Lógica de servidor | Supabase Edge Functions (Deno) |
| Lector de QR | `@zxing/browser` |
| Generador de QR | `qrcode` |
| Resumen de dudas | API de Claude, desde una Edge Function |
| PWA | Serwist |
| Pruebas | Vitest + Playwright |
| Despliegue | Vercel |

---

## 2. ESTRUCTURA DE CARPETAS

```
ZR App/
├── app/
│   ├── layout.tsx                    fuentes locales, metadatos PWA
│   ├── globals.css                   ⭐ EL ÚNICO sitio donde se define color
│   ├── page.tsx                      redirige según el rol
│   ├── manifest.ts
│   │
│   ├── (publico)/
│   │   ├── login/page.tsx
│   │   └── cambiar-clave/page.tsx    obligatoria si la clave es temporal
│   │
│   ├── (estudiante)/
│   │   ├── layout.tsx                barra inferior de 5 botones
│   │   ├── inicio/page.tsx
│   │   ├── material/page.tsx
│   │   ├── caso/[casoId]/page.tsx    pantalla completa, sin barra
│   │   ├── duda/page.tsx
│   │   ├── mi-modulo/page.tsx
│   │   ├── perfil/page.tsx
│   │   └── escanear/page.tsx         pantalla completa, sin barra
│   │
│   ├── (profesor)/
│   │   ├── layout.tsx
│   │   ├── hoy/page.tsx
│   │   ├── dudas/page.tsx            las 3 preguntas + las crudas
│   │   ├── casos/page.tsx            solo el conteo
│   │   └── perfil/page.tsx
│   │
│   └── (admin)/
│       ├── layout.tsx
│       ├── panel/page.tsx
│       ├── qr/page.tsx               pantalla completa
│       ├── asistencia/page.tsx       en vivo + registro manual
│       ├── material/page.tsx         subir PDF
│       └── perfil/page.tsx
│
├── components/
│   ├── ui/                           botón, tarjeta, aviso, píldora, campo
│   ├── EstadoCarga.tsx               ⭐ cargando · vacío · error · con datos
│   ├── TiraSemana.tsx
│   ├── LectorQR.tsx
│   └── PasosCaso.tsx
│
├── lib/
│   ├── supabase/
│   │   ├── cliente.ts                navegador — solo clave publicable
│   │   ├── servidor.ts               componentes de servidor
│   │   └── admin.ts                  ⚠️ service_role · NUNCA importar en cliente
│   ├── auth-helpers.ts               ya existe
│   ├── validators.ts                 ya existe
│   ├── types.ts                      ya existe
│   ├── database.types.ts             generado desde la base
│   └── config.ts                     lee system_config · ningún número en duro
│
├── middleware.ts                     protege por grupo de ruta
│
├── supabase/
│   ├── migrations/
│   │   ├── 000_esquema_base.sql      volcado de zr-prod
│   │   ├── 034_qr_un_solo_uso.sql
│   │   ├── 035_system_config.sql
│   │   ├── 036_contenido_fase0.sql
│   │   └── 037_seguridad.sql
│   ├── functions/
│   │   ├── provision-codigo/         genera el QR de un solo uso
│   │   ├── validate-scan/            reescrita
│   │   ├── registro-manual/
│   │   └── resumir-dudas/            llama a la API de Claude
│   └── seed/
│
└── tests/
    ├── rls/                          ya existe
    └── e2e/
```

---

## 3. MODELO DE DATOS

### 3.1 Ya existe en `zr-prod` y se usa tal cual

`profiles` · `students` · `teachers` · `admins` · `programs` · `modules` · `cohorts` ·
`class_sessions` · `attendance_events` · `content_items` · `content_views` · `system_config` ·
`audit_log`

### 3.2 Migración 034 — el QR de un solo uso

```sql
create table public.qr_codes (
  id            uuid primary key default gen_random_uuid(),
  session_id    uuid not null references class_sessions(id) on delete cascade,
  code          text not null unique,          -- lo que va dentro del QR
  used          boolean not null default false,
  used_at       timestamptz,
  used_by       uuid references profiles(id),
  created_at    timestamptz not null default now()
);
create index on public.qr_codes (session_id, used);
create unique index on public.qr_codes (session_id) where used = false;
```

> **El índice único parcial es la pieza clave:** garantiza que **haya como máximo un código sin
> usar por sesión**. Es lo que hace imposible que dos estudiantes usen el mismo código, y lo
> resuelve la base, no el código de la aplicación.

Además: retirar `attendance.qr_window_seconds` y `attendance.qr_drift_tolerance`.

### 3.3 Migración 036 — el contenido de Fase 0

```sql
-- El banco de casos. Se cargan ya revisados y aprobados (03_CASOS.md §4).
create table public.cases (
  id            uuid primary key default gen_random_uuid(),
  module_id     uuid not null references modules(id),
  cohort_id     uuid references cohorts(id),      -- null = para todas
  publish_on    date not null,                    -- el día que se abre
  title         text not null,
  scenario      text not null,                    -- sin cifras (03_CASOS.md §1)
  step1_prompt  text not null,
  step1_options jsonb not null,                   -- [{texto, correcta}]
  step2_prompt  text not null,
  step2_options jsonb not null,
  step3_prompt  text not null,                    -- texto libre
  reference     text not null,                    -- qué era y POR QUÉ NO las otras
  approved_by   uuid references profiles(id),     -- quién lo aprobó
  approved_at   timestamptz,
  created_at    timestamptz not null default now()
);
create index on public.cases (cohort_id, publish_on);

-- Lo que responde el estudiante. NO produce nota.
create table public.case_attempts (
  id            uuid primary key default gen_random_uuid(),
  case_id       uuid not null references cases(id) on delete cascade,
  student_id    uuid not null references profiles(id) on delete cascade,
  step1_choice  int,
  step2_choice  int,
  step3_text    text,
  confidence    int check (confidence between 1 and 5),
  revealed_at   timestamptz,                      -- cuándo vio la referencia
  completed_at  timestamptz,
  created_at    timestamptz not null default now(),
  unique (case_id, student_id)
);

-- Las dudas. Texto libre, sin lista de temas.
create table public.student_questions (
  id            uuid primary key default gen_random_uuid(),
  student_id    uuid not null references profiles(id) on delete cascade,
  cohort_id     uuid not null references cohorts(id),
  case_id       uuid references cases(id),        -- si salió de un caso
  body          text not null,
  created_at    timestamptz not null default now()
);
create index on public.student_questions (cohort_id, created_at);

-- Las 3 preguntas que resumen la semana. Generadas, no escritas.
create table public.question_digests (
  id            uuid primary key default gen_random_uuid(),
  cohort_id     uuid not null references cohorts(id),
  week_start    date not null,
  questions     jsonb not null,                   -- ["...", "...", "..."]
  source_count  int not null,                     -- de cuántas dudas salió
  generated_at  timestamptz not null default now(),
  unique (cohort_id, week_start)
);

-- Las competencias del módulo. Lista, sin estado.
create table public.module_competencies (
  id            uuid primary key default gen_random_uuid(),
  module_id     uuid not null references modules(id) on delete cascade,
  position      int not null,
  title         text not null,
  description   text,
  unique (module_id, position)
);
```

**Cada una nace con RLS habilitada y sus políticas en la misma migración** (regla 1).

### 3.4 Quién ve qué

| Tabla | Estudiante | Profesor | Admin |
|---|---|---|---|
| `cases` | Solo las de su cohorte **con `publish_on <= hoy`** | Las de su cohorte | Todas |
| `case_attempts` | **Solo las suyas** | ❌ **Ninguna fila** — solo cuenta agregada | Todas |
| `student_questions` | Solo las suyas | Las de su cohorte | Todas |
| `question_digests` | ❌ | Las de su cohorte | Todas |
| `module_competencies` | Las de su módulo | Las suyas | Todas |
| `qr_codes` | ❌ **nunca directamente** — solo vía Edge Function | ❌ | Vía Edge Function |

> ⚠️ **`case_attempts` es la política más delicada.** Se decidió que el profesor ve números y
> no nombres (`00_LEEME.md` §4.2). Eso **no se resuelve ocultando la columna en la pantalla**:
> se resuelve con RLS que no le deja leer ni una fila, más una vista agregada aparte.
> Si se hace en el frontend, cualquiera lo salta abriendo la consola.

---

## 4. EDGE FUNCTIONS

Cuatro. Toda la lógica de negocio vive aquí (regla 2).

### 4.1 `provision-codigo`
Genera el siguiente código de un solo uso de una sesión. Solo admin.
**Devuelve el código sin usar que exista, o crea uno.** Es lo que la pantalla del QR consulta.

### 4.2 `validate-scan` — reescrita
Recibe el código escaneado. **La llama el estudiante**, no el profesor.

1. ¿El usuario es estudiante y está autenticado?
2. ¿El código existe y **no está usado**?
3. ¿La sesión está abierta? ¿Es de su cohorte?
4. Marcar `used = true` **y** crear el `attendance_event` **en una sola transacción**
5. Marcar el refrigerio en el mismo evento
6. Devolver nombre y estado

> ⚠️ **La que está desplegada hoy hace lo contrario** — valida TOTP y exige que quien llama sea
> profesor. Se reescribe entera. Ver `plan/01_ESTADO.md` §5.2.

**Idempotencia:** el mismo escaneo dos veces devuelve *«ya estabas registrado»*, no un error ni
una segunda fila.

### 4.3 `registro-manual`
Admin marca presente a un estudiante con un motivo. Escribe `method = 'manual'`, el motivo y
quién lo hizo. Marca asistencia y refrigerio, igual que el escaneo.

### 4.4 `resumir-dudas`
Lee las dudas de la semana de una cohorte, llama a la **API de Claude** y guarda 3 preguntas en
`question_digests`. La dispara el profesor con un botón.

```
Entrada al modelo:  solo los textos de las preguntas, en una lista
                    ⚠️ NUNCA nombre, cédula ni id de estudiante
Salida:             exactamente 3 preguntas que cubran lo más repetido
Modelo:             claude-sonnet-5
Si falla:           el profesor ve las dudas en crudo. Nada se rompe
```

**Es la única parte de Fase 0 que usa IA en tiempo de ejecución.** Los casos se producen fuera
y se cargan revisados.

---

## 5. VARIABLES DE ENTORNO

```bash
# .env.local — NUNCA se sube al repositorio
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=          # publicable, puede ir al navegador
SUPABASE_SERVICE_ROLE_KEY=              # ⚠️ solo servidor. Nunca en cliente
```

```bash
# Secretos de las Edge Functions — se ponen con `supabase secrets set`
ANTHROPIC_API_KEY=                      # solo para resumir-dudas
```

> El CI ya comprueba que `service_role` no acabe en el paquete del navegador. Esa comprobación
> **está en `.github/ci-pendiente.yml` y sigue sin activarse.**

---

## 6. ALMACENAMIENTO DE ARCHIVOS

Un bucket de Supabase Storage: **`material`**, privado.

- Administración sube PDF. El estudiante los lee con URL firmada de duración corta.
- **Bucket privado, no público.** Un PDF público es una URL que circula por WhatsApp sin control.
- Registro en `content_items`, vista en `content_views`.

---

## 7. LOS SEIS COMPROBANTES DE QUE VA BIEN

Antes de dar por terminada cualquier tarea (`INGENIERIA.md` §9.2):

1. `npm run typecheck` pasa
2. La migración tiene número nuevo y RLS con políticas
3. `npm run test:rls` pasa
4. Camino feliz **y** camino de error
5. **Funciona en un teléfono real de 360 px**
6. El linter de seguridad no reporta ningún hallazgo `ERROR` nuevo
