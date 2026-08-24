# 03 · PRODUCCIÓN DE CONTENIDO — CUÁNTO CUESTA Y CÓMO SE MONTA

> El contenido es el cuello de botella real de este modelo, no el software.
> La app se termina una vez; el contenido hay que producirlo **todas las semanas**.

---

## 1. EL PRESUPUESTO DE HORAS

Sale de los documentos originales del MDV, medido sobre el montaje real de la semana 1.

| Tarea | Primera vez | En régimen |
|---|---|---|
| **Una semana completa de un módulo** | 8-10 h | **3-4 h** |
| Un módulo entero de 4 semanas | 30-40 h | 12-16 h |
| Una especialidad nueva (industrial, petrolera) | — | 1 jornada por módulo |

**Estas horas van dentro de la carga docente contratada.** Es la condición que dirección ya
aprobó y la que sostiene todo el proyecto. Si el profesor tiene que montar la semana fuera de
su horario, el modelo se cae en la tercera semana.

### 1.1 Por qué este número decide si hace falta la IA

`plan/07` §7 tiene esta pregunta abierta: *«¿Cuánto tarda una persona en escribir un caso? Ese
número decide si la IA hace falta.»*

**Ya hay una respuesta estimada: 3-4 horas por semana, en régimen.** Lo que falta es
**confirmarla midiendo la primera semana real**, la del 7 de septiembre.

| Si la medición da | Entonces |
|---|---|
| **3-4 h** | La IA generadora es una comodidad, no una necesidad. Va al final de la cola |
| **6 h o más** | La IA generadora sube de prioridad: el modelo no se sostiene a mano |
| **Menos de 3 h** | No se construye. El profesor va más rápido escribiendo que corrigiendo un borrador |

> **Hay que cronometrarlo. No estimarlo de memoria después.** Quien monte la semana del 7
> anota la hora a la que empieza y a la que termina.

---

## 2. CÓMO SE MONTA UNA SEMANA

Siete pasos. El procedimiento es del original; los nombres se tradujeron al modelo de ZR App.

1. **Definir la competencia del sábado.** Es lo único que hay que pensar de verdad.
2. **Escribir el caso real del taller** — el que se verá el sábado. De un carro que entró de
   verdad, no inventado.
3. **Derivar el caso sintético del martes** a partir del real, cambiando el objeto y el
   síntoma.
4. **Renombrar las actividades** siguiendo la convención, con su **nivel de IA** marcado.
5. **Cargar el banco de preguntas** de la diagnóstica del viernes y del examen del módulo.
6. **Ajustar la rúbrica: solo cambian los ítems ★ críticos**, según lo que mata o cuesta caro
   en *esa* competencia. El resto del checklist se hereda.
7. **Vincular la competencia** a la evaluación de desempeño del sábado.

### 2.1 El paso que más se olvida

En el original es el 6, y el aviso vale igual aquí:

> **Una semana clonada que sigue apuntando a la competencia de la semana anterior no falla:
> funciona mal en silencio.** Todo el mundo aparece evaluado en lo que no era, y nadie lo nota
> hasta que ya pasó.

Es exactamente el tipo de error que una prueba automática debería atrapar. **Cuando se
construya el épico F, la validación de «la semana apunta a su propia competencia» va con él.**

---

## 3. QUIÉN MONTA QUÉ

Decidido en `spec/00` §4.3 y §5.1.1: **la semana la pueden cargar los dos.**

| Quién | Qué hace |
|---|---|
| **Profesor** | Escribe el caso — es el único que estuvo en el taller |
| **Dirección** | Revisa, aprueba o pide cambios, y publica |

El profesor **no publica solo**. Dirección **no escribe el caso**. En el prototipo v10 esto es
el flujo de `v-flujo`: idea → borradores → edición → envío a dirección → aprobación →
publicación.

---

## 4. LA REGLA DE CAPACIDAD QUE HAY QUE VIGILAR

Del original, sobre la evidencia en video: 20 estudiantes × 12 semanas × 40 MB ≈ **10 GB por
cohorte**.

> El video de estudiantes es **Fase 3** y no se construye ahora (`CLAUDE.md` §7). Se anota aquí
> para que cuando llegue, el almacenamiento esté contemplado desde el día uno y no se descubra
> con el disco lleno.

Para Fase 1 lo que ocupa son los **PDF de guías y materiales**, que es un orden de magnitud
menos.

---

## 5. ORIGEN

`_archivo/metodologia-lowcode/MDV-implementacion-tecnica-parte2.md` §6, y
`MDV-implementacion-tecnica-lowcode.md` §4.

El procedimiento de clonado del original es de Moodle (`Reutilizar curso › Importar`) y **no
aplica**. Lo que se conserva es la secuencia de siete pasos y el presupuesto de horas.
