-- ============================================================================
-- 036_contenido_fase0.sql
--
-- QUÉ HACE: crea las cuatro tablas del contenido de Fase 0:
--           casos, intentos de caso, dudas y competencias del módulo.
--           Más la vista agregada que el profesor consulta.
--
-- POR QUÉ:  fase0/00_LEEME.md §3.1. Es todo lo que el estudiante gana para sí
--           mismo entre semana. NINGUNA de estas tablas produce una nota:
--           Fase 0 saca todo lo que califica.
--
-- REVERSIÓN: drop de las cuatro tablas y de la vista. Ver el bloque final.
--
-- VERIFICADO CONTRA: esquema real de zr-prod, 24 de agosto de 2026.
--   Reutiliza las funciones auxiliares que YA EXISTEN:
--   auth_role() · is_student() · is_staff() · is_admin_up()
--   my_cohort_id() · my_module_id() · teaches_cohort()
-- ============================================================================

begin;

-- ===========================================================================
-- 1. CASES — el banco de casos
--    Se cargan YA REVISADOS Y APROBADOS. La revisión ocurre fuera de la app
--    (fase0/00_LEEME.md §4.1), por eso hay approved_by / approved_at.
-- ===========================================================================
create table if not exists public.cases (
  id            uuid primary key default gen_random_uuid(),
  module_id     uuid not null references public.modules(id) on delete cascade,
  cohort_id     uuid references public.cohorts(id) on delete cascade,  -- null = todas
  publish_on    date not null,
  week_number   integer,
  title         text not null,
  scenario      text not null,

  step1_prompt  text not null,
  step1_options jsonb not null,   -- [{"texto":"...","correcta":true}, ...]
  step2_prompt  text not null,
  step2_options jsonb not null,
  step3_prompt  text not null,    -- texto libre, no se corrige

  reference     text not null,    -- qué era y POR QUÉ NO las otras

  approved_by   uuid references public.profiles(id) on delete set null,
  approved_at   timestamptz,
  created_at    timestamptz not null default now(),

  -- Un caso sin aprobar no se le muestra a nadie. Ver la política de lectura.
  constraint cases_opciones_validas check (
    jsonb_typeof(step1_options) = 'array' and
    jsonb_typeof(step2_options) = 'array' and
    jsonb_array_length(step1_options) between 2 and 6 and
    jsonb_array_length(step2_options) between 2 and 6
  )
);

comment on table public.cases is
  'Casos sintéticos, uno por día. Conceptuales: sobre cómo razonar y por dónde empezar, nunca sobre valores exactos (fase0/03_CASOS.md §1). No producen nota.';

create index if not exists cases_cohorte_fecha_idx on public.cases (cohort_id, publish_on);
create index if not exists cases_modulo_idx on public.cases (module_id);

-- ===========================================================================
-- 2. CASE_ATTEMPTS — lo que responde el estudiante. NO produce nota.
-- ===========================================================================
create table if not exists public.case_attempts (
  id            uuid primary key default gen_random_uuid(),
  case_id       uuid not null references public.cases(id) on delete cascade,
  student_id    uuid not null references public.profiles(id) on delete cascade,
  step1_choice  integer,
  step2_choice  integer,
  step3_text    text,
  confidence    integer check (confidence between 1 and 5),
  revealed_at   timestamptz,
  completed_at  timestamptz,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  unique (case_id, student_id)
);

comment on table public.case_attempts is
  'Intento del estudiante en un caso. Sin nota y sin puntaje: es evidencia de participación. El profesor ve el CONTEO, nunca las filas.';

create index if not exists case_attempts_student_idx on public.case_attempts (student_id);
create index if not exists case_attempts_case_idx on public.case_attempts (case_id);

