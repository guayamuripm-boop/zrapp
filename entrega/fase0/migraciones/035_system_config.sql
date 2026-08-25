-- ============================================================================
-- 035_system_config.sql
--
-- QUÉ HACE: crea las claves de configuración que el prototipo ya usa y que NO
--           existen en zr-prod.
--
-- POR QUÉ:  regla 5 del proyecto — ningún número de negocio se escribe en el
--           código. El prototipo v10 tiene cinco valores en su CONFIG que no
--           tienen dónde vivir en la base. Sin estas claves, el desarrollador
--           se ve obligado a escribirlos en duro. Ver spec/00 §6.1.
--
-- REVERSIÓN: borrar las claves insertadas. No hay pérdida de datos.
--
-- VERIFICADO: consultado system_config en vivo el 24 de agosto de 2026.
--   `value` es de tipo JSONB, no texto. Por eso los ::jsonb.
--
-- ⚠️ NOTA IMPORTANTE SOBRE NOMBRES
--   La base YA tiene los umbrales correctos, pero con otros nombres que los que
--   pedía spec/00:
--       module.passing_threshold_first    = 10   (aprueba el módulo 1)
--       module.passing_threshold_default  = 12   (aprueba del módulo 2 en adelante)
--       exam.max_score                    = 20   (la escala)
--   NO se renombran. Las 13 Edge Functions desplegadas leen esos nombres, y
--   renombrarlas las rompería todas. Se adopta lo que ya está en la base.
-- ============================================================================

begin;

insert into public.system_config (key, value, description, is_public) values

  -- --- Pesos de la nota práctica (Fase 1; se crean ahora para no volver) ----
  ('practica.peso_checklist', '0.70'::jsonb,
   'Cuánto pesa el checklist de pasos dentro de la nota práctica.', true),

  ('practica.peso_defensa', '0.30'::jsonb,
   'Cuánto pesa la defensa técnica oral dentro de la nota práctica.', true),

  -- --- Pesos de la nota del módulo -----------------------------------------
  ('modulo.peso_teoria', '0.50'::jsonb,
   'Cuánto pesa el examen teórico en la nota del módulo.', true),

  ('modulo.peso_practica', '0.50'::jsonb,
   'Cuánto pesa la evaluación práctica en la nota del módulo.', true),

  -- --- Umbral de dominio ----------------------------------------------------
  ('nota.umbral_dominada', '16'::jsonb,
   'A partir de qué nota una competencia se considera dominada. Por debajo del umbral de aprobación, requiere refuerzo.', true),

  -- --- Fase 0 ---------------------------------------------------------------
  ('fase0.casos_por_semana', '5'::jsonb,
   'Cuántos casos sintéticos se publican por semana, uno por día de lunes a viernes.', true),

  ('fase0.digest_preguntas', '3'::jsonb,
   'Cuántas preguntas resumen se le presentan al profesor a partir de las dudas de la semana.', true)

on conflict (key) do update
  set value       = excluded.value,
      description = excluded.description,
      is_public   = excluded.is_public;

commit;

-- ============================================================================
-- COMPROBACIÓN — debe devolver 7 filas:
--
--   select key, value from public.system_config
--    where key in ('practica.peso_checklist','practica.peso_defensa',
--                  'modulo.peso_teoria','modulo.peso_practica',
--                  'nota.umbral_dominada','fase0.casos_por_semana',
--                  'fase0.digest_preguntas')
--    order by key;
--
-- Y que los pesos sumen 1:
--   practica.peso_checklist + practica.peso_defensa = 1.00
--   modulo.peso_teoria      + modulo.peso_practica  = 1.00
-- ============================================================================
