# 04 · PANTALLAS Y RUTAS
> **Derivado de `ZR_APP_PROTOTIPO_v10.html`.** El prototipo es la especificación visual y de
> comportamiento. Cuando este documento y el prototipo se contradigan, **manda el prototipo** y
> se corrige este documento.
>
> Reescrito el 23 de agosto de 2026. La versión anterior se perdió por un daño de codificación
> y describía un alcance más estrecho que el del prototipo. Está en
> `_archivo/docs-superados/04_PANTALLAS_danado.md`, solo como referencia histórica.

---

## 0. CÓMO SE USA ESTE DOCUMENTO

1. Abre el prototipo en el navegador y entra con la cédula del rol que vas a construir (§0.3).
2. Busca la pantalla en este documento.
3. Construye. Si algo no está descrito aquí, míralo en el prototipo. Si tampoco está ahí,
   **pregunta** — no lo inventes.

### 0.1 Reglas que aplican a toda pantalla

| Regla | Valor |
|---|---|
| Ancho de diseño | **360 px**. Si no funciona a 360, no está terminada |
| Área táctil mínima | 48 × 48 px |
| Tamaño de texto mínimo | 14 px (`spec/06` §5) |
| Color | Solo tokens de `spec/06` §4. Ningún hex escrito en un componente |
| Idioma | Español de Venezuela. Coma decimal (`16,5`), fechas `sáb 15 ago 2026` |
| Números de negocio | Se leen de `system_config`. **Nunca escritos en el código** (regla 5) |
| Estados obligatorios | Toda pantalla que carga datos define: cargando · vacío · error · con datos |
| Navegación | Barra inferior de **5 botones** en los cuatro roles. Con etiqueta de texto, no solo ícono |

### 0.2 Las cuatro barras inferiores

Salen literales del prototipo. **Cinco botones, ni uno más.**

| Rol | Botones |
|---|---|
| Estudiante | Inicio · Semana · Material · Progreso · Perfil |
| Profesor | Hoy · Estudio · Alumnos · Reportes · Perfil |
| Administración | Inicio · Alumnos · Asistir · Consent. · Perfil |
| Dirección | Inicio · Alumnos · Módulos · Grupos · Perfil |

Las pantallas que no están en la barra (dudas, antes de la clase, salud, notas por módulo)
son **hijas** de una pestaña: se llega a ellas desde su pestaña padre y el botón de esa
pestaña se queda marcado como activo. En el prototipo esto es el mapa `parentTab`.

### 0.3 Cédulas del prototipo para probar

| Cédula | Rol |
|---|---|
| `V-30000001` | Estudiante (Luis Hernández — va aprobando) |
| `V-30000003` | Estudiante (María Pérez — **en riesgo**, para ver los estados rojos) |
| `V-10000003` | Profesor |
| `V-10000005` | Administración |
| `V-10000004` | Dirección |

### 0.4 Estructura de rutas

```
app/
  layout.tsx                          fuentes locales, metadatos de la PWA
  page.tsx                            entrada — redirige según el rol
  (publico)/
    login/page.tsx
    registro/page.tsx
    registro/consentimiento/page.tsx
  (estudiante)/
    layout.tsx                        barra inferior de 5 botones
    inicio/page.tsx
    semana/page.tsx
    material/page.tsx
    material/[moduleId]/page.tsx
    progreso/page.tsx
    perfil/page.tsx
    examen/[examId]/page.tsx          pantalla completa, sin barra
    caso/[casoId]/page.tsx            pantalla completa, sin barra
    escanear/page.tsx                 pantalla completa, sin barra
  (profesor)/
    layout.tsx
    hoy/page.tsx
    hoy/antes/page.tsx
    hoy/dudas/page.tsx
    estudio/page.tsx
    estudio/semana/[n]/page.tsx
    alumnos/page.tsx
    alumnos/[studentId]/page.tsx
    reportes/page.tsx
    perfil/page.tsx
    evaluar/[studentId]/page.tsx      pantalla completa, sin barra
  (admin)/
    layout.tsx
    panel/page.tsx
    alumnos/page.tsx
    alumnos/[studentId]/page.tsx
    asistencia/page.tsx
    codigos/page.tsx
    consentimientos/page.tsx
    perfil/page.tsx
    qr/page.tsx                       pantalla completa, sin barra
  (direccion)/
    layout.tsx
    inicio/page.tsx
    inicio/salud/page.tsx
    inicio/feedback/page.tsx
    alumnos/page.tsx
    alumnos/notas/page.tsx
    modulos/page.tsx
    curriculo/page.tsx
    curriculo/estudio/page.tsx
    grupos/page.tsx
    perfil/page.tsx
```

