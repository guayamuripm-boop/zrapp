# 00 · RECONCILIACIÓN — FUENTE DE VERDAD ÚNICA
> **Este documento gana sobre todos los demás en los temas que trata.**
> Resuelve las contradicciones detectadas entre `docs/00_CONTEXTO_MAESTRO_AGENTE.md`,
> `spec/07_MDV_INTEGRACION.md` y las migraciones aplicadas.
>
> Decisiones tomadas por la dirección de ZR Mecademy el **20 de agosto de 2026**.
> Si un documento anterior dice lo contrario de lo que dice aquí, este manda.

---

## 1. POR QUÉ EXISTE ESTE DOCUMENTO

El proyecto acumuló tres modelos distintos de calificación y dos ciclos semanales distintos,
todos escritos con la misma autoridad aparente. Un agente de código que leyera `docs/00`
construiría algo incompatible con lo que construiría leyendo `spec/07`. Este documento cierra
esas bifurcaciones con una sola respuesta por tema.

**Contradicciones que resuelve:**

| Tema | `docs/00` decía | `spec/07` (MDV) decía | **Decisión** |
|---|---|---|---|
| Origen de la nota | 50% teoría + 50% práctica | Solo el sábado; lun-vie vale 0% | **docs/00** |
| Escala | Sobre 20, aprueba con 12 | Rúbrica 100, aprueba con 81 | **Sobre 20** |
| Compuerta semanal | No existe | Bloqueante, cierra viernes 22:00 | **No bloquea** |
| Ciclo lun-vie | No especificado | Microlecciones + simulador + clínica por videollamada | **Ciclo de casos** |
| Quién escanea el QR | No especificado | — | **Admin muestra, estudiante escanea** |

---

## 2. MODELO DE CALIFICACIÓN (DECISIÓN FIRME)

### 2.1 Escala
- **Escala única: 0 a 20 puntos.** No existe la escala de 100 puntos en ninguna pantalla ni
  en ningún cálculo visible.
- Una evaluación individual aprueba con **10 o más**.
- El **módulo** aprueba con:
  - **10 o más** — solo en el módulo 1 (regla excepcional de arranque).
  - **12 o más** — del módulo 2 en adelante.

### 2.2 Composición de la nota del módulo

    NOTA DEL MÓDULO = 50% TEORÍA + 50% PRÁCTICA

- **Teoría (50%):** exámenes del módulo. Autocalificados (opción múltiple, V/F) o con cola de
  corrección manual (redacción abierta).
- **Práctica (50%):** evaluación del sábado en taller. Ver §2.3.
### 2.2.1 Participación: se mide con datos, no con una nota subjetiva

`docs/00` §3.4 exige que el profesor asigne un mínimo de 5% a participación. **La forma de
medirla no es un número que el profesor inventa al final del módulo.** Se deriva de evidencia
que el sistema ya registra:

| Fuente | Qué evidencia | Dónde está el dato |
|---|---|---|
| **Defensa técnica** | Si sabe explicar lo que hizo y por qué | `technical_defenses.level_achieved` |
| **Constancia en los casos semanales** | Si trabaja los casos de lunes a viernes, semana tras semana | `activity_completions` |

La participación **vive dentro de la mitad práctica**, no como un cuarto componente: es
evidencia del mismo desempeño presencial que ya evalúa el sábado.

⚠️ **Advertencia de diseño — no construir una racha tipo Duolingo.** `docs/00` §3.10 rechaza
explícitamente las mecánicas de racha, y con buen argumento: el estudiante de ZR ya pagó, ya
asiste y tiene un objetivo laboral; superponerle urgencia artificial compite con su motivación
real en vez de reforzarla. Lo que sí se hace es **medir constancia** (cuántas semanas trabajó
los casos) y mostrársela al profesor como evidencia. Sin contador de días, sin insignias por
constancia, sin comparación entre estudiantes, sin perder nada por romper una seguidilla.

### 2.3 Cómo se calcula la nota práctica del sábado

La evaluación práctica combina dos instrumentos, ambos expresados en 0-20:

    NOTA PRÁCTICA = (CHECKLIST × 70%) + (DEFENSA TÉCNICA × 30%)

- **Checklist de desempeño:** lista de ítems observables que el profesor marca mientras el
  estudiante trabaja en el vehículo. Algunos ítems están marcados como **críticos**.
- **Defensa técnica:** preguntas orales que el profesor hace al terminar. Se califican en una
  escala de 4 niveles (1 = no sabe, 4 = domina).

