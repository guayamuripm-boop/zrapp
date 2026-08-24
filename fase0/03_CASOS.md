# 03 · EL BANCO DE CASOS

> Cómo se escriben los casos sintéticos, quién los revisa y qué hace falta para producirlos.
> El razonamiento pedagógico está en `metodologia/01_MODELO.md` §4.2.

---

## 1. LA REGLA DE SEGURIDAD DEL CONTENIDO

Es la regla más importante de este documento y viene de una decisión de dirección.

> ## Los casos son sobre **cómo razonar y por dónde empezar**.
> ## **Nunca sobre el valor exacto.**

Qué observar, en qué orden revisar, cómo descartar una causa, qué haría un mecánico antes de
tocar nada. Eso es lo que enseña el caso.

**Cuando haga falta un número, sale de la guía del profesor o del manual del fabricante — no
del caso.** El caso puede decir *«el voltaje está por debajo de lo normal»*; **no** puede decir
*«el voltaje es 11,4 V y lo normal son 12,6 V»*.

### 1.1 Por qué

Los casos los redacta una IA a partir de una presentación. Una IA puede equivocarse en un valor
de referencia con total seguridad y sonar convincente. **Un estudiante que se lleva un número
falso a un taller real puede dañar un equipo o hacerse daño.**

Un error de método se corrige el sábado hablando. Un número falso memorizado, no.

### 1.2 Qué sí y qué no

| ✅ Sí va en un caso | ❌ No va en un caso |
|---|---|
| «El cliente dice que en la mañana no arranca» | «La batería marca 11,4 V» |
| «¿Qué revisarías antes de desconectar nada?» | «¿Cuál es el torque exacto de este perno?» |
| «Se ve corrosión blanca en un borne» | «La densidad del electrolito es 1,180» |
| «¿Qué descartarías primero, y por qué?» | «El alternador debe cargar a 14,2 V» |
| «¿Qué le preguntarías al cliente?» | Cualquier cifra que el estudiante pueda memorizar mal |
| Orden de pasos, seguridad, criterio | Especificaciones de un modelo concreto |

### 1.3 La prueba para saber si un caso cumple

> **¿Un mecánico con 20 años de oficio podría discutir este caso sin abrir un manual?**

Si la respuesta es sí, el caso es conceptual y sirve.
Si hace falta un manual para saber si la respuesta es correcta, el caso tiene demasiado número.

---

## 2. LA FORMA DE UN CASO

Los mismos cuatro pasos del método, siempre. El estudiante no debe tener que aprender una
mecánica nueva cada día.

```
ESCENARIO
  Dos o tres frases. Un síntoma concreto, contado como lo contaría un cliente.
  Sin cifras.

PASO 1 · ¿Cuál es tu primera hipótesis?
  3 o 4 opciones. Una correcta, las demás plausibles — no absurdas.

PASO 2 · ¿Qué revisarías primero?
  3 o 4 opciones. Se evalúa el ORDEN y el criterio, no el instrumento.

PASO 3 · Explica tu razonamiento
  Texto libre. No se corrige automáticamente. Es para que el estudiante
  se obligue a poner en palabras lo que pensó.

PASO 4 · ¿Qué tan seguro estás?
  Escala. Alimenta la calibración de confianza.

REFERENCIA  — se revela solo al completar los cuatro pasos
  Qué era, POR QUÉ era eso, y — lo más importante —
  POR QUÉ NO ERAN LAS OTRAS opciones.
```

### 2.1 «Por qué no las otras» no es opcional

Es la parte que más enseña y la que más se olvida escribir. Un estudiante que descarta bien
tres causas equivocadas aprende más que uno que acierta la correcta por suerte.

### 2.2 La calibración

Al revelar la referencia se le devuelve el cruce entre lo que acertó y lo seguro que estaba
(`01_ENTREGABLE.md` §2.4). El cruce que más enseña es **acertó = no, confianza = alta**:
*«Estabas seguro y no era.»* Ese es el caso que conviene revisar y que el estudiante no
detecta solo.

---

## 3. UN EJEMPLO COMPLETO

> Ejemplo de forma, no de contenido. El contenido real sale de la presentación del módulo.

**ESCENARIO**
> Un cliente trae su carro. Dice que en la mañana, cuando arranca por primera vez, el motor
> «se demora y suena flojo», pero que si lo intenta una segunda vez arranca bien. En la tarde
> nunca le ha pasado.

**PASO 1 · ¿Cuál es tu primera hipótesis?**
- El sistema de arranque no está recibiendo suficiente energía ✅
- El motor de arranque está dañado y hay que cambiarlo
- El combustible no está llegando bien
- Es normal en las mañanas frías, no hay falla

**PASO 2 · ¿Qué revisarías primero?**
- El estado y la conexión de los bornes, antes de desconectar nada ✅
- Desmontar el motor de arranque para revisarlo
- El filtro de combustible
- Nada: le digo al cliente que lo deje encendido más tiempo

**PASO 3 · Explica tu razonamiento** *(texto libre)*
> ¿Por qué crees que pasa en la mañana y no en la tarde? ¿Qué te dice que arranque al segundo
> intento?

