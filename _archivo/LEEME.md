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

Prototipos v1, v2 y la versión estática. **El vigente es `ZR_APP_PROTOTIPO_v10.html`** en la
raíz.

---

## DÓNDE ESTÁ LA VERDAD HOY

| Para saber | Lee |
|---|---|
| Las reglas de negocio | `spec/00_RECONCILIACION.md` |
| Qué se entrega el 5 de septiembre | `plan/06_ENTREGABLE.md` |
| Qué hacer y en qué orden | `plan/02_SPRINT.md` |
| Cómo se ve y se comporta cada pantalla | `ZR_APP_PROTOTIPO_v10.html` |
| El estado real de la base de datos | `plan/01_ESTADO.md` |