### 2.4 Ítem crítico: es una ALERTA, no un tope de nota

Un ítem crítico es un paso del procedimiento que, si se hace mal en un taller real, causa daño
o riesgo (ej. no usar guantes al manipular electrolito, no medir densidad antes de concluir).

**Decisión: fallar un ítem crítico NO topa ni reduce la nota.** Genera una **alerta visible**:

- El **profesor** la ve al terminar de evaluar: *"falló el ítem crítico de medición de densidad"*.
- El **estudiante** la ve en su progreso, junto a qué revisar para corregirlo.
- El **profesor decide** qué hacer con esa información: reforzar en clase, repetir el
  procedimiento con él, o dejarlo pasar si fue un descuido puntual.

**Por qué alerta y no castigo automático.** Es coherente con todo el resto del sistema: sin
compuerta bloqueante, sin baja por inasistencia, sin reprobación automática. El criterio del
profesor manda; el sistema le da la información para ejercerlo, no la decisión ya tomada.

📌 **Esto puede endurecerse después.** Si con el uso real se ve que los ítems críticos se están
ignorando, se puede activar un tope leyendo un valor de `system_config` — sin desplegar código.
Empezar suave y endurecer con evidencia es más barato que al revés.

### 2.4.1 Estados de competencia — alineados al umbral de aprobación

Un solo punto de corte gobierna todo el sistema. El estado de la competencia y la aprobación
del módulo **nunca pueden decir cosas distintas del mismo desempeño**.

| Estado | Rango (escala 0-20) | Significa |
|---|---|---|
| 🟢 **Dominada** | 16 a 20 | Domina la destreza con solvencia |
| 🔵 **En desarrollo** | 12 a 15,9 | Aprobó, pero todavía puede afinar |
| 🔴 **Requiere refuerzo** | menos de 12 | **No aprobó.** Necesita repasar |

**Regla:** el corte inferior de "en desarrollo" es exactamente el umbral de aprobación del
módulo. Así *"requiere refuerzo"* significa siempre *"no aprobó"* — sin zona gris donde el
estudiante apruebe mientras su competencia dice que necesita refuerzo.

⚠️ **En el módulo 1** el umbral de aprobación es 10, no 12. El corte de "requiere refuerzo"
se mueve con él: los estados leen el umbral vigente desde `system_config`, no un número fijo.

Valores en `system_config`: `nota.umbral_dominada = 16`, `nota.aprueba_modulo_1 = 10`,
`nota.aprueba_modulo_n = 12`.

### 2.5 Lo que NO se implementa

- ❌ Rúbrica de 100 puntos con aprobación en 81.
- ❌ Ítems críticos de 20 puntos + normales de 2,5 puntos.
- ❌ Tope de nota por ítem crítico fallado (es alerta, ver §2.4).
- ❌ Reprobación automática del módulo por un ítem crítico.
- ❌ Reprobación automática por inasistencia (prohibido — regla absoluta 7).

---

## 3. COMPUERTA SEMANAL: SEÑAL, NO BLOQUEO (DECISIÓN FIRME)

El MDV original cerraba una compuerta el viernes a las 22:00 y mandaba a refuerzo a quien no
hubiera completado el trabajo de la semana. **Eso no se implementa.**

### 3.1 Qué sí se implementa: la pantalla «Antes de la clase»

Lo que reemplaza a la compuerta es **una sola pantalla que el profesor abre el sábado antes de
empezar**. Reúne tres cosas que hoy están dispersas o no existen:

**1. Cómo llegó el grupo (estimado, no lista negra)**
> *"18 de 24 trabajaron la semana."*

Un número agregado, no un señalamiento individual. El profesor puede desplegarlo para ver el
detalle si lo necesita, pero **lo primero que ve es el grupo**, porque la decisión que va a
tomar es sobre la clase, no sobre una persona.

**2. Las dudas frecuentes, agrupadas por tema**
Ya existe y es la mejor pantalla del prototipo. Se integra aquí en vez de vivir aparte: el
profesor las necesita en este momento exacto, no en otro menú.

**3. Las caídas claras — dónde está fallando el grupo**
Los criterios que más falla la cohorte, con su tasa de fallo. Sale de la vista
`v_error_heatmap`, que **ya está construida** en la migración 015 y hoy no la usa nadie.

