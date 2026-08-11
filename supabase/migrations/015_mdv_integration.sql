-- =============================================================================
-- ZR APP · MIGRACIÓN 015 · Integración del Modelo de Dominio Verificado (MDV)
-- =============================================================================
-- Añade las tablas, enums, vistas y triggers para implementar la metodología
-- MDV dentro de ZR App. El MDV se centra en:
--
--   1. COMPUERTA A: el trabajo semanal (lun-vie) habilita el acceso al sábado.
--   2. EVALUACIÓN POR RÚBRICA CON ÍTEMS CRÍTICOS: un solo ítem crítico que
--      falle = competencia "requiere refuerzo", sin importar el puntaje total.
--   3. DEFENSA TÉCNICA: 3 preguntas sorteadas de un banco de 10.
--   4. PASAPORTE DE COMPETENCIAS: visual, con colores (verde/amarillo/rojo).
--   5. TICKET DE REFLEXIÓN: cierre obligatorio del sábado.
--
-- REGLA DE NEGOCIO INVIOLABLE:
--   El trabajo digital vale 0% de la nota y habilita la compuerta del sábado.
--   El sábado presencial vale 100%. Esta regla se implementa como lógica de
--   negocio en el backend: el carril abierto NUNCA aporta puntos al total.
--
-- Referencia: Metodologia/MDV_Documento_Tecnico_Arquitectura_LowCode.md
-- =============================================================================

-- =============================================================================
-- PARTE 1 · NUEVOS TIPOS ENUMERADOS
-- =============================================================================

-- Nivel de IA permitido por actividad.
-- N0 = sin IA, N1 = tutor, N2 = asistente, N3 = copiloto, N4 = objeto de auditoría.
create type public.ia_level as enum ('N0','N1','N2','N3','N4');

-- Días del carril abierto (lunes a viernes).
create type public.weekday as enum (
  'lunes','martes','miercoles','jueves','viernes'
);

-- Tipos de actividad del carril abierto.
create type public.activity_type as enum (
  'microleccion',
  'simulacion',
  'caso_simulado',
  'duda_obligatoria',
  'clinica_errores',
  'autochequeo'
);

-- Estado del progreso semanal del estudiante (compuerta A).
create type public.weekly_status as enum (
  'en_progreso',
  'completado',
  'incompleto',
  'refuerzo'
);

-- Resultado de la evaluación de desempeño del sábado.
-- Es distinto de mastery_status: este describe el resultado de UNA evaluación,
-- mastery_status describe el estado acumulativo de la competencia.
create type public.eval_outcome as enum (
  'dominada',
  'en_desarrollo',
  'requiere_refuerzo'
);

-- Nivel alcanzado en la defensa técnica.
create type public.defense_level as enum (
  'nivel_1',  -- acepta o rechaza sin explicar
  'nivel_2',  -- identifica 2-3 errores
  'nivel_3',  -- identifica 4+ errores incluyendo seguridad
  'nivel_4'   -- identifica 5-6 errores, propone medición para cada uno
);

-- Roles rotativos del taller del sábado.
create type public.workshop_role as enum (
  'operador',
  'inspector_calidad',
  'documentador',
  'responsable_seguridad'
);

-- Agregar 'requiere_refuerzo' al enum existente de mastery_status.
-- 'en_progreso' ya existe y cubre el concepto MDV de 'en desarrollo'.
alter type public.mastery_status add value if not exists 'requiere_refuerzo';

-- Agregar fuente 'defensa_tecnica' al enum de mastery_source.
alter type public.mastery_source add value if not exists 'defensa_tecnica';
alter type public.mastery_source add value if not exists 'evaluacion_rubrica';

-- =============================================================================
-- PARTE 2 · CARRIL ABIERTO: ACTIVIDADES SEMANALES (lunes a viernes)
-- =============================================================================
-- Tabla de configuración: define QUÉ actividades hay cada día de cada semana.
-- El instructor las configura una vez por módulo. Son las mismas para toda la
-- cohorte. El contenido específico (URLs de videos, preguntas) va en el jsonb.

