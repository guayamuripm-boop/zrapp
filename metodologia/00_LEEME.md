# METODOLOGÍA — EL MODELO QUE LA APP TIENE QUE SOSTENER

> Esta carpeta responde a **«por qué la app funciona así»**.
> `spec/` responde a **«qué se construye»**. `INGENIERIA.md` a **«cómo se construye»**.

---

## POR QUÉ EXISTE ESTA CARPETA

El 23 de agosto de 2026 se archivaron por error los tres documentos técnicos del MDV, porque
especifican Moodle 5.1 + H5P + FlutterFlow y eso contradice el stack decidido.

**La parte del stack sí estaba superada. El modelo no.** Dentro de esos documentos había
contenido de Fase 1 que no está en ningún otro sitio: los ocho indicadores, la línea base con
grupo de control, la encuesta de motivación, el presupuesto de horas para montar una semana, y
el respaldo y monitoreo.

Esta carpeta rescata eso, **sin el Moodle**.

Los originales siguen en `_archivo/metodologia-lowcode/`, solo como rastro histórico. Sus
instrucciones de instalación, plugins y FlutterFlow **no se siguen**.

---

## QUÉ HAY AQUÍ

| Archivo | Qué responde |
|---|---|
| `01_MODELO.md` | Cómo se evalúa, cómo se dosifica la semana, qué se le permite a la IA |
| `02_MEDICION.md` | Cómo se demuestra que el modelo funcionó. Los ocho indicadores y la línea base |
| `03_PRODUCCION.md` | Cuánto cuesta montar una semana de contenido y cómo se monta |

---

## LO QUE DE ESOS DOCUMENTOS **NO** SE SIGUE

Estas cuatro cosas están en los originales y fueron **descartadas** por dirección el 20 de
agosto de 2026. Si las lees ahí, están superadas por `spec/00_RECONCILIACION.md`:

| En los originales | Lo vigente |
|---|---|
| Rúbrica sobre 100, aprueba con 81 | **Escala 0-20.** Aprueba con 12 (con 10 el primer módulo) |
| «Compuerta A es real» — bloquea el sábado si no completó el trabajo digital | **La compuerta es señal, no bloqueo.** Nadie se queda fuera del taller |
| «El trabajo digital vale 0% y habilita» | El trabajo de la semana **es evidencia de participación**, no una llave |
| Todo el stack: Moodle, H5P, FlutterFlow, plugins, Docker | **Next.js + Supabase.** Ver `CLAUDE.md` §3 |

> ⚠️ La regla 4 de los originales («Compuerta A es real», con el disparador de los viernes a
> las 22:00) **no se implementa**. Ni siquiera como opción configurable.

---

## LO QUE SÍ SIGUE VIGENTE Y ESTÁ EN EL PROTOTIPO v10

- **La escala de dominio** y los estados de competencia
- **Los ítems críticos que no promedian** — avisan, no topan la nota
- **La defensa técnica** con niveles de 1 a 4
- **El ciclo semanal por casos**, de lunes a sábado
- **La duda del miércoles/jueves** como guion de la clínica del sábado
- **Los niveles de IA N0 a N4**
- **«Repetir no castiga»** — el intento se registra, no penaliza
