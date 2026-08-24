# 01 · EL MODELO — CÓMO SE EVALÚA Y CÓMO SE DOSIFICA LA SEMANA

> Rescatado de los documentos técnicos del MDV, **sin la parte de Moodle**.
> Donde el original contradice a `spec/00_RECONCILIACION.md`, manda `spec/00`.

---

## 1. LAS CUATRO REGLAS DEL MODELO

Son las que la aplicación tiene que hacer ciertas. Tres siguen vigentes; la cuarta se descartó.

### Regla 1 · La nota nace el sábado

**No existe una nota del trabajo digital.** Lo que el estudiante hace de lunes a viernes se
registra como participación y como evidencia, pero no produce una calificación.

La nota sale de dos sitios, y los dos son del sábado: el **examen teórico** y la **evaluación
práctica**.

Implicación técnica: ninguna tabla del ciclo semanal lleva una columna de nota con peso.
`weekly_activities` y `activity_completions` son **registro, no calificación**.

### Regla 2 · Los puntos críticos no promedian

Un ítem crítico es un paso que en un taller real mata a alguien o cuesta muy caro: no usar
guantes con electrolito, no desconectar el borne negativo primero.

Fallar uno **no baja la nota**. Marca la evaluación como *requiere refuerzo* y **genera una
alerta al profesor**.

> ⚠️ Los originales lo implementan topando la nota. **Eso cambió.** El ítem crítico avisa; el
> profesor decide qué hacer. Ver `spec/00` §2.4.

Por qué: una nota que se desploma por un paso enseña a esconder el error. Una alerta que llega
al profesor hace que el paso se repase el sábado siguiente.

### Regla 3 · Repetir no castiga

El número de intento **se registra pero no afecta la nota final**. La nota es el estado de
dominio alcanzado, no el promedio de los tramos.

Por qué: si el segundo intento vale menos que el primero, el estudiante que más necesita
repetir es el que menos gana repitiendo.

### ~~Regla 4 · La compuerta bloquea~~ — **DESCARTADA**

Los originales especifican un disparador los viernes a las 22:00 que marca al estudiante como
`no_evalua` si no completó el trabajo de la semana.

**No se implementa.** La compuerta es una **señal para el profesor**, no un bloqueo para el
estudiante (`spec/00` §3). Nadie se queda fuera del taller por no haber abierto la app.

En el prototipo v10 esto se ve así: los días futuros de la tira semanal llevan candado y no se
pueden *trabajar*, pero **sí se pueden mirar**, y el sábado no depende de ellos.

---

## 2. LA ESCALA DE DOMINIO

Cuatro estados. Son los que aparecen en `/progreso` y en el mapa de competencias.

| Estado | Cuándo | Qué significa para el estudiante |
|---|---|---|
| **Dominada** | nota ≥ `umbral_dominada` (16) | Lo hace solo y lo sabe explicar |
| **En desarrollo** | nota ≥ umbral de aprobación | Aprueba, pero le falta soltura |
| **Requiere refuerzo** | por debajo del umbral | Hay que volver sobre esto |
| **Pendiente** | todavía no se evalúa | No ha llegado su sábado |

Umbrales, **siempre desde `system_config`**: aprueba con **12**, y con **10** solo el primer
módulo, que es excepcional porque el estudiante viene de cero.

**La nota práctica** = `checklist × 70% + defensa técnica × 30%`, sobre 20.
**La nota del módulo** = `teórico × 50% + práctica × 50%`.

---

## 3. LA DEFENSA TÉCNICA

Tres preguntas orales al terminar la práctica del sábado. El profesor marca un nivel por
pregunta:

| Nivel | Qué es |
|---|---|
| 1 | No supiste |
| 2 | Respuesta superficial |
| 3 | Correcta |
| 4 | La dominas |

Por qué existe: **separa al que ejecutó de memoria del que entendió.** Dos estudiantes pueden
completar el mismo checklist; solo uno sabe por qué cada paso está donde está.

Es también la evidencia de participación que sustituye a contar asistencias.

---

## 4. EL CICLO SEMANAL

Seis días, cada uno con una sola cosa que hacer. La dosificación importa tanto como el
contenido: **una tarea por día se hace; cinco tareas el domingo no.**

