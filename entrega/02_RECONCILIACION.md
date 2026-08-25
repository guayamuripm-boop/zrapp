# 02 · RECONCILIAR LOS DOS REPOSITORIOS

> ## ⛔ ESTO VA PRIMERO. ANTES DE INSTALAR NADA.
>
> Hay **dos repositorios con trabajo real y distinto**. Aplicar las correcciones de este
> paquete sin mirar el otro es la forma de pedirle a alguien que rehaga trabajo ya hecho —
> o de borrarlo.

---

## 1. LA SITUACIÓN

| | `guayamuripm-boop/zrapp` | El clon de `mdavi` |
|---|---|---|
| Qué tiene de más | **Especificación, plan, prototipos, metodología, migraciones escritas** | **Código.** Las 13 Edge Functions vivas salieron de ahí |
| Qué le falta | La aplicación | Las decisiones tomadas del 20 al 24 de agosto |
| Estado | Al día en documentación | Al día en implementación |

**Ninguno de los dos está completo. Ninguno de los dos está equivocado.**

El proyecto acumuló decisiones nuevas mientras se escribía código sobre las viejas. Es lo
normal cuando dirección y desarrollo avanzan en paralelo sin un punto de sincronización.

---

## 2. POR QUÉ NO SE PUEDE SALTAR ESTE PASO

Este paquete afirma cosas sobre el estado del proyecto —
*«la aplicación no existe»*, *«cero líneas»*, *«hay que reescribir `validate-scan`»*.

**Todo eso se verificó contra `zr-prod` y contra ESTE repositorio.** Ninguna se verificó
contra el clon de `mdavi`, porque no se tenía acceso.

Si él ya construyó la app, o ya reescribió esa función, media docena de tareas del backlog
sobran. Y si además tiene migraciones aplicadas que la base no refleja, las migraciones 034 a
036 de este paquete pueden chocar de frente.

---

## 3. EL PROCEDIMIENTO — CUATRO PASOS

### Paso 1 · Inventario. Lo hace `mdavi`, y toma 20 minutos

Que responda estas preguntas **antes de tocar nada**:

```
1. ¿Existe una aplicación Next.js en tu clon?
   ¿Qué pantallas funcionan hoy, de punta a punta?

2. ¿Qué archivos de migración tienes en supabase/migrations/?
   Pega la salida de:  ls supabase/migrations/

3. ¿Aplicaste alguna migración a zr-prod después del 15 de agosto?
   (La base dice que la última fue la 033, ese día.)

4. Las 13 Edge Functions desplegadas: ¿están todas en tu repositorio?
   ¿Alguna la diste ya por superada?

5. ¿Tu clon salió de guayamuripm-boop/zrapp, o lo empezaste aparte?
   Pega la salida de:  git remote -v
                       git log --oneline -15

6. ¿Hay algo tuyo que NO esté subido a ningún remoto?
   Pega la salida de:  git status
```

> **La 6 es la más importante.** Trabajo que solo vive en un disco duro se pierde. Antes que
> nada, que lo suba a una rama.

### Paso 2 · Un solo repositorio

`github.com/guayamuripm-boop/zrapp` pasa a ser **el único**. Es el que tiene la
especificación, el historial de decisiones y el CI.

`mdavi` sube su trabajo como **una rama**, no como reemplazo:

```bash
cd <su-clon>
git remote add central https://github.com/guayamuripm-boop/zrapp.git
git fetch central
git checkout -b codigo-de-mdavi
git push central codigo-de-mdavi
```

**Nadie mergea nada todavía.** El objetivo de este paso es solo que su trabajo sea **visible**
para los dos, en un sitio donde se pueda comparar.

> Si su clon no comparte historia con el central, `git push` de una rama huérfana funciona
> igual. Lo que importa es que los archivos estén ahí.

### Paso 3 · Comparar, decisión por decisión

Con las dos ramas visibles, se revisa **qué gana en cada tema**:

| Tema | Quién manda | Por qué |
|---|---|---|
| **Reglas de negocio** | `spec/00_RECONCILIACION.md` | Son decisiones de dirección, no técnicas |
| **Cómo se ve cada pantalla** | Los prototipos | Están aprobados |
| **Código que ya funciona** | **Lo de `mdavi`** | Código probado vale más que código descrito |
| **Esquema de base** | El estado real de `zr-prod` | Es lo que existe |
| **Alcance del 5 de septiembre** | `fase0/00_LEEME.md` | Decisión del 24 de agosto |

