# 04 · EL BACKLOG DE FASE 0

> Cada tarea trae **qué hace**, **qué toca** y **cuándo está terminada**.
> Una tarea sin criterio de terminado se discute tres veces; una con criterio se verifica.
>
> **Se hacen en orden.** Cada bloque depende del anterior.

---

## CÓMO USAR ESTE DOCUMENTO CON UN AGENTE DE CÓDIGO

Una tarea por conversación. El prompt que funciona:

```
Lee entrega/00_EMPIEZA_AQUI.md e INGENIERIA.md.
Vamos a hacer F0-11 de entrega/fase0/04_TAREAS.md.
La pantalla está en ZR_APP_FASE0_PROTOTIPO.html, vista v-qr.
El contrato está en entrega/fase0/03_CONTRATOS.md §2.1.
```

**Lo que no funciona:** «haz la pantalla de asistencia». Sin criterio de terminado, el agente
inventa el alcance.

---

# BLOQUE A · CIMIENTOS

## 🔴 F0-01 · Probar la cámara **[RIESGO MÁXIMO]**
Página mínima con `@zxing/browser`, desplegada con HTTPS, que lea un QR de otra pantalla.

**Terminado cuando:** tres teléfonos distintos, uno de gama baja, leen el código **en el
taller** en menos de 3 segundos.

**Si falla:** se para todo y se replantea la asistencia. No se sigue construyendo sobre un
supuesto roto.

## 🔴 F0-02 · Accesos
Ver `02_CONEXIONES.md` §8. **No lo resuelve el desarrollador solo.**

**Terminado cuando:** `zr-dev` existe, el desarrollador entra, y **los dos repositorios están
unificados** — `entrega/02_RECONCILIACION.md`.

## 🔴 F0-03 · El proyecto existe
Next.js 15 + TypeScript + Tailwind 4, tokens de `spec/06`, tipografías locales, clientes de
Supabase (navegador y servidor), desplegado con HTTPS.

**Terminado cuando:** la app abre por HTTPS desde un teléfono, aunque sea una pantalla en blanco.

## 🔴 F0-04 · Volcar el esquema y descargar las funciones
`supabase db pull` → `000_esquema_base.sql`. Descargar las 13 Edge Functions.

**Terminado cuando:** `supabase db reset` en local reproduce la base y `npm run db:types` genera
tipos sin errores.

---

# BLOQUE B · BASE DE DATOS

## 🔴 F0-05 · Migración 034 — QR de un solo uso
Está **escrita** en `migraciones/034_qr_un_solo_uso.sql`. Revisar, correr en local, luego en
`zr-dev`, luego pedir aprobación para `zr-prod`.

**Terminado cuando:** existe `qr_codes`, el índice único parcial impide dos códigos vivos por
sesión, y las dos claves `attendance.qr_*` ya no están.

## 🔴 F0-06 · Migración 035 — claves de configuración
Escrita en `migraciones/035_system_config.sql`.

**Terminado cuando:** las 7 claves existen y los pesos suman 1.

## 🔴 F0-07 · Migración 036 — tablas del contenido
Escrita en `migraciones/036_contenido_fase0.sql`.

**Terminado cuando:** las 5 tablas existen **con RLS y políticas**, la vista `v_casos_conteo`
tiene `security_invoker = true`, y ninguna tabla del esquema queda sin RLS.

## 🔴 F0-08 · Cerrar los hallazgos de seguridad **[BLOQUEA CARGAR ESTUDIANTES]**
Quitar `SECURITY DEFINER` de `v_students`, `v_exam_questions_student` y
`v_feedback_session_summary` — o justificar cada una por escrito. Política para
`student_qr_secrets`. Revisar las 9 funciones con `verify_jwt: false`.

**Terminado cuando:** el linter no reporta ningún hallazgo de nivel `ERROR`.

> **Hasta que esto pase, no se carga ni una cédula real.**

---

# BLOQUE C · IDENTIDAD

## 🔴 F0-09 · Entrar con cédula
Prefijo `V-`/`E-`, cédula a correo interno, middleware por grupo de ruta.
**El rol se lee del servidor, nunca del cliente** (regla 9).

**Un solo mensaje de error** para cualquier fallo: *«Cédula o contraseña incorrecta»*. Decir
«esa cédula no existe» confirma qué cédulas están registradas.

**Terminado cuando:** los cuatro roles entran y cada uno cae en su pantalla, en un teléfono.

## 🔴 F0-10 · Contraseña temporal
Si el perfil está marcado como temporal, redirige a cambio obligatorio antes de cualquier otra
pantalla.

**Terminado cuando:** un usuario nuevo no puede llegar a ninguna pantalla sin cambiarla.

## 🟠 F0-11 · Carnet digital
Nombre, cédula, programa, código, sede, turno.

**Terminado cuando:** se abre **en modo avión** y se ve completo.

---

# BLOQUE D · ASISTENCIA · lo que decide el piloto

## 🔴 F0-12 · `provision-codigo` + pantalla del QR
Edge Function §2.1 de `03_CONTRATOS.md`, y la pantalla a pantalla completa.

**Terminado cuando:** el QR se lee **a dos metros**, el contador sube solo, y al escanearse
aparece otro código distinto al instante.

