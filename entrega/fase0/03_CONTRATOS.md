# 03 · CONTRATOS — QUÉ RECIBE Y DEVUELVE CADA COSA

> **Este documento existe para que el frontend y el backend avancen en paralelo sin esperarse.**
> Si el contrato está fijado, quien hace la pantalla puede trabajar contra datos falsos mientras
> quien hace la función la escribe.
>
> Verificado contra el esquema real de `zr-prod` el 24 de agosto de 2026.

---

## 0. REGLAS DE TODAS LAS FUNCIONES

1. **Toda la lógica de negocio vive aquí, nunca en el navegador** (regla 2).
2. Todas responden **JSON**, siempre con la misma forma de error (§1).
3. Todas exigen sesión (`Authorization: Bearer <token>`), salvo que se diga lo contrario.
4. **La función comprueba el rol leyéndolo de la base**, nunca de lo que manda el cliente.
5. Los mensajes de error se le pueden **enseñar al usuario tal cual**: en español, sin jerga y
   diciendo qué hacer (`spec/06` §8).

---

## 1. FORMA DEL ERROR

```json
{ "error": { "code": "CODIGO_EN_MAYUSCULAS", "message": "Frase que se le puede mostrar al usuario." } }
```

| Código | Cuándo | HTTP |
|---|---|---|
| `NO_AUTORIZADO` | Sin sesión, o el rol no puede hacer esto | 401 / 403 |
| `QR_INVALIDO` | El código no existe o está mal formado | 400 |
| `QR_YA_USADO` | El código ya se consumió | 409 |
| `SESION_NO_ABIERTA` | La clase no está abierta | 409 |
| `OTRA_COHORTE` | El estudiante no pertenece a esa cohorte | 403 |
| `YA_REGISTRADO` | Ya tenía asistencia hoy — **no es un error de verdad**, ver §2.2 | 200 |
| `ERROR_INTERNO` | Cualquier otra cosa | 500 |

---

## 2. LAS CUATRO EDGE FUNCTIONS DE FASE 0

### 2.1 `provision-codigo` — administración pide el código a mostrar

**Quién puede llamarla:** `admin`, `super_admin`, `direccion_academica`.

```
POST /functions/v1/provision-codigo
{ "sessionId": "uuid" }
```

```json
{ "code": "ZR-A7K2-M9", "qrPayload": "ZR1|ZR-A7K2-M9", "escaneados": 8, "total": 24 }
```

**Qué hace:**
1. Comprueba rol y que la sesión esté `abierta`.
2. Busca en `qr_codes` el código de esa sesión con `used = false`.
3. Si no hay, **crea uno**. Si ya hay, **devuelve ese** — no crea otro.
4. Devuelve además el conteo en vivo.

> El punto 3 es el que hace que la pantalla se pueda refrescar sin generar códigos huérfanos.
> El índice único parcial de la migración 034 lo garantiza a nivel de base.

---

### 2.2 `validate-scan` — el estudiante escanea. **Se reescribe entera**

> ⚠️ **La que está desplegada hoy hace lo contrario:** valida un código TOTP que lleva el
> estudiante y exige que quien llame sea **profesor**. Ver `plan/01_ESTADO.md` §5.2.
> **No se parchea. Se reescribe.**

**Quién puede llamarla:** `estudiante`, y solo sobre sí mismo.

```
POST /functions/v1/validate-scan
{ "code": "ZR-A7K2-M9", "sessionId": "uuid", "deviceId": "string opcional" }
```

**Éxito:**
```json
{
  "ok": true,
  "duplicado": false,
  "estudiante": { "nombre": "Luis Hernández", "cedula": "V-30000001" },
  "asistencia": { "registradaEn": "2026-09-05T11:52:00Z", "refrigerio": true }
}
```

**Ya estaba registrado** — HTTP 200, **no es un error**:
```json
{ "ok": true, "duplicado": true, "estudiante": { "nombre": "Luis Hernández" },
  "mensaje": "Ya estabas registrado" }
```

**Qué hace, en este orden y en UNA SOLA TRANSACCIÓN:**
1. ¿Quién llama es estudiante y tiene sesión?
2. ¿El código existe?  → si no, `QR_INVALIDO`
3. ¿Está sin usar?      → si no, `QR_YA_USADO`
4. ¿La sesión está `abierta`? → si no, `SESION_NO_ABIERTA`
5. ¿El estudiante pertenece a la cohorte de esa sesión? → si no, `OTRA_COHORTE`
6. `qr_codes`: marcar `used = true`, `used_at = now()`, `used_by = <estudiante>`
7. `attendance_events`: insertar con `method = 'qr'`
8. **Marcar el refrigerio en el MISMO evento**: `snack_claimed_at = now()`

**Idempotencia — no es opcional:** si el estudiante ya tiene asistencia en esa sesión, devuelve
`duplicado: true` y **no crea una segunda fila**. Mandar el mismo escaneo dos veces nunca puede
producir dos asistencias.

> **Los pasos 6, 7 y 8 son una sola transacción.** Si falla el 7, el código no puede haber
> quedado quemado: el estudiante se quedaría sin poder registrarse y sin código válido.

---

### 2.3 `registro-manual` — administración marca presente a mano

> **Sin esta función el 5 de septiembre no se puede operar.** Los estudiantes son nuevos y no
> llegan con la app instalada — `fase0/01_ENTREGABLE.md` §6.

**Quién puede llamarla:** `admin`, `super_admin`, `direccion_academica`.

