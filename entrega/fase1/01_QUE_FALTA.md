# 01 · QUÉ FALTA — EL DELTA ENTRE FASE 0 Y EL v10 COMPLETO

> Inventario verificado contra el prototipo v10 (31 paneles, 182 funciones) y contra el
> esquema real de `zr-prod`, el 24 de agosto de 2026.

---

## 1. LO QUE FASE 0 YA DEJA HECHO

No se rehace. Se construye encima:

- Proyecto Next.js, tokens de marca, tipografías locales, PWA
- Entrar con cédula, los cuatro roles, middleware, contraseña temporal
- Carnet digital
- **Asistencia completa**: QR de un solo uso, escaneo, registro manual, conteo en vivo
- Material del módulo con bucket privado
- El caso del día con sus cuatro pasos y la calibración
- Dudas y su resumen
- Competencias del módulo (como lista)
- Las tablas: `qr_codes`, `cases`, `case_attempts`, `student_questions`,
  `question_digests`, `module_competencies`

---

## 2. PANTALLAS QUE FALTAN

### 2.1 Estudiante

| Pantalla | v10 | Qué añade |
|---|---|---|
| **Examen con cronómetro** | `pe-examen` | Cuenta atrás, una pregunta por vista, entrega automática, **revisión al terminar** |
| **Progreso** | `pe-progreso` | Promedio, mapa de competencias **con estado**, desglose de notas |
| **«Ver qué falló y por qué»** | `verDetallePractica` | Paso por paso del checklist, con la frase concreta y a qué guía ir |
| **Semana / calendario** | `pe-semana` | Calendario mensual y «próximo sábado» |
| Consentimiento parental | — | LOPNNA, menores de 18 |
| Registro propio | `v-registro` | Dos pasos, con código de inscripción |

### 2.2 Profesor

| Pantalla | v10 | Qué añade |
|---|---|---|
| **Evaluación práctica** | `v-evalp` | Checklist + defensa, **en una sola pantalla** |
| **Alumnos con notas** | `pp-alum` | Tabla del módulo, filas expandibles |
| **Antes de la clase** | `pp-antes` | Dónde falla el grupo |
| **Reportes** | `pp-reportes` | Distribución y **feedback anónimo** |
| Estudio | `pp-estudio` | Material y cómo se evalúa |
| Crear el caso | `v-crearcaso` | El profesor monta su semana sin depender del dev |

### 2.3 Dirección — **el rol entero**

Diez pantallas (`pd-*`). Currículo, programas, grupos, notas por módulo, salud del sistema,
activar feedback, aprobar contenido.

> ✅ **Hallazgo:** `direccion_academica` **ya existe como rol** en el enum `user_role` de la
> base. Eso resuelve la pregunta que estaba abierta en `plan/07` §7 sobre si era un rol nuevo o
> `super_admin` con otra interfaz. **Es un rol real.**

### 2.4 Administración

| Pantalla | Qué añade |
|---|---|
| Consentimientos | Ver, verificar, recordar. Habilita al menor |
| Estudiantes | Ficha completa, buscar, filtrar, exportar |
| Códigos de inscripción | Generar y controlar |
| Historial de asistencia | Más allá del sábado de hoy |

---

## 3. TABLAS QUE FALTAN

### 3.1 Se traen de la migración archivada `015`

⚠️ **Se copian las tablas, NO los umbrales.** La 015 define rúbrica sobre 100 con aprobación en
81 y la compuerta bloqueante. **Nada de eso va** — `spec/00` §2.4.1. Los umbrales correctos ya
están en `system_config` (escala 0-20, aprueba con 12).

| Tabla | Para |
|---|---|
| `performance_evaluations` | La evaluación del sábado |
| `rubric_templates`, `rubric_criteria` | El checklist con ítems críticos |
| `eval_criteria_results` | El resultado por ítem |
| `defense_questions`, `technical_defenses` | La defensa técnica |

### 3.2 Ya existen en `zr-prod` y hoy están vacías

`exams` (con `duration_minutes`) · `exam_questions` · `exam_attempts` · `exam_answers` ·
`mastery_map` · `feedback_micro` · `feedback_macro` · `parental_consents` ·
`module_enrollments` (con los 6 campos de nota correctos) · `learning_guides` ·
`notifications` · `push_subscriptions`

> **`module_enrollments` ya implementa el modelo de notas decidido:** `theory_score`,
> `practice_score`, `participation_score`, `participation_weight`, `passing_threshold`,
> `final_score`. No hay que diseñarlo, hay que usarlo.

### 3.3 Se crean nuevas

| Tabla | Para |
|---|---|
| `weekly_activities`, `activity_completions` | El ciclo semanal, **solo registro, sin efecto vinculante** |

---

## 4. EDGE FUNCTIONS

### 4.1 Ya desplegadas — hay que revisarlas, no confiar

`submit-attempt` · `grade-answer` · `create-student` · `create-staff-user` ·
`send-push` · `approve-professor` · `delete-account` · `claim-snack` ·
`request-rehabilitation` · `approve-rehabilitation` · `respond-rehabilitation`

⚠️ **Nueve de las trece tienen `verify_jwt: false`.** Y ninguna se ha revisado contra las
decisiones vigentes de `spec/00`. Que existan no significa que hagan lo correcto — es
exactamente lo que pasó con `validate-scan`.

### 4.2 Faltan

| Función | Para |
|---|---|
| `guardar-evaluacion-practica` | Checklist + defensa, con el cálculo **en el servidor** |
| `cerrar-modulo` | Nota final del módulo desde `module_enrollments` |
| `activar-feedback` | Dirección abre el feedback de un módulo |

---

## 5. LAS DECISIONES QUE SIGUEN ABIERTAS

**Ninguna se resuelve inventando.** Todas son de dirección.

| # | Pregunta | Bloquea |
|---|---|---|
| 1 | 🔴 **¿Cuál es el currículo real?** Los 13 módulos de la base tienen nombres inventados y no hay listado formal de competencias | **Casi todo Fase 1** |
| 2 | ¿Cuánto tardó montar la primera semana de contenido, cronometrado? | Si hace falta generación con IA |
| 3 | ¿Las 9 funciones con `verify_jwt: false` son así a propósito? | La revisión de seguridad |
| 4 | ¿Va a haber grupo de control para medir el piloto? Si no se decide antes del 5 de septiembre, ya no se puede medir | La medición del trimestre |
| 5 | ¿Se integra Odoo, para el registro con código por WhatsApp? | El registro propio del estudiante |

> **La 1 es la que más pesa.** Sin currículo real no hay competencias, sin competencias no hay
> mapa de dominio, y sin mapa de dominio la pantalla de progreso queda vacía. Es lo primero que
> hay que resolver después del piloto.

---

## 6. LO QUE **NO** SE CONSTRUYE, AUNQUE ESTÉ EN EL v10

| Del prototipo | Por qué | Cuándo |
|---|---|---|
| Entrada por Odoo (`v-odoo`, `simOdoo`) | Requiere integrar Odoo | Cuando se decida |
| **Generación de casos con IA** (`generarConIA`, `generarSemanaIA`, `generarPregIA`) | Primero hay que saber cuánto cuesta escribirlos a mano | Cuando el contenido sea el cuello de botella |
| Simulación de pago | Fase 2 | — |

Y todo lo prohibido de `00_EMPIEZA_AQUI.md` §5.