create table public.weekly_activities (
  id                  uuid primary key default gen_random_uuid(),
  learning_guide_id   uuid not null references public.learning_guides(id) on delete cascade,
  day_of_week         public.weekday not null,
  activity_type       public.activity_type not null,
  order_index         int not null default 1,
  title               text not null,
  description         text,
  duration_minutes    int not null check (duration_minutes > 0),
  ia_level            public.ia_level not null default 'N0',
  is_gate_requirement boolean not null default true,
  content_config      jsonb not null default '{}',
  -- content_config examples:
  --   microleccion: {"video_url": "...", "embedded_questions": [...]}
  --   simulacion:   {"simulator_url": "...", "scenario_id": "..."}
  --   duda:         {"min_characters": 50}
  --   autochequeo:  {"question_bank_id": "...", "num_questions": 8}
  created_at          timestamptz not null default now(),
  unique (learning_guide_id, day_of_week, order_index)
);

comment on table public.weekly_activities is
  'Actividades del carril abierto (lun-vie). Configuración, no instancia.';
comment on column public.weekly_activities.is_gate_requirement is
  'Si es true, completar esta actividad es requisito para la compuerta A del sábado.';

create index idx_wa_guide on public.weekly_activities (learning_guide_id);

alter table public.weekly_activities enable row level security;

-- Todos ven las actividades de su módulo; solo personal crea/edita.
create policy "todos: leer actividades de su módulo"
  on public.weekly_activities for select to authenticated
  using (
    learning_guide_id in (
      select lg.id from public.learning_guides lg
      where lg.module_id = (select public.my_module_id())
    )
    or (select public.is_staff())
  );

create policy "personal: gestionar actividades"
  on public.weekly_activities for all to authenticated
  using ((select public.is_staff()))
  with check ((select public.is_staff()));

grant select, insert, update, delete on public.weekly_activities to authenticated;

-- =============================================================================
-- PARTE 3 · SEGUIMIENTO DE ACTIVIDADES Y COMPUERTA A
-- =============================================================================

-- Registro de cada actividad completada por cada estudiante.
create table public.activity_completions (
  id                  uuid primary key default gen_random_uuid(),
  student_id          uuid not null references public.students(id) on delete cascade,
  activity_id         uuid not null references public.weekly_activities(id) on delete cascade,
  completed_at        timestamptz not null default now(),
  score               int,           -- para autochequeos: puntaje obtenido
  max_score           int,           -- para autochequeos: puntaje máximo
  response_data       jsonb,         -- respuestas de dudas, autochequeos, etc.
  created_at          timestamptz not null default now(),
  unique (student_id, activity_id)   -- un solo registro por estudiante/actividad
);

create index idx_ac_student on public.activity_completions (student_id);

alter table public.activity_completions enable row level security;

create policy "estudiante: ver sus completaciones"
  on public.activity_completions for select to authenticated
  using (student_id = auth.uid());

create policy "estudiante: registrar sus completaciones"
  on public.activity_completions for insert to authenticated
  with check (student_id = auth.uid());

create policy "personal: ver completaciones de su cohorte"
  on public.activity_completions for select to authenticated
  using ((select public.can_see_student(student_id)));

grant select, insert on public.activity_completions to authenticated;

-- Progreso semanal agregado: la compuerta A.
-- Una fila por estudiante por sesión de clase (sábado).
-- Se calcula automáticamente basado en activity_completions.
create table public.weekly_progress (
  id                      uuid primary key default gen_random_uuid(),
  student_id              uuid not null references public.students(id) on delete cascade,
  session_id              uuid not null references public.class_sessions(id) on delete cascade,
  activities_completed    int not null default 0,
  activities_required     int not null default 0,
  self_check_score        int,          -- puntaje del autochequeo del viernes
  self_check_max          int default 8,
  doubt_submitted         boolean not null default false,
  gate_closed_at          timestamptz,  -- cuando se cerró la compuerta (viernes 22:00)
  saturday_enabled        boolean not null default false,
  status                  public.weekly_status not null default 'en_progreso',
  created_at              timestamptz not null default now(),
  updated_at              timestamptz not null default now(),
  unique (student_id, session_id)
);

comment on table public.weekly_progress is
  'Compuerta A: seguimiento semanal. saturday_enabled = true si el estudiante completó '
  'todas las actividades requeridas y pasó el autochequeo. NUNCA se pone en true manualmente.';

create index idx_wp_student on public.weekly_progress (student_id);
create index idx_wp_session on public.weekly_progress (session_id);

create trigger trg_wp_updated
  before update on public.weekly_progress
  for each row execute function public.set_updated_at();

create trigger trg_wp_audit
  after insert or update or delete on public.weekly_progress
  for each row execute function public.fn_audit();

