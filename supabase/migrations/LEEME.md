# MIGRACIONES

> **La siguiente migración de este proyecto es la `034`.** No la 017.

---

## POR QUÉ ESTÁ VACÍA ESTA CARPETA

Las migraciones **001 a 016** que había aquí **nunca se aplicaron a `zr-prod`**. La base real
va por la **033**, con 17 migraciones que este repositorio nunca conoció.

El 23 de agosto de 2026 se archivaron en `_archivo/migraciones-superadas/`, para que nadie las
aplique por error. **No se aplican. Ni una.**

## QUÉ HAY QUE HACER PRIMERO

1. **Volcar el esquema real de `zr-prod`** a `000_esquema_base.sql`. Hasta que eso esté, este
   repositorio no describe la base.
2. A partir de ahí, cada migración nueva se numera desde la **034**.

## LAS SEIS REGLAS

1. Una migración aplicada **nunca se edita**. Se crea la siguiente.
2. Toda tabla nueva nace **con RLS habilitada y con sus políticas en la misma migración**.
3. Se corre `npm run test:rls` antes de subirla.
4. **Ningún número de negocio va en el SQL.** Umbrales y pesos van a `system_config`.
5. El orden es **local → `zr-dev` → `zr-prod`**. Nunca directo a producción.
6. Después de aplicar, se corre el linter de seguridad. Un hallazgo `ERROR` significa que la
   migración **no está terminada**.

El detalle completo, con la plantilla, está en `INGENIERIA.md` §3.

## LO QUE BLOQUEA HOY

Hay **3 hallazgos de nivel `ERROR`** abiertos en `zr-prod`: `v_students`,
`v_exam_questions_student` y `v_feedback_session_summary` están definidas con
`SECURITY DEFINER`. Y `student_qr_secrets` tiene RLS habilitada sin ninguna política.

> **No se carga ni una cédula real mientras haya un hallazgo `ERROR` abierto.**
