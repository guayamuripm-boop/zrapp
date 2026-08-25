# 02 · CONEXIONES, ACCESOS Y SECRETOS

> **En este documento no hay ni una sola clave, y nunca la habrá.**
> Dice qué secreto existe, quién lo tiene y cómo pedirlo.

---

## 1. LA REGLA DE LAS CREDENCIALES

> **Ninguna clave se escribe en el repositorio, ni se manda por chat, ni por correo.**

Se comparten por el **gestor de contraseñas del equipo**. Y los comandos que las usan
(`supabase login`, `supabase secrets set`) **los corre cada quien en su máquina** — nadie
necesita ver la clave de otro.

Si una clave llega al repositorio, queda en el historial de git **para siempre**, aunque se
borre en el commit siguiente. Rotarla es la única salida.

---

## 2. LOS CUATRO SERVICIOS

| Servicio | Para qué | Quién administra |
|---|---|---|
| **Supabase** | Base, autenticación, archivos, funciones | Dirección |
| **GitHub** | Repositorio e integración continua | Dirección |
| **Alojamiento** (Vercel / Cloudflare) | La app, con HTTPS | Por definir |
| **API de Claude** | Resumen de dudas · **opcional** | Dirección |

---

## 3. SUPABASE

### 3.1 Los proyectos

| Proyecto | Qué es | Quién entra |
|---|---|---|
| **`zr-prod`** | La base real, con estudiantes reales | ⚠️ Acceso restringido |
| **`zr-dev`** | Pruebas — **donde trabaja el desarrollador** | Todo el equipo |

> ## 🔴 `zr-dev` NO EXISTE TODAVÍA
> Hoy la única base es producción. **Crearlo es la primera tarea de infraestructura.**
> Va en la misma organización, es gratuito, y es lo que permite cumplir la regla de oro:
>
> > **Ninguna migración toca `zr-prod` sin haber corrido antes en local y en `zr-dev`.**

### 3.2 Recomendación sobre el acceso a producción

**El desarrollador trabaja contra `zr-dev`. Las migraciones a `zr-prod` las aplica y aprueba
dirección**, después de que hayan corrido limpias en desarrollo.

No es desconfianza: son datos personales de menores de edad, y la LOPNNA los regula. Un
`update` sin `where` a las 11 de la noche le puede pasar a cualquiera.

### 3.3 Cómo se conecta

```bash
supabase login
```

Abre el navegador y se autoriza ahí. **Cada quien con su propia cuenta.**

```bash
supabase link --project-ref <ref-del-proyecto>
```

### 3.4 ⚠️ Dos problemas abiertos

**a) El CLI de la máquina de dirección apunta a otra cuenta.** Está autenticado con una cuenta
que no ve `zr-prod`. Se resuelve con `supabase login` usando la cuenta dueña.

**b) Hay un segundo repositorio con trabajo real.** `mdavi`, el programador del proyecto,
trabaja desde su propio clon y desde ahí desplegó las 13 Edge Functions vivas.

> **Antes de que nadie escriba una migración, hay que unificar los dos repositorios.**
> Ver `entrega/02_RECONCILIACION.md`. Dos personas migrando la misma base en paralelo es la
> forma más rápida de romperla — y que sean del mismo equipo no lo evita.

### 3.5 Las claves que da Supabase

| Clave | Dónde va | Puede ir al navegador |
|---|---|---|
| `anon` / publicable | `.env.local` y el panel del alojamiento | ✅ Sí |
| `service_role` | Solo servidor y Edge Functions | ⛔ **Jamás** |

---

## 4. LAS 13 EDGE FUNCTIONS QUE YA ESTÁN DESPLEGADAS

El repositorio conoce **una**. En `zr-prod` hay **trece** vivas:

```
validate-scan · provision-qr · claim-snack · create-student · create-staff-user
submit-attempt · grade-answer · send-push · approve-professor · delete-account
request-rehabilitation · approve-rehabilitation · respond-rehabilitation
```

**Tarea F0-05b:** descargarlas al repositorio y revisarlas.

```bash
supabase functions download <slug>
```