-- Trigger: calcular saturday_enabled automáticamente.
-- Regla: todas las actividades requeridas completadas + autochequeo >= 5/8.
-- El umbral del autochequeo viene de system_config.
create or replace function public.fn_calculate_gate_a()
returns trigger
language plpgsql
as $$
declare
  v_threshold int;
begin
  v_threshold := public.cfg_int('mdv.self_check_threshold', 5);

  if new.activities_completed >= new.activities_required
     and new.self_check_score is not null
     and new.self_check_score >= v_threshold
     and new.doubt_submitted = true then
    new.saturday_enabled := true;
    new.status := 'completado';
  elsif new.gate_closed_at is not null then
    -- La compuerta ya cerró y no cumplió
    new.saturday_enabled := false;
    new.status := 'refuerzo';
  end if;

  return new;
end;
$$;

create trigger trg_calculate_gate_a
  before insert or update on public.weekly_progress
  for each row execute function public.fn_calculate_gate_a();

alter table public.weekly_progress enable row level security;

create policy "estudiante: ver su progreso"
  on public.weekly_progress for select to authenticated
  using (student_id = auth.uid());

create policy "personal: ver progreso de su cohorte"
  on public.weekly_progress for select to authenticated
  using ((select public.can_see_student(student_id)));

create policy "personal: gestionar progreso"
  on public.weekly_progress for all to authenticated
  using ((select public.is_staff()))
  with check ((select public.is_staff()));

-- El estudiante no escribe directamente: las Edge Functions actualizan
-- weekly_progress cuando el estudiante completa actividades.
grant select on public.weekly_progress to authenticated;
grant insert, update, delete on public.weekly_progress to authenticated;

-- =============================================================================
-- PARTE 4 · RÚBRICAS CON ÍTEMS CRÍTICOS
-- =============================================================================
-- Esta es la parte más importante de la integración MDV.
-- Un ítem crítico que falle = competencia "requiere refuerzo", sin importar
-- el puntaje total. Esto se logra con la aritmética de la rúbrica:
--   4 ítems críticos × 20 puntos = 80 puntos
--   8 ítems normales × 2.5 puntos = 20 puntos
--   Total: 100 puntos. Aprueba con 81.
--   → Fallar un solo crítico da máximo 80 → reprobado automáticamente.