```
POST /functions/v1/registro-manual
{ "sessionId": "uuid", "studentId": "uuid",
  "motivo": "no_instalo_app" | "sin_bateria" | "camara_falla" | "otro",
  "motivoTexto": "string, obligatorio solo si motivo = otro" }
```

```json
{ "ok": true, "duplicado": false,
  "estudiante": { "nombre": "María Pérez", "cedula": "V-30000021" },
  "asistencia": { "registradaEn": "2026-09-05T11:48:00Z", "refrigerio": true, "metodo": "manual" } }
```

**Qué hace:** igual que `validate-scan` pero sin código, con `method = 'manual'`, guardando el
motivo en `attendance_events.manual_reason` y **quién lo hizo** en `scanned_by`.
Marca refrigerio igual.

> ✅ **La tabla `attendance_events` ya tiene `manual_reason`, `method`, `scanned_by`,
> `snack_claimed_at` y `snack_claimed_by`.** No hace falta migración para esto.

---

### 2.4 `resumir-dudas` — las 3 preguntas del profesor

**Quién puede llamarla:** `profesor` de esa cohorte, `admin` y superiores.

```
POST /functions/v1/resumir-dudas
{ "cohortId": "uuid", "weekStart": "2026-09-07" }
```

```json
{ "ok": true, "preguntas": ["...", "...", "..."], "sourceCount": 31,
  "generadoEn": "2026-09-11T22:10:00Z" }
```

**Qué hace:**
1. Lee las dudas de esa cohorte y esa semana.
2. **Extrae SOLO los textos.**
3. Llama al modelo pidiendo 3 preguntas que cubran lo más repetido.
4. Guarda en `question_digests`.

> ## ⚠️ LA REGLA DE PRIVACIDAD, QUE NO SE NEGOCIA
> **Al modelo se le manda un arreglo de textos y nada más.** Nunca `student_id`, nunca el
> nombre, nunca la cédula. Son menores de edad — `metodologia/01_MODELO.md` §5.1.

**Si falla, o si no hay clave contratada:** devuelve error y **la pantalla del profesor sigue
mostrando las dudas en crudo**. Nada se rompe. Ver `entrega/01_TODO_GRATIS.md` §5.

---

## 3. TIPOS DE TYPESCRIPT DE LAS TABLAS NUEVAS

Se generan automáticamente con `npm run db:types`, pero estos son los que hay que conocer:

```ts
export type MotivoManual = 'no_instalo_app' | 'sin_bateria' | 'camara_falla' | 'otro';

export interface OpcionCaso { texto: string; correcta: boolean }

export interface Caso {
  id: string;
  module_id: string;
  cohort_id: string | null;      // null = para todas las cohortes
  publish_on: string;            // 'YYYY-MM-DD'
  week_number: number | null;
  title: string;
  scenario: string;              // sin cifras técnicas — fase0/03_CASOS.md §1
  step1_prompt: string;
  step1_options: OpcionCaso[];
  step2_prompt: string;
  step2_options: OpcionCaso[];
  step3_prompt: string;
  reference: string;
  approved_by: string | null;
  approved_at: string | null;    // null = borrador, NO se le muestra a nadie
}

export interface IntentoCaso {
  id: string;
  case_id: string;
  student_id: string;
  step1_choice: number | null;
  step2_choice: number | null;
  step3_text: string | null;
  confidence: number | null;     // 1..5
  revealed_at: string | null;
  completed_at: string | null;
}

export interface Duda {
  id: string;
  student_id: string;
  cohort_id: string;
  case_id: string | null;
  body: string;
  answered_at: string | null;
  created_at: string;
}

export interface Competencia {
  id: string;
  module_id: string;
  position: number;
  title: string;
  description: string | null;
}
```

### 3.1 ⚠️ El tipo que NO se manda al cliente

`Caso` contiene `step1_options[].correcta` y `reference`. **Eso NO puede salir al navegador
antes de que el estudiante complete los cuatro pasos**, o basta con abrir la consola para ver
la respuesta.

**Cómo se resuelve:** la pantalla del caso pide primero una versión recortada (sin `correcta` ni
`reference`) y **solo al revelar** pide la completa desde el servidor. Es el mismo patrón que
`v_exam_questions_student` en Fase 1, y la razón de la regla 3 del proyecto.

---

## 4. LA CALIBRACIÓN DE CONFIANZA

Se calcula del cruce entre acierto y confianza. **Es una tabla de cuatro mensajes, no un
algoritmo.** Los textos exactos están en el prototipo, función `revelar()`.

| Acertó | Confianza | Clase | Mensaje |
|---|---|---|---|
| Sí | ≥ 4 | `ok` | Tu confianza estaba bien calibrada |
| Sí | ≤ 2 | `warn` | Sabías más de lo que creías |
| No | ≥ 4 | `err` | **Estabas seguro y no era** |
| No | ≤ 2 | `warn` | Dudabas, y con razón |

> El cruce *no acertó + muy seguro* es el que más enseña, y el estudiante no lo detecta solo.
> Es lo que distingue esto de un cuestionario.

---

## 5. CORRECCIÓN A `spec/02_CONTRATOS.md`

⚠️ Ese documento tiene una sección **«Contenido del código QR del estudiante»** que describe el
**modelo viejo**, donde el estudiante llevaba un código rotativo.

**Está superada por este documento.** En el modelo vigente el estudiante no lleva ningún
código: lo lleva la pantalla de administración. El resto de `spec/02` (formato de cédula,
conversión a correo interno, formato de errores) **sigue vigente**.