### 4.1 Dos advertencias

⚠️ **Nueve tienen `verify_jwt: false`** — aceptan llamadas sin token. Hay que revisar una por
una si es intencional o es un hueco.

⚠️ **`validate-scan` y `provision-qr` implementan el modelo de QR contrario al decidido.**
No son un adelanto: son deuda. Se reescriben — contrato en `03_CONTRATOS.md` §2.

---

## 5. GITHUB

### 5.1 Acceso

Dirección agrega al desarrollador como colaborador de
`github.com/guayamuripm-boop/zrapp`.

### 5.2 🔴 El CI está escrito pero desactivado

El proyecto **lleva un mes sin integración continua**, y no por una decisión técnica.

Al intentar publicar el flujo de trabajo, GitHub lo rechaza:

```
refusing to allow a Personal Access Token to create or update workflow
`.github/workflows/ci.yml` without `workflow` scope
```

El token no tiene permiso para subir flujos. En su momento se borró el archivo para desatascar
un push, y con él se fue la única red de seguridad automática — la que impide que **una tabla
sin RLS o una clave de servicio filtrada** lleguen a producción.

**El flujo está listo en `.github/ci-pendiente.yml`.** Dos formas de activarlo:

| Camino | Cómo |
|---|---|
| **A · Desde la web, 30 segundos** | En el repositorio: *Add file › Create new file*, nombre `.github/workflows/ci.yml`, pegar el contenido, *Commit* |
| **B · Arreglando el token** | Dar permiso `workflow` en `github.com/settings/tokens`, y luego mover el archivo por git |

**Qué comprueba una vez activo:** que ninguna clave de servicio esté en el repositorio, que
ninguna migración archivada vuelva, que **toda migración que crea una tabla habilite RLS**, y
que no haya enlaces rotos. Cuando exista la app, además: tipos, linter, pruebas, **pruebas de
aislamiento** y que `service_role` no se filtre al navegador.

---

## 6. ALOJAMIENTO

Ver `entrega/01_TODO_GRATIS.md` §3 para elegir entre Vercel y Cloudflare Pages.

**Lo urgente no es cuál, es que exista hoy:** sin HTTPS no se puede probar la cámara, que es el
riesgo máximo del proyecto.

Las tres variables de entorno se cargan **en el panel del servicio**, nunca en el repositorio.

---

## 7. API DE CLAUDE — OPCIONAL

Solo para `resumir-dudas`. **Si no se contrata, Fase 0 funciona igual**: el profesor lee las
dudas en crudo y alguien escribe las 3 preguntas a mano el viernes. Son 15 minutos.

Si se activa:

```bash
supabase secrets set ANTHROPIC_API_KEY=...
```

Ese comando **lo corre dirección**, con la clave. Nunca va al repositorio ni a `.env.local`.

> ⚠️ **Al modelo solo se le mandan los textos de las dudas.** Nunca nombre, cédula ni nada que
> identifique a quien preguntó. Son menores de edad.

---

## 8. RESUMEN DE BLOQUEANTES

Ninguno lo puede resolver el desarrollador solo:

| # | Bloqueante | Quién | Bloquea |
|---|---|---|---|
| 1 | Invitar al desarrollador a Supabase y a GitHub | Dirección | **Todo** |
| 2 | **Crear `zr-dev`** | Dirección | Cualquier migración |
| 3 | **Unificar los dos repositorios** — ver `entrega/02_RECONCILIACION.md` | Dirección + mdavi | Cualquier migración |
| 4 | Crear el proyecto de alojamiento | Dirección o técnico | **La prueba de cámara** |
| 5 | Activar el CI | Dirección | La red de seguridad |
| 6 | Cerrar los 3 hallazgos de nivel `ERROR` | Técnico | **Cargar estudiantes reales** |

> **Regla dura sobre el 6:** no se carga ni una cédula real mientras haya un hallazgo de nivel
> `ERROR` abierto. Son `v_students`, `v_exam_questions_student` y
> `v_feedback_session_summary`, las tres con `SECURITY DEFINER`.
