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

---

# SEMANA 1 — CIMIENTOS Y EL SÁBADO

## 🔴 Jueves 21 — Riesgos primero

### T-01 · Probar la cámara **[RIESGO MÁXIMO]**
Página mínima desplegada en HTTPS que abra la cámara y lea un QR.

- [ ] Página de prueba con `@zxing/browser`
- [ ] Desplegada en Vercel (HTTPS es obligatorio para la cámara)
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
- [ ] Mover `001`-`016` a `_archivo/migraciones-superadas/`
- [ ] Actualizar `CLAUDE.md`: ya no son 16 migraciones aplicadas

**Terminado cuando:** el repositorio refleja lo que está vivo.

---

## 🔴 Viernes 22 — La base queda lista

### T-04 · Migración: tablas de evaluación práctica
Copiar de la 015 **solo las tablas**, con umbrales de `spec/00` §2.4.1.

- [ ] `rubric_templates`, `rubric_criteria` (con `is_critical`)
- [ ] `performance_evaluations`, `eval_criteria_results`
- [ ] `defense_questions`, `technical_defenses`
- [ ] RLS habilitada y políticas escritas en todas
- [ ] Sin el trigger de rúbrica 100/81. La nota se calcula 0-20

**Terminado cuando:** se puede insertar una evaluación completa y `npm run test:rls` pasa.

### T-05 · Migración: QR de un solo uso
- [ ] Tabla `qr_codes` con `used` y `used_at`
- [ ] Retirar `attendance.qr_window_seconds` y `qr_drift_tolerance` de `system_config`
- [ ] Añadir `qr.un_solo_uso = true`
- [ ] Adaptar `validate-scan` al modelo nuevo

### T-06 · Cerrar los hallazgos de seguridad **[RIESGO]**
- [ ] Quitar `SECURITY DEFINER` de las 3 vistas o justificar cada una por escrito
- [ ] Política para `student_qr_secrets`
- [ ] Revocar ejecución anónima de las funciones que no la necesiten
- [ ] Fijar `search_path` en las 11 funciones
- [ ] Activar protección de contraseñas filtradas

**Terminado cuando:** la revisión de seguridad no reporta ningún error de nivel ERROR.

---

## 🔴 Sábado 23 — La aplicación existe

### T-07 · Proyecto Next.js
- [ ] `create-next-app` con TypeScript y Tailwind 4
- [ ] Tokens de `spec/06` en `globals.css`
- [ ] Roboto y Raleway instaladas localmente (`@fontsource-variable`), **nunca desde CDN**
- [ ] Cliente de Supabase, navegador y servidor
- [ ] Mover `lib/` al proyecto
- [ ] Generar tipos desde la base

### T-08 · Entrar con cédula
- [ ] `/login` con el formato `V-12345678`
- [ ] Conversión cédula → correo interno
- [ ] `middleware.ts` que protege por rol
- [ ] Redirección: estudiante → carnet, profesor → hoy, admin → panel

**Terminado cuando:** los cuatro roles entran y cada uno cae donde le toca. En un teléfono.

---

## 🟡 Domingo 24 — Colchón o adelanto

Sin tareas asignadas. Si la semana va al día, adelantar T-09.

---

## 🔴 Lunes 25 — El QR completo

### T-09 · Administración muestra el código
- [ ] Pantalla que genera y muestra el QR en grande
- [ ] Al escanearse, el código muere y aparece otro
- [ ] Contador de escaneados en vivo (Realtime)

### T-10 · El estudiante escanea
- [ ] Pantalla de cámara con `@zxing/browser`
- [ ] Permiso de cámara con explicación previa, no a secas
- [ ] Confirmación grande y legible a un metro
- [ ] Marca asistencia **y refrigerio** en el mismo evento
- [ ] Errores claros: código usado, no es de tu cohorte, sesión cerrada

**Terminado cuando:** un estudiante escanea desde su teléfono y el profesor ve subir el
contador, con ambos dispositivos en el taller.

---

## 🔴 Martes 26 — La evaluación del sábado

### T-11 · Evaluar la práctica
Seguir el prototipo, pantalla «Evaluar práctica».

- [ ] Una sola pantalla, la ficha se abre en el sitio
- [ ] Checklist de tres estados: sin evaluar → cumple → no cumple
- [ ] **No mostrar nota hasta que no falte nada por evaluar**
- [ ] 3 preguntas sorteadas de un banco de 10, con opción de volver a sortear
- [ ] Cálculo 70/30 sobre 20
- [ ] Ítem crítico: alerta, **nunca tope de nota**
- [ ] No permite guardar incompleta

**Terminado cuando:** un profesor evalúa a 3 estudiantes seguidos en un teléfono sin
equivocarse de fila.

