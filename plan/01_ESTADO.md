# 01 · ESTADO REAL DEL PROYECTO
> Revisado el 21 de agosto de 2026 contra el proyecto Supabase `zr-prod`.
> **Lee esto antes de escribir una sola línea de SQL.**

---

## 1. LA DIVERGENCIA

El repositorio y la base de datos son **dos versiones distintas del proyecto**.

| | Repositorio | Base de datos `zr-prod` |
|---|---|---|
| Última migración | **016** | **033** |
| Tablas | 40 definidas | 29 aplicadas + 6 vistas |
| Estado | Escritas, nunca aplicadas ahí | Vivas, con datos |

**El repositorio está 17 migraciones atrás.** Alguien construyó sobre esa base y el
repositorio no lo refleja.

⚠️ **`CLAUDE.md` dice que las 16 migraciones están "YA APLICADAS". No lo están** — al menos
no en `zr-prod`. Están escritas.

---

## 2. QUÉ TIENE CADA UNA

### 2.1 El núcleo compartido (27 tablas, sin discusión)

`profiles` · `students` · `teachers` · `admins` · `programs` · `modules` · `cohorts` ·
`class_sessions` · `module_enrollments` · `attendance_events` · `student_qr_secrets` ·
`exams` · `exam_questions` · `exam_attempts` · `exam_answers` · `content_items` ·
`content_views` · `learning_guides` · `mastery_map` · `feedback_micro` · `feedback_macro` ·
`notifications` · `push_subscriptions` · `parental_consents` · `system_config` ·
`system_config_history` · `audit_log`

### 2.2 Solo en la base — y hay que conservarlo

| Qué | Por qué importa |
|---|---|
| `professor_applications` | Postulaciones de profesores |
| `exam_rehabilitation_requests` | Solicitudes de recuperación de examen |
| 6 vistas | `v_students`, `v_students_blocked`, `v_mi_dominio`, `v_proximo_sabado`, `v_exam_questions_student`, `v_feedback_session_summary` |
| `module_enrollments` con 6 campos de nota | `theory_score`, `practice_score`, `participation_score`, `participation_weight`, `passing_threshold`, `final_score` |
| `exams.duration_minutes` | El cronómetro del examen |
| `attendance_events.snack_claimed_at` | El refrigerio con el mismo escaneo |

**El hallazgo que decide la discusión:** `module_enrollments` implementa exactamente el
modelo de notas de `spec/00` §2.2 — teoría y práctica por separado, participación con su
peso, umbral guardado por inscripción. **La base está más alineada con las decisiones que el
propio repositorio.**

### 2.3 Solo en el repositorio (13 tablas, todas de 015 y 016)

| Tabla | ¿Se trae? |
|---|---|
| `performance_evaluations` | ✅ **Sí** — sin ella no hay dónde guardar la evaluación del sábado |
| `rubric_templates`, `rubric_criteria` | ✅ **Sí** — el checklist con ítems críticos |
| `eval_criteria_results` | ✅ **Sí** — el resultado por ítem |
| `defense_questions` | ✅ **Sí** — el banco de preguntas |
| `technical_defenses` | ✅ **Sí** — el resultado de la defensa |
| `qr_codes` | ✅ **Sí** — el código de un solo uso |
| `weekly_activities`, `activity_completions` | ⚠️ Solo como registro, sin efecto vinculante |
| `weekly_progress` | ❌ **No** — es la compuerta bloqueante, descartada en `spec/00` §3 |
| `reflection_tickets` | ❌ No entra en el MVP |
| `workshop_role_assignments` | ❌ No entra en el MVP |
| `ia_declarations` | ❌ No entra en el MVP |

⚠️ **La migración 015 trae las tablas que sirven junto con umbrales que NO van.** Define
rúbrica sobre 100 con aprobación en 81 y la compuerta bloqueante. **Se copian las tablas, no
los umbrales.** Ver `spec/00` §2.4.1 para los valores correctos.

---

## 3. LOS DATOS QUE HAY (son de prueba)

