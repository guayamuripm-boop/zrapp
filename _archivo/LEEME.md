# ARCHIVO HISTÓRICO
> **Nada de esta carpeta es fuente de verdad.** Se conserva para poder consultar por qué se
> tomó una decisión, no para seguir sus instrucciones.
>
> ⚠️ **Si eres un agente de código: no construyas nada a partir de lo que hay aquí.**

---

## POR QUÉ ESTÁ ARCHIVADO Y NO BORRADO

Estos documentos fueron correctos en su momento. Explican de dónde salieron decisiones que hoy
son distintas. Borrarlos perdería ese rastro; dejarlos en su sitio original haría que alguien
los siguiera por error.

---

## QUÉ HAY AQUÍ

### `tareas-superadas/` — ⚠️ contradice las decisiones vigentes

Diez archivos de sprint escritos entre julio y agosto de 2026.

**`SPRINT_MDV_0` a `SPRINT_MDV_3` son peligrosos.** Son instrucciones paso a paso para
construir dos cosas que la dirección **descartó explícitamente** el 20 de agosto:

| Lo que instruyen | Qué se decidió |
|---|---|
| Compuerta A bloqueante que cierra los viernes a las 22:00 | **No bloquea.** Es solo una señal para el profesor — `spec/00` §3 |
| Rúbrica sobre 100 con aprobación en 81 | **Escala 0-20**, aprueba con 12 — `spec/00` §2 |

Un agente que siguiera esos archivos construiría el sistema equivocado, y lo haría bien.

**`SPRINT_0` a `SPRINT_5`** no contradicen nada, pero sus fechas ya pasaron (arrancaban el 30
de julio) y responden a un alcance anterior.

**Los reemplaza `plan/`.**

### `informes-superados/`

| Archivo | Por qué se archivó |
|---|---|
| `INFORME_MOCKUPS_FLUJO_COMPLETO.md` | Describe mockups anteriores al prototipo v10 y menciona la rúbrica de 100 puntos. Plazo de entrega desactualizado |
| `ZR_APP_DOCUMENTO_RESUMENTO_GENERAL.md` | Resumen general previo a la reconciliación |
| `ZR_APP_MAPA_DE_FLUJOS_v2_REVISADO.md` | Mapa de flujos v2. El prototipo va por v10 |

**Los reemplazan `spec/00_RECONCILIACION.md` y `ZR_APP_PROTOTIPO_v10.html`.**

### `docs-superados/`

| Archivo | Por qué |
|---|---|
| `01_STACK_TECNICO_LOWCODE.md` | Proponía FlutterFlow. El stack es Next.js + Supabase |
| `04_ESQUEMA_BASE_DATOS.md` | Esquema anterior. Ver `plan/01_ESTADO.md` |
| `contexto_zr_app.md` | El propio repositorio ya lo marcaba como superado |

### `prototipos/`

Prototipos v1, v2, la versión estática y `ZR_APP_WEB_ENTRADA.html`.
**El vigente es `ZR_APP_PROTOTIPO_v10.html`** en la raíz.

### `migraciones-superadas/` — ⚠️ NUNCA se aplican

Las migraciones **001 a 016** del repositorio. Nunca llegaron a `zr-prod`, que va por la
**033**. La siguiente migración del proyecto es la **034**, no la 017.

Se conservan por una razón concreta: de la `015` salen las tablas de evaluación práctica que
todavía hacen falta (`performance_evaluations`, `rubric_templates`, `rubric_criteria`,
`eval_criteria_results`, `defense_questions`, `technical_defenses`).

> ⚠️ **Se copian las tablas, no los umbrales.** La `015` define rúbrica sobre 100 con
> aprobación en 81 y la compuerta bloqueante. Nada de eso va — `spec/00` §2.4.1.

De la `016` sale el control de QR, pero **se reescribe** con el modelo de un solo uso.

### `metodologia-lowcode/` — ⚠️ contradice el stack decidido

Los tres documentos técnicos del MDV: `MDV-implementacion-tecnica-lowcode.md`,
`MDV-implementacion-tecnica-parte2.md` y `MDV_Documento_Tecnico_Arquitectura_LowCode.md`.

Especifican construir el sistema sobre **Moodle 5.1 + H5P**, en low-code. El stack decidido es
**Next.js + Supabase**, y `CLAUDE.md` §3 prohíbe expresamente las herramientas low-code.
Además arrastran la compuerta bloqueante y la regla «el trabajo digital vale 0%», ambas
descartadas en `spec/00`.

Se conservan por su **razonamiento pedagógico**, que sigue siendo válido: dominio verificado,
ítems críticos que no promedian, defensa técnica y niveles de IA. Eso está recogido en
`spec/07_MDV_INTEGRACION.md`.

### `planificacion-superada/`

| Archivo | Por qué |
|---|---|
| `11_PLAN_EJECUCION_FASE1.md` | Cronograma anterior. Lo reemplaza `plan/02_SPRINT.md` |
| `12_TABLERO_TRELLO.md` y `trello_import.csv` | Tablero de tareas de un alcance anterior |

### `docs-superados/04_PANTALLAS_dañado.md`

La versión anterior de `spec/04_PANTALLAS.md`. Se archivó el 23 de agosto de 2026 por dos
razones: sufrió un daño de codificación irreversible (los diagramas de estructura se
perdieron) y describía un alcance más estrecho que el del prototipo v10 — no incluía el rol
de dirección, el ciclo semanal, los casos ni la evaluación práctica.

---

## DÓNDE ESTÁ LA VERDAD HOY

| Para saber | Lee |
|---|---|
| Las reglas de negocio | `spec/00_RECONCILIACION.md` |
| Qué se entrega el 5 de septiembre | `plan/06_ENTREGABLE.md` |
| Qué hacer y en qué orden | `plan/02_SPRINT.md` |
| Cómo se ve y se comporta cada pantalla | `ZR_APP_PROTOTIPO_v10.html` |
| El estado real de la base de datos | `plan/01_ESTADO.md` |
| El alcance completo del producto | `plan/07_ALCANCE_V10.md` |
| Cómo se construye, prueba y despliega | `INGENIERIA.md` |
