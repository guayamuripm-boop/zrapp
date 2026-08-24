# 07 · EL ALCANCE COMPLETO, DERIVADO DEL PROTOTIPO v10
> Escrito el 23 de agosto de 2026, después de inventariar `ZR_APP_PROTOTIPO_v10.html`
> completo: 12 vistas, 31 paneles, 182 funciones, 4.404 líneas.
>
> **Este documento dice QUÉ se construye y en qué orden.**
> `06_ENTREGABLE.md` sigue mandando sobre el alcance del **5 de septiembre**.
> Este manda sobre todo lo que viene después.

---

## 1. LA DECISIÓN

**El prototipo v10 es el producto.** No es una maqueta de la que se toman ideas: es la
especificación. Se replica.

Pero el v10 contiene cosas que ya estaban decididas como diferidas. Por eso el alcance va en
**tres niveles**, y el nivel decide el orden:

| Nivel | Qué es | Cuándo |
|---|---|---|
| **N1 · Núcleo** | Lo que hace falta para que una clase real funcione sin papel | **5 de septiembre** |
| **N2 · El producto** | El resto del prototipo v10 | Septiembre – noviembre |
| **N3 · Diferido** | Lo que está en el v10 pero no se construye todavía | Ver §6 |

> **Cómo leer esto si vas a construir:** haz N1 completo antes de tocar N2. Dentro de cada
> nivel, el orden de los épicos es el orden de construcción — cada uno depende del anterior.

---

## 2. INVENTARIO COMPLETO DEL PROTOTIPO

Las 31 pantallas del v10, con su nivel. Ninguna se olvidó.

### 2.1 Público

| # | Pantalla | v10 | Nivel |
|---|---|---|---|
| 1 | Entrada / landing | `v-odoo` | N1 |
| 2 | Iniciar sesión con cédula | `v-login` | N1 |
| 3 | Registro en dos pasos | `v-registro` | N3 |
| 4 | Consentimiento parental | — | N2 |

### 2.2 Estudiante — 5 pestañas + 3 pantallas completas

| # | Pantalla | v10 | Nivel |
|---|---|---|---|
| 5 | Inicio — tira de la semana, indicadores, acción del día | `pe-inicio` | N1 parcial · N2 completo |
| 6 | Semana — calendario y próximo sábado | `pe-semana` | N2 |
| 7 | Material — guías y PDF | `pe-mater` | N2 |
| 8 | Progreso — promedio, mapa de competencias, notas | `pe-progreso` | N2 |
| 9 | Perfil y carnet digital | `pe-perfil` | **N1** |
| 10 | Examen con cronómetro y revisión | `pe-examen` | N2 |
| 11 | Caso PBL con calibración de confianza | `pe-caso` | N2 |
| 12 | Escanear el QR | `v-escaneo` | **N1** |

### 2.3 Profesor — 5 pestañas + 2 pantallas completas

| # | Pantalla | v10 | Nivel |
|---|---|---|---|
| 13 | Hoy — asistencia en vivo | `pp-hoy` | **N1** |
| 14 | Antes de la clase — dónde falla el grupo | `pp-antes` | N2 |
| 15 | Dudas — resumen para la clínica | `pp-dudas` | N2 |
| 16 | Estudio — material y cómo se evalúa | `pp-estudio` | N2 |
| 17 | Alumnos — tabla de notas | `pp-alum` | N2 |
| 18 | Reportes — distribución y feedback anónimo | `pp-reportes` | N2 |
| 19 | Perfil | `pp-perfil` | N1 |
| 20 | Evaluación práctica en una pantalla | `v-evalp` | N2 |
| 21 | Crear el caso de la semana | `v-crearcaso` | N2 |

### 2.4 Administración — 5 pestañas + 1 pantalla completa

| # | Pantalla | v10 | Nivel |
|---|---|---|---|
| 22 | Panel — hoy en la academia | `pa-inicio` | **N1** |
| 23 | Alumnos — ficha completa, buscar, CSV | `pa-est` | N1 parcial |
| 24 | Asistencia — hoy e historial | `pa-asist` | **N1** |
| 25 | Códigos de inscripción | `pa-cod` | N3 |
| 26 | Consentimientos pendientes | `pa-cons` | N2 |
| 27 | Mostrar el QR en pantalla | `pa-cod` / `mostrarQR` | **N1** |