> **La regla:** si `mdavi` ya construyó algo que cumple la decisión vigente, **se queda lo
> suyo**. Este paquete no viene a reemplazar código que funciona: viene a corregir el rumbo
> donde el rumbo cambió.

### Paso 4 · Recién entonces, aplicar el paquete

Cuando esté claro qué existe, se toma de `entrega/fase0/` **solo lo que haga falta** y se
renumeran las migraciones si es necesario.

---

## 4. LAS TRES CORRECCIONES QUE HAY QUE COMUNICARLE SÍ O SÍ

Aunque su código sea mejor que lo que este repositorio describe, **estas tres son decisiones
de dirección tomadas después de que él escribiera lo suyo.** No son opiniones técnicas.

### 4.1 🔴 El QR va al revés de lo que está desplegado

**Lo desplegado:** el estudiante lleva un código TOTP que cambia cada 30 segundos y **el
profesor lo escanea a él**. `validate-scan` rechaza a quien no sea profesor.

**Lo decidido** (`spec/00` §5): **administración muestra el código en pantalla y el estudiante
lo escanea.** El código es de **un solo uso**: muere al usarse y aparece otro.

**Por qué cambió:** con un código en el teléfono del estudiante, basta con mandarlo por
WhatsApp para que un ausente marque asistencia. Con uno de un solo uso en la pantalla del
salón, cuando el ausente lo intente ese código ya está quemado.

**Qué implica:** `validate-scan` y `provision-qr` se reescriben. Contrato exacto en
`entrega/fase0/03_CONTRATOS.md` §2.

### 4.2 🔴 La escala de notas y el ítem crítico

- **Escala 0-20.** Aprueba con **12**, y con **10** solo el primer módulo.
- **El ítem crítico avisa, no topa la nota.** Marca *requiere refuerzo* y alerta al profesor.

Si en algún sitio hay una rúbrica sobre 100 con aprobación en 81, **es la versión vieja**.
Salió de la migración `015`, que está archivada. Ver `spec/00` §2.4.

### 4.3 🔴 La compuerta semanal no bloquea

No existe ningún disparador que marque a un estudiante como «no evaluable» por no haber
completado el trabajo de la semana. **Es una señal para el profesor, no un bloqueo para el
estudiante.** Nadie se queda fuera del taller por no abrir la app (`spec/00` §3).

---

## 5. LO QUE HAY QUE PREGUNTARLE, NO DECIRLE

Tres cosas donde **él sabe más** que este paquete:

1. **Las 9 funciones con `verify_jwt: false`.** ¿Es intencional? Puede haber una razón de
   arquitectura que no se ve desde fuera.
2. **Qué hay detrás de `professor_applications` y `exam_rehabilitation_requests`.** Son dos
   tablas que existen en la base y que ningún documento de este repositorio explica.
3. **Por qué el esquema real difiere de `spec/`.** En varios puntos la base está **mejor**
   alineada con las decisiones que el propio repositorio — por ejemplo `module_enrollments`,
   que ya implementa el modelo de notas correcto.

---

## 6. CUÁNDO ESTÁ TERMINADA LA RECONCILIACIÓN

- [ ] `mdavi` respondió el inventario del paso 1
- [ ] Su trabajo está subido a una rama del repositorio central
- [ ] **No queda nada suyo sin subir a ningún remoto**
- [ ] Está escrito qué pantallas funcionan hoy de punta a punta
- [ ] Está escrito qué migraciones existen y cuáles se aplicaron a `zr-prod`
- [ ] Las tres correcciones de §4 están comunicadas y entendidas
- [ ] Se decidió, tema por tema, qué se queda de cada lado
- [ ] `entrega/00_EMPIEZA_AQUI.md` §4 se corrigió con lo que resultó ser cierto

**Solo entonces se empieza a construir.**

---

## 7. CUÁNTO TOMA

Medio día, entre las dos partes. **Y ahorra días.**

Con el 5 de septiembre a doce días vista, medio día de sincronización es caro. Descubrir el 2
de septiembre que dos personas construyeron la misma pantalla de dos formas distintas es mucho
más caro.