**PASO 4 · ¿Qué tan seguro estás?**

**REFERENCIA**
> **Qué era:** el sistema de arranque no está recibiendo la energía que necesita. El patrón de
> «en frío falla, en caliente no» y de «al segundo intento sí» apunta a que la energía
> disponible está justo en el límite: el primer intento la consume y deja al sistema en peores
> condiciones, pero también «despierta» lo suficiente para que el segundo funcione.
>
> **Por qué no las otras:**
> - *Motor de arranque dañado* — si estuviera dañado fallaría también en la tarde. La falla
>   que depende de la temperatura y de la hora rara vez es una pieza rota; suele ser energía.
> - *Combustible* — un problema de combustible no mejora al segundo intento inmediato, y
>   normalmente da síntomas también con el motor caliente.
> - *Es normal* — que arranque «flojo» no es normal. Es un aviso temprano, y cuesta mucho menos
>   atenderlo ahora que cuando el carro no arranque del todo un lunes a las 6 de la mañana.
>
> **Lo que hay que llevarse:** antes de desmontar nada, se revisa lo que está a la vista y lo
> que es reversible. Desconectar y desmontar cuesta tiempo y puede introducir fallas nuevas.

**Fíjate en lo que este caso NO tiene:** ni un solo número. Y aun así se puede discutir,
acertar y equivocarse.

---

## 4. QUIÉN REVISA — EL CIRCUITO

Decidido: lo revisan **el profesor del módulo, dirección académica y el desarrollador**.
Y ocurre **fuera de la aplicación** (`00_LEEME.md` §4.1).

```
1. El dev redacta 5 casos a partir de la presentación del módulo
        ↓
2. Documento compartido, un caso por página
        ↓
3. El PROFESOR revisa: ¿es real? ¿es así como pasa en el taller?
   Es el único que puede detectar que un caso suena bien pero no ocurre nunca
        ↓
4. DIRECCIÓN ACADÉMICA revisa: ¿corresponde al módulo? ¿al nivel del grupo?
        ↓
5. Ambos aprueban por escrito
        ↓
6. El dev los carga a la base
        ↓
7. La app los muestra, uno por día
```

### 4.1 La regla dura

> **Ningún caso llega al estudiante sin que el profesor lo haya leído y aprobado.**

No importa cuánta prisa haya. Un caso sin revisar es exactamente el riesgo que la regla de §1
existe para evitar.

### 4.2 Cuánto cuesta revisar

Cinco casos conceptuales, de una página cada uno: **entre 45 y 90 minutos** la primera semana,
menos después. Hay que reservarlo en la agenda del profesor, no asumirlo.

---

## 5. QUÉ NECESITO PARA PRODUCIR LOS CASOS

Esto es lo que hace falta que me entreguen. **Cuanto antes, mejor: es el camino crítico del
contenido** (`02_PLAN.md`, F0-04).

### 5.1 Imprescindible

| Qué | Por qué |
|---|---|
| **La presentación del módulo** que se dicta | De ahí salen los temas y el nivel |
| **Qué se ve cada semana** | Para que el caso del martes corresponda a lo del sábado anterior |

### 5.2 Ayuda mucho, si existe

| Qué | Para qué |
|---|---|
| **Dos o tres casos reales** que hayan entrado al taller | Los casos sintéticos salen mucho mejores cuando imitan algo que pasó de verdad |
| Los errores que más comete el grupo | Se convierten en las opciones incorrectas plausibles |
| El nivel del grupo | Un caso para principiantes y uno para avanzados no se parecen |

### 5.3 Qué devuelvo

Por cada semana de módulo:

- **5 casos** con su formato completo, uno por día de lunes a viernes
- **La lista de competencias del módulo**, derivada de la presentación, para la pantalla
  «Mi módulo»
- **Los temas** para la lista desplegable de las dudas

> ⚠️ **Las competencias las derivo yo de la presentación, porque no hay currículo formal.**
> Eso significa que **hay que revisarlas igual que los casos** — es mi interpretación de lo que
> enseña el módulo, no un documento oficial de la academia.

---

## 6. CUÁNTO CONTENIDO HACE FALTA

| Periodo | Casos |
|---|---|
| Una semana | 5 |
| Un módulo de 4 semanas | 20 |

Para el **5 de septiembre** hacen falta **5 casos**: los de la semana del 7 al 11.
No hacen falta los 20 el primer día.

> `metodologia/03_PRODUCCION.md` estima 3-4 h por semana de contenido en régimen. **Esa
> estimación hay que cronometrarla** con esta primera semana real — es lo que decide si más
> adelante hace falta automatizar la generación.

---

## 7. LO QUE ESTE DOCUMENTO **NO** AUTORIZA

- **Generar casos dentro de la aplicación.** En Fase 0 se producen fuera y se cargan revisados.
- **Publicar un caso sin revisión humana.**
- **Poner cifras técnicas en un caso.** Ver §1.
- **Que el caso produzca una nota.** En Fase 0 nada produce nota.
