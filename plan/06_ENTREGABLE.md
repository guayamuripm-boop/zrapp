# 06 · EL ENTREGABLE DEL 5 DE SEPTIEMBRE
> Definido el 21 de agosto de 2026. **Este documento manda sobre el alcance.**
> Si algo no está aquí, no entra. Si alguien pide algo que no está aquí, va después del piloto.

---

> ## ⚠️ SUPERADO POR `fase0/` — 24 DE AGOSTO DE 2026
>
> Dirección decidió entregar **Fase 0** el 5 de septiembre: material, caso diario, dudas,
> competencias del módulo **y** la asistencia. Este documento describía un piloto **solo de
> asistencia**.
>
> **El alcance del 5 de septiembre lo manda ahora `fase0/00_LEEME.md`.**
> Lo que sigue vigente de aquí es el criterio binario de éxito, el plan B y la coreografía del
> día, todo recogido en `fase0/01_ENTREGABLE.md`.


## 1. QUÉ ES, EN UNA FRASE

> Una aplicación instalable que la cohorte del piloto usa en su primera clase, con la que
> **queda registrada su asistencia y su refrigerio sin papel**, y que captura de dónde parte
> cada estudiante.

---

## 2. CRITERIO DE ÉXITO

**Al terminar la clase del 5 de septiembre, los 24 estudiantes presentes están registrados en
el sistema y nadie escribió un nombre en una hoja.**

Es un criterio binario y se verifica el mismo día: se cuenta cuántas personas hay en el taller
y cuántas filas hay en la tabla de asistencia. Si los números coinciden y no hubo papel, se
cumplió.

### 2.1 Lo que este criterio obliga

**Registrar sin papel no es lo mismo que registrar por QR.** Van a fallar teléfonos: batería
descargada, cámara rota, alguien que no instaló la app, un modelo que no lee el código.

Por eso el entregable **debe incluir una salida manual dentro de la aplicación**:
administración busca al estudiante en la lista y lo marca presente, dejando registrado que fue
manual y por qué.

Sin esa salida, el criterio de éxito es imposible de cumplir el primer día. Con ella, un
teléfono que falla es una fila más en la base, no una hoja suelta que alguien tiene que
transcribir el lunes.

### 2.2 Lo que NO se mide ese día

- Cuánta gente instaló la app por su cuenta
- Si el diagnóstico lo respondieron todos
- Si a alguien le gustó la interfaz
- Si el profesor usó el retrato del grupo

Todo eso se observa y se anota, pero **no define si el piloto salió bien**.

---

## 3. LO QUE FUNCIONA ESE DÍA

### 3.1 Estudiante

| # | Función | Detalle |
|---|---|---|
| 1 | **Entrar** | Con su cédula y una contraseña temporal que cambia al primer ingreso |
| 2 | **Carnet digital** | Nombre, cédula, programa, código, sede y turno. Se ve sin señal una vez cargado |
| 3 | **Escanear el QR** | Marca asistencia **y** refrigerio en el mismo evento |
| 4 | **Diagnóstico de entrada** | Aparece **cuando el profesor lo abre**, no antes. Ver §4 |

### 3.2 Administración

| # | Función | Detalle |
|---|---|---|
| 5 | **Mostrar el QR** | En pantalla grande. El código muere al usarse y aparece otro |
| 6 | **Ver quién llegó** | Contador en vivo y lista de quiénes faltan |
| 7 | **Registrar a mano** | Buscar al estudiante y marcarlo presente, con motivo. **Es lo que hace posible el criterio de éxito** |

### 3.3 Profesor

| # | Función | Detalle |
|---|---|---|
| 8 | **Ver asistentes** | Cuántos llegaron, en vivo |
| 9 | **Abrir el diagnóstico** | Un botón en su pantalla. Ver §4 |
| 10 | **Retrato del grupo** | Los agregados del diagnóstico, según `05_DIAGNOSTICO.md` §4 |

### 3.4 Sitio web

| # | Función | Detalle |
|---|---|---|
| 11 | **Botón de entrada** | El botón que hoy dice `Sign in` pasa a decir **Aula Virtual** y apunta a la app |

---

## 4. EL DIAGNÓSTICO LO ABRE EL PROFESOR

**Decisión:** el diagnóstico no está disponible desde que el estudiante entra. Aparece cuando
el profesor lo abre desde su pantalla.

### 4.1 Cómo funciona

1. El profesor toca **«Abrir el diagnóstico»** en su panel
2. A los estudiantes de esa cohorte les aparece en su inicio, al instante
3. El profesor ve llenarse el contador: *«14 de 24 respondieron»*
4. Cuando quiere, lo cierra

### 4.2 Por qué así y no siempre disponible

**El profesor controla el momento pedagógico.** Puede decidir abrirlo apenas empieza la clase,
después de presentarse, o al final. Y sobre todo: **puede pedirle al grupo que lo responda en
ese momento**, que es cuando de verdad lo responden todos.

Un formulario que está siempre disponible lo responde la mitad. Uno que el profesor abre y
pide en voz alta lo responde el grupo entero.

