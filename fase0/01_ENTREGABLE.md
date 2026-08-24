# 01 · EL ENTREGABLE, PANTALLA POR PANTALLA

> Cómo se ve y se comporta cada una está en `ZR_APP_PROTOTIPO_v10.html`.
> Aquí está **qué hace y qué no hace en Fase 0**.

---

## 1. EL CRITERIO DE ÉXITO

Son dos, y el primero manda.

### 1.1 El binario — se verifica el mismo día

> **Al terminar la clase del 5 de septiembre, los estudiantes presentes están registrados en el
> sistema y nadie escribió un nombre en una hoja.**

Se cuenta cuánta gente hay en el taller y cuántas filas hay en `attendance_events`. Si los
números coinciden y no hubo papel, se cumplió. **Este criterio no se negocia y no depende de
nada de contenido.**

### 1.2 El de Fase 0 — se verifica la semana siguiente

> **Al menos la mitad de la cohorte abrió la app entre semana y trabajó al menos un caso.**

No se mide el 5. Se mide del 7 al 11 de septiembre, que es la primera semana con contenido.

### 1.3 Lo que NO se mide

- Cuánta gente instaló la app por su cuenta
- Si les gustó la interfaz
- Si el profesor usó el resumen de dudas

Se observa y se anota, pero no define si el piloto salió bien.

---

## 2. ESTUDIANTE

### 2.1 `/login`
Prefijo `V-`/`E-`, cédula y contraseña. **Un solo mensaje de error** para cualquier fallo.
Contraseña temporal con cambio obligatorio al primer ingreso.

### 2.2 `/inicio`
Orden obligatorio: **lo que toca hoy → mi módulo → el acceso al carnet**.

- **Tarjeta del día.** De lunes a viernes lleva al caso del día. El sábado, a escanear.
- **La tira de la semana.** Los seis días con su estado: ya pasó · hoy · con candado.
  Los futuros se pueden **mirar pero no trabajar**.
- **Acceso a material y a mandar una duda.**

> En Fase 0 la tarjeta del día **no cambia de tipo** como en el v10 (guía / sintético / real /
> dudas / diagnóstica). Todos los días de lunes a viernes son **el caso del día**. Mandar una
> duda está siempre disponible, no solo el jueves.
>
> Se simplifica a propósito: un solo tipo de actividad diaria es más fácil de explicarle al
> estudiante en la primera semana, y mucho más rápido de construir.

**Sin indicadores de notas ni de promedio.** En Fase 0 no hay.

### 2.3 `/material`
Los PDF del módulo: presentaciones y guías. Se abren y se descargan.
Cada apertura registra una vista en `content_views`.

**Estados:** cargando · **vacío** (*«Todavía no hay material publicado»*) · error · con datos.
El estado vacío importa: los primeros días va a estar vacío de verdad.

### 2.4 `/caso/[id]` — la pantalla que define Fase 0
Los cuatro pasos, con barra de progreso:

1. **¿Cuál es tu primera hipótesis?** — opciones
2. **¿Qué revisarías primero?** — opciones
3. **Explica tu razonamiento** — texto libre
4. **¿Qué tan seguro estás?** — escala de confianza

**La referencia no se revela hasta completar los cuatro.** Si lo intenta:
*«La idea es que compares tu razonamiento con el de referencia — no vale saltarlo.»*

**La calibración de confianza** se muestra al revelar. Es el cruce entre acierto y seguridad:

| Acertó | Confianza | Mensaje |
|---|---|---|
| Sí | Alta | *Tu confianza estaba bien calibrada* |
| Sí | Baja | *Sabías más de lo que creías* |
| No | Alta | *Estabas seguro y no era* — el que más conviene revisar |
| No | Baja | *Dudabas, y con razón* |

> **Esto entra aunque sea Fase 0.** Es lo que distingue el método de un cuestionario. Cuesta
> poco: es una tabla de cuatro mensajes.

**El caso no produce nota.** Al terminar no hay puntaje, hay una comparación.

### 2.5 `/duda`
Un tema (lista desplegable) y un texto: *«¿Qué es lo que no te quedó claro? Escríbelo como
pregunta.»*

**No es anónima** — el profesor necesita saber a quién volver. Distinto del feedback de la
clase, que sí lo es y que **no entra en Fase 0**.

### 2.6 `/mi-modulo`
Qué módulo cursa y **qué competencias se adquieren en él**, como lista.

**Sin estado por competencia**, sin colores de dominio, sin porcentaje. Es informativo:
*«esto es lo que vas a saber hacer al terminar este módulo».*

