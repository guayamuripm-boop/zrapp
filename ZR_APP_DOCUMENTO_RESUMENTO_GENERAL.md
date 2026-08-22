# ZR App · Documento Resumen General
## Academia Técnica ZR Mecademy — Plataforma Digital Fase 1

> **Fecha de entrega: sábado 5 de septiembre 2026**
> **Público objetivo:** Estudiantes 15-25 años, ~100 activos
> **Frecuencia de clases:** Sábados exclusivamente

---

## 1. RESUMEN EJECUTIVO

**ZR App** es una PWA (Progressive Web App) para la academia técnica ZR Mecademy, cuya finalidad es resolver dolores operativos reales antes que añadir features de retención. El proyecto se construye en 5 sprints (Sprint 0 al Sprint 4) con fecha límite el 5 de septiembre 2026.

**Principio rector:** cada feature debe sumar valor neto a al menos uno de los tres roles (estudiante, profesor, administración) sin generar fricción a los otros dos. Si un módulo agrega trabajo sin quitar trabajo en otro lado, se cuestiona antes de construirse.

**Cifras clave:**
- 13 módulos en el programa completo (13 meses, 4 sábados por módulo por lo general)
- ~100 estudiantes activos
- 4 estudiantes menores de 18 (requieren consentimiento parental LOPNNA)
- 2 estudiantes bloqueados en el sistema
- 12 estudiantes en los datos de prueba

**Fase 1 (lo que se construye ahora):**
1. Registro e inicio de sesión con cédula
2. Consentimiento parental obligatorio para 15-17 años (ley LOPNNA)
3. Carnet digital con código QR rotatorio
4. Asistencia: profesor escanea QR del estudiante
5. Entrega de refrigerio marcado con el mismo escaneo
6. Exámenes digitales con autocalificación
7. Repositorio de material de estudio (PDFs)
8. Feedback corto por clase (3 preguntas)
9. Paneles de profesor y de administración
10. **«Próximo sábado»** — qué debe preparar el estudiante
11. **«Mi progreso»** — competencias del módulo que domina

**Puntos 10 y 11 son los únicos que el estudiante gana para sí mismo; todo lo demás resuelve un dolor de la academia.**

**Prohibido en Fase 1:**
- Pagos, cuotas, saldos, financiamiento
- Video micro-learning, puntos, canjes, insignias, rachas
- Red social, subida de videos, comentarios, portafolio público
- Simulador visual, certificados, roles de especialización
- Integración Google Classroom
- Aplicación nativa o publicación en App Store/Play Store
- Mensajería privada entre usuarios
- Baja automática por inasistencia
- Bloqueo físico de aulas/talleres

---

## 2. ARQUITECTURA TÉCNICA

### Stack (está decidido, no se cambia):
| Capa | Herramienta | Versión |
|---|---|---|
| Frontend y paneles | Next.js (App Router) + TypeScript | 15+ |
| Estilos | Tailwind CSS | 4+ |
| Base de datos, auth, almacenamiento | Supabase (PostgreSQL) | — |
| Lógica de servidor | Supabase Edge Functions (Deno) | — |
| Lector de QR | `@zxing/browser` | — |
| Generador de QR | `qrcode` | — |
| Generador de TOTP | `otpauth` | — |
| Validación de entradas | `zod` | — |
| Pruebas | Vitest + Playwright | — |
| Despliegue | Vercel | — |

**Prohibido usar:** FlutterFlow, Retool, n8n, Firebase, Prisma, ORMs.

### Cuatro roles del sistema:
| Rol | Quién es | Qué puede hacer |
|---|---|---|
| `estudiante` | Alumno | Ver carnet, QR, presentar exámenes, ver contenido y notas, dar feedback |
| `profesor` | Docente | Abrir sesiones, escanear asistencia, crear/calificar exámenes, subir contenido, ver feedback agregado |
| `admin` | Administración | Todo lo de profesor + gestionar estudiantes, cohortes, consentimientos, reportes |
| `super_admin` | Dirección académica | Todo lo anterior + editar `system_config` |

### Concepto clave: Estudiante pertenece a una **cohorte**
- La cohorte cursa un módulo a la vez
- Una **sesión de clase** es un sábado concreto de una cohorte
- La asistencia se registra contra una sesión, nunca contra una fecha suelta

---

## 3. REGLAS DE SEGURIDAD ABSOLUTAS (VIOLAR LAS ES ROMPE EL PROYECTO)

1. **Nunca escribas una tabla sin su política de RLS.** Row Level Security va en el 100% de las tablas.
2. **Nunca calcules notas, aprobaciones ni validaciones de QR en el navegador.** Todo eso vive en Edge Functions del lado servidor.
3. **Nunca envíes `exam_questions.correct_answer` al estudiante.** Usa siempre la vista `v_exam_questions_student`, que no tiene esa columna.
4. **Nunca uses la clave `service_role` en código de navegador.** Solo en Edge Functions y rutas de servidor Next.js.
5. **Nunca escribas un número de negocio en el código.** Umbrales, porcentajes y ventanas de tiempo se leen de la tabla `system_config`.
6. **Nunca edites una migración ya aplicada.** Crea una nueva con el número siguiente.
7. **Nunca implements reprobación automática por inasistencia.** Está explícitamente prohibida por la academia.
8. **Nunca implementes bloqueo de acceso físico a aulas o talleres.** Está prohibido por normativa del Ministerio de Educación.
9. **Nunca permits que el rol de un usuario venga del cliente.** Todo el que se registra es `estudiante`. Los roles de personal los asigna un administrador desde el servidor.
10. **Nunca construyas nada de Fase 2 o Fase 3.**

---

## 4. BASE DE DATOS (13 migraciones SQL — copiar tal cual, no modificar)

