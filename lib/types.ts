// lib/types.ts — Tipos de negocio exactos según spec/02_CONTRATOS.md

export type UserRole = 'estudiante' | 'profesor' | 'admin' | 'super_admin';

export type Profile = {
  id: string;
  full_name: string;
  cedula: string;
  avatar_url: string | null;
  role: UserRole;
  status: 'activo' | 'suspendido' | 'baja';
  created_at: string;
  updated_at: string;
};

export type Student = {
  id: string;
  birth_date: string;
  cohort_id: string | null;
  onboarding_status: 'en_curso' | 'completo' | 'bloqueado';
  qr_secret: string | null;
  created_at: string;
  updated_at: string;
};

export type StudentView = Student & {
  full_name: string;
  cedula: string;
  contact_email: string;
  phone: string | null;
  age: number;
  is_minor: boolean;
  cohort_name: string | null;
  module_name: string | null;
  consent_verified: boolean | null;
};

export type Teacher = {
  id: string;
  specialties: string[];
  created_at: string;
  updated_at: string;
};

export type Cohort = {
  id: string;
  program_id: string;
  name: string;
  current_module_id: string | null;
  teacher_id: string | null;
  location: string | null;
  start_date: string;
  created_at: string;
  updated_at: string;
};

export type Module = {
  id: string;
  program_id: string;
  order_index: number;
  name: string;
  duration_weeks: number;
  inces_homologado: boolean;
  created_at: string;
  updated_at: string;
};

export type LearningGuide = {
  id: string;
  module_id: string;
  week_number: number;
  order_in_week: number;
  sub_competency_name: string;
  pre_practice_description: string | null;
  practice_description: string | null;
  digitized: boolean;
  created_at: string;
  updated_at: string;
};

export type ClassSession = {
  id: string;
  cohort_id: string;
  module_id: string | null;
  teacher_id: string | null;
  session_date: string;
  week_number: number;
  status: 'programada' | 'abierta' | 'cerrada' | 'cancelada';
  created_at: string;
  updated_at: string;
};

export type Enrollment = {
  id: string;
  student_id: string;
  module_id: string;
  cohort_id: string;
  passing_threshold: number;
  theory_score: number | null;
  practice_score: number | null;
  participation_score: number | null;
  final_score: number | null;
  status: 'en_curso' | 'aprobado' | 'reprobado';
  created_at: string;
  updated_at: string;
};

export type AttendanceEvent = {
  id: string;
  session_id: string;
  student_id: string;
  method: 'qr' | 'manual';
  status: 'asistencia' | 'refrigerio' | 'ambos';
  scanned_at: string;
  device_id: string;
  created_at: string;
};

export type Exam = {
  id: string;
  module_id: string;
  cohort_id: string | null;
  teacher_id: string;
  title: string;
  status: 'borrador' | 'habilitado' | 'cerrado' | 'calificado';
  max_score: number;
  time_limit_minutes: number | null;
  opens_at: string | null;
  closes_at: string | null;
  created_at: string;
  updated_at: string;
};

export type ExamQuestion = {
  id: string;
  exam_id: string;
  order_index: number;
  type: 'opcion_multiple' | 'verdadero_falso' | 'redaccion_abierta';
  statement: string;
  options: QuestionOption[] | null;
  correct_answer: CorrectAnswer;
  points: number;
  rubric: string | null;
  created_at: string;
  updated_at: string;
};

export type QuestionOption = { key: string; text: string };

export type CorrectAnswer =
  | { key: string }        // opcion_multiple
  | { value: boolean }     // verdadero_falso
  | null;                  // redaccion_abierta

export type StudentQuestion = Omit<ExamQuestion, 'correct_answer'> & {
  exam_id: string;
};

export type ExamAttempt = {
  id: string;
  exam_id: string;
  student_id: string;
  started_at: string;
  submitted_at: string | null;
  score: number | null;
  status: 'en_progreso' | 'entregado' | 'calificado';
  created_at: string;
  updated_at: string;
};

export type ExamAnswer = {
  id: string;
  attempt_id: string;
  question_id: string;
  answer: StudentAnswer;
  score: number | null;
  comment: string | null;
  created_at: string;
  updated_at: string;
};

export type StudentAnswer =
  | { key: string }
  | { value: boolean }
  | { text: string };

export type ContentItem = {
  id: string;
  module_id: string;
  week_number: number | null;
  title: string;
  type: 'pdf' | 'video' | 'enlace';
  url: string;
  size_bytes: number | null;
  published_at: string | null;
  created_at: string;
  updated_at: string;
};

export type Notification = {
  id: string;
  user_id: string;
  title: string;
  body: string;
  read: boolean;
  created_at: string;
};

export type ParentalConsent = {
  id: string;
  student_id: string;
  consent_type: 'account_creation' | 'data_processing' | 'image_rights';
  representative_name: string;
  representative_cedula: string;
  representative_email: string;
  representative_phone: string | null;
  method: 'fisico' | 'digital';
  document_url: string | null;
  verified_at: string | null;
  created_at: string;
  updated_at: string;
};

export type FeedbackAnswer = { q: string; a: number }; // a va de 1 a 5

export type PendingScan = {
  localId: string;
  sessionId: string;
  qrCode: string;
  scannedAt: string;
  deviceId: string;
  synced: boolean;
  lastError?: string;
};

export type SystemConfig = {
  key: string;
  value: unknown;
  description: string;
  updated_by: string | null;
  updated_at: string;
};

// Vistas derivadas
export type VProximoSabado = {
  student_id: string;
  session_id: string;
  session_date: string;
  module_name: string;
  week_number: number;
  pre_practice_description: string | null;
};

export type VMiDominio = {
  student_id: string;
  module_id: string;
  module_name: string;
  week_number: number;
  sub_competency_name: string;
  status: 'dominado' | 'en_progreso' | 'no_iniciado';
  dominated_via: 'evaluacion_practica' | 'evaluacion_teorica' | 'autoevaluacion' | null;
  marked_at: string | null;
  marked_by: string | null;
};

export type VExamQuestionsStudent = Omit<ExamQuestion, 'correct_answer'>;

export type VStudents = StudentView;

export type VStudentsBlocked = StudentView & {
  block_reason: 'sin_consentimiento' | 'consentimiento_sin_verificar';
};