# TODO GRATIS — QUÉ CUENTAS ABRIR Y CÓMO NO PAGAR NUNCA

> Requisito de dirección: **el proyecto funciona sin costo.**
> Este documento dice qué se usa, qué límite tiene y **qué haría que empiece a cobrar**.

---

## 1. EL RESUMEN

| Pieza | Servicio | Plan | Costo |
|---|---|---|---|
| Base de datos, auth, archivos, funciones | **Supabase** | Free | **$0** |
| Alojamiento de la app | **Cloudflare Pages** o **Vercel** | Free / Hobby | **$0** |
| Repositorio e integración continua | **GitHub** | Free | **$0** |
| Framework | Next.js | Código abierto | **$0** |
| Estilos | Tailwind CSS | Código abierto | **$0** |
| Lector de QR | `@zxing/browser` | Código abierto | **$0** |
| Generador de QR | `qrcode` | Código abierto | **$0** |
| Tipografías | Roboto y Raleway | Licencia libre, **instaladas en el proyecto** | **$0** |
| Pruebas | Vitest + Playwright | Código abierto | **$0** |
| Resumen de dudas con IA | API de Claude | **De pago · OPCIONAL** | ver §5 |

**Total para operar Fase 0: $0.**

---

## 2. SUPABASE — LA PIEZA CENTRAL

El plan gratuito cubre de sobra una academia de ~100 estudiantes. Lo que hay que vigilar:

| Recurso | Qué lo consume aquí | Riesgo |
|---|---|---|
| **Espacio de base de datos** | Filas de asistencia, casos, dudas | Bajo. Son tablas de texto |
| **Almacenamiento de archivos** | **Los PDF de material** | ⚠️ **Es lo único que puede crecer** |
| **Proyectos activos** | `zr-prod` + `zr-dev` | ⚠️ El plan gratuito limita cuántos hay activos |
| **Usuarios activos** | ~100 estudiantes | Muy holgado |

### 2.1 ⚠️ Los proyectos gratuitos se pausan solos

**Un proyecto de Supabase en plan gratuito se pausa si pasa un tiempo sin actividad.**

Para `zr-dev` da igual: se despausa y sigue. **Para `zr-prod` sería un desastre un sábado a las
7:40 de la mañana.** Mitigación:

- Entrar a `zr-prod` durante la semana previa a cada clase, aunque sea a mirar.
- Confirmar el estado del proyecto en la lista de verificación del viernes.

### 2.2 Cómo no llenar el almacenamiento

Los PDF son lo único pesado. Reglas prácticas:

- **Comprimir las presentaciones antes de subirlas.** Una presentación exportada sin comprimir
  puede pesar diez veces lo necesario.
- **Un archivo por semana de módulo**, no uno por clase.
- **Nada de video.** El video de estudiantes es Fase 3 y su cálculo de capacidad está en
  `metodologia/03_PRODUCCION.md` §4: rompería el plan gratuito el primer mes.

### 2.3 Cuentas necesarias

| Proyecto | Para qué | Estado |
|---|---|---|
| `zr-prod` | La base real | ✅ Existe |
| `zr-dev` | Pruebas — **donde trabaja el desarrollador** | ❌ **Hay que crearlo** |

---

## 3. ALOJAMIENTO DE LA APP

Se necesita HTTPS obligatoriamente: **la cámara del teléfono no funciona sin él.**

### 3.1 Dos opciones, ambas gratuitas

| Opción | A favor | En contra |
|---|---|---|
| **Cloudflare Pages** | Plan gratuito sin restricción de uso comercial. Despliegues ilimitados | Next.js requiere un poco más de configuración |
| **Vercel** | Es de los creadores de Next.js, configuración casi nula | ⚠️ El plan gratuito (Hobby) está pensado para uso **no comercial** |

> ⚠️ **Punto a verificar antes de decidir:** Vercel Hobby es gratuito pero sus términos
> restringen el uso comercial. Una academia que cobra matrícula puede caer en esa categoría.
> **Revisen los términos vigentes antes de elegir**, o vayan directo a Cloudflare Pages, que no
> tiene esa restricción.

**Recomendación:** empezar en **Vercel** para el simulacro del 29 (es lo más rápido de montar y
lo que menos tiempo consume esta semana), y **decidir el destino definitivo antes de cobrar la
primera matrícula a través de la app** — que en Fase 0 no ocurre, porque no hay pagos.

### 3.2 Lo que NO se debe hacer

- **No pagar un servidor propio.** No hace falta y añade mantenimiento.
- **No usar alojamiento compartido tipo cPanel.** Next.js no encaja bien ahí.

---

## 4. GITHUB

Gratuito para repositorios privados, incluida la integración continua para este volumen.

**Un detalle que ya bloqueó al proyecto:** el token actual **no tiene permiso para subir flujos
de trabajo**, y por eso el CI lleva un mes sin existir. Está resuelto en
`fase0/02_CONEXIONES.md` §5.

---

## 5. LA ÚNICA PIEZA QUE CUESTA — Y ES OPCIONAL

El **resumen automático de dudas**: la IA lee las dudas de la semana y redacta las 3 preguntas
que cubren lo más repetido, para el profesor.

| Camino | Costo | Cuándo elegirlo |
|---|---|---|
| **A · A mano** | **$0** | **Recomendado para Fase 0.** Alguien lee las dudas el viernes y escribe las 3 preguntas. Con 24 estudiantes son 30 dudas: 15 minutos |
| **B · Automático** | Céntimos por semana | Cuando haya varias cohortes y leerlas a mano deje de ser viable |

**La app se construye igual en los dos casos.** La pantalla del profesor muestra las 3
preguntas y debajo las dudas en crudo. Lo único que cambia es quién escribe esas 3 preguntas.

> **Regla de diseño:** si la función automática falla o no está contratada, **el profesor sigue
> viendo las dudas en crudo y nada se rompe.** Nunca se deja una pantalla dependiendo de que un
> servicio de pago responda.

### 5.1 Si algún día se activa

- La clave se guarda como **secreto de las Edge Functions**, nunca en el repositorio.
- **Al modelo solo se le mandan los textos de las preguntas.** Nunca nombre, cédula ni nada que
  identifique a quien preguntó — son menores de edad (`metodologia/01_MODELO.md` §5.1).

---

## 6. LO QUE HARÍA QUE ESTO EMPIECE A COSTAR

Vigilar estas cuatro cosas:

| Si pasa esto | Qué cuesta |
|---|---|
| Subir video de estudiantes | Revienta el almacenamiento gratuito. **Es Fase 3, no se hace** |
| Subir presentaciones sin comprimir | Llena el almacenamiento antes de tiempo |
| Crear un proyecto Supabase por cohorte | Se pasa del límite de proyectos. **Una sola base, varias cohortes** |
| Activar el resumen de IA sin necesitarlo | Gasto evitable. Ver §5 |

---

## 7. LISTA DE CUENTAS A ABRIR

Para el técnico, el primer día:

- [ ] Cuenta de **GitHub**, y que dirección lo agregue como colaborador del repositorio
- [ ] Cuenta de **Supabase**, y que dirección lo invite a la organización
- [ ] Cuenta de **Vercel** (o Cloudflare), conectada al repositorio
- [ ] **Node.js 20 o superior** instalado
- [ ] **Supabase CLI** instalada
- [ ] **Docker** instalado — hace falta para levantar Supabase en local

Los comandos exactos están en `fase0/01_ENTORNO.md`.