Las migraciones están en `supabase/migrations/` del `001_` al `013_`. Cada una crea tablas, enums, vistas y triggers con Row Level Security habilitado.

### Tablas y enums principales:

**Enums (definidos en `001_extensions_and_enums.sql`):**
- `user_role`: `estudiante`, `profesor`, `admin`, `super_admin`
- `profile_status`: `activo`, `suspendido`, `egresado`, `retirado`
- `onboarding_status`: `en_curso`, `completo`
- `consent_type`: `account_creation`, `ugc_publication`
- `consent_method`: `fisico`, `digital`
- `cohort_status`: `activa`, `finalizada`, `suspendida`
- `enrollment_status`: `en_curso`, `aprobado`, `reprobado`, `retirado`
- `session_status`: `programada`, `abierta`, `cerrada`, `reprogramada`, `cancelada`
- `exam_status`: `oculto`, `habilitado`, `cerrado`, `calificado`
- `question_type`: `opcion_multiple`, `verdadero_falso`, `redaccion_abierta`
- `attempt_status`: `en_progreso`, `entregado`, `calificado`
- `attendance_method`: `qr`, `manual`
- `content_type`: `pdf`, `presentacion`, `imagen`, `enlace`, `documento`
- `notification_channel`: `push`, `email`, `in_app`
- `mastery_status`: `no_iniciado`, `en_progreso`, `dominado`
- `mastery_source`: `evaluacion_practica`, `evaluacion_teorica`, `micro_learning`

**Tablas más importantes:**

1. **`profiles`** — identidad común a los 4 roles, 1 a 1 con `auth.users`
2. **`students`** — `birth_date`, `cohort_id`, `onboarding_status`, `trust_level` (Fase 2)
3. **`cohorts`** — grupos que cursan en paralelo, `current_module_id`, `teacher_id`, `location`
4. **`modules`** — los 13 módulos del programa, `order_index`, `duration_weeks`, `inces_homologado`
5. **`class_sessions`** — un sábado concreto de una cohorte, `status`, `opened_at`, `closed_at`
6. **`attendance_events`** — escaneos QR, `scanned_at` (momento real, no `now()`), `synced_at`, `snack_claimed_at`
7. **`student_qr_secrets`** — secreto TOTP por estudiante, **ningún rol puede leerla por la API**
8. **`exams`** — `status`, `max_score` (sobre 20), `passing_score` (10 o 12 por módulo), `opens_at`, `closes_at`
9. **`exam_questions** — tipo, `statement`, `options`, `correct_answer`, `points`, `rubric`
10. **`exam_attempts`** — `student_id`, `exam_id`, `status`, `started_at`, `submitted_at`, `total_score`
11. **`exam_answers** — `answer` (jsonb), `awarded_points`, `auto_graded`, `teacher_feedback`
12. **`learning_guides`** — sub-competencias, `pre_practice_description` (investigación entre semana), `practice_description` (práctica sábado), `digitized`
13. **`parental_consents`** — LOPNNA, `consent_type = 'account_creation'`, representante legal, `method`, `document_url`
14. **`system_config`** — todos los números de negocio. **Nunca escribir números en el código.** Leer siempre de aquí.
15. **`notifications`** — 4 tipos: `examen_habilitado`, `nota_publicada`, `consentimiento_pendiente`, `feedback_disponible`
16. **`feedback_micro** — máximo 3 preguntas, escala 1-5, por sesión
17. **`feedback_macro** — por módulo, texto libre, [Fase 2]
18. **`content_items`** — material de estudio, bucket `contenido` (privado)
19. **`content_views`** — registra qué contenido se ve
20. **`mastery_map`** — mapa de dominio por competencias [añadido Fase 1 el 30/07/2026]
21. **`audit_log`** — todo lo que se modifica se registra aquí (inmutable)

### Política de RLS (archivo `012_rls_policies.sql` — lo más importante del proyecto):

- `student_qr_secrets`: **NINGÚN rol puede leerla** (se revoca todo). El secreto se entrega una sola vez desde Edge Functions.
- `profiles`: estudiante lee solo la suya; admin/super_admin todo.
- `students`: estudiante lee la suya; admin todo; profesor puede ver los de su cohorte.
- `parental_consents`: estudiante lee/solo la suya; admin gestiona.
- `attendance_events`: estudiante lee la suya; profesor puede ver la de su cohorte.
- `exams`: estudiante solo los habilitados de su módulo/cohorte.
- `exam_questions`: SIN política para estudiantes (por seguridad). Se accede solo por vista `v_exam_questions_student`.
- `feedback_micro`: estudiante escribe la suya, lee la suya; admin lee todo (agregado).
- `system_config`: todo el mundo puede leer lo público; super_admin escribe.
- `mastery_map`: estudiante lee/actualiza la suya; profesor puede ver la de su cohorte.

**Regla crítica:** `service_role` se salta TODAS las políticas RLS. Nunca usar en código de navegador.

### Configuración inicial (migración `013_seed_config.sql`):

Todos los números de negocio viven aquí. Si encuentras algún número escrito en el código de la aplicación, es un error: debe leerse de `system_config`.

