-- ============================================================================
-- seed_fase0.sql — DATOS DE PRUEBA
--
-- Para local y para zr-dev. ⚠️ NUNCA se corre en zr-prod.
--
-- Sirve para que el desarrollador levante la app y vea algo en pantalla desde
-- el primer día, sin depender de que llegue el contenido real.
--
-- Los casos son los mismos del prototipo. Siguen la regla de fase0/03_CASOS.md
-- §1: conceptuales, sobre cómo razonar y por dónde empezar. Ni una cifra.
--
-- REQUISITO: haber aplicado 000_esquema_base + 034 + 035 + 036.
-- ============================================================================

begin;

-- ---------------------------------------------------------------------------
-- 0. Punteros a lo que ya existe. Ajustar si los nombres reales cambian.
-- ---------------------------------------------------------------------------
do $$
declare
  v_program uuid;
  v_module  uuid;
  v_cohort  uuid;
  v_session uuid;
begin

  select id into v_program from public.programs order by created_at limit 1;
  if v_program is null then
    raise exception 'No hay ningún programa. Carga primero el esquema base.';
  end if;

  -- Módulo de prueba de Fase 0 -----------------------------------------------
  insert into public.modules (program_id, order_index, name, description, duration_weeks, inces_homologado)
  values (v_program, 1, 'Módulo 1 · Introducción al diagnóstico',
          'Cómo razonar frente a una falla: qué observar, en qué orden revisar y cómo descartar.',
          4, false)
  on conflict do nothing;

  select id into v_module from public.modules
   where program_id = v_program and order_index = 1 limit 1;

  -- Cohorte de prueba --------------------------------------------------------
  insert into public.cohorts (program_id, name, current_module_id, location, start_date, status)
  values (v_program, 'Cohorte piloto · septiembre 2026', v_module, 'Sede principal',
          date '2026-09-05', 'activa')
  on conflict do nothing;

  select id into v_cohort from public.cohorts
   where name = 'Cohorte piloto · septiembre 2026' limit 1;

  -- Sesión del sábado del piloto --------------------------------------------
  insert into public.class_sessions (cohort_id, module_id, session_date, week_number, status)
  values (v_cohort, v_module, date '2026-09-05', 1, 'programada')
  on conflict do nothing;

  select id into v_session from public.class_sessions
   where cohort_id = v_cohort and session_date = date '2026-09-05' limit 1;

  -- =========================================================================
  -- COMPETENCIAS DEL MÓDULO — lista, sin estado
  -- =========================================================================
  insert into public.module_competencies (module_id, position, title, description) values
    (v_module, 1, 'Recoger la información del cliente',
     'Preguntar de forma que la respuesta sirva para diagnosticar, no solo para conversar.'),
    (v_module, 2, 'Formular una hipótesis y sostenerla',
     'Decir qué crees que pasa y en qué observación concreta te apoyas.'),
    (v_module, 3, 'Ordenar las revisiones',
     'Empezar por lo visible y lo reversible, y dejar lo caro e irreversible para el final.'),
    (v_module, 4, 'Descartar con criterio',
     'Elegir la comprobación que elimina más caminos, no la que confirma tu corazonada.'),
    (v_module, 5, 'Distinguir causa de efecto',
     'Reconocer cuándo una pieza dañada es la víctima de otra cosa que sigue ahí.'),
    (v_module, 6, 'Trabajar con seguridad',
     'Aplicar las normas del taller antes de tocar nada, siempre y sin excepción.')
  on conflict (module_id, position) do nothing;

  -- =========================================================================
  -- LOS CINCO CASOS DE LA SEMANA 1 · lunes 7 a viernes 11 de septiembre
  -- Cargados como APROBADOS para que se vean en desarrollo.
  -- ⚠️ En producción, approved_at solo se pone tras la revisión del profesor.
  -- =========================================================================

  insert into public.cases (module_id, cohort_id, publish_on, week_number, title, scenario,
    step1_prompt, step1_options, step2_prompt, step2_options, step3_prompt, reference, approved_at) values

  (v_module, v_cohort, date '2026-09-07', 1,
   'El carro que arranca flojo en la mañana',
   'Un cliente trae su carro. Dice que en la mañana, cuando arranca por primera vez, el motor «se demora y suena flojo», pero que si lo intenta una segunda vez arranca bien. En la tarde nunca le ha pasado.',
   '¿Cuál es tu primera hipótesis?',
   '[{"texto":"El sistema de arranque no está recibiendo suficiente energía","correcta":true},
     {"texto":"El motor de arranque está dañado y hay que cambiarlo","correcta":false},
     {"texto":"El combustible no está llegando bien","correcta":false},
     {"texto":"Es normal en las mañanas frías, no hay falla","correcta":false}]'::jsonb,
   '¿Qué revisarías primero?',
   '[{"texto":"El estado y la conexión de los bornes, antes de desconectar nada","correcta":true},
     {"texto":"Desmontar el motor de arranque para revisarlo","correcta":false},
     {"texto":"El filtro de combustible","correcta":false},
     {"texto":"Nada: le digo que lo deje encendido más tiempo","correcta":false}]'::jsonb,
   '¿Por qué crees que pasa en la mañana y no en la tarde? ¿Qué te dice que arranque al segundo intento?',
   'QUÉ ERA: el sistema de arranque no está recibiendo la energía que necesita. El patrón de «en frío falla, en caliente no» y de «al segundo intento sí» apunta a que la energía disponible está justo en el límite.