### 2.5 Dirección — 5 pestañas + 4 hijas

| # | Pantalla | v10 | Nivel |
|---|---|---|---|
| 28 | Inicio — acciones rápidas y alertas | `pd-inicio` | N2 |
| 29 | Salud del sistema | `pd-salud` | N2 |
| 30 | Activar feedback por programa | `pd-fb` | N2 |
| 31 | Alumnos por programa | `pd-estudiantes` | N2 |
| 32 | Progreso y notas por módulo | `pd-progNotas` | N2 |
| 33 | Módulos — historial | `pd-modulos` | N2 |
| 34 | Currículo — 13 módulos | `pd-curriculo` | N2 |
| 35 | Montar contenido, aprobar borradores | `pd-estudio` | N2 · con IA en N3 |
| 36 | Grupos — programas activos | `pd-programas` | N2 |
| 37 | Perfil | `pd-perfil` | N1 |

---

## 3. NIVEL 1 — EL NÚCLEO DEL PILOTO

**Criterio de éxito, binario:** al terminar la clase del 5 de septiembre, los 24 estudiantes
presentes están registrados y nadie escribió un nombre en una hoja.

Está desglosado tarea por tarea en `02_SPRINT.md`. Aquí solo el mapa de qué toca qué.

### Épico A · Cimientos

| Tarea | Qué | Toca |
|---|---|---|
| **T-00** | Crear el proyecto `zr-dev` | Infraestructura |
| **T-00b** | Resolver la cuenta del CLI y quién más despliega a `zr-prod` | — |
| **T-00c** | **Activar el CI** — mover `.github/ci-pendiente.yml` a `.github/workflows/`. Requiere permiso `workflow` en el token | `.github/` |
| **T-03** | Volcar el esquema real de `zr-prod` al repositorio como `000_esquema_base.sql` | `supabase/migrations/` |
| **T-03b** | Descargar las 13 Edge Functions desplegadas al repositorio | `supabase/functions/` |
| **T-06** | Cerrar los 3 hallazgos `ERROR` y la política de `student_qr_secrets` | 3 vistas + 1 tabla |
| **T-07** | Proyecto Next.js 15 + Tailwind 4 + tokens + fuentes locales | — |

### Épico B · Identidad

| Tarea | Qué | Toca |
|---|---|---|
| **T-08** | Entrar con cédula, los 4 roles, middleware por grupo de ruta | `profiles`, `students`, `teachers`, `admins` |
| **T-08b** | Contraseña temporal con cambio obligatorio | `profiles` |
| **T-11** | Carnet digital, visible sin señal | `v_students` |

### Épico C · Asistencia — la razón de ser del piloto

| Tarea | Qué | Toca |
|---|---|---|
| **T-01** | **Probar la cámara en el taller, con 3 teléfonos.** Riesgo máximo | — |
| **T-04** | Migración: `qr_codes` de un solo uso. Retirar `attendance.qr_window_seconds` y `qr_drift_tolerance` | `qr_codes`, `system_config` |
| **T-04b** | Migración: crear las 5 claves de `system_config` que faltan y el prototipo ya usa — `spec/00` §6.1 | `system_config` |
| **T-09** | Administración muestra el QR. Muere al usarse, aparece otro | Edge `provision-qr` |
| **T-10** | El estudiante escanea. Asistencia **y** refrigerio en el mismo evento | Edge `validate-scan`, `claim-snack`, `attendance_events` |
| **T-10b** | **Registro manual con motivo.** Sin esto el criterio es imposible | `attendance_events` |
| **T-13** | El profesor ve el contador en vivo | Realtime |

### Épico D · Diagnóstico de entrada

