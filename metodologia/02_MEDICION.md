# 02 · MEDICIÓN — CÓMO SE DEMUESTRA QUE ESTO FUNCIONÓ

> **La frase que resume este documento:** sin línea base, dentro de doce semanas nadie va a
> poder demostrar nada.

---

## 1. EL PROBLEMA QUE RESUELVE

El piloto va a producir opiniones: que los estudiantes están más motivados, que el profesor
tiene más control, que la app ayudó. **Una opinión no sobrevive a una reunión de junta.**

Lo que sobrevive es un número comparado contra otro número tomado antes.

Y hay un plazo: **lo que no se capture antes de la primera clase, ya no se puede capturar.**

---

## 2. LA LÍNEA BASE — CUATRO INSTRUMENTOS, ANTES DE EMPEZAR

| Instrumento | Cuándo | Cómo | Por qué |
|---|---|---|---|
| **Prueba práctica común** | Antes de la semana 1, a los **dos** grupos | Misma tarea, misma lista de cotejo, mismo evaluador | Es la única comparación limpia entre el grupo piloto y el de control |
| **Cuestionario de conocimientos previos** | Igual | Presencial | Permite calcular **el cambio**, no solo el resultado final |
| **Encuesta de motivación** | Igual | Anónima, 6 ítems | Se repite al cierre. Detecta la caída esperable de las primeras semanas |
| **Datos históricos del módulo** | Ahora | Exportar de Odoo la reprobación de las **tres cohortes anteriores** | Contexto sin el cual cualquier resultado es discutible |

> ⚠️ **El grupo de control es la pieza que más se olvida y la que más vale.** Sin una cohorte
> que siga con el método anterior, cualquier mejora se puede atribuir a que este grupo era
> mejor. Hay que decidir **ya** si va a haberlo.

### 2.1 El diagnóstico de entrada del 5 de septiembre no es la línea base

Son cosas distintas y conviene no confundirlas:

| | Diagnóstico de entrada | Línea base |
|---|---|---|
| Para qué | Que el profesor sepa de dónde parte cada quien | Demostrar el efecto del modelo |
| A quién | Solo la cohorte piloto | Piloto **y** grupo de control |
| Quién lo ve | El profesor, agregado | Dirección, a las 12 semanas |

El diagnóstico está especificado en `plan/05_DIAGNOSTICO.md`. La línea base **no está
planificada todavía** — ver §5.

---

## 3. LA ENCUESTA DE MOTIVACIÓN — SEIS ÍTEMS

Escala de 1 a 5. Anónima. Se aplica en la **semana 0, la 6 y la 12**.

1. Siento que estoy aprendiendo algo que voy a usar en un taller real.
2. **Sé exactamente qué me falta para dominar lo que estoy estudiando.**
3. **Cuando me equivoco, sé qué hacer para corregirlo.**
4. Puedo decidir cosas sobre mi propio aprendizaje.
5. **Si me esfuerzo más, mi resultado mejora.**
6. Me siento parte de un grupo que trabaja junto.

**Los ítems 2, 3 y 5 son los que este modelo debería mover primero.** Son exactamente lo que
la pantalla de progreso y el «ver qué falló y por qué» existen para producir.

> **Criterio de alarma:** si a la semana 6 los ítems 2, 3 y 5 no se movieron, el problema es de
> **implementación, no de diseño**. Algo se construyó mal o no se está usando. Es una señal
> para revisar la app, no para revisar el modelo.

Los ítems 1, 4 y 6 se mueven más lento y dependen del profesor, no de la app.

---

## 4. LOS OCHO INDICADORES

Se revisan **cada dos semanas**, en la reunión de ajuste.

| # | Indicador | De dónde sale en ZR App |
|---|---|---|
| 1 | **Completitud antes del sábado** | `activity_completions` sobre `weekly_activities` de la semana |
| 2 | **Señalados por la compuerta** | Cuántos llegan al sábado sin haber trabajado la semana. **Es una señal, no una exclusión** |
| 3 | **Dominio al primer intento** | `exam_attempts` / `performance_evaluations` con `intento = 1` y estado *dominada* |
| 4 | **Intentos hasta el dominio** | Conteo de intentos por competencia y estudiante |
| 5 | **Fallo en ítems críticos** | `eval_criteria_results` de los criterios marcados `critico` |
| 6 | **Nivel promedio de defensa** | `technical_defenses`, promedio de los niveles 1-4 |
| 7 | **Retención diferida** | Cuestionario de la semana 6 sobre contenido de la semana 2 |
| 8 | **Asistencia y deserción** | `attendance_events` por `class_session` |

### 4.1 El indicador que más se usa es el 5

**Dice qué error de seguridad se repite, y con qué profesor.** No es para calificar al
profesor: es para saber qué paso hay que enseñar distinto.

Si el mismo ítem crítico falla en 8 de 24 estudiantes, el problema no está en los 8.

### 4.2 Cómo llegan

**Un informe que hay que ir a buscar no se mira. Uno que llega, sí.**

Los ocho van en el panel de dirección (`/inicio/salud`, `plan/07` épico M) **y** en un correo
automático los lunes a coordinación.

> ⚠️ El envío automático de los lunes **no está en `plan/07`**. Hay que añadirlo al épico M.

### 4.3 Lo que NO se mide

- Tiempo dentro de la app. Un estudiante rápido no es peor.
- Comparaciones entre estudiantes visibles para ellos. Ver `CLAUDE.md` §7.
- Nada individual del feedback anónimo.

---

## 5. LO QUE ESTO OBLIGA Y TODAVÍA NO ESTÁ PLANIFICADO

Ninguna de estas cuatro cosas está en `plan/02_SPRINT.md` ni en `plan/07_ALCANCE_V10.md`.
**Son decisiones de dirección, no de ingeniería:**

| # | Qué hay que decidir | Antes de |
|---|---|---|
| 1 | **¿Va a haber grupo de control?** Si sí, cuál cohorte | La primera clase |
| 2 | **¿Quién aplica la prueba práctica común a los dos grupos?** | La primera clase |
| 3 | ¿Se pueden exportar de Odoo las tres cohortes anteriores? | La reunión de las 12 semanas |
| 4 | ¿Quién recibe el informe de los lunes y quién actúa sobre él? | El primer lunes |

**Las dos primeras vencen el 5 de septiembre.** Después de esa fecha ya no hay «antes» que
medir.

---

## 6. ORIGEN

`_archivo/metodologia-lowcode/MDV-implementacion-tecnica-lowcode.md` §5 (los ocho indicadores)
y `MDV-implementacion-tecnica-parte2.md` §4 (línea base y encuesta).

Las consultas SQL de los originales son de Moodle y **no sirven**: hay que reescribirlas contra
el esquema de `zr-prod`. Los indicadores sí sirven tal cual.