Es el mismo patrón que la activación del feedback por dirección (`spec/00` §7): **el sistema
no decide cuándo es el momento, lo decide quien está en el salón.**

### 4.3 Lo que esto obliga técnicamente

- La pantalla del estudiante tiene que **enterarse sin recargar** — suscripción en tiempo real
- Si el estudiante no tiene señal en ese momento, lo ve al reconectar
- El estado *abierto/cerrado* vive en la sesión de clase, no en la configuración global:
  cada cohorte lo abre cuando le toca

---

## 5. LO QUE **NO** FUNCIONA ESE DÍA

Esta lista es tan importante como la anterior. **Si alguien de la junta llega esperando ver
notas, el piloto «fracasa» aunque todo haya funcionado.**

| No hay | Cuándo llega |
|---|---|
| Notas ni evaluación práctica | Cuando haya algo que evaluar, después del primer módulo |
| Materiales ni guías | Semana del 7 |
| Exámenes | Después del piloto |
| Casos sintéticos | **Lunes 7** — su primera semana empieza ese día |
| Registro propio del estudiante | Las cuentas van cargadas por administración |
| Código de inscripción por WhatsApp | Requiere integrar Odoo. Después |
| Funcionar sin señal | El escaneo requiere conexión |
| Historial, currículo, configuración | Cuando haya varias cohortes |

**Hay que decirlo antes, no el mismo día.** Conviene mandar esta tabla a quien vaya a estar
presente, con una semana de anticipación.

---

## 6. LA COREOGRAFÍA DEL DÍA

### Antes — durante la semana del 1 al 4

- [ ] Administración carga la cohorte con cédulas y fechas de nacimiento
- [ ] **Se manda el enlace de la app por WhatsApp**, para que lleguen con ella instalada
- [ ] Se confirma que al menos 20 de 24 la instalaron antes del sábado

> ⚠️ **No dejar la instalación para el mismo día.** 24 teléfonos descargando a la vez con la
> señal del taller es un riesgo evitable.

### 7:40 – 8:00 · Llegada

- Administración abre la sesión y muestra el QR en pantalla
- Cada estudiante escanea al entrar → asistencia y refrigerio
- A quien le falle el teléfono, administración lo registra a mano en la app

### 8:00 · Empieza la clase

- El profesor ve cuántos llegaron

### ~8:15 · El diagnóstico

- El profesor lo abre desde su pantalla y le pide al grupo que lo responda
- Diez minutos
- El profesor ve el retrato del grupo llenarse

### Resto de la clase

- La clase transcurre normal. La app no vuelve a usarse ese día

### Al terminar

- Contar cuánta gente hubo y cuántas filas hay en la tabla
- **Anotar todo lo que falló**, sin arreglar nada en el momento

---

## 7. QUIÉN TIENE QUE ESTAR

| Rol | Por qué |
|---|---|
| Alguien del equipo técnico, presente | Con acceso a la base, por si algo hay que corregir en vivo |
| El profesor de la cohorte | Ya entrenado en su pantalla, no aprendiendo ese día |
| Administración | Operando el QR y el registro manual |

**El profesor y administración tienen que haber usado la app antes del 5.** El ensayo del
sábado 30 sirve también para eso.

---

## 8. PLAN B

| Si falla | Qué se hace |
|---|---|
| La cámara de un teléfono | Administración lo registra a mano en la app |
| La app no abre en un teléfono | Igual: registro manual |
| Se cae internet en el taller | Administración anota en su teléfono y carga al recuperar señal. **Sigue sin ser papel** |
| Se cae Supabase | Lista impresa. Es el único caso donde se acepta papel |
| El diagnóstico no abre | La clase sigue normal. Se hace el lunes |

**El único escenario que admite papel es que se caiga el servicio completo.** Todo lo demás
tiene salida dentro de la aplicación.

---

## 9. CÓMO SE SABE QUE ESTÁ LISTO, ANTES DEL DÍA

Lista de verificación para el **jueves 4 de septiembre**. Si algo no se cumple, se avisa
inmediatamente — no el sábado.

- [ ] Los 24 estudiantes están cargados y pueden entrar
- [ ] Al menos 20 tienen la app instalada
- [ ] El profesor entró a su pantalla y abrió y cerró el diagnóstico al menos una vez
- [ ] Administración mostró el QR y registró a alguien a mano al menos una vez
- [ ] Tres teléfonos distintos escanearon correctamente **en el taller**
- [ ] El estudiante A no puede ver nada del estudiante B
- [ ] El botón del sitio web apunta a la app
- [ ] La revisión de seguridad no reporta errores de nivel ERROR
- [ ] Está escrito el plan B y quien esté presente lo conoce

---

## 10. LO QUE SE ENTREGA COMO EVIDENCIA

Después del piloto, para que quede constancia de qué pasó:

- **El número:** cuántos presentes contra cuántos registrados
- **La lista de fallos**, con lo que se arregló y lo que quedó pendiente
- **El retrato del grupo** que salió del diagnóstico
- **Qué dijeron cinco estudiantes** a los que se les pregunte qué no entendieron

Eso es lo que convierte el piloto en información, en vez de en una anécdota.
