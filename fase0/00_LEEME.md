# FASE 0 — LO QUE SE ENTREGA EL 5 DE SEPTIEMBRE DE 2026

> Decidido el 24 de agosto de 2026 por dirección.
> **Este documento manda sobre el alcance del 5 de septiembre.** Sustituye a
> `plan/06_ENTREGABLE.md`, que describía un piloto solo de asistencia.

---

## 1. QUÉ ES, EN UNA FRASE

> Una aplicación instalable donde el estudiante **recibe el material de su módulo, trabaja un
> caso distinto cada día y manda sus dudas**, y donde el sábado **queda registrada su
> asistencia y su refrigerio sin papel**.

---

## 2. POR QUÉ ESTA FASE EXISTE

La Fase 1 completa incluye evaluación práctica, exámenes, notas y el mapa de dominio por
competencia. Eso es lo que más tiempo lleva y lo más delicado de construir: cálculo de notas,
rúbricas, defensa técnica, aislamiento de calificaciones.

**Fase 0 saca todo lo que produce una nota.** Lo que queda es lo que el estudiante gana para sí
mismo, más el registro del sábado que la academia necesita.

### 2.1 Lo que esto cuesta, dicho claro

Fase 0 **no es más pequeña que el piloto de asistencia** que estaba planificado para el
5 de septiembre. Es aproximadamente **el doble**: añade materiales, el caso diario con su
banco, las dudas con su resumen, y las competencias del módulo.

Se decidió aun sabiéndolo. Lo que se hace para protegerlo está en §4 y en `02_PLAN.md`:
**se construye en un orden donde siempre hay algo que funciona.**

---

## 3. QUÉ ENTRA Y QUÉ NO

### 3.1 Entra

| # | Qué | Quién lo usa |
|---|---|---|
| 1 | Entrar con cédula | Los cuatro roles |
| 2 | Carnet digital | Estudiante |
| 3 | **Material del módulo** — presentaciones y guías en PDF | Estudiante |
| 4 | **El caso del día** — uno distinto de lunes a viernes | Estudiante |
| 5 | **Mandar una duda** — texto libre, al terminar un caso o cuando quiera | Estudiante |
| 6 | **Mi módulo** — qué competencias se adquieren en él | Estudiante |
| 7 | **Escanear el QR** — asistencia y refrigerio en el mismo evento | Estudiante |
| 8 | **Mostrar el QR** y **registro manual** | Administración |
| 9 | **Subir material** | Administración |
| 10 | Asistentes en vivo · **las 3 preguntas que resumen las dudas** · cuántos trabajaron el caso | Profesor |

### 3.2 No entra

Esta lista vale tanto como la anterior. **Si alguien llega el 5 esperando algo de aquí, el
piloto «fracasa» aunque todo haya funcionado.**

| No hay | Por qué |
|---|---|
| **Notas, exámenes, evaluación práctica** | Es lo que define Fase 0: nada que produzca una nota |
| **Defensa técnica y rúbricas** | Igual |
| Mapa de dominio por competencia con su estado | Requiere notas. En Fase 0 las competencias se **listan**, no se puntúan |
| El progreso del estudiante | Igual |
| Diagnóstico de entrada | Sale del alcance. Se hace en papel o después |
| Pantallas de autoría y aprobación de contenido | Ver §4.1 — la revisión ocurre fuera de la app |
| Panel de dirección | Fase 1 |
| Registro propio del estudiante | Las cuentas las carga administración |
| Funcionar sin señal | El escaneo requiere conexión |
| Generación de casos con IA dentro de la app | Los casos se producen fuera y se cargan revisados |

---

## 4. LAS TRES SIMPLIFICACIONES QUE HACEN ESTO POSIBLE

Sin estas tres, Fase 0 no cabe en 12 días.

### 4.1 La revisión del contenido ocurre **fuera** de la aplicación

Decidido: cada caso lo revisan **el profesor, dirección académica y el desarrollador**.

Eso **no se construye como pantallas**. El circuito es:

```
El dev redacta los casos a partir de la presentación del módulo
        ↓
Documento compartido — lo leen el profesor y dirección académica
        ↓
Corrigen y aprueban ahí mismo
        ↓
El dev los carga a la base ya aprobados
        ↓
La app solo los muestra
```