| Tarea | Qué | Toca |
|---|---|---|
| **T-05** | Migración: `entry_diagnostics` + vista `v_diagnostico_cohorte` | tabla nueva |
| **T-12** | La pantalla del diagnóstico — 8 a 10 preguntas, casi todo a toques | — |
| **T-13b** | El profesor lo abre y a los estudiantes les aparece **sin recargar** | Realtime, `class_sessions` |
| **T-13c** | El retrato del grupo, agregado | `v_diagnostico_cohorte` |

### Épico E · Entrega

| Tarea | Qué |
|---|---|
| **T-18** | PWA instalable — manifiesto, Serwist, probada en 3 teléfonos |
| **T-18b** | El botón del sitio web: `Sign in` → **Aula Virtual** |
| **T-19** | Cargar la cohorte real. **Solo después de cerrar los hallazgos ERROR** |
| **T-20** | Congelar. Recorrido de los 4 roles. Plan B escrito |

---

## 4. NIVEL 2 — EL PRODUCTO DEL PROTOTIPO

Empieza el **8 de septiembre**, con el piloto ya corrido y sus fallos ordenados.

El orden no es negociable: cada épico depende del anterior. **Un épico se cierra cuando su
pantalla funciona de punta a punta en un teléfono**, no cuando «está el backend».

### Épico F · El ciclo semanal *(semana del 8)*
Es lo que convierte la app en algo que el estudiante abre entre semana.

- La tira de seis días con sus estados (`done` / `today` / `future` con candado)
- La tarjeta del día, distinta cada día
- La compuerta como **señal, no bloqueo**: se puede mirar el futuro, no trabajarlo
- Calendario mensual y «Próximo sábado»
- Envío de dudas y su agrupación por tema

**Tablas:** `weekly_activities`, `activity_completions` *(se traen de 015, solo como registro,
sin efecto vinculante)*, `class_sessions`.
**Terminado cuando:** un estudiante abre la app un martes y sabe qué tiene que hacer.

### Épico G · Materiales *(semana del 8)*
- Guías y PDF por módulo, módulo actual y anteriores
- Registro de vistas
- Subida desde el panel del profesor

**Tablas:** `content_items`, `content_views`, `learning_guides`.

### Épico H · Casos *(semana del 15)*
- Los cuatro pasos: hipótesis → medición → razonamiento → confianza
- La referencia **no se revela** sin completar los cuatro
- **La calibración de confianza** — los cuatro mensajes según acierto × confianza
- El objeto del caso se adapta: vehículo, muestra, pieza, equipo
- Caso sintético el martes, caso real el miércoles

**Terminado cuando:** un estudiante que se equivoca estando seguro recibe el mensaje que le
dice exactamente eso.

### Épico I · Exámenes *(semana del 22)*
- Cronómetro con avisos a 5 min y 1 min, entrega automática al agotarse
- Una pregunta por pantalla, sin poder avanzar sin responder
- Corrección **en `submit-attempt`**, nunca en el navegador
- El cliente lee de `v_exam_questions_student` — **jamás recibe `correct_answer`**
- **La revisión pregunta por pantalla al terminar:** qué respondió, qué era, dónde repasar
- Diagnóstica del viernes, sin peso; examen del módulo, 50%
- Constructor de exámenes del profesor

**Tablas:** `exams`, `exam_questions`, `exam_attempts`, `exam_answers`.
**Edge:** `submit-attempt`, `grade-answer` *(ya desplegadas — revisar contra `spec/00`)*.

### Épico J · Evaluación práctica *(semana del 29)*
El primer módulo ya tiene algo que evaluar. Antes de esto no había.

- **Toda la evaluación en una sola pantalla**, sin navegar ni perder lo hecho
- Checklist a toques, con los ítems marcados `CRÍTICO`
- Defensa técnica: cada pregunta con nivel de 1 a 4
- Nota = `checklist × 70% + defensa × 30%`, sobre 20, **calculada en el servidor**
- **El ítem crítico alerta, no topa la nota** — con umbrales 0-20, no la rúbrica de 100

**Tablas a traer de 015, con los umbrales corregidos:** `performance_evaluations`,
`rubric_templates`, `rubric_criteria`, `eval_criteria_results`, `defense_questions`,
`technical_defenses`.

