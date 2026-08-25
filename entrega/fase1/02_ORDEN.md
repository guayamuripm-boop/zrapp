# 02 · EL ORDEN DE CONSTRUCCIÓN

> Ocho épicos. **El orden no es negociable: cada uno depende del anterior.**
>
> Un épico se cierra cuando **su pantalla funciona de punta a punta en un teléfono**,
> no cuando «está el backend».

---

## 0. LA REGLA QUE ORDENA TODO

> **Se entrega en trozos que funcionan.** Nunca «el backend de todo» y después «el frontend de
> todo». Una pantalla completa que sirve vale más que diez a medias.

Y una segunda, propia de esta fase:

> **Nada que produzca una nota se construye sin su prueba de aislamiento.** Una calificación
> visible para quien no debe verla es una fuga de datos de un menor de edad.

---

## ÉPICO A · RECOGER EL PILOTO
**Antes de escribir una línea.** Ver `00_EMPIEZA_AQUI.md` §6.

**Terminado cuando:** están escritos el número, la lista de fallos, lo que dijeron cinco
estudiantes, y **cuánto tardó montar la semana de contenido**.

---

## ÉPICO B · EL CURRÍCULO REAL 🔴 **BLOQUEA CASI TODO**
No es programación: es que la academia defina sus módulos y sus competencias.

Los 13 módulos que hay en la base tienen **nombres inventados**. Sin currículo real no hay
competencias; sin competencias no hay mapa de dominio; sin mapa de dominio la pantalla de
progreso queda vacía.

**Terminado cuando:** `modules` y `module_competencies` tienen el contenido real, revisado por
dirección académica.

---

## ÉPICO C · EL CICLO SEMANAL COMPLETO
Lo que Fase 0 dejó simplificado: en Fase 0 todos los días son «el caso». Aquí cada día tiene su
tipo — guía, caso sintético, caso real, dudas, diagnóstica.

- La tira de seis días con su etiqueta por día
- Calendario mensual y «Próximo sábado»
- `weekly_activities` y `activity_completions` — **solo registro, sin efecto vinculante**

**Terminado cuando:** un estudiante abre la app un miércoles y sabe qué le toca ese día, y es
distinto de lo del martes.

> ⚠️ La compuerta sigue siendo **señal, no bloqueo**. Los días futuros se miran, no se trabajan.
> Nadie se queda fuera del taller por no haber abierto la app.

---

## ÉPICO D · EXÁMENES
La primera cosa que produce una nota. Por eso va antes que la evaluación práctica: es más
sencilla y obliga a montar bien el aislamiento.

- Cronómetro desde `exams.duration_minutes`, avisos a 5 min y 1 min, entrega automática
- Una pregunta por pantalla, sin avanzar sin responder
- **Corrección en `submit-attempt`**, nunca en el navegador
- El cliente lee de `v_exam_questions_student` — **jamás recibe `correct_answer`**
- **La revisión al terminar:** qué respondió, qué era, dónde repasar
- Diagnóstica del viernes sin peso; examen del módulo al 50%
- Constructor de exámenes del profesor

**Terminado cuando:** un estudiante presenta un examen completo, se le corrige solo, ve su
revisión, y **la pestaña de red confirma que nunca le llegó la respuesta correcta antes de
entregar**.

---

## ÉPICO E · EVALUACIÓN PRÁCTICA
El sábado, con el profesor y el estudiante delante.

- **Toda la evaluación en UNA sola pantalla.** Sin navegar, sin perder lo hecho
- Checklist a toques, con los ítems marcados `CRÍTICO`
- Defensa técnica: cada pregunta con nivel de 1 a 4
- Comentario del profesor
- Nota = `checklist × 70% + defensa × 30%`, sobre 20, **calculada en el servidor**
- **El ítem crítico alerta, no topa la nota**

Tablas de la 015, **con los umbrales de `system_config`, no los de la 015**.

**Terminado cuando:** el profesor evalúa a un estudiante completo **en el taller, de pie, con
una mano**, sin salir de la pantalla.

---

## ÉPICO F · PROGRESO Y NOTAS
Lo que el estudiante gana de los dos épicos anteriores.

- Promedio del módulo con el mensaje explícito de si va aprobando
- Mapa de competencias con sus cuatro estados
- Desglose con la cuenta escrita: `16 × 50% + 15 × 50% = 15,5`
- **«Ver qué falló y por qué»** — paso por paso, con la frase concreta y a qué guía ir

**Sin puntos, sin niveles, sin insignias, sin comparación entre estudiantes.**

**Terminado cuando:** un estudiante que reprobó una competencia **sabe qué leer para
arreglarlo**. Ese es el criterio, no que se vea la nota.

---

## ÉPICO G · PANELES DEL PROFESOR
- Antes de la clase: dónde falla el grupo
- Alumnos: tabla de notas con filas expandibles
- Reportes: distribución del módulo
- **Feedback anónimo: promedio del grupo, solo con 3 o más respuestas, nunca individual**

**Terminado cuando:** con 2 respuestas el feedback **no se muestra**, y con 3 sí. Probado.

---

## ÉPICO H · DIRECCIÓN
Las diez pantallas. **La operación y la vigilancia van separadas** (`spec/00` §5.7).

- Currículo con sus competencias · programas y grupos · notas por módulo
- Activar feedback por programa
- Salud del sistema, **con los ocho indicadores** de `metodologia/02_MEDICION.md`
- **El correo automático de los lunes** a coordinación
- Aprobar o rechazar los borradores de contenido del profesor

**Terminado cuando:** dirección abre el feedback de un módulo desde su teléfono y al profesor
le aparece.

---

## ÉPICO I · CONSENTIMIENTOS Y CIERRE
- **Consentimiento parental LOPNNA** para menores de 18: subir documento, verificar, recordar
- Registro propio del estudiante en dos pasos
- Escaneo **sin conexión**, con sincronización idempotente
- Notificaciones push

**Terminado cuando:** un menor de edad no puede quedar activo sin consentimiento verificado.

---

## RESUMEN DE DEPENDENCIAS

```
A · Recoger el piloto
      ↓
B · Currículo real  🔴 sin esto no arranca casi nada
      ↓
C · Ciclo semanal ───┐
      ↓              │
D · Exámenes         │
      ↓              │
E · Evaluación práctica
      ↓
F · Progreso y notas   ← necesita D y E
      ↓
G · Paneles del profesor
      ↓
H · Dirección
      ↓
I · Consentimientos y cierre
```

---

## CÓMO SE SABE QUE UN ÉPICO ESTÁ TERMINADO

Las ocho condiciones de `INGENIERIA.md` §9.2, más una propia de Fase 1:

> **9. Existe una prueba de aislamiento que demuestra que el estudiante A no puede ver la nota
> del estudiante B.** No basta con que la pantalla no la muestre.