### T-12 · Medir cuánto tarde **[RIESGO]**
- [ ] Cronometrar la evaluación de 5 estudiantes reales
- [ ] Extrapolar al tamaño del grupo

**Si pasa de 5 minutos por estudiante, hay que replantear la evaluación** antes del piloto.

---

## 🟡 Miércoles 27 — Colchón

Arreglar lo que salga de T-11 y T-12. Si sobra tiempo, adelantar T-13.

---

# SEMANA 2 — EL ESTUDIANTE

## 🔴 Jueves 28 — Carnet y notas

### T-13 · Carnet digital
- [ ] Nombre, cédula, programa, código, sede y turno
- [ ] Foto si existe
- [ ] Se ve sin internet una vez cargado

### T-14 · Progreso y notas
- [ ] Promedio del módulo con la cuenta a la vista
- [ ] Mapa de competencias con sus estados
- [ ] **Detalle de la práctica: qué falló y por qué** (`spec/00` §5.4)
- [ ] Participación visible

---

## 🔴 Viernes 29 — La semana del estudiante

### T-15 · Inicio adaptativo y ciclo semanal
- [ ] El inicio muestra lo que toca **hoy**
- [ ] Los seis días con su estado
- [ ] Se desbloquea día a día (`spec/00` §4.0)

### T-16 · Caso sintético
- [ ] Los cuatro pasos: hipótesis, medición, razonamiento, confianza
- [ ] La referencia **no se revela** sin completar los pasos
- [ ] Devolverle la calibración de su confianza (`spec/00` §5.5.1)

---

## 🔴 Sábado 30 — PRUEBA EN CLASE REAL

### T-17 · Piloto de ensayo **[LA FECHA MÁS IMPORTANTE DEL PLAN]**
Con la clase real de ese sábado.

- [ ] Estudiantes escanean con sus propios teléfonos
- [ ] El profesor evalúa a un grupo pequeño
- [ ] Anotar **todo** lo que falle, sin arreglar nada en el momento
- [ ] Preguntarle a 5 estudiantes qué no entendieron

**Terminado cuando:** hay una lista escrita de fallos y quedan 6 días para arreglarlos.

**Sin esta fecha, el 5 de septiembre es a ciegas.**

---

## 🔴 Domingo 31 y Lunes 1 — Arreglar

### T-18 · Corregir lo del ensayo
- [ ] Ordenar los fallos por gravedad
- [ ] Arreglar todo lo que impida operar
- [ ] Lo cosmético se anota y se deja

---

## 🟡 Martes 2 — Materiales y exámenes

### T-19 · Materiales
- [ ] Agrupados por semana, desde Supabase Storage
- [ ] Se pueden abrir y descargar

### T-20 · Examen
- [ ] Pregunta por pregunta con cronómetro
- [ ] Al agotarse el tiempo entrega lo respondido
- [ ] Revisión con la respuesta correcta y por qué

---

## 🟡 Miércoles 3 — Instalable

### T-21 · PWA
- [ ] `manifest.json` con los iconos de `marca/`
- [ ] Service worker con Serwist
- [ ] Se instala en Android desde el navegador
- [ ] Probado en tres teléfonos

---

## 🔴 Jueves 4 — Congelar

### T-22 · Datos reales
- [ ] Cargar la cohorte del piloto: estudiantes con cédula y correo
- [ ] Cargar el profesor
- [ ] Cargar el módulo con sus competencias y su checklist
- [ ] Verificar el aislamiento: el estudiante A no ve nada de B

### T-23 · Congelar
- [ ] **No se despliega nada más después de este día**
- [ ] Recorrido completo de los cuatro roles
- [ ] Plan B escrito por si falla el escaneo el sábado

---

## 🎯 Sábado 5 — PILOTO

- [ ] Alguien del equipo presente con acceso a la base
- [ ] Lista impresa de la cohorte, por si acaso
- [ ] Anotar todo lo que pase

---

# RESUMEN DE RIESGOS

| Riesgo | Cuándo se sabe | Plan B |
|---|---|---|
| La cámara no lee en el taller | **Jueves 21** | Código de 6 dígitos escrito en la pizarra |
| El profesor no alcanza a evaluar a todos | **Martes 26** | Evaluar la mitad del grupo por sábado, rotando |
| Falla algo en el ensayo | **Sábado 30** | 6 días para arreglar |
| No hay contenido real del módulo | Ver `03_DATOS.md` | Cargar solo la primera semana |
| Se cae internet en el taller | El día | Lista impresa y carga manual el lunes |

**Los tres primeros se descubren con tiempo si se respetan las fechas.** Ese es el propósito
de ponerlos al principio.