POR QUÉ NO LAS OTRAS:
· Motor de arranque dañado — si estuviera dañado fallaría también en la tarde. Una falla que depende de la temperatura y de la hora rara vez es una pieza rota; suele ser energía.
· Combustible — un problema de combustible no mejora al segundo intento inmediato, y normalmente también da síntomas con el motor caliente.
· Es normal — que arranque flojo no es normal. Es un aviso temprano, y cuesta mucho menos atenderlo ahora.

LO QUE HAY QUE LLEVARSE: antes de desmontar nada, se revisa lo que está a la vista y lo que es reversible.',
   now()),

  (v_module, v_cohort, date '2026-09-08', 1,
   'La luz que se pone débil al frenar',
   'Una clienta dice que cuando frena de noche, las luces del tablero «se ponen flojas» por un momento y luego vuelven. El carro nunca se ha apagado y arranca sin problema.',
   '¿Cuál es tu primera hipótesis?',
   '[{"texto":"Hay una conexión con mala calidad en el circuito, que se nota cuando sube la demanda","correcta":true},
     {"texto":"Las luces del tablero están quemadas","correcta":false},
     {"texto":"El sistema de frenos está fallando","correcta":false},
     {"texto":"Es un defecto normal de fábrica del modelo","correcta":false}]'::jsonb,
   '¿Qué revisarías primero?',
   '[{"texto":"Los puntos de conexión y las masas, buscando suciedad, holgura o corrosión","correcta":true},
     {"texto":"Cambiar todas las luces del tablero","correcta":false},
     {"texto":"Purgar el sistema de frenos","correcta":false},
     {"texto":"Nada, porque el carro funciona","correcta":false}]'::jsonb,
   '¿Por qué el síntoma aparece justo al frenar y no en otro momento?',
   'QUÉ ERA: casi siempre es una conexión de mala calidad. Al frenar de noche se suman varios consumos a la vez, y una conexión floja o sucia que aguantaba con poca demanda deja de aguantar cuando la demanda sube.

POR QUÉ NO LAS OTRAS:
· Luces quemadas — una luz quemada no vuelve. El síntoma que aparece y desaparece apunta a conexión, no a la pieza.
· Sistema de frenos — el freno solo es el disparador porque activa un consumo. El problema no está en el freno.
· Defecto de fábrica — es la respuesta que cierra la puerta a buscar. Si el carro funcionó bien antes, algo cambió.

LO QUE HAY QUE LLEVARSE: un síntoma que aparece cuando sube la demanda y se corrige solo casi nunca es una pieza rota.',
   now()),

  (v_module, v_cohort, date '2026-09-09', 1,
   'Dos mecánicos, dos diagnósticos',
   'Un carro entra con una falla. Un compañero dice que es una cosa; otro dice que es otra distinta. Los dos tienen argumentos y ninguno ha medido nada todavía. El cliente está esperando.',
   '¿Qué haces primero?',
   '[{"texto":"Preguntar qué observación concreta sostiene cada hipótesis","correcta":true},
     {"texto":"Hacerle caso al que tiene más años de experiencia","correcta":false},
     {"texto":"Empezar a desarmar por donde dice el primero","correcta":false},
     {"texto":"Decirle al cliente que vuelva mañana","correcta":false}]'::jsonb,
   '¿Cómo decides por dónde seguir?',
   '[{"texto":"Por la revisión que descarte más posibilidades de una vez, aunque no confirme ninguna","correcta":true},
     {"texto":"Por la que sea más rápida de hacer","correcta":false},
     {"texto":"Por la que confirme la hipótesis que a ti te parece correcta","correcta":false},
     {"texto":"Por la que menos ensucie","correcta":false}]'::jsonb,
   'Explica por qué conviene más una revisión que descarta varias causas que una que confirma solo una.',
   'QUÉ ERA: se le pide a cada uno la observación concreta en la que se apoya, y después se elige la revisión que descarte más caminos de una vez. Diagnosticar es cerrar puertas en orden.

POR QUÉ NO LAS OTRAS:
· Los años de experiencia — ayudan a generar buenas hipótesis, no a saltarse la comprobación.
· Empezar a desarmar — es la decisión más cara y la menos reversible. Se toma al final.
· Que vuelva mañana — no resuelve nada y pierde al cliente. La duda entre dos hipótesis es el trabajo, no un obstáculo.