create table public.rubric_templates (
  id                uuid primary key default gen_random_uuid(),
  learning_guide_id uuid not null references public.learning_guides(id) on delete cascade,
  name              text not null,
  description       text,
  total_points      int not null default 100,
  passing_score     int not null default 81,
  max_attempts      int,          -- null = sin límite (repetir no castiga)
  created_by        uuid references public.teachers(id),
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

comment on table public.rubric_templates is
  'Plantilla de rúbrica para evaluación de desempeño. Cada competencia (learning_guide) '
  'tiene una rúbrica. Los ítems críticos pesan 20 pts cada uno, los normales 2.5 pts.';
comment on column public.rubric_templates.passing_score is
  'Nota de aprobación. 81 hace que fallar un solo ítem crítico (20 pts) sea reprobatorio '
  'automáticamente: máximo alcanzable sería 80 < 81.';

create index idx_rt_guide on public.rubric_templates (learning_guide_id);

create trigger trg_rt_updated
  before update on public.rubric_templates
  for each row execute function public.set_updated_at();

alter table public.rubric_templates enable row level security;

create policy "todos: leer rúbricas"
  on public.rubric_templates for select to authenticated
  using (true);

create policy "personal: gestionar rúbricas"
  on public.rubric_templates for all to authenticated
  using ((select public.is_staff()))
  with check ((select public.is_staff()));

grant select, insert, update, delete on public.rubric_templates to authenticated;

-- Criterios individuales de la rúbrica.
create table public.rubric_criteria (
  id                  uuid primary key default gen_random_uuid(),
  rubric_template_id  uuid not null references public.rubric_templates(id) on delete cascade,
  order_index         int not null,
  description         text not null,
  is_critical         boolean not null default false,
  max_points          numeric(5,2) not null,
  -- Típicamente: is_critical=true → max_points=20, is_critical=false → max_points=2.5
  created_at          timestamptz not null default now(),
  unique (rubric_template_id, order_index)
);

comment on column public.rubric_criteria.is_critical is
  'Ítem crítico de seguridad o calidad. Si is_critical=true y cumple=false, '
  'la competencia es automáticamente "requiere_refuerzo" sin importar el total.';

create index idx_rc_template on public.rubric_criteria (rubric_template_id);

alter table public.rubric_criteria enable row level security;

create policy "todos: leer criterios"
  on public.rubric_criteria for select to authenticated
  using (true);

create policy "personal: gestionar criterios"
  on public.rubric_criteria for all to authenticated
  using ((select public.is_staff()))
  with check ((select public.is_staff()));

grant select, insert, update, delete on public.rubric_criteria to authenticated;

-- =============================================================================
-- PARTE 5 · EVALUACIÓN DE DESEMPEÑO (sábado)
-- =============================================================================
-- El instructor evalúa a cada estudiante usando la rúbrica en la tablet.
-- Es la ÚNICA evaluación que produce nota y que mueve el pasaporte.

create table public.performance_evaluations (
  id                  uuid primary key default gen_random_uuid(),
  session_id          uuid not null references public.class_sessions(id) on delete cascade,
  student_id          uuid not null references public.students(id) on delete cascade,
  learning_guide_id   uuid not null references public.learning_guides(id),
  rubric_template_id  uuid not null references public.rubric_templates(id),
  attempt_number      int not null default 1 check (attempt_number >= 1),
  total_score         numeric(5,2),
  critical_items_ok   boolean,
  outcome             public.eval_outcome,
  video_evidence_url  text,           -- URL en Supabase Storage
  evaluated_by        uuid not null references public.teachers(id),
  evaluated_at        timestamptz not null default now(),
  notes               text,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);

comment on table public.performance_evaluations is
  'Evaluación de desempeño del sábado. Es la ÚNICA fuente de nota. '
  'Si critical_items_ok = false → outcome = requiere_refuerzo automáticamente.';
comment on column public.performance_evaluations.attempt_number is
  'Número de intento. Repetir NO castiga: la nota es el estado de dominio, no un promedio.';

create index idx_pe_session   on public.performance_evaluations (session_id);
create index idx_pe_student   on public.performance_evaluations (student_id);
create index idx_pe_guide     on public.performance_evaluations (learning_guide_id);

create trigger trg_pe_updated
  before update on public.performance_evaluations
  for each row execute function public.set_updated_at();

create trigger trg_pe_audit
  after insert or update or delete on public.performance_evaluations
  for each row execute function public.fn_audit();

alter table public.performance_evaluations enable row level security;

create policy "estudiante: ver sus evaluaciones"
  on public.performance_evaluations for select to authenticated
  using (student_id = auth.uid());

create policy "personal: ver evaluaciones de su cohorte"
  on public.performance_evaluations for select to authenticated
  using ((select public.can_see_student(student_id)));

create policy "personal: crear evaluaciones"
  on public.performance_evaluations for insert to authenticated
  with check ((select public.is_staff()));

create policy "personal: actualizar evaluaciones"
  on public.performance_evaluations for update to authenticated
  using ((select public.is_staff()))
  with check ((select public.is_staff()));

grant select, insert, update on public.performance_evaluations to authenticated;

-- Resultados por criterio de la evaluación.
create table public.eval_criteria_results (
  id                  uuid primary key default gen_random_uuid(),
  evaluation_id       uuid not null references public.performance_evaluations(id) on delete cascade,
  criterion_id        uuid not null references public.rubric_criteria(id),
  meets_criterion     boolean not null,
  awarded_points      numeric(5,2) not null,
  observation         text,
  created_at          timestamptz not null default now(),
  unique (evaluation_id, criterion_id)
);

create index idx_ecr_eval on public.eval_criteria_results (evaluation_id);

alter table public.eval_criteria_results enable row level security;

create policy "estudiante: ver sus resultados"
  on public.eval_criteria_results for select to authenticated
  using (
    evaluation_id in (
      select id from public.performance_evaluations where student_id = auth.uid()
    )
  );

create policy "personal: gestionar resultados"
  on public.eval_criteria_results for all to authenticated
  using ((select public.is_staff()))
  with check ((select public.is_staff()));

grant select, insert, update on public.eval_criteria_results to authenticated;

-- -----------------------------------------------------------------------------
-- Trigger: calcular outcome de la evaluación basado en criterios.
-- REGLA MDV: si CUALQUIER ítem crítico falla → requiere_refuerzo.
-- Si todos los críticos pasan pero puntaje < passing_score → en_desarrollo.
-- Si todos los críticos pasan y puntaje >= passing_score → dominada.
-- -----------------------------------------------------------------------------
create or replace function public.fn_calculate_eval_outcome()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_total         numeric;
  v_passing       int;
  v_critical_fail boolean;
  v_all_graded    boolean;
begin
  -- Verificar si todos los criterios ya tienen resultado
  select
    count(*) = (select count(*) from public.rubric_criteria where rubric_template_id = new.rubric_template_id),
    coalesce(sum(ecr.awarded_points), 0),
    bool_or(rc.is_critical and not ecr.meets_criterion)
  into v_all_graded, v_total, v_critical_fail
  from public.eval_criteria_results ecr
  join public.rubric_criteria rc on rc.id = ecr.criterion_id
  where ecr.evaluation_id = new.evaluation_id;

  if not v_all_graded then
    return new;
  end if;

  -- Obtener nota de aprobación
  select rt.passing_score into v_passing
  from public.rubric_templates rt
  join public.performance_evaluations pe on pe.rubric_template_id = rt.id
  where pe.id = new.evaluation_id;

  -- Actualizar la evaluación
  update public.performance_evaluations set
    total_score = v_total,
    critical_items_ok = not coalesce(v_critical_fail, false),
    outcome = case
      when coalesce(v_critical_fail, false) then 'requiere_refuerzo'::public.eval_outcome
      when v_total < v_passing then 'en_desarrollo'::public.eval_outcome
      else 'dominada'::public.eval_outcome
    end
  where id = new.evaluation_id;

  return new;
end;
$$;

create trigger trg_calculate_eval_outcome
  after insert or update on public.eval_criteria_results
  for each row execute function public.fn_calculate_eval_outcome();

-- -----------------------------------------------------------------------------
-- Trigger: actualizar mastery_map cuando se calcula el outcome.
-- Cuando una evaluación llega a un outcome definitivo, actualiza el pasaporte.
-- La nota del mejor intento manda: repetir no castiga.
-- -----------------------------------------------------------------------------
create or replace function public.fn_sync_mastery_from_eval()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_mastery_status public.mastery_status;
begin
  if new.outcome is null then
    return new;
  end if;

  -- Mapear eval_outcome → mastery_status
  v_mastery_status := case new.outcome
    when 'dominada'           then 'dominado'::public.mastery_status
    when 'en_desarrollo'      then 'en_progreso'::public.mastery_status
    when 'requiere_refuerzo'  then 'requiere_refuerzo'::public.mastery_status
  end;

  -- Solo actualizar si mejora el estado actual (dominado > en_progreso > requiere_refuerzo > no_iniciado)
  -- o si no existe registro previo.
  insert into public.mastery_map (student_id, learning_guide_id, status, dominated_via, marked_by, marked_at)
  values (
    new.student_id,
    new.learning_guide_id,
    v_mastery_status,
    case when new.outcome = 'dominada' then 'evaluacion_rubrica'::public.mastery_source else null end,
    new.evaluated_by,
    case when new.outcome = 'dominada' then now() else null end
  )
  on conflict (student_id, learning_guide_id) do update set
    status = case
      -- Solo mejorar, nunca degradar (el mejor intento manda)
      when excluded.status = 'dominado' then 'dominado'
      when public.mastery_map.status = 'dominado' then 'dominado'
      when excluded.status = 'en_progreso' then 'en_progreso'
      else excluded.status
    end::public.mastery_status,
    dominated_via = case
      when excluded.status = 'dominado' then 'evaluacion_rubrica'::public.mastery_source
      else public.mastery_map.dominated_via
    end,
    marked_by = case
      when excluded.status = 'dominado' then new.evaluated_by
      else public.mastery_map.marked_by
    end,
    marked_at = case
      when excluded.status = 'dominado' then now()
      else public.mastery_map.marked_at
    end;

  return new;
end;
$$;

create trigger trg_sync_mastery
  after update of outcome on public.performance_evaluations
  for each row
  when (new.outcome is not null and old.outcome is distinct from new.outcome)
  execute function public.fn_sync_mastery_from_eval();

-- =============================================================================
-- PARTE 6 · DEFENSA TÉCNICA
-- =============================================================================

-- Banco de preguntas de defensa por competencia.
create table public.defense_questions (
  id                uuid primary key default gen_random_uuid(),
  learning_guide_id uuid not null references public.learning_guides(id) on delete cascade,
  question_text     text not null,
  expected_level    public.defense_level not null default 'nivel_3',
  active            boolean not null default true,
  created_at        timestamptz not null default now()
);

comment on table public.defense_questions is
  'Banco de 10+ preguntas por competencia. Se sortean 3 para cada defensa técnica.';

create index idx_dq_guide on public.defense_questions (learning_guide_id);

alter table public.defense_questions enable row level security;

create policy "todos: leer preguntas activas"
  on public.defense_questions for select to authenticated
  using (true);

create policy "personal: gestionar preguntas"
  on public.defense_questions for all to authenticated
  using ((select public.is_staff()))
  with check ((select public.is_staff()));

grant select, insert, update, delete on public.defense_questions to authenticated;

-- Resultado de la defensa técnica.
create table public.technical_defenses (
  id                  uuid primary key default gen_random_uuid(),
  evaluation_id       uuid not null references public.performance_evaluations(id) on delete cascade,
  questions_drawn     uuid[] not null,  -- 3 IDs de defense_questions
  responses           jsonb,            -- [{"question_id":"...","response":"...","score":3}]
  level_achieved      public.defense_level not null,
  evaluated_by        uuid not null references public.teachers(id),
  duration_seconds    int,
  notes               text,
  created_at          timestamptz not null default now(),
  unique (evaluation_id)   -- una defensa por evaluación
);

comment on table public.technical_defenses is
  'Defensa técnica oral. Si level_achieved = nivel_1 → competencia NO dominada, '
  'sin importar la rúbrica. Dura ~5 min.';

create index idx_td_eval on public.technical_defenses (evaluation_id);

alter table public.technical_defenses enable row level security;

create policy "estudiante: ver su defensa"
  on public.technical_defenses for select to authenticated
  using (
    evaluation_id in (
      select id from public.performance_evaluations where student_id = auth.uid()
    )
  );

create policy "personal: gestionar defensas"
  on public.technical_defenses for all to authenticated
  using ((select public.is_staff()))
  with check ((select public.is_staff()));

grant select, insert, update on public.technical_defenses to authenticated;

-- -----------------------------------------------------------------------------
-- Trigger: si la defensa es nivel_1, forzar outcome a requiere_refuerzo.
-- REGLA MDV: defensa nivel 1 + punto crítico mal → NO DOMINADA.
-- Defensa nivel 1 sola ya es suficiente para bloquear.
-- -----------------------------------------------------------------------------
create or replace function public.fn_defense_blocks_mastery()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.level_achieved = 'nivel_1' then
    update public.performance_evaluations
    set outcome = 'requiere_refuerzo'
    where id = new.evaluation_id
      and outcome is distinct from 'requiere_refuerzo';
  end if;
  return new;
end;
$$;

create trigger trg_defense_blocks
  after insert or update of level_achieved on public.technical_defenses
  for each row execute function public.fn_defense_blocks_mastery();

-- =============================================================================
-- PARTE 7 · TICKET DE REFLEXIÓN (cierre del sábado)
-- =============================================================================

create table public.reflection_tickets (
  id                uuid primary key default gen_random_uuid(),
  student_id        uuid not null references public.students(id) on delete cascade,
  session_id        uuid not null references public.class_sessions(id) on delete cascade,
  before_thought    text not null,    -- "Antes pensaba..."
  now_understand    text not null,    -- "Ahora entiendo..."
  biggest_mistake   text not null,    -- "Mi mayor error..."
  next_time         text not null,    -- "La próxima vez..."
  created_at        timestamptz not null default now(),
  unique (student_id, session_id)
);

comment on table public.reflection_tickets is
  'Ticket de salida obligatorio del sábado. 4 campos de reflexión, ~3 minutos.';

alter table public.reflection_tickets enable row level security;

create policy "estudiante: ver sus tickets"
  on public.reflection_tickets for select to authenticated
  using (student_id = auth.uid());

create policy "estudiante: crear su ticket"
  on public.reflection_tickets for insert to authenticated
  with check (student_id = auth.uid());

create policy "personal: ver tickets de su cohorte"
  on public.reflection_tickets for select to authenticated
  using ((select public.can_see_student(student_id)));

grant select, insert on public.reflection_tickets to authenticated;

-- =============================================================================
-- PARTE 8 · ROLES ROTATIVOS DEL TALLER
-- =============================================================================

create table public.workshop_role_assignments (
  id                uuid primary key default gen_random_uuid(),
  session_id        uuid not null references public.class_sessions(id) on delete cascade,
  student_id        uuid not null references public.students(id) on delete cascade,
  station           int not null check (station >= 1),
  role              public.workshop_role not null,
  rotation          int not null default 1 check (rotation >= 1),
  created_at        timestamptz not null default now(),
  unique (session_id, student_id, rotation)
);

comment on table public.workshop_role_assignments is
  'Asignación automática de roles en las estaciones del taller del sábado.';

create index idx_wra_session on public.workshop_role_assignments (session_id);

alter table public.workshop_role_assignments enable row level security;

create policy "todos: ver asignaciones de su sesión"
  on public.workshop_role_assignments for select to authenticated
  using (
    session_id in (
      select cs.id from public.class_sessions cs
      join public.students s on s.cohort_id = cs.cohort_id
      where s.id = auth.uid()
    )
    or (select public.is_staff())
  );

create policy "personal: gestionar asignaciones"
  on public.workshop_role_assignments for all to authenticated
  using ((select public.is_staff()))
  with check ((select public.is_staff()));

grant select, insert, update, delete on public.workshop_role_assignments to authenticated;

-- =============================================================================
-- PARTE 9 · DECLARACIÓN DE USO DE IA (Nivel N3)
-- =============================================================================

create table public.ia_declarations (
  id                  uuid primary key default gen_random_uuid(),
  student_id          uuid not null references public.students(id) on delete cascade,
  activity_id         uuid references public.weekly_activities(id),
  session_id          uuid references public.class_sessions(id),
  tool_used           text not null,
  question_asked      text not null,
  response_received   text not null,
  accepted_because    text,
  corrected_because   text,
  verification        text,       -- ficha fabricante, medición, norma
  own_decision        text not null,
  created_at          timestamptz not null default now()
);

comment on table public.ia_declarations is
  'Declaración obligatoria de uso de IA (nivel N3). Sin declaración, la entrega se bloquea.';

create index idx_iad_student on public.ia_declarations (student_id);

alter table public.ia_declarations enable row level security;

create policy "estudiante: ver y crear sus declaraciones"
  on public.ia_declarations for select to authenticated
  using (student_id = auth.uid());

create policy "estudiante: crear declaración"
  on public.ia_declarations for insert to authenticated
  with check (student_id = auth.uid());

create policy "personal: ver declaraciones"
  on public.ia_declarations for select to authenticated
  using ((select public.can_see_student(student_id)));

grant select, insert on public.ia_declarations to authenticated;

-- =============================================================================
-- PARTE 10 · CONTROL DE ENTRADA (sábado 08:00)
-- =============================================================================
-- Se implementa reutilizando el sistema de exámenes existente (migración 007).
-- Se añade un campo exam_type para distinguir controles de entrada de exámenes
-- regulares. El control de entrada:
--   - 8 preguntas sorteadas de un banco de 20
--   - 20 minutos
--   - Solo un intento
--   - No cuenta para la nota, es requisito para continuar

-- Agregar tipo de examen al enum. No podemos alterar exam_status, pero podemos
-- agregar un campo a la tabla exams.
alter table public.exams add column if not exists
  exam_purpose text not null default 'evaluacion'
  check (exam_purpose in ('evaluacion','control_entrada','autochequeo','retencion'));

comment on column public.exams.exam_purpose is
  'Propósito del examen. control_entrada y autochequeo NO cuentan para la nota. '
  'evaluacion sí. retencion es para las pruebas de retención (semanas 6 y 12).';

-- =============================================================================
-- PARTE 11 · VISTAS MDV
-- =============================================================================

-- Vista: pasaporte de competencias del estudiante (versión MDV).
-- Extiende v_mi_dominio con datos de la última evaluación de desempeño.
create or replace view public.v_pasaporte_mdv
with (security_invoker = true)
as
select
  s.id                                          as student_id,
  lg.module_id,
  m.name                                        as module_name,
  lg.id                                         as learning_guide_id,
  lg.week_number,
  lg.order_in_week,
  lg.sub_competency_name,
  coalesce(mm.status, 'no_iniciado')            as mastery_status,
  mm.dominated_via,
  mm.marked_at,
  pe.outcome                                    as last_eval_outcome,
  pe.attempt_number                             as last_eval_attempt,
  pe.total_score                                as last_eval_score,
  pe.critical_items_ok                          as last_eval_critical_ok,
  td.level_achieved                             as last_defense_level,
  pe.evaluated_at                               as last_eval_date
from public.students s
join public.cohorts c        on c.id = s.cohort_id
join public.modules m        on m.id = c.current_module_id
join public.learning_guides lg on lg.module_id = m.id
left join public.mastery_map mm
       on mm.student_id = s.id and mm.learning_guide_id = lg.id
left join lateral (
  select pe2.*
  from public.performance_evaluations pe2
  where pe2.student_id = s.id and pe2.learning_guide_id = lg.id
  order by pe2.attempt_number desc
  limit 1
) pe on true
left join public.technical_defenses td on td.evaluation_id = pe.id
order by lg.week_number, lg.order_in_week;

grant select on public.v_pasaporte_mdv to authenticated;

-- Vista: estado de compuerta A por sesión.
-- El instructor la ve el sábado a las 07:50 para saber quién está habilitado.
create or replace view public.v_gate_a_status
with (security_invoker = true)
as
select
  cs.id                   as session_id,
  cs.session_date,
  cs.week_number,
  s.id                    as student_id,
  p.full_name,
  p.cedula,
  wp.activities_completed,
  wp.activities_required,
  wp.self_check_score,
  wp.doubt_submitted,
  wp.saturday_enabled,
  wp.status               as weekly_status
from public.class_sessions cs
join public.cohorts c on c.id = cs.cohort_id
join public.students s on s.cohort_id = c.id
join public.profiles p on p.id = s.id
left join public.weekly_progress wp
       on wp.student_id = s.id and wp.session_id = cs.id
order by cs.session_date desc, p.full_name;

grant select on public.v_gate_a_status to authenticated;

-- Vista: heatmap de errores del sábado (para el instructor).
-- Muestra qué criterios críticos se fallan más.
create or replace view public.v_error_heatmap
with (security_invoker = true)
as
select
  rc.description                              as criterion,
  rc.is_critical,
  lg.sub_competency_name                      as competency,
  count(*) filter (where not ecr.meets_criterion) as times_failed,
  count(*)                                    as times_evaluated,
  round(
    100.0 * count(*) filter (where not ecr.meets_criterion) / nullif(count(*), 0),
    1
  )                                           as failure_rate
from public.eval_criteria_results ecr
join public.rubric_criteria rc on rc.id = ecr.criterion_id
join public.rubric_templates rt on rt.id = rc.rubric_template_id
join public.learning_guides lg on lg.id = rt.learning_guide_id
group by rc.id, rc.description, rc.is_critical, lg.sub_competency_name
order by times_failed desc;

grant select on public.v_error_heatmap to authenticated;

-- =============================================================================
-- PARTE 12 · CONFIGURACIÓN MDV EN system_config
-- =============================================================================

insert into public.system_config (key, value, description) values
  ('mdv.self_check_threshold', '5', 'Puntaje mínimo del autochequeo (de 8) para pasar la compuerta A'),
  ('mdv.gate_close_time', '22:00', 'Hora de cierre de la compuerta A los viernes (hora local)'),
  ('mdv.gate_close_day', 'viernes', 'Día de cierre de la compuerta A'),
  ('mdv.rubric_passing_score', '81', 'Nota de aprobación por defecto de las rúbricas'),
  ('mdv.critical_item_points', '20', 'Puntos por ítem crítico de rúbrica'),
  ('mdv.normal_item_points', '2.5', 'Puntos por ítem normal de rúbrica'),
  ('mdv.defense_questions_draw', '3', 'Cantidad de preguntas sorteadas en la defensa técnica'),
  ('mdv.defense_questions_bank', '10', 'Mínimo de preguntas en el banco de defensa por competencia'),
  ('mdv.entry_control_questions', '8', 'Cantidad de preguntas en el control de entrada del sábado'),
  ('mdv.entry_control_time_minutes', '20', 'Tiempo del control de entrada en minutos'),
  ('mdv.reflection_ticket_required', 'true', 'Si el ticket de reflexión es obligatorio al final del sábado'),
  ('mdv.ia_tutor_url', '', 'URL del tutor de IA externo (proyecto Claude/GPT)'),
  ('mdv.ia_tutor_max_exchanges', '3', 'Máximo de intercambios por tema con el tutor IA antes de derivar al instructor'),
  ('mdv.video_evidence_max_seconds', '90', 'Duración máxima del video de evidencia de ejecución')
on conflict (key) do nothing;

-- =============================================================================
-- PARTE 13 · DATOS DE PRUEBA MDV
-- =============================================================================
-- Los datos de prueba completos van en seed_dev.sql.
-- Aquí solo se documentan los campos nuevos que deben poblarse.
--
-- Ver: supabase/seed/seed_dev_mdv.sql (se crea aparte)
