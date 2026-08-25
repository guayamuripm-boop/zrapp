# FASE 1 · EMPIEZA AQUÍ

> ## ⛔ NO ABRAS ESTA CARPETA HASTA QUE FASE 0 ESTÉ ENTREGADA
>
> El 5 de septiembre de 2026 hay una clase real con estudiantes reales. Todo lo de aquí es
> **después**. Construir Fase 1 en paralelo es la forma más segura de no entregar ninguna de
> las dos.

---

## 1. QUÉ ES FASE 1

**El producto completo del prototipo `ZR_APP_PROTOTIPO_v10.html`**: 31 pantallas, cuatro roles,
con notas, exámenes, evaluación práctica y el panel de dirección.

Fase 0 sacó todo lo que produce una calificación. **Fase 1 lo mete.**

| | Fase 0 | Fase 1 |
|---|---|---|
| Asistencia y refrigerio | ✅ | ✅ |
| Material y casos diarios | ✅ | ✅ |
| Dudas | ✅ | ✅ |
| Competencias | Lista, sin estado | **Con estado de dominio** |
| **Exámenes con cronómetro** | ❌ | ✅ |
| **Evaluación práctica** | ❌ | ✅ |
| **Defensa técnica** | ❌ | ✅ |
| **Notas y progreso** | ❌ | ✅ |
| **Panel de dirección** | ❌ | ✅ |
| **Consentimiento parental** | ❌ | ✅ |

---

## 2. LO PRIMERO: EL PROTOTIPO v10

**`ZR_APP_PROTOTIPO_v10.html`**, en la raíz. 4.404 líneas, 12 vistas, 31 paneles.
**Es la especificación, no una referencia.**

Cédulas para entrar:

| Cédula | Rol |
|---|---|
| `V-30000001` | Estudiante que va aprobando |
| `V-30000003` | Estudiante **en riesgo** — para ver los estados rojos |
| `V-10000003` | Profesor |
| `V-10000005` | Administración |
| `V-10000004` | Dirección |

---

## 3. QUÉ HAY EN ESTA CARPETA

| Archivo | Qué |
|---|---|
| `00_EMPIEZA_AQUI.md` | Este |
| `01_QUE_FALTA.md` | El delta exacto entre lo que deja Fase 0 y el v10 completo |
| `02_ORDEN.md` | Los épicos en orden, con sus dependencias y su criterio |

Y en la raíz del repositorio:

| Documento | Responde |
|---|---|
| `spec/04_PANTALLAS.md` | Las 31 pantallas, ruta por ruta |
| `spec/00_RECONCILIACION.md` | **Las reglas de negocio. Manda sobre todo** |
| `plan/07_ALCANCE_V10.md` | El inventario completo en tres niveles |
| `metodologia/01_MODELO.md` | Por qué se evalúa así |

---

## 4. LAS CUATRO REGLAS QUE FASE 1 AÑADE

Fase 0 no las necesitaba porque no había notas. **Aquí sí, y son las que más caro salen.**

### 4.1 Ningún cálculo de nota en el navegador
La nota práctica, la del módulo y la corrección de exámenes viven en Edge Functions.
El cliente **muestra** resultados, nunca los calcula.

Si te encuentras escribiendo un `if` con un umbral dentro de un componente, está en el lugar
equivocado.

### 4.2 El estudiante nunca recibe `correct_answer`
Se lee de la vista `v_exam_questions_student`, que no tiene esa columna.

⚠️ Hoy esa vista tiene un hallazgo de nivel `ERROR` (`SECURITY DEFINER`) que puede estar
saltándose el aislamiento que la justifica. **Se cierra en Fase 0, tarea F0-08.**

### 4.3 El ítem crítico **avisa, no topa la nota**
Fallar un paso crítico marca la evaluación como *requiere refuerzo* y **alerta al profesor**.
No baja la calificación.

> Los documentos archivados en `_archivo/` dicen lo contrario, con una rúbrica sobre 100 y
> aprobación en 81. **Eso se descartó** — `spec/00` §2.4. No los sigas.

### 4.4 El profesor nunca ve el feedback individual
Solo el promedio del grupo, y **solo con 3 o más respuestas**. Si viera quién dijo qué, nadie
diría la verdad.

---

## 5. LO QUE ESTÁ PROHIBIDO CONSTRUIR, TAMBIÉN EN FASE 1

| No se construye | Por qué |
|---|---|
| Reprobación automática por inasistencia | **Prohibida** por la academia |
| Bloqueo de acceso a aulas o talleres | **Prohibido** por normativa del Ministerio |
| Mensajería privada entre usuarios | **Prohibida** por seguridad de menores |
| Compuerta que bloquee el sábado | Descartada: es señal, no bloqueo |
| Pagos, cuotas, saldos | Fase 2 |
| Puntos, insignias, rachas, ranking | Fase 2 |
| Video de estudiantes, portafolio público | Fase 3 |
| Google Classroom | Descartado, no se hace nunca |

Las tablas de Fase 2 y 3 **no se crean todavía**. Nada «por si acaso».

---

## 6. ANTES DE EMPEZAR FASE 1, RECOGE EL PILOTO

No se arranca sin esto. Sale de `INGENIERIA.md` §8.3:

1. **El número:** cuántos presentes contra cuántos registrados el 5 de septiembre
2. **La lista de fallos**, con lo arreglado y lo pendiente
3. **Qué dijeron cinco estudiantes** a los que se les pregunte qué no entendieron
4. **Cuánto tardó montar la primera semana de contenido**, cronometrado

> El punto 4 decide si hace falta automatizar la generación de casos.
> `metodologia/03_PRODUCCION.md` §1.1 estima 3-4 horas por semana en régimen: **hay que
> confirmarlo midiendo, no recordando.**

---

## 7. LAS DECISIONES QUE SIGUEN ABIERTAS

**No las resuelvas inventando.** Están en `01_QUE_FALTA.md` §5.

La más importante: **el currículo real.** Los 13 módulos que hay hoy en la base tienen nombres
inventados, y no existe un listado formal de competencias. Fase 1 entera cuelga de eso.
