# 04 · QUÉ SE PUEDE CAMBIAR SIN TOCAR CÓDIGO
> Catálogo completo de `system_config` y de lo que puede hacer el super administrador.
> Regla absoluta 5 de `CLAUDE.md`: **ningún número de negocio va escrito en el código.**

---

## 1. POR QUÉ IMPORTA

Cada valor que quede escrito en el código es un despliegue cada vez que la academia cambie de
opinión. Y la academia va a cambiar de opinión — sobre umbrales, sobre pesos, sobre cuántas
preguntas se sortean. Eso no es indecisión, es cómo funciona una institución educativa.

El objetivo: **que dirección pueda ajustar el sistema un martes sin llamar a nadie.**

---

## 2. LOS TRES NIVELES DE RIESGO

No todos los valores se pueden cambiar con la misma ligereza.

| Nivel | Qué pasa al cambiarlo | Quién puede |
|---|---|---|
| 🟢 **Seguro** | Efecto inmediato, nada se recalcula | Dirección académica |
| 🟡 **Con aviso** | Afecta a evaluaciones futuras, no a las hechas | Dirección, con confirmación |
| 🔴 **Peligroso** | **Recalcula notas ya puestas** | Solo super admin, con doble confirmación |

⚠️ **Los rojos cambian notas de estudiantes reales.** La pantalla debe decir exactamente a
cuántos afecta antes de guardar, y quedar registrado en `system_config_history` con quién lo
hizo y cuándo.

---

## 3. CATÁLOGO COMPLETO

### 3.1 Notas y aprobación

| Clave | Valor | Riesgo | Qué controla |
|---|---|---|---|
| `exam.max_score` | 20 | 🔴 | La escala de todo el sistema |
| `exam.individual_passing_score` | 10 | 🟡 | Con cuánto aprueba una evaluación suelta |
| `module.passing_threshold_default` | 12 | 🔴 | Con cuánto se aprueba un módulo |
| `module.passing_threshold_first` | 10 | 🔴 | Excepción del primer módulo |
| `nota.umbral_dominada` | 16 | 🟡 | Desde dónde una competencia es «dominada» |
| `modulo.peso_teoria` | 0.50 | 🔴 | Cuánto pesa la teoría |
| `modulo.peso_practica` | 0.50 | 🔴 | Cuánto pesa la práctica |
| `module.participation_weight_min` | 0.05 | 🟡 | Mínimo de participación que exige la academia |

> ⚠️ `peso_teoria` y `peso_practica` **deben sumar 1**. La pantalla tiene que validarlo, no
> confiar en que quien edita haga la cuenta.

### 3.2 Evaluación práctica del sábado

| Clave | Valor | Riesgo | Qué controla |
|---|---|---|---|
| `practica.peso_checklist` | 0.70 | 🔴 | Cuánto pesa el checklist |
| `practica.peso_defensa` | 0.30 | 🔴 | Cuánto pesa la defensa oral |
| `practica.escala_defensa` | 4 | 🟡 | Cuántos niveles tiene la defensa |
| `practica.item_critico_topa` | false | 🟡 | Si un ítem crítico fallado topa la nota |
| `practica.item_critico_tope` | 9 | 🟡 | En cuánto la topa, si lo anterior está activo |
| `defensa.preguntas_sorteadas` | 3 | 🟢 | Cuántas se le sortean a cada estudiante |
| `defensa.banco_minimo` | 10 | 🟢 | Mínimo de preguntas para poder sortear |

> 📌 `item_critico_topa` está en `false` por decisión de `spec/00` §2.4 — el ítem crítico
> **alerta, no castiga**. Se dejó como interruptor para poder endurecerlo con evidencia real,
> sin desplegar código.

### 3.3 Asistencia

| Clave | Valor | Riesgo | Qué controla |
|---|---|---|---|
| `qr.un_solo_uso` | true | 🟡 | Si el código muere al escanearse |
| `asistencia.marca_refrigerio` | true | 🟢 | Si el mismo escaneo marca el refrigerio |
| `asistencia.ventana_minutos` | 90 | 🟢 | Cuánto tiempo se puede escanear tras abrir la sesión |

> ❌ **Se retiran** `attendance.qr_window_seconds` y `attendance.qr_drift_tolerance`:
> son del modelo rotativo, descartado en `spec/00` §5.

### 3.4 Ciclo semanal

| Clave | Valor | Riesgo | Qué controla |
|---|---|---|---|
| `semana.desbloqueo_dia_a_dia` | true | 🟢 | Si la semana se abre día a día o toda el lunes |
| `semana.diagnostica_opcional` | true | 🟢 | Si la diagnóstica del viernes es voluntaria |
| `curriculo.competencias_min` | 2 | 🟢 | Mínimo de competencias por módulo |
| `curriculo.competencias_max` | 8 | 🟢 | Máximo. Más que eso, el módulo se parte en dos |