**El middleware protege por grupo de ruta.** Sin sesión → `/login`. Con sesión pero en el
grupo equivocado → a su propia pantalla de inicio. El rol se lee del servidor, **nunca de un
parámetro ni de `localStorage`** (regla 9).

---

## 1. PANTALLAS PÚBLICAS

### `/` — entrada
Cuatro elementos: isotipo, «ZR Mecademy», «Inscribirme por primera vez», «Ya tengo cuenta ·
Entrar». Aviso: *«Entras con el mismo usuario del sitio — no necesitas otra cuenta.»*

> El botón **Aula Virtual** de `zrmecademy.com` apunta aquí. Ver `spec/00` §5.1.

### `/login`
| Campo | Detalle |
|---|---|
| Prefijo | Botón que alterna `V-` / `E-`. Por defecto `V-` |
| Cédula | Solo dígitos, mínimo 6 |
| Contraseña | Mínimo 8 |

La cédula se convierte a un correo interno para autenticar contra Supabase. **Un solo mensaje
de error para cualquier fallo:** *«Cédula o contraseña incorrecta»* — nunca *«esa cédula no
existe»*, porque eso confirma qué cédulas están registradas.

Al entrar redirige: estudiante → `/inicio` · profesor → `/hoy` · admin → `/panel` ·
dirección → `/inicio`.

**Contraseña temporal:** si el perfil está marcado como temporal, redirige a cambio
obligatorio antes de cualquier otra pantalla.

### `/registro` — dos pasos
**Paso 1:** código de inscripción (empieza con `ZR-`) · nombre completo · cédula · fecha de
nacimiento · contraseña.
**Paso 2:** correo · teléfono · sede · turno.

> ⚠️ El registro propio **no entra en el MVP del 5 de septiembre**: las cuentas las carga
> administración. El código por WhatsApp requiere integrar Odoo. Ver `plan/06` §5.

### `/registro/consentimiento`
Si la edad calculada de la fecha de nacimiento es **menor de 18**, esta pantalla es
obligatoria antes de crear la cuenta (LOPNNA). Datos del representante, parentesco, y subida
del documento firmado. Queda `pendiente` hasta que administración lo verifica.

---

## 2. ESTUDIANTE

### `/inicio`
La pantalla más importante de la app. Orden obligatorio (`spec/06` §10.3):
**lo que viene → mi progreso → lo que tengo que hacer hoy.**

**2.1 · Tira de la semana.** Seis botones, lunes a sábado, con su etiqueta:
`Guía · Sintét. · Real · Dudas · Diag. · Eval.` Cada día tiene tres estados:
`done` (ya pasó) · `today` (hoy) · `future` (con candado 🔒).

Los días futuros **se pueden mirar pero no trabajar**: el botón de acción queda deshabilitado
y aparece el aviso *«Esta actividad se abre el [día]»*. Es la compuerta semanal como
**señal, no como bloqueo** (`spec/00` §3).

**2.2 · Tarjeta del día.** Cambia según el día de la semana:

| Día | Título | Acción |
|---|---|---|
| Lunes | Lee la guía de la semana | Abrir guía |
| Martes | Practica con el caso sintético | Ver el caso → `/caso` |
| Miércoles | Lee el caso real del taller | Leer caso → `/caso` |
| Jueves | Manda tus dudas de la semana | Enviar mi duda (modal) |
| Viernes | Diagnóstica corta del viernes | Hacer diagnóstica → `/examen` |
| Sábado | ¡Nos vemos en el taller! | Marcar asistencia → `/escanear` |

**2.3 · Dos indicadores.** Ambos llevan a `/progreso`:
- *Competencias dominadas* — `N/total`
- *Promedio del módulo* — sobre 20. **Si está por debajo del umbral de aprobación, el borde y
  la cifra van en rojo.**

