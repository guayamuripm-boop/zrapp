# ENTREGA AL EQUIPO DE DESARROLLO

> Escrito el 24 de agosto de 2026. Este es el punto de entrada para **el técnico y su agente
> de código**. Todo lo verificado aquí se comprobó contra la base real `zr-prod`, no contra
> documentación.

---

## 1. LEE ESTO EN 3 MINUTOS ANTES DE NADA

**Qué es el proyecto:** una aplicación web instalable (PWA) para una academia técnica de
mecánica automotriz en Venezuela. Clases los sábados. Estudiantes de 15 a 25 años, **muchos
menores de edad** — eso condiciona todo lo relacionado con datos.

**Cómo está partido el trabajo:**

| Carpeta | Qué construye | Cuándo |
|---|---|---|
| **`fase0/`** | Lo que se entrega el **5 de septiembre de 2026** | **Ahora** |
| **`fase1/`** | El producto completo del prototipo v10 | Después del 5 |

> **Empieza por `fase0/00_EMPIEZA_AQUI.md`. No abras `fase1/` hasta que Fase 0 esté entregada.**

---

## 2. LAS DOS COSAS QUE HAY QUE ABRIR ANTES DE ESCRIBIR CÓDIGO

1. **`ZR_APP_FASE0_PROTOTIPO.html`** — ábrelo en el navegador. Es lo que hay que construir en
   Fase 0, funcionando. Recórrelo con los tres roles.
2. **`ZR_APP_PROTOTIPO_v10.html`** — el producto completo, para Fase 1.

**Los prototipos son la especificación visual.** Ante cualquier duda de cómo se ve o se
comporta una pantalla, se abre el prototipo. **No se inventa.**

---

## 3. LAS DIEZ REGLAS QUE NO SE ROMPEN

Están completas en `CLAUDE.md` §2. Estas son las que más caro salen:

1. **Ninguna tabla sin RLS y sin política**, escritas en la misma migración.
2. **Ningún cálculo de negocio en el navegador.** Notas, validación de QR y corrección viven
   en el servidor. El cliente solo muestra.
3. **La clave `service_role` nunca en código de navegador.** Da acceso total saltándose el
   aislamiento.
4. **Ningún número de negocio escrito en el código.** Umbrales y pesos van a `system_config`.
5. **Una migración aplicada no se edita.** Se crea la siguiente.
6. **El rol nunca viene del cliente.** Se lee del servidor.
7. **Nunca se le manda `correct_answer` al estudiante.**
8. **Nada de Fase 2 o 3**: pagos, puntos, insignias, mensajería privada.

---

## 4. EL ESTADO REAL, VERIFICADO

No le creas a la documentación vieja del repositorio. Esto se comprobó en vivo:

| | Estado |
|---|---|
| Base `zr-prod` | **Viva.** 29 tablas, RLS activada en todas, migración **033** |
| Siguiente migración | **034** — no la 017 |
| Edge Functions | **13 desplegadas.** 9 con `verify_jwt: false`, por revisar |
| ⚠️ `validate-scan` y `provision-qr` | **Implementan el modelo de QR contrario al decidido.** Hay que reescribirlas |
| Aplicación Next.js | ⚠️ **No existe en ESTE repositorio.** Puede existir en el de `mdavi` — ver §4.2 |
| Proyecto `zr-dev` | **No existe** |
| Estudiantes cargados | **0** |
| Hallazgos de seguridad | **3 de nivel ERROR abiertos** |

### 4.1 Lo que esto significa el primer día

**Las 13 funciones desplegadas no son un adelanto para la asistencia: son deuda.** La
`validate-scan` que está viva exige que quien llame sea *profesor* y valida un código TOTP que
lleva el estudiante — es exactamente al revés de lo decidido.

### 4.2 ⚠️ HAY DOS REPOSITORIOS, Y ESTE NO ES EL ÚNICO

`mdavi`, el programador del proyecto, trabaja desde su propio clon y **lo ha ido mejorando**.
Desde ahí desplegó las 13 Edge Functions vivas.

**Este repositorio va por delante en especificación y planificación. El suyo, en código.**
Ninguno de los dos está completo.

> **Antes de aplicar nada de este paquete, hay que unificarlos.**
> El procedimiento está en `entrega/02_RECONCILIACION.md`. Es lo primero, antes incluso de
> instalar dependencias.
>
> La tabla de arriba describe **este** repositorio. Cuánto de eso sigue siendo cierto después
> de mirar el otro es exactamente lo que la reconciliación tiene que averiguar.

---

## 5. TODO ESTO ES GRATIS — Y CÓMO SE MANTIENE ASÍ

Ver **`01_TODO_GRATIS.md`**. Resumen: el stack completo (Supabase, alojamiento, GitHub,
tipografías, librerías) funciona en planes gratuitos para el tamaño de esta academia.

**La única pieza que cuesta dinero es opcional** y tiene salida gratuita: el resumen automático
de dudas con IA. Si no se paga, el profesor lee las dudas en crudo y no se rompe nada.

---

## 6. ORDEN DE LECTURA

```
0. 02_RECONCILIACION.md                  ← ⛔ PRIMERO. Hay dos repositorios
1. Este archivo                          ← estás aquí
2. 01_TODO_GRATIS.md                     ← qué cuentas abrir, sin pagar
3. fase0/00_EMPIEZA_AQUI.md              ← el día 1, hora a hora
4. fase0/01_ENTORNO.md                   ← comandos exactos para arrancar
5. fase0/02_CONEXIONES.md                ← accesos y secretos
6. fase0/03_CONTRATOS.md                 ← qué recibe y devuelve cada función
7. fase0/04_TAREAS.md                    ← el backlog, con criterio de terminado
8. fase0/migraciones/                    ← SQL listo para correr
```

Y en la raíz del repositorio, cuando haga falta el porqué:

| Documento | Responde |
|---|---|
| `INGENIERIA.md` | Cómo se trabaja: ramas, migraciones, pruebas, definición de terminado |
| `fase0/01_ENTREGABLE.md` | Qué hace cada pantalla, y **qué se recorta si se atrasa** |
| `fase0/02_PLAN.md` | Los 12 días con fechas reales |
| `spec/00_RECONCILIACION.md` | Las reglas de negocio. Manda sobre el resto |
| `spec/06_IDENTIDAD_VISUAL.md` | Colores, tipografías, medidas, voz |
| `metodologia/01_MODELO.md` | Por qué el modelo pedagógico es así |

---

## 7. LOS CUATRO BLOQUEANTES QUE **NO** PUEDE RESOLVER EL DESARROLLADOR

Están en manos de dirección. Si no se resuelven, el día 1 se pierde:

| # | Bloqueante | Quién lo resuelve |
|---|---|---|
| 1 | **Acceso a Supabase.** Hay que invitar al desarrollador a la organización | Dirección |
| 2 | **`zr-dev` no existe.** Hoy la única base es producción, con datos reales | Dirección |
| 3 | **Hay un segundo repositorio con código que este no conoce** — el de `mdavi`, el programador. Hay que unificarlos | Dirección + mdavi |
| 4 | **El token de GitHub no puede subir flujos de trabajo**, así que no hay CI | Dirección |

Detalle y comandos en `fase0/02_CONEXIONES.md`.

---

## 8. LA REGLA DE ORO DE ESTE PROYECTO

> **Si algo no está escrito en ningún lado, la respuesta correcta es preguntar. Nunca inventar.**

Una decisión inventada cuesta días de retrabajo. Una pregunta cuesta cinco minutos.
