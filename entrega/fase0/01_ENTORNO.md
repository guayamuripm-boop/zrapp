# 01 · ENTORNO — DE CERO A CORRIENDO

> Comandos exactos. Todo gratuito — ver `entrega/01_TODO_GRATIS.md`.

---

## 1. REQUISITOS

| Qué | Versión | Para qué |
|---|---|---|
| **Node.js** | 20 o superior | La aplicación |
| **Docker Desktop** | Última | Levantar Supabase en local. **Tiene que estar corriendo** |
| **Supabase CLI** | Última | Migraciones y funciones |
| **Git** | Cualquiera | — |

```bash
node -v
docker --version
supabase --version
```

Si falta la CLI de Supabase:

```bash
npm install -g supabase
```

---

## 2. CLONAR

```bash
git clone https://github.com/guayamuripm-boop/zrapp.git
cd zrapp
```

**Lee `entrega/00_EMPIEZA_AQUI.md` antes de escribir nada.**

---

## 3. CREAR EL PROYECTO NEXT.JS

⚠️ **Todavía no existe.** El repositorio hoy tiene la especificación, los prototipos y las
migraciones, pero **cero líneas de aplicación**. Esto se crea en la raíz:

```bash
npx create-next-app@latest . --typescript --tailwind --app --eslint --src-dir=false --import-alias="@/*"
```

Cuando pregunte si sobrescribe archivos existentes, **di que no a todo lo que ya está**
(`README.md`, `.gitignore`).

### 3.1 Dependencias del proyecto

```bash
npm install @supabase/supabase-js @supabase/ssr @zxing/browser qrcode
npm install -D vitest @vitest/coverage-v8 @playwright/test @types/qrcode
```

### 3.2 Las tipografías van dentro del proyecto

**Roboto y Raleway se instalan como archivos locales, nunca desde un CDN.**
Sin señal en el taller, una tipografía externa no carga y la app se ve rota.

Next.js las sirve desde el propio proyecto con `next/font/local`.
Detalle en `spec/06_IDENTIDAD_VISUAL.md` §5.

---

## 4. VARIABLES DE ENTORNO

Crear `.env.local` en la raíz. **Nunca se sube al repositorio** — ya está en `.gitignore`.

```bash
# Apunta a zr-dev mientras se desarrolla. NUNCA a zr-prod.
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
```

| Variable | Puede ir al navegador | Dónde se usa |
|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | ✅ Sí | Todos lados |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | ✅ Sí | Cliente de navegador |
| `SUPABASE_SERVICE_ROLE_KEY` | ⛔ **JAMÁS** | Solo servidor y Edge Functions |

> ## ⚠️ SOBRE `service_role`
> Esa clave **se salta todo el aislamiento de la base**. Con ella, cualquiera lee y modifica
> los datos de los 100 estudiantes, incluidos menores de edad.
>
> - Nunca en un archivo con `NEXT_PUBLIC_`
> - Nunca importada desde un componente de cliente
> - Nunca en un commit
>
> El CI tiene una comprobación que falla el despliegue si aparece en el paquete del navegador.

Los valores se piden por el gestor de contraseñas. **Nunca por chat ni por correo.**
Ver `02_CONEXIONES.md`.

---

## 5. LEVANTAR SUPABASE EN LOCAL

Con Docker corriendo:

```bash
supabase start
```

Imprime `API URL`, `anon key` y `service_role key` **locales**. Esos son los que van en
`.env.local` para trabajar sin tocar ninguna base remota.

### 5.1 ⚠️ Antes de `db reset` hace falta el esquema base

`supabase/migrations/` está **vacía**. Las migraciones 001-016 se archivaron porque nunca se
aplicaron a `zr-prod`, que va por la **033**.

**Primera tarea de base de datos (F0-05):** volcar el esquema real de `zr-prod` a
`supabase/migrations/000_esquema_base.sql`.

```bash
supabase link --project-ref <ref-de-zr-dev>
supabase db pull
```

Hasta que eso exista, `supabase db reset` deja la base vacía.

### 5.2 Después, el ciclo normal

```bash
supabase db reset      # borra local, aplica migraciones en orden, carga el seed
```

Copiar las migraciones de `entrega/fase0/migraciones/` a `supabase/migrations/`
**después** del `000_esquema_base.sql`, y el seed a `supabase/seed/`.

---

## 6. GENERAR LOS TIPOS DE TYPESCRIPT

Cada vez que cambie el esquema:

```bash
supabase gen types typescript --local > lib/database.types.ts
```

**Nunca se escriben a mano.** Si el tipo no coincide con la base, el error aparece en
producción, no al compilar.

---

## 7. SCRIPTS DE `package.json`

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "typecheck": "tsc --noEmit",
    "test": "vitest run",
    "test:rls": "vitest run tests/rls",
    "db:reset": "supabase db reset",
    "db:types": "supabase gen types typescript --local > lib/database.types.ts",
    "verify": "npm run typecheck && npm run lint && npm run test && npm run test:rls && npm run build"
  }
}
```

**`npm run verify` es el comando que decide si una tarea está terminada.**

---

## 8. ALMACENAMIENTO DE ARCHIVOS

Un bucket para los PDF del material:

| Nombre | Acceso |
|---|---|
| `material` | **Privado** |

> **Privado, no público.** Un PDF público es una URL que circula por WhatsApp sin control.
> El estudiante lo abre con una URL firmada de duración corta que genera el servidor.

Se crea desde el panel de Supabase, o con SQL en una migración.

---

## 9. DESPLEGAR

1. Conectar el repositorio al servicio de alojamiento (ver `entrega/01_TODO_GRATIS.md` §3).
2. Cargar las tres variables de entorno **en el panel del servicio**, no en el repositorio.
3. Cada push a `main` despliega solo.

**HTTPS viene incluido y es obligatorio:** sin él la cámara no funciona.

---

## 10. VERIFICACIÓN FINAL DEL ENTORNO

Antes de tomar la primera tarea, todo esto tiene que pasar:

- [ ] `npm run dev` levanta y se ve la app en `localhost:3000`
- [ ] `supabase start` levanta sin errores
- [ ] `npm run typecheck` pasa
- [ ] Existe `.env.local` y **no** aparece en `git status`
- [ ] `lib/database.types.ts` está generado
- [ ] La app desplegada abre por **HTTPS** desde un teléfono
- [ ] **La cámara del teléfono pide permiso y lee un QR** ← F0-01

El último es el que importa. Los demás son preparación.