**2.4 · Exámenes.** El examen del módulo aparece siempre mientras esté abierto, con la
etiqueta *«Cuenta 50%»*. La diagnóstica **solo aparece el viernes**, etiquetada *«Opcional ·
no cuenta para tu nota»*.

**2.5 · Asistencia.** El botón «Marcar asistencia» **solo existe el sábado**. El resto de la
semana no aparece — no sirve de nada.

**2.6 · Banner de feedback.** Solo visible si dirección activó el feedback para ese programa
y módulo (`spec/00` §7).

### `/semana`
Calendario mensual real (lunes primero, sábados resaltados, navegable por mes), tarjeta
«Próximo sábado» con tema y hora, y la lista de los seis días con su estado
(`Cursado` / `Hoy` / `Pendiente`).

### `/material`
Guías, presentaciones y PDF del módulo. Módulo actual y anteriores en pestañas. Cada apertura
registra una vista en `content_views`.

### `/progreso`
**3.1 · Tarjeta de promedio.** Cifra grande sobre 20 y el mensaje explícito:
*«Vas aprobando · se aprueba con 12»* o *«Por debajo de 12 · necesitas subir»*.
Debajo: dominadas · en desarrollo · requieren refuerzo.

**3.2 · Mapa de competencias.** Una fila por competencia con su fecha, su nota y su estado:

| Estado | Cuándo |
|---|---|
| 🏆 Dominada | nota ≥ `umbral_dominada` (16) |
| 📈 En desarrollo | nota ≥ umbral de aprobación |
| 🔴 Requiere refuerzo | por debajo del umbral |
| · Pendiente | todavía no se evalúa |

Si falló un ítem crítico, se muestra ⚠️ junto a la nota. **El ítem crítico avisa, no topa la
nota** (`spec/00` §2.4).

**Sin puntos, sin niveles, sin insignias y sin comparación entre estudiantes.**

**3.3 · Notas del módulo.** Examen teórico (50%) · Evaluación práctica (50%) · Promedio, con
la cuenta escrita: `16 × 50% + 15 × 50% = 15,5`.

**3.4 · «Ver qué falló y por qué».** Es la razón de ser de esta pantalla (`spec/00` §5.4).
Abre el detalle de la práctica del sábado: paso por paso del checklist con ✓/✗, **una frase
concreta de qué pasó en cada paso** y a qué sección de qué guía ir a repasar; las respuestas
orales con su nivel de 1 a 4; el comentario del profesor; y la nota con su desglose.

Si falló un ítem crítico, aviso al final: *«No te baja la nota, pero es de los que importan en
un taller real.»*

**3.5 · Participación.** Días que trabajó en la semana, sobre 5.

### `/perfil`
Carnet digital (nombre, cédula, programa, código, sede, turno, foto), datos de contacto,
preferencias y cerrar sesión. **El carnet debe verse sin señal una vez cargado.**

### `/examen/[examId]` — pantalla completa
| Elemento | Detalle |
|---|---|
| Cronómetro | Cuenta atrás desde `exams.duration_minutes`. Amarillo a los 5 min, rojo al último |
| Progreso | Barra por preguntas respondidas |
| Preguntas | **Una por pantalla.** Opciones como botones grandes |
| Avance | No deja pasar sin elegir opción |
| Tiempo agotado | Entrega automática de lo respondido, avisando cuántas quedaron sin responder |

**La corrección ocurre en la Edge Function `submit-attempt`, nunca en el navegador** (regla 2).
El cliente **nunca** recibe `correct_answer`: lee de `v_exam_questions_student` (regla 3).

**Al terminar:** nota sobre 20, estado (🏆 / 📈 / 🔴), y la **revisión pregunta por pregunta**
con la respuesta dada y la correcta. El estudiante ve por qué falló, no solo que falló.

Al salir del examen, **el cronómetro se detiene**. No puede seguir corriendo de fondo.

### `/caso/[casoId]` — pantalla completa
El ciclo de razonamiento en cuatro pasos, con barra de progreso:

1. **¿Cuál es tu primera hipótesis?** — opciones
2. **¿Qué medirías primero?** — opciones
3. **Explica tu razonamiento** — texto libre
4. **¿Qué tan seguro estás?** — escala de confianza

**La referencia no se revela hasta completar los cuatro pasos.** Si intenta saltarlos:
*«La idea es que compares tu razonamiento con el de referencia — no vale saltarlo.»*

