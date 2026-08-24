-- Migración 016: Tabla de control de QR para flujo de "código que cambia cada escaneo"
-- Propósito: Controlar qué códigos QR han sido usados y cuáles están disponibles
-- Esto permite el flujo donde la admin muestra un QR, el estudiante escanea,
-- y el código "muere" al usarse, cambiándose automáticamente.

-- Habilitar Row Level Security en la tabla (regla absolutA del proyecto)
ALTER TABLE qr_codes ENABLE ROW LEVEL SECURITY;

-- Crear la tabla qr_codes si no existe
CREATE TABLE IF NOT EXISTS qr_codes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES class_sessions(id) ON DELETE CASCADE,
  student_cedula VARCHAR(15) NOT NULL,
  code_value VARCHAR(50) NOT NULL,
  used BOOLEAN DEFAULT false,
  used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  
  -- Restricción única: un código QR solo puede usarse una vez por sesión
  CONSTRAINT uq_qr_session_code UNIQUE (session_id, code_value)
);

-- Comentar la tabla para documentación
COMMENT ON TABLE qr_codes IS 'Control de códigos QR para asistencia. Cada código se usa una sola vez por sesión.';

-- Crear índices para búsquedas eficientes
-- Índice principal: encontrar QR no usados por sesión (el caso más común en validate-scan)
CREATE INDEX IF NOT EXISTS idx_qr_codes_session_used ON qr_codes (session_id, used ASC, created_at DESC);

-- Índice auxiliar: buscar por cédula de estudiante (para auditoría)
CREATE INDEX IF NOT EXISTS idx_qr_codes_cedula ON qr_codes (student_cedula);

-- Crear políticas de Row Level Security (RLS)

-- Política 1: Estudiantes solo pueden ver sus propios códigos QR (para privacidad)
-- Esto asume que se configura el contexto adecuado o se usa desde el servidor
CREATE POLICY "students_view_own_qr" ON qr_codes
  FOR SELECT USING (student_cedula = current_setting('app.current_cedula', true));

-- Política 2: El personal (profesor, admin, super_admin) puede gestionar todos los QR
-- Para usar esta política, el rol debe verificarse en la aplicación
CREATE POLICY "staff_manage_qr" ON qr_codes
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.role IN ('profesor', 'admin', 'super_admin')
    )
  );

-- Política 3: Los administradores pueden insertar y actualizar todos los QR
CREATE POLICY "admin_insert_qr" ON qr_codes
  FOR INSERT WITH CHECK (true);

-- Política 4: Los administradores pueden actualizar el estado usado
CREATE POLICY "admin_update_qr_used" ON qr_codes
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.role IN ('admin', 'super_admin')
    )
  );

-- Insertar registros de prueba iniciales (opcional - se llenará dinámicamente)
-- NOTA: Estos serán creados dinámicamente por la aplicación cuando inicie una sesión
-- INSERT INTO qr_codes (session_id, student_cedula, code_value, used, created_at)
-- VALUES 
--   ('00000000-0000-0000-0000-000000000000', 'V-30000001', 'ZR1|00000000-0000-0000-0000-000000000000|V-30000001', false, now()),
--   ('00000000-0000-0000-0000-000000000000', 'V-30000002', 'ZR1|00000000-0000-0000-0000-000000000001|V-30000002', false, now());

-- Comentario final
-- === FLUJO DE TRABAJO ===
-- 1. Admin/Director entra a /hoy y ve un QR grande en pantalla: ZR1|<session-uuid>|<V-XXXXXXXX>
-- 2. Estudiante va a oficina de administración, uno por uno
-- 3. Estudiante escanea QR con su teléfono (cámara + lector de códigos)
-- 4. Sistema valida: ¿existe el estudiante? ¿Pertenece a la cohorte? ¿QR ya usado?
-- 5. Si es válido: ✓ Asistencia registrada, el código "muere" ya no sirve
-- 6. Sistema genera y muestra un NUEVO QR al instante
-- 7. Siguiente estudiante escanea el nuevo código
-- 8. Al finalizar el día, la sesión se cierra y todos los QR usados quedan registrados
-- === FIN DEL FLUJO ===