> ⚠️ **Se copian las tablas, no los umbrales.** La 015 trae rúbrica sobre 100 con aprobación
> en 81 y la compuerta bloqueante. Nada de eso va. Ver `spec/00` §2.4.1.

### Épico K · Progreso y notas *(semana del 29)*
- Promedio del módulo con el mensaje explícito de si va aprobando
- Mapa de competencias con sus cuatro estados
- Desglose de notas con la cuenta escrita
- **«Ver qué falló y por qué»** — paso por paso, con la frase concreta y a qué guía ir

**Sin puntos, sin niveles, sin insignias, sin comparación entre estudiantes.**

**Terminado cuando:** un estudiante que reprobó una competencia sabe qué leer para arreglarlo.

### Épico L · Paneles del profesor *(octubre)*
- Antes de la clase: dónde falla el grupo, qué preguntaron
- Alumnos: tabla de notas con filas expandibles
- Reportes: distribución del módulo
- **Feedback anónimo — promedio del grupo, solo con 3 o más respuestas, nunca individual**

### Épico M · Dirección *(octubre)*
Las diez pantallas de `pd-*`. La operación y la vigilancia **separadas**.

- Currículo de 13 módulos con sus competencias
- Programas y grupos: asignar profesor y módulo
- Progreso y notas por módulo
- Activar el feedback por programa
- Salud del sistema, con **los ocho indicadores** de `metodologia/02_MEDICION.md`
- **El correo automático de los lunes** a coordinación con esos ocho indicadores
- Aprobar o rechazar los borradores de contenido del profesor

### Épico N · Consentimientos y PWA completa *(octubre)*
- Consentimiento parental LOPNNA para menores de 18: subir documento, verificar, recordar
- Registro propio del estudiante en dos pasos
- Escaneo **sin conexión**, con sincronización idempotente
- Notificaciones push *(`send-push` ya está desplegada)*

---

## 5. MAPA DE COBERTURA — QUÉ FALTA EN LA BASE

Contra las 29 tablas de `zr-prod`.

### 5.1 Ya existe y sirve
`profiles` · `students` · `teachers` · `admins` · `programs` · `modules` · `cohorts` ·
`class_sessions` · `module_enrollments` *(con los 6 campos de nota correctos)* ·
`attendance_events` *(con `snack_claimed_at`)* · `student_qr_secrets` · `exams`
*(con `duration_minutes`)* · `exam_questions` · `exam_attempts` · `exam_answers` ·
`content_items` · `content_views` · `learning_guides` · `mastery_map` · `feedback_micro` ·
`feedback_macro` · `notifications` · `push_subscriptions` · `parental_consents` ·
`system_config` · `audit_log` · `professor_applications` · `exam_rehabilitation_requests`

### 5.2 Falta crear

| Tabla | Para | Nivel |
|---|---|---|
| `qr_codes` | El código de un solo uso | **N1** |
| *(no es tabla)* `system_config` | **Faltan 5 claves y sobran 2** — `spec/00` §6.1 | **N1** |
| `entry_diagnostics` | El diagnóstico de entrada | **N1** |
| `performance_evaluations` | La evaluación del sábado | N2 |
| `rubric_templates`, `rubric_criteria` | El checklist con ítems críticos | N2 |
| `eval_criteria_results` | El resultado por ítem | N2 |
| `defense_questions`, `technical_defenses` | La defensa técnica | N2 |
| `weekly_activities`, `activity_completions` | El ciclo semanal, **solo registro** | N2 |
| `student_questions` | Las dudas del jueves | N2 |
| `cases` | Casos sintéticos y reales | N2 |
| `case_attempts` | Hipótesis, medición, razonamiento, **confianza** | N2 |

### 5.3 Las 13 Edge Functions desplegadas

Están vivas en `zr-prod` y **el repositorio solo conoce una**. Hay que descargarlas y
revisarlas contra `spec/00` antes de confiar en ellas:

`validate-scan` · `provision-qr` · `claim-snack` · `create-student` · `create-staff-user` ·
`submit-attempt` · `grade-answer` · `send-push` · `approve-professor` · `delete-account` ·
`request-rehabilitation` · `approve-rehabilitation` · `respond-rehabilitation`

> ⚠️ **Nueve de ellas tienen `verify_jwt: false`.** Hay que revisar una por una si eso es
> intencional o es un hueco de seguridad.
>
> ⚠️⚠️ **`validate-scan` y `provision-qr` desplegadas implementan el modelo de QR equivocado**
> — el estudiante lleva un TOTP rotativo y el profesor lo escanea. Es lo contrario de lo
> decidido. Ver `plan/01_ESTADO.md` §5.2. **No son un adelanto para el épico C: son deuda.**

---

## 6. NIVEL 3 — LO QUE ESTÁ EN EL v10 Y **NO** SE CONSTRUYE

Está en el prototipo, pero no entra. Si alguien lo pide, la respuesta es esta tabla.

| Del v10 | Por qué no | Cuándo |
|---|---|---|
| **Entrada por Odoo** (`v-odoo`, `simOdoo`) | Requiere integrar Odoo | Cuando la integración esté decidida |
| **Registro con código por WhatsApp** | Depende de Odoo | Igual |
| **Generación de contenido con IA** (`generarConIA`, `generarSemanaIA`, `generarPregIA`, `generarChecklistIA`) | Es la última pieza, no la primera. Primero hay que saber cuánto cuesta escribir el contenido a mano | Cuando el contenido sea el cuello de botella |
| **Códigos de inscripción** (`pa-cod`) | Las cuentas las carga administración | Con varias cohortes |
| **Simulación de pago** (`simOdoo`) | Es Fase 2 | Fase 2 |
| Pagos, cuotas, saldos, financiamiento | Fase 2 | — |
| Puntos, insignias, rachas, ranking, canjes | Fase 2 | — |
| Video micro-learning | Fase 2 | — |
| Red social, portafolio público, comentarios | Fase 3 | — |
| Simulador visual, certificados, roles de especialización | Fase 3 | — |
| Google Classroom | Descartado, no se hace nunca | — |
| App nativa, App Store, Play Store | Descartado en Fase 1 | — |
| Mensajería privada entre usuarios | **Prohibida** por seguridad de menores | Nunca |
| Reprobación automática por inasistencia | **Prohibida** por la academia | Nunca |
| Bloqueo de acceso a aulas o talleres | **Prohibido** por el Ministerio | Nunca |

> Las tablas de Fase 2 y 3 **no se crean todavía**. No se agregan «por si acaso».

---

## 7. LO QUE HAY QUE DECIDIR

Preguntas abiertas que bloquean parte de N2. **No las resuelvas inventando.**

| # | Pregunta | Bloquea |
|---|---|---|
| 1 | ¿Quién más despliega a `zr-prod`? Hay una función que apunta a otro repositorio | **Todo. Es lo primero** |
| 2 | ¿`dirección` es un rol nuevo o es `super_admin` con otra interfaz? El v10 lo trata como rol aparte; la base solo tiene `super_admin` | Épico M |
| 3 | ¿Los 13 módulos del currículo son los reales? Los de la base son inventados | Épico M, y el contenido |
| 4 | ¿Cuánto tarda una persona en escribir un caso? **Hay una estimación: 3-4 h por semana en régimen** (`metodologia/03_PRODUCCION.md` §1). Falta cronometrar la semana real del 7 de septiembre para confirmarla | N3 · IA |
| 5 | ¿Las 9 Edge Functions con `verify_jwt: false` son así a propósito? | Épico A |
| 6 | **¿Va a haber grupo de control para medir el piloto?** Si no se decide antes del 5 de septiembre, ya no se puede medir — `metodologia/02_MEDICION.md` §5 | La medición del trimestre |

---

## 8. HISTORIAL

| Fecha | Cambio |
|---|---|
| 2026-08-23 | Documento creado. Sale del inventario completo del prototipo v10 y del estado verificado de `zr-prod`: 29 tablas, 13 Edge Functions, migración 033, 62 hallazgos de seguridad abiertos |