**Calibración de confianza** (`spec/00` §5.5.1). Al revelar, se le devuelve el cruce entre lo
que acertó y lo seguro que estaba:

| Acertó | Confianza | Mensaje |
|---|---|---|
| Sí | Alta | *Tu confianza estaba bien calibrada* |
| Sí | Baja | *Sabías más de lo que creías* |
| No | Alta | *Estabas seguro y no era* — el caso que más conviene revisar |
| No | Baja | *Dudabas, y con razón* |

El objeto del caso **no siempre es un carro**: puede ser una muestra, una pieza o un equipo.
La etiqueta y el campo se adaptan al tipo de objeto.

### `/escanear` — pantalla completa
Ver §5.1: es la misma mecánica, del lado del estudiante.

---

## 3. PROFESOR

### `/hoy`
Asistencia en vivo (contador que sube solo), la clase del día, y **«Lo que puedes hacer
ahora»** — las acciones disponibles según el momento. Enlaces a `/hoy/antes` y `/hoy/dudas`.

### `/hoy/antes`
**Dónde está fallando el grupo** — agregados de la semana, para preparar la clase.
**Lo que preguntaron esta semana** — dudas agrupadas por tema, con su frecuencia.

### `/hoy/dudas`
El resumen para la clínica del sábado: las dudas agrupadas por tema.

### `/estudio`
Material del módulo que dicta, cómo se evalúa (checklist con sus ítems críticos y banco de
preguntas de defensa), y acceso a montar la semana.

### `/estudio/semana/[n]`
El editor de la semana. Cuatro campos: tema/competencia del sábado, descripción del caso real
del taller, teoría base *(«para que la IA no invente»)*, y el número de semana.

Acciones: **Generar borradores con IA** · **Guardar como borrador** · **Enviar a dirección
para revisar** · **Ver como lo ve el estudiante**.

> El profesor y dirección **pueden cargar la semana los dos** (`spec/00` §5.1.1).
> Dirección aprueba antes de publicar.

### `/alumnos`
Tabla de los estudiantes del módulo con su nota. Filas expandibles. Los que están por debajo
del umbral se marcan en rojo. Desde aquí se entra a la ficha y a la evaluación práctica.

### `/reportes`
Salud del programa, distribución de notas del módulo, y **feedback anónimo**.

> ⚠️ **El profesor nunca ve el feedback individual.** Solo el promedio del grupo, y solo si
> hay **3 o más respuestas**. Las respuestas abiertas no se proyectan ni se muestran
> atribuidas.

### `/evaluar/[studentId]` — pantalla completa
**Toda la evaluación del sábado ocurre en una sola pantalla** (`spec/00` §5.3). Sin navegar,
sin perder lo hecho:

1. **Checklist** — un toque por paso. Los ítems críticos van marcados `CRÍTICO`.
2. **Defensa técnica** — cada pregunta con su nivel de 1 a 4:
   *No supiste · Respuesta superficial · Correcta · La dominas*.
3. **Comentario** del profesor.

La nota se calcula `checklist × 70% + defensa × 30%`, sobre 20, con los pesos leídos de
`system_config`. **El cálculo va en el servidor, no en el navegador** (regla 2).

Fallar un ítem crítico **genera una alerta, no topa la nota**.

---

## 4. ADMINISTRACIÓN

### `/panel`
Hoy en la academia, asistencia del sábado con el contador (*«18 de 24 ya escanearon»*), y el
acceso a **Mostrar QR en pantalla**.

### `/alumnos`
Lista de estudiantes activos con buscar, filtrar y exportar CSV. Ficha completa por estudiante.

### `/asistencia`
Dos pestañas: **Sábado de hoy** e **Historial**. La de hoy trae quién llegó, quién falta, y el
**registro manual** (§5.2).

### `/codigos`
Códigos de inscripción: generar, ver los activos, ver cuáles se usaron.

### `/consentimientos`
Los consentimientos pendientes de menores de edad. Por cada uno: **Ver doc** · **Verificar** ·
**Recordar**. Verificar es la acción que habilita al estudiante.

### `/qr` — pantalla completa
Ver §5.1.

---

## 5. LAS DOS PANTALLAS CRÍTICAS

Son las que deciden el piloto del 5 de septiembre. Se construyen primero y se prueban en el
taller, no en una oficina.