**El cierre es una recomendación, no un tablero.** La pantalla termina diciendo qué conviene
reforzar primero y por qué. Un dato que no termina en una decisión es ruido.

### 3.1.1 Reglas de esta pantalla

- **Nadie queda fuera de la evaluación del sábado por lo que diga aquí.**
- El estudiante **ve su propio avance** de la semana, pero nunca el de sus compañeros.
- La preparación **no puntúa por sí sola**. Alimenta la participación (§2.2.1) como evidencia
  de constancia, no como una nota aparte.

### 3.2 Por qué

Tres razones, en orden de peso:

1. **Riesgo de conectividad.** La señal en los talleres es mala y muchos estudiantes dependen
   de datos móviles. Bloquear la evaluación por trabajo digital no entregado castiga la
   conectividad, no el aprendizaje.
2. **Coherencia con la política de asistencia confirmada** (`docs/00` §3.4): la academia
   decidió explícitamente que no hay bajas ni bloqueos automáticos.
3. **El valor del dato está en la conversación, no en el castigo.** Un profesor que sabe que
   12 de 24 no abrieron la guía puede cambiar cómo arranca la clase. Eso ya es la mayor parte
   del beneficio, sin ninguno de los costos.

### 3.3 Efecto sobre la migración 015

`fn_calculate_gate_a` y el Edge Function `close-gate-a` **quedan sin efecto vinculante**. La
tabla `weekly_progress` se conserva porque el dato sigue siendo útil como señal; lo que se
retira es la consecuencia. Ver §6.

---

## 4. CICLO SEMANAL: BASADO EN CASOS (DECISIÓN FIRME)

La semana se organiza alrededor de **problemas reales de vehículos**, no de microlecciones en
video. Es el ciclo que la academia puede sostener hoy con los recursos que tiene.

| Día | Actividad | Peso en la nota | Detalle |
|---|---|---|---|
| **Lunes** | Guía de investigación | 0% | Lectura previa: teoría que necesita para el sábado |
| **Martes** | **Caso sintético** | 0% | Problema planteado con respuesta de referencia. El estudiante razona antes de ver la solución |
| **Miércoles** | **Caso real** | 0% | El caso concreto que verá el sábado en el taller. Lo lee y se prepara |
| **Jueves** | Dudas | 0% | Envía sus preguntas. El sistema las agrupa por tema |
| **Viernes** | Diagnóstica (**opcional**) | 0% | Prueba corta autocalificada. Voluntaria: nada se pierde por no hacerla |
| **SÁBADO** | Clase presencial + evaluación | **100% de la práctica** | Clínica de dudas → práctica en taller → checklist + defensa |

### 4.0 La semana se desbloquea día a día

Cada actividad se abre **el día que le toca**, no antes. El lunes el estudiante solo ve la
guía; el martes se abre el caso sintético; y así hasta el sábado.

**Por qué.** El orden es el método, no una preferencia de calendario. El caso sintético del
martes solo enseña si se intenta **antes** de leer el caso real del miércoles — que es
básicamente su respuesta. Si toda la semana está abierta el lunes, el estudiante lee el
miércoles primero, llega al martes con la respuesta ya sabida, y el ejercicio de razonamiento
—que es donde ocurre el aprendizaje— desaparece sin que nadie lo note.

**Lo que sí puede hacer siempre:**
- Ver **qué viene** cada día (título y descripción), aunque no pueda abrirlo todavía.
- Volver a cualquier día **ya desbloqueado**, sin límite y sin penalización.
- Recuperar días que se saltó: lo pendiente no se cierra ni se pierde.

**Lo que nunca se hace:** cerrar un día por no haberlo hecho a tiempo. Desbloquear es abrir con
el ritmo de la semana, no una cuenta regresiva. Coherente con §3: el sistema acompaña, no
castiga.

### 4.1 El caso sintético es el corazón pedagógico

Estructura obligatoria de todo caso sintético (metodología de aprendizaje basado en problemas):

1. **Escenario realista** — vehículo concreto, con la queja del cliente en sus propias
   palabras, más datos técnicos (año, kilometraje, uso, historial).
2. **Hipótesis** — el estudiante elige la causa más probable entre alternativas plausibles.
3. **Primera medición** — decide por dónde empezar a diagnosticar.
4. **Razonamiento escrito** — explica por qué, como se lo diría al cliente.
5. **Autoevaluación de confianza** — cuán seguro está (1-5).
6. **Respuesta de referencia** — se revela **solo después** de completar los pasos anteriores.
   Incluye por qué las otras opciones no eran, y qué pista del enunciado era la clave.