| Clave | Valor | Descripción |
|---|---|---|
| `module.passing_threshold_first` | `10` | Nota mínima para aprobar el **primer** módulo (regla excepcional de arranque) |
| `module.passing_threshold_default` | `12` | Nota mínima para aprobar del segundo módulo en adelante |
| `module.participation_weight_min` | `0.05` | Peso mínimo de participación en la nota final (cada profesor fija el suyo por encima) |
| `exam.max_score` | `20` | Escala de todas las evaluaciones internas |
| `exam.individual_passing_score` | `10` | Nota mínima para aprobar una evaluación individual |
| `attendance.qr_window_seconds` | `30` | Duración de cada código QR rotatorio, en segundos |
| `attendance.qr_drift_tolerance` | `1` | Ventanas de tolerancia hacia adelante/atrás por desfase de reloj |
| `feedback.micro_max_questions` | `3` | Máximo de preguntas del feedback por clase |
| `feedback.min_responses_to_show` | `3` | Respuestas mínimas antes de mostrar el agregado al profesor (impide identificar quién dijo qué) |
| `grading.sla_hours` | `72` | Horas objetivo para calificar una redacción abierta |
| `app.support_channel` | `"Contacta a coordinación en la sede"` | Texto que se muestra al estudiante cuando algo falla |

---

## 5. FLUJOS PRINCIPALES DEL NEGOCIO

### 5.1 Registro y Onboarding

**Secuencia completa (spec/04_PANTALLAS.md §2):**

1. El usuario entra a `/login`
2. Cédula (`V-12345678`) y contraseña (≥8 caracteres)
3. Cédula se convierte a correo determinista: `${cedula}@estudiante.zrmecademy.com`
4. `signInWithPassword` o `signUp` si es nuevo

**Si es nuevo registro (`/registro`):**
- Formulario único: `fullName`, `cedula`, `contactEmail`, `phone` (opcional), `birthDate`, `password`, `repeatPassword`
- Validado con `registroSchema` (zod)
- `signUp` con correo sintético + metadatos
- Insertar fila en `students` con `birth_date`
- **Calcular edad** con `age_years(birth_date)`:
  - **Menor de 18** → redirigir a `/registro/consentimiento`
  - **18 o más** → llamar a `provision-qr` y redirigir a `/carnet`

**Consentimiento parental (`/registro/consentimiento`) — obligatorio para 15-17 años:**
- Pantalla imposible de saltar
- Datos del representante: nombre, cédula, correo, teléfono
- Método: `fisico` (firmado en sede) o `digital` (subir documento firmado)
- Al guardar: insertar en `parental_consents` con `consent_type = 'account_creation'`, luego actualizar `students.onboarding_status = 'completo'`
- **Si el disparador de la base rechaza el cambio**, muestra error LOPNNA y se para el onboarding. Ese rechazo es la red de seguridad.

**Si es mayor de 18 años:**
- Va directo a `/carnet`, sin consentimiento
- Cronómetro: debe tomar menos de 60 segundos

### 5.2 Carnet Digital (estudiante)

Pantalla de inicio, la más usada. Debe cargar rápido y **funcionar sin internet**.

**Orden de las tarjetas (no negociable):**
1. **«Próximo sábado»** — lo único accionable
2. **«Mi progreso»** — resumen, con enlace a `/progreso`
3. **El carnet propiamente dicho** — foto/iniciales, nombre, cédula, cohorte, módulo, QR grande

**Tarjeta «Próximo sábado»:**
- Datos de la vista `v_proximo_sabado`
- Si no hay sesión próxima: *"No tienes clase programada por ahora"*
- Si la guía no está digitalizada (`pre_practice_description` vacío): solo fecha y módulo, sin inventar texto

**Tarjeta «Mi progreso»:**
- De la vista `v_mi_dominio`
- Muestra **todas** las competencias del módulo, incluidas las que no tienen fila en `mastery_map` (salen como `no_iniciado`)
- Colores: `--zr-success` (dominado), `--zr-blue-mid` (en progreso), `--zr-border` (pendiente)
- **Nunca muestres comparación con otros estudiantes.** Es personal.

**El carnet en sí:**
- Foto o iniciales, nombre completo, cédula
- Cohorte y módulo actual
- **QR grande, al menos 60% del ancho**, con marco `--zr-navy`. Debajo, barra que se vacía en 30 segundos y el código se regenera solo
- Contador: *"Módulos aprobados: 3 de 13"*
- Aviso en `--zr-warning` si hay consentimiento pendiente

**Cómo se genera el QR (spec/02_CONTRATOS.md §2):**
```
ZR1|<cedula>|<totp_6_digitos>
```
- `ZR1` es la versión del formato (si cambia, será `ZR2`)
- Código TOTP generado en el teléfono, sin internet, a partir del secreto entregado en el aprovisionamiento
- Rota cada 30 segundos (`system_config.attendance.qr_window_seconds`)
- **Nunca metas nombre, foto ni id del estudiante en el QR.** Solo lo mínimo para identificar y validar

### 5.3 Asistencia (el corazón del proyecto — Sprint 2)

**Regla de oro:** **El profesor escanea al estudiante, nunca al revés.** Si se hace al revés, un alumno fotografía el QR y lo manda por WhatsApp a un compañero ausente. Además, así solo un teléfono necesita señal, y en los talleres la señal es mala.

**Sprint 2 test (sábado 15 agosto):**
- 100% de presentes queda registrado
- Tiempo total menor que línea base medida el 1 de agosto
- Sistema aguenta al menos un corte de señal sin perder ningún escaneo

**Funcionamiento (spec/03_EDGE_FUNCTIONS.md §2 + spec/06_attendance.sql):**

