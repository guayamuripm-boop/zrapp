# ZR App — Plataforma académica de ZR Mecademy

Aplicación web instalable (PWA) para la gestión académica de una academia técnica de mecánica
automotriz. Clases sabatinas, ~100 estudiantes activos de 15 a 25 años.

**Entrega de Fase 1: sábado 5 de septiembre de 2026.**

---

## ⚡ Empieza aquí

| Si eres… | Lee esto primero |
|---|---|
| **Desarrollador** que entra al proyecto | [`entrega/00_EMPIEZA_AQUI.md`](entrega/00_EMPIEZA_AQUI.md) — **el paquete de entrega** |
| **Agente de código** (Claude, Cursor, Copilot) | [`AGENTS.md`](AGENTS.md) — **completo, antes de escribir una línea** |
| Alguien que va a **construir una pantalla** | [`ZR_APP_PROTOTIPO_v10.html`](ZR_APP_PROTOTIPO_v10.html), y luego [`spec/04_PANTALLAS.md`](spec/04_PANTALLAS.md) |
| Alguien que quiere saber **qué se construye y en qué orden** | [`plan/07_ALCANCE_V10.md`](plan/07_ALCANCE_V10.md) |
| Alguien que quiere entender **por qué el modelo pedagógico es así** | [`metodologia/01_MODELO.md`](metodologia/01_MODELO.md) |
| Alguien que quiere entender **por qué** el proyecto es así | [`docs/08_AUDITORIA_TECNICA_Y_VIABILIDAD.md`](docs/08_AUDITORIA_TECNICA_Y_VIABILIDAD.md) |

---

## Estructura

```
├── AGENTS.md · CLAUDE.md    Reglas absolutas y orden de trabajo
├── INGENIERIA.md            EL PROCESO — cómo se construye, prueba y despliega
├── COLABORACION.md          Cómo trabajamos juntos
│
├── ZR_APP_PROTOTIPO_v10.html   LA ESPECIFICACIÓN VISUAL — 31 pantallas, 4 roles
│
├── spec/                    LA ESPECIFICACIÓN — es la verdad
│   ├── 00_RECONCILIACION.md Manda sobre el resto. Léelo primero
│   ├── 01_SETUP.md          Comandos exactos para montar el entorno
│   ├── 02_CONTRATOS.md      Tipos y formas de datos
│   ├── 03_EDGE_FUNCTIONS.md Cada función con su entrada y salida
│   ├── 04_PANTALLAS.md      Las 31 pantallas del v10, los 4 roles
│   ├── 05_PRUEBAS.md        Qué probar y cómo
│   └── 06_IDENTIDAD_VISUAL.md  Colores, tipografía, voz y tono
│
├── supabase/
│   ├── migrations/          ⚠️ vacía · la siguiente es la 034, no la 017
│   ├── functions/           1 de las 13 desplegadas · faltan 12 por descargar
│   └── seed/                Datos de prueba
│
├── entrega/                 ⭐ PARA EL EQUIPO DE DESARROLLO — fase0/ y fase1/
├── metodologia/             POR QUÉ el modelo es así — modelo, medición, producción
├── plan/                    El sprint vigente y el alcance completo
├── marca/                   Logos y referencia visual oficial
├── docs/                    Contexto de negocio, auditoría y decisiones
└── _archivo/                Histórico. NO es fuente de verdad
```

**Jerarquía cuando dos cosas se contradicen:**
estado real de `zr-prod` › `spec/00_RECONCILIACION.md` › `plan/06_ENTREGABLE.md` ›
prototipo v10 › `spec/` › `docs/`

La versión larga está en [`INGENIERIA.md`](INGENIERIA.md) §11.

---

## Stack

Next.js (App Router) + TypeScript · Supabase (Postgres, Auth, Storage, Edge Functions) ·
Tailwind · PWA instalable · Vercel

**No se usa:** FlutterFlow, Retool, n8n, Firebase ni ningún ORM.

---

## Arrancar en local

> ⚠️ **La aplicación Next.js todavía no existe** — cero líneas. El primer paso real del
> proyecto es crearla. Ver [`plan/07_ALCANCE_V10.md`](plan/07_ALCANCE_V10.md) §3, épico A.

```bash
npm install && supabase start && supabase db reset && npm run dev
```

Detalle completo, requisitos previos y variables de entorno en [`spec/01_SETUP.md`](spec/01_SETUP.md).

> ⚠️ **El CLI de Supabase de la máquina de desarrollo está autenticado con una cuenta que no
> ve `zr-prod`.** Sin resolverlo no se puede hacer `link`, `db pull` ni `functions deploy`.

---

## Antes de cada Pull Request

```bash
npm run verify
```

Ejecuta comprobación de tipos, linter, pruebas y **pruebas de acceso cruzado**. Estas últimas
verifican que un estudiante no puede leer los datos de otro. **Si fallan, no se publica** —
la base contiene datos personales de menores de edad y eso lo regula la LOPNNA.

---

## Reglas que no se rompen

1. Nadie sube directo a `main`. Todo pasa por Pull Request.
2. Nadie despliega el día antes de una clase real.
3. Nadie edita una migración ya aplicada; se crea una nueva.
4. Ninguna tabla se crea sin RLS y sin su prueba de acceso cruzado.
5. Ningún número de negocio va escrito en el código: vive en `system_config`.
6. Las claves nunca se comparten por chat.

Las diez reglas completas están en [`AGENTS.md`](AGENTS.md) §2.

---

## Recursos que no viven en el repositorio

| Qué | Dónde |
|---|---|
| Claves de Supabase, Vercel y GitHub | Gestor de contraseñas compartido (Bitwarden) |
| Manual de identidad completo (PDF, 23 MB) | `C:\Proyectos\Marcas\ZR Mecademy\IdentidadZRMecademy2025\` |
| Fuentes de Illustrator y Photoshop | Misma carpeta |

En `marca/referencia/` están las tres páginas del manual que de verdad se consultan: paleta,
tipografías y usos del logo.

---

*Repositorio privado. Contiene datos y documentación interna de ZR Mecademy.*
