-- ============================================================================
-- 034_qr_un_solo_uso.sql
--
-- QUÉ HACE: crea la tabla `qr_codes` con el modelo de UN SOLO USO y retira la
--           configuración del modelo rotativo anterior.
--
-- POR QUÉ:  spec/00_RECONCILIACION.md §5 decidió que ADMINISTRACIÓN muestra el
--           código en pantalla y EL ESTUDIANTE lo escanea. El código muere al
--           usarse. Lo que está hoy en zr-prod es el modelo contrario: el
--           estudiante lleva un TOTP rotativo y el profesor lo escanea a él.
--           Ver plan/01_ESTADO.md §5.2.
--
-- REVERSIÓN: `drop table public.qr_codes;` y volver a insertar las dos claves
--            de system_config que se borran abajo. Los datos de qr_codes son
--            desechables — son códigos de un solo uso ya consumidos.
--
-- VERIFICADO CONTRA: esquema real de zr-prod, 24 de agosto de 2026.
--   Reutiliza las funciones auxiliares que YA EXISTEN en la base:
--   is_student() · is_staff() · is_admin_up() · my_cohort_id() · teaches_cohort()
-- ============================================================================

begin;

-- ---------------------------------------------------------------------------
-- 1. LA TABLA
-- ---------------------------------------------------------------------------
create table if not exists public.qr_codes (
  id          uuid primary key default gen_random_uuid(),
  session_id  uuid not null references public.class_sessions(id) on delete cascade,
  code        text not null unique,
  used        boolean not null default false,
  used_at     timestamptz,
  used_by     uuid references public.profiles(id) on delete set null,
  created_at  timestamptz not null default now(),

  -- Un código usado tiene que decir cuándo y por quién. Un código sin usar, no.
  constraint qr_codes_uso_coherente check (
    (used = false and used_at is null and used_by is null) or
    (used = true  and used_at is not null)
  )
);

comment on table public.qr_codes is
  'Códigos de asistencia de un solo uso. Administración los muestra en pantalla; el estudiante los escanea. Al usarse mueren y se genera otro.';

-- ---------------------------------------------------------------------------
-- 2. EL ÍNDICE QUE HACE CUMPLIR LA REGLA
-- ---------------------------------------------------------------------------
-- Como máximo UN código sin usar por sesión, garantizado por la base.
-- Esto es lo que hace imposible que dos estudiantes usen el mismo código.
-- NO se resuelve en el código de la aplicación: se resuelve aquí.
create unique index if not exists qr_codes_uno_vivo_por_sesion
  on public.qr_codes (session_id)
  where used = false;

create index if not exists qr_codes_session_used_idx
  on public.qr_codes (session_id, used);

-- ---------------------------------------------------------------------------
-- 3. RLS — REGLA 1 DEL PROYECTO
-- ---------------------------------------------------------------------------
alter table public.qr_codes enable row level security;

-- El ESTUDIANTE no lee esta tabla NUNCA de forma directa. Escanea un código y
-- se lo manda a la Edge Function `validate-scan`, que lo valida del lado
-- servidor. Si el estudiante pudiera leer la tabla, podría sacar el código sin
-- escanear nada — y todo el modelo de un solo uso dejaría de servir.
-- Por eso NO hay política de lectura para estudiantes. Es intencional.

-- Administración y dirección: ven los códigos de cualquier sesión.
create policy qr_codes_admin_todo on public.qr_codes
  for all to authenticated
  using (public.is_admin_up())
  with check (public.is_admin_up());

-- El profesor: solo lectura, y solo de las sesiones de su cohorte.
-- No los crea ni los consume: en el modelo decidido el profesor no maneja
-- ningún código, solo ve el conteo de asistentes.
create policy qr_codes_profesor_lee on public.qr_codes
  for select to authenticated
  using (
    public.auth_role() = 'profesor'
    and exists (
      select 1 from public.class_sessions s
      where s.id = qr_codes.session_id
        and public.teaches_cohort(s.cohort_id)
    )
  );

-- ---------------------------------------------------------------------------
-- 4. RETIRAR LA CONFIGURACIÓN DEL MODELO VIEJO
-- ---------------------------------------------------------------------------
-- Estas dos claves son del QR rotativo con ventana de 30 segundos. Ese modelo
-- quedó descartado. Dejarlas invita a que alguien las vuelva a usar.
delete from public.system_config
 where key in ('attendance.qr_window_seconds', 'attendance.qr_drift_tolerance');

-- La nueva regla, explícita y consultable.
insert into public.system_config (key, value, description, is_public)
values (
  'qr.un_solo_uso',
  'true'::jsonb,
  'El código de asistencia muere al escanearse y se genera otro al instante. Fotografiarlo y reenviarlo no sirve.',
  true
)
on conflict (key) do update
  set value = excluded.value,
      description = excluded.description;

commit;

-- ============================================================================
-- DESPUÉS DE APLICAR ESTA MIGRACIÓN, FALTA:
--
--   1. Reescribir la Edge Function `validate-scan` — la desplegada valida TOTP
--      y exige que quien llame sea profesor. Contrato nuevo en 03_CONTRATOS.md
--   2. Retirar o reescribir `provision-qr` — genera el secreto TOTP del
--      estudiante, que en este modelo ya no existe
--   3. Correr `npm run test:rls`
--   4. Correr el linter de seguridad y confirmar 0 hallazgos de nivel ERROR
-- ============================================================================