| Tabla | Filas | Nota |
|---|---|---|
| `modules` | 13 | ⚠️ **Nombres inventados.** Hay que reemplazarlos por los reales |
| `cohorts` | 3 | Sesiones del 1 ago al 5 sep |
| `class_sessions` | 18 | 6 por cohorte |
| `learning_guides` | 8 | ⚠️ Contenido de prueba |
| `system_config` | 11 | ✅ Los valores de notas son correctos |
| `profiles` | 5 | Solo admin, dirección y super_admin |
| `students` | **0** | Ninguno cargado |
| `teachers` | **0** | Ninguno cargado |
| `audit_log` | 452 | Hay actividad previa |

**Lo único que sirve tal cual es `system_config`.** Todo lo demás son datos de prueba que hay
que reemplazar por los reales — ver `03_DATOS.md`.

---

## 4. LOS HALLAZGOS DE SEGURIDAD

62 hallazgos de la revisión automática. Estos hay que cerrarlos **antes de cargar un solo
estudiante real**:

| Hallazgo | Nivel | Qué pasa |
|---|---|---|
| 3 vistas con `SECURITY DEFINER` | **Error** | `v_students`, `v_exam_questions_student` y `v_feedback_session_summary` ignoran el aislamiento de quien consulta |
| `student_qr_secrets` sin política | **Grave** | Aislamiento activo y ninguna regla escrita: nadie puede leerla |
| 46 funciones ejecutables sin sesión | Revisar | Funciones con permisos elevados accesibles por anónimos |
| 11 funciones con `search_path` abierto | Revisar | Riesgo de suplantación de esquema |
| Sin protección de contraseñas filtradas | Menor | Una casilla en la configuración de autenticación |

⚠️ **`v_exam_questions_student` es especialmente grave:** esa vista existe precisamente para
NO mostrarle al estudiante la respuesta correcta (regla absoluta 3 de `CLAUDE.md`). Con
`SECURITY DEFINER` puede estar saltándose el aislamiento que la justifica.

---

## 5. QUÉ NO EXISTE TODAVÍA

- **Aplicación Next.js** — cero líneas
- **Despliegue** — no hay proyecto en Vercel
- **Edge Function desplegada** — `validate-scan` está escrita (255 líneas) pero no publicada
- **Estudiantes y profesores** — ninguno en la base
- **Contenido real** — los módulos y guías son de prueba

---

## 6. LO QUE HAY Y VALE

No todo está por hacer. Esto ya está y no hay que rehacerlo:

- **Especificación completa y sin contradicciones** — `spec/00_RECONCILIACION.md`, 638 líneas
- **Prototipo funcional** — `ZR_APP_PROTOTIPO_v10.html`, define cada pantalla e interacción
- **27 tablas con aislamiento activo** y la configuración de notas correcta
- **`lib/`** — 534 líneas de TypeScript escritas contra los contratos
- **Pruebas de aislamiento** — 750 líneas en `tests/rls/`
- **Edge Function** — escrita, falta desplegar
- **Manual de identidad aplicado** — paleta, tipografías y logo, en `spec/06` y `marca/`

**El prototipo es la especificación visual.** Cuando haya duda de cómo se ve o se comporta una
pantalla, se abre el prototipo, no se inventa.

---

## 7. LA DECISIÓN SOBRE LA DIVERGENCIA

**La base manda. Del repositorio se trae solo lo que falta y sigue siendo válido.**

Orden de trabajo:

1. Volcar el esquema real de `zr-prod` al repositorio como migración consolidada
2. Archivar las migraciones 001-016 en `_archivo/migraciones-superadas/`
3. Migración nueva: tablas de evaluación práctica, **con umbrales 0-20**
4. Migración nueva: `qr_codes` de un solo uso, retirar la configuración del rotativo
5. Migración nueva: cerrar los hallazgos de seguridad

⚠️ **Antes de tocar el esquema, confirmar que nadie más esté trabajando en `zr-prod`.**
Hay 452 registros de auditoría y 17 migraciones que el repositorio no conoce. Dos agentes
migrando la misma base en paralelo es la forma más rápida de romperla.