LO QUE HAY QUE LLEVARSE: la revisión que más vale no es la que confirma una hipótesis: es la que elimina más.',
   now()),

  (v_module, v_cohort, date '2026-09-10', 1,
   'Lo que el cliente no cuenta',
   'Llega un carro con una falla que aparece «de vez en cuando». El cliente no sabe decir cuándo. Tú no puedes reproducirla en el taller: probaste media hora y funcionó perfecto todo el tiempo.',
   '¿Cuál es tu mejor jugada?',
   '[{"texto":"Preguntarle al cliente por el contexto: hora, clima, carga, qué estaba haciendo","correcta":true},
     {"texto":"Decirle que no tiene nada, porque no falló","correcta":false},
     {"texto":"Cambiar la pieza que más suele fallar en ese modelo","correcta":false},
     {"texto":"Dejarlo encendido todo el día a ver si pasa","correcta":false}]'::jsonb,
   '¿Cuál de estas preguntas sirve más?',
   '[{"texto":"¿Pasa más cuando el carro lleva rato apagado, o cuando ya lleva rato andando?","correcta":true},
     {"texto":"¿Usted cree que es caro?","correcta":false},
     {"texto":"¿Quién se lo arregló la última vez?","correcta":false},
     {"texto":"¿Qué marca de repuestos prefiere?","correcta":false}]'::jsonb,
   '¿Por qué una falla intermitente que depende del contexto es una pista y no un obstáculo?',
   'QUÉ ERA: se investiga el contexto. Una falla intermitente casi nunca es aleatoria: depende de algo — la temperatura, el tiempo andando, la carga. Ese algo es la pista más valiosa, y el único que lo vio es el cliente.

POR QUÉ NO LAS OTRAS:
· «No tiene nada» — que no falle en media hora no significa que no falle. Significa que no reprodujiste la condición.
· Cambiar la pieza que más falla — es adivinar con el dinero del cliente. Y si acierta por suerte, no aprendiste nada.
· Dejarlo encendido todo el día — gasta un día sin controlar la variable que importa.

LO QUE HAY QUE LLEVARSE: el cliente es el único testigo de la falla. Saber preguntarle es una habilidad técnica.',
   now()),

  (v_module, v_cohort, date '2026-09-11', 1,
   'La reparación que duró tres días',
   'Un carro vuelve al taller. Hace tres días se reparó lo que se diagnosticó, el cliente se fue contento, y ahora está de vuelta con el mismo síntoma.',
   '¿Qué es lo más probable?',
   '[{"texto":"Se trató un efecto y no la causa que lo produce","correcta":true},
     {"texto":"El repuesto que se puso venía malo","correcta":false},
     {"texto":"El cliente hizo algo mal","correcta":false},
     {"texto":"Es mala suerte","correcta":false}]'::jsonb,
   '¿Por dónde empiezas ahora?',
   '[{"texto":"Por revisar qué evidencia sostuvo el diagnóstico anterior, y qué no se comprobó","correcta":true},
     {"texto":"Por repetir la misma reparación con otro repuesto","correcta":false},
     {"texto":"Por revisar todo el carro desde cero, ignorando lo anterior","correcta":false},
     {"texto":"Por cobrarle de nuevo la revisión","correcta":false}]'::jsonb,
   'Explica la diferencia entre tratar un efecto y tratar la causa. Da un ejemplo tuyo.',
   'QUÉ ERA: lo más probable es que se atendió un efecto y no la causa. Una pieza que se daña puede ser la víctima de otra cosa que sigue ahí. El tiempo que tarda en volver suele ser la pista de qué es.

POR QUÉ NO LAS OTRAS:
· Repuesto malo — ocurre, pero es la primera explicación que uno quiere creer porque no obliga a revisar el propio razonamiento. Se comprueba, no se asume.
· Culpa del cliente — cierra la investigación y daña la relación. Si el uso rompe la reparación, eso también es parte del diagnóstico.
· Mala suerte — no es una categoría técnica. Todo lo que vuelve tiene una razón.

LO QUE HAY QUE LLEVARSE: un trabajo que vuelve es la información más honesta del oficio. Se revisa el razonamiento, no la pieza.',
   now())

  on conflict do nothing;

  raise notice 'Seed de Fase 0 cargado. Módulo: %, Cohorte: %, Sesión: %', v_module, v_cohort, v_session;
end $$;

commit;

-- ============================================================================
-- LO QUE ESTE SEED NO TRAE, A PROPÓSITO
--
-- · Estudiantes. Se crean con la Edge Function `create-student`, que además
--   crea el usuario de autenticación. Insertarlos a mano deja perfiles sin
--   poder iniciar sesión.
-- · Dudas de ejemplo. Se generan usando la app, que es como se prueban de verdad.
-- · Material. Son archivos: se suben por la pantalla de administración.
--
-- COMPROBACIÓN
--   select count(*) from public.cases;                 -- 5
--   select count(*) from public.module_competencies;   -- 6
-- ============================================================================