**Regla:** la referencia no se muestra antes. Sin el intento previo no hay aprendizaje, solo
lectura.

### 4.2 Lo que NO se implementa del MDV original

- ❌ Microlecciones en video de 30 segundos (no hay quién las produzca — gap abierto #3).
- ❌ Clínica de errores por videollamada los jueves (la clínica ocurre el sábado presencial).
- ❌ Simulador interactivo (es Fase 3).
- ❌ Duda del miércoles como requisito bloqueante (la duda es del jueves y no bloquea).

---

## 4.3 QUIÉN MONTA EL CONTENIDO (DECISIÓN FIRME)

**Dirección académica es la dueña del currículo. El profesor imparte y evalúa.**

| | Dirección académica | Profesor |
|---|---|---|
| Define los 13 módulos y sus competencias | ✅ | ❌ |
| Monta guías, presentaciones y casos | ✅ **principal** | ⚠️ puede proponer |
| Define checklist e ítems críticos | ✅ | ❌ |
| Define el banco de preguntas de defensa | ✅ | ❌ |
| Crea exámenes | ✅ publica directo | ⚠️ requiere aprobación |
| Asigna módulos a programas con fechas | ✅ | ❌ |
| Asigna profesor a cada programa | ✅ | ❌ |
| **Imparte la teoría** | ❌ | ✅ |
| **Evalúa la práctica del sábado** | ❌ | ✅ |
| Ve dudas y prepara la clínica | ❌ | ✅ |

**Por qué.** El currículo tiene que ser el mismo para las tres sedes y para todos los
programas — si cada profesor arma su material, dos estudiantes con el mismo certificado
habrán cursado cosas distintas. La academia certifica un programa, no la interpretación de
cada docente.

Esto **no elimina la libertad de cátedra** que reconoce `docs/00` §3.4: el profesor amplía y
adapta cómo enseña, y puede proponer casos y guías que dirección aprueba. Lo que no hace es
definir qué se evalúa ni con qué instrumento.

### 4.3.0 Un módulo se define con dos datos: su tema y sus competencias

**Todo lo demás se deriva.** Esta es la regla que hace viable digitalizar 13 módulos.

Lo único que una persona escribe a mano:

    Módulo · Suspensión y frenos
    1. Cambio de pastillas
    2. Purga del sistema hidráulico
    3. Diagnóstico de amortiguadores
    4. Alineación básica

De ahí sale, sin decidir nada más:

| Qué | Cómo se deriva |
|---|---|
| **Duración** | Una competencia por sábado → 4 competencias = 4 sábados |
| **Calendario de evaluación** | Cada sábado evalúa una competencia; el **último** lleva además el examen teórico |
| **Checklist** | Un ítem observable por competencia + uno de seguridad. La IA lo propone, un humano lo aprueba |
| **Banco de defensa** | Dos preguntas por competencia + dos generales. La IA las propone, un humano las aprueba |

**El caso sintético SÍ se deriva. El caso real no.** Ver §4.3.0.1.

### 4.3.0.1 Los dos casos son de naturaleza distinta

| | Caso sintético (martes) | Caso real (miércoles y sábado) |
|---|---|---|
| Qué es | Un escenario **inventado** para razonar | El objeto **físico** que van a trabajar |
| ¿Se deriva de la competencia? | **Sí** | **No** |
| Dónde vive | En la **plantilla**, como banco | En la **edición** de cada programa |
| Cuándo se define | Al definir el módulo, una vez | Cada semana, cuando se sabe qué hay |

**Por qué el sintético se guarda como banco y no como caso único.** Si todas las cohortes
trabajan el mismo escenario, los estudiantes de un grupo se lo pasan al siguiente y el
ejercicio de razonamiento se pierde. Se derivan **dos por competencia** y cada edición usa uno
— la misma lógica que el sorteo de preguntas de defensa.

### 4.3.0.2 El caso real no siempre es un vehículo

Lo que el estudiante tiene enfrente el sábado depende de lo que haya en el taller. El sistema
modela cinco tipos de **objeto de práctica**:

| Tipo | Ejemplo |
|---|---|
| **Vehículo completo** | Aveo 2015 que no arranca en las mañanas |
| **Motor o conjunto** | Motor 1.6 en banco, con humo azul al arrancar |
| **Componente suelto** | Alternador desmontado que no carga |
| **Banco de pruebas** | Banco de arranque y carga del taller |
| **Muestra o pieza** | Batería usada de 3 años para medir densidad |

**Por qué importa modelarlo.** Buena parte de la enseñanza técnica ocurre sobre componentes y
bancos, no sobre carros completos — y una academia no siempre tiene un vehículo disponible.
Asumir "carro" en la interfaz obligaría a forzar el lenguaje cada vez que la práctica es sobre
una pieza. El tipo de objeto cambia el texto de la pantalla del estudiante y el ejemplo que se
le sugiere a quien carga la semana.

**Por qué la duración sale de las competencias.** `docs/00` §0.1 dice que los módulos duran
típicamente 4 sábados, con excepciones de 3 y de 8. Ese número no es arbitrario: es cuántas
destrezas distintas se enseñan. Al derivarlo, la decisión pedagógica (qué competencias tiene
este módulo) es la única que se toma, y el calendario se acomoda solo.

**Límites:** mínimo 2 competencias, máximo 8. Un módulo que necesite más de 8 sábados conviene
partirlo en dos — es la señal de que abarca demasiado.

**Esto no es diseñar desde cero.** `docs/00` §3.10 confirma que las competencias **ya existen**
como Guías de Aprendizaje físicas. El trabajo es transcribirlas, no inventarlas.

### 4.3.1 El currículo es una biblioteca, los programas lo recorren

- Existe **un solo currículo** de 13 módulos, con su material, competencias, checklist y
  banco de preguntas.
- Cada **programa** (cohorte) recorre ese currículo en **sus propias fechas**. El programa
  2026-01 cursa el módulo 3 del 1 al 22 de agosto; el 2026-02 lo cursa del 8 al 29.
- Dirección asigna módulo → programa → fechas → **profesor de ese módulo**.
- **Un programa tiene un profesor distinto por módulo.** Son especialistas: quien dicta
  electricidad no es quien dicta transmisión. El profesor se asigna a la *edición* del
  módulo, no al programa completo.
- **Alerta obligatoria:** si un módulo ya está programado y su material está incompleto,
  dirección lo ve en su pantalla de inicio. Un módulo sin material significa estudiantes con
  la semana vacía.

---

## 5. ASISTENCIA: QUIÉN ESCANEA A QUIÉN (DECISIÓN FIRME)

**Administración muestra el QR en una pantalla. El estudiante lo escanea con su teléfono.**

Flujo exacto (implementado en `supabase/migrations/016_qr_control.sql`):

1. Administración abre la sesión del día y muestra un QR grande en pantalla.
2. El estudiante escanea con la cámara de su teléfono.
3. El sistema valida: ¿existe? ¿pertenece a la cohorte? ¿el código ya se usó?
4. Si es válido, registra asistencia y **el código muere**.
5. Se genera un QR nuevo al instante para el siguiente estudiante.

El mismo escaneo marca la entrega del refrigerio.

**El profesor no maneja ningún código.** En su pantalla del sábado solo ve el conteo de
asistentes en vivo.

⚠️ `CLAUDE.md` y `AGENTS.md` decían lo contrario (que el profesor escanea al estudiante).
Corregidos el 2026-08-20 conforme a la migración 016.

---

## 5.1 ENTRADA DESDE EL SITIO WEB

El sitio institucional **ya tiene un botón de sesión** arriba a la derecha (hoy dice `Sign in`).
No se agrega un botón: se define qué hace.

| Estado de quien toca | A dónde va |
|---|---|
| Sin sesión, desde escritorio | Pantalla de entrada de la app |
| Con sesión abierta | Directo a su carnet |
| Desde el teléfono, con la app instalada | Abre la app, no el navegador |

**Se renombra a «Aula Virtual».** `Sign in` nombra el mecanismo; «Aula Virtual» nombra el
destino, y además está en el idioma del público.

**Camino completo de un estudiante nuevo** — de seis pasos, **tres son automáticos**:

1. Estudiante · se inscribe y paga en la sede *(presencial, como hoy)*
2. Administración · registra el pago en Odoo *(un formulario que ya usan)*
3. **Automático** · Odoo emite el código de un solo uso y lo envía por WhatsApp
4. Estudiante · entra al sitio, toca «Aula Virtual», escribe su código
5. **Automático** · se instala la app y se emite el carnet
6. **Automático** · el sábado escanea el QR y queda registrada su asistencia y su refrigerio

⚠️ **Pregunta abierta:** ¿el usuario del sitio y el de la app son el mismo? Depende de cómo
esté montado Odoo hoy. Ver §8.

---

## 5.1.1 LA SEMANA LA PUEDEN CARGAR LOS DOS (DECISIÓN FIRME)

**El profesor y dirección académica pueden cargar la semana. Los dos, siempre.**

No es una excepción ni un permiso especial: es cómo funciona. El profesor es quien sabe qué
hay en el taller, pero un profesor ocupado no puede ser el motivo de que una semana llegue
vacía. Dirección entra y la carga.

| | Profesor | Dirección |
|---|---|---|
| ¿Puede cargar la semana? | ✅ | ✅ |
| Qué pasa al terminar | Va a **revisión** de dirección | Se **publica** directo |
| Botón que ve | «Enviar a dirección» | «Publicar la semana» |

**Dirección siempre aprueba lo del profesor.** No al revés: nadie aprueba lo de dirección.

**Por qué así y no con un solo responsable.** Un solo responsable crea un cuello de botella
en el peor momento posible: la semana empieza el lunes y nadie puede esperar a que aparezca
quien tenía la tarea. Que ambos puedan hacerlo convierte una dependencia en un respaldo.

**Dónde lo hace cada uno:**
- El profesor, en su **Estudio** — ve las semanas del módulo que dicta, con su estado de carga.
- Dirección, en **Programas → módulo → semana** — puede entrar a cualquier programa.

Los dos usan la misma pantalla de carga. Lo único que cambia es el botón del final.

---

## 5.2 EXÁMENES: CICLO DE VIDA Y TIEMPO

### 5.2.1 Un examen recorre cinco estados

    borrador → en revisión → aprobado → publicado → cerrado

| Estado | Quién puede moverlo | Qué significa |
|---|---|---|
| **Borrador** | Su autor | Solo él lo ve. Editable |
| **En revisión** | — | Dirección lo está mirando. El autor no puede tocarlo |
| **Aprobado** | Dirección | Listo. **El autor decide cuándo publicarlo** |
| **Publicado** | Su autor | Los estudiantes ya pueden presentarlo |
| **Cerrado** | Su autor | No admite más respuestas |

**Nada se publica solo.** Aprobar y publicar son dos actos distintos: dirección autoriza el
contenido, el profesor elige el momento. Un examen aprobado el martes puede publicarse el
viernes si así conviene a la clase.

**Dirección no pasa por revisión.** Sus exámenes van de borrador a publicado directamente.

### 5.2.2 Todo examen tiene duración

Cada examen lleva un tiempo en minutos y una fecha de cierre. Al abrirlo, al estudiante le
arranca un cronómetro visible que cambia de color al bajar de 5 minutos y de 1 minuto.

Si el tiempo se agota, **se entrega lo que lleve respondido** y el resultado dice cuántas
preguntas quedaron sin contestar. No se pierde el trabajo hecho.

---

## 5.3 LA EVALUACIÓN DEL SÁBADO OCURRE EN UNA SOLA PANTALLA

El profesor no navega entre fichas: la lista de estudiantes y la evaluación son la misma
pantalla. Toca a un estudiante, su ficha se abre ahí mismo, evalúa, y al tocar al siguiente
la anterior se cierra sola.

**Por qué importa:** son 24 estudiantes en una jornada de taller, de pie y con interrupciones.
Cada navegación es una oportunidad de perder el sitio.

### 5.3.1 El checklist tiene tres estados, no dos

    sin evaluar → cumple → no cumple → sin evaluar

**«Sin evaluar» no es «no cumple».** Un paso que el profesor todavía no ha revisado no puede
contar como fallado. De ahí se siguen dos reglas:

- **No se muestra ninguna nota hasta que no quede nada sin evaluar.** Antes de eso la pantalla
  dice qué falta. Mostrar una nota parcial con el estudiante al lado condiciona el resto de la
  evaluación.
- **No se puede guardar una evaluación incompleta.**

### 5.3.2 Las preguntas de defensa se sortean

A cada estudiante se le sortean **3 preguntas de un banco de 10**. El profesor puede volver a
sortear si lo necesita.

**Por qué el sorteo es visible en pantalla:** para que el profesor sepa —y pueda decirle al
estudiante— que nadie elige qué le toca. Es lo que hace inútil pasarse las preguntas entre
compañeros, y esa es toda la razón de que el banco exista.

---

## 5.4 EL ESTUDIANTE VE POR QUÉ FALLÓ, NO SOLO QUE FALLÓ

Después de una evaluación práctica, el estudiante puede abrir su detalle y ver:

- **Cada paso del checklist**, con ✓ o ✕ y una explicación concreta de qué salió mal
- **A qué sección de qué guía ir** para corregir cada fallo
- **Sus respuestas orales** con el nivel obtenido y qué significa ese nivel
- **El comentario textual del profesor**
- **De dónde sale su nota**, con la cuenta a la vista

**Por qué es obligatorio y no opcional:** el sistema ya tiene esa información y hoy se queda
en la pantalla del profesor. Es el dato más valioso que el estudiante puede recibir, y sin él
la evaluación solo produce una calificación, no aprendizaje.

---

## 5.5 REGLAS DE INTERFAZ QUE SALIERON DE LA AUDITORÍA

Tres decisiones tomadas al revisar dónde la app le hacía perder tiempo a alguien.

### 5.5.1 Si se le pide un dato al usuario, se le devuelve algo

El caso sintético le pedía al estudiante marcar su confianza del 1 al 5, y **nunca le decía
nada al respecto** — aunque la propia pantalla se lo prometía.

Ahora, al revelar la referencia, lo primero que ve es el cruce entre lo que respondió y lo
seguro que estaba:

| Acertó | Confianza | Lo que se le dice |
|---|---|---|
| Sí | Alta | Tu confianza estaba bien calibrada |
| Sí | Baja | Sabías más de lo que creías |
| No | Alta | Estabas seguro y no era — este es el caso que más conviene revisar |
| No | Baja | Dudabas, y con razón |

**Regla general:** ningún campo se le pide al usuario si el sistema no va a hacer algo visible
con él. Un dato que se captura y no se devuelve es trabajo regalado.

### 5.5.2 No se pide confirmar lo que el sistema ya sabe

Se retiró el botón «Marcarlo como practicado» del final del caso. El sistema ya sabía que el
estudiante completó los cuatro pasos y reveló la referencia; pedirle que lo confirmara era un
toque sin información nueva.

### 5.5.3 Cada rol solo ve las herramientas de su trabajo

El profesor tenía un estudio de contenido de cuatro pestañas con botones para crear exámenes
y subir guías — trabajo que según §4.3 le toca a dirección. Se le retiró.

Su Estudio ahora tiene exactamente dos cosas:
- **Consultar** el material del módulo que dicta, con su checklist y su banco (solo lectura).
- **Cargar la semana** — que sí es suyo (§5.1.1).

**Regla general:** un rol que ve botones de un trabajo que no le corresponde termina
haciéndolo o preguntando por qué no puede. Las dos salidas cuestan tiempo.

---

## 5.6 TAMAÑO DE TEXTO EN LA BARRA DE NAVEGACIÓN

 §5 exige **14 px como mínimo absoluto**. La barra inferior lo cumple.

Para que las cinco etiquetas quepan en columnas de 86 px se acortaron a **8 caracteres o
menos**, midiendo cada una contra el ancho real de su columna:

| Rol | Etiquetas |
|---|---|
| Estudiante | Inicio · Semana · Material · Progreso · Perfil |
| Profesor | Hoy · Estudio · Alumnos · Reportes · Perfil |
| Dirección | Inicio · Alumnos · Módulos · Grupos · Perfil |
| Administración | Inicio · Alumnos · Asistir · Consent. · Perfil |

La más ancha ocupa 55 px de los 86 disponibles. **Ninguna se recorta ni se parte en dos
líneas.** Si en el futuro se agrega una etiqueta, se mide antes de aceptarla.

---

## 5.7 DIRECCIÓN: LA OPERACIÓN Y LA VIGILANCIA VAN SEPARADAS

La pantalla de Programas hacía tres trabajos a la vez: asignar módulos, mirar la salud de cada
programa y comparar cómo califica cada profesor. Son tres preguntas mentales distintas, y quien
entraba a asignar un módulo tenía que pasar por encima de dos cosas que no buscaba.

| Pantalla | Para qué | Cada cuánto se usa |
|---|---|---|
| **Programas** | Asignar módulos, fechas y profesores. Cargar semanas | Semanal |
| **Salud** (desde Inicio) | Cómo va cada programa y cómo califica cada profesor | Al cierre de un módulo |

**Regla general:** lo que se usa cada semana no comparte pantalla con lo que se mira una vez
al mes. La frecuencia de uso es un criterio de agrupación tan válido como el tema.

---

## 6. TRABAJO PENDIENTE QUE ESTA DECISIÓN GENERA

| # | Qué hay que hacer | Dónde | Estado |
|---|---|---|---|
| 1 | Migración **017**: umbrales a escala 0-20 (aprueba 10/12), retirar efecto vinculante de compuerta A, ítem crítico como alerta | `supabase/migrations/017_*.sql` | Pendiente de aprobación |
| 2 | Añadir a `system_config`: `nota.aprueba_modulo_1 = 10`, `nota.aprueba_modulo_n = 12`, `nota.escala_max = 20`, `practica.peso_checklist = 0.7`, `practica.peso_defensa = 0.3` | migración 017 | Pendiente |
| 3 | Corregir la regla del QR en `CLAUDE.md` y `AGENTS.md` | raíz | **Hecho** |
| 4 | Marcar `spec/07_MDV_INTEGRACION.md` como parcialmente superado | `spec/07` | **Hecho** |
| 5 | Corregir el prototipo: hoy usa 40/60 en vez de 50/50, y topa la nota por ítem crítico en vez de solo alertar | prototipo v10 | Pendiente |

**Regla 6 del proyecto:** las migraciones 001-016 ya están aplicadas y **no se editan**.
Todo ajuste va en la 017.

---

## 7. PREGUNTAS RESUELTAS EL 2026-08-20

| # | Pregunta | Respuesta |
|---|---|---|
| 1 | ¿De dónde sale el 5% de participación? | Se mide con **datos**, no con criterio subjetivo: defensa técnica + constancia en los casos semanales. Vive dentro de la mitad práctica. Ver §2.2.1 |
| 2 | ¿La diagnóstica del viernes es obligatoria? | **Totalmente opcional.** Vale 0% y no se pierde nada por no hacerla |
| 3 | ¿Google Classroom sigue en uso? | **No.** ZR App lo reemplaza. El repositorio de materiales es propio, en Supabase Storage. **Gap cerrado** |
| 4 | ¿Se puede re-evaluar tras fallar un ítem crítico? | La pregunta perdió sentido: el ítem crítico ya **no topa la nota**, solo alerta. Ver §2.4 |

### Consecuencia de cerrar el gap de Google Classroom

`docs/07_REGISTRO_DE_CAMBIOS_Y_GAPS_ABIERTOS.md` §3 listaba la integración con Classroom como
el gap abierto #1 desde julio. **Queda cerrado:** se construye repositorio propio, Classroom se
retira. Esto también resuelve el bloqueo por mora descrito en `02_MODULO_FINANCIAMIENTO.md` §7
— si hubiera bloqueo digital, opera sobre el contenido de ZR App, no sobre Classroom.

---

## 8. PREGUNTAS QUE SIGUEN ABIERTAS

Ninguna de las que trata este documento. Los gaps que siguen vivos son de **Fase 2 y 3** y no
bloquean nada de Fase 1 — ver `docs/07_REGISTRO_DE_CAMBIOS_Y_GAPS_ABIERTOS.md` §3
(niveles Cash & Carry, producción de video, moderación UGC, roles de especialización,
tratamiento fiscal de descuentos, contrato de adhesión).

---

## 9. HISTORIAL

| Fecha | Cambio |
|---|---|
| 2026-08-20 | Documento creado. Se fijan escala 0-20, compuerta no bloqueante, ciclo de casos y modelo de QR. |
| 2026-08-21 | La semana la cargan profesor y dirección, con aprobación para el profesor (§5.1.1). Fricciones retiradas (§5.5). Nav a 14px (§5.6). Dirección separa operación de vigilancia (§5.7). |
| 2026-08-21 | Documentados: entrada web (§5.1), ciclo de vida y duración de exámenes (§5.2), evaluación en una pantalla con checklist de tres estados (§5.3), detalle de práctica para el estudiante (§5.4). |
| 2026-08-21 | Un módulo se define con tema + competencias; duración, evaluaciones, checklist y banco se derivan (§4.3.0). Profesor asignado por módulo, no por programa. |
| 2026-08-21 | Dirección académica confirmada como dueña del currículo (§4.3). El profesor imparte y evalúa; no diseña el plan. |
| 2026-08-20 | Participación medida con datos (§2.2.1). Ítem crítico pasa de tope de nota a alerta (§2.4). Diagnóstica del viernes es opcional. Cerrado el gap de Google Classroom. |
