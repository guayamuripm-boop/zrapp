# 05 · DIAGNÓSTICO DE ENTRADA
> La función central del primer sábado. Decidida el 21 de agosto de 2026.

---

## 1. POR QUÉ EXISTE

El 5 de septiembre la cohorte tiene su primera clase. **No hay nada que evaluar todavía** —
nadie ha aprendido nada. Construir el checklist y la defensa técnica para ese día es poner
trabajo en el momento equivocado.

Lo que sí tiene sentido ese día es lo contrario: **medir de dónde parte cada uno.**

Sirve a cuatro cosas a la vez:

| Para quién | Qué gana |
|---|---|
| **El profesor** | Llega el lunes sabiendo quién ya trabajó en un taller y quién nunca agarró un multímetro |
| **La academia** | Un punto de partida contra el cual comparar dentro de tres meses |
| **El estudiante** | Articula en voz alta por qué está ahí. Un ancla, no un trámite |
| **La app** | Una razón de existir el primer día que no es una obligación |

---

## 2. QUÉ PREGUNTA

Tres bloques, entre 8 y 10 preguntas. **Casi todo se responde tocando, no escribiendo.**
Menos de tres minutos.

### 2.1 Qué trae

| Pregunta | Formato |
|---|---|
| ¿Has trabajado antes en un taller? | Nunca · Ayudando a alguien · Trabajando |
| ¿Has reparado algo tú mismo? | Sí / No + campo abierto corto si dice sí |
| ¿Tienes herramientas propias? | Ninguna · Algunas · Un juego completo |
| ¿Sabes usar un multímetro? | No sé qué es · Lo he visto · Lo he usado |

### 2.2 A dónde va

| Pregunta | Formato |
|---|---|
| ¿Por qué te inscribiste? | Trabajar de esto · Poner mi taller · Arreglar mis propios carros · Me lo recomendaron · Otro |
| ¿Qué quieres estar haciendo en dos años? | Campo abierto, dos líneas |
| ¿Hay alguien en tu familia en el oficio? | Sí / No |

### 2.3 Qué espera

| Pregunta | Formato |
|---|---|
| ¿Qué esperas aprender en este módulo? | Campo abierto, dos líneas |
| **¿Qué te preocupa de empezar?** | Campo abierto, dos líneas |

> ⚠️ **La última es la más valiosa y la que más fácil se recorta.** Con estudiantes de 15 a 25
> años, en Venezuela, en una academia que cuesta dinero, las respuestas van a ser sobre poder
> pagar, sobre no entender, sobre el tiempo, sobre no servir para esto.
>
> **Eso es información de retención que normalmente se descubre cuando el muchacho ya dejó de
> venir.** No se recorta.

---

## 3. REGLAS DE DISEÑO

**3.1 · Se responde una sola vez**, al entrar por primera vez. Después se puede consultar
desde el perfil, pero no vuelve a aparecer.

**3.2 · No es obligatorio para usar la app.** Se puede saltar. Si se salta, aparece un aviso
discreto en el inicio hasta que lo complete. Bloquear la app el primer día es la peor primera
impresión posible.

**3.3 · Le devuelve algo al terminar.** Misma regla que la calibración del caso sintético
(`spec/00` §5.5.1): si se le pide un dato, se le devuelve algo.

Ejemplos de lo que puede decirle:

> *«Sos 1 de 8 que nunca ha trabajado en un taller. Este módulo arranca desde cero — llegaste
> en el momento correcto.»*

> *«Ya has reparado cosas por tu cuenta. En el taller vas a ponerle nombre a lo que ya sabes
> hacer.»*

**3.4 · El profesor ve el grupo, no las personas** — al menos de entrada. Primero el retrato
agregado; el detalle individual está a un toque si lo necesita.

**3.5 · Las respuestas abiertas no se muestran atribuidas al grupo.** El profesor las lee,
pero no se proyectan en clase. Lo que alguien escribió sobre lo que le preocupa no es material
de exposición.

---

## 4. QUÉ VE EL PROFESOR

Su pantalla del sábado, además del contador de asistencia:

```
El grupo que llega
  8 de 24 nunca han trabajado en un taller
  5 tienen herramientas propias
  11 nunca han usado un multímetro

Por qué se inscribieron
  Trabajar de esto           14
  Poner su taller             6
  Arreglar sus propios carros 3
  Otro                        1

Lo que más les preocupa
  «No tener tiempo con el trabajo»        mencionado 7 veces
  «No entender la parte eléctrica»        mencionado 5 veces
  «Poder seguir pagando»                  mencionado 4 veces
```

Eso último **cambia cómo arranca la clase.** Un profesor que sabe que a siete les preocupa el
tiempo empieza distinto que uno que no lo sabe.

---

## 5. DÓNDE SE GUARDA

Tabla nueva `entry_diagnostics`:

| Columna | Tipo | Nota |
|---|---|---|
| `id` | uuid | |
| `student_id` | uuid | Único: uno por estudiante |
| `cohort_id` | uuid | Para agregar por cohorte |
| `experiencia_taller` | enum | nunca · ayudando · trabajando |
| `ha_reparado` | boolean | |
| `que_reparo` | text | Opcional |
| `herramientas` | enum | ninguna · algunas · completo |
| `nivel_multimetro` | enum | no_conoce · lo_ha_visto · lo_ha_usado |
| `motivo_inscripcion` | enum | trabajar · taller_propio · carros_propios · recomendacion · otro |
| `motivo_otro` | text | Opcional |
| `aspiracion_dos_anos` | text | |
| `familiar_en_oficio` | boolean | |
| `que_espera_aprender` | text | |
| `que_le_preocupa` | text | |
| `completed_at` | timestamptz | |

**RLS obligatoria:**
- El estudiante lee y escribe **solo el suyo**
- El profesor de su cohorte lee los de su cohorte
- Dirección y super admin leen todos
- **Nadie puede editar el de otro**

Vista `v_diagnostico_cohorte` con los agregados, para que el profesor no consulte fila por
fila ni pueda deducir quién escribió qué desde una consulta agregada.

---

## 6. LO QUE ESTE DIAGNÓSTICO NO ES

- ❌ **No es una evaluación.** No tiene nota, no cuenta para nada, no se aprueba ni se reprueba
- ❌ **No filtra ni clasifica.** Nadie va a un grupo distinto por lo que responda
- ❌ **No se le muestra a otros estudiantes**
- ❌ **No es el feedback del módulo** — ese va al cierre y es anónimo (`spec/00` §7)

Si en algún momento alguien propone usarlo para separar por nivel, **eso es otra decisión** y
hay que tomarla explícitamente, no derivarla de este dato.
