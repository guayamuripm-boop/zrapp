# 02 · LOS 12 DÍAS

> **Fechas verificadas contra el calendario real de 2026.** El plan anterior
> (`plan/02_SPRINT.md`) tenía los días de la semana equivocados: daba el 21 de agosto por
> jueves cuando fue viernes, y ponía el ensayo el «sábado 30», que es domingo.

---

## 0. LA IDEA QUE ORDENA ESTE PLAN

> **Se construye en un orden donde siempre hay algo que funciona.**

La asistencia va primero, completa, y se exprime en el simulacro del **sábado 29**. Si a
partir de ahí todo sale mal, lo que queda en pie es un piloto que cumple el criterio binario.
El contenido se construye encima, en la segunda semana.

Lo contrario — empezar por el material y los casos porque son más fáciles — dejaría el riesgo
grande para el final. **La cámara es lo único que puede obligar a replantear el modelo, y hay
que saberlo el primer día, no el día 10.**

---

## 1. EL CALENDARIO REAL

| | L | M | X | J | V | **S** | D |
|---|---|---|---|---|---|---|---|
| **Ago** | **24** hoy | 25 | 26 | 27 | 28 | **29 SIMULACRO** | 30 |
| **Ago/Sep** | 31 | 1 | 2 | 3 | 4 | **5 PILOTO** | 6 |

**Dos sábados.** El 29 es un **simulacro técnico sin estudiantes** — la clase de ese día es
otra cohorte. El 5 es el piloto, **con estudiantes nuevos que ese día conocen la academia**.

> ⚠️ Eso significa que **el 5 de septiembre es el primer contacto de la app con estudiantes
> reales**. No hay ensayo previo con gente. Ver §Sábado 29 y `01_ENTREGABLE.md` §6.

---

# SEMANA 1 · LA ASISTENCIA, COMPLETA

## 🔴 Lunes 24 — Los riesgos primero

### F0-01 · Probar la cámara **[RIESGO MÁXIMO]**
- [ ] Página mínima con `@zxing/browser`, desplegada en Vercel — **HTTPS es obligatorio**
- [ ] **Tres teléfonos distintos**, uno de gama baja
- [ ] **En el taller, con su luz real.** No en una oficina

**Terminado cuando:** tres teléfonos leen un QR de pantalla en menos de 3 segundos, en el taller.

**Si falla:** se para y se replantea la asistencia hoy mismo. Alternativas: código de 6 dígitos
en la pizarra, o lista manual. **No se sigue construyendo sobre un supuesto roto.**

### F0-02 · Resolver quién más toca `zr-prod`
- [ ] Hay una Edge Function desplegada desde otro repositorio, en otra máquina
- [ ] El CLI de esta máquina está autenticado con una cuenta que no ve `zr-prod`

### F0-03 · El proyecto existe
- [ ] Next.js 15 + TypeScript + Tailwind 4
- [ ] Tokens de `spec/06`, fuentes locales — **nunca desde un CDN**
- [ ] Cliente de Supabase, navegador y servidor
- [ ] Desplegado en Vercel, aunque sea una pantalla en blanco

### 📨 F0-04 · Pedir la presentación del módulo **[CAMINO CRÍTICO DEL CONTENIDO]**
- [ ] Pedirla hoy. **Se necesita el miércoles 26 a más tardar**

---

## 🔴 Martes 25 — La base queda lista

### F0-05 · Volcar el esquema real
- [ ] Exportar `zr-prod` a `supabase/migrations/000_esquema_base.sql`
- [ ] Descargar las 13 Edge Functions al repositorio

### F0-06 · Migración 034 — QR de un solo uso
- [ ] Tabla `qr_codes` con `used` y `used_at`
- [ ] Retirar `attendance.qr_window_seconds` y `attendance.qr_drift_tolerance`
- [ ] **Reescribir `validate-scan`** — la desplegada implementa el modelo contrario
- [ ] **Retirar o reescribir `provision-qr`** — genera el TOTP del estudiante, que ya no se usa

### F0-07 · Migración 035 — las claves que faltan
Las cinco de `spec/00` §6.1. En Fase 0 hacen falta menos, pero se crean todas para no volver.

### F0-08 · Cerrar los hallazgos de seguridad **[BLOQUEA CARGAR ESTUDIANTES]**
- [ ] Quitar `SECURITY DEFINER` de las 3 vistas, o justificar por escrito
- [ ] Política para `student_qr_secrets`
- [ ] Revisar las 9 funciones con `verify_jwt: false`

**Terminado cuando:** el linter no reporta ningún hallazgo de nivel `ERROR`.

---

## 🔴 Miércoles 26 — Entrar

### F0-09 · Login de los cuatro roles
- [ ] Cédula `V-`/`E-` → correo interno
- [ ] Middleware por grupo de ruta. **El rol se lee del servidor**
- [ ] Contraseña temporal con cambio obligatorio

### F0-10 · Carnet digital
- [ ] Se ve **en modo avión** una vez cargado

### 📨 Llega la presentación del módulo
- [ ] **Empieza la producción de casos y competencias** (`03_CASOS.md`)

---

## 🔴 Jueves 27 — El QR completo

### F0-11 · Administración muestra
- [ ] QR grande. Muere al usarse y aparece otro al instante
- [ ] Contador en vivo

### F0-12 · El estudiante escanea
- [ ] Asistencia **y refrigerio** en el mismo evento
- [ ] Los tres resultados: verde, amarillo, rojo

### F0-13 · Registro manual **[HACE POSIBLE EL CRITERIO]**
- [ ] Buscar entre los que faltan, marcar presente con motivo
- [ ] Queda registrado que fue manual y quién

---

## 🟡 Viernes 28 — Congelar para el simulacro

- [ ] Cargar una cohorte de prueba con cédulas reales
- [ ] Recorrido completo: estudiante, administración, profesor
- [ ] **No se despliega nada más hoy**

---

## 🎯 Sábado 29 — SIMULACRO TÉCNICO, SIN ESTUDIANTES

**No hay clase real.** La cohorte del 29 es otra, y el piloto será con estudiantes **nuevos**.

Eso cambia lo que este día puede darnos: ya no valida el comportamiento de 24 personas
desconocidas, solo que la máquina funciona. **Hay que exprimirlo al máximo.**

- [ ] **Reunir todos los teléfonos que se puedan** — equipo, familia, quien preste el suyo.
      Mínimo 6, con al menos dos de gama baja y dos marcas distintas
- [ ] **En el taller**, con su luz y su señal reales. No en la oficina
- [ ] Recorrer la fila completa: mostrar el QR · escanear uno tras otro · ver subir el contador
- [ ] Probar los tres resultados a propósito: correcto · repetido · código ya usado
- [ ] **Registro manual cronometrado**: ¿de verdad son menos de 20 segundos?
- [ ] Alguien que **no haya visto la app** intenta usarla sin que nadie le explique
- [ ] **Anotar todo. No arreglar nada en el momento**

**Terminado cuando:** hay una lista escrita de fallos y quedan 6 días para arreglarlos.

> ⚠️ **Este día es también cuando el profesor y administración aprenden su pantalla.**
> Nadie debería estar aprendiéndola el 5 de septiembre.

### El riesgo que este cambio deja abierto

El 5 de septiembre pasa a ser **el primer contacto de la app con estudiantes reales**, y encima
con estudiantes **nuevos** que ese día conocen la academia. No van a llegar con la app
instalada ni sabiendo qué es.

**Mitigación:** ver `01_ENTREGABLE.md` §6.1 — la coreografía del día cambia.

---

## 🔴 Domingo 30 — Arreglar

- [ ] Ordenar los fallos por gravedad
- [ ] Arreglar todo lo que impida operar. Lo cosmético se anota y se deja

> **A partir de aquí, la asistencia no se toca más.** Lo que viene se construye encima.

---

# SEMANA 2 · EL CONTENIDO

## 🟠 Lunes 31 — Material y competencias

### F0-14 · Migración 036 — las tablas del contenido
- [ ] `cases`, `case_attempts`, `student_questions`, `module_competencies`
- [ ] RLS y políticas en la misma migración
- [ ] `npm run test:rls` pasa

### F0-15 · Material
- [ ] Administración sube un PDF y lo asigna al módulo
- [ ] El estudiante lo ve, lo abre y lo descarga
- [ ] **Estado vacío bien resuelto** — los primeros días estará vacío de verdad

### F0-16 · Mi módulo
- [ ] Lista de competencias del módulo. Solo lectura, sin estado

---

## 🟠 Martes 1 — El caso del día

### F0-17 · La pantalla del caso **[LA QUE DEFINE FASE 0]**
- [ ] Los cuatro pasos con barra de progreso
- [ ] **La referencia no se revela sin completar los cuatro**
- [ ] **La calibración de confianza**, los cuatro mensajes
- [ ] Se guarda el intento. **No produce nota**

### F0-18 · La tira de la semana
- [ ] Seis días con su estado. Los futuros con candado, mirables pero no trabajables

---

## 🟠 Miércoles 2 — Dudas

### F0-19 · El estudiante manda su duda
- [ ] **Solo texto libre**, sin lista de temas
- [ ] Dos puertas de entrada: al terminar un caso, y desde el inicio

### F0-20 · Las tres preguntas del profesor
- [ ] Edge Function `resumir-dudas` que llama a la API de Claude
- [ ] Devuelve **3 preguntas** que cubren lo más repetido de la semana
- [ ] **Solo se le mandan los textos al modelo** — nunca nombre ni cédula
- [ ] Debajo, las dudas en crudo
- [ ] **Salida manual:** si la función falla, el profesor ve las dudas en crudo y nada se rompe

### F0-21 · El conteo de casos
- [ ] *«14 de 24 trabajaron el caso»*. **Sin nombres**

### 📨 Los casos aprobados
- [ ] **Fecha límite: hoy.** Profesor y dirección terminaron de revisar

---

## 🟡 Jueves 3 — Instalable y con contenido real

### F0-22 · PWA
- [ ] Manifiesto con los iconos de `marca/`, service worker
- [ ] Se instala en Android. **Probado en tres teléfonos**

### F0-23 · Cargar el contenido real
- [ ] Los casos aprobados, uno por día del 7 al 11
- [ ] Las competencias del módulo
- [ ] Los PDF de material

### F0-24 · Cargar la cohorte
- [ ] Cédulas y fechas de nacimiento. **Solo con los hallazgos ERROR cerrados**
- [ ] Mandar el enlace por WhatsApp

---

## 🔴 Viernes 4 — Congelar

- [ ] **No se despliega nada después de hoy**
- [ ] La lista de verificación completa de `01_ENTREGABLE.md` §7
- [ ] Plan B escrito y conocido por quien vaya a estar

---

## 🎯 Sábado 5 — PILOTO

### La coreografía

| Hora | Qué |
|---|---|
| **7:40 – 8:00** | Llegada. **Registro manual desde el primer minuto** — es la vía principal, no la de respaldo. Ver §6.1 de `01_ENTREGABLE.md` |
| **8:00** | El profesor ve cuántos llegaron |
| **~8:30** | Se presenta la app al grupo: se reparten las claves, se instala, se recorre |
| **~9:00** | **Ahora sí, el QR.** Con la app ya instalada, cada uno escanea. Es una demostración, no el registro |
| **Durante la clase** | Se les muestra el material, el caso del lunes y cómo mandar una duda |
| **Al terminar** | Contar presentes contra filas en la tabla. **Anotar todo lo que falló** |

- [ ] Alguien del equipo presente, con acceso a la base
- [ ] Lista impresa de la cohorte, por si acaso
- [ ] **Las claves temporales impresas y recortadas**, una por estudiante

---

## 2. RESUMEN DE RIESGOS

| Riesgo | Cuándo se sabe | Plan B |
|---|---|---|
| **La cámara no lee en el taller** | **Lunes 24** | Código de 6 dígitos en la pizarra |
| Hallazgos de seguridad sin cerrar | Martes 25 | No se cargan datos reales hasta cerrarlos |
| **No llega la presentación del módulo** | **Miércoles 26** | Se cae el contenido. Queda asistencia + material |
| **Estudiantes nuevos sin la app el día 5** | Se sabe de antemano | Registro manual primero, instalación después. Ver `01_ENTREGABLE.md` §6.1 |
| Falla algo en el ensayo | **Sábado 29** | Quedan 6 días |
| Los casos no se revisan a tiempo | Miércoles 2 | Se publican menos días |
| No se instala en gama media | Jueves 3 | Funciona igual desde el navegador |
| Llegan sin la app instalada | Viernes 4 | Registro manual |

**Los tres primeros se descubren en los tres primeros días.** Ese es el propósito de ponerlos
al principio.

---

## 3. LO QUE NO SE MUEVE

Pase lo que pase con el calendario:

1. **La prueba en teléfono real, en el taller.** Si algo se atrasa, se recorta alcance.
2. **El registro manual.** Sin él vuelve el papel.
3. **No se carga una cédula real con un hallazgo `ERROR` abierto.** Son menores de edad.
4. **El sábado no se arregla nada.** Se anota; el domingo se ordena; el lunes se arregla.