### 3.5 Exámenes

| Clave | Valor | Riesgo | Qué controla |
|---|---|---|---|
| `examen.duracion_default` | 45 | 🟢 | Minutos que trae un examen nuevo |
| `examen.requiere_aprobacion_profesor` | true | 🟢 | Si lo del profesor pasa por dirección |
| `grading.sla_hours` | 72 | 🟢 | Plazo para corregir preguntas abiertas |

### 3.6 Feedback

| Clave | Valor | Riesgo | Qué controla |
|---|---|---|---|
| `feedback.micro_max_questions` | 3 | 🟢 | Cuántas preguntas por clase |
| `feedback.min_responses_to_show` | 3 | 🟡 | Mínimo de respuestas para mostrar el promedio |

> ⚠️ `min_responses_to_show` protege el anonimato. **Bajarlo a 1 o 2 permite deducir quién
> dijo qué** en un grupo pequeño. La pantalla debe advertirlo.

### 3.7 Operación

| Clave | Valor | Riesgo | Qué controla |
|---|---|---|---|
| `app.support_channel` | texto | 🟢 | A quién acudir cuando algo falla |
| `app.mantenimiento` | false | 🟢 | Modo mantenimiento con mensaje |
| `app.mensaje_global` | vacío | 🟢 | Aviso en la pantalla de todos |

> 💡 `app.mensaje_global` sirve más de lo que parece: *«Este sábado la clase es a las 9, no a
> las 8»* llega a todos sin desplegar nada ni mandar cien mensajes de WhatsApp.

---

## 4. LO QUE HACE EL SUPER ADMIN, ADEMÁS DE LA CONFIGURACIÓN

### 4.1 Usuarios y roles

- Crear usuarios de personal: profesor, administración, dirección académica
- Cambiar el rol de alguien
- Desactivar una cuenta sin borrarla
- Forzar cambio de contraseña

> ⚠️ **Regla absoluta 9:** el rol nunca viene del cliente. Todo el que se registra solo es
> `estudiante`. Los roles de personal los asigna un humano desde el servidor.

### 4.2 Estructura académica

- Crear y editar programas
- Crear y editar los módulos del currículo y sus competencias
- Crear cohortes y asignarles profesor por módulo
- Abrir y cerrar sesiones de clase

### 4.3 Auditoría

- Ver `audit_log`: quién cambió qué y cuándo
- Ver `system_config_history`: el historial de cada valor
- Exportar notas y asistencia

> El registro de auditoría **no se puede editar ni borrar desde la aplicación**. Es
> append-only. Si alguien puede editarlo, no sirve como auditoría.

### 4.4 Lo que NO debe poder hacer nadie desde la aplicación

- Borrar un estudiante con notas cargadas — se desactiva, no se borra
- Editar una nota sin dejar rastro
- Cambiar la escala con evaluaciones ya hechas sin confirmación doble
- Ver el feedback individual de un estudiante — ni siquiera el super admin

---

## 5. CÓMO SE VE LA PANTALLA

Agrupada por tema, no por clave. Nadie entiende una lista alfabética de 30 valores.

```
Notas y aprobación          🔴 3 valores afectan notas existentes
  Escala máxima                                            20
  Aprueba el módulo con                                    12
  Aprueba el primer módulo con                             10
  Una competencia es «dominada» desde                      16
  Peso de la teoría                                       50%
  Peso de la práctica                                     50%   ✓ suman 100%

Evaluación del sábado
  Peso del checklist                                      70%
  Peso de la defensa                                      30%   ✓ suman 100%
  Preguntas sorteadas por estudiante                        3
  Un ítem crítico fallado topa la nota              ○ No  ● Sí
```

**Cada valor lleva:**
- Qué controla, en una frase, sin jerga
- Su nivel de riesgo, visible
- A cuántos estudiantes afecta el cambio, si es 🔴
- Quién lo cambió la última vez y cuándo

**Cada cambio queda en `system_config_history`.** Sin excepción.

---

## 6. PARA CUÁNDO

**No entra en el MVP del 5 de septiembre.** Para el piloto los valores se ajustan por SQL si
hace falta — son cinco personas y una cohorte.

Entra **después del piloto**, cuando haya varias cohortes y dirección necesite ajustar sin
depender de nadie. Pero el catálogo se define ahora, para que ningún valor termine escrito en
el código mientras tanto.

**Lo único que sí debe existir el 5 de septiembre:** que todos estos valores estén **en
`system_config` y no en el código**. La pantalla puede esperar; la disciplina no.