1. El estudiante tiene un secreto TOTP en su teléfono. Su carnet muestra un QR que cambia cada 30 segundos.
2. El **profesor** escanea ese QR con un dispositivo de la academia.
3. El servidor valida el código. **El cliente NUNCA valida.**
4. Validaciones en `validate-scan` Edge Function (12 pasos en orden):
   1. Validar token: quien llama debe ser `profesor`, `admin` o `super_admin` → `NO_AUTORIZADO` si no
   2. Validar formato `qrCode` con regex → `QR_INVALIDO` si falla
   3. Separar versión | cédula | TOTP; si `version !== 'ZR1'` → `QR_INVALIDO`
   4. Buscar estudiante por cédula → si no existe → `QR_INVALIDO`
   5. Leer secreto de `student_qr_secrets` con cliente admin
   6. Leer `attendance.qr_window_seconds` y `attendance.qr_drift_tolerance` de `system_config`
   7. Validar TOTP con esa ventana y tolerancia → si no coincide en ninguna ventana → `QR_VENCIDO`
   8. Leer la sesión: si estado no es `abierta` → `SESION_NO_ABIERTA`
   9. Verificar quien llama da clase en esa cohorte → si no → `NO_AUTORIZADO`
   10. Verificar que estudiante pertenece a cohorte de la sesión → si no → `ESTUDIANTE_OTRA_COHORTE`
   11. Insertar en `attendance_events` con `scanned_at = scannedAt` (momento real, **no** `now()`) y `synced_at = now()`
   12. Si el insert choca con restricción única `(session_id, student_id)`: **no es error**. Devolver `{ ok: true, duplicate: true }`. Esto hace que reenviar la cola sin conexión sea seguro.

**Por qué `scannedAt` y no `now()` (spec/03_EDGE_FUNCTIONS.md §12):**
El dispositivo del profesor puede estar sin señal y sincronizar 3 horas después. La hora que importa es la del escaneo real.

**Modo refrigerio (misma pantalla de escaneo, interruptor arriba):**
- En modo asistencia: llama a `validate-scan`
- En modo refrigerio: llama a `claim-snack`
- **Regla de negocio:** no hay refrigerio sin asistencia registrada. Segunda falla → `REFRIGERIO_YA_ENTREGADO`

**Búsqueda por cédula (respaldo manual):**
- Abre lista de estudiantes de la cohorte con buscador
- Al elegir uno, **pide obligatoriamente un motivo**: *"olvidó el teléfono"*, *"teléfono sin batería"*, *"otro"* (texto libre)
- Registra con `method = 'manual'` y `manual_reason`
- Queda auditado en `audit_log`

### 5.4 Evaluaciones Digitales (Sprint 3)

**Estado del examen:** `oculto` → `habilitado` → `en_progreso` → `entregado` → `calificado`

**Constructor de exámenes (profesor):**
- Datos del examen: título, instrucciones, módulo, cohorte, puntaje máximo (siempre 20), fechas, duración
- Lista de preguntas reordenables
- Al agregar pregunta, se elige el tipo primero y el formulario cambia:
  - **Opción múltiple:** enunciado, de 2 a 6 opciones con clave `a/b/c...`, marcar correcta, puntos
  - **Verdadero/falso:** enunciado, cuál es correcta, puntos
  - **Redacción abierta:** enunciado, rúbrica, puntos. `correct_answer` queda en `null`

**Validación antes de publicar:**
- El disparador `trg_validate_exam_publish` de la base verifica que la suma de puntos de las preguntas coincida con `max_score`
- Si no hay preguntas → error. Si la suma no cuadra → error con mensaje

**Entrega por estudiante (una pregunta por pantalla):**
- Siempre de `v_exam_questions_student`, **nunca** de `exam_questions` (la columna `correct_answer` viaja al navegador y el examen queda resuelto para cualquiera que abra herramientas de desarrollo)
- Cada pregunta se guarda automáticamente en `exam_answers` al cambiar de pregunta
- En la última pregunta: **Entregar** con confirmación: *"¿Seguro? No podrás cambiar tus respuestas."*
- Al entregar: llamar a `submit-attempt` Edge Function

**`submit-attempt` Edge Function (spec/03_EDGE_FUNCTIONS.md §4):**
1. Validar token: el intento pertenece a quien llama → si no → `NO_AUTORIZADO`
2. Si el intento no está `en_progreso` → `INTENTO_YA_ENTREGADO`
3. Traer todas las preguntas del examen **con su `correct_answer`** (aquí sí se puede: estamos en el servidor)
4. Para cada respuesta del estudiante:
   - `opcion_multiple`: correcta si `answer.key === correct_answer.key`. Puntos: todos o cero.
   - `verdadero_falso`: correcta si `answer.value === correct_answer.value`. Puntos: todos o cero.
   - `redaccion_abierta`: dejar `awarded_points = null`. **No intentes calificarla.**
   - Marcar `auto_graded = true` en las dos primeras
   - Si el estudiante no respondió una pregunta objetiva: `awarded_points = 0`
5. Actualizar el intento a `entregado` con `submitted_at = now()`
6. **No lo cierres tú.** El disparador `trg_close_attempt` de la base se encarga solo de pasar a `calificado` cuando ya no queden respuestas sin puntaje.

**`grade-answer` Edge Function (spec/03_EDGE_FUNCTIONS.md §5):**
1. Validar quien llama es personal y da clase en la cohorte del examen → si no → `NO_AUTORIZADO`
2. Validar que `awardedPoints` está entre 0 y los puntos de esa pregunta → si no → `DATOS_INVALIDOS`
3. Actualizar `exam_answers`: `awarded_points`, `graded_by`, `graded_at = now()`, `teacher_feedback`
4. Devolver si el intento quedó cerrado (lo decide el disparador de la base)

**Cálculo de notas (docs/00_CONTEXTO_MAESTRO_AGENTE.md §3.4):**
- Escala numérica: **sobre 20 puntos** en todas las evaluaciones internas
- Una evaluación individual se aprueba con **10 puntos o más** (solo en el **primer módulo**)
- Del **segundo módulo en adelante**: **12 puntos o más** para aprobar
- **Participación:** profesor asigna un porcentaje de la nota final a participación (**mínimo 5%**). La participación **solo se obtiene asistiendo y participando activamente** — faltar implica perder automáticamente ese porcentaje
- **Asistencia:** no existe regla automática de "pierdes el módulo si faltas N sábados". La reprobación ocurre cuando las faltas repetidas le impiden acumular notas suficientes. **El sistema no debe implementar baja automática por inasistencia.**