## 🔴 F0-13 · `validate-scan` reescrita + pantalla de escaneo
Edge Function §2.2. **La desplegada hace lo contrario: no se parchea, se reescribe.**

Permiso de cámara **con explicación previa**, no a secas. Resultado legible **a un metro**, con
los tres estados: verde, amarillo (*ya estabas registrado*), rojo.

**Terminado cuando:**
- Un escaneo marca asistencia **y refrigerio** en el mismo evento
- **El mismo escaneo dos veces no crea dos asistencias**
- Un código ya usado da error claro
- Un estudiante de otra cohorte da error claro
- Probado entre dos teléfonos reales, en el taller

## 🔴 F0-14 · `registro-manual` **[SIN ESTO NO SE PUEDE OPERAR EL DÍA 5]**
Edge Function §2.3, y la pantalla con búsqueda y motivo.

**Terminado cuando:** un estudiante sin teléfono queda registrado **en menos de 20 segundos**,
cronometrado, y queda guardado el motivo y quién lo hizo.

## 🟠 F0-15 · Asistentes en vivo del profesor
Contador que sube solo, con suscripción en tiempo real.

**Terminado cuando:** administración registra a alguien y el número del profesor sube **sin
recargar**, en menos de 5 segundos.

---

# BLOQUE E · CONTENIDO

## 🟠 F0-16 · Material
Administración sube PDF al bucket privado y lo asigna al módulo. El estudiante lo abre con URL
firmada. Registro en `content_views`.

**Terminado cuando:** los cuatro estados están resueltos — cargando, **vacío**, error, con
datos. El vacío importa: los primeros días estará vacío de verdad.

## 🟠 F0-17 · Mi módulo
Lista de competencias, solo lectura. **Sin estado de dominio, sin colores, sin porcentaje.**

**Terminado cuando:** se ven las competencias del módulo del estudiante y de ningún otro.

## 🔴 F0-18 · El caso del día **[LA PANTALLA QUE DEFINE FASE 0]**
Los cuatro pasos con barra de progreso.

**Terminado cuando:**
- **La referencia no se revela sin completar los cuatro pasos**
- Al intentarlo sale el mensaje, no un error
- **La calibración de confianza** muestra el mensaje correcto en los cuatro cruces
- El intento se guarda
- ⚠️ **El navegador nunca recibe `correcta` ni `reference` antes de revelar** — comprobado
  mirando la pestaña de red, no confiando en la pantalla
- No aparece ningún puntaje: el caso no produce nota

## 🟠 F0-19 · La tira de la semana
Seis días con sus estados. Los futuros **se pueden mirar pero no trabajar**.

**Terminado cuando:** un día futuro muestra de qué se trata, con el botón deshabilitado y su
aviso.

## 🟠 F0-20 · Mandar una duda
Texto libre, sin lista de temas. Dos entradas: al terminar un caso, y desde el inicio.

**Terminado cuando:** el estudiante ve sus propias dudas y **ninguna de otro estudiante**.

## 🟡 F0-21 · Las tres preguntas del profesor
Edge Function §2.4 + pantalla. **Con salida manual:** si la función falla o no hay clave, el
profesor ve las dudas en crudo y nada se rompe.

**Terminado cuando:** el profesor ve las 3 preguntas y debajo las dudas, y **al modelo no se le
manda ningún dato identificable** — comprobado leyendo el código de la función.

## 🟡 F0-22 · El conteo de casos
*«14 de 24 trabajaron el caso»*, desde `v_casos_conteo`.

**Terminado cuando:** el profesor ve el número y **la consulta directa a `case_attempts` con su
sesión devuelve cero filas**. Eso es lo que se prueba, no que la pantalla no muestre nombres.

---

# BLOQUE F · ENTREGA

## 🟡 F0-23 · PWA instalable
Manifiesto con los iconos de `marca/`, service worker.

**Terminado cuando:** se instala en **tres teléfonos distintos** desde el navegador.

## 🟠 F0-24 · Cargar contenido y cohorte
Los casos aprobados, las competencias, los PDF, y las cédulas de la cohorte.

**Terminado cuando:** los hallazgos `ERROR` están cerrados **antes** de cargar la primera
cédula real, y **el estudiante A no puede leer nada del estudiante B** — verificado con dos
sesiones reales, no con la teoría.

## 🔴 F0-25 · Congelar
**No se despliega nada después del viernes 4.**

**Terminado cuando:** la lista de `fase0/01_ENTREGABLE.md` §8 está completa y el plan B está
escrito y conocido por quien vaya a estar el sábado.

---

## RESUMEN DE PRIORIDAD

| | Tareas | Si falta |
|---|---|---|
| 🔴 **No se recorta** | F0-01 a F0-10, F0-12 a F0-14, F0-18, F0-25 | No hay piloto |
| 🟠 Importante | F0-11, F0-15 a F0-17, F0-19, F0-20, F0-24 | Se degrada, se opera igual |
| 🟡 Se recorta primero | F0-21, F0-22, F0-23 | Se hace a mano |

El orden exacto de recorte está en `fase0/01_ENTREGABLE.md` §5.
