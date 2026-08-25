# 03 · EL MENSAJE PARA MDAVI

> Copia el bloque de §1 y mándaselo por donde se hablen normalmente.
> Está escrito para que lo pueda leer en dos minutos y sepa exactamente qué hacer.

---

## 1. EL MENSAJE — copia desde aquí

---

Hola. Trabajé estos días en ordenar el proyecto y hay **cambios de alcance y tres decisiones
que te afectan directamente**. Todo está subido a `main` en
`github.com/guayamuripm-boop/zrapp`.

**Antes de que apliques nada, hay algo que resolver:** tú tienes trabajo en tu clon que ese
repositorio no conoce, y el repositorio tiene decisiones nuevas que tu clon no conoce. Si
aplicas lo nuevo encima sin más, es probable que te pida rehacer cosas que ya hiciste.

Así que el primer paso no es código, es sincronizar.

### Lo primero — 20 minutos

```bash
git pull
```

Y lee, en este orden:

1. **`entrega/02_RECONCILIACION.md`** ← empieza por aquí, es el procedimiento
2. `entrega/00_EMPIEZA_AQUI.md`
3. `entrega/fase0/00_EMPIEZA_AQUI.md`

Y **abre en el navegador `ZR_APP_FASE0_PROTOTIPO.html`** — es una maqueta funcional de lo que
hay que entregar el 5 de septiembre. Recórrela con los tres roles.

### Lo que necesito de ti para sincronizar

Contéstame esto cuando puedas, aunque sea en bruto:

```
1. ¿Tienes una app Next.js? ¿Qué pantallas funcionan hoy de punta a punta?
2. ls supabase/migrations/
3. ¿Aplicaste alguna migración a zr-prod después del 15 de agosto?
4. git remote -v   y   git log --oneline -15
5. git status   ← ¿hay algo tuyo sin subir a ningún lado?
```

Y **sube tu trabajo a una rama del repositorio central**, para que los dos podamos verlo:

```bash
git remote add central https://github.com/guayamuripm-boop/zrapp.git
git fetch central
git checkout -b codigo-de-mdavi
git push central codigo-de-mdavi
```

No mergees nada todavía. Solo que sea visible.

### Las tres decisiones que cambiaron

Son de dirección, tomadas después de que escribieras lo tuyo. Están explicadas con el porqué en
`entrega/02_RECONCILIACION.md` §4:

1. **El QR va al revés.** Ahora **administración muestra el código en pantalla y el estudiante
   lo escanea**, y es de **un solo uso**. Lo desplegado hace lo contrario: el estudiante lleva
   un TOTP y el profesor lo escanea. La razón es concreta — un código en el teléfono del
   estudiante se manda por WhatsApp y un ausente marca asistencia.
2. **Escala 0-20**, aprueba con 12 (con 10 el primer módulo). **El ítem crítico avisa, no topa
   la nota.** Si viste una rúbrica sobre 100 con aprobación en 81, es la versión vieja.
3. **La compuerta semanal no bloquea.** Es una señal para el profesor. Nadie se queda fuera del
   taller por no abrir la app.

### Y tres cosas donde tú sabes más que yo

Pregunto en serio, no para corregirte:

1. Las **9 Edge Functions con `verify_jwt: false`** — ¿es a propósito?
2. **`professor_applications`** y **`exam_rehabilitation_requests`** — existen en la base y
   ningún documento las explica. ¿Qué hay detrás?
3. En varios puntos **el esquema real está mejor que la especificación** (`module_enrollments`
   ya implementa el modelo de notas correcto). ¿Hay más cosas así que deba saber?

### El contexto de fechas

**Sábado 5 de septiembre hay clase con estudiantes nuevos** y ese día se usa la app. El alcance
está cerrado en `fase0/00_LEEME.md` y el plan día por día en `fase0/02_PLAN.md`.

Lo que no se puede recortar de ninguna forma: **entrar, el carnet, el QR, el escaneo y el
registro manual**. El registro manual sobre todo — ese día los estudiantes son nuevos y nadie
llega con la app instalada, así que es la vía principal de entrada, no el plan B.

Cuando me respondas el inventario, ajustamos el plan a lo que de verdad ya existe.

---

## 2. FIN DEL MENSAJE

---

## 3. QUÉ MANDARLE ADEMÁS

| Qué | Cómo |
|---|---|
| **El repositorio** | Ya está todo en `main`. Solo necesita `git pull` |
| **El prototipo de Fase 0** | Está en el repositorio, pero mándaselo también como archivo suelto — se abre sin instalar nada y lo puede ver desde el teléfono |
| **La presentación del módulo** | Cuando la tengas. Es el camino crítico del contenido |

### 3.1 Lo que **no** se manda por chat

- Ninguna clave, ni de Supabase, ni de la API, ni de nada.
- Las credenciales van por el gestor de contraseñas, y los comandos que las usan los corre él
  en su máquina (`supabase login`).

---

## 4. LO QUE TÚ TIENES QUE RESOLVER EN PARALELO

Mientras él hace el inventario:

| # | Qué | Por qué urge |
|---|---|---|
| 1 | **Crear `zr-dev`** | Hoy la única base es producción, con datos reales |
| 2 | Confirmar que él tiene acceso a la organización de Supabase | Para que pueda desplegar |
| 3 | **Activar el CI** — `.github/ci-pendiente.yml` | Es la red de seguridad que falta hace un mes |
| 4 | **La presentación del módulo** | Sin ella no hay casos ni competencias |

---

## 5. DESPUÉS DE QUE RESPONDA

Cuando tengas su inventario, tráemelo. Con eso puedo:

- Corregir `entrega/00_EMPIEZA_AQUI.md` §4 con el estado que resulte ser cierto
- Quitar del backlog las tareas que ya estén hechas
- Renumerar las migraciones si él tiene algunas que la base no refleja
- Ajustar `fase0/02_PLAN.md` a los días que de verdad quedan

**Ese es el momento en que el plan deja de ser una estimación y pasa a ser real.**
