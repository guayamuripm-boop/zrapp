// lib/validators.ts — Esquemas de validación exactos según spec/02_CONTRATOS.md §4

import { z } from 'zod';

// Cédula venezolana: V o E, guion, 6 a 9 dígitos.
export const cedulaSchema = z
  .string()
  .trim()
  .toUpperCase()
  .regex(/^[VE]-\d{6,9}$/, 'La cédula debe tener el formato V-12345678');

export const passwordSchema = z
  .string()
  .min(8, 'La contraseña debe tener al menos 8 caracteres');

export const loginSchema = z.object({
  cedula: cedulaSchema,
  password: z.string().min(1, 'La contraseña es obligatoria'),
});

export const registroSchema = z.object({
  fullName: z.string().trim().min(3, 'Escribe tu nombre completo'),
  cedula: cedulaSchema,
  contactEmail: z.string().trim().email('Escribe un correo válido'),
  phone: z.string().trim().optional(),
  birthDate: z.coerce.date(),
  password: passwordSchema,
  confirmPassword: z.string(),
}).refine((data) => data.password === data.confirmPassword, {
  message: 'Las contraseñas no coinciden',
  path: ['confirmPassword'],
});

export const consentimientoSchema = z.object({
  representativeName: z.string().trim().min(3, 'Nombre del representante obligatorio'),
  representativeCedula: cedulaSchema,
  representativeEmail: z.string().trim().email('Correo del representante obligatorio'),
  representativePhone: z.string().trim().optional(),
  method: z.enum(['fisico', 'digital']),
  documentUrl: z.string().url().optional(),
}).refine((data) => data.method !== 'digital' || data.documentUrl, {
  message: 'Debes subir el documento firmado',
  path: ['documentUrl'],
});

export const escaneoSchema = z.object({
  sessionId: z.string().uuid('ID de sesión inválido'),
  qrCode: z.string().regex(/^ZR1\|[VE]-\d{6,9}\|\d{6}$/, 'Código QR con formato inválido'),
  scannedAt: z.string().datetime(),
  deviceId: z.string().min(1, 'ID de dispositivo obligatorio'),
});

export const examenSchema = z.object({
  moduleId: z.string().uuid(),
  cohortId: z.string().uuid().nullable(),
  title: z.string().trim().min(5, 'Título mínimo 5 caracteres'),
  maxScore: z.number().int().min(1).max(100),
  timeLimitMinutes: z.number().int().positive().nullable(),
  opensAt: z.string().datetime().nullable(),
  closesAt: z.string().datetime().nullable(),
});

export const preguntaSchema = z.object({
  type: z.enum(['opcion_multiple', 'verdadero_falso', 'redaccion_abierta']),
  statement: z.string().trim().min(10, 'Enunciado mínimo 10 caracteres'),
  options: z.array(z.object({ key: z.string(), text: z.string() })).min(2).max(6).nullable(),
  correctAnswer: z.union([
    z.object({ key: z.string() }),
    z.object({ value: z.boolean() }),
    z.null(),
  ]),
  points: z.number().int().min(1),
  rubric: z.string().nullable(),
}).refine((data) => {
  if (data.type === 'opcion_multiple') {
    return data.options && data.options.length >= 2 && 'key' in (data.correctAnswer || {});
  }
  if (data.type === 'verdadero_falso') {
    return data.correctAnswer && 'value' in data.correctAnswer;
  }
  if (data.type === 'redaccion_abierta') {
    return data.correctAnswer === null;
  }
  return false;
}, {
  message: 'La respuesta correcta no coincide con el tipo de pregunta',
  path: ['correctAnswer'],
});

export const calificacionSchema = z.object({
  score: z.number().min(0),
  comment: z.string().optional(),
});

export const contenidoSchema = z.object({
  moduleId: z.string().uuid(),
  weekNumber: z.number().int().positive().nullable(),
  title: z.string().trim().min(3),
  type: z.enum(['pdf', 'video', 'enlace']),
  url: z.string().url(),
  publishedAt: z.string().datetime().nullable(),
});

export const configSchema = z.record(z.unknown());

// Tipos inferidos
export type LoginInput = z.infer<typeof loginSchema>;
export type RegistroInput = z.infer<typeof registroSchema>;
export type ConsentimientoInput = z.infer<typeof consentimientoSchema>;
export type EscaneoInput = z.infer<typeof escaneoSchema>;
export type ExamenInput = z.infer<typeof examenSchema>;
export type PreguntaInput = z.infer<typeof preguntaSchema>;
export type CalificacionInput = z.infer<typeof calificacionSchema>;
export type ContenidoInput = z.infer<typeof contenidoSchema>;