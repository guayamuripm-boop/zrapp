# 03 · LO QUE TIENE QUE ENTREGAR LA ACADEMIA
> Esto no lo puede resolver ningún agente de código. Sin esta información no hay piloto,
> por bien que funcione la aplicación.

---

## POR QUÉ ESTE ARCHIVO EXISTE

La base `zr-prod` tiene datos de prueba. Los 13 módulos que hay cargados —«Introducción y
Herramientas», «Sistema de Alimentación», «Taller Integrador»— **son nombres inventados por
quien sembró la base**, no el currículo real de ZR Mecademy.

Una aplicación perfecta que evalúa competencias inventadas no sirve para nada.

---

## LO MÍNIMO PARA EL 5 DE SEPTIEMBRE

Para un solo sábado no hace falta el currículo completo. Hace falta **un módulo bien
definido**: el que esté cursando la cohorte del piloto.

### 1 · La cohorte del piloto — 🔴 para el **lunes 25 de agosto**

- Nombre del programa
- Sede y turno
- Nombre del profesor y su especialidad
- **Lista de estudiantes:** nombre completo, cédula, fecha de nacimiento, correo, teléfono
- Cuáles son menores de 15 a 17 años

> **Por qué la fecha de nacimiento:** determina quién necesita consentimiento del
> representante. Sin ella el sistema no puede saberlo.

### 2 · El módulo que van a cursar — 🔴 para el **miércoles 27 de agosto**

Solo dos datos, y de ellos sale todo lo demás (`spec/00` §4.3.0):

```
Módulo N · Nombre real del módulo
Competencias:
  1. …
  2. …
  3. …
  4. …
```

**Una competencia es una destreza que se puede observar en el taller.** No es un tema.

| ✅ Es competencia | ❌ No lo es |
|---|---|
| Medir densidad del electrolito con hidrómetro | Conocer la batería |
| Cambiar pastillas de freno | Sistema de frenos |
| Interpretar un código de falla | Diagnóstico electrónico |

La diferencia práctica: de la primera columna se puede decir «lo hizo bien» o «lo hizo mal»
mirándolo. De la segunda no.

**De esas líneas se deriva automáticamente:** cuántos sábados dura, qué se evalúa cada
sábado, el checklist con sus ítems críticos, y el banco de preguntas de defensa.

> `docs/00` §3.10 confirma que estas competencias **ya existen** en las Guías de Aprendizaje
> físicas que la academia usa hoy. No hay que inventarlas, hay que transcribirlas. Si alguien
> pasa las guías, se extraen de ahí para que las revisen.

### 3 · El contenido del primer sábado — 🟡 para el **lunes 1 de septiembre**

- La guía de investigación que leen el lunes (PDF o texto)
- La presentación de clase, si existe
- **Qué van a tener enfrente el sábado:** un vehículo, un motor en banco, un componente o una
  muestra, y cuál es la falla

---

## LO QUE PUEDE ESPERAR

Los otros 12 módulos, el material de semanas siguientes, las fotos de los estudiantes, los
códigos de inscripción de Odoo, y la integración de WhatsApp.

Todo eso se carga después del piloto, con la aplicación ya funcionando.

---

## CALENDARIO DE ENTREGA

| Cuándo | Qué | Quién | Si no llega |
|---|---|---|---|
| **Lun 25 ago** | Cohorte y lista de estudiantes | Administración | No hay a quién cargarle la app |
| **Mié 27 ago** | Módulo y sus competencias | Coordinación Académica | No hay qué evaluar el sábado |
| **Vie 29 ago** | Confirmar el profesor del piloto | Dirección | No hay quién evalúe |
| **Lun 1 sep** | Guía y caso del primer sábado | Profesor o Dirección | El estudiante ve la semana vacía |
| **Jue 4 sep** | Consentimientos firmados de los menores | Administración | Riesgo legal con datos de menores |

---

## PLANTILLA PARA ENTREGAR LA LISTA

Una hoja de cálculo con estas columnas exactas. Se importa directo, sin retrabajo:

```
nombre_completo | cedula     | fecha_nacimiento | correo            | telefono
Luis Hernández  | V-30000001 | 2001-05-12       | luis@correo.com   | 0412-1234567
María Pérez     | V-30000003 | 2009-11-20       | marta@correo.com  | 0412-9876543
```

**Reglas del formato:**
- La cédula va con la letra y el guion: `V-12345678` o `E-12345678`
- La fecha en formato año-mes-día: `2009-11-20`
- Si el estudiante es menor, el correo puede ser el del representante
- El teléfono es opcional pero conviene: por ahí llega el código de inscripción

---

## LA PREGUNTA QUE HAY QUE RESPONDER YA

**¿La cohorte del piloto empieza de cero o ya viene cursando?**

Cambia bastante:

| | Empieza de cero | Ya viene cursando |
|---|---|---|
| Módulo | El 1 | El que vayan |
| Notas previas | Ninguna | Hay que cargarlas o empezar limpio |
| Asistencia previa | Ninguna | Ídem |
| Lo que se prueba | Todo el recorrido desde el inicio | Solo el sábado |

**Una cohorte que empieza de cero es más limpia para el piloto** — no arrastra datos que hay
que reconstruir, y permite probar el registro del estudiante desde el primer paso.