**Qué ahorra:** las pantallas `v-crearcaso` y `pd-estudio` del prototipo v10, más el flujo de
borrador → envío → aprobación → publicación. Es un épico completo.

**Cuándo deja de servir:** cuando el profesor tenga que montar sus propias semanas sin
depender del dev. Eso es Fase 1.

### 4.2 El profesor ve **números, no nombres**

Decidido: el profesor ve *«14 de 24 trabajaron el caso»*, sin la lista de quién.

Ahorra la pantalla de seguimiento individual, y de paso es mejor: en Fase 0 el caso no tiene
peso, así que una lista de nombres solo produciría presión sin consecuencia.

> El registro **sí se guarda** en la base. Solo no se muestra atribuido.

### 4.3 Las competencias son una lista, no un estado

El estudiante ve **qué se aprende en este módulo**, en general. No ve *dominada / en
desarrollo / requiere refuerzo*, porque eso necesita notas y en Fase 0 no hay.

Es una pantalla de solo lectura que se carga con el módulo.

---

## 5. LO QUE HACE FALTA DE LA ACADEMIA, Y CUÁNDO

**Esto es el camino crítico real.** El código se puede apurar; el contenido no.

| Qué | Quién | Para cuándo | Si no llega |
|---|---|---|---|
| **La presentación del módulo** que se dicta el 5 de septiembre | Dirección | **Miércoles 26 de agosto** | No hay casos ni competencias. Se entrega solo asistencia y material |
| Los PDF de guías y material | Dirección | Lunes 31 de agosto | La pantalla de material sale vacía |
| Los casos revisados y aprobados | Profesor + dirección | **Miércoles 2 de septiembre** | Se publican menos días de casos |
| La cohorte: cédulas y fechas de nacimiento | Administración | Jueves 3 de septiembre | No hay con quién probar |

> ⚠️ **La cohorte del piloto son estudiantes NUEVOS**, y el 29 de agosto no hay ensayo con
> clase real. Eso cambia la coreografía del 5 de septiembre — ver `01_ENTREGABLE.md` §6.

> ⚠️ **La presentación del módulo es lo primero y lo más urgente.** De ella salen las
> competencias y los cinco casos. Sin ella, el 24 de agosto, no arranca la producción de
> contenido y Fase 0 se cae a un piloto de asistencia.

---

## 6. DÓNDE ESTÁ CADA COSA

| Archivo | Qué |
|---|---|
| `01_ENTREGABLE.md` | Pantalla por pantalla, criterio de éxito, y **qué se recorta si se atrasa** |
| `02_PLAN.md` | Los 12 días, con las fechas reales verificadas contra el calendario |
| `03_CASOS.md` | Cómo se escriben los casos. **La regla de seguridad del contenido** |
| `04_ARQUITECTURA.md` | La estructura técnica completa: carpetas, tablas, funciones, entorno |
| `05_QUE_NECESITO.md` | **Los bloqueantes.** Accesos, contenido y decisiones pendientes |

Y el prototipo:

| Archivo | Qué |
|---|---|
| `ZR_APP_FASE0_PROTOTIPO.html` | ⭐ **La maqueta funcional de Fase 0.** Se abre en cualquier navegador |

**Ábrelo antes de construir cualquier pantalla.** Los tres roles funcionan de verdad: el caso
con sus cuatro pasos y la calibración, el QR que muere al usarse, el registro manual, las tres
preguntas del profesor. Nada está conectado a la base — es una maqueta.

> Es distinto de `ZR_APP_PROTOTIPO_v10.html`, que sigue siendo la especificación visual de
> **Fase 1 completa**. El de Fase 0 solo tiene lo que se entrega el 5 de septiembre.

Lo que no cambia sigue mandando: `spec/00_RECONCILIACION.md` para las reglas,
`ZR_APP_PROTOTIPO_v10.html` para cómo se ve cada pantalla, `INGENIERIA.md` para el proceso.

---

## 7. HISTORIAL

| Fecha | Cambio |
|---|---|
| 2026-08-24 | Documento creado. Dirección decide entregar Fase 0 completa el 5 de septiembre, sabiendo que duplica el alcance del piloto de asistencia que estaba planificado |
