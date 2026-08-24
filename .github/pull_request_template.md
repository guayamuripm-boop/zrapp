## Tarea
T-___

## Qué hace


## Verificación
- [ ] `npm run verify` pasa
- [ ] Si toca la base: migración nueva versionada, **nunca** editando una ya aplicada
- [ ] Si crea tabla: RLS habilitada + política escrita + prueba de acceso cruzado
- [ ] Probado en un teléfono real, no solo en el navegador de escritorio
- [ ] Ningún número de negocio escrito en duro (van en `system_config`)
- [ ] `SUPABASE_SERVICE_ROLE_KEY` no aparece en código que llega al navegador
- [ ] Camino feliz **y** camino de error, ambos probados
- [ ] El linter de seguridad no reporta ningún hallazgo nuevo de nivel `ERROR`

## Notas para quien revisa


---
<!-- Recuerda: nadie aprueba su propio PR. No se despliega el día antes de una clase real. -->
