// ZR App - Aplicación Estática
// Navegación entre pantallas - Funciona en cualquier navegador sin Docker

// Almacenar estado de usuario (localStorage para persistencia simple)
const ESTORAGE_KEY = 'zr-app-user';

function guardarUsuario(usuario) {
  try {
    localStorage.setItem(ESTORAGE_KEY, JSON.stringify(usuario));
  } catch (e) {
    console.log('localStorage no disponible');
  }
}

function obtenerUsuario() {
  try {
    const datos = localStorage.getItem(ESTORAGE_KEY);
    return datos ? JSON.parse(datos) : null;
  } catch (e) {
    return null;
  }
}

function limpiarUsuario() {
  try {
    localStorage.removeItem(ESTORAGE_KEY);
  } catch (e) {}
}

// Ocultar todas las pantallas
function ocultarTodasPantallas() {
  var pantallas = document.querySelectorAll('.pantalla');
  for (var i = 0; i < pantallas.length; i++) {
    pantallas[i].classList.add('oculto');
  }
}

// Mostrar una pantalla específica
function mostrarPantalla(idPantalla) {
  ocultarTodasPantallas();
  var pantalla = document.getElementById(idPantalla);
  if (pantalla) {
    pantalla.classList.remove('oculto');
    // Scroll al inicio
    window.scrollTo(0, 0);
  }
}

// Entrar como estudiante (login simulado)
function entrarComoEstudiante() {
  var usuario = {
    id: 'est-' + Date.now(),
    cedula: 'V-30000001',
    rol: 'estudiante',
    nombre: 'Juan Pérez',
    cohorte: '2A',
    modulo: 'Electricidad Automotriz'
  };
  guardarUsuario(usuario);
  mostrarPantalla('pantalla-carnet');
}

// Entrar como administrador
function entrarComoAdmin() {
  var usuario = {
    id: 'admin-' + Date.now(),
    rol: 'admin',
    nombre: 'Administrador'
  };
  guardarUsuario(usuario);
  mostrarPantalla('pantalla-panel');
}

// Entrar como profesor
function entrarComoProfesor() {
  var usuario = {
    id: 'prof-' + Date.now(),
    rol: 'profesor',
    nombre: 'Profesor Demo',
    cedula: 'V-10000001'
  };
  guardarUsuario(usuario);
  mostrarPantalla('pantalla-hoy');
}

// Volver al login
function volverLogin() {
  limpiarUsuario();
  mostrarPantalla('pantalla-login');
}

// Navegar entre las pantallas de estudiante
function irA(pantalla) {
  var idPantalla = 'pantalla-' + pantalla;
  mostrarPantalla(idPantalla);
  
  // Actualizar botones de navegación inferior
  var botones = document.querySelectorAll('.nav-btn');
  for (var i = 0; i < botones.length; i++) {
    botones[i].classList.remove('activo');
  }
  
  // Activar el botón correspondiente
  var secciones = ['carnet', 'semana', 'examenes', 'material'];
  for (var j = 0; j < secciones.length; j++) {
    if (secciones[j] === pantalla) {
      if (botones[j]) {
        botones[j].classList.add('activo');
      }
    }
  }
}

// Inicializar al cargar la página
window.addEventListener('DOMContentLoaded', function() {
  var usuario = obtenerUsuario();
  
  if (usuario) {
    if (usuario.rol === 'admin') {
      mostrarPantalla('pantalla-panel');
    } else if (usuario.rol === 'profesor') {
      mostrarPantalla('pantalla-hoy');
    } else {
      mostrarPantalla('pantalla-carnet');
    }
  } else {
    mostrarPantalla('pantalla-login');
  }
});