-- ===========================================================================
-- 3. STUDENT_QUESTIONS — las dudas. Texto libre, sin lista de temas.
-- ===========================================================================
create table if not exists public.student_questions (
  id          uuid primary key default gen_random_uuid(),
  student_id  uuid not null references public.profiles(id) on delete cascade,
  cohort_id   uuid not null references public.cohorts(id) on delete cascade,
  case_id     uuid references public.cases(id) on delete set null,
  body        text not null check (length(trim(body)) >= 5),
  answered_at timestamptz,
  created_at  timestamptz not null default now()
);

comment on table public.student_questions is
  'Dudas del estudiante, en texto libre. NO son anónimas: el profesor necesita poder volver con quien preguntó.';

create index if not exists student_questions_cohorte_idx
  on public.student_questions (cohort_id, created_at desc);

-- ===========================================================================
-- 4. QUESTION_DIGESTS — las 3 preguntas que resumen la semana
-- ===========================================================================
create table if not exists public.question_digests (
  id            uuid primary key default gen_random_uuid(),
  cohort_id     uuid not null references public.cohorts(id) on delete cascade,
  week_start    date not null,
  questions     jsonb not null,
  source_count  integer not null default 0,
  generated_by  uuid references public.profiles(id) on delete set null,
  generated_at  timestamptz not null default now(),
  unique (cohort_id, week_start),
  constraint question_digests_tres check (
    jsonb_typeof(questions) = 'array' and jsonb_array_length(questions) between 1 and 5
  )
);

comment on table public.question_digests is
  'Las 3 preguntas que cubren lo más repetido de las dudas de la semana. Al modelo solo se le mandan los TEXTOS, nunca nombres ni cédulas.';

-- ===========================================================================
-- 5. MODULE_COMPETENCIES — lista, sin estado. En Fase 0 no se califican.
-- ===========================================================================
create table if not exists public.module_competencies (
  id          uuid primary key default gen_random_uuid(),
  module_id   uuid not null references public.modules(id) on delete cascade,
  position    integer not null,
  title       text not null,
  description text,
  created_at  timestamptz not null default now(),
  unique (module_id, position)
);

comment on table public.module_competencies is
  'Qué se aprende en el módulo. LISTA, sin estado de dominio: el estado necesita notas y en Fase 0 no hay.';

-- ===========================================================================
-- 6. RLS — REGLA 1. Toda tabla nueva nace con aislamiento y políticas.
-- ===========================================================================
alter table public.cases               enable row level security;
alter table public.case_attempts       enable row level security;
alter table public.student_questions   enable row level security;
alter table public.question_digests    enable row level security;
alter table public.module_competencies enable row level security;

-- --- CASES ----------------------------------------------------------------
-- El estudiante ve los de su cohorte, APROBADOS y con fecha llegada.
-- Las tres condiciones importan: sin `approved_at` se filtraría un borrador;
-- sin `publish_on <= today` vería el caso de mañana.
create policy cases_estudiante_lee on public.cases
  for select to authenticated
  using (
    public.is_student()
    and approved_at is not null
    and publish_on <= current_date
    and (cohort_id is null or cohort_id = public.my_cohort_id())
  );

create policy cases_profesor_lee on public.cases
  for select to authenticated
  using (
    public.auth_role() = 'profesor'
    and (cohort_id is null or public.teaches_cohort(cohort_id))
  );

create policy cases_admin_todo on public.cases
  for all to authenticated
  using (public.is_admin_up()) with check (public.is_admin_up());

-- --- CASE_ATTEMPTS --------------------------------------------------------
-- El estudiante: solo las suyas, y solo las puede crear a su propio nombre.
create policy case_attempts_estudiante on public.case_attempts
  for all to authenticated
  using (student_id = auth.uid())
  with check (student_id = auth.uid());

-- ⚠️ EL PROFESOR NO TIENE POLÍTICA DE LECTURA AQUÍ. ES INTENCIONAL.
-- Se decidió que ve el CONTEO y no los nombres (fase0/00_LEEME.md §4.2).
-- Eso NO se resuelve ocultando una columna en la pantalla: si pudiera leer las
-- filas, bastaría con abrir la consola del navegador para ver quién hizo qué.
-- Se resuelve aquí, no dejándole leer ni una fila, y dándole la vista agregada
-- `v_casos_conteo` de más abajo.

