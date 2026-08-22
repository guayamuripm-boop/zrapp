# PLAN DE ENTREGA — MVP DEL 5 DE SEPTIEMBRE DE 2026

> Esta carpeta contiene todo lo necesario para llegar al piloto. Si eres un agente de código
> retomando este trabajo, **lee los cinco archivos en orden antes de tocar nada**.

---

## QUÉ SE ENTREGA

Un MVP con **las funciones críticas del estudiante y todo lo que las alimenta**, funcionando
con una cohorte real el sábado 5 de septiembre de 2026.

No es una demostración. Es una clase real con estudiantes reales.

### Entra

| Rol | Qué debe funcionar |
|---|---|
| **Estudiante** | Entrar · carnet digital · escanear el QR · ver su semana · caso sintético · materiales · su progreso y notas · presentar examen |
| **Profesor** | Evaluar la práctica (checklist + defensa) · ver cómo llegó el grupo · ver dudas |
| **Administración** | Mostrar el QR de la sesión · ver quién asistió |
| **Dirección** | Cargar la semana · aprobar lo del profesor |

### No entra (se agrega después del piloto)

Gestión de currículo por dirección · asignación de programas · historial completo por módulo ·
activación de feedback · asistentes de IA reales · escaneo sin internet · importación CSV ·
notificaciones push · el sitio web.

**Por qué se recorta:** nada de eso lo necesita un estudiante el primer sábado. Todo se
construye después sobre algo que ya funciona, que es mucho más barato que construirlo antes
sobre algo que todavía no.

---

## LOS ARCHIVOS DE ESTA CARPETA

| Archivo | Para qué |
|---|---|
| `00_LEEME.md` | Este. El punto de entrada |
| `01_ESTADO.md` | Qué existe de verdad hoy, y la divergencia entre el repositorio y la base |
| `02_SPRINT.md` | Los 15 días, tarea por tarea, con criterio de terminado |
| `03_DATOS.md` | Qué información tiene que entregar la academia, y para cuándo |
| `04_CONFIGURACION.md` | Qué puede cambiar dirección sin tocar código |

---

## REGLAS DE TRABAJO PARA ESTE SPRINT

Además de las diez reglas absolutas de `CLAUDE.md`, que siguen vigentes:

**1 · La fuente de verdad de las reglas de negocio es `spec/00_RECONCILIACION.md`.**
Si algo contradice ese documento, ese documento gana. No improvises un umbral ni un peso.

**2 · La base de datos manda sobre las migraciones del repositorio.**
`zr-prod` está 17 migraciones adelante. Lee `01_ESTADO.md` antes de escribir SQL.

**3 · Ninguna tarea se da por terminada sin probarla en un teléfono real.**
No en el navegador de escritorio con la ventana angosta. En un teléfono, de pie.

**4 · Si una tarea se atrasa, se recorta alcance, no se recorta prueba.**
Es preferible llegar al 5 de septiembre con menos funciones que funcionan, que con más
funciones que nadie probó.

**5 · Todo número de negocio va a `system_config`.**
Ver `04_CONFIGURACION.md`. Un umbral escrito en el código es un despliegue cada vez que la
academia cambie de opinión.

---

## EL ORDEN DE LOS RIESGOS

Atacar en este orden, porque es el orden en que descubrirlos tarde sale más caro:

1. **La cámara del teléfono lee el QR** — si esto falla, se cae la premisa de la asistencia
2. **El contenido real del módulo del piloto** — sin competencias no hay evaluación
3. **Los hallazgos de seguridad de la base** — hay datos de menores de por medio
4. **El profesor alcanza a evaluar a todo el grupo en una jornada** — nunca se ha medido

Los cuatro se pueden empezar hoy y ninguno depende de que la aplicación exista.
