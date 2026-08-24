# ⚠️ ESTAS MIGRACIONES NO SON EL ESQUEMA VIGENTE

> **No las apliques a `zr-prod`.** Crearían una base distinta de la que está en producción.

---

## LA SITUACIÓN

| | Aquí | En `zr-prod` |
|---|---|---|
| Última migración | **016** | **033** |
| Estado | Escritas, nunca aplicadas ahí | Vivas, con datos reales |

El repositorio está **17 migraciones atrás**. Alguien construyó sobre esa base y estos
archivos no lo reflejan.

⚠️ `CLAUDE.md` §5 dice que estas migraciones están «YA APLICADAS». **No lo están** en
`zr-prod`. Ver `plan/01_ESTADO.md` para el detalle completo.

---

## QUÉ SIRVE Y QUÉ NO

### ✅ Sirve de aquí

- **`016_qr_control.sql`** — el QR de un solo uso. Es la decisión vigente (`spec/00` §5) y
  **no está en la base**. Hay que aplicarlo.

- **De `015_mdv_integration.sql`, solo estas tablas:** `rubric_templates`, `rubric_criteria`,
  `performance_evaluations`, `eval_criteria_results`, `defense_questions`,
  `technical_defenses`. Son la evaluación práctica y tampoco están en la base.

### ❌ No sirve

**De `015`, todo lo demás:**

| Qué trae | Por qué no va |
|---|---|
| Rúbrica sobre 100 con aprobación en 81 | Se decidió **escala 0-20**, aprueba con 12 — `spec/00` §2 |
| `weekly_progress` y el trigger `fn_calculate_gate_a` | La compuerta **no bloquea** — `spec/00` §3 |
| Edge Function `close-gate-a` | Ídem |
| `reflection_tickets`, `workshop_role_assignments`, `ia_declarations` | Fuera del alcance del MVP |

**Las migraciones 001 a 014** describen un esquema que la base ya superó. Se conservan como
referencia histórica.

---

## QUÉ HACER

Está en `plan/02_SPRINT.md`, tareas T-03 a T-06:

1. Volcar el esquema real de `zr-prod` a `000_esquema_base.sql`
2. Mover estos archivos a `_archivo/migraciones-superadas/`
3. Migración nueva con las tablas de evaluación, **con umbrales de 0-20**
4. Migración nueva con el QR de un solo uso
5. Migración que cierre los hallazgos de seguridad

**Hasta que eso ocurra, esta carpeta es referencia, no instrucción.**
