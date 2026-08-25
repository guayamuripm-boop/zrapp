# FASE 0 · EMPIEZA AQUÍ

> Para **el técnico y su agente de código**.
> Objetivo: entregar Fase 0 el **sábado 5 de septiembre de 2026**.

---

## 1. EN UNA FRASE

> Una app instalable donde el estudiante **recibe el material de su módulo, trabaja un caso
> distinto cada día y manda sus dudas**, y donde el sábado **queda registrada su asistencia y
> su refrigerio sin papel**.

**Fuera de Fase 0:** notas, exámenes, evaluación práctica, rúbricas, defensa técnica y el panel
de dirección. Nada que produzca una calificación.

---

## 2. LO PRIMERO: ABRE EL PROTOTIPO

**`ZR_APP_FASE0_PROTOTIPO.html`**, en la raíz del repositorio. Ábrelo en el navegador y
recórrelo entero con los tres roles.

**Eso es lo que hay que construir.** No es una referencia aproximada: es la especificación.
Cuando dudes de cómo se ve o se comporta algo, ábrelo. **No inventes.**

Dentro tiene un control para alternar entre un día de semana (el caso) y el sábado (la
asistencia). Recorre los dos.

---

## 3. EL DÍA 1, HORA A HORA

### Antes de abrir el editor

- [ ] Leer este archivo completo
- [ ] Recorrer el prototipo con los tres roles
- [ ] Leer `entrega/00_EMPIEZA_AQUI.md` §3 — las reglas que no se rompen
- [ ] Leer `INGENIERIA.md` §2 y §9 — el ciclo de una tarea y la definición de terminado

### Lo primero que se escribe, y no es una pantalla

> ## 🔴 F0-01 · PROBAR LA CÁMARA. HOY.
>
> Es el **riesgo máximo del proyecto** y sigue sin tocarse.
>
> Una página mínima con `@zxing/browser`, desplegada con HTTPS, que lea un QR mostrado en otra
> pantalla. **Probada con tres teléfonos distintos, uno de gama baja, en el taller, con su luz
> real.** No en una oficina.
>
> **Si la cámara no lee en gama baja, todo el modelo de asistencia cambia** y hay que saberlo
> hoy, no el día 10. Alternativas: código de 6 dígitos en la pizarra, o lista manual.

**HTTPS es obligatorio** — el navegador no da acceso a la cámara sin él. Por eso el
alojamiento se monta antes que nada.

### Después, en este orden

1. **`01_ENTORNO.md`** — instalar, crear el proyecto Next.js, levantar Supabase local
2. **`02_CONEXIONES.md`** — pedir los accesos que no puedes darte tú mismo
3. **`04_TAREAS.md`** — el backlog, tarea por tarea, con criterio de terminado

---

## 4. EL ORDEN DE CONSTRUCCIÓN, Y POR QUÉ ES ESE

> **Se construye en un orden donde siempre hay algo que funciona.**

```
SEMANA 1 · LA ASISTENCIA, COMPLETA        → sáb 29: simulacro técnico
SEMANA 2 · EL CONTENIDO ENCIMA            → sáb 5:  piloto con estudiantes
```

**La asistencia va primero y entera.** Si a partir del día 8 todo sale mal, lo que queda en pie
sigue cumpliendo el criterio binario de éxito: cero papel.

Lo contrario — empezar por el material y los casos porque son más fáciles — dejaría el riesgo
grande para el final.

### 4.1 Si te atrasas, recorta en este orden

De abajo hacia arriba. Está en `fase0/01_ENTREGABLE.md` §5:

```
1º  el conteo de casos del profesor
2º  la pantalla «Mi módulo»
3º  el resumen de 3 preguntas
4º  la subida de material desde la app
5º  el caso del día
6º  el material
─────────────────────────────────────
    NUNCA:  entrar · carnet · QR · escaneo · REGISTRO MANUAL
    NUNCA:  la prueba en teléfono real
```

---

## 5. LAS TRES COSAS QUE MÁS FÁCIL SE HACEN MAL

### 5.1 El QR va al revés de lo que está desplegado

**Administración muestra el código en pantalla. El estudiante lo escanea.** El código muere al
usarse y aparece otro al instante.

Las funciones `validate-scan` y `provision-qr` que están vivas en `zr-prod` implementan lo
contrario: el estudiante lleva un código rotativo y el profesor lo escanea a él. **No las
copies. Se reescriben** — contrato en `03_CONTRATOS.md` §2.

**Por qué de un solo uso:** fotografiarlo y mandarlo por WhatsApp no sirve, porque cuando el
ausente lo intente ese código ya está quemado.

### 5.2 «El profesor ve números, no nombres» se resuelve en la base

El profesor ve *«14 de 24 trabajaron el caso»*, sin la lista.

**Eso NO se hace ocultando una columna en la pantalla.** Si pudiera leer las filas, bastaría con
abrir la consola del navegador. Se resuelve con RLS que **no le deja leer ni una fila** de
`case_attempts`, más la vista agregada `v_casos_conteo`. Ya está escrito en la migración 036.

### 5.3 El registro manual no es el plan B

El 5 de septiembre son **estudiantes nuevos**, es su primer día en la academia y **nadie llega
con la app instalada**. La coreografía se invierte: se registra a mano al entrar, y el QR se
enseña después, ya en clase, como demostración.

**Si el registro manual no está terminado, ese día no se puede operar.**

---

## 6. CÓMO SÉ QUE UNA TAREA ESTÁ TERMINADA

Las ocho condiciones de `INGENIERIA.md` §9.2. Todas, no algunas:

1. `npm run typecheck` pasa
2. Si tocó la base: migración con número nuevo, corrida en **local → `zr-dev` → `zr-prod`**
3. Si creó tabla: **RLS habilitada y políticas escritas en la misma migración**
4. `npm run test:rls` pasa — el estudiante A no ve nada del estudiante B
5. `npm run test` pasa
6. Camino feliz **y** camino de error, ambos probados
7. **Funciona en un teléfono real de 360 px**, no en el simulador del navegador
8. El linter de seguridad no reporta ningún hallazgo nuevo de nivel `ERROR`

---

## 7. QUÉ HAY EN ESTA CARPETA

| Archivo | Qué |
|---|---|
| `00_EMPIEZA_AQUI.md` | Este |
| `01_ENTORNO.md` | Comandos exactos: instalar, crear, levantar |
| `02_CONEXIONES.md` | Accesos, secretos y los bloqueantes de dirección |
| `03_CONTRATOS.md` | Las 4 Edge Functions y los tipos de TypeScript |
| `04_TAREAS.md` | El backlog completo, con criterio de terminado |
| `migraciones/034…036` | **SQL listo para correr**, escrito contra el esquema real |
| `seed_fase0.sql` | Datos de prueba: casos, competencias, dudas, cohorte |

Y en la raíz del repositorio:

| Documento | Responde |
|---|---|
| `fase0/01_ENTREGABLE.md` | Qué hace cada pantalla y qué se recorta |
| `fase0/02_PLAN.md` | Los 12 días con fechas reales |
| `fase0/03_CASOS.md` | Cómo se escriben los casos y **la regla de seguridad del contenido** |
| `fase0/04_ARQUITECTURA.md` | Carpetas, tablas, funciones, entorno |
| `INGENIERIA.md` | El proceso completo |
| `spec/06_IDENTIDAD_VISUAL.md` | Colores, tipografías, medidas, voz |

---

## 8. SI ALGO NO ESTÁ ESCRITO

**Pregunta. No inventes.**

Una decisión inventada cuesta días de retrabajo. Una pregunta cuesta cinco minutos.