**Nota final y estado (spec/04_PANTALLAS.md §3):**
- Mostrada en grande: `16,5 / 20` en verde o rojo
- Debajo, el umbral: *"Aprueba con 12"* (módulo 1: *"Aprueba con 10"*)
- En rojo si reprobado, verde si aprobado, gris si en curso

### 5.5 Feedback por clase (spec/04_PANTALLAS.md §3 + spec/08_content_feedback.sql)

**Micro-feedback (por clase, máximo 3 preguntas):**
- 3 preguntas como máximo, escala 1 a 5 con caritas o estrellas grandes
- Debe responderse en menos de 20 segundos
- Botón: **Enviar**
- Después: *"Gracias. Tu respuesta es anónima para tu profesor."* (y es verdad, la base lo garantiza)
- Se guarda en `feedback_micro` por sesión
- La base asegura que el estudiante solo ve su propio feedback

**Vista para el profesor (`v_feedback_session_summary`):**
- Solo muestra **promedio** del grupo
- Solo si hay **3 o más respuestas** (si hay menos, no muestra nada, impide identificar quién dijo qué)
- Muestra: `question`, `response_count`, `avg_score` (redondeado a 2 decimales)
- **Nunca** muestra quién dijo qué

**Feedback macro (por módulo):**
- Formulario abierto, genera insignia digital (QR/PDF) vinculada al carnet
- [Fase 2]

### 5.6 Carnet y "Lo que el estudiante gana para sí mismo"

Según docs/13_DISENO_DE_PRODUCTO_ESTUDIANTE.md:

Las 3 cosas que el estudiante gana son (en orden de pantalla en los primeros 10 segundos):

1. **«Lo que viene el próximo sábado»** (§3.1) — medio día de trabajo, dato que ya existe (`learning_guides.pre_practice_description`). Ataca directamente los 6 días de silencio entre clases.

2. **«Mi progreso»** (§3.2) — mapa de dominio del módulo. Es la única cosa que ataca la **percepción de competencia**, que la academia misma identifica como la variable que más predice motivación sostenida. El estudiante ve qué competencias dominó, cuáles están en progreso y cuáles son pendientes. **Sin puntos, sin niveles, sin comparación con otros.**

3. **El carnet con el QR** — es una herramienta de la academia para identificarlo. Las otras dos son suyas.

**Orden en la pantalla de inicio (importante para primera impresión):**
1. Lo que viene el próximo sábado
2. Mi progreso en el módulo
3. El carnet con el QR

---

## 6. EDGE FUNCTIONS (lógica sensible, vive en el servidor)

### 6.1 `provision-qr` (función 1)
- Entrega al estudiante su secreto TOTP, una sola vez, al completar el registro
- Entrada: token de quien llama
- Salida: `{ secret, issuer: "ZR Mecademy", label, periodSeconds: 30 }`
- Lógica: obtener usuario, verificar rol `estudiante`, buscar secreto en `student_qr_secrets`, si no existe generar uno nuevo (20 bytes aleatorios en base32) e insertarlo

### 6.2 `validate-scan` (la función más importante)
- Registra una asistencia (12 pasos en orden exacto, ya descrito en §5.3)
- Entrada: `{ sessionId, qrCode, scannedAt, deviceId }`
- Salida correcta: `{ ok: true, student: {id, fullName, cedula}, attendanceId: uuid, duplicate: false }`

### 6.3 `claim-snack` (función 3)
- Marca la entrega del refrigerio
- Entrada: `{ sessionId, qrCode }`
- Lógica idéntica a `validate-scan` en los pasos 1-10, luego:
  11. Buscar `attendance_events` de ese `(sessionId, studentId)`. Si no existe → `NO_AUTORIZADO` con mensaje "El estudiante no tiene asistencia registrada hoy" (regla de negocio: **no hay refrigerio sin asistencia**)
  12. Si `snack_claimed_at` ya tiene valor → `REFRIGERIO_YA_ENTREGADO`
  13. Actualizar `snack_claimed_at = now()` y `snack_claimed_by` = quien llama

### 6.4 `submit-attempt` (función 4)
- El estudiante entrega su examen y se autocalifica lo que se pueda
- Entrada: `{ attemptId }`
- Salida: `{ ok: true, autoGradedPoints, pendingManualQuestions, status: "entregado" }`
- Lógica: validar que el intento pertenece a quien llamar, validar que está `en_progreso`, traer preguntas con correct_answer, calificar objetivas (todo o nada), dejar redacción en `null`, actualizar a `entregado`. El cierre automático a `calificado` lo hace el disparador de la base.

### 6.5 `grade-answer` (función 5)
- El profesor califica una redacción abierta
- Entrada: `{ answerId, awardedPoints, feedback }`
- Validaciones: quien llama es personal y da clase en la cohorte; `awardedPoints` entre 0 y los puntos de la pregunta → si no → `DATOS_INVALIDOS`
- Actualizar `exam_answers`: `awarded_points`, `graded_by`, `graded_at = now()`, `teacher_feedback`

### 6.6 `create-staff-user` (función 6)
- Un administrador crea una cuenta de profesor o de otro administrador
- Entrada: `{ cedula, fullName, contactEmail, role, password }`
- Lógica: verificar quien llama es `admin` o `super_admin`; **solo un `super_admin` puede crear otro `super_admin`**; crear usuario con `adminClient().auth.admin.createUser()`, correo confirmado; actualizar `profiles.role`; insertar en `teachers` o `admins` según corresponda