### 2.7 `/perfil`
Carnet digital: nombre, cédula, programa, código, sede, turno.
**Se ve sin señal una vez cargado.**

### 2.8 `/escanear`
Cámara con `@zxing/browser`. Permiso pedido **con explicación previa**, no a secas.
Resultado grande, legible a un metro:

| Estado | Qué dice |
|---|---|
| ✅ Verde | Registrado, con su nombre. Más un pitido corto |
| ⚠️ Amarillo | *«Ya estabas registrado»* — información, no alarma |
| ⛔ Rojo | *«Este código ya se usó»* · *«No es de tu cohorte»* · *«La sesión está cerrada»* |

Un solo escaneo marca **asistencia y refrigerio**.

---

## 3. ADMINISTRACIÓN

### 3.1 `/qr` — mostrar el código
QR grande, legible a 2 metros. **Al escanearse muere y aparece otro al instante.**
Contador de escaneados en vivo.

### 3.2 `/asistencia` — registro manual
**Sin esto el criterio de éxito es imposible.** Van a fallar teléfonos.

Buscar al estudiante entre los que faltan y marcarlo presente con un motivo:
`sin batería` · `cámara falla` · `no instaló la app` · `otro`.
Queda registrado que fue manual y quién lo hizo. Marca asistencia **y** refrigerio.

**Terminado cuando:** un estudiante sin teléfono queda registrado en menos de 20 segundos.

### 3.3 `/material` — subir
Subir un PDF, ponerle título y asignarlo al módulo. Nada más.

---

## 4. PROFESOR

### 4.1 `/hoy`
Asistentes en vivo, con el contador subiendo solo.

### 4.2 `/dudas` — el resumen
**Las dudas agrupadas por tema, ordenadas por frecuencia.** Es el guion de la clínica del
sábado: *«7 preguntaron por el orden de desconexión de bornes»*.

Puede abrir un tema y leer las preguntas tal cual las escribieron.

### 4.3 `/casos`
Solo el número: *«14 de 24 trabajaron el caso del martes»*. **Sin nombres** — decisión de §4.2
de `00_LEEME.md`.

---

## 5. QUÉ SE RECORTA SI SE ATRASA

**En este orden exacto.** Se recorta de abajo hacia arriba.

| Orden de recorte | Qué se cae | Qué pasa si se cae |
|---|---|---|
| 1º | `/casos` del profesor (el conteo) | El profesor pregunta en voz alta quién lo hizo |
| 2º | `/mi-modulo` | Las competencias se dicen en clase |
| 3º | El resumen de dudas por tema | El profesor lee las dudas en crudo desde la base |
| 4º | La subida de material desde la app | El dev carga los PDF a mano |
| 5º | El caso del día | **Fase 0 se convierte en el piloto de asistencia + material** |
| 6º | El material | **Fase 0 se convierte en el piloto de asistencia** |

**Lo que NUNCA se recorta:**

- Entrar, el carnet, el QR, el escaneo y **el registro manual**
- **La prueba en teléfono real, en el taller**

> Si se recorta hasta el nivel 6, lo que queda **sigue siendo un piloto que cumple el criterio
> binario**. Ese es el propósito del orden de construcción de `02_PLAN.md`.

---

## 6. PLAN B DEL DÍA

| Si falla | Qué se hace |
|---|---|
| La cámara de un teléfono | Administración lo registra a mano en la app |
| La app no abre en un teléfono | Igual: registro manual |
| Se cae internet en el taller | Administración anota en su teléfono y carga al recuperar señal. **Sigue sin ser papel** |
| Se cae Supabase completo | Lista impresa. **Es el único caso donde se acepta papel** |
| No hay casos cargados | La clase sigue normal. Los casos empiezan el lunes 7 |

---

## 7. LISTA DE VERIFICACIÓN DEL VIERNES 4

Si algo no se cumple, se avisa ese día. **No el sábado.**

- [ ] Los estudiantes están cargados y pueden entrar
- [ ] Al menos 20 de 24 tienen la app instalada
- [ ] Administración mostró el QR y registró a alguien a mano **al menos una vez**
- [ ] Tres teléfonos distintos escanearon correctamente **en el taller**
- [ ] El estudiante A no puede ver nada del estudiante B
- [ ] Hay al menos un caso cargado y alguien lo completó de punta a punta
- [ ] Hay al menos un PDF de material publicado y se abre en un teléfono
- [ ] La revisión de seguridad no reporta ningún hallazgo de nivel `ERROR`
- [ ] El plan B está escrito y quien esté presente lo conoce