create policy case_attempts_admin on public.case_attempts
  for select to authenticated
  using (public.is_admin_up());

-- --- STUDENT_QUESTIONS ----------------------------------------------------
create policy student_questions_estudiante_lee on public.student_questions
  for select to authenticated
  using (student_id = auth.uid());

create policy student_questions_estudiante_crea on public.student_questions
  for insert to authenticated
  with check (student_id = auth.uid() and cohort_id = public.my_cohort_id());

create policy student_questions_profesor on public.student_questions
  for select to authenticated
  using (public.auth_role() = 'profesor' and public.teaches_cohort(cohort_id));

create policy student_questions_admin on public.student_questions
  for all to authenticated
  using (public.is_admin_up()) with check (public.is_admin_up());

-- --- QUESTION_DIGESTS -----------------------------------------------------
-- El estudiante NO lo ve: es el guion del profesor, no material del alumno.
create policy question_digests_profesor on public.question_digests
  for select to authenticated
  using (public.auth_role() = 'profesor' and public.teaches_cohort(cohort_id));

create policy question_digests_admin on public.question_digests
  for all to authenticated
  using (public.is_admin_up()) with check (public.is_admin_up());

-- --- MODULE_COMPETENCIES --------------------------------------------------
-- Cualquiera autenticado las lee: no hay nada sensible en «qué se aprende».
create policy module_competencies_lee on public.module_competencies
  for select to authenticated using (true);

create policy module_competencies_admin on public.module_competencies
  for all to authenticated
  using (public.is_admin_up()) with check (public.is_admin_up());

-- ===========================================================================
-- 7. LA VISTA AGREGADA DEL PROFESOR
--    Números, nunca nombres. Es la contraparte de no darle lectura a
--    case_attempts.
-- ===========================================================================
create or replace view public.v_casos_conteo
with (security_invoker = true) as
select
  c.id            as case_id,
  c.cohort_id,
  c.publish_on,
  c.title,
  count(a.id) filter (where a.completed_at is not null) as completados,
  count(a.id)                                            as iniciados
from public.cases c
left join public.case_attempts a on a.case_id = c.id
group by c.id, c.cohort_id, c.publish_on, c.title;

comment on view public.v_casos_conteo is
  'Cuántos trabajaron cada caso. SIN nombres. security_invoker = true para que respete el aislamiento de quien consulta.';

-- ⚠️ `security_invoker = true` NO ES OPCIONAL.
-- Sin él la vista correría con los permisos de quien la creó y se saltaría
-- las políticas del que consulta. Es exactamente el hallazgo de nivel ERROR
-- que hoy tienen v_students, v_exam_questions_student y
-- v_feedback_session_summary. No se repite aquí.

commit;

-- ============================================================================
-- COMPROBACIONES DESPUÉS DE APLICAR
--
-- 1. Ninguna tabla sin RLS:
--      select tablename from pg_tables
--       where schemaname='public' and rowsecurity = false;
--    -> debe devolver 0 filas
--
-- 2. Ninguna tabla con RLS y sin política:
--      select c.relname from pg_class c
--       join pg_namespace n on n.oid=c.relnamespace
--       where n.nspname='public' and c.relrowsecurity
--         and not exists (select 1 from pg_policy p where p.polrelid=c.oid);
--    -> no debe aparecer ninguna de las cinco tablas nuevas
--
-- 3. npm run test:rls
-- 4. Linter de seguridad: 0 hallazgos de nivel ERROR
--
-- REVERSIÓN COMPLETA
--   drop view if exists public.v_casos_conteo;
--   drop table if exists public.question_digests, public.student_questions,
--                        public.case_attempts, public.cases,
--                        public.module_competencies cascade;
-- ============================================================================