### 6.7 `send-push` (función 7)
- Envía notificaciones pendientes por Web Push
- Disparo: por `pg_cron`, cada 5 minutos. **Nunca la llama el navegador.**
- Lógica: traer de `notifications` las que tienen `sent_at is null` y `channel = 'push'`; buscar suscripciones en `push_subscriptions`; enviar con claves VAPID; marcar `sent_at = now`; si devuelve 404 o 410, borrarla (dispositivo ya no existe)

---

## 7. SISTEMA DE CONFIGURACIÓN (system_config)

**Toda la aplicación lee de aquí.** Cambiar un umbral es editar una fila, no desplegar código.

Todos los números están en `013_seed_config.sql`. Si encuentras algún número en el código, es un error.

| Categoría | Clave | Valor | Público |
|---|---|---|---|
| **Calificación** | `module.passing_threshold_first` | `10` | Sí |
| | `module.passing_threshold_default` | `12` | Sí |
| | `module.participation_weight_min` | `0.05` | Sí |
| | `exam.max_score` | `20` | Sí |
| | `exam.individual_passing_score` | `10` | Sí |
| **Asistencia** | `attendance.qr_window_seconds` | `30` | Sí |
| | `attendance.qr_drift_tolerance` | `1` | No |
| **Feedback** | `feedback.micro_max_questions` | `3` | Sí |
| | `feedback.min_responses_to_show` | `3` | No |
| **Operación** | `grading.sla_hours` | `72` | No |
| | `app.support_channel` | `"Contacta a coordinación en la sede"` | Sí |

---

## 8. SEGURIDAD Y SESGO EVALUACIÓN

### 8.1 Riesgos de sesgo identificados y a evaluar:

1. **Falta de valor visible para el estudiante:** La Fase 1 está diseñada ~80% para dolor institucional y ~20% para el estudiante (docs/13_ §2). Las tres cosas que sí le sirven al estudiante (nota al instante, material siempre disponible, saber dónde va) son "ganancias silenciosas" que no se señalan en la app.

2. **Orden de las tarjetas en el carnet:** El documento de diseño estudantil (§3) recomienda el orden: 1) próximo sábado, 2) mi progreso, 3) carnet. El carnet es una herramienta de la academia, no del estudiante. Si el carnet va primero, la app se percibe como "algo que me obligan a usar". Los primeros 10 segundos deciden la adopción.

3. **Consentimiento parental como trámite:** Para el estudiante de 15-17 años, el consentimiento es "un trámite más" que gana la academia, no él. La pantalla no señala qué ganó él con ese trámite.

4. **Feedback anónimo:** El estudiante da feedback pero nunca ve los resultados. La anonimidad está garantizada por la base de datos (agregado mínimo, 3+ respuestas), pero el estudiante no sabe si su opinión influyó.

5. **No hay comparación entre estudiantes:** Está bien intencionada (evita humillación), pero también oculta el progreso relativo que podría ser motivador si se hace bien.

6. **Micro-feedback sin retroalimentación:** El estudiante responde 3 preguntas y punto. No ve resumen, no ve promedio del grupo, no sabe si sus respuestas ayudaron a mejorar nada.

7. **Perfil de cédula venezolana:** El formato `V-12345678` es obligatorio. Si el estudiante no conoce su formato exacto, no puede registrarse. Sesgo de usabilidad para recién llegados.

8. **Modo avión + QR:** La funcionalidad de QR sin internet es una decisión de diseño excelente para talleres con mala señal, pero requiere que el estudiante tenga un teléfono con reloj TOTP configurado. Estudiantes sin acceso a tecnología adecuada se excluyen sutilmente.

9. **Asistencia sin internet:** El sistema funciona sin señal y se sincroniza después (idempotente). Esto es inclusivo para zonas con mala conectividad, pero depende del estudiante tener un teléfono con batería y funcionamiento básico.

10. **Rol único al registrarse:** Todo el que se registra es `estudiante`. Los roles de personal vienen de la administración. Esto es seguro pero puede crear fricción si un profesor intenta usar la app antes de que un admin cree su cuenta.

### 8.2 Puntos a evaluar para mejorar:

- **Señalar las "ganancias silenciosas":** La pantalla de inicio del estudiante debería indicar sutilmente las 3 cosas que ganó (proximo sábado, progreso, y qué módulo ve).
- **Hacer visible el progreso sin comparar:** El mapa de dominio (`mi progreso`) ya hace esto bien, pero ¿se podría indicar "avance del grupo" de forma agregada sin identificar individuos?
- **Retroalimentación de micro-feedback:** ¿Mostrar al estudiante que su feedback fue registrado? Un mensaje efímero tipo "Gracias, tus respuestas ayudan a mejorar las clases" sin revelar lo individual.
- **Orden de pantalla:** Probar el orden recomendado (proximo sábado → progreso → carnet) vs el orden actual y medir primera impresión en la prueba del 5 de septiembre.
- **Facilitar el consentimiento:** El estudiante de 15-17 años debería entender qué gana con el consentimiento parental, no solo que "es obligatorio".
- **Accesibilidad tecnológica:** Evaluar si el requisito de TOTP/QR en todo momento excluye a algunos estudiantes. Tener un modo de respaldo que no requiera teléfono con señal en todo momento.
- **Peso de participación:** El mínimo es 5% pero cada profesor fija el suyo. ¿Mostrar a los estudiantes el peso de participación de su cohorte para transparencia?

---

## 9. PRUEBAS Y VERIFICACIÓN

### Comandos obligatorios:

```bash
npm run verify
# Compuesto por:
# npm run typecheck && npm run lint && npm run test && npm run test:rls
```

### Verificaciones antes de cualquier tarea:

1. **`npm run typecheck`** pasa sin errores
2. **Si tocaste la base:** migración nueva con número en `supabase/migrations/`
3. **Si creaste una tabla:** tiene RLS habilitada y políticas escritas
4. **`npm run test:rls`** pasa (estudiante A no puede leer datos del estudiante B)
5. **`npm run test`** pasa
6. **Probaste el camino feliz y el camino de error**
7. **Funciona en teléfono (360 px ancho), no solo escritorio**

### Tests críticos (spec/05_PRUEBAS.md):

**Tests de acceso cruzado (13 pruebas en `tests/rls/acceso-cruzado.test.ts`):**
- Estudiante A no puede leer perfil de B
- Estudiante A no puede leer notas de B
- Estudiante A no puede leer asistencia de B
- Estudiante A no puede leer consentimiento parental de B
- Estudiante A no puede leer intentos de examen de B
- Estudiante A no puede leer feedback de B
- **NO puede leer secre de QR, NI EL PROPIO**
- **NO puede ver respuestas correctas de un examen**
- La vista para estudiantes no expone `correct_answer`
- Estudiante no puede subirse el rol a sí mismo
- Estudiante no puede escribir sus propias notas
- Estudiante no puede registrar su propia asistencia
- Estudiante no puede leer la auditoría
- Estudiante no puede leer mapa de dominio de otro
- **NO puede marcarse a sí mismo una competencia como dominada**

**Tests de reglas de negocio (19 pruebas en `tests/reglas/negocio.test.ts`):**
- Umbral del primer módulo (10) y resto (12)
- Cálculo de nota: teoría 16, práctica 14, participación 20, peso 0.10 → `final_score = 15.50`
- Aprobación: nota 12.5 con umbral 12 → `status = 'aprobado'`
- Reprobación: nota 11.9 con umbral 12 → `status = 'reprobado'`
- Peso mínimo: intentar `participation_weight = 0.04` → base lo rechaza
- **Sin baja automática:** estudiante con cero asistencias y notas suficientes → sigue `aprobado`. **Nunca reprueba por faltas.**
- Menor sin consentimiento → base lo rechaza con mensaje LOPNNA
- Menor con consentimiento → funciona
- Mayor de edad → completa registro sin consentimiento
- Asistencia duplicada → segunda falla por restricción única
- Sesión cerrada → rechazado: `SESION_NO_ABIERTA`
- Cohorte equivocada → rechazado
- Refrigerio doble → segunda falla
- Asistencia inmutable → borrar evento rechazado
- Auditoría inmutable → editar `audit_log` rechazado
- Puntos del examen: publicar uno que sume 18 de 20 → rechazado con mensaje de puntos
- Feedback largo: enviar 4 preguntas → rechazado
- Cierre de intento: calificar última respuesta pendiente → intento pasa a `calificado` con su total

**Tests e2E (Playwright - 4 recorridos):**
- `registro-menor.spec.ts`: registro de menor, debe redirigir a consentimiento, no dejable de saltar
- `registro-adulto.spec.ts`: registro de mayor, debe ir directo a carnet en <60 segundos
- `asistencia.spec.ts`: profesor abre clase, envía código válido → verde y nombre; envía de nuevo → amarillo "Ya registrado"; código vencido → error rojo; registro manual con motivo → `method = 'manual'`
- `examen.spec.ts`: profesor crea examen con los 3 tipos y lo publica; estudiante lo presenta y entrega; verifica puntaje automático en objetivas y `null` en redacción; profesor califica redacción; verifica que intento pasa a `calificado`

---

## 10. PROHIBICIONES EXPLÍCITAS (Fase 1 y Fase 2 no construibles)

Si el usuario solicita algo de esta lista, responder que pertenece a otra fase y no construirse:

### Fase 2 (prohibido en Fase 1):
- Pagos, cuotas, saldos, estado de cuenta o financiamiento
- Video micro-learning, puntos, canjes, insignias, rachas
- **Solo el estado de cada competencia** (dominada, en progreso o pendiente) entra en Fase 1, sin puntos, sin niveles, sin insignias y sin comparación entre estudiantes
- Contabilidad del fondo de refrigerios

### Fase 3 (prohibido en Fase 1 y 2):
- Red social, subida de videos por estudiantes, comentarios, portafolio público
- Simulador visual, roles de especialización, certificados
- Integración con Google Classroom (descartada, no se hace nunca)
- Aplicación nativa o publicación en App Store / Play Store
- Mensajería privada entre usuarios

### Siempre prohibido:
- Reprobación automática por inasistencia
- Bloqueo físico de aulas o talleres
- Que el rol del usuario venga del cliente

---

## 11. IDENTIDAD VISUAL Y DISEÑO

### Colores (spec/06_IDENTIDAD_VISUAL.md):
- `--zr-navy`: `#21284F` — azul noche, barras, texto principal
- `--zr-blue`: `#3869B1` — azul de marca, botón de acción principal
- `--zr-blue-light`: `#98BAE3` — azul claro, fondos de tarjeta
- `--zr-blue-mid`: `#6590CB` — azul medio, estados activos
- `--zr-success`: `#16A34A` — éxito, asistencia registrada, competencia dominada
- `--zr-warning`: `#EAB308` — advertencia, "ya registrado", consentimiento pendiente
- `--zr-error`: `#DC2626` — error, código vencido, fallo de escaneo

### Tipografía:
- **Raleway** para títulos y cifras grandes (40 px para resultado de escaneo, 24 px para títulos de pantalla, 20 px para subtítulos)
- **Roboto** para todo lo demás (mínimo 16 px, absoluto 14 px)
- Importar desde `@fontsource-variable/roboto` y `@fontsource-variable/raleway` (nunca desde Google Fonts por falta de señal)

### Medidas mínimas:
- Botón mínimo: 56 px de alto (`min-h-14`)
- Texto mínimo: 16 px (`text-base`)
- Zona táctil mínima: 48 × 48 px
- Ámbito principal: tercio inferior de pantalla, alcanzable con pulgar

