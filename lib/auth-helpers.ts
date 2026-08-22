// lib/auth-helpers.ts — Helpers de autenticación según spec/02_CONTRATOS.md §5, §7

import type { UserRole, Profile } from './types';

// Convierte cédula a correo sintético para Supabase Auth
export function cedulaAEmail(cedula: string): string {
  return `${cedula.trim().toUpperCase()}@estudiante.zrmecademy.com`;
}

// Convierte correo sintético de vuelta a cédula
export function emailACedula(email: string): string {
  return email.replace('@estudiante.zrmecademy.com', '');
}

// Calcula edad a partir de fecha de nacimiento
export function calcularEdad(birthDate: string): number {
  const today = new Date();
  const birth = new Date(birthDate);
  let age = today.getFullYear() - birth.getFullYear();
  const m = today.getMonth() - birth.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < birth.getDate())) {
    age--;
  }
  return age;
}

// Verifica si es menor de edad (15-17 años)
export function esMenorDeEdad(birthDate: string): boolean {
  const age = calcularEdad(birthDate);
  return age >= 15 && age < 18;
}

// Verifica si el rol es personal (profesor, admin, super_admin)
export function esPersonal(role?: UserRole | null): boolean {
  return role === 'profesor' || role === 'admin' || role === 'super_admin';
}

// Verifica si el rol es admin o super_admin
export function esAdmin(role?: UserRole | null): boolean {
  return role === 'admin' || role === 'super_admin';
}

// Verifica si el rol es super_admin
export function esSuperAdmin(role?: UserRole | null): boolean {
  return role === 'super_admin';
}

// Obtiene la ruta de redirección según el rol
export function getRedirectPath(role?: UserRole | null): string {
  switch (role) {
    case 'estudiante':
      return '/carnet';
    case 'profesor':
      return '/hoy';
    case 'admin':
    case 'super_admin':
      return '/panel';
    default:
      return '/login';
  }
}

// Formatea cédula para mostrar (siempre con guion)
export function formatearCedula(cedula: string): string {
  const upper = cedula.trim().toUpperCase();
  if (upper.includes('-')) return upper;
  // Si viene sin guion, agregarlo después de la primera letra
  return upper.length > 1 ? `${upper[0]}-${upper.slice(1)}` : upper;
}

// Formatea fecha en español venezolano: "sáb 15 ago 2026"
export function formatearFecha(fecha: string): string {
  const date = new Date(fecha);
  const dias = ['dom', 'lun', 'mar', 'mié', 'jue', 'vie', 'sáb'];
  const meses = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
  return `${dias[date.getDay()]} ${date.getDate()} ${meses[date.getMonth()]} ${date.getFullYear()}`;
}

// Formatea hora en 24h: "08:30"
export function formatearHora(fecha: string): string {
  const date = new Date(fecha);
  return date.toLocaleTimeString('es-VE', { hour: '2-digit', minute: '2-digit', hour12: false });
}

// Formatea nota: un decimal, coma decimal, sobre 20
export function formatearNota(nota: number | null, maxScore: number = 20): string {
  if (nota === null) return '—';
  return `${nota.toFixed(1).replace('.', ',')} / ${maxScore}`;
}

// Formatea porcentaje sin decimales
export function formatearPorcentaje(valor: number): string {
  return `${Math.round(valor)}%`;
}

// Genera ID único simple para uso local (UUID v4 simplificado)
export function generarId(): string {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    const r = (Math.random() * 16) | 0;
    const v = c === 'x' ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

// Obtiene iniciales para avatar
export function getIniciales(nombre: string): string {
  return nombre
    .trim()
    .split(/\s+/)
    .map((n) => n[0])
    .slice(0, 2)
    .join('')
    .toUpperCase();
}

// Clase para manejar sesión en localStorage (mock)
export class MockAuth {
  private static readonly KEY = 'zrapp_session';
  
  static getSession(): { user: Profile; token: string } | null {
    if (typeof window === 'undefined') return null;
    try {
      const data = localStorage.getItem(this.KEY);
      return data ? JSON.parse(data) : null;
    } catch {
      return null;
    }
  }
  
  static setSession(user: Profile, token: string): void {
    if (typeof window === 'undefined') return;
    localStorage.setItem(this.KEY, JSON.stringify({ user, token }));
  }
  
  static clearSession(): void {
    if (typeof window === 'undefined') return;
    localStorage.removeItem(this.KEY);
  }
  
  static isAuthenticated(): boolean {
    return this.getSession() !== null;
  }
  
  static getUser(): Profile | null {
    return this.getSession()?.user ?? null;
  }
  
  static getRole(): UserRole | null {
    return this.getUser()?.role ?? null;
  }
}