### 5.1 · El QR de un solo uso

**Administración muestra; el estudiante escanea.** Nunca al revés (`spec/00` §5).

| Lado | Pantalla | Comportamiento |
|---|---|---|
| Administración | `/qr` | QR gigante, legible a 2 metros. **Al escanearse, ese código muere y aparece otro al instante.** Contador de escaneados en vivo |
| Estudiante | `/escanear` | Cámara con `@zxing/browser`. Permiso pedido **con explicación previa**, no a secas |

**Un solo escaneo marca asistencia Y refrigerio.** Es el mismo evento.

**Resultado, muy grande y legible a un metro:**

| Estado | Qué dice |
|---|---|
| ✅ Verde | Registrado, con su nombre. Más un pitido corto |
| ⚠️ Amarillo | *«Ya estabas registrado»* — es información, no una alarma |
| ⛔ Rojo | *«Este código ya se usó»* · *«No es de tu cohorte»* · *«La sesión está cerrada»* |

**Por qué el código de un solo uso:** fotografiarlo y mandarlo por WhatsApp no sirve. Cuando
el ausente lo intente, ese código ya está quemado.

La validación ocurre completa en la Edge Function `validate-scan` (regla 2).

> **Sin conexión:** el escaneo se guarda en el teléfono y se sincroniza al reconectar. La
> sincronización es **idempotente**: mandar el mismo escaneo dos veces no crea dos asistencias.
> ⚠️ Esto **no entra en el MVP del 5 de septiembre** (`plan/06` §5).

### 5.2 · El registro manual

**Sin esta pantalla el criterio de éxito del piloto es imposible** (`plan/06` §2.1). Van a
fallar teléfonos: batería, cámara, o alguien que no instaló la app.

Administración busca al estudiante en la lista de los que faltan y lo marca presente con un
motivo: `sin batería` · `cámara falla` · `no instaló la app` · `otro`.

- Queda registrado que fue **manual** y **quién** lo hizo.
- Marca asistencia **y refrigerio**, igual que el escaneo.
- **Terminado cuando:** un estudiante sin teléfono queda registrado en menos de 20 segundos.

---

## 6. DIRECCIÓN

Dirección tiene dos trabajos que **van separados**: la operación y la vigilancia
(`spec/00` §5.7). No se mezclan en la misma pantalla.

| Ruta | Qué |
|---|---|
| `/inicio` | Acciones rápidas · alertas de material faltante · «De vez en cuando» |
| `/inicio/salud` | Salud del sistema — la vigilancia, aparte de la operación |
| `/inicio/feedback` | Activar el feedback por programa y módulo. **Dirección decide cuándo** |
| `/alumnos` | Estudiantes por programa |
| `/alumnos/notas` | Progreso y notas, por módulo |
| `/modulos` | Historial de módulos dictados |
| `/curriculo` | El currículo completo — 13 módulos, con sus competencias |
| `/curriculo/estudio` | Montar contenido con IA · **Aprobar / Rechazar / Ver detalle** los borradores que manda el profesor |
| `/grupos` | Programas activos · asignar profesor y módulo a cada cohorte |

Solo dirección (`super_admin`) puede editar `system_config`.

---

## 7. LO QUE NINGUNA PANTALLA HACE

Vale tanto como lo anterior. Si aparece en el prototipo pero está en esta lista,
**no se construye**:

| No existe | Por qué |
|---|---|
| Reprobación automática por inasistencia | Prohibida por la academia (regla 7) |
| Bloqueo de acceso al aula o al taller | Prohibido por el Ministerio (regla 8) |
| Mensajería privada entre usuarios | Prohibida por seguridad de menores |
| Pagos, cuotas, saldos, estado de cuenta | Fase 2 |
| Puntos, insignias, rachas, ranking | Fase 2 |
| Video subido por estudiantes, comentarios, portafolio público | Fase 3 |
| El profesor viendo feedback individual | Rompe el anonimato |
| El cliente calculando notas o validando QR | Regla 2 |

---

## 8. HISTORIAL

| Fecha | Cambio |
|---|---|
| 2026-08-23 | Reescrito desde el prototipo v10. Se añaden el rol dirección, el ciclo semanal, los casos, la evaluación práctica en una pantalla y el registro manual. La versión anterior se archivó por daño de codificación |