### Voz y tono (spec/06_ §8):
- Tutea siempre: *"Ya tienes nota"* (no *"Usted tiene una calificación disponible"*)
- Español de Venezuela, sin regionalismos forzados: *"Tu profesor habilitó un examen"* (no *"Tu profe te puso una prueba, pana"*)
- Los errores dicen qué hacer: *"El código venció. Pídele al estudiante que muestre el nuevo."* (no *"Error 403: token inválido"*)
- Sin jerga técnica jamás: *"No hay internet. Se guardó y se enviará solo."* (no *"Fallo de sincronización con el backend"*)
- Celebra lo que costó, no lo trivial: *"Dominaste el diagnóstico de batería"* (no *"¡Iniciaste sesión! ¿YZ?"*)
- Nunca culpes al usuario: *"No encontramos esa cédula"* (no *"Escribiste mal la cédula"*)
- Formato local siempre: coma decimal (`16,5`), fechas `sáb 15 ago 2026`, horas en 24 h (`08:30`), cédula con guion (`V-30000001`)

### Iconografía:
- `lucide-react`, trazo 2 px, mínimo 24 px (32 px en acciones principales)
- Consistencia: mismo icono en todas las pantallas para que se aprendan solos

---

## 12. RUTAS Y NAVEGACIÓN

### Rutas públicas:
- `/login` — cédula + contraseña
- `/registro` — formulario único de registro
- `/registro/consentimiento` — consentimiento parental (obligatorio para 15-17)
- `/recuperar` — recuperación de contraseña
- `/api/auth/callback` — callback de auth

### Rutas estudiante (barra inferior fija, 4 botones):
- `/carnet` — pantalla de inicio (próximo sábado → progreso → carnet con QR)
- `/clases` — sesiones de su cohorte, estado de asistencia
- `/examenes` — ver y presentar exámenes
- `/material` — repositorio de contenido

### Rutas profesor:
- `/hoy` — pantalla de inicio del sábado (tarjeta clase + botón abrir asistencia)
- `/escanear/[sessionId]` — pantalla crítica de escaneo
- `/sesiones` — gestión de sesiones (abrir, cerrar, reprogramar)
- `/examenes` — constructor de exámenes
- `/calificar` — cola de redacciones por calificar
- `/notas/[cohortId]` — notas por estudiante de su cohorte
- `/contenido` — subir y ver material

### Rutas admin:
- `/panel` — cuatro tarjetas con números grandes (estudiantes activos, consentimientos pendientes, asistencia última sesión, exámenes sin calificar)
- `/estudiantes` — tabla con buscador, filtros, importar CSV
- `/cohortes` — crear cohortes, asignar profesor y salón, avanzar de módulo
- `/reportes` — cuatro reportes con exportación CSV
- `/configuracion` — solo super_admin, editar `system_config`

### Middleware (spec/04_PANTALLAS.md §0):
- Si no hay sesión y ruta protegida → redirigir a `/login`
- Con sesión, leer rol y verificar que corresponde al grupo de rutas
- Rol equivocado → redirigir a pantalla de inicio de su propio rol
- Rutas públicas: `/login`, `/registro`, `/registro/consentimiento`, `/recuperar`, `/api/auth/callback`

---

## 13. ROADMAP Y FECHAS

| Sprint | Fechas | Objetivo principal |
|---|---|---|
| **Sprint 0** | 30 jul → 2 ago | Base de datos, seguridad, entornos listos |
| **Sprint 1** | 3 → 9 ago | Identidad, consentimiento, carnet (prueba campo sáb 8 ago) |
| **Sprint 2** | 10 → 16 ago | Asistencia y operación del sábado (prueba campo sáb 15 ago) |
| **Sprint 3** | 17 → 23 ago | Evaluaciones digitales (prueba campo sáb 22 ago) |
| **Sprint 4** | 24 → 30 ago | Material, feedback, paneles, PWA |
| **Entrega** | 5 sep 2026 | Entrega final al cliente |

**Hitos críticos:**
- Sábado 8 de agosto: prueba en campo Sprint 1 (5 estudiantes reales, al menos 2 menores)
- Sábado 15 de agosto: prueba en campo Sprint 2 (eliminar planilla papel)
- Sábado 22 de agosto: prueba en campo Sprint 3 (exámenes digitales reales)
- Sábado 5 de septiembre: **Fecha de entrega**

---

## 14. CONCLUSIÓN

**ZR App no es una aplicación educativa "ideal", es una herramienta operativa diseñada para las condiciones reales de ZR Mecademy:** talleres con mala señal, estudiantes de 15-25 años, clases los sábados, academia que necesita resolver problemas de asistencia, evaluación y cumplimiento legal antes que features de retención.

**El éxito se mide por:**
1. Que el 5 de septiembre, 100 estudiantes abran la app sin ayuda técnica
2. Que el QR funcione en modo avión (sin internet)
3. Que la asistencia registre el 100% de presentes en menos de 20 minutos
4. Que los exámenes se presenten y califiquen automáticamente lo posible
5. Que los menores completen su registro con consentimiento parental
6. Que el profesor tenga su panel operativo el sábado a las 8 de la mañana

**Las 3 features que el estudiante gana para sí mismo (y que definen la adopción):**
1. **«Lo que viene el próximo sábado»** — ataca los 6 días de silencio
2. **«Mi progreso»** — hace visible su dominio real
3. **Saber dónde está parado** — ver sus notas y módulo actual

Todo lo demás resuelve dolor de la academia, y si hay que recortar, se recortan de últimos, no de primeros.

---
*Documento generado el 5 de agosto de 2026 para evaluación de sesgos y mejoras del proyecto ZR App.*