# 02 · SPRINT AL 5 DE SEPTIEMBRE
> 15 días. Del jueves 21 de agosto al sábado 5 de septiembre de 2026.
> Cada tarea tiene un criterio de terminado. Si no se cumple, la tarea no está lista.

---

## CÓMO LEER ESTE PLAN

- **Los días con 🔴 son irrecuperables.** Si se atrasan, se atrasa la entrega.
- **Los días con 🟡 tienen colchón.** Se pueden comprimir.
- Las tareas marcadas **[RIESGO]** son las que más caro salen si fallan tarde.

**Regla del sprint:** si algo se atrasa, se recorta alcance — nunca se recorta la prueba en
teléfono real.

> ⚠️ **El alcance lo define `06_ENTREGABLE.md`.** Si una tarea de aquí no sirve a algo de
> ese documento, no va. La evaluación práctica **sale del MVP**: el 5 de septiembre es la
> primera clase y no hay nada que evaluar.

---

# SEMANA 1 — CIMIENTOS Y EL SÁBADO

## 🔴 Jueves 21 — Riesgos primero

### T-01 · Probar la cámara **[RIESGO MÁXIMO]**
Página mínima desplegada en HTTPS que abra la cámara y lea un QR.

- [ ] Página de prueba con `@zxing/browser`
- [ ] Desplegada en Vercel — HTTPS es obligatorio para la cámara
- [ ] Probada con **al menos tres teléfonos distintos**, uno de gama baja
- [ ] Probada **en el taller**, con su luz real, no en una oficina

**Terminado cuando:** tres teléfonos leen un QR impreso y uno en pantalla, en menos de 3
segundos, en el taller.

**Si falla:** parar y replantear la asistencia antes de construir nada más. Alternativas:
código numérico de 6 dígitos, NFC, o lista manual del profesor.

### T-02 · Confirmar que nadie más toca `zr-prod`
- [ ] Preguntar al equipo si hay otra sesión o agente trabajando
- [ ] Si lo hay, coordinar antes de migrar

### T-03 · Volcar el esquema real al repositorio
- [ ] Exportar el esquema de `zr-prod`
- [ ] Guardar como `supabase/migrations/000_esquema_base.sql`
- [ ] Mover las migraciones 001 a 016 a `_archivo/migraciones-superadas/`
- [ ] Corregir `CLAUDE.md`: ya no son 16 migraciones aplicadas

**Terminado cuando:** el repositorio refleja lo que está vivo.

---

## 🔴 Viernes 22 — La base queda lista

### T-04 · Migración: QR de un solo uso
- [ ] Tabla `qr_codes` con `used` y `used_at`
- [ ] Retirar `attendance.qr_window_seconds` y `attendance.qr_drift_tolerance`
- [ ] Añadir `qr.un_solo_uso = true`
- [ ] Adaptar la Edge Function `validate-scan` al modelo nuevo

### T-05 · Migración: diagnóstico de entrada
- [ ] Tabla `entry_diagnostics` según `05_DIAGNOSTICO.md` §5
- [ ] RLS: el estudiante solo el suyo · el profesor los de su cohorte · dirección todos
- [ ] Vista `v_diagnostico_cohorte` con los agregados
- [ ] Las pruebas de aislamiento pasan

### T-06 · Cerrar los hallazgos de seguridad **[RIESGO]**
- [ ] Quitar `SECURITY DEFINER` de las 3 vistas, o justificar cada una por escrito
- [ ] Escribir política para `student_qr_secrets`
- [ ] Revocar ejecución anónima de las funciones que no la necesiten
- [ ] Fijar `search_path` en las 11 funciones
- [ ] Activar protección de contraseñas filtradas

**Terminado cuando:** la revisión de seguridad no reporta ningún error de nivel ERROR.

---

## 🔴 Sábado 23 — La aplicación existe

### T-07 · Proyecto Next.js
- [ ] Crear el proyecto con TypeScript y Tailwind 4
- [ ] Tokens de `spec/06` en los estilos globales
- [ ] Roboto y Raleway instaladas localmente, **nunca desde un CDN**
- [ ] Cliente de Supabase, navegador y servidor
- [ ] Mover `lib/` al proyecto
- [ ] Generar los tipos desde la base

### T-08 · Entrar con cédula
- [ ] Pantalla de entrada con el formato `V-12345678`
- [ ] Conversión de cédula a correo interno
- [ ] Middleware que protege las rutas por rol
- [ ] Redirección: estudiante al carnet, profesor a hoy, administración al panel
- [ ] Contraseña temporal con cambio obligatorio al primer ingreso

**Terminado cuando:** los tres roles entran y cada uno cae donde le toca. En un teléfono.

---

## 🟡 Domingo 24 — Colchón

Sin tareas asignadas. Si la semana va al día, adelantar T-09.

---

## 🔴 Lunes 25 — El QR completo

### T-09 · Administración muestra el código
- [ ] Pantalla que genera y muestra el QR en grande
- [ ] Al escanearse, el código muere y aparece otro al instante
- [ ] Contador de escaneados en vivo

### T-10 · El estudiante escanea
- [ ] Pantalla de cámara con `@zxing/browser`
- [ ] Permiso de cámara con explicación previa, no a secas
- [ ] Confirmación grande, legible a un metro
- [ ] Marca asistencia **y refrigerio** en el mismo evento
- [ ] Errores claros: código ya usado, no es de tu cohorte, sesión cerrada

**Terminado cuando:** un estudiante escanea desde su teléfono y administración ve subir el
contador, con ambos dispositivos en el taller.

### T-10b · Registro manual **[HACE POSIBLE EL CRITERIO DE ÉXITO]**
Sin esto, un teléfono que falla termina en un papel — y el criterio de éxito es cero papel.

- [ ] Administración busca al estudiante en la lista de quienes faltan
- [ ] Lo marca presente con un motivo: sin batería · cámara falla · no instaló la app · otro
- [ ] Queda registrado que fue manual y quién lo hizo
- [ ] Marca asistencia **y refrigerio**, igual que el escaneo

**Terminado cuando:** un estudiante sin teléfono queda registrado en la app en menos de 20
segundos.

---

## 🔴 Martes 26 — Carnet

### T-11 · Carnet digital
- [ ] Nombre, cédula, programa, código, sede y turno
- [ ] Foto si existe
- [ ] Se ve sin internet una vez cargado

**Terminado cuando:** un estudiante lo abre en modo avión y lo ve completo.

---

## 🟡 Miércoles 27 — Colchón

Arreglar lo que salga del QR y el carnet. Si sobra tiempo, adelantar T-12.

---

# SEMANA 2 — DIAGNÓSTICO Y ENSAYO

## 🔴 Jueves 28 — Diagnóstico de entrada

### T-12 · Pantalla del diagnóstico
- [ ] Los tres bloques, entre 8 y 10 preguntas, casi todo a toques
- [ ] Se responde una sola vez y se puede saltar
- [ ] **Devuelve un mensaje al terminar** — `05_DIAGNOSTICO.md` §3.3
- [ ] Aviso discreto en el inicio si lo saltó

**Terminado cuando:** tres personas distintas lo completan en un teléfono en menos de 3
minutos y las tres entienden el mensaje final.

---

## 🔴 Viernes 29 — El profesor

### T-13 · Panel del profesor
- [ ] Asistentes en vivo
- [ ] **El retrato del grupo** que sale del diagnóstico — `05_DIAGNOSTICO.md` §4
- [ ] Lo que más les preocupa, agregado por frecuencia
- [ ] Las respuestas abiertas **no se proyectan** ni se muestran atribuidas

### T-13b · El profesor abre el diagnóstico
El diagnóstico no está disponible hasta que él lo abre. Ver `06_ENTREGABLE.md` §4.

- [ ] Botón «Abrir el diagnóstico» en el panel del profesor
- [ ] El estado vive en la sesión de clase, no en la configuración global
- [ ] Al abrirlo, **le aparece a los estudiantes sin recargar** (tiempo real)
- [ ] El profesor ve el contador llenarse: «14 de 24 respondieron»
- [ ] Lo puede cerrar

**Terminado cuando:** el profesor abre desde un teléfono y a otro teléfono le aparece el
diagnóstico en menos de 5 segundos, sin tocar nada.

---

## 🔴 Sábado 30 — PRUEBA EN CLASE REAL

### T-14 · Piloto de ensayo **[LA FECHA MÁS IMPORTANTE DEL PLAN]**
Con la clase real de ese sábado.

- [ ] Los estudiantes escanean con sus propios teléfonos
- [ ] Al menos 5 completan el diagnóstico
- [ ] Anotar **todo** lo que falle, sin arreglar nada en el momento
- [ ] Preguntarle a 5 estudiantes qué no entendieron

**Terminado cuando:** hay una lista escrita de fallos y quedan 6 días para arreglarlos.

**Sin esta fecha, el 5 de septiembre es a ciegas.**

> El ensayo sirve también para que **el profesor y administración usen la app antes del día**.
> Nadie debería estar aprendiendo su pantalla el 5 de septiembre.

---

## 🔴 Domingo 31 y Lunes 1 — Arreglar

### T-15 · Corregir lo del ensayo
- [ ] Ordenar los fallos por gravedad
- [ ] Arreglar todo lo que impida operar
- [ ] Lo cosmético se anota y se deja para después

---

## 🟠 Martes 2 — El caso del día

### T-16 · Caso sintético
- [ ] Los cuatro pasos: hipótesis, medición, razonamiento y confianza
- [ ] La referencia **no se revela** sin completar los pasos
- [ ] Devolverle la calibración de su confianza — `spec/00` §5.5.1
- [ ] Se abre el día que le toca

### T-17 · Contenido de la primera semana **[RIESGO DE CONTENIDO]**
- [ ] **Cinco casos escritos y revisados**, uno por día del 7 al 11 de septiembre
- [ ] **Medir cuánto tomó escribirlos** — ese dato decide el modelo, ver `00_LEEME.md`

---

## 🟡 Miércoles 3 — Instalable

### T-18 · PWA
- [ ] Manifiesto con los iconos de `marca/`
- [ ] Service worker con Serwist
- [ ] Se instala en Android desde el navegador
- [ ] Probado en tres teléfonos

### T-18b · El botón del sitio web
- [ ] Coordinar con quien administre zrmecademy.com
- [ ] Renombrar `Sign in` a **Aula Virtual**
- [ ] Apuntarlo a la app
- [ ] Probar desde un teléfono: debe abrir la app instalada, no el navegador

**Depende de terceros.** Si quien administra el sitio no responde esta semana, se avisa y se
entrega con enlace directo.

---

## 🔴 Jueves 4 — Congelar

### T-19 · Datos reales
- [ ] Cargar la cohorte: estudiantes con cédula, fecha de nacimiento y correo
- [ ] Contraseñas temporales con cambio obligatorio
- [ ] Cargar el profesor
- [ ] Verificar el aislamiento: el estudiante A no ve nada de B

### T-19b · Repartir la app antes del sábado **[RIESGO]**
- [ ] Mandar el enlace por WhatsApp a la cohorte, **lunes 1 a más tardar**
- [ ] Instrucción de una línea de cómo instalarla
- [ ] Confirmar que al menos 20 de 24 la instalaron antes del viernes

⚠️ **No dejar la instalación para el mismo día.** 24 teléfonos descargando a la vez con la
señal del taller es un riesgo evitable.

### T-20 · Congelar
- [ ] **No se despliega nada más después de este día**
- [ ] Recorrido completo de los tres roles
- [ ] Plan B escrito por si falla el escaneo el sábado

---

## 🎯 Sábado 5 — PILOTO

- [ ] Alguien del equipo presente, con acceso a la base
- [ ] Lista impresa de la cohorte, por si acaso
- [ ] Anotar todo lo que pase

---

# LO QUE SIGUE DESPUÉS DEL 5

En este orden. Nada de esto entra al sprint.

**Semana del 7** — el ciclo semanal completo · materiales.

**Cuando ya haya qué evaluar** — evaluación práctica con checklist y defensa · notas y
progreso · el detalle de qué falló.

**Cuando el sábado funcione solo** — exámenes con cronómetro · «Antes de la clase» · dudas.

**Cuando haya varias cohortes** — currículo y competencias · asignación de módulos y
profesores · historial · pantalla de configuración.

**Cuando el contenido sea el cuello de botella** — los asistentes de IA.

---

# RESUMEN DE RIESGOS

| Riesgo | Cuándo se sabe | Plan B |
|---|---|---|
| La cámara no lee en el taller | **Jueves 21** | Código de 6 dígitos en la pizarra |
| Hallazgos de seguridad sin cerrar | **Viernes 22** | No se cargan datos reales hasta cerrarlos |
| Falla algo en el ensayo | **Sábado 30** | Quedan 6 días para arreglar |
| No hay contenido para la primera semana | **Martes 2** | Publicar 2 casos y completar durante la semana |
| La app no se instala en gama media | **Miércoles 3** | Funciona igual desde el navegador, sin instalar |
| Se cae internet en el taller | El día | Administración anota en su teléfono y carga al recuperar señal |
| Llegan sin la app instalada | **Viernes 4** | Registro manual por administración |
| El sitio web no se puede tocar | **Miércoles 3** | Se entrega con enlace directo por WhatsApp |

**Los cuatro primeros se descubren con tiempo si se respetan las fechas.** Ese es el propósito
de ponerlos al principio.
