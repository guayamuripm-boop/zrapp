# PLAN DE ENTREGA — MVP DEL 5 DE SEPTIEMBRE DE 2026

> Esta carpeta contiene todo lo necesario para llegar al piloto. Si eres un agente de código
> retomando este trabajo, **lee los archivos en orden antes de tocar nada**.

---

## QUÉ SE ENTREGA

Una PWA instalable que la cohorte del piloto se lleva el **sábado 5 de septiembre de 2026**,
su primer día de clase.

No es una demostración. Es una clase real con estudiantes reales.

### La clave del alcance: el 5 de septiembre no hay nada que evaluar

Es la **primera clase** de esa cohorte. Nadie ha aprendido nada todavía. Construir el
checklist de práctica y la defensa técnica para ese día es poner trabajo en el momento
equivocado.

Lo que sí tiene sentido ese día es **medir de dónde parte cada uno** y resolver el dolor
operativo que ya existe: la asistencia y el refrigerio.

---

## LAS DOS FECHAS DEL MVP

No es una entrega, son dos, con dos días de diferencia.

### 🔴 Sábado 5 · lo que se instala ese día

| # | Función | Por qué ese día |
|---|---|---|
| 1 | **Entrar** con cédula | Sin esto no hay nada |
| 2 | **Carnet digital** | Es lo que justifica instalar la app: da identidad, no tarea |
| 3 | **Escanear el QR** → asistencia y refrigerio | El dolor operativo real, y lo único que usan tres roles el mismo día |
| 4 | **Diagnóstico de entrada** | De dónde parte cada uno. Ver `05_DIAGNOSTICO.md` |
| 5 | **Panel del profesor** | Asistentes en vivo + el retrato del grupo |

### 🟠 Lunes 7 · su primera semana

| # | Función |
|---|---|
| 6 | **Caso sintético del día** |
| 7 | **Ver qué le toca cada día** de la semana |

Entre el sábado 5 y el lunes 7 hay un domingo. **Si el sábado sale bien, ese domingo es el
colchón para lo del lunes.**

---

## LO QUE VIENE DESPUÉS, EN ORDEN

**Cuando ya haya qué evaluar** — evaluación práctica (checklist + defensa) · notas y progreso ·
el detalle de qué falló · materiales.

**Cuando el sábado ya funcione solo** — exámenes con cronómetro · «Antes de la clase» para el
profesor · dudas de la semana.

**Cuando haya varias cohortes** — carga de semana · currículo y competencias por dirección ·
asignación de módulos y profesores · historial completo · pantalla de configuración.

**Cuando el contenido sea el cuello de botella** — los asistentes de IA. Ahí sí ahorran semanas.

**Cuando haya mala señal documentada** — escaneo sin internet. Es difícil de verdad; no vale
la pena antes de comprobar que hace falta.

---

## LA CUENTA DEL CONTENIDO — DECIDIR ANTES DE LA SEMANA 2

El modelo es **un caso sintético por día**. Eso son:

    5 casos por semana  ·  20 por módulo  ·  260 en el programa completo

Ese es el costo real, y es de contenido, no de código. Para la primera semana son 5 y se
escriben en una tarde. Sostenerlo todas las semanas es otra cosa.

**Dos salidas, y no hace falta decidir hoy:**

- **Un caso por semana**, trabajado de lunes a viernes en etapas — lunes la hipótesis, martes
  la medición, miércoles el razonamiento. Un quinto del contenido, y el estudiante entra igual
  todos los días.
- **Cinco casos cortos por semana**, como está planteado. Ahí la IA gana su lugar, pero
  después del piloto.

**Recomendación:** escribir cinco a mano la primera semana **midiendo cuánto cuesta**. Con ese
dato se decide el modelo, en vez de decidirlo ahora a ciegas.

---

## LOS ARCHIVOS DE ESTA CARPETA

| Archivo | Para qué |
|---|---|
| `00_LEEME.md` | Este. El punto de entrada |
| `01_ESTADO.md` | Qué existe hoy, y la divergencia entre el repositorio y la base |
| `02_SPRINT.md` | Los 15 días, tarea por tarea |
| `03_DATOS.md` | Qué debe entregar la academia, y para cuándo |
| `04_CONFIGURACION.md` | Qué se cambia sin tocar código |
| `05_DIAGNOSTICO.md` | El diagnóstico de entrada: qué pregunta y por qué |

---

## REGLAS DE TRABAJO PARA ESTE SPRINT

Además de las diez reglas absolutas de `CLAUDE.md`, que siguen vigentes:

**1 · La fuente de verdad de las reglas de negocio es `spec/00_RECONCILIACION.md`.**
Si algo la contradice, ese documento gana. No improvises un umbral ni un peso.

**2 · La base de datos manda sobre las migraciones del repositorio.**
`zr-prod` está 17 migraciones adelante. Lee `01_ESTADO.md` antes de escribir SQL.

**3 · Ninguna tarea se da por terminada sin probarla en un teléfono real.**
No en el navegador de escritorio con la ventana angosta. En un teléfono, de pie.

**4 · Si una tarea se atrasa, se recorta alcance, no se recorta prueba.**
Es preferible llegar con menos funciones que funcionan, que con más que nadie probó.

**5 · Todo número de negocio va a `system_config`.** Ver `04_CONFIGURACION.md`.

**6 · Si se le pide un dato al usuario, se le devuelve algo.** Ver `spec/00` §5.5.1. Aplica al
diagnóstico igual que al caso sintético.

---

## EL ORDEN DE LOS RIESGOS

Atacar en este orden, porque es el orden en que descubrirlos tarde sale más caro:

1. **La cámara del teléfono lee el QR** — si falla, se cae la premisa de la asistencia
2. **Los hallazgos de seguridad de la base** — hay datos de menores de por medio
3. **El contenido de la primera semana** — cinco casos sintéticos, escritos y revisados
4. **La app se instala** en teléfonos de gama media

Los cuatro se pueden empezar hoy y ninguno depende de que la aplicación exista.