| Día | Qué | Peso |
|---|---|---|
| **Lunes** | Lee la guía de la semana | Ninguno |
| **Martes** | Caso **sintético** — practica el razonamiento | Ninguno |
| **Miércoles** | Caso **real** del taller — el mismo que verá el sábado | Ninguno |
| **Jueves** | **Manda su duda** de la semana | Ninguno |
| **Viernes** | Diagnóstica corta, 3 preguntas | Ninguno |
| **Sábado** | Clase, evaluación práctica y examen | **Todo** |

### 4.1 La duda es el guion de la clínica

La pregunta es una sola y es obligatoria:

> **«¿Qué es lo que no te quedó claro esta semana? Escríbelo como pregunta.»**

El profesor las recibe agrupadas por tema y ordenadas por frecuencia. **Esa lista es el guion
de la clínica del sábado.** No hay que preparar nada más.

No es anónima — el profesor necesita saber a quién volver. (Distinto del **feedback de la
clase**, que sí es anónimo y solo se muestra agregado con 3 o más respuestas.)

### 4.2 El caso, en cuatro pasos

Hipótesis → qué medirías → razonamiento → **qué tan seguro estás**.

**La referencia no se revela hasta completar los cuatro.** Y al revelarla se le devuelve la
calibración: si su confianza correspondía con lo que realmente sabía.

El cruce que más enseña es *acertó = no, confianza = alta*: **«Estabas seguro y no era.»** Ese
es el caso que conviene revisar, y el estudiante no lo detecta solo.

### 4.3 Repaso espaciado

Los valores de referencia de cada módulo (12,6 V · 9,6 V · 13,8–14,7 V · 0,5 V · 50 mA en
electricidad automotriz) se olvidan en dos semanas si no se repasan.

**Solución para Fase 1, sin construir nada:** un cuestionario de «valores de referencia» que se
reabre cada semana con preguntas al azar del mismo banco. No es espaciamiento algorítmico, pero
produce la mayor parte del efecto con cero fricción.

> No se construye un motor de repetición espaciada. Es un cuestionario reabierto.

---

## 5. LOS CINCO NIVELES DE IA

Cada actividad lleva marcado su nivel. **El objetivo no es impedir el uso de IA — es eliminar
la ambigüedad.** El estudiante siempre sabe qué está permitido y el profesor nunca discute
sobre reglas no escritas.

| Nivel | Qué se permite | Dónde aparece |
|---|---|---|
| **N0** | Sin IA | Exámenes y evaluación práctica del sábado |
| **N1** | IA como tutor — explica, no resuelve | Guía de la semana |
| **N2** | IA como asistente — ayuda a redactar | Razonamiento del caso |
| **N3** | IA como copiloto — se usa y **se declara** | Trabajos largos |
| **N4** | La IA es el **objeto de auditoría** — se le pide una respuesta y el estudiante la critica | Ejercicio avanzado |

**El control real es presencial.** El sábado se evalúa sin dispositivos. Marcar el nivel en la
app no impide que alguien abra otra pestaña, y no pretende hacerlo: **N4 es la respuesta
pedagógica a eso** — si no puedes impedir que la use, evalúa si sabe cuándo se equivoca.

> Los niveles se marcan en la interfaz desde Fase 1. **El tutor de IA no se construye
> todavía** — ver `plan/07` §6.

### 5.1 Las tres reglas de privacidad, si algún día hay tutor de IA

No negociables, y se escriben aquí para que no se «descubran» tarde:

1. **Nunca se manda a un modelo el nombre, la cédula ni la nota de un estudiante.**
2. **Nunca se manda la conversación de un estudiante a otro contexto.**
3. **Lo que el estudiante escribe al tutor no lo ve el profesor de forma atribuida.**

Son las mismas razones por las que la mensajería privada está prohibida: **son menores de
edad.**

---

## 6. DE DÓNDE SALE CADA COSA

| Sección | Original |
|---|---|
| Reglas 1-4 | `MDV_Documento_Tecnico_Arquitectura_LowCode.md` §8 |
| Escala de dominio | `MDV-implementacion-tecnica-lowcode.md` §2.1 |
| Duda del miércoles | Íd. §4.3 |
| Repaso espaciado | Íd. §4.5 |
| Niveles de IA | Íd. §6 · `Arquitectura` §7 |
| Reglas de privacidad | `MDV-implementacion-tecnica-parte2.md` §3.2 |

Los tres están en `_archivo/metodologia-lowcode/`. **Se leen por el razonamiento, nunca por las
instrucciones de implementación